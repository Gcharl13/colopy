// sim/mapview.js — the layered terrain compositor, ported 1:1 from
// viceroy_cpp/src/mapview.cpp (the byte-faithful reference renderer). Each tile
// is TERRAIN.SS base ground + PHYS0.SS overlays (biome edge-blend, forest canopy,
// river band, hills/mountains, and water-tile coast composition). The pixels are
// the real sheet bytes; the layer order + sprite selection follow CLAUDE.md hard
// rules 3/4/5/7. Edge/coast heuristics inherit mapview.cpp's own confidence
// (cited there to RULINGS 2026-06-22 / INGAME_MAP_RENDER_TRACE).
//
// Map shape: { width, height, tiles:Uint8Array } (lab loadMap). All neighbour
// reads treat off-map as open ocean, like the C++.

import { SS_TRANSPARENT } from './sheet.js';

const D4X = [0, 1, 0, -1], D4Y = [-1, 0, 1, 0];               // N,E,S,W

function L1at(m, x, y) {                                       // L1 byte, off-map = 0
  if (x < 0 || y < 0 || x >= m.width || y >= m.height) return 0;
  return m.tiles[y * m.width + x];
}
const isWater = (id) => id === 0x19 || id === 0x1A;           // Ocean / Sea-lane
function waterAt(m, x, y) {                                    // off-map counts as sea
  if (x < 0 || y < 0 || x >= m.width || y >= m.height) return true;
  return isWater(m.tiles[y * m.width + x] & 0x1F);
}

// classify_vis (func_006204): id&0x1F; fold forest 8..0x17 -> (id&7)|8; 25->0x19, 26->0x1A.
function classifyVis(b) {
  const id = b & 0x1F;
  if (id >= 8 && id < 0x18) return (id & 7) | 8;
  if (id === 25) return 0x19;
  if (id === 26) return 0x1A;
  return id;
}
// O513 base-ground id (6b): land_base = vis<0x18 ? vis&7 : vis, Desert group -> 0x11.
function landBaseOf(id) {
  const vis = id & 0x1F;
  const forested = vis >= 8 && vis < 0x18;
  let lb = (vis < 0x18) ? (vis & 7) : vis;
  if (lb === 1 && !forested) lb = 0x11;
  return lb;
}
// terrain_cell_transform: terrain code -> TERRAIN.SS base-ground frame index.
function terrainBaseFrame(code) {
  if (code === 0x11 || code === 0x09) return 8;
  if (code >= 8) return code - 0xF;
  return code;
}
// Base TERRAIN.SS frame for a tile (scrub/forested-desert -> brush frame 8; plain Desert -> 1).
function baseFrameOf(b) {
  if (classifyVis(b) === 9) return 8;
  if ((b & 0x1F) === 1) return 1;
  return terrainBaseFrame(landBaseOf(b));
}

// draw_ground: fill the terrain's flat colour (sampled from the texture centre) then
// blit its TERRAIN.SS texture, so transparent gaps show the biome colour, not black.
function drawGround(scr, terr, b, dx, dy) {
  const bf = baseFrameOf(b);
  if (bf < 0 || bf >= terr.nframes) return;
  const f = terr.frames[bf];
  if (!f) return;
  if (f.w > 0 && f.h > 0) {
    const c = f.px[((f.h >> 1) * f.w) + (f.w >> 1)];
    scr.fillRect(dx, dy, 16, 16, c === SS_TRANSPARENT ? 0 : c);
  }
  scr.blitFrame(f, dx, dy);
}

// --- neighbour masks (N=8,S=4,W=2,E=1) ------------------------------------
function forestNeighbour(m, x, y) {
  const b = L1at(m, x, y) & 0x1F;
  if (b < 8 || b >= 0x18) return false;     // only the auto-forest band 8..23
  return (b & 7) !== 1;                       // exclude desert/scrub
}
function forestNmask(m, x, y) {
  let k = 0;
  if (forestNeighbour(m, x, y - 1)) k |= 8;
  if (forestNeighbour(m, x, y + 1)) k |= 4;
  if (forestNeighbour(m, x - 1, y)) k |= 2;
  if (forestNeighbour(m, x + 1, y)) k |= 1;
  return k;
}
function riverNmask(m, x, y) {               // bit 0x40 carriers; isolated -> 0x0F
  let k = 0;
  if (L1at(m, x, y - 1) & 0x40) k |= 8;
  if (L1at(m, x, y + 1) & 0x40) k |= 4;
  if (L1at(m, x - 1, y) & 0x40) k |= 2;
  if (L1at(m, x + 1, y) & 0x40) k |= 1;
  return k ? k : 0x0F;
}
function featHiNmask(m, x, y) {              // (nb & 0xA0) == self_hi
  const self = L1at(m, x, y) & 0xA0; let k = 0;
  if ((L1at(m, x, y - 1) & 0xA0) === self) k |= 8;
  if ((L1at(m, x, y + 1) & 0xA0) === self) k |= 4;
  if ((L1at(m, x - 1, y) & 0xA0) === self) k |= 2;
  if ((L1at(m, x + 1, y) & 0xA0) === self) k |= 1;
  return k;
}

