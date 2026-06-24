// tabs/map.js — Map (M3): the FULL sprite-composited render, not a colour grid.
// Each tile is TERRAIN.SS base ground + PHYS0.SS overlays, composited by the
// compositor ported 1:1 from viceroy_cpp/src/mapview.cpp and resolved through
// PHYS0's embedded palette (the game's active map palette, per main.cpp:225).
// Pixels are real sheet bytes [B]; layer order + sprite selection follow CLAUDE.md
// hard rules 3/4/5/7; edge/coast heuristics carry the reference renderer's tier.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B, R } from '../provenance.js';
import { loadSheet } from '../sim/sheet.js';
import { Surface } from '../sim/surface.js';
import { renderMapRegion, tileLayers, classifyVis } from '../sim/mapview.js';
import { generate } from '../sim/mapgen.js';

const TERRAIN_NAME = [
  'Tundra', 'Desert', 'Plains', 'Prairie', 'Grassland', 'Savanna', 'Marsh', 'Swamp',
  ...Array(16).fill('Forest'),   // 8..23 auto-forest variants
  'Arctic', 'Ocean', 'Sea Lane', 'Mountains', 'Hills',
];

export async function render(host, ctx) {
  // Load the two map sheets as INDEXED frames (the same bytes the C++ reads).
  const [terr, phys] = await Promise.all([loadSheet('TERRAIN'), loadSheet('PHYS0')]);

  let map = await ctx.mapData();           // current map (AMER2 by default)
  let zoom = 1;

  const canvas = el('canvas', { class: 'map-canvas' });
  const inspector = el('div', { class: 'inspector' }, 'Click a tile to inspect its layer stack.');
  const sizeOut = el('span', {});

  // Composite `map` onto a fresh surface and paint the canvas (the M3 pipeline).
  function paint() {
    const surf = new Surface(map.width * 16, map.height * 16, 0);
    renderMapRegion(surf, terr, phys, map, 0, 0, map.width, map.height);
    canvas.width = surf.w; canvas.height = surf.h;
    canvas.getContext('2d').putImageData(surf.toImageData(phys.pal), 0, 0);
    applyZoom();
    sizeOut.textContent = '';
    sizeOut.append(renderVal(B(`${map.width}×${map.height}`, map.generated ? 'random-map default 58×72 @0x75702 [B]' : 'AMER2.MP header [B]')));
  }
  const applyZoom = () => { canvas.style.width = (canvas.width * zoom) + 'px'; canvas.style.height = (canvas.height * zoom) + 'px'; };

  const zoomSel = el('select', { class: 'picker' }, ...[0.5, 1, 2, 3].map((z) => el('option', { value: String(z) }, `${z}×`)));
  zoomSel.value = '1';
  zoomSel.addEventListener('change', () => { zoom = Number(zoomSel.value); applyZoom(); });

  canvas.addEventListener('click', (e) => {
    const r = canvas.getBoundingClientRect();
    const x = Math.floor((e.clientX - r.left) / r.width * map.width);
    const y = Math.floor((e.clientY - r.top) / r.height * map.height);
    if (x < 0 || y < 0 || x >= map.width || y >= map.height) return;
    showTile(inspector, map, x, y);
  });

  const setMap = (m) => { map = m; paint(); };
  paint();

  host.append(
    section('Map — full sprite-composited render',
      el('p', { class: 'hint' },
        'Layered render of every tile: ', el('code', {}, 'TERRAIN.SS'), ' base ground + ',
        el('code', {}, 'PHYS0.SS'), ' overlays (biome edge-blend, forest canopy, river band, hills/mountains, ',
        'coast), composited by the port of ', el('code', {}, 'viceroy_cpp/src/mapview.cpp'),
        ' and resolved through PHYS0’s palette. Pixels are real sheet bytes [B].'),
      el('div', { class: 'row' },
        el('span', {}, 'size: '), sizeOut,
        el('span', { class: 'gap' }, 'sea-lane (right column): '),
        renderVal(B('id 26', 'CLAUDE.md hard rule 2 [B]')),
        el('span', { class: 'gap' }, 'palette: '),
        renderVal(B('PHYS0 embedded', 'active map palette, main.cpp:225 [B]')),
        el('label', { class: 'gap' }, 'zoom '), zoomSel),
      el('div', { class: 'map-layout' }, el('div', { class: 'map-scroll' }, canvas), inspector)),
    generatorSection(setMap, () => ctx.mapData().then(setMap)),
  );
  fireRendered();
}

