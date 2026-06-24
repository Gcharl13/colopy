// tabs/market.js — European market (M4). The price model from spec/systems/market.md:
// per-turn drift, supply build, luxury shared-pool coupling, and buy/sell. Every
// FORMULA cites its byte-verified offset (B); the scenario inputs you type (price
// seed, per-player trade accumulators, King's tax %, quantities) are runtime state,
// modeled here (R) so you can watch the byte-true math respond.
import { el, section, dataTable, fireRendered } from '../ui.js';
import { renderVal, B, R } from '../provenance.js';
import { rowsOf } from '../data/loaders.js';
import { GOODS, FINISHED, RAW_INPUT, driftStep, supplyOf, luxuryTargets, sell, buy,
  isBoycotted, setBoycott, clearBoycott, JAKOB_FUGGER_CLEAR, backTaxToLift } from '../sim/market.js';

const numInput = (v, attrs = {}) => el('input', { type: 'number', value: String(v), class: 'num', ...attrs });

// Shared boycott bitmask (PowerRecord +0x20) for this tab session — modeled state.
let boycottMask = 0;
const boycottListeners = new Set();
function setMask(m) { boycottMask = m & 0xFFFF; for (const fn of boycottListeners) fn(); }

export async function render(host, ctx) {
  const tables = await ctx.tablesData();
  const cargo = tables['@CARGO'];
  boycottMask = 0;

  host.append(
    driftSection(),
    luxurySection(),
    boycottSection(cargo),
    tradeSection(cargo),
    section('@CARGO — goods & price params (B)',
      el('p', { class: 'hint' }, 'Base buy/sell prices, drift band [drift_low, drift_high], rise/fall, attrition (recovery), volatility — all from NAMES.TXT.'),
      dataTable(cargo.columns, rowsOf(cargo))),
  );
  fireRendered();
}

// --- per-turn price drift (func_0305A8 @0x30618) -------------------------
function driftSection() {
  const out = el('div', { class: 'preview-out' });
  const goodSel = el('select', { class: 'picker' }, ...GOODS.map((g, i) => el('option', { value: i }, `${i} ${g}`)));
  goodSel.value = '9';
  const seed = numInput(800, { min: 0, max: 5000 });
  const accs = [0, 1, 2, 3].map((p) => numInput(p === 0 ? 400 : 0));
  const recompute = () => {
    out.innerHTML = '';
    const base = Number(seed.value) || 0;
    const a = accs.map((x) => Number(x.value) || 0);
    const { next, decay, totalTrade } = driftStep(base, a);
    out.append(
      el('div', {}, 'Σ clamped trade (4 players): ', renderVal(R(totalTrade, 'Σ max(accum,0) — @0x305E0..0x305F0 [formula B]'))),
      el('div', {}, 'base + Σtrade: ', renderVal(R(base + totalTrade, 'pre-shift total'))),
      el('div', {}, 'decay = (base + Σtrade) ≫ 8: ', renderVal(R(decay, 'func_0305A8 @0x30618 — /256 [formula B]'))),
      el('div', {}, 'next price base: ', renderVal(R(next, 'base − decay [formula B]')), ' (was ', String(base), ')'),
      el('div', { class: 'hint' }, 'Heavy selling grows the per-good accumulator (+0xFC), so the European base relaxes downward harder. Formula byte-verified at func_0305A8 @0x30618.'),
    );
  };
  for (const inp of [goodSel, seed, ...accs]) inp.addEventListener('input', recompute);
  setTimeout(recompute, 0);
  return section('Per-turn price drift (B formula, modeled state)',
    el('p', { class: 'hint' }, 'func_0305A8: ', el('code', {}, 'base[g] −= (base[g] + Σ_players max(trade_accum[p][g],0)) / 256'),
      '. price seed is random [600,1000] per game (func_07561C @0x75645); accumulators are runtime — edit them.'),
    el('div', { class: 'row' }, el('label', {}, 'good '), goodSel,
      el('label', { class: 'gap' }, 'price seed '), seed),
    el('div', { class: 'row' }, el('label', {}, 'trade accum / player '), ...accs.map((a, i) => el('span', { class: 'gap' }, `P${i} `, a))),
    out);
}

// --- luxury shared-pool coupling (@0x030649 / @0x030745) ------------------
function luxurySection() {
  const out = el('div', { class: 'preview-out' });
  // one supply input per finished + raw-input good
  const idx = [...RAW_INPUT, ...FINISHED];
  const inputs = {};
  for (const i of idx) inputs[i] = numInput(i === 9 ? 300 : 200, { min: 1 });
  const yearInp = numInput(1600, { min: 1492, max: 1800 });
  const recompute = () => {
    out.innerHTML = '';
    const supply = new Array(16).fill(0);
    for (const i of idx) supply[i] = Number(inputs[i].value) || 1;
    const { sPair, targets } = luxuryTargets(supply, Number(yearInp.value) || 1600);
    const rows = idx.map((i) => ({ good: `${i} ${GOODS[i]}`, supply: supply[i],
      kind: FINISHED.includes(i) ? 'finished' : 'raw input', target: targets[i] }));
    out.append(
      el('div', {}, 'S_pair = Σ supply[Rum,Cigars,Cloth,Coats] (clamp ≥1): ', renderVal(R(sPair, '@0x030649 — pooled luxury supply [formula B]'))),
      dataTable(['good', 'kind', 'supply', 'target'], rows, (c, r) =>
        c === 'target' ? renderVal(R(r.target, 'target = (S_pair·3)/supply[i] — @0x030745 [formula B]')) : String(r[c])),
      el('p', { class: 'hint' }, 'Dumping one luxury lowers its own price and nudges the other three UP: it grows the shared numerator S_pair while only its own denominator rises. Furs(4) supply is halved (+1 if year<1700, +1 if <1600).'),
    );
  };
  for (const i of idx) inputs[i].addEventListener('input', recompute);
  yearInp.addEventListener('input', recompute);
  setTimeout(recompute, 0);
  return section('Luxury shared-pool price coupling (B formula, modeled supply)',
    el('p', { class: 'hint' }, 'The four finished luxuries (Rum/Cigars/Cloth/Coats) and their raw inputs (Sugar/Tobacco/Cotton/Furs) price off one shared pool: ',
      el('code', {}, 'target[i] = (3 · ΣsupplyLux) / supply[i]'), '.'),
    el('div', { class: 'row' }, el('label', {}, 'year '), yearInp,
      ...idx.map((i) => el('span', { class: 'gap' }, `${GOODS[i]} `, inputs[i]))),
    out);
}

// --- boycotts (PowerRecord +0x20 bitmask; spec/systems/boycotts.md) -------
function boycottSection(cargo) {
  const rows = rowsOf(cargo);
  const chips = el('div', { class: 'boycott-chips' });
  const maskOut = el('span', {});
  const render = () => {
    chips.innerHTML = '';
    for (let g = 0; g < GOODS.length; g++) {
      const on = isBoycotted(boycottMask, g);
      const chip = el('button', { class: 'chip' + (on ? ' on' : '') }, GOODS[g]);
      chip.addEventListener('click', () => setMask(on ? clearBoycott(boycottMask, g) : setBoycott(boycottMask, g)));
      chips.append(chip);
    }
    maskOut.textContent = '';
    maskOut.append(renderVal(R('0x' + boycottMask.toString(16).padStart(4, '0'),
      'boycott bitmask PowerRecord +0x20 [field B; live state R]')));
  };
  boycottListeners.add(render);
  setTimeout(render, 0);
  const fugger = el('button', { class: 'btn' }, 'Jakob Fugger — clear all');
  fugger.addEventListener('click', () => setMask(JAKOB_FUGGER_CLEAR));
  return section('Boycotts (B — PowerRecord +0x20 bitmask)',
    el('p', { class: 'hint' }, 'A refused tax raise ⇒ Tea Party ⇒ the disputed good is boycotted (bit set ',
      el('code', {}, 'mask |= 1<<good'), ' @0x34717). A boycotted good cannot be traded in Europe until the ',
      'back-tax (price×500) is paid (treasury +0x2A → King +0x22, @0x3340C) or Jakob Fugger clears all (@0x3BD45).'),
    el('div', { class: 'row' }, el('span', {}, 'Click a good to toggle its boycott:')),
    chips,
    el('div', { class: 'row' }, el('span', {}, 'mask: '), maskOut, el('span', { class: 'gap' }), fugger));
}