// O512 biome edge-blend: dither a differing LAND neighbour's ground into the edge.
function blendEdges(scr, terr, phys, m, mx, my, dx, dy) {
  const cclass = classifyVis(m.tiles[my * m.width + mx]);
  for (let d = 0; d < 4; d++) {
    const nx = mx + D4X[d], ny = my + D4Y[d];
    if (nx < 0 || ny < 0 || nx >= m.width || ny >= m.height) continue;
    const nb = m.tiles[ny * m.width + nx];
    const nclass = classifyVis(nb);
    if (isWater(nclass) || nclass === cclass) continue;
    const nf = baseFrameOf(nb), sidx = 0x68 + d;
    if (nf < 0 || nf >= terr.nframes || sidx >= phys.nframes) continue;
    const st = phys.frames[sidx], nbf = terr.frames[nf];
    if (!st || !nbf) continue;
    for (let gy = 0; gy < st.h && gy < 16; gy++)
      for (let gx = 0; gx < st.w && gx < 16; gx++)
        if (st.px[gy * st.w + gx] === 0 && gx < nbf.w && gy < nbf.h) {
          const p = nbf.px[gy * nbf.w + gx];
          if (p !== SS_TRANSPARENT) scr.put(dx + gx, dy + gy, p);
        }
  }
}

// nearest cardinal LAND neighbour's ground pixel at local (lx,ly); -1 if none.
function landFillPx(terr, m, tx, ty, lx, ly) {
  const es = [
    { dist: ly, nx: tx, ny: ty - 1 }, { dist: 15 - ly, nx: tx, ny: ty + 1 },
    { dist: lx, nx: tx - 1, ny: ty }, { dist: 15 - lx, nx: tx + 1, ny: ty },
  ];
  for (let i = 0; i < 4; i++)
    for (let j = i + 1; j < 4; j++)
      if (es[j].dist < es[i].dist) { const t = es[i]; es[i] = es[j]; es[j] = t; }
  for (const e of es) {
    if (e.nx < 0 || e.ny < 0 || e.nx >= m.width || e.ny >= m.height) continue;
    const nb = m.tiles[e.ny * m.width + e.nx];
    if (isWater(nb & 0x1F)) continue;
    const bf = baseFrameOf(nb);
    if (bf >= 0 && bf < terr.nframes) {
      const f = terr.frames[bf];
      if (f && lx < f.w && ly < f.h) { const p = f.px[ly * f.w + lx]; if (p !== SS_TRANSPARENT) return p; }
    }
  }
  return -1;
}

// draw a PHYS0 coast sub-tile (index 0 = deep-ocean cutout, 0xFD = land side).
function blitSubtile(scr, terr, m, tx, ty, fr, dx, dy, ox, oy, fillLand) {
  for (let gy = 0; gy < fr.h; gy++)
    for (let gx = 0; gx < fr.w; gx++) {
      const p = fr.px[gy * fr.w + gx], lx = ox + gx, ly = oy + gy;
      if (p === 0) continue;                       // deep-ocean cutout -> ocean base
      if (p === SS_TRANSPARENT) {                  // land side
        if (!fillLand) continue;
        const lp = landFillPx(terr, m, tx, ty, lx, ly);
        if (lp >= 0) scr.put(dx + lx, dy + ly, lp);
        continue;
      }
      scr.put(dx + lx, dy + ly, p);                // water / shore / sand as-is
    }
}

