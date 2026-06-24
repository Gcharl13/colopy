// tabs/worldgen.js — Customize New World: a live map view whose terrain is driven
// by the four byte-verified Customize parameters (GAME.TXT @CLAND/@CCONT/@CTEMP/
// @CCLIM → DGROUP:0x1E7E). Change any dropdown (or the seed) and the world
// re-generates + re-composites through the SAME M3 sprite renderer. The pass
// STRUCTURE, terrain ids, climate tables and borders are byte-verified (B); the
// RNG and fill conditions are modeled (R) — a different continent per seed.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B, R } from '../provenance.js';
import { generate, CUSTOMIZE } from '../sim/mapgen.js';
import { compositeToCanvas } from '../sim/compose.js';
import { mapSheets, wireMapCanvas } from './map.js';

export async function render(host, ctx) {
  const { terr, phys } = await mapSheets(ctx);

  let map = null;
  const canvas = el('canvas', { class: 'map-canvas' });
  const inspector = el('div', { class: 'inspector' }, 'Click a tile to inspect its layer stack.');
  const { zoomSel, applyZoom } = wireMapCanvas(canvas, inspector, () => map);
  const info = el('div', { class: 'preview-out' });

  // One <select> per Customize variable, options = the exact in-game menu strings.
  const controls = {};
  for (const [name, def] of Object.entries(CUSTOMIZE)) {
    const sel = el('select', { class: 'picker' }, ...def.options.map((o, i) => el('option', { value: i }, o)));
    sel.value = '1';                       // default = Normal/Temperate
    sel.addEventListener('change', regen);
    controls[name] = sel;
  }
  const seed = el('input', { type: 'number', value: '12345', min: 1, class: 'num' });
  seed.addEventListener('input', regen);

  function regen() {
    map = generate({
      landMass: +controls.landMass.value, landForm: +controls.landForm.value,
      temperature: +controls.temperature.value, climate: +controls.climate.value,
      seed: +seed.value || 1,
    });
    map.generated = true;
    compositeToCanvas(canvas, map, terr, phys);
    applyZoom();
    info.innerHTML = '';
    info.append(
      el('div', {}, 'world: ', renderVal(B(`${map.width}×${map.height}`, 'random-map default 58×72 @0x75702 [B]')),
        el('span', { class: 'gap' }, 'land tiles: '),
        renderVal(R(`${map.landCount} / target ${map.target}`, 'target = (landMass+landForm+1)·0x140 @0x64AAD [target B; fill R]'))),
      el('div', {}, 'European starts: ',
        renderVal(R(map.starts.map((s) => `P${s.power}(${s.x},${s.y})`).join('  '), 'y=(H/5)·(p+1), x walked inland @0x65C9C [rule B]'))),
    );
  }

  const reseed = el('button', { class: 'btn' }, '🎲 random seed');
  reseed.addEventListener('click', () => { seed.value = String(1 + Math.floor(Math.random() * 2_000_000)); regen(); });

  // Build the labelled control row from the Customize defs (shows @C-key + title).
  const controlRow = el('div', { class: 'gen-controls' },
    ...Object.entries(CUSTOMIZE).map(([name, def]) =>
      el('label', { class: 'gen-ctl' },
        el('span', { class: 'gen-title' }, def.title),
        el('span', { class: 'gen-key' }, def.key),
        controls[name])),
    el('label', { class: 'gen-ctl' }, el('span', { class: 'gen-title' }, 'SEED'),
      el('span', { class: 'gen-key' }, 'RNG (modeled)'), el('div', { class: 'row' }, seed, reseed)));

  regen();   // initial world

  host.append(
    section('World Gen — Customize New World (live map view)',
      el('p', { class: 'hint' },
        'The four parameters below are the byte-verified Customize-New-World inputs (', el('code', {}, 'DGROUP:0x1E7E'),
        ', menu strings ', el('code', {}, '@CLAND/@CCONT/@CTEMP/@CCLIM'), '). Adjust any one and the world rebuilds via ',
        el('code', {}, 'func_064A10'), '’s passes, rendered by the same compositor as AMER2. Output terrain is ',
        el('b', {}, 'modeled (R)'), ' — the RNG isn’t byte-exact — but the structure, climate tables and borders are byte-verified.'),
      controlRow,
      info,
      el('div', { class: 'map-layout' },
        el('div', {}, el('div', { class: 'row' }, el('label', {}, 'zoom '), zoomSel),
          el('div', { class: 'map-scroll' }, canvas)),
        inspector)),
    paramHelp(),
  );
  fireRendered();
}

// What each variable does (with its byte anchor), so the inputs are self-documenting.
function paramHelp() {
  const rows = [
    ['LAND MASS (@CLAND)', 'Small / Normal / Large', 'land area — feeds the landmass target (landMass+landForm+1)·0x140 (@0x64AAD)'],
    ['LAND FORM (@CCONT)', 'Archipelago / Normal / Large Continents', 'coherence — many scattered blobs vs few big continents'],
    ['TEMPERATURE (@CTEMP)', 'Cool / Temperate / Warm', 'shifts the climate band (Cool → poleward tundra/marsh; Warm → equatorial savanna/grassland)'],
    ['CLIMATE (@CCLIM)', 'Arid / Normal / Wet', 'moisture — forest density + Marsh/Swamp (dry applies the −2 moisture step)'],
    ['SEED', 'any integer', 'the modeled RNG (DOS LCG not byte-pinned) — same params + seed reproduce the same world'],
  ];
  return section('What the inputs do',
    el('table', { class: 'data' },
      el('thead', {}, el('tr', {}, el('th', {}, 'variable'), el('th', {}, 'options'), el('th', {}, 'effect'))),
      el('tbody', {}, ...rows.map((r) => el('tr', {}, el('td', {}, r[0]), el('td', {}, r[1]), el('td', {}, r[2]))))));
}