// --- buy/sell transaction (SELL func@0x32914; BUY page-13) ----------------
function tradeSection(cargo) {
  const rows = rowsOf(cargo);
  const out = el('div', { class: 'preview-out' });
  const goodSel = el('select', { class: 'picker' }, ...GOODS.map((g, i) => el('option', { value: i }, `${i} ${g}`)));
  goodSel.value = '2';
  const qty = numInput(100, { min: 1, max: 1000 });
  const king = numInput(15, { min: 0, max: 75 });
  const gold = numInput(1000, { min: 0 });
  const recompute = () => {
    out.innerHTML = '';
    const gi = Number(goodSel.value);
    const row = rows[gi] || {};
    const price = Number(row.price_start2 ?? row.price_start1 ?? 1);   // sell (ask) price
    const buyPrice = Number(row.price_start1 ?? price);
    const q = Number(qty.value) || 0, k = Number(king.value) || 0, g0 = Number(gold.value) || 0;
    // Boycott gate: the good is tested BEFORE the tax math (@0x415A6) — if boycotted,
    // trading is blocked until the back-tax (price×500) is paid.
    if (isBoycotted(boycottMask, gi)) {
      const bt = backTaxToLift(price, g0);
      out.append(
        el('div', { class: 'tier-tbd' }, el('strong', {}, `${GOODS[gi]} is BOYCOTTED`), ' — cannot buy or sell in Europe.'),
        el('div', {}, 'back-tax to lift = price × 500: ', renderVal(R(bt.owed, 'func_03334E @0x333AF — price×500 [formula B]'))),
        el('div', {}, 'affordable from gold ', String(g0), '? ', renderVal(R(bt.affordable ? 'yes' : 'no', 'gold check @0x333DD [B]')),
          ' → pays treasury +0x2A, credits King +0x22'),
        el('p', { class: 'hint' }, 'Toggle the boycott off above (or Jakob Fugger) to trade again.'),
      );
      return;
    }
    const s = sell(price, q, k, g0);
    const b = buy(buyPrice, q, g0);
    out.append(
      el('div', {}, el('strong', {}, 'SELL'), ' at ', renderVal(B(price, `@CARGO ${GOODS[gi]} price_start2 [B]`)), '/unit × ', String(q)),
      el('div', {}, '  gross = price·qty: ', renderVal(R(s.gross, 'func@0x32914 step 1 [formula B]'))),
      el('div', {}, '  King tax (', String(k), '%): ', renderVal(R(s.tax, 'tax = gross·king%/100 — @0x32a4a → REF +0x22 [formula B]'))),
      el('div', {}, '  net = gross − tax: ', renderVal(R(s.net, 'net credited to gold [formula B]'))),
      el('div', {}, '  gold ', String(g0), ' → ', renderVal(R(s.newGold, 'gold += net, clamp [0,999999] — func@0x8806 @0x32a82 [formula B]'))),
      el('div', { class: 'gap' }, el('strong', {}, 'BUY'), ' at ', renderVal(B(buyPrice, `@CARGO ${GOODS[gi]} price_start1 [B]`)), '/unit × ', String(q), ' (untaxed)'),
      el('div', {}, '  cost = price·qty: ', renderVal(R(b.cost, 'page-13 inline debit, no tax [formula B]'))),
      el('div', {}, '  gold ', String(g0), ' → ', renderVal(R(b.newGold, 'gold −= cost [formula B]')),
        b.affordable ? '' : el('span', { class: 'tier-tbd' }, '  (insufficient gold)')),
      el('p', { class: 'hint' }, 'Sales are taxed (proceeds feed the King’s REF fund +0x22); purchases are untaxed. Gold clamps to [0, 999999].'),
    );
  };
  for (const inp of [goodSel, qty, king, gold]) inp.addEventListener('input', recompute);
  boycottListeners.add(recompute);     // re-evaluate the boycott gate live
  setTimeout(recompute, 0);
  return section('Buy / sell transaction (B formula, modeled qty & tax)',
    el('p', { class: 'hint' }, 'SELL func@0x32914: gross → King tax → net → gold. BUY (page-13): inline gold debit, untaxed.'),
    el('div', { class: 'row' }, el('label', {}, 'good '), goodSel,
      el('label', { class: 'gap' }, 'qty '), qty,
      el('label', { class: 'gap' }, 'King tax % '), king,
      el('label', { class: 'gap' }, 'gold '), gold),
    out);
}
