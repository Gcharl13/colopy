// sim/mapgen.js — a Customize-New-World map generator following func_064A10's
// passes P0–P6 (spec/systems/map_generation.md). The PASS STRUCTURE, terrain
// immediates, climate→terrain tables, landmass target, and border rules are
// BYTE_VERIFIED (cited inline). The RNG and the exact blob-walk / smoothing fill
// conditions are NOT byte-pinned, so the OUTPUT is MODELED (R): a different map per
// seed with the right structure, not a byte-exact reproduction of a DOS seed.
//
// Output tiles use the SAME encoding the committed AMER2 grid + the M3 compositor
// read: base id in bits0-4 (0..7 land, 8..15 forested, 24 Arctic, 25 Ocean,
// 26 Sea Lane), hills bit 0x20, mountain bit 0x20|0x80, river bit 0x40 — so a
// generated map composites identically through sim/mapview.js.

const OCEAN = 25, SEA_LANE = 26, ARCTIC = 24;

// Climate band → base terrain id (BYTE_VERIFIED inline jump tables @0x64CFC / @0x6504E).
const CLIMATE_N = [5, 4, 1, 3, 2, 2];   // Savannah,Grassland,Desert,Prairie,Plains,Plains
const CLIMATE_S = [2, 3, 3, 4, 6, 7];   // Plains,Prairie,Prairie,Grassland,Marsh,Swamp

