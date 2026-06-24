// tabs/map.js — Map (M3): the FULL sprite-composited render, not a colour grid.
// Each tile is TERRAIN.SS base ground + PHYS0.SS overlays, composited by the
// compositor ported 1:1 from viceroy_cpp/src/mapview.cpp and resolved through
// PHYS0's embedded palette (the game's active map palette, per main.cpp:225).
// Pixels are real sheet bytes [B]; layer order + sprite selection follow CLAUDE.md
// hard rules 3/4/5/7; edge/coast heuristics carry the reference renderer's tier.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B } from '../provenance.js';
import { loadSheet } from '../sim/sheet.js';
import { Surface } from '../sim/surface.js';
import { renderMapRegion, tileLayers, classifyVis } from '../sim/mapview.js';

const TERRAIN_NAME = [
  'Tundra', 'Desert', 'Plains', 'Prairie', 'Grassland', 'Savanna', 'Marsh', 'Swamp',
  ...Array(16).fill('Forest'),   // 8..23 auto-forest variants
  'Arctic', 'Ocean', 'Sea Lane', 'Mountains', 'Hills',
];

export async function render(host, ctx) {
  const map = await ctx.mapData();
  const W = map.width, H = map.height;

  // Load the two map sheets as INDEXED frames (the same bytes the C++ reads).
  const [terr, phys] = await Promise.all([loadSheet('TERRAIN'), loadSheet('PHYS0')]);

  // Composite the WHOLE map onto an indexed surface, then resolve via PHYS0 pal.
  const surf = new Surface(W * 16, H * 16, 0);
  renderMapRegion(surf, terr, phys, map, 0, 0, W, H);
  const imageData = surf.toImageData(phys.pal);

  // Natural-size offscreen → on-screen canvas (CSS-scaled, pixelated).
  const canvas = el('canvas', { class: 'map-canvas', width: surf.w, height: surf.h });
  canvas.getContext('2d').putImageData(imageData, 0, 0);

  let zoom = 1;
  const applyZoom = () => { canvas.style.width = (surf.w * zoom) + 'px'; canvas.style.height = (surf.h * zoom) + 'px'; };
  applyZoom();
  const zoomSel = el('select', { class: 'picker' }, ...[0.5, 1, 2, 3].map((z) =>
    el('option', { value: String(z) }, `${z}×`)));
  zoomSel.value = '1';
  zoomSel.addEventListener('change', () => { zoom = Number(zoomSel.value); applyZoom(); });

  const inspector = el('div', { class: 'inspector' }, 'Click a tile to inspect its layer stack.');
  canvas.addEventListener('click', (e) => {
    const r = canvas.getBoundingClientRect();
    const x = Math.floor((e.clientX - r.left) / r.width * W);
    const y = Math.floor((e.clientY - r.top) / r.height * H);
    if (x < 0 || y < 0 || x >= W || y >= H) return;
    showTile(inspector, map, x, y);
  });

  const scroll = el('div', { class: 'map-scroll' }, canvas);

  host.append(
    section('Map — AMER2.MP, full sprite-composited render',
      el('p', { class: 'hint' },
        'Layered render of every tile: ', el('code', {}, 'TERRAIN.SS'), ' base ground + ',
        el('code', {}, 'PHYS0.SS'), ' overlays (biome edge-blend, forest canopy, river band, hills/mountains, ',
        'coast), composited by the port of ', el('code', {}, 'viceroy_cpp/src/mapview.cpp'),
        ' and resolved through PHYS0’s palette. Pixels are real sheet bytes [B].'),
      el('div', { class: 'row' },
        el('span', {}, 'size: '), renderVal(B(`${W}×${H}`, 'AMER2.MP header [B]')),
        el('span', { class: 'gap' }, 'sea-lane (right column): '),
        renderVal(B('id 26', 'CLAUDE.md hard rule 2 [B]')),
        el('span', { class: 'gap' }, 'palette: '),
        renderVal(B('PHYS0 embedded', 'active map palette, main.cpp:225 [B]')),
        el('label', { class: 'gap' }, 'zoom '), zoomSel),
      el('p', { class: 'hint' },
        'Layer order + sprite selection follow CLAUDE.md hard rules 3/4/5/7; the edge-blend and ',
        'coast-connectivity heuristics carry the reference renderer’s confidence (see ',
        el('code', {}, 'mapview.cpp'), ' / RULINGS 2026-06-22).'),
      el('div', { class: 'map-layout' }, scroll, inspector)),
  );
  fireRendered();
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
