// tabs/map.js — Map (M3): the FULL sprite-composited render, not a colour grid.
// Each tile is TERRAIN.SS base ground + PHYS0.SS overlays, composited by the
// compositor ported 1:1 from viceroy_cpp/src/mapview.cpp and resolved through
// PHYS0's embedded palette (the game's active map palette, per main.cpp:225).
// Pixels are real sheet bytes [B]; layer order + sprite selection follow CLAUDE.md
// hard rules 3/4/5/7; edge/coast heuristics carry the reference renderer's tier.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B } from '../provenance.js';
import { loadSheet } from '../sim/sheet.js';
import { tileLayers, classifyVis } from '../sim/mapview.js';
import { compositeToCanvas } from '../sim/compose.js';

export const TERRAIN_NAME = [
  'Tundra', 'Desert', 'Plains', 'Prairie', 'Grassland', 'Savanna', 'Marsh', 'Swamp',
  ...Array(16).fill('Forest'),   // 8..23 auto-forest variants
  'Arctic', 'Ocean', 'Sea Lane', 'Mountains', 'Hills',
];

// Shared sheet load (TERRAIN + PHYS0 as indexed frames) — cached on ctx so the
// Map and World Gen tabs don't each re-decode the atlases.
export async function mapSheets(ctx) {
  return ctx._mapSheets ??= Promise.all([loadSheet('TERRAIN'), loadSheet('PHYS0')]).then(([terr, phys]) => ({ terr, phys }));
}

// Attach a zoom <select> + click-to-inspect to a canvas painting `getMap()`.
export function wireMapCanvas(canvas, inspector, getMap) {
  let zoom = 1;
  const applyZoom = () => { canvas.style.width = (canvas.width * zoom) + 'px'; canvas.style.height = (canvas.height * zoom) + 'px'; };
  const zoomSel = el('select', { class: 'picker' }, ...[0.5, 1, 2, 3].map((z) => el('option', { value: String(z) }, `${z}×`)));
  zoomSel.value = '1';
  zoomSel.addEventListener('change', () => { zoom = Number(zoomSel.value); applyZoom(); });
  canvas.addEventListener('click', (e) => {
    const m = getMap(); const r = canvas.getBoundingClientRect();
    const x = Math.floor((e.clientX - r.left) / r.width * m.width);
    const y = Math.floor((e.clientY - r.top) / r.height * m.height);
    if (x < 0 || y < 0 || x >= m.width || y >= m.height) return;
    showTile(inspector, m, x, y);
  });
  return { zoomSel, applyZoom };
}

export async function render(host, ctx) {
  const { terr, phys } = await mapSheets(ctx);
  const map = await ctx.mapData();           // AMER2

  const canvas = el('canvas', { class: 'map-canvas' });
  const inspector = el('div', { class: 'inspector' }, 'Click a tile to inspect its layer stack.');
  const { zoomSel, applyZoom } = wireMapCanvas(canvas, inspector, () => map);
  compositeToCanvas(canvas, map, terr, phys);
  applyZoom();

  host.append(
    section('Map — AMER2.MP, full sprite-composited render',
      el('p', { class: 'hint' },
        'Layered render of every tile: ', el('code', {}, 'TERRAIN.SS'), ' base ground + ',
        el('code', {}, 'PHYS0.SS'), ' overlays (biome edge-blend, forest canopy, river band, hills/mountains, ',
        'coast), composited by the port of ', el('code', {}, 'viceroy_cpp/src/mapview.cpp'),
        ' and resolved through PHYS0’s palette. Pixels are real sheet bytes [B].'),
      el('div', { class: 'row' },
        el('span', {}, 'size: '), renderVal(B(`${map.width}×${map.height}`, 'AMER2.MP header [B]')),
        el('span', { class: 'gap' }, 'sea-lane (right column): '),
        renderVal(B('id 26', 'CLAUDE.md hard rule 2 [B]')),
        el('span', { class: 'gap' }, 'palette: '),
        renderVal(B('PHYS0 embedded', 'active map palette, main.cpp:225 [B]')),
        el('label', { class: 'gap' }, 'zoom '), zoomSel),
      el('p', { class: 'hint' }, 'A randomly-generated world (same renderer) lives in the ', el('b', {}, 'World Gen'), ' tab.'),
      el('div', { class: 'map-layout' }, el('div', { class: 'map-scroll' }, canvas), inspector)),
  );
  fireRendered();
}

export function showTile(inspector, map, x, y) {
  const raw = map.tiles[y * map.width + x];
  const id = raw & 0x1f;
  const vis = classifyVis(raw);
  const { out } = tileLayers(map, x, y);

  const byteCite = map.generated ? 'generated tile byte (sim/mapgen.js) [R]' : 'AMER2.MP tile byte [B]';
  inspector.innerHTML = '';
  inspector.append(
    el('div', {}, el('strong', {}, `tile (${x}, ${y})`)),
    el('div', {}, 'raw byte: ', renderVal(B('0x' + raw.toString(16).padStart(2, '0'), byteCite))),
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