// compose_coast (water tiles only): 8-neighbour land bitmap -> diagonal beach
// (150..153) or 4 quadrant sub-tiles (108 + cfg[q]*4 + q).
function composeCoast(scr, terr, phys, m, tx, ty, dx, dy) {
  const CDX = [0, 1, 1, 1, 0, -1, -1, -1], CDY = [-1, -1, 0, 1, 1, 1, 0, -1]; // N,NE,E,SE,S,SW,W,NW
  const cfg = [0, 0, 0, 0]; let conn = 0;
  for (let dir = 0; dir < 8; dir++) {
    if (waterAt(m, tx + CDX[dir], ty + CDY[dir])) continue;
    conn |= (1 << dir);
    if (dir & 1) cfg[((dir + 1) & 6) >> 1] |= 2;
    else { cfg[dir >> 1] |= 4; cfg[((dir >> 1) + 1) & 3] |= 1; }
  }
  if (!conn) return;                               // open ocean
  let pattern = -1;
  if ((conn & 0xDD) === 0xC1) pattern = 0;
  if ((conn & 0x77) === 0x07) pattern = 1;
  if ((conn & 0x77) === 0x70) pattern = 2;
  if ((conn & 0xDD) === 0x1C) pattern = 3;
  if (pattern >= 0) {
    const f = 0x96 + pattern;
    if (f < phys.nframes && phys.frames[f]) blitSubtile(scr, terr, m, tx, ty, phys.frames[f], dx, dy, 0, 0, true);
    return;
  }
  const qx = [0, 8, 8, 0], qy = [0, 0, 8, 8];      // NW,NE,SE,SW
  for (let q = 0; q < 4; q++) {
    const f = 0x6C + cfg[q] * 4 + q;
    if (f >= 0 && f < phys.nframes && phys.frames[f])
      blitSubtile(scr, terr, m, tx, ty, phys.frames[f], dx, dy, qx[q], qy[q], cfg[q] !== 0);
  }
}

// Full neighbour-aware tile composition (port of sprite_draw_map_tile).
export function terrainCompose(scr, terr, phys, m, mx, my, dx, dy) {
  const b = m.tiles[my * m.width + mx];
  const id = b & 0x1F, vis = classifyVis(b);

  drawGround(scr, terr, b, dx, dy);                            // 1. base ground
  if (isWater(id)) { composeCoast(scr, terr, phys, m, mx, my, dx, dy); return; }  // 10. coast
  blendEdges(scr, terr, phys, m, mx, my, dx, dy);             // 2. biome blend
  if (vis >= 8 && vis < 0x18 && landBaseOf(b) !== 1) {        // 4. forest canopy
    const f = 0x40 + forestNmask(m, mx, my);
    if (f < phys.nframes && phys.frames[f]) scr.blitFrame(phys.frames[f], dx, dy);
  }
  if (b & 0x40) {                                             // 7. river band
    const f = ((b & 0x80) ? 0x00 : 0x10) + riverNmask(m, mx, my);
    if (f < phys.nframes && phys.frames[f]) scr.blitFrame(phys.frames[f], dx, dy);
  }
  if (b & 0x20) {                                            // 6. hills / mountains
    const base = (b & 0x80) ? 0x20 : 0x30;
    const f = base + featHiNmask(m, mx, my);
    if (f < phys.nframes && phys.frames[f]) scr.blitFrame(phys.frames[f], dx, dy);
  }
}

// Composite a whole map onto a fresh-sized Surface region (one 16px tile each).
// Returns nothing; writes into `scr`. Off-map tiles are skipped (caller clears).
export function renderMapRegion(scr, terr, phys, m, x0, y0, cols, rows, dx0 = 0, dy0 = 0) {
  for (let r = 0; r < rows; r++)
    for (let c = 0; c < cols; c++) {
      const mx = x0 + c, my = y0 + r;
      if (mx < 0 || my < 0 || mx >= m.width || my >= m.height) continue;
      terrainCompose(scr, terr, phys, m, mx, my, dx0 + c * 16, dy0 + r * 16);
    }
}

// Inspector helper: the layer breakdown for one tile, byte-faithful to terrainCompose.
export function tileLayers(m, mx, my) {
  const b = m.tiles[my * m.width + mx];
  const id = b & 0x1F, vis = classifyVis(b);
  const out = [];
  out.push({ layer: 'base ground', frame: baseFrameOf(b), sheet: 'TERRAIN' });
  if (isWater(id)) { out.push({ layer: 'coast', frame: 'computed (150–153 / 108+cfg)', sheet: 'PHYS0' }); return { b, id, vis, out }; }
  if (vis >= 8 && vis < 0x18 && landBaseOf(b) !== 1)
    out.push({ layer: 'forest canopy', frame: 0x40 + forestNmask(m, mx, my), sheet: 'PHYS0' });
  if (b & 0x40) out.push({ layer: 'river band', frame: ((b & 0x80) ? 0x00 : 0x10) + riverNmask(m, mx, my), sheet: 'PHYS0' });
  if (b & 0x20) out.push({ layer: (b & 0x80) ? 'mountains' : 'hills', frame: ((b & 0x80) ? 0x20 : 0x30) + featHiNmask(m, mx, my), sheet: 'PHYS0' });
  return { b, id, vis, out };
}

export { classifyVis, landBaseOf, baseFrameOf, isWater };