// Seedable PRNG (mulberry32) — MODELED stand-in for the DOS LCG (0x181F:0x4D4).
function rng(seed) {
  let a = seed >>> 0;
  return () => {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// Smooth value-noise field (seeded), bilinearly interpolated over a coarse grid —
// used to make climate boundaries wavy (not even strips) and to cluster elevation
// into ranges. NOT byte-derived: the DOS generator's perturbation isn't pinned, so
// this is part of the modeled (R) randomization. cell = grid spacing in tiles.
function noiseField(seed, cell) {
  const h = (xi, yi) => {                       // hash lattice point → [0,1)
    let a = (xi * 374761393 + yi * 668265263 + seed * 2246822519) >>> 0;
    a = Math.imul(a ^ (a >>> 13), 1274126177) >>> 0;
    return ((a ^ (a >>> 16)) >>> 0) / 4294967296;
  };
  const sm = (t) => t * t * (3 - 2 * t);        // smoothstep
  return (x, y) => {
    const gx = x / cell, gy = y / cell;
    const x0 = Math.floor(gx), y0 = Math.floor(gy);
    const fx = sm(gx - x0), fy = sm(gy - y0);
    const a = h(x0, y0), b = h(x0 + 1, y0), c = h(x0, y0 + 1), d = h(x0 + 1, y0 + 1);
    return (a * (1 - fx) + b * fx) * (1 - fy) + (c * (1 - fx) + d * fx) * fy;  // [0,1)
  };
}

// The four byte-verified Customize-New-World parameters (DGROUP:0x1E7E, mod-3 0..2),
// with their exact in-game menu labels (GAME.TXT @CLAND/@CCONT/@CTEMP/@CCLIM):
export const CUSTOMIZE = {
  landMass:    { key: '@CLAND', title: 'LAND MASS',   options: ['Small', 'Normal', 'Large'] },
  landForm:    { key: '@CCONT', title: 'LAND FORM',   options: ['Archipelago', 'Normal', 'Large Continents'] },
  temperature: { key: '@CTEMP', title: 'TEMPERATURE', options: ['Cool', 'Temperate', 'Warm'] },
  climate:     { key: '@CCLIM', title: 'CLIMATE',     options: ['Arid', 'Normal', 'Wet'] },
};

// params: { landMass, landForm, temperature, climate, seed }, each Customize var 0..2
// (idx0=land-mass p1, idx1=land-form p2, idx2=temperature, idx3=moisture/climate —
//  DGROUP:0x1E7E, written mod-3 by the Customize dialog func_070060 @0x701AD).
export function generate(params = {}) {
  const W = 58, H = 72;                 // random-map defaults @0x75702/@0x75708 (0x3A×0x48) [B]
  const landMass = clamp(params.landMass ?? 1, 0, 2);       // idx0 p1
  const landForm = clamp(params.landForm ?? 1, 0, 2);       // idx1 p2
  const temperature = clamp(params.temperature ?? 1, 0, 2); // idx2 (Cool..Warm)
  const climateV = clamp(params.climate ?? 1, 0, 2);        // idx3 moisture (Arid..Wet)
  // Map the named vars onto the generator's internals:
  const p1 = landMass + 1, p2 = landForm;                   // landmass target (p1+p2+1)·0x140 @0x64AAD
  const climateShift = 1 - temperature;                     // Cool → poleward bands, Warm → equatorial
  const moisture = climateV;                                // Arid(0)/Normal(1)/Wet(2)
  const seed = (params.seed ?? 1) >>> 0;
  const rand = rng(seed);
  const ri = (lo, hi) => { lo = Math.floor(lo); hi = Math.floor(hi); return lo + Math.floor(rand() * (hi - lo + 1)); };

  const t = new Uint8Array(W * H).fill(OCEAN);   // P0: all Ocean (0x19) @0x64A4B
  const land = new Uint8Array(W * H);            // landmass mask (P1)
  const at = (x, y) => (x < 0 || y < 0 || x >= W || y >= H ? -1 : y * W + x);

  // --- P1 landmass: blob-growth random walk; target ≈(p1+p2+1)·0x140 (@0x64AAD) [B target] ---
  const target = (p1 + p2 + 1) * 0x140;
  const DX = [0, 1, 1, 1, 0, -1, -1, -1], DY = [-1, -1, 0, 1, 1, 1, 0, -1];   // 8-dir compass (DS:0xB4/0xBE)
  let placed = 0;
  // LAND FORM controls coherence: Archipelago = many scattered blobs, Large
  // Continents = few big ones (fewer walkers over the same land target).
  const nWalk = landForm === 0 ? 6 + landMass : landForm === 1 ? 3 : 2;
  // Round-robin drunkard's walk over a few walkers until we hit the land target.
  const walkers = [];
  for (let s = 0; s < nWalk; s++) walkers.push({ x: ri(W * 0.25, W * 0.7), y: Math.floor((H / (nWalk + 1)) * (s + 1)) });
  let iter = 0; const maxIter = target * 60;
  while (placed < target && iter++ < maxIter) {
    for (const w of walkers) {
      if (placed >= target) break;
      const i = at(w.x, w.y);
      if (i >= 0 && !land[i]) { land[i] = 1; placed++; }
      // 4-neighbour land mask (mask 6/9 ⇒ fill the boxed-in cell)
      let m = 0;
      if (at(w.x, w.y - 1) >= 0 && land[at(w.x, w.y - 1)]) m |= 8;
      if (at(w.x, w.y + 1) >= 0 && land[at(w.x, w.y + 1)]) m |= 4;
      if (at(w.x - 1, w.y) >= 0 && land[at(w.x - 1, w.y)]) m |= 2;
      if (at(w.x + 1, w.y) >= 0 && land[at(w.x + 1, w.y)]) m |= 1;
      if ((m === 6 || m === 9) && i >= 0 && !land[i]) { land[i] = 1; placed++; }
      const d = ri(0, 7);
      w.x = clamp(w.x + DX[d], 1, W - 3);     // keep off the sea-lane columns
      w.y = clamp(w.y + DY[d], 1, H - 2);
    }
  }

  // --- P2 climate: latitude band → base terrain; set hills/forest (@0x64CF6/@0x65048) [tables B] ---
  // The latitude→band mapping is byte-verified; the DOS generator does NOT lay even
  // strips, so we perturb the band with a smooth noise field (modeled R) — boundaries
  // wander, and an independent elevation field clusters hills/mountains into ranges.
  const climateNoise = noiseField(seed ^ 0x1234, 9);     // ~9-tile climate cells → wavy bands
  const localNoise = noiseField(seed ^ 0x9E37, 3);       // fine per-tile terrain jitter
  const elevNoise = noiseField(seed ^ 0x5151, 7);        // elevation → mountain ranges/foothills
  for (let y = 0; y < H; y++) {
    const north = y < H / 2;
    const distFromEq = north ? (H / 2 - y) / (H / 2) : (y - H / 2) / (H / 2);
    for (let x = 0; x < W; x++) {
      const i = y * W + x;
      if (!land[i]) continue;
      // band wanders ±~2 with the climate noise instead of a clean latitude step
      const jitter = (climateNoise(x, y) - 0.5) * 4.2;
      let band = clamp(Math.round(distFromEq * 5 + jitter) + climateShift, 0, 5);
      let base = (north ? CLIMATE_N : CLIMATE_S)[band];
      // local jitter: sometimes borrow an adjacent band's terrain so a band isn't one flat colour
      const lj = localNoise(x, y);
      if (lj > 0.86 && band < 5) base = (north ? CLIMATE_N : CLIMATE_S)[band + 1];
      else if (lj < 0.14 && band > 0) base = (north ? CLIMATE_N : CLIMATE_S)[band - 1];
      if (!north && (base === 6 || base === 7) && moisture < 1) base -= 2;   // dry: Marsh/Swamp → drier (@moisture −2)
      let b = base & 0x1F;
      // elevation from the clustered field: high zones = mountain spines, flanks = hills
      const e = elevNoise(x, y);
      if (e > 0.78) b |= 0x20 | 0x80;        // mountain (ranges, not specks)
      else if (e > 0.66) b |= 0x20;          // hills (foothills around the spines)
      t[i] = b;
    }
  }

  // --- P3 smoothing: fold unforested→forested (+8, @0x653F8) in NOISE PATCHES (not
  // speckle); de-speckle interior ocean. forestThresh ↓ with moisture ⇒ wetter = more forest. ---
  const forestNoise = noiseField(seed ^ 0x7A21, 5);   // ~5-tile forest patches
  const forestThresh = 0.62 - moisture * 0.12;        // Arid 0.62 / Normal 0.50 / Wet 0.38
  for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
    const i = y * W + x;
    if (!land[i]) continue;
    const baseId = t[i] & 0x1F;
    if (baseId < 8 && (t[i] & 0x20) === 0 && baseId !== 1 && forestNoise(x, y) > forestThresh)
      t[i] = (t[i] & 0xE0) | ((baseId & 7) | 8);   // forested variant (band 8..15)
  }
  // remove 1-tile ocean holes surrounded by land
  for (let y = 1; y < H - 1; y++) for (let x = 1; x < W - 1; x++) {
    const i = y * W + x;
    if (land[i]) continue;
    const ln = land[at(x, y - 1)] + land[at(x, y + 1)] + land[at(x - 1, y)] + land[at(x + 1, y)];
    if (ln === 4) { land[i] = 1; t[i] = 2; }       // fill with Plains
  }

  // --- P4 rivers: a few interior→coast paths carry the river bit 0x40 (@0x65BC2) ---
  const rivers = Math.max(2, p1 + p2 + 2);
  for (let r = 0; r < rivers; r++) {
    // find a land interior start (retry a handful of times)
    let x = 0, y = 0, found = false;
    for (let tryi = 0; tryi < 40 && !found; tryi++) {
      x = ri(4, W - 6); y = ri(4, H - 6);
      if (land[at(x, y)]) found = true;
    }
    if (!found) continue;
    let guard = 0;
    while (guard++ < 200) {
      const i = at(x, y);
      if (i < 0 || !land[i]) break;        // reached coast/edge
      t[i] |= 0x40;
      x += x > W / 2 ? 1 : -1;             // drift toward the nearest horizontal edge
      y += ri(-1, 1);
      y = clamp(y, 1, H - 2);
    }
  }

  // --- P5 borders: top/bottom rows → Arctic (24), THEN right two columns → Sea Lane
  // (26) so the east edge stays an unbroken pole-to-pole lane (@0x65941/@0x6582A) [B] ---
  for (let x = 0; x < W; x++) { t[x] = ARCTIC; t[(H - 1) * W + x] = ARCTIC; land[x] = 0; land[(H - 1) * W + x] = 0; }
  for (let y = 0; y < H; y++) { t[y * W + (W - 1)] = SEA_LANE; t[y * W + (W - 2)] = SEA_LANE; land[y * W + (W - 1)] = 0; land[y * W + (W - 2)] = 0; }

  // --- P6 starts: 4 powers, y = (H/5)·(p+1) band, x walked inland from the east sea lane (@0x65C9C) [B rule] ---
  const starts = [];
  for (let p = 0; p < 4; p++) {
    const sy = Math.floor((H / 5) * (p + 1));
    let sx = W - 3;
    while (sx > 2 && !land[sy * W + sx]) sx--;     // walk inland until land
    starts.push({ power: p, x: sx, y: sy });
  }

  return { width: W, height: H, tiles: t, starts, landCount: placed, target };
}

function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }
