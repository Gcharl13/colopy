// tabs/mechanics.js — Colony per-turn mechanics (M5, folds in the deferred M2).
// Three byte-verified simulators over the B terrain data: per-tile production
// (Tory penalty + expert + building gate + factory), the Sons-of-Liberty EMA, and
// food growth. Formulas cite their func/offset (B); only food per-capita stays R.
import { el, section, dataTable, fireRendered } from '../ui.js';
import { renderVal, B, R, A } from '../provenance.js';
import { rowsOf } from '../data/loaders.js';
import { tileYield, solCurve, solStep, turnsToGrow, GROWTH_STORE, MAX_POP } from '../sim/colony_turn.js';

// Terrain-yield columns → good index (market goods order).
const JOBS = [
  { col: 'y_farmer', good: 0, name: 'Farmer → Food' },
  { col: 'y_planter_sugar', good: 1, name: 'Planter → Sugar' },
  { col: 'y_planter_tobacco', good: 2, name: 'Planter → Tobacco' },
  { col: 'y_planter_cotton', good: 3, name: 'Planter → Cotton' },
  { col: 'y_trapper', good: 4, name: 'Trapper → Furs' },
  { col: 'y_lumberjack', good: 5, name: 'Lumberjack → Lumber' },
  { col: 'y_ore', good: 6, name: 'Miner → Ore' },
  { col: 'y_silver', good: 7, name: 'Miner → Silver' },
  { col: 'y_fisherman', good: 0, name: 'Fisherman → Food' },
];

const numInput = (v, attrs = {}) => el('input', { type: 'number', value: String(v), class: 'num', ...attrs });

export async function render(host, ctx) {
  const tables = await ctx.tablesData();
  const unforested = tables['@UNFORESTED'];

  host.append(
    productionSection(unforested),
    chainsSection(tables['@BUILDING']),
    solSection(),
    growthSection(),
    section('@UNFORESTED — terrain yields (B)',
      el('p', { class: 'hint' }, 'The base lookup table (NAMES.TXT) the production formula reads at @0x9C1E.'),
      dataTable(unforested.columns, rowsOf(unforested))),
  );
  fireRendered();
}

// --- per-tile production (compute_terrain_yield @0x9B9C) ------------------
function productionSection(unforested) {
  const rows = rowsOf(unforested);
  const out = el('div', { class: 'preview-out' });
  const terrainSel = el('select', { class: 'picker' }, ...rows.map((r, i) => el('option', { value: i }, r.name)));
  terrainSel.value = '4';   // Grassland-ish default
  const jobSel = el('select', { class: 'picker' }, ...JOBS.map((j, i) => el('option', { value: i }, j.name)));
  const pop = numInput(6, { min: 1, max: 32 });
  const sol = numInput(50, { min: 0, max: 100 });
  const diffSel = el('select', { class: 'picker' },
    ...['Discoverer', 'Explorer', 'Conquistador', 'Governor', 'Viceroy'].map((n, i) => el('option', { value: i }, `${i} ${n}`)));
  diffSel.value = '3';
  const expert = el('input', { type: 'checkbox' });

  const recompute = () => {
    out.innerHTML = '';
    const terrain = rows[Number(terrainSel.value)];
    const job = JOBS[Number(jobSel.value)];
    const base = Number(terrain[job.col]) || 0;
    const res = tileYield({
      base, good: job.good, pop: Number(pop.value) || 1, sol: Number(sol.value) || 0,
      difficulty: Number(diffSel.value), expertMatch: expert.checked,
      hasMfgBuilding: true, factory: false,
    });
    out.append(
      el('table', { class: 'data' },
        el('thead', {}, el('tr', {}, el('th', {}, 'step'), el('th', {}, 'Δ / value'), el('th', {}, 'tier'))),
        el('tbody', {}, ...res.steps.map((s) =>
          el('tr', {}, el('td', {}, s.label),
            el('td', {}, renderVal(s.tier === 'A' ? A(s.value, s.cite) : B(s.value, s.cite))),
            el('td', {}, s.tier))))),
      el('div', { class: 'big-summary' }, el('strong', {}, 'final yield/turn: '), renderVal(B(res.yield, 'max(yield,0) — compute_terrain_yield @0x9FFB'))),
      el('p', { class: 'hint' }, 'Manufactured goods (≥8) need their building (gate @0x9F4F) and double at factory tier (count_building_chain_present>2 @0x8EA9); set a terrain job above to see the raw path.'),
    );
  };
  for (const inp of [terrainSel, jobSel, pop, sol, diffSel]) inp.addEventListener('input', recompute);
  expert.addEventListener('change', recompute);
  setTimeout(recompute, 0);
  return section('Per-tile production (B — compute_terrain_yield @0x9B9C)',
    el('p', { class: 'hint' }, 'yield = terrain[good] − floor(toryCnt/(10−diff)) , then expert (+2 era / ×2 mfg), building gate, factory ×2.'),
    el('div', { class: 'row' },
      el('label', {}, 'terrain '), terrainSel, el('label', { class: 'gap' }, 'job '), jobSel,
      el('label', { class: 'gap' }, 'pop '), pop, el('label', { class: 'gap' }, 'SoL% '), sol,
      el('label', { class: 'gap' }, 'difficulty '), diffSel,
      el('label', { class: 'gap' }, expert, ' expert')),
    out);
}

// --- raw→finished production chains (@BUILDING House→Shop→Factory) --------
// The 5 manufacturing chains: each finished good has a 3-link building chain;
// the 3rd link (Factory) is the count_building_chain_present>2 factory tier (×2).
const CHAINS = [
  { raw: 'Sugar', finished: 'Rum', links: ['Rum Distiller\'s House', 'Rum Distillery', 'Rum Factory'] },
  { raw: 'Tobacco', finished: 'Cigars', links: ['Tobacconist\'s House', 'Tobacconist\'s Shop', 'Cigar Factory'] },
  { raw: 'Cotton', finished: 'Cloth', links: ['Weaver\'s House', 'Weaver\'s Shop', 'Textile Mill'] },
  { raw: 'Furs', finished: 'Coats', links: ['Fur Trader\'s House', 'Fur Trading Post', 'Fur Factory'] },
  { raw: 'Ore', finished: 'Tools', links: ['Blacksmith\'s House', 'Blacksmith\'s Shop', 'Iron Works'] },
];
function chainsSection(building) {
  const present = new Set(rowsOf(building).map((r) => r.name));
  const rows = CHAINS.map((c) => ({
    chain: `${c.raw} → ${c.finished}`,
    house: c.links[0], shop: c.links[1], factory: c.links[2],
    inData: c.links.filter((l) => present.has(l)).length,
  }));
  return section('Raw → finished production chains (B chains; R ratio)',
    el('p', { class: 'hint' },
      'Each finished good is made from its raw input through a 3-link building chain (', el('code', {}, 'House → Shop → Factory'),
      '). The 3rd link is the factory tier (', el('code', {}, 'count_building_chain_present>2'), ' @0x8EA9) that doubles output. ',
      'The chains and buildings are byte-verified (@BUILDING); the exact raw:finished conversion RATIO is not decompiled — ',
      'modeled here as 1:1 per worker (', el('b', {}, 'R'), ').'),
    el('table', { class: 'data' },
      el('thead', {}, el('tr', {}, ...['chain', 'House (tier 1)', 'Shop (tier 2)', 'Factory (×2)', 'ratio'].map((c) => el('th', {}, c)))),
      el('tbody', {}, ...rows.map((r) => el('tr', {},
        el('td', {}, renderVal(B(r.chain, '@BUILDING chain (NAMES.TXT) [B]'))),
        el('td', {}, r.house), el('td', {}, r.shop),
        el('td', {}, present.has(r.factory) ? r.factory : el('span', { class: 'tier-tbd' }, `${r.factory}?`)),
        el('td', {}, renderVal(R('1:1', 'MODELED: per-worker conversion ratio (not decompiled)'))))))));
}

// --- Sons-of-Liberty EMA (func_02D658 @0x2DA1C) --------------------------
function solSection() {
  const out = el('div', { class: 'preview-out' });
  const bells = numInput(8, { min: 0, max: 100 });
  const pop = numInput(6, { min: 1, max: 32 });
  const recompute = () => {
    out.innerHTML = '';
    const bl = Number(bells.value) || 0, pp = Number(pop.value) || 1;
    const { curve, steady, final } = solCurve(bl, pp, 80);
    // sparkline-ish: show a few sampled turns
    const samples = [1, 5, 10, 20, 40, 80].map((t) => ({ turn: t, sol: curve[t - 1] }));
    out.append(
      dataTable(['turn', 'sol'], samples, (c, r) => c === 'sol' ? renderVal(B(r.sol + '%', 'EMA step — func_02D658 @0x2DA1C')) : String(r.turn)),
      el('div', { class: 'big-summary' },
        el('span', {}, 'after 80 turns: '), renderVal(B(final + '%', 'simulated EMA')),
        el('span', { class: 'gap' }, 'analytic steady state ≈ '), renderVal(A(steady + '%', 'derived: sol → min(100, 50·bells/pop) (colony.md §3)'))),
      el('p', { class: 'hint' }, 'Both rebel-dividend (+0xC2) and divisor (+0xC6) are 1/64-decay EMAs (B += 2·pop, A += bells). Reaches 100% when bells ≥ 2·pop. WoI halving and the <pop downward pressure are omitted here (noted TBD).'),
    );
  };
  bells.addEventListener('input', recompute);
  pop.addEventListener('input', recompute);
  setTimeout(recompute, 0);
  return section('Sons of Liberty % (B — EMA, decay 1/64)',
    el('p', { class: 'hint' }, 'sol = 100·A/B, where each turn: ', el('code', {}, 'B −= B/64; B += 2·pop;  A += bells − A/64; A = clamp(A,0,B)'), '.'),
    el('div', { class: 'row' }, el('label', {}, 'bells/turn '), bells, el('label', { class: 'gap' }, 'population '), pop),
    out);
}

// --- food growth (+200 store, pop<32) ------------------------------------
function growthSection() {
  const out = el('div', { class: 'preview-out' });
  const food = numInput(4, { min: -10, max: 50 });
  const pop = numInput(3, { min: 1, max: 32 });
  const perCapita = R(2, 'MODELED: food per colonist/turn = 2 (user-confirmed; byte-loc TBD)', { id: 'food.per_capita', unit: 'food/colonist' });
  const recompute = () => {
    out.innerHTML = '';
    const produced = Number(food.value) || 0, pp = Number(pop.value) || 1;
    const pc = perCapita.value;
    const consumed = pp * pc;
    const net = produced - consumed;
    const turns = turnsToGrow(net);
    out.append(
      el('div', {}, 'food produced/turn: ', renderVal(B(produced, 'user input (terrain × farmers)'))),
      el('div', {}, 'food consumed = pop × ', renderVal(perCapita), ': ', renderVal(R(consumed, 'MODELED: pop × per-capita'))),
      el('div', {}, 'net food/turn: ', renderVal(R(net, 'produced − consumed'))),
      el('div', {}, 'growth store / colonist born at: ', renderVal(B(GROWTH_STORE, 'func_02D658 @0x2E098 — +200 store')), ' (max pop ', renderVal(B(MAX_POP, 'population < 0x20 @0x009432')), ')'),
      el('div', { class: 'big-summary' }, el('strong', {}, 'turns to next colonist: '),
        renderVal(net > 0 ? R(turns, 'ceil(200/net) [growth store B; per-capita R]') : R('never (net ≤ 0)', 'starving/stagnant'))),
      el('p', { class: 'hint' }, 'Food per-capita (2) is the one modeled input — edit it and the whole chain updates. Starvation rule itself is TBD.'),
    );
  };
  food.addEventListener('input', recompute);
  pop.addEventListener('input', recompute);
  window.addEventListener('lab:override', recompute);
  setTimeout(recompute, 0);
  return section('Food & population growth (B store; R consumption)',
    el('div', { class: 'row' }, el('label', {}, 'food produced/turn '), food, el('label', { class: 'gap' }, 'population '), pop),
    out);
}
