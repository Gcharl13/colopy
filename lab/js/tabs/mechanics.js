// tabs/mechanics.js — Mechanics (M0 thin: show the B data tables + a tiny
// single-colony production preview that exercises the provenance path, including
// one MODELED input (food consumption pop×2) badged R + editable).
import { el, section, dataTable, fireRendered } from '../ui.js';
import { renderVal, B, R } from '../provenance.js';
import { rowsOf } from '../data/loaders.js';
import { colonyPreview } from '../sim/colony.js';

export async function render(host, ctx) {
  const tables = await ctx.tablesData();
  const cargo = tables['@CARGO'];
  const unforested = tables['@UNFORESTED'];

  host.append(
    section('Single-colony preview (Phase A — M0 stub)',
      el('p', { class: 'hint' },
        'A first taste of the flow path with provenance. Yields are byte-verified (B); ',
        'food consumption (pop×2) is ', el('b', {}, 'modeled (R)'), ' — edit it to see the effect. ',
        'Full per-turn sim lands in M2.'),
      previewBlock(unforested)),
    section('@CARGO — goods & price model (B)',
      el('p', { class: 'hint' }, 'Base price / drift / burden from NAMES.TXT. The price-movement sim (drift /256, buy/sell, luxury pool) arrives in M4.'),
      dataTable(cargo.columns, rowsOf(cargo))),
    section('@UNFORESTED — terrain yields (B)',
      dataTable(unforested.columns, rowsOf(unforested))),
  );
  fireRendered();
}

function previewBlock(unforested) {
  const rows = rowsOf(unforested);
  const out = el('div', { class: 'preview-out' });
  const terrainSel = el('select', {}, ...rows.map((r, i) => el('option', { value: i }, r.name)));
  const popInput = el('input', { type: 'number', value: '3', min: '1', max: '32', class: 'num' });
  const recompute = () => {
    out.innerHTML = '';
    const terrain = rows[Number(terrainSel.value)];
    const pop = Number(popInput.value) || 1;
    const res = colonyPreview(terrain, pop);
    out.append(
      el('div', {}, 'Farmer food yield/tile: ', renderVal(res.foodYield)),
      el('div', {}, 'Colonists: ', renderVal(res.pop)),
      el('div', {}, 'Food consumed (', renderVal(res.consumption), '): ',
        el('span', {}, '= pop × '), renderVal(res.perCapita)),
      el('div', {}, 'Net food (1 farmer on this tile): ', renderVal(res.net)),
      el('div', { class: 'hint' }, 'Growth at +200 stored food (B); starvation rule is TBD.'),
    );
  };
  terrainSel.addEventListener('change', recompute);
  popInput.addEventListener('input', recompute);
  window.addEventListener('lab:override', recompute);
  const block = el('div', { class: 'preview' },
    el('div', { class: 'row' }, el('label', {}, 'Tile terrain: '), terrainSel,
      el('label', { class: 'gap' }, 'Population: '), popInput),
    out);
  setTimeout(recompute, 0);
  return block;
}
