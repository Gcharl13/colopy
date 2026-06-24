// tabs/map.js — Map (M0 thin: decode AMER2 tiles, render a terrain-id heatmap on
// a canvas, tile inspector). Full sprite compositing lands in M3; the modeled
// generator in M4.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B, A } from '../provenance.js';

// Terrain id -> name + a flat preview color. Names/ids are byte-verified
// (formats/MP_FORMAT.md); the preview COLORS are a tool convenience (A), not B —
// real rendering composites the sprite sheets (M3).
const TERRAIN = [
  'Tundra', 'Desert', 'Plains', 'Prairie', 'Grassland', 'Savanna', 'Marsh', 'Swamp',
  ...Array(16).fill('Forest'),   // 8..23 auto-forest variants
  'Arctic', 'Ocean', 'Sea Lane', 'Mountains', 'Hills',
];
const COLOR = {
  0: '#b9c4c9', 1: '#e6d8a8', 2: '#cdd66e', 3: '#bcd05a', 4: '#8fc24a', 5: '#d6c45a', 6: '#7fa07a', 7: '#5f7d6a',
  24: '#eef3f6', 25: '#2b5d9e', 26: '#3f78c0', 27: '#7d6f63', 28: '#9a8060',
};
const forestColor = '#3f6e3a';
function tileColor(id) { return COLOR[id] ?? (id >= 8 && id <= 23 ? forestColor : '#444'); }

export async function render(host, ctx) {
  const map = await ctx.mapData();
  const W = map.width, H = map.height, t = map.tiles;
  const SCALE = 6;

  const canvas = el('canvas', { class: 'map-canvas', width: W * SCALE, height: H * SCALE });
  const inspector = el('div', { class: 'inspector' }, 'Click a tile to inspect.');
  const cx = canvas.getContext('2d');

  for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
    const id = t[y * W + x] & 0x1f;             // base terrain id (mask per func_006204) [B]
    cx.fillStyle = tileColor(id);
    cx.fillRect(x * SCALE, y * SCALE, SCALE, SCALE);
  }

  canvas.addEventListener('click', (e) => {
    const r = canvas.getBoundingClientRect();
    const x = Math.floor((e.clientX - r.left) / SCALE), y = Math.floor((e.clientY - r.top) / SCALE);
    if (x < 0 || y < 0 || x >= W || y >= H) return;
    const raw = t[y * W + x];
    const id = raw & 0x1f;
    inspector.innerHTML = '';
    inspector.append(
      el('div', {}, `tile (${x}, ${y})`),
      el('div', {}, 'raw byte: ', renderVal(B('0x' + raw.toString(16).padStart(2, '0'), 'AMER2.MP tile byte [B]'))),
      el('div', {}, 'terrain id: ', renderVal(B(id, 'raw & 0x1F (func_006204 @0x6204) [B]')),
        ' = ', renderVal(B(TERRAIN[id] || `id ${id}`, 'formats/MP_FORMAT.md terrain table [B]'))),
      el('div', {}, 'river bit (0x20): ', renderVal(B(!!(raw & 0x20), 'MP_FORMAT bit 5 [B]'))),
      el('div', {}, 'forest bit (0x40): ', renderVal(B(!!(raw & 0x40), 'MP_FORMAT bit 6 [B]'))),
      el('div', { class: 'hint' }, 'Preview color is a tool convenience (A); real sprite compositing is M3.'),
    );
  });

  host.append(
    section('Map — AMER2.MP (render existing, B)',
      el('p', { class: 'hint' },
        'Decoded from the committed tile grid (', el('code', {}, 'data_extracted/map/AMER2_tiles.json'),
        '). Dimensions & terrain ids are byte-verified; the flat colors are a placeholder until ',
        'sprite compositing (M3).'),
      el('div', { class: 'row' },
        el('span', {}, 'size: '), renderVal(B(`${W}×${H}`, 'AMER2.MP header [B]')),
        el('span', { class: 'gap' }, 'sea-lane (right column): '),
        renderVal(B('id 26', 'CLAUDE.md hard rule 2 [B]'))),
      el('div', { class: 'map-layout' }, canvas, inspector)),
    section('Procedural generator (M4 — MODELED)',
      el('p', { class: 'hint' }, 'The DOS map generator is not decompiled. The generator tab will be clearly badged R/TBD when built in M4.')),
  );
  fireRendered();
}