// --- Customize New World generator (sim/mapgen.js — func_064A10 passes) ----
function generatorSection(setMap, loadAmer2) {
  const num = (v, a = {}) => el('input', { type: 'number', value: String(v), class: 'num', ...a });
  const p1 = num(2, { min: 0, max: 4 }), p2 = num(1, { min: 0, max: 4 });
  const climate = num(0, { min: -2, max: 2 }), moisture = num(1, { min: 0, max: 2 });
  const seed = num(12345, { min: 1 });
  const info = el('div', { class: 'preview-out' });

  const regen = () => {
    const m = generate({
      p1: +p1.value, p2: +p2.value, climateShift: +climate.value, moisture: +moisture.value, seed: +seed.value,
    });
    m.generated = true;
    setMap(m);
    info.innerHTML = '';
    info.append(
      el('div', {}, 'land tiles: ', renderVal(R(`${m.landCount} / target ${m.target}`, 'target = (p1+p2+1)·0x140 @0x64AAD [target B; fill modeled]'))),
      el('div', {}, 'European starts: ', renderVal(R(m.starts.map((s) => `P${s.power}(${s.x},${s.y})`).join('  '), 'y=(H/5)·(p+1), x walked inland @0x65C9C [rule B]'))),
      el('p', { class: 'hint' }, 'Click “random seed” for a new continent, then click tiles above to inspect the generated terrain.'),
    );
  };
  const go = el('button', { class: 'btn primary' }, 'Generate');
  go.addEventListener('click', regen);
  const reseed = el('button', { class: 'btn' }, 'Random seed');
  reseed.addEventListener('click', () => { seed.value = String(1 + Math.floor(Math.random() * 2_000_000)); regen(); });
  const back = el('button', { class: 'btn' }, 'Back to AMER2.MP');
  back.addEventListener('click', () => { loadAmer2(); });

  return section('Customize New World — modeled generator (R)',
    el('p', { class: 'hint' },
      'Follows ', el('code', {}, 'func_064A10'), '’s passes P0–P6 (ocean fill → landmass blob-growth → ',
      'climate bands ', el('code', {}, '{5,4,1,3,2,2}'), 'N / ', el('code', {}, '{2,3,3,4,6,7}'), 'S → ',
      'forest/smoothing → rivers → sea-lane + Arctic borders → 4 European starts). The pass STRUCTURE, terrain ids, ',
      'climate tables, landmass target and border rules are byte-verified; the RNG and fill conditions are ',
      el('b', {}, 'modeled (R)'), ' — a different continent per seed, not a byte-exact DOS map.'),
    el('div', { class: 'row' },
      el('label', {}, 'land p1 '), p1, el('label', { class: 'gap' }, 'land p2 '), p2,
      el('label', { class: 'gap' }, 'climate '), climate, el('label', { class: 'gap' }, 'moisture '), moisture,
      el('label', { class: 'gap' }, 'seed '), seed),
    el('div', { class: 'row' }, go, reseed, back),
    info);
}

function showTile(inspector, map, x, y) {
  const raw = map.tiles[y * map.width + x];
  const id = raw & 0x1f;
  const vis = classifyVis(raw);
  const { out } = tileLayers(map, x, y);

  inspector.innerHTML = '';
  inspector.append(
    el('div', {}, el('strong', {}, `tile (${x}, ${y})`)),
    el('div', {}, 'raw byte: ', renderVal(B('0x' + raw.toString(16).padStart(2, '0'), 'AMER2.MP tile byte [B]'))),
    el('div', {}, 'terrain id: ', renderVal(B(id, 'raw & 0x1F (func_006204 @0x6204) [B]')),
      ' = ', renderVal(B(TERRAIN_NAME[id] || `id ${id}`, 'formats/MP_FORMAT.md [B]'))),
    el('div', {}, 'classified vis: ', renderVal(B('0x' + vis.toString(16), 'classify_vis (func_006204) [B]'))),
    // Bit semantics per the byte-faithful compositor (mapview.cpp) — NOT the old
    // M0 reading. Forest is the id BAND 8..23 (hard rule 3), not a bit.
    el('div', {}, 'hills/mtn bit (0x20): ', renderVal(B(!!(raw & 0x20), 'mapview.cpp: 0x20=hills/mountains [B]'))),
    el('div', {}, 'river bit (0x40): ', renderVal(B(!!(raw & 0x40), 'mapview.cpp: 0x40=river [B]'))),
    el('div', {}, 'mountain bit (0x80): ', renderVal(B(!!(raw & 0x80), 'mapview.cpp: 0x80=mountain (vs hill) [B]'))),
    el('div', {}, 'forest (band 8..23): ', renderVal(B(id >= 8 && id <= 23, 'CLAUDE.md hard rule 3 [B]'))),
    el('h3', {}, 'layer stack'),
    el('table', { class: 'data' },
      el('thead', {}, el('tr', {}, el('th', {}, 'layer'), el('th', {}, 'sheet'), el('th', {}, 'frame'))),
      el('tbody', {}, ...out.map((L) => el('tr', {},
        el('td', {}, L.layer), el('td', {}, L.sheet), el('td', {}, String(L.frame)))))),
  );
}
