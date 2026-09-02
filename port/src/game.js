/* Colonization — HTML port.
 *
 * Layer-3 implementation built from the spec (docs/COLONIZATION_TECHNICAL_REFERENCE.md
 * + spec/), per REWRITE_READINESS.md: preserve every player-visible number and layout,
 * modernize the form. Screen geometry cites the manual section it came from.
 *
 * ASSETS and DATA are injected by port/tools/bundle.py.
 */
'use strict';

const W = 320, H = 200;               // Mode 13h logical screen

// ---------------------------------------------------------------- palette
// Every .PIK carries its own 256-colour palette which overrides the master
// VICEROY.PAL (whose 0xFC-0xFE are magenta placeholders). Ink indices therefore
// resolve through the palette of whichever backdrop is on screen.
let PAL = DATA.palette;
const isPlaceholder = (c) => c[0] > 240 && c[1] < 110 && c[2] > 240;
const _merged = new Map();
// The default EGA 16-colour row. A sheet palette whose low 16 equals this
// table did not AUTHOR those entries -- the extractor stamped the stub -- and
// the running game resolves them through the master VICEROY.PAL instead.
// Proven against the live map capture (07_map_opening_turn.png): the English
// nation plate is master red (255,0,0), 111 px exact, and the EGA stub red
// (255,85,85) appears NOWHERE in the frame. This is what had the Dutch plates
// drawing EGA magenta instead of VICEROY.PAL's orange 13 = (255,113,0).
const EGA_STUB = [
  [0, 0, 0], [0, 0, 170], [0, 170, 0], [0, 170, 170],
  [170, 0, 0], [170, 0, 170], [170, 85, 0], [170, 170, 170],
  [85, 85, 85], [85, 85, 255], [85, 255, 85], [85, 255, 255],
  [255, 85, 85], [255, 85, 255], [255, 255, 85], [255, 255, 255],
];
const isEgaStubRow = (pal) =>
  EGA_STUB.every((c, i) => pal[i] && pal[i][0] === c[0] &&
                            pal[i][1] === c[1] && pal[i][2] === c[2]);
const usePalette = (bg) => {
  if (_merged.has(bg)) { PAL = _merged.get(bg); return; }
  const base = DATA.palettes[bg] || DATA.palette;
  const uiPal = DATA.palettes.OPENMENU || DATA.palette;
  // Keep the backdrop's own scene colours, but patch any entry still holding a
  // magenta placeholder. ORDER MATTERS: the MASTER first, and the picker
  // palette only where the master is a placeholder too. A backdrop sheet
  // leaves unauthored whatever its own art does not use -- WOODTILE.SS, the
  // map screen's sheet, has no water in it and so leaves the whole VGA
  // cycling band 120..127 unset, where OPENMENU's entries are the title
  // screen's SAND. Taking the picker first repainted every sea-lane tile and
  // coast edge tan in the C port (2026-08-17); the master's 120..127 is the
  // blue ramp CYCLE.DAT rotates. Index 13 is the same story -- master orange
  // (255,113,0), the very entry the EGA_STUB note above is about. 139..143
  // and 252..254 ARE placeholders in the master too, and those are the ones
  // the picker is genuinely for.
  const out = base.map((c, i) =>
    !isPlaceholder(c) ? c
      : !isPlaceholder(DATA.palette[i]) ? DATA.palette[i]
      : uiPal[i]);
  // Unauthored EGA low-16 row -> the master palette's own entries.
  if (isEgaStubRow(base))
    for (let i = 0; i < 16; i++) out[i] = DATA.palette[i];
  _merged.set(bg, out);
  PAL = out;
};
const ink = (i) => {
  const c = PAL[i & 255];
  return `rgb(${c[0]},${c[1]},${c[2]})`;
};

// ---------------------------------------------------------------- images
const IMG = {};
function loadImages() {
  const names = Object.keys(ASSETS);
  return Promise.all(names.map(n => new Promise(res => {
    const im = new Image();
    im.onload = () => { IMG[n] = im; res(); };
    im.onerror = () => { res(); };
    im.src = ASSETS[n];
  })));
}

// ---------------------------------------------------------------- font
// .FF glyphs: white with alpha carrying the 2bpp ink level (see build_assets.py).
// Advance = glyph width; glyphs carry their own trailing spacing column.
// .FF glyphs are 2bpp; the engine maps levels 1..3 through a 3-entry palette
// LUT (level 1 = the main ink, level 3 = the dark core). Each level ships as
// its own mask, tinted and stacked at draw time. The documented picker LUT is
// (254, 253, 0), i.e. [ink, ink-1, 0] — the rule used here.
class Font {
  constructor(meta, imgs) { this.m = meta; this.imgs = imgs; this.tints = new Map(); }
  tinted(lvl, color) {
    const key = lvl + '|' + color;
    if (this.tints.has(key)) return this.tints.get(key);
    const src = this.imgs[lvl];
    const c = document.createElement('canvas');
    c.width = src.width; c.height = src.height;
    const g = c.getContext('2d');
    g.drawImage(src, 0, 0);
    g.globalCompositeOperation = 'source-in';
    g.fillStyle = color;
    g.fillRect(0, 0, c.width, c.height);
    this.tints.set(key, c);
    return c;
  }
  width(s) {
    let w = 0;
    for (const ch of s) {
      const g = this.m.glyphs[ch.charCodeAt(0)];
      w += g ? g.w : (this.m.widths[32] || 3);
    }
    return w;
  }
  get height() { return this.m.h; }
  // lut: [level1, level2, level3] css colours. Drawn 3 -> 2 -> 1 so the main
  // ink lands on top of its own dark core.
  draw(ctx, s, x, y, lut, shadow) {
    if (typeof lut === 'string') lut = [lut, lut, '#000'];
    if (shadow !== undefined) {
      for (const [dx, dy] of [[1, 0], [0, 1], [1, 1]])
        this.draw(ctx, s, x + dx, y + dy, [shadow, shadow, shadow]);
    }
    for (const lvl of [3, 2, 1]) {
      const atlas = this.tinted(lvl, lut[lvl - 1]);
      let cx = Math.round(x);
      for (const ch of s) {
        const g = this.m.glyphs[ch.charCodeAt(0)];
        if (g) {
          ctx.drawImage(atlas, g.x, this.m.y, g.w, this.m.h, cx, Math.round(y), g.w, this.m.h);
          cx += g.w;
        } else cx += (this.m.widths[32] || 3);
      }
    }
    let cx = Math.round(x);
    for (const ch of s) {
      const g = this.m.glyphs[ch.charCodeAt(0)];
      cx += g ? g.w : (this.m.widths[32] || 3);
    }
    return cx;
  }
  // Centring is on the INK width, which is one pixel less than the advance
  // width -- the last glyph's trailing spacing column does not count. Derived
  // from seven live report strings whose ink extents were measured exactly:
  //   ECONOMIC ADVISER REPORT  w=90 -> x=116      European Trade w=54 -> 134
  //   RELIGIOUS ADVISER REPORT w=92 -> x=115      Ship   w=14 -> 36
  //   LABOR/NAVAL ADVISER ...  w=76 -> x=123      Cargo  w=20 -> 113
  //   INDIAN ADVISER REPORT    w=80 -> x=121      Location w=29 -> 188
  // Every one of them is cx - (w-1)/2 rounded, and none is cx - w/2.
  center(ctx, s, cx, y, lut, shadow) {
    this.draw(ctx, s, Math.round(cx - (this.width(s) - 1) / 2), y, lut, shadow);
  }
  // Right-aligned: the engine's `anchor - strwidth` numeric placement
  // (spec/ui/advisor_reports.md §4, `0x181F:0x204`). `rx` is the advance edge,
  // so the last glyph's ink lands at rx-2 for a 3-of-4 wide digit.
  right(ctx, s, rx, y, lut, shadow) {
    this.draw(ctx, s, Math.round(rx - this.width(s)), y, lut, shadow);
  }
}
// Ink helper: build the level LUT from a single palette index.
const lut = (i) => [ink(i), ink(i - 1), ink(0)];

const FONT = {};

// ---------------------------------------------------------------- colour cycling
// CYCLE.DAT ships one band: 8 entries from index 120, stepped every 35 ticks of
// the engine's 60.8766 Hz timer (~0.575 s/step, 4.60 s round trip). Each step
// moves every colour one index UP and wraps the last into the first, so after
// `phase` steps palette index 120+k shows the colour authored at 120+(k-phase).
// The DAC is global, so this animates the water wherever it appears: TERRAIN's
// Ocean/Sea Lane grounds, PHYS0's river bands and clean coast edges, ICONS 123.
// Cited in notes/rulings/RULINGS.md 2026-08-05; band and period come through
// the manifest from build_assets.CYCLE.
const CYC = DATA.cycle;
const CYCLED = new Set(CYC.sheets);
const _cycAtlas = new Map();

function cyclePhase() {
  // A pinned phase keeps shots.py and the render probes deterministic.
  if (G.cyclePhase !== null && G.cyclePhase !== undefined) return G.cyclePhase;
  const ticks = (performance.now() - G.cycleT0) * CYC.hz / 1000;
  return Math.floor(ticks / CYC.delay) % CYC.len;
}

// The band always resolves through the MASTER palette -- the map view streams
// VICEROY.PAL, not whatever backdrop palette `PAL` currently points at.
function cycAtlas(sheet, phase) {
  const base = IMG['SS_' + sheet];
  if (!phase || !base || !CYCLED.has(sheet)) return base;
  const key = sheet + '|' + phase;
  const hit = _cycAtlas.get(key);
  if (hit) return hit;
  const c = document.createElement('canvas');
  c.width = base.width; c.height = base.height;
  const g = c.getContext('2d');
  g.drawImage(base, 0, 0);
  const out = g.getImageData(0, 0, c.width, c.height);
  const mc = document.createElement('canvas');
  mc.width = base.width; mc.height = base.height;
  const mg = mc.getContext('2d');
  mg.drawImage(IMG['CYC_' + sheet], 0, 0);
  const m = mg.getImageData(0, 0, c.width, c.height).data;
  for (let i = 0; i < m.length; i += 4) {
    if (!m[i + 3]) continue;
    const k = m[i] - CYC.start;
    const src = DATA.palette[CYC.start + (((k - phase) % CYC.len) + CYC.len) % CYC.len];
    out.data[i] = src[0]; out.data[i + 1] = src[1]; out.data[i + 2] = src[2];
  }
  g.putImageData(out, 0, 0);
  _cycAtlas.set(key, c);
  return c;
}

// ---------------------------------------------------------------- sprites
function sheetFrame(ctx, sheet, idx, x, y) {
  const sh = DATA.sheets[sheet];
  if (!sh) return;
  const f = sh.frames[idx];
  if (!f) return;
  const atlas = cycAtlas(sheet, cyclePhase());
  if (!atlas) return;
  ctx.drawImage(atlas, f.x, f.y, f.w, f.h, Math.round(x), Math.round(y), f.w, f.h);
}
function frameSize(sheet, idx) {
  const f = DATA.sheets[sheet] && DATA.sheets[sheet].frames[idx];
  return f ? [f.w, f.h] : [0, 0];
}
// func_00380C layer 1: the frame's opaque shape as one flat colour (the
// engine's colour = flags&4 ? 0x5F : 0, @0x003829-@0x003834, blit 0xCD8:4).
const _silCache = new Map();
function sheetSilhouette(ctx, sheet, idx, x, y, colourIdx) {
  const sh = DATA.sheets[sheet];
  if (!sh) return;
  const f = sh.frames[idx];
  if (!f) return;
  const key = `${sheet}:${idx}:${colourIdx}`;
  let c = _silCache.get(key);
  if (!c) {
    const atlas = cycAtlas(sheet, 0);
    if (!atlas) return;
    c = document.createElement('canvas');
    c.width = f.w; c.height = f.h;
    const g = c.getContext('2d');
    g.drawImage(atlas, f.x, f.y, f.w, f.h, 0, 0, f.w, f.h);
    g.globalCompositeOperation = 'source-in';
    g.fillStyle = ink(colourIdx);
    g.fillRect(0, 0, f.w, f.h);
    _silCache.set(key, c);
  }
  ctx.drawImage(c, Math.round(x), Math.round(y));
}
// 0x181F:0x2F8 / 0xC56:4 = func_00E964 @0x00E964, the SCALED blit. One mask
// table per call (@0x00EA00-@0x00EA36): an accumulator starts at 0x32 and
// adds pct per index; reaching 0x64 KEEPS that index (acc -= 0x64), else it
// is dropped. w' / h' count the kept indices below w / h (@0x00EA1A-
// @0x00EA25). The passed x is the CENTRE (x_left = x - (w' >> 1),
// @0x00EA38-@0x00EA3D) and the passed y the BOTTOM row (y_top = y - h' + 1,
// @0x00EA41-@0x00EA48). Rows are kept/dropped by the same mask (@0x00EB1E),
// columns likewise (@0x00EB73), the destination advancing only on kept
// pixels (@0x00EB91): 50% keeps even indices, 25% keeps 1, 5, 9, ... The
// mirror flag (a negative frame) is not modelled -- no caller here uses it.
const scaleMask = (n, pct) => {
  const m = new Array(n);
  let acc = 0x32;
  for (let i = 0; i < n; i++) {
    acc += pct;
    if (acc >= 0x64) { m[i] = true; acc -= 0x64; } else m[i] = false;
  }
  return m;
};
const _scaledCache = new Map();
function sheetFrameScaled(ctx, sheet, idx, xc, yb, pct) {
  const sh = DATA.sheets[sheet];
  if (!sh) return;
  const f = sh.frames[idx];
  if (!f) return;
  const key = `${sheet}:${idx}:${pct}`;
  let c = _scaledCache.get(key);
  if (!c) {
    const atlas = cycAtlas(sheet, 0);
    if (!atlas) return;
    const mask = scaleMask(Math.max(f.w, f.h), pct);
    const cols = [], rows = [];
    for (let i = 0; i < f.w; i++) if (mask[i]) cols.push(i);
    for (let i = 0; i < f.h; i++) if (mask[i]) rows.push(i);
    c = document.createElement('canvas');
    c.width = Math.max(1, cols.length); c.height = Math.max(1, rows.length);
    c.__w = cols.length; c.__h = rows.length;
    const src = document.createElement('canvas');
    src.width = f.w; src.height = f.h;
    const sg = src.getContext('2d');
    sg.drawImage(atlas, f.x, f.y, f.w, f.h, 0, 0, f.w, f.h);
    const id = sg.getImageData(0, 0, f.w, f.h);
    const g = c.getContext('2d');
    const od = g.createImageData(c.width, c.height);
    rows.forEach((r, j) => cols.forEach((cx, i) => {
      const s = (r * f.w + cx) * 4, d = (j * c.width + i) * 4;
      od.data[d] = id.data[s]; od.data[d + 1] = id.data[s + 1];
      od.data[d + 2] = id.data[s + 2]; od.data[d + 3] = id.data[s + 3];
    }));
    g.putImageData(od, 0, 0);
    _scaledCache.set(key, c);
  }
  if (!c.__w || !c.__h) return;
  ctx.drawImage(c, xc - (c.__w >> 1), yb - c.__h + 1);
}

// ------------------------------------------------- count strips (engine verbs)
// Three shared primitives the colony screen (and the reports) are built out of.
// All three are byte-read out of VICEROY.EXE; every constant below cites the
// instruction that supplies it. Sprite indices here are EXE-sheet indices minus
// one -- the lab bundle is off by one from the EXE's ICONS numbering (the same
// off-by-one recorded for the building frames in spec/ui/colony_screen.md §3.7).
//   EXE 0x38 (56) empty/consumed overlay -> bundle 55, the red cross
//   EXE 0x3A (58) alternate overlay      -> bundle 57
const GAUGE_MARK = 55, GAUGE_ALT = 57;

// `func_002E4E @0x002E4E` -- the count badge. Values <= 0 draw nothing
// (`cmp [bp+6],0 / jg` @0x002E52). y is advanced by 2 (`add [bp+0xa],2`
// @0x002E5B), a black plate of (textwidth+1) x 7 is filled there
// (`push 7 / push 0 / bx = w+2` @0x002E9E-0x002EA6), and the digits land at
// +1,+1 inside it (`inc ax / inc dx` @0x002ED3/0x002ED7).
function countBadge(ctx, value, x, y, colorIdx) {
  if (value <= 0) return;
  const s = String(value);
  ctx.fillStyle = ink(0);
  ctx.fillRect(Math.round(x), Math.round(y) + 2, FONT.tiny.width(s) + 1, 7);
  const flat = [ink(colorIdx), ink(colorIdx), ink(colorIdx)];
  FONT.tiny.draw(ctx, s, x + 1, y + 3, flat);
}

// `func_002D74 @0x002D74` -- the strip pitch every count row uses:
//   pitch = (span - spritewidth) / (count - 1)      idiv @0x002DCB
// clamped to [1, spritewidth+1]                     cap @0x002DD1, floor @0x002DDA
// so a small count spaces the icons out to just touching and a large one floors
// at 1px and stacks them. This single formula is why one live frame shows a
// pitch of 4 on one row and 6 on another -- it is per row, not a constant.
function stripPitch(w, count, span) {
  if (count <= 1) return 1;
  let p = Math.trunc((span - w) / (count - 1));
  if (p > w + 1) p = w + 1;
  return p < 1 ? 1 : p;
}

// `func_002EE4 @0x002EE4` (thunk `0x181F:0x236`) -- the proportional strip.
// (Named `proportionalStrip` and not `spriteStrip` because the advisor reports
// already own that name for their own, separately measured, strip helper. Those
// gauges are the SAME engine verb and should fold into this one, but the F2
// crosses row shows an alternating 33/34 pitch that only the flag-bit-0
// fractional path in `func_002EE4` @0x002FBA explains, and that path is not read
// yet -- so the report code is left alone rather than half-converted.)
// `count` copies of `frame` at the pitch above, drawn at y+1 (`inc ax` @0x002F71);
// every icon from index `count-sub` on also gets GAUGE_MARK laid over it
// (`mov ax,0x38` @0x002FA5). Then two badges: the filled count at x+2 in white
// (@0x00301B-0x00302C) and the consumed count at the first marked icon in red
// (@0x003032-0x003043).
function proportionalStrip(ctx, frame, count, sub, x, y, span) {
  // The tile panel is the first of the four `mov al,[0x336]` sites
  // (func_0264A8 @0x0264AD): its yield strips badge only when the SAVED
  // numbers toggle is on -- the census3 scene cells are pure icon runs.
  gauge(ctx, frame, count, sub, count, x, y, span, 0, 0, G.colonyNumbers ? 1 : 0);
}

// `func_0033F2 @0x0033F2` (enqueue) + `func_003104 @0x003104` (flush) -- a row of
// several strips fitted into one span. Each cell is {frame, count, sub, flags}:
// flags bit 15 marks EVERY icon with GAUGE_MARK and turns the leading badge red
// (`test ah,0x80` @0x003253, colour `add ax,0xc` @0x00333C); bit 14 swaps the
// filled icons for GAUGE_ALT (`test byte[bx+0x2cf5],0x40` @0x0032C2).
//
// The layout solve (@0x00317C-0x0031ED), verbatim:
//   avail = span - (N-1)*gap - max(0, totalspritewidth - N*spacing)
//   while avail < (cells with count>1): shrink gap, then grow spacing
//   pitch = avail / sum(count-1)          idiv @0x0031D5
//   per cell: step = min(spritewidth+1, pitch)   @0x0033D1-0x0033DE
//   after a cell: x += spritewidth - spacing + gap               @0x00339A
// Reproduces the live frame's three rows to the pixel -- see the check in
// docs/LIVE_UI_CHECK_2026-08-05.md §10.4.
function countRowLayout(cells, x0, span, gap0) {
  const row = cells.filter(c => c.count > 0 || c.sub > 0);
  const n = row.length;
  if (!n) return [];
  let multi = 0, extras = 0, totalW = 0;
  for (const c of row) {
    if (c.count > 1) { multi += 1; extras += c.count - 1; }
    totalW += frameSize('ICONS', c.frame)[0];
  }
  let gap = gap0, spacing = 0, avail = 0;
  for (let guard = 0; guard < 4096; guard++) {
    const slack = Math.max(0, totalW - n * spacing);
    avail = span - (n - 1) * gap - slack;
    if (avail < multi) {
      if (gap > 0) { gap -= 1; continue; }
      if (slack > 0) { spacing += 1; continue; }
      avail = multi;
    }
    if (multi <= avail) break;
  }
  let shift = 0, pitch = 0;
  if (extras) {
    pitch = Math.trunc(avail / extras);
    if (pitch === 0) do { shift += 1; } while ((extras >> shift) > avail && shift < 16);
  }
  const out = [];
  let x = x0;
  for (const c of row) {
    const [w] = frameSize('ICONS', c.frame);
    const step = pitch === 0 ? 1 : Math.min(w + 1, pitch);
    const total = c.count >> shift, filled = (c.count - c.sub) >> shift;
    out.push({ cell: c, x, step, total, filled, w,
               last: x + Math.max(0, total - 1) * step });
    x += Math.max(0, total - 1) * step + w - spacing + gap;
  }
  return out;
}

function drawCountRow(ctx, cells, x0, y, span, gap0, numbers) {
  for (const e of countRowLayout(cells, x0, span, gap0)) {
    const always = (e.cell.flags & 0x8000) !== 0, alt = (e.cell.flags & 0x4000) !== 0;
    let markX = null, x = e.x;
    for (let i = 0; i < e.total; i++) {
      if (alt && i < e.filled) sheetFrame(ctx, 'ICONS', GAUGE_ALT, x, y);
      else {
        sheetFrame(ctx, 'ICONS', e.cell.frame, x, y);
        if (always || (i >= e.filled && !alt)) sheetFrame(ctx, 'ICONS', GAUGE_MARK, x, y);
      }
      if (i === e.filled) markX = x;
      x += e.step;
    }
    // BADGES ARE GATED (@0x0032E8-0x003309): drawn only when [0x70] is set --
    // the colony strips load it from the SAVED toggle byte [0x336] (all four
    // sites `mov al,[0x336]` @0x0264AD/@0x026DDD/@0x02731E/@0x0275D3; block
    // 34 of the save) -- OR when this cell compressed to step 1 with count>1
    // (`cmp [bp-0x1e],1 / cmp [bx+0x2cce],1` @0x0032EE-0x003300). The 1653
    // save carries the toggle ON (its Curacao frame badges everything), the
    // census3 save OFF (Jamestown badges nothing). Callers whose screens
    // force [0x70]=1 (@0x037E5C/@0x037F3E) pass numbers=true.
    if (!(numbers !== false || (e.step === 1 && e.cell.count > 1))) continue;
    // Bit 14 also rewrites the badges: the leading one shows the WHOLE count
    // and the trailing one is suppressed (`add [bp-0x1a],ax / mov [bp-6],0`
    // @0x00331E-0x003321). That is why the live food row reads "16" over a run
    // whose first four icons are the alternate sprite.
    countBadge(ctx, alt ? e.cell.count : e.cell.count - e.cell.sub,
               e.x + 2, y, always ? 0x0C : 0x0F);
    if (markX !== null && !alt) countBadge(ctx, e.cell.sub, markX + 2, y, 0x0C);
  }
}

// ---------------------------------------------------------------- terrain decode
// Tile byte: bits 0-4 terrain id; high bits (v & 0xE0):
//   0x20 hills · 0xA0 mountains · 0x40 minor river · 0xC0 major river  (formats/MP_FORMAT.md)
const TERR = { ARCTIC: 24, OCEAN: 25, SEALANE: 26 };
function tileTerrain(v) { return v & 0x1F; }
// Water = classes 0x19/0x1A only; Arctic (0x18) is land (§6.7).
function isWaterId(t) { return t === TERR.OCEAN || t === TERR.SEALANE; }
function tileWater(v) { return isWaterId(v & 0x1F); }
// Relief gate (§6.5): bit 0x20 on a non-water tile; bit 0x80 set -> Mountains.
function tileHills(v) { return !tileWater(v) && (v & 0xA0) === 0x20; }
function tileMountains(v) { return !tileWater(v) && (v & 0xA0) === 0xA0; }
// Rivers (§6.6) ride bit 0x40; bit 0x80 promotes to Major. 0 = none, 1 = minor,
// 2 = major.
function tileRiver(v) { return (v & 0x40) ? ((v & 0x80) ? 2 : 1) : 0; }

// TERRAIN.SS frame = ground id, folded per func_006204 / CLAUDE.md rule 3.
function groundFrame(tid) {
  tid &= 0x1F;
  if (tid >= 16 && tid <= 23) tid = (tid & 7) | 8;
  if (tid <= 7) return tid;
  if (tid >= 8 && tid <= 15) return tid === 9 ? 8 : (tid & 7);
  return { 24: 9, 25: 10, 26: 11 }[tid];
}
function isForested(tid) {
  let t = tid & 0x1F;
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  return t >= 8 && t <= 15;
}
// PHYS0 overlay bands, §6.4-6.7. The manual quotes ENGINE frame numbers; the
// sprite index on disk (and in the atlas) is engine - 1, so the bases below are
// already converted. Every band is `base + 4-bit adjacency mask`.
const PHYS = {
  RIVER_MAJOR: 0x00,   // engine 0x01
  RIVER_MINOR: 0x10,   // engine 0x11
  MOUNTAIN: 0x20,      // engine 0x21
  HILL: 0x30,          // engine 0x31
  FOREST: 0x40,        // engine 0x41
  MOUTH_MAJOR: 0x8C,   // engine 0x8D, + cardinal d
  MOUTH_MINOR: 0x90,   // engine 0x91, + cardinal d
  COAST_EDGE: 0x96,    // engine 0x97, + clean-edge pattern 0..3
  QUADRANT: 0x6C,      // engine 0x6D, + code*4 + quadrant
  DETAIL: 0x59,        // engine 0x5A, + DTAB[class]
  ROAD: 0x50,          // engine 0x51, stub; +1+dir for the eight spokes
  FOG: 0x94,           // engine 0x95, the unexplored-tile sprite (§6.11)
  // engine 0x68 -- the Lost City Rumour stone ring. `mov ax,0x68` @0x68411,
  // then the same emit primitive the detail band uses, `call 0x67dc8` @0x68414.
  // The byte pattern b8 68 00 occurs EXACTLY ONCE in the 494910-byte
  // VICEROY.EXE, so the frame number is not ambiguous. Disk frame 103 dumps as
  // a 16x16 concentric brown-and-tan stone ring, which is what it should be.
  // This supersedes the port's old by-eye "ICONS 17 gold sunburst", which had
  // no catalogue entry behind it (notes/SPRITE_CATALOG.md:497 -- ICONS indices
  // 16+ are uncatalogued).
  RUMOUR: 0x67,
};

// §6.4-6.6 — the 4-cardinal connection mask. Weights N=8, S=4, W=2, E=1.
function mask4(mx, my, connects) {
  return (connects(at(mx, my - 1)) ? 8 : 0)
       | (connects(at(mx, my + 1)) ? 4 : 0)
       | (connects(at(mx - 1, my)) ? 2 : 0)
       | (connects(at(mx + 1, my)) ? 1 : 0);
}
// §6.4 — a neighbour joins a forest run iff its masked id is in the band
// 8..0x17 AND (id & 7) != 1: desert Scrub never connects, and a Scrub centre
// draws no forest overlay at all (its trees are the cactus ground frame).
const forestConnects = (v) => { const t = v & 0x1F; return t >= 8 && t <= 0x17 && (t & 7) !== 1; };
const isScrub = (v) => { const t = v & 0x1F; return t >= 8 && t <= 0x17 && (t & 7) === 1; };
// §6.6 — the river mask tests only bit 0x40, so major and minor interconnect.
const riverConnects = (v) => (v & 0x40) !== 0;

// §6.9 — the detail band is the prime-resource mechanism. DTAB is the 29-entry
// word array at DS:0x192; -1 = no detail, a 0 entry reads as 6.
const DTAB = [6, 1, 2, 3, 4, 5, 6, 6,
              9, 1, 8, 9, 10, 10, 6, 6,
              9, 1, 8, 9, 10, 10, 6, 6,
              -1, 7, -1, 12, 13];
// The salt is the SAME word [0x190] the rumour hash reads -- `add cl,
// byte[0x190]` @0x6129 here, `add cx, word[0x190]` @0x61E1 there -- so the port
// now feeds both from G.mapSeed rather than the fixed 1 it used to hold here.
// Unified 2026-08-07 as the recorded deliberate decision (RULINGS.md): the
// byte-vs-word read difference is inert because `and cx,0xF` @0x612D lets only
// the low 4 bits reach a detail tile, and since (a+b)&0xF depends only on each
// addend's low nibble, adding the full seed is equivalent to adding seed&0xF.
// Before/after diff over AMER2: 399 detail tiles at the old fixed salt 1,
// 396-439 across other salts, 188/399 positions shared between salts 1 and 7 --
// the density holds, the layout moves per game, which is what the engine does.
// The gate is on the WHOLE word being zero (@0x60A9), matching the rumour gate
// @0x6191, and beginGame rolls 1..0x7FFF so it never fires in play.
function detailClass(v) {
  if (tileMountains(v)) return 27;
  if (tileHills(v)) return 28;
  return v & 0x1F;
}
// tile_terrain_variant_hash (@0x0060A0) returns the tile's DETAIL ID -- and
// that id IS the prime-resource id: the field yield calls THIS function for
// its resource argument (0x37F:0x4B0 resolves to file 0x60A0 by the type-B
// thunk rule stub = seg*16 + off + 0x2400, proven on 0x37F:0x10E ->
// 0x5CFE = map_tile_read_layer_15C). Resources are procedural, not a plane.
function detailId(mx, my, v) {
  if (!G.mapSeed) return -1;                  // word [0x190] == 0 disables @0x60A9
  // The pre-gate func_005F82 (@0x0060B3-@0x0060C4): improvement bit 2 with
  // the TERRITORY plane's high nibble >= 4 (a tribe owner; func_005DF0 =
  // [0x164] byte >> 4, 0xF none) suppresses the detail outright.
  const imp = impAt(mx, my), owner = resAt(mx, my);
  if ((imp & 2) && owner !== 0x0F && owner >= 4) return -1;
  const forest = forestConnects(v) || isScrub(v) ? 1 : 0;
  const q = (mx & 3) * 4 + (my & 3);
  const h = ((my >> 2) * 3 + (mx >> 2) + (G.mapSeed & 0xF) - forest) & 0xF;
  if (h !== q && (h ^ 0xA) !== q) return -1;
  const d = DTAB[detailClass(v)];
  if (d < 0) return -1;
  // Improve bit 4 suppresses the detail EXCEPT table entry 0xC, which
  // becomes id 0 (@0x00616A-@0x00617E: test al,4 -> only 0xC survives).
  if (imp & 4) return d === 0xC ? 0 : -1;
  return d;
}
function detailFrame(mx, my, v) {
  const d = detailId(mx, my, v);
  return d < 0 ? -1 : PHYS.DETAIL + d;
}

function terrainName(v) {
  const t = tileTerrain(v);
  if (tileMountains(v)) return 'Mountains';
  if (tileHills(v)) return 'Hills';
  if (t <= 7) return DATA.terrain.unforested[t];
  if (t >= 8 && t <= 23) return DATA.terrain.forested[((t >= 16 ? (t & 7) | 8 : t) - 8) & 7];
  return DATA.terrain.other[t - 24] || '?';
}

// ---------------------------------------------------------------- map
// The terrain plane is mutable: clearing a forest rewrites the tile id in place
// (the executor's `sub es:[bx],8`), so the port works on a copy of the shipped
// AMER2 array and restores it on a new game.
const MAP = { w: DATA.map.w, h: DATA.map.h, tiles: DATA.map.tiles.slice() };
const at = (x, y) => (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) ? 25 : MAP.tiles[y * MAP.w + x];
// The IMPROVEMENT layer is the engine's map layer #2 (DGROUP [0x160]/[0x162]),
// the one compute_terrain_yield reads and the pioneer executors write:
//   road = bit 0x08 (func_0409D6 @0x40AEC `or es:[bx],8`)
//   plow = bit 0x40 (func_040656 @0x04089F `or es:[bx],0x40`)
// It is a separate plane from the terrain byte, which is why plow's 0x40 does
// not collide with the terrain plane's river bit of the same value.
const IMPROVE = new Uint8Array(MAP.w * MAP.h);
// Plane 3's HIGH nibble -- RESOLVED 2026-08-29: it is the tile's
// TERRITORY OWNER (func_005DF0 = byte >> 4, 0xF -> -1 none; both callers
// use it as an owner -- @0x2288A compares it to the active player,
// @0x47242 range-checks < 4), multiplexed with the FEATURE marker
// (func_005F82: improve bit 2 AND nibble >= 4). The "neighbourhood reads
// 3" that looked like region bits was the Dutch (power 3) territory
// claim around their colonies. Consumers: the rumour hash suppresses on
// ANY claimed nibble (@0x61BC in func_006188) and the detail hash's
// feature pre-gate (map_detail_id). The claim WRITER (colony founding?)
// is unread -- fresh games stay 0xF everywhere, flagged.
const RESOURCE = new Uint8Array(MAP.w * MAP.h).fill(0x0F);
const resAt = (x, y) => (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h)
  ? 0x0F : RESOURCE[y * MAP.w + x];
void resAt;
// The REGION plane: map layer 3 ([0x164]), whose LOW NIBBLE is a landmass/
// region id -- byte-read at func_005D9C (the reader behind 0x181F:0x722,
// resolved 2026-08-07f). A shipped save carries the plane verbatim; a fresh
// game rebuilds the same semantic by flood-filling the land components (the
// engine's own region builder is unread -- R-tier, flagged).
const REGION = new Uint8Array(MAP.w * MAP.h);
function buildRegions() {
  REGION.fill(0);
  let next = 1;
  const stack = [];
  for (let seed = 0; seed < REGION.length; seed++) {
    if (REGION[seed] || tileWater(MAP.tiles[seed])) continue;
    REGION[seed] = next;
    stack.length = 0;
    stack.push(seed);
    while (stack.length) {
      const t = stack.pop(), x = t % MAP.w, y = (t / MAP.w) | 0;
      for (const [dx, dy] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
        const nx = x + dx, ny = y + dy;
        if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) continue;
        const n = ny * MAP.w + nx;
        if (REGION[n] || tileWater(MAP.tiles[n])) continue;
        REGION[n] = next;
        stack.push(n);
      }
    }
    if (next < 15) next += 1;                 // the id lives in a nibble
  }
}
const ROAD_BIT = 0x08, PLOW_BIT = 0x40;
const impAt = (x, y) => (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h)
  ? 0 : IMPROVE[y * MAP.w + x];
const hasRoad = (x, y) => (impAt(x, y) & ROAD_BIT) !== 0;
const hasPlow = (x, y) => (impAt(x, y) & PLOW_BIT) !== 0;

// ---------------------------------------------------------------- game state
const G = {
  screen: 'title',
  menuRow: 0,
  difficulty: 2,          // default 2 per §18.11
  nation: 0,
  leader: '',
  briefPage: 0,
  card: 0,
  gold: 0,
  tax: 0,
  year: 1492,
  season: 0,
  turn: 0,
  view: { x: 0, y: 0 },   // top-left tile of the viewport
  units: [],
  sel: 0,
  msg: '',
  // The engine blinks the active unit's selection ring; ~2 Hz at 60 fps.
  blink: true,
  tick: 0,
  // Milliseconds since load, refreshed once per frame. The hold-to-drag
  // deadline is measured against it rather than against G.tick so it does not
  // drift with the frame rate.
  wallClock: 0,
  // The live drag payload -- the engine's [0x8D54] (colony) / [0x9E3A] (Europe)
  // "what am I carrying" word plus its detail fields. null = carrying nothing.
  // `dragArm` is the pressed-but-not-yet-lifted colonist, waiting out the hold
  // deadline; see the drag-and-drop section for the full byte trail.
  drag: null,
  dragArm: null,
  // Which ship in the colony's port the dock panel shows. Clamped by
  // colonyShip() whenever the list shrinks.
  colonyShipSel: 0,
  // VGA colour cycling. cycle_init seeds every band's timestamp with the clock
  // as the map screen is entered, so the run starts at phase 0; cyclePhase is
  // an override that pins it (null = free-running off the wall clock).
  cycleT0: 0,
  cyclePhase: null,
  // F6's caption row selects one of four views; live default = Military Garrisons.
  f6View: 2,
  dialog: null,           // active modal popup, see openDialog()
  landHo: false,          // @LANDHO fires once per game
  newLand: '',            // what the player named the New World
  woodcut: 1,             // @WOODCUT index on the woodcut screen
  colonies: [],           // founded colonies
  colony: 0,              // active colony on the colony screen
  colonyNumbers: false,   // [0x336] -- the saved colony-strip badge toggle
  europe: [],             // ships in port / on the high seas
  market: [],             // per-good bid price
  euroRow: 0,             // recruit-menu row
  colonyView: 0,          // right-panel mode: production / units / build
  colonyPopup: null,      // 'build' | 'jobs' | 'occupation' | 'unitopts'
  colonyPopupRow: 0,
  colonyPopupUnit: -1,    // @UNITOPTIONS: which G.units entry the menu is for
  colonistSel: 0,
  pediaCat: 0, pediaSel: 0, pediaMode: 'index',
  crosses: 0,             // immigration accumulator
  bells: 0, bellsPerTurn: 0, fatherInProgress: null, declared: false, boycotts: [],
  rivals: [], metAnyone: false,
  warMatrix: {}, treatyMatrix: {}, parleyLock: {}, attitude: 8,
  routes: [], trade: null,
  mercSeen: false, interventionWatch: false,
  parley: null, parleyRow: 0,
  ref: {}, refUnits: [], royalFund: 0, flags: 0, declaredYear: 0,
  upkeepUnpaid: false,
  goTo: null, succession: false, retired: false,
  // The three option words. Game Options defaults with Combat Analysis on and
  // water cycling enabled (its bit is inverted, so clear = on).
  gameOptions: 0x0200, colonyOptions: 0, soundOptions: 0x07,
  options: null,
  // [0x96], the current tune id. The rotation that would set it lives in the
  // external sound driver, which does not port; Pick Music still writes it.
  tune: 0,
  razed: 0, bellsTotal: 0, lostWar: false,
  combat: null,            // the Combat Analysis panel's live figures
  combatAnalysis: true,    // Game Options bit 0x0200
  mapSeed: 0, rumoursDone: new Set(), rumourFloor: 1,
  foundFountain: false, foundCibola: false,
  report: null,           // open F-key report
  natives: [],            // native units on the map
  villages: [], tribes: [], fathersOwned: [],
  village: null, villageVisitor: null, villageRow: 0,
  villageMode: 'actions',  // @ACTIONS menu, or the trade list below it
  eventQueue: [],          // GAME.TXT event popups waiting to be acknowledged
  raidSeen: false,         // woodcut 13 (INDIAN RAID) fires once
  accum: [],              // per-good traffic accumulator
  kingsFund: 0,           // the tax the Crown has taken
  dock: [],               // three immigration candidate slots
  euroMenu: null,         // open Europe sub-menu: recruit / purchase / train
  euroMenuRow: 0,
  euroShip: 0,            // selected ship in port
  euroDockSel: 0,         // selected dock unit (wears the green cell)
  euroMsg: '',
  dockUnits: [],          // recruits/trainees waiting on the Europe dock
  artilleryBought: 0,
  marketSel: -1,          // highlighted market cell
  openMenu: -1,           // open pulldown index, -1 = none
  menuSel: 0,
  zoom: 0,                // §26.7 zoom level 0..3
  viewMode: false,        // View Pieces vs Move Pieces
  showHidden: false,
};

// NAMES @UNIT drives every unit stat. The "Icon" column is an ENGINE sprite
// number; the ICONS.SS index on disk is one lower (Colonist 101 -> frame 100).
const UNITS = {};
for (const r of DATA.units) {
  UNITS[r.name] = { name: r.name, icon: r.icon - 1, movement: r.movement,
                    attack: r.attack, combat: r.combat, cargo: r.cargo,
                    // Build materials (@UNIT Cost/Tools/Guns columns) for the
                    // colony-built units.
                    cost: r.cost, tools: r.tools, guns: r.guns,
                    hull: r.hull };
}
const unit = (n) => UNITS[n];

// func_003710 -- the unit ICON RESOLVER (byte-read 2026-08-30). The @UNIT
// icon column is only the BASE: type 0 Colonists resolve per profession
// (@0x3749 -> sub @0x36B2: experts icon = prof + 0x52 -> png 81+row; the
// class rows via the inline jump table @0x36C4 -> the F4 figure cluster),
// and the five equipment types fall back to the PLAIN gray variants when
// the matching expert profession is absent:
//   Pioneers   png 73 unless Hardy Pioneers    (@0x3751, prof 0x14)
//   Soldiers   png 74 unless Veteran Soldiers  (@0x3761, prof 0x15)
//   Scouts     png 75 unless Seasoned Scouts   (@0x377B, prof 0x16)
//   Dragoons   png 76 unless Veteran Soldiers  (@0x376E -- SOLDIERS, the
//              mounted veteran keeps his 0x15 byte; Veteran Dragoons is
//              never written by the engine's own equipping)
//   Missionaries png 77 unless Jesuit          (@0x378B, prof 0x18)
// and damaged Artillery draws the broken cart, png 65 (@0x37A5, the
// record +0x04 bit 0x80). Braves/ships fall through to the base icon.
const CLASS_ICON = { 19: 100, 20: 58, 21: 59, 22: 60, 23: 104, 24: 61,
                     25: 106, 26: 107, 27: 66 };
function unitIconOf(u) {
  const prof = u.profession ? (DATA.jobexpert || []).indexOf(u.profession) : -1;
  if (u.type === 'Colonists') {
    if (prof >= 0 && prof <= 18) return 81 + prof;      // prof + 0x52
    return CLASS_ICON[prof] !== undefined ? CLASS_ICON[prof] : 100;
  }
  if (u.type === 'Pioneers' && u.profession !== 'Hardy Pioneers') return 73;
  if (u.type === 'Soldiers' && u.profession !== 'Veteran Soldiers') return 74;
  if (u.type === 'Scouts' && u.profession !== 'Seasoned Scouts') return 75;
  if (u.type === 'Dragoons' && u.profession !== 'Veteran Soldiers') return 76;
  if (u.type === 'Missionaries' && u.profession !== 'Jesuit Missionaries') return 77;
  if (u.type === 'Artillery' && u.damaged) return 65;
  return u.icon;
}

// Starting conditions, §18.11: gold 1000 (d=0) / 300 (d=1) / 0 (d>=2), human only.
const START_GOLD = [1000, 300, 0, 0, 0];
// One whole move = three movement points.
const MOVE_UNIT = 3;

// @UNIT hull is the ship predicate: every vessel has hull > 0, and it is the
// only column that separates them from the Wagon Train (which carries cargo but
// sails nowhere).
//
// A dock/hold entry may be a PROFESSION name ('Expert Farmers', 'Veteran
// Soldiers', a @CLASS immigrant band), not a @UNIT type: the five professions
// with a unit of their own land as that unit, everyone else walks ashore as a
// plain Colonist CARRYING the profession. The old code threw on any profession
// name, which is what killed making landfall with recruits or trainees aboard
// -- the whole "sail out of Europe with an armed party" chain died there.
// The profession -> type pairs are the @JOB expert_name column against the
// @UNIT rows that share the trade (Soldier/Veteran Soldiers etc.).
const PROFESSION_UNIT = {
  'Veteran Soldiers': 'Soldiers', 'Veteran Dragoons': 'Dragoons',
  'Hardy Pioneers': 'Pioneers', 'Seasoned Scouts': 'Scouts',
  'Jesuit Missionaries': 'Missionaries',
};
function mkUnit(spec, x, y, cargo) {
  // spec: a string, or Europe's armed { name, type } pair.
  const name = typeof spec === 'object' ? spec.name : spec;
  const profession = unit(name) ? null : name;
  const t = unit(typeof spec === 'object' ? spec.type
          : profession ? (PROFESSION_UNIT[name] || 'Colonists') : name);
  // Movement budgets are stored in THIRDS: the @UNIT loader multiplies the
  // column by 3 (`SHL al,1 / ADD al,cl` @0x074F04, unit.md §3), which is what
  // makes a road step cost 1/3 of a move.
  const u = { type: t.name, icon: t.icon, x, y,
              moves: t.movement * MOVE_UNIT, movesLeft: t.movement * MOVE_UNIT,
              ship: t.hull > 0, nation: G.nation, orders: 0, cargo: cargo || [] };
  if (profession) u.profession = profession;
  // A Pioneer is a colonist carrying tools; UnitRecord +0x15 starts at 100.
  if (t.name === 'Pioneers') u.tools = PIONEER_TOOLS;
  return u;
}

function beginGame() {
  G.gold = START_GOLD[G.difficulty];
  G.tax = 0; G.year = 1492; G.season = 0; G.turn = 0;
  // The colony-layout seed base. In the real game `dword[0x8D80]` is the BIOS
  // clock read once at startup (`mov [0x8d80],ax / mov [0x8d82],dx` @0x075FF5),
  // so it is per-SESSION, not per-save: the same colony laid out differently
  // between two launches of the same save. The port draws it once per game and
  // keeps it in G, which round-trips through save/load -- a deliberate
  // difference, and the friendlier one.
  G.plotSeedBase = (Math.random() * 0x100000000) >>> 0;
  // cycle_init stamps every band's last-rotation time with the clock as the map
  // screen comes up, so the first frame of a game is always phase 0 -- which is
  // the phase docs/screens/06_ingame_map.png was captured at.
  G.cycleT0 = performance.now();
  // Starting force (new_game_setup): ONE ship carrying Pioneers + Soldiers, at
  // the nation's start tile from NAMES @SCENARIO, at every difficulty. The
  // Dutch ship is a Merchantman. (§18.11 claims the force is "doubled at d <= 1
  // by a second placement pass"; that claim carries no function cite anywhere
  // in the tree and play shows one ship at every level -- see RULINGS.md
  // 2026-08-04. Difficulty scales starting gold, not hulls.)
  const [sx, sy] = DATA.starts[G.nation];
  // Manifest order is Soldiers then Pioneers: the live opening turn lists
  // "Veteran" above "100 Tools" in the sidebar
  // (docs/screens/live_2026-08-05/07_map_opening_turn.png).
  G.units = [mkUnit(G.nation === 3 ? 'Merchantman' : 'Caravel', sx, sy,
                    ['Soldiers', 'Pioneers'])];
  G.sel = 0;
  G.landHo = false; G.newLand = ''; G.zoom = 0; G.openMenu = -1;
  G.colonies = []; G.europe = []; G.builtColony = false;
  G.kingsFund = 0; G.euroMenu = null; G.euroShip = 0; G.euroDockSel = 0;
  G.euroMsg = '';
  G.dockUnits = []; G.artilleryBought = 0; G.crosses = 0;
  G.fathersOwned = []; G.bells = 0; G.bellsPerTurn = 0;
  G.fatherInProgress = null; G.declared = false; G.boycotts = [];
  // The endgame flag word must clear with the rest: WOI_DECLARED leaking
  // through a New Game left woiLocked() refusing colonies in the fresh game.
  G.flags = 0; G.declaredYear = 0; G.upkeepUnpaid = false;
  G.rivalWars = {}; G.goTo = null; G.report = null;
  // No modal survives into a fresh game: a dialog left open by the previous
  // session would otherwise be "answered" by the first click of the new one.
  G.dialog = null; G.colonyPopup = null; G.dragArm = null; G.drag = null;
  G.eventQueue = []; G.raidSeen = false; G.villageMode = 'actions';
  G.wcSeen = 0; G.wcAfter = null;    // woodcut shown-bitmask ([0x540A])
  G.eventTribe = -1;                 // popup tribe-speaker channel ([0x1F5C])
  // Both mutable map planes go back to their shipped state.
  MAP.tiles.set ? MAP.tiles.set(DATA.map.tiles) : MAP.tiles.splice(0, MAP.tiles.length, ...DATA.map.tiles);
  IMPROVE.fill(0);
  buildRegions();
  seedNatives();
  seedRivals();
  G.warMatrix = {}; G.treatyMatrix = {}; G.parleyLock = {};
  G.parley = null; G.attitude = 8;
  G.routes = []; G.trade = null;
  G.mercSeen = false; G.interventionWatch = false; G.succession = false;
  G.retired = false; G.options = null;
  // Tutorial mask seed 0x0E (@0x755EB); TUTORIAL1 fires with the fleet on
  // the high seas -- the game's very first event.
  G.tutMask = 0x0E; G.tutSide = {}; G.scored = false;
  // The other two once-flag homes in the globals block (func_020F50 read,
  // RULINGS 2026-08-07z6): [0x5380] and [0x5382].
  G.onceFlags = 0; G.phaseFlags = 0;
  G.soonWarned = false; G.soonWarned2 = false; G.timeChanged = false;
  tutOnce(1, { STRING0: G.units[0].type });
  seedREF();
  SEEN.fill(0);
  revealAll();
  G.razed = 0; G.bellsTotal = 0; G.lostWar = false;
  // The map generator's first act is to store the seed the rumour hash reads.
  // func_064A10 @0x64A16 is `push 0x7fff; push 1; lcall random_int`, so the
  // range is random_int(1, 0x7FFF) -- the LOWER BOUND IS 1, not 0. A zero salt
  // would disable both the detail band and rumours outright (gates @0x60A9 and
  // @0x6191). Push order confirmed against the known random_int(1,9) at
  // @0x614F6 (`push 9; push 1`). Stored @0x64A23 into word [0x190].
  G.combat = null;
  G.mapSeed = 1 + Math.floor(Math.random() * 0x7FFF);
  G.rumoursDone = new Set(); G.rumourFloor = 1;
  G.foundFountain = false; G.foundCibola = false;
  G.metAnyone = false;
  seedMarket();
  // The dock holds three candidate slots; each refills from the @CLASS ladder.
  G.dock = [0, 0, 0].map(() => rollImmigrant());
  centerOn(sx, sy);
}

// §26.7: zoom z spans (0xF << z) x (0xC << z) tiles at (0x10 >> z) pixels, so
// the viewport is always 240x192. Level 0 is 15x12 at 16px.
const TILE = 16;
const VIEW_COLS = () => 0xF << G.zoom;
const VIEW_ROWS = () => 0xC << G.zoom;
const TILE_PX = () => 0x10 >> G.zoom;
function centerOn(tx, ty) {
  G.view.x = Math.max(0, Math.min(MAP.w - VIEW_COLS(), tx - (VIEW_COLS() >> 1)));
  G.view.y = Math.max(0, Math.min(MAP.h - VIEW_ROWS(), ty - (VIEW_ROWS() >> 1)));
}

// ---------------------------------------------------------------- chrome
// Dialog box chrome, §26.1: black outline (idx 0), ring 0x2E,
// bevel light 0xFD top/right, dark 0x37 left/bottom; tiled fill.
// Dialog box painter, byte-exact per func_06E0C8 (spec/ui/dialog_framework.md
// §"Box painter"). Four steps, in this order:
//   1. outline  -- 1px hollow rect, colour 0 (black), on the box edge
//   2. ring 2   -- 1px hollow rect inset 1, colour [0x1F44]
//   3. ring 3   -- the bevel, four 1px spans inset 2: top and RIGHT in the
//                  light [0x1F46], left and BOTTOM in the dark [0x1F48]
//   4. interior -- tiled fill at (x+3, y+3, w-6, h-6), i.e. inside the rings
//
// The ring colours are mode-dependent. Boot/title (@0x0734BC) uses the
// immediates 0x2E / 0xFD / 0x37 with OPENTILE; in-game (@0x073474) takes them
// from [0x830..], which is the NAMES @COLORS row -- and its last three fields
// are border0/border1/border2 = 134/128/138, a mid, a lighter and a darker
// wood brown. That is exactly a ring-plus-bevel triplet, so they map in order.
// CLOSED 2026-08-07: func_073474 walked in full + the [0x830..0x839] bytes
// read from the EXE image (file 0x1D9A0+0x830): normal [0x1F4A]<-[0x830]=68,
// hilite [0x1F4E]<-[0x831]=149, [0x1F4C]<-8, [0x1F50]<-128, [0x1F52]<-47,
// selection band [0x1F40/42]<-[0x835]=138, ring [0x1F44]<-134,
// bevel light/dark [0x1F46]/[0x1F48]<-128/138. The 68/149 in-game ink
// reading is byte-verified; the flag is removed.
// Selection band: the boot setter ties [0x1F40]/[0x1F42] to 0x37, which
// resolves through OPENMENU's palette to (56,32,24) -- confirmed against the
// selected row in docs/screens/01_mainmenu_BEGINMENU.png. The in-game setter
// takes its inks from [0x830..] = NAMES @COLORS, whose `select` field is 138 =
// (60,32,24), the same dark brown. Using 0x37 on an in-game screen is wrong:
// through the wood palettes it is a BLUE (93,121,186), which is what the
// landfall dialog and every pulldown were showing.
const SELECT_BOOT = 0x37, SELECT_GAME = 138;
const FRAME_BOOT = { ring: 0x2E, light: 0xFD, dark: 0x37 };
const FRAME_GAME = { ring: 134, light: 128, dark: 138 };
function plaque(ctx, x, y, w, h, tileSheet, frame) {
  const f = frame || (tileSheet === 'OPENTILE' ? FRAME_BOOT : FRAME_GAME);
  // 1. outline
  hollowRect(ctx, x, y, w, h, 0);
  // 2. ring 2
  hollowRect(ctx, x + 1, y + 1, w - 2, h - 2, f.ring);
  // 3. ring 3 -- the bevel. Drawn in the engine's order (left, right, top,
  // bottom) and that order is load-bearing: the top span is painted AFTER the
  // left one, so the top-left corner pixel comes out LIGHT, and the bottom span
  // is painted last, so the bottom-right corner comes out DARK. Painting
  // top/right first instead puts the wrong colour in both corners -- caught by
  // diffing against docs/screens/01_mainmenu_BEGINMENU.png at (x+2, y+2).
  ctx.fillStyle = ink(f.dark);
  ctx.fillRect(x + 2, y + 2, 1, h - 4);              // left
  ctx.fillStyle = ink(f.light);
  ctx.fillRect(x + w - 3, y + 2, 1, h - 4);          // right
  ctx.fillRect(x + 2, y + 2, w - 4, 1);              // top
  ctx.fillStyle = ink(f.dark);
  ctx.fillRect(x + 2, y + h - 3, w - 4, 1);          // bottom
  // 4. interior, tiled inside the rings. The engine's fill (func_00E350)
  // anchors the tile grid on the BOX ORIGIN, not the fill rect: phase =
  // |fill_x0 - anchor_x| mod tile_w with fill at +3, so the first tile shows
  // its columns from 3 on (@0x00E371-A2). Starting the grid at ix-3/iy-3
  // reproduces that under the clip.
  const ix = x + 3, iy = y + 3, iw = w - 6, ih = h - 6;
  const [tw, th] = frameSize(tileSheet, 0);
  if (tw) {
    ctx.save();
    ctx.beginPath(); ctx.rect(ix, iy, iw, ih); ctx.clip();
    for (let yy = iy - 3; yy < iy + ih; yy += th)
      for (let xx = ix - 3; xx < ix + iw; xx += tw) sheetFrame(ctx, tileSheet, 0, xx, yy);
    ctx.restore();
  } else {
    ctx.fillStyle = ink(f.dark);
    ctx.fillRect(ix, iy, iw, ih);
  }
}
function hollowRect(ctx, x, y, w, h, colorIdx) {
  ctx.fillStyle = ink(colorIdx);
  ctx.fillRect(x, y, w, 1); ctx.fillRect(x, y + h - 1, w, 1);
  ctx.fillRect(x, y, 1, h); ctx.fillRect(x + w - 1, y, 1, h);
}

// ---------------------------------------------------------------- dialogs
// Popup geometry is the builder math of spec/ui/dialog_framework.md §3
// (func_06D316 @0x06D316): content_w = max(@width, longest line px); box_w =
// content_w + 2*inset'(3); centred at X = 160 - W/2, Y = 100 - H/2. Body lines
// pen from box_y+6 at box_x+5 with pitch glyph_h+1 = 6. When a body block is
// present the option seed bumps by border(3) + text_h; rows sit at box_x+9 with
// their text at row_y+1, pitch 8, and the selected row wears the +0x40 band
// colour 0x37. Checked against the worked boot-menu example in that spec:
// @y=91, one title line -> title top 97, first option top 107, box_h 58.
// The dialog framework's FONT is FONTINTR, capture-proven: the live landfall
// popup's letterforms (60_landfall_dialog.png) match the intr sheet exactly
// and are ~8px tall -- the prior "body font = FONTTINY" reading held only for
// the HUD's direct draws, not the popup framework (RULINGS 2026-08-08d). The
// byte-read layout math is FONT-RELATIVE and lands pixel-exact on the capture
// with intr (h=9): text-line pitch = glyph_h+1 = 10 (`call 0x1266; inc ax`
// @0x06D012), option-row pitch = glyph_h+border(3) = 12 (dialog_framework.md
// par.5) -- the frame measures body 122->132 and rows 146->158.
const DFONT = () => FONT.intr || FONT.tiny;
const DTEXT = 10, DROW = 12;
// @SMALLFONT sections (census 2026-08-08: the Royal University list renders
// in the SMALL font while the recruit ask beside it is intr -- the directive
// genuinely switches; the boot menu's byte-read 6-cell math is that font's).
// small => the 6-cell font with its 5+1 / 5+3 pitches.
const dFont = (small) => small ? FONT.tiny : DFONT();
const dText = (small) => small ? 6 : DTEXT;
const dRow = (small) => small ? 8 : DROW;
function layoutDialog(d) {
  // Every measured line carries the +10 body margin (`add ax,0x0A`
  // @0x06CCE3); @width is a FLOOR under that, and 190 in practice.
  let cw = d.width;
  for (const l of d.body.concat(d.tail))
    cw = Math.max(cw, dFont(d.small).width(l.replace(/[{}]/g, '')) + 10);
  const w = cw + 6;
  const textH = d.body.length * dText(d.small);
  const rows = d.opts ? d.opts.length * dRow(d.small)
                      : (d.small ? 11 : 17);        // entry field: label + box
  const h = 6 + textH + 3 + rows + 3;
  // The engine's screen clamps: right past 320 shifts left, bottom past 200
  // shifts up (@0x06D563/@0x06D571); a negative origin floors at 0.
  // A popup WITH AN ADVISER FIGURE centres LOWER (y=130): every census
  // frame with a figure sits there (turnevent_0/1/2/3/5, cargoready, the
  // census3 BUY prompt -- click-opened, so the old turn-processing theory
  // is out), and every figureless one centres on 100 (pick_music,
  // find_colony, noentry). The drop gives the figure headroom; the
  // positioning code is unread, the 130 centre is capture-measured.
  // KING*/IND* sheets are unmeasured and keep the 100 centre -- TBD.
  const low = d.speaker && /^(MSS|MYR)/.test(d.speaker);
  let x = Math.round(160 - w / 2), y = Math.round((low ? 130 : 100) - h / 2);
  if (x + w > 320) x = 320 - w;
  if (y + h > 200) y = 200 - h;
  return { x: Math.max(0, x), y: Math.max(0, y), w, h, textH };
}
// The two ink sets: the boot/title setter (@0x0734BC) uses the immediates
// 0xFE base / 0xFC gold hilite; the IN-GAME setter (@0x073474) reads the
// NAMES @COLORS row -- slot 0 = 68 basic text, slot 1 = 149 gold hilite (the
// same [0x830]/[0x831] pair the F9 report decodes; the slot mapping is the
// spec's reading, its two anchors being slot 3 = 8 = boot's disabled ink and
// the F9 decode -- @0x073474's own body is unread, flagged).
function dialogInks() {
  return G.screen === 'title' ? { base: 0xFE, hi: 0xFC } : { base: 68, hi: 149 };
}
// '{...}' spans switch to the hilite ink (struct +0x74 ink record, func_06C388).
function spanText(ctx, line, x, y, base, hi, font) {
  const f = font || FONT.tiny;
  for (const part of line.split(/(\{[^}]*\})/)) {
    if (!part) continue;
    x = f.draw(ctx, part.replace(/[{}]/g, ''),
               x, y, lut(part.startsWith('{') ? hi : base));
  }
  return x;
}
function drawDialog(ctx) {
  const d = G.dialog;
  if (!d) return;
  const b = layoutDialog(d);
  const ik = dialogInks();
  if (d.speaker) drawSpeakerSheet(ctx, d.speaker, b);
  plaque(ctx, b.x, b.y, b.w, b.h, G.screen === 'title' ? 'OPENTILE' : 'WOODTILE');
  const f = dFont(d.small), tp = dText(d.small), rp = dRow(d.small);
  d.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * tp,
                                    ik.base, ik.hi, f));
  const seed = b.y + 6 + b.textH + 3;
  if (d.opts) {
    d.opts.forEach((o, k) => {
      const oy = seed + k * rp;
      // Selection is the +0x40 band ONLY -- the hilite ink is gated on the
      // {brace} flag (func_06C346 @0x06C365), never on the row being
      // selected, so every row's text runs through the same span painter.
      if (k === d.sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 4, oy, b.w - 8, rp - 2); }
      spanText(ctx, o, b.x + 9, oy + 1, ik.base, ik.hi, f);
    });
  } else {
    // Entry popup (@LANDHO): the tail line is the field label, the box follows.
    const label = d.tail[0] || '';
    spanText(ctx, label, b.x + 5, seed + 2, ik.base, ik.hi, f);
    const fx = b.x + 5 + f.width(label.replace(/[{}]/g, '')) + 4;
    hollowRect(ctx, fx, seed, b.x + b.w - 5 - fx, d.small ? 11 : 15, ik.base);
    const caret = (Math.floor(G.tick / 24) % 2) ? '_' : '';
    f.draw(ctx, d.entry + caret, fx + 3, seed + 3, lut(ik.hi));
  }
}
// Capture-pinned dialog speakers: the landfall ask wears the MSS3 scout
// (60_landfall_dialog / 77_landfall_portrait) and the set-sail ask the MSS0
// naval officer (78_europe_setsail_portrait). No other DATA.dialogs key has a
// captured portrait, so none is invented.
const DIALOG_SPEAKER = { LANDHO: 'MSS3', LANDFALL: 'MSS3', LANDFALL2: 'MSS3',
                         SAILAWAY: 'MSS0', SAILHOME: 'MSS0' };
function openDialog(key, onDone, prefill) {
  const t = DATA.dialogs[key];
  // A numeric @default names the highlighted option row; a text @default
  // prefills an entry field; no @default at all is an entry field with no
  // prefill (GAME.TXT @COLONY carries no directives).
  const numeric = typeof t.default === 'string' && /^\d+$/.test(t.default);
  G.dialog = {
    key,
    body: t.body, tail: t.tail, width: t.width, onDone,
    speaker: DIALOG_SPEAKER[key] || null,
    small: !!t.small,
    opts: numeric ? t.tail : null,
    // @default names the highlighted row ONE-BASED: @ABANDON's `@default=2`
    // over two rows is "Never! That would be folly." -- the engine highlights
    // the cautious answer. @LANDFALL's `@default=1` is "Stay With Ships" for
    // the same reason. (The port read it as a 0-based index until 2026-08-05.)
    sel: numeric ? Math.max(0, Math.min(t.tail.length - 1, +t.default - 1)) : 0,
    entry: numeric ? undefined : (prefill !== undefined ? prefill : (t.default || '')),
  };
}
// The bounded numeric-entry dialog behind @HOWMUCH1-5 ("Amount:", body
// carries the 0-N bound). Digits only; the result is clamped to [0, max].
// Enter on an empty field takes the FULL amount -- the port's own
// convenience reading, flagged (the engine's empty-entry behaviour is
// unread).
function askAmount(key, subs, max, onDone) {
  const t = DATA.dialogs[key];
  if (!t) { onDone(max); return; }
  G.dialog = {
    key,
    body: t.body.map(l => fillTemplate(l, { ...subs, NUMBER0: max })),
    width: t.width, entry: '', numeric: true,
    onDone: (v) => {
      if (v === -1) { onDone(0); return; }        // Escape cancels
      const n = String(v).trim() === '' ? max
              : Math.max(0, Math.min(max, parseInt(v, 10) || 0));
      onDone(n);
    },
  };
}
function closeDialog(result) {
  const d = G.dialog;
  G.dialog = null;
  if (d && d.onDone) d.onDone(result);
}
function dialogKey(k) {
  const d = G.dialog;
  if (d.opts) {
    if (k === 'ArrowUp') d.sel = (d.sel + d.opts.length - 1) % d.opts.length;
    else if (k === 'ArrowDown') d.sel = (d.sel + 1) % d.opts.length;
    else if (k === 'Enter' || k === ' ') closeDialog(d.sel);
    else if (k === 'Escape') closeDialog(-1);
  } else {
    if (k === 'Enter') closeDialog(d.entry);
    else if (k === 'Escape' && d.numeric) closeDialog(-1);
    else if (k === 'Backspace') d.entry = d.entry.slice(0, -1);
    else if (k.length === 1 && d.entry.length < 23 &&
             (!d.numeric || /\d/.test(k))) d.entry += k;
  }
}
function dialogClick(mx, my) {
  const d = G.dialog, b = layoutDialog(d);
  if (!d.opts) { closeDialog(d.entry); return; }
  const seed = b.y + 6 + b.textH + 3, rp = dRow(d.small);
  for (let k = 0; k < d.opts.length; k++) {
    if (hit(mx, my, { x: b.x + 4, y: seed + k * rp, w: b.w - 8, h: rp })) { closeDialog(k); return; }
  }
}

// ---------------------------------------------------------------- screens
const MENU_OPTS = DATA.text.beginmenu.slice(1);
const MENU_BOX = { x: 77, y: 91, w: 166, h: 58 };          // §26.1

function drawTitle(ctx) {
  usePalette('OPENMENU');
  ctx.drawImage(IMG.OPENMENU, 0, 0);
  const b = MENU_BOX;
  plaque(ctx, b.x, b.y, b.w, b.h, 'OPENTILE');
  // Title line, §26.1: x=box+5, top=box+6; the {..} span renders gold 0xFC.
  const title = DATA.text.beginmenu[0].replace('%STRING0', '1.0').replace('%STRING1', 'HTML');
  let tx = b.x + 5;
  for (const part of title.split(/(\{[^}]*\})/)) {
    if (!part) continue;
    const gold = part.startsWith('{');
    tx = FONT.tiny.draw(ctx, part.replace(/[{}]/g, ''), tx, b.y + 6, lut(gold ? 0xFC : 0xFE));
  }
  // Options: x=box+9, tops y=107+8k (pitch 8); selection bar (box+4, top-1, 158, 7).
  MENU_OPTS.forEach((opt, k) => {
    const oy = 107 + 8 * k;
    if (k === G.menuRow) { ctx.fillStyle = ink(SELECT_BOOT); ctx.fillRect(b.x + 4, oy - 1, 158, 7); }
    FONT.tiny.draw(ctx, opt, b.x + 9, oy, lut(k === G.menuRow ? 0xFC : 0xFE));
  });
}

// §26.2 — cells (col*105+23, grp*96+7, 68, 90) with idx = n+1.
const DIFF_CELL = (n) => {
  const i = n + 1;
  return { x: (i % 3) * 105 + 23, y: Math.floor(i / 3) * 96 + 7, w: 68, h: 90 };
};
const DIFF_OUTLINE = [0x0A, 0x09, 0x0E, 0x0D, 0x0C];
function drawDifficulty(ctx) {
  usePalette('DIFFICUL');
  ctx.drawImage(IMG.DIFFICUL, 0, 0);
  FONT.intr.center(ctx, DATA.text.misc[162], 56, 16, lut(254), ink(0));
  FONT.intr.center(ctx, DATA.text.misc[163], 56, 29, lut(254), ink(0));
  const c = DIFF_CELL(G.difficulty);
  // 1-px hollow rect over the selected cell, colour per row (§26.2).
  hollowRect(ctx, c.x, c.y, c.w - 1, c.h - 1, DIFF_OUTLINE[G.difficulty]);
  // Level name uppercased + ':' and the rank word, drawn for the selected row
  // only, with a black shadow. Unlike the nation picker (which splits its two
  // lines to the top and bottom of the cell), the difficulty picker stacks
  // BOTH lines together in the middle, 8px apart, and draws both in the row's
  // own ink -- measured off the live DOSBox frame
  // docs/screens/live_2026-08-05/03_difficulty.png: for the (128,7,68,90)
  // Discoverer cell the glyph rows start at y=45 and y=53 and both are 0x0A
  // (4,182,16), not 254/0xFC.
  const dInk = lut(DIFF_OUTLINE[G.difficulty]);
  FONT.tiny.center(ctx, DATA.difficulty[G.difficulty].toUpperCase() + ':',
                   c.x + c.w / 2, c.y + 38, dInk, ink(0));
  FONT.tiny.center(ctx, DATA.text.misc[165 + G.difficulty],
                   c.x + c.w / 2, c.y + 46, dInk, ink(0));
  FONT.tiny.center(ctx, '(' + DATA.text.misc[161] + ')', 56, 81, lut(254));
}

// §26.3 — cells (col*99+112, row*91+13, 88, 82).
const NAT_CELL = (i) => ({ x: (i % 2) * 99 + 112, y: Math.floor(i / 2) * 91 + 13, w: 88, h: 82 });
function drawNation(ctx) {
  usePalette('NATIONS');
  ctx.drawImage(IMG.NATIONS, 0, 0);
  FONT.intr.center(ctx, DATA.text.misc[170], 56, 36, lut(254), ink(0));
  FONT.intr.center(ctx, DATA.text.misc[171], 56, 49, lut(254), ink(0));
  const n = DATA.nations[G.nation], c = NAT_CELL(G.nation);
  hollowRect(ctx, c.x, c.y, c.w - 1, c.h - 1, n.color);
  // Both lines take the nation's own colour -- live frame
  // docs/screens/live_2026-08-05/04_nation.png has "ENGLAND:" and
  // "Immigration" alike at (247,0,0) = @COUNTRY.color 12, not 254 for the name.
  FONT.tiny.center(ctx, n.country.toUpperCase() + ':', c.x + c.w / 2, c.y + 2,
                   lut(n.color), ink(0));
  FONT.tiny.center(ctx, DATA.text.misc[173 + G.nation], c.x + c.w / 2, c.y + c.h - 9,
                   lut(n.color), ink(0));
  FONT.tiny.center(ctx, '(' + DATA.text.misc[161] + ')', 56, 182, lut(254));
}

// §26.4 — WOODPANL backdrop, prompt y=88, entry field (79,98,167,14), maxlen 23.
function drawName(ctx) {
  usePalette('WOODPANL');
  ctx.drawImage(IMG.WOODPANL, 0, 0);
  // @LEADERNAME, @width=300, FONTINTR (pixel-confirmed; no @smallfont).
  const prompt = DATA.text.leadername.split('\n')[0].replace(/\^/g, '');
  FONT.intr.center(ctx, prompt, 160, 88, lut(0xFE), ink(0));
  hollowRect(ctx, 79, 98, 167, 14, 0xFE);
  const caret = (Math.floor(Date.now() / 400) % 2) ? '_' : '';
  FONT.intr.draw(ctx, G.leader + caret, 84, 101, lut(0xFE));
}

// @NATIONnA (history) then @NATIONnB (the gameplay bonus), both @width=300
// centred over WOODPANL. '^^' marks a centred line, '_' an indent, '{}' gold.
function briefLines(page) {
  const raw = (DATA.briefings[G.nation] || ['', ''])[page] || '';
  return raw.split('\n')
            .map(s => s.replace(/\^\^/g, '').replace(/[\^_]/g, ' ').trim())
            .filter((s, i) => i > 0);
}
function drawBriefing(ctx) {
  usePalette('WOODPANL');
  ctx.drawImage(IMG.WOODPANL, 0, 0);
  FONT.intr.center(ctx, DATA.nations[G.nation].country.toUpperCase(), 160, 18,
                   lut(0xFC), ink(0));
  const lines = briefLines(G.briefPage);
  const top = G.briefPage === 0 ? 38 : 66;
  let y = top;
  for (const l of lines) {
    if (!l) { y += 5; continue; }
    // {..} spans render gold; split so the hilite keeps its place on the line.
    const parts = l.split(/(\{[^}]*\})/).filter(Boolean);
    let w = 0;
    for (const pt of parts) w += FONT.tiny.width(pt.replace(/[{}]/g, ''));
    let x = 160 - w / 2;
    for (const pt of parts) {
      const gold = pt.startsWith('{');
      x = FONT.tiny.draw(ctx, pt.replace(/[{}]/g, ''), x, y, lut(gold ? 0xFC : 0xFE), ink(0));
    }
    y += 9;
  }
  FONT.tiny.center(ctx, G.briefPage === 0 ? '(more)' : '(click to continue)',
                   160, 188, lut(0xFC), ink(0));
}

// The 10 LEVN cards play over world generation; @BUILD1..10 supplies the text.
function cardText(i) {
  const n = DATA.nations[G.nation];
  return (DATA.cards[i] || '').split('\n').map(s => s
    .replace(/\^\^/g, '').replace(/[\^_]/g, ' ').trim())
    .filter(Boolean)
    .map(s => {
      if (i === 1) return s.replace('%STRING0', DATA.text.misc[165 + G.difficulty])
                           .replace('%STRING1', G.leader);
      if (i === 2) return s.replace('%STRING0', n.homeport);
      if (i === 3) return s.replace('%STRING0', n.country)
                           .replace('%STRING1', DATA.myleader[G.nation]);
      if (i === 6) return s.replace('%STRING0', n.country);
      return s;
    });
}
function drawCards(ctx) {
  const key = `LEVN${String(G.card + 1).padStart(4, '0')}`;
  usePalette(key);
  if (IMG[key]) ctx.drawImage(IMG[key], 0, 0);
  else { ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H); }
  // Renderer func_004B72 lays the card text at pen (14,54), ink 0x0E.
  cardText(G.card).forEach((l, i) => FONT.tiny.center(ctx, l, 160, 54 + i * 9,
                                                      lut(0x0E), ink(0)));
  FONT.tiny.center(ctx, '(click to continue)', 160, 190, lut(0x0E), ink(0));
}

// §18.5 / §26.13 — the King's audience. One renderer paints the audience, the
// win and the loss screens: KINGLSS1.PIK throne room, the outcome-selected
// king-and-dog figure (KING1.SS here), and the nation canopy banner. Both
// figures are placed by their own frame descriptors — the (hx, hy) pair is an
// (anchor-x = centre-x, anchor-y = bottom-y) anchor (ruling of 2026-07-31),
// which resolves KING1 to (0,12) and ENGLND1 to (32,0), pixel-exact.
const NATION_STEM = ['ENGLND1', 'FRANCE1', 'SPAIN1', 'DUTCH1'];
function sheetAnchored(ctx, sheet, idx) {
  const f = DATA.sheets[sheet] && DATA.sheets[sheet].frames[idx];
  if (!f) return;
  sheetFrame(ctx, sheet, idx, f.hx - (f.w >> 1), f.hy - f.h + 1);
}
// §26.14 -- woodcut event plates. Black clear, WOODFRAM frame 1, the WDCUT<n>
// art, a NAMEPLAT caption strip at y=162 (left cap + N mid tiles + right cap,
// centred on x=160) and the @WOODCUT caption at y=165 in FONT-NP with the ink
// LUT 0x5C/0x5D/0x5E. Frame and art are placed by their own sheet-header
// anchors, which put WOODFRAM at (23,15) and WDCUT01 at (63,40).
//
// The manual has the caption prefixed "<year>: "; the DOS capture
// docs/screens/12_discovery_cinematic.png shows the bare caption, and pixels
// outrank team docs, so the bare form is what is drawn here. Conflict logged in
// notes/rulings/RULINGS.md (2026-08-04) rather than settled silently.
function drawWoodcut(ctx) {
  // Every .SS ships its own 768-byte palette, and the woodcut sheets' is not
  // the master VICEROY.PAL: in it 0x5C/0x5D/0x5E are the dark caption browns,
  // where the master's are pale wood tones that would be invisible on the
  // plate. Adopting WOODFRAM's palette is what makes the quoted LUT resolve.
  usePalette('WOODFRAM');
  ctx.fillStyle = ink(0); ctx.fillRect(0, 0, W, H);
  sheetAnchored(ctx, 'WOODFRAM', 0);
  sheetAnchored(ctx, 'WDCUT' + String(G.woodcut).padStart(2, '0'), 0);
  const caption = DATA.woodcuts[G.woodcut] || '';
  const npLut = [ink(0x5C), ink(0x5D), ink(0x5E)];
  const capW = FONT.np.width(caption);
  const [lw] = frameSize('NAMEPLAT', 0), [mw] = frameSize('NAMEPLAT', 1);
  const n = Math.max(1, Math.ceil((capW + 8 - 2 * lw) / mw));
  let sx = Math.round(160 - (2 * lw + n * mw) / 2);
  sheetFrame(ctx, 'NAMEPLAT', 0, sx, 162); sx += lw;
  for (let i = 0; i < n; i++, sx += mw) sheetFrame(ctx, 'NAMEPLAT', 1, sx, 162);
  sheetFrame(ctx, 'NAMEPLAT', 2, sx, 162);
  FONT.np.center(ctx, caption, 160, 165, npLut);
}

// Once-only woodcut gate, modelling the engine's shown-bitmask [0x540A]
// (test func_005418 / set func_0053DE, wrapper func_00543C): each plate fires
// once per game. `after` is where the dismissal lands -- a screen name, or a
// function for chains (the tribe-welcome popup); default is the map.
function woodcutOnce(n, after) {
  G.wcSeen = G.wcSeen || 0;
  if (G.wcSeen & (1 << n)) return false;
  G.wcSeen |= 1 << n;
  G.woodcut = n;
  G.wcAfter = after || null;
  G.screen = 'woodcut';
  return true;
}
// Tribe first contact (func_056C3E @0x056DA6): the plate is per TRIBE ID --
// Inca (0) 5, Aztec (1) 4, everyone else 3 -- followed by @INDIANWELCOME.
function firstTribeContact(v) {
  const t = G.tribes[v.tribe];
  if (t.met) return;
  t.met = true;
  const n = v.tribe === 0 ? 5 : v.tribe === 1 ? 4 : 3;
  G.eventTribe = v.tribe;
  woodcutOnce(n, () => {
    G.screen = 'village';
    // "We are a glorious nation of {N <settlements>}" -- the engine's plural
    // string is unread; levelname+'s' is the port's phrasing. The treaty
    // effect is now BYTE-READ (func_056C3E @0x56DCB, RULINGS 2026-08-07z9):
    // answering NO adjusts the tribe's tension by +100 -- straight to the
    // war band -- and fires @INDIANSHUN with the power's name (0xD6C(tribe,
    // ..., 0x64) @0x56DEF, emit 0x1811 @0x56E11); YES continues peacefully
    // (t.treaty). The per-tribe plate split (Inca 5 / Aztec 4 / else 3) is
    // also byte-confirmed at @0x56D95.
    const count = G.villages.filter(w => w.tribe === v.tribe).length;
    askEvent('INDIANWELCOME', {
      STRING0: t.name, NUMBER0: count,
      STRING1: `${DATA.levelname[t.level] || 'Camp'}s`,
    }, (choice) => {
      if (choice === 0) { t.treaty = true; return; }
      adjustTension(v.tribe, 100, 0);
      showEvent('INDIANSHUN', { STRING0: DATA.nations[G.nation].country });
    });
  });
}

// The scroll is GAME.TXT @VICEROY (@VICEROY2 for the Netherlands) laid out by
// its own directives @width=78 @x=232 @y=21: one 8px line per source line —
// blank `^` lines consume a slot — with `^^` lines centred in the column and
// the quoted body left-aligned at x=232.
function drawKing(ctx) {
  usePalette('KINGLSS1');
  ctx.drawImage(IMG.KINGLSS1, 0, 0);
  sheetAnchored(ctx, NATION_STEM[G.nation], 0);
  sheetAnchored(ctx, 'KING1', 0);

  const n = DATA.nations[G.nation];
  const src = (DATA.viceroy[G.nation === 3 ? 1 : 0] || '')
    .replace(/%COUNTRY/g, n.country).split('\n');
  const X = 232, WIDTH = 78, CX = X + WIDTH / 2, INK = lut(36);
  let y = 21;
  for (const raw of src) {
    const m = raw.match(/^\^*/)[0].length;
    const text = raw.slice(m).trim();
    if (text) {
      if (m >= 2) FONT.king.center(ctx, text, CX, y, INK);
      else for (const seg of wrapText(FONT.king, text, WIDTH)) {
        FONT.king.draw(ctx, seg, X, y, INK); y += 8;
      }
      if (m >= 2) y += 8;
    } else y += 8;
  }
  FONT.tiny.center(ctx, '(click to begin)', CX, 186, lut(0xFC), ink(0));
}

function wrapText(font, s, width) {
  const out = [];
  let line = '';
  for (const w of s.split(' ')) {
    const t = line ? line + ' ' + w : w;
    if (font.width(t) > width && line) { out.push(line); line = w; }
    else line = t;
  }
  if (line) out.push(line);
  return out;
}

// §6.11 -- O512 (func_067F50), the biome-edge blend. For each of the four
// cardinals N,E,S,W (dir 0..3) it compares the neighbour's terrain class with
// the centre's; where they differ it stamps stencil PHYS0 disk 0x68+dir and
// masked-blits the NEIGHBOUR's ground through it, so the neighbour bleeds into
// this tile's edge as a dither gradient. Every biome transition on the map comes
// from this one composer.
//
// The stencil is an INDEX-0 DOT stencil: decoding PHYS0 frame 0x68 gives 241
// pixels of index 253 and 15 of index 0, the 15 forming a sparse dither along
// the north edge. Those 15 are the mask -- and the plain PHYS0 atlas already IS
// that mask, because it keys out 253 and keeps index 0 opaque, so the frame
// arrives as 15 opaque dots on transparent. Compose with destination-in.
// (The PHYS0C atlas keys out BOTH 0 and 253, which leaves these four frames
// completely empty; using it here erased nothing and blitted the neighbour's
// whole tile -- which is what made the fog field render as open terrain.)
//
// Water centres skip it: their edges are the §6.7 coast composition. When a
// land centre's neighbour is water, the engine ring-walks that neighbour's
// cardinals W -> S -> E -> N and takes the first non-water class, which is what
// produces the dithered land-side beach.
const O512_DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]];        // N, E, S, W
const O512_RING = [[-1, 0], [0, 1], [1, 0], [0, -1]];        // W, S, E, N
const STENCIL_BASE = 0x68;
let _stencil = null;
function stencilBlit(ctx, dir, groundIdx, px, py) {
  if (!_stencil) {
    const c = document.createElement('canvas');
    c.width = TILE; c.height = TILE;
    _stencil = c.getContext('2d');
  }
  _stencil.globalCompositeOperation = 'source-over';
  _stencil.clearRect(0, 0, TILE, TILE);
  sheetFrame(_stencil, 'TERRAIN', groundIdx, 0, 0);
  _stencil.globalCompositeOperation = 'destination-in';
  sheetFrame(_stencil, 'PHYS0', STENCIL_BASE + dir, 0, 0);
  _stencil.globalCompositeOperation = 'source-over';
  ctx.drawImage(_stencil.canvas, px, py);
}
// `hidden` is O512's [bp+4]: 0 on the main path (0x68315), 1 on the fog path
// (0x68244, right after the 0x95 draw). It only enters the skip test — an edge
// is suppressed when the neighbour matches the centre in BOTH class and fog
// state, which is why a fogged tile still dithers an explored same-class
// neighbour into its edge, and why the open fog field stays flat.
function edgeBlend(ctx, mx, my, px, py, hidden) {
  const v = at(mx, my);
  const centreWater = tileWater(v);
  // Visible water centres skip the blend: their coast is the §6.7 composition
  // (shore + clean edges + 8x8 quadrants) that the 2026-08-04 ruling settled.
  if (centreWater && !hidden) return;
  const cls = groundFrame(v);
  for (let d = 0; d < 4; d++) {
    const [dx, dy] = O512_DIRS[d];
    const nx = mx + dx, ny = my + dy;
    if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) continue;   // is_xy_in_bounds
    let nv = at(nx, ny);
    // The ring walk is gated on [bp+6] = "centre is water", so it runs for land
    // centres only -- that is the land-side beach dither.
    if (tileWater(nv) && !centreWater) {
      let found = null;
      for (const [rx, ry] of O512_RING) {
        const w = at(nx + rx, ny + ry);
        if (!tileWater(w)) { found = w; break; }
      }
      if (found === null) continue;              // still water: no edge
      nv = found;
    }
    // The "still water" skip lives in the ring block's tail (@0x68120), so it
    // does not fire when the ring is disabled: an all-ocean fog boundary still
    // dithers, which is exactly what docs/screens/06_ingame_map.png shows.
    // An unexplored neighbour contributes nothing -- the fog path is defined as
    // blending EXPLORED neighbours in. Pinned on the live frame: the explored
    // patch's N-edge and S-edge tiles are pixel-identical to each other there,
    // so neither picked up anything from the fog they touch.
    if (!isSeen(nx, ny)) continue;
    // The class-equality skip is qualified by the centre's own fog state
    // ("same class with no fog", @0x68153). A fogged centre therefore still
    // dithers a same-class explored neighbour in, which is the all-ocean
    // boundary visible around the starting caravel.
    const ncls = groundFrame(nv);
    if (ncls === cls && !hidden) continue;
    stencilBlit(ctx, d, ncls, px, py);
  }
}

// ------------------------------------------------------------ tile compositor
// The O514 -> O513 -> O512 chain of §6.3-6.11. Implemented here: ground fold,
// the adjacency-masked forest / relief / river bands, river mouths, the coastal
// beach halo (clean edges + quadrant fallback), the O512 biome-edge dither and
// its fog path (§6.11), and the prime-resource detail band. Roads (§6.8) are
// drawn by drawImprovements as the hub + eight adjacency connectors from the
// improvement plane -- the same sprites the compositor band emits. No road can
// arrive any other way: VICEROY's own loader discards .MP layer 2
// (live-verified, RULINGS batch 7), so the improve plane is the only source.

// §6.7 — 8-direction land bitmap, bit d in order N, NE, E, SE, S, SW, W, NW.
const DIR8 = [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1]];
function landBits(mx, my) {
  let b = 0;
  for (let d = 0; d < 8; d++) {
    if (!tileWater(at(mx + DIR8[d][0], my + DIR8[d][1]))) b |= 1 << d;
  }
  return b;
}
// Clean-edge patterns (§6.7): pattern -1 means fall through to the quadrants.
function coastPattern(b) {
  if ((b & 0xDD) === 0xC1) return 0;
  if ((b & 0x77) === 0x07) return 1;
  if ((b & 0x77) === 0x70) return 2;
  if ((b & 0xDD) === 0x1C) return 3;
  return -1;
}
// Per-quadrant code, q = 0..3 = TL, TR, BR, BL: |=4 its own cardinal, |=1 the
// adjoining cardinal, |=2 its diagonal. The manual reads that middle term as
// "next-clockwise"; the sprites say otherwise -- q0's |=1 frame paints the TL
// cell's WEST edge, q1's paints the TR cell's NORTH edge, and so on, so the bit
// is the COUNTER-clockwise neighbour. Confirmed by diffing this compositor
// against docs/screens/colony_sites_live.png (see RULINGS.md 2026-08-04).
const Q_OWN = [0, 2, 4, 6];      // N, E, S, W
const Q_NEXT = [6, 0, 2, 4];     // W, N, E, S
const Q_DIAG = [7, 1, 3, 5];     // NW, NE, SE, SW
function quadCodes(b) {
  return [0, 1, 2, 3].map(q =>
    ((b >> Q_OWN[q]) & 1) * 4 | ((b >> Q_NEXT[q]) & 1) | ((b >> Q_DIAG[q]) & 1) * 2);
}
const Q_OFF = [[0, 0], [8, 0], [8, 8], [0, 8]];

// §6.7 beach halo: a coastal water tile is grounded with a cardinal land
// neighbour's terrain (visit order N, E, S, W -- W wins) and the coast frames
// paint the water back over it, leaving the land showing through their holes.
const HALO_DIRS = [[0, -1], [1, 0], [0, 1], [-1, 0]];
function haloGround(mx, my) {
  let g = -1;
  for (const [dx, dy] of HALO_DIRS) {
    const n = at(mx + dx, my + dy);
    if (!tileWater(n)) g = groundFrame(tileTerrain(n));
  }
  return g;
}

function drawTile(ctx, mx, my, px, py, scene) {
  // An unexplored tile is black. The visibility bit is sticky, so once seen a
  // tile stays drawn even with nothing standing near it.
  // §6.11 fog path (O513 @0x68212 -> @0x68244). An unexplored tile is NOT black:
  // it draws the fog sprite -- engine frame 0x95, a flat dark-blue mottle whose
  // striped hatching is what once got it mistaken for a plough overlay -- and
  // then runs O512 so explored neighbours dither into its edge. Both halves are
  // pixel-verified against docs/screens/06_ingame_map.png: every fog tile away
  // from the explored patch matches frame 0x94 exactly, and each fog tile
  // cardinally touching it differs by the stencil's ~15 dots.
  if (!isSeen(mx, my)) {
    sheetFrame(ctx, 'PHYS0', PHYS.FOG, px, py);
    edgeBlend(ctx, mx, my, px, py, true);
    return;
  }
  const v = at(mx, my);
  const water = tileWater(v);
  const ocean = groundFrame(tileTerrain(v));

  if (!water) {
    sheetFrame(ctx, 'TERRAIN', ocean, px, py);
    // O512 runs right after the ground so the neighbour dither sits under the
    // overlays, not over them (§6.11, call site 0x68315).
    edgeBlend(ctx, mx, my, px, py, false);
    // §6.4 forest, §6.5 relief, §6.6 river -- in O513's draw order.
    if (forestConnects(v)) {
      sheetFrame(ctx, 'PHYS0', PHYS.FOREST + mask4(mx, my, forestConnects), px, py);
    }
    if (tileMountains(v) || tileHills(v)) {
      const own = v & 0xA0;
      const base = tileMountains(v) ? PHYS.MOUNTAIN : PHYS.HILL;
      sheetFrame(ctx, 'PHYS0', base + mask4(mx, my, n => (n & 0xA0) === own), px, py);
    }
    const r = tileRiver(v);
    if (r) {
      const m = mask4(mx, my, riverConnects) || 0xF;   // isolated river forced to 0xF
      sheetFrame(ctx, 'PHYS0', (r === 2 ? PHYS.RIVER_MAJOR : PHYS.RIVER_MINOR) + m, px, py);
    }
    // The SCENE LATCH gate @0x683ED: O513 skips the detail sprites when
    // [0x18A] is set -- the colony area view never shows them. The rumour
    // medallion draw @0x68405 is NOT scene-gated.
    if (!scene) {
      const df = detailFrame(mx, my, v);
      if (df >= 0) sheetFrame(ctx, 'PHYS0', df, px, py);
    }
    // A Lost City Rumour square. Presence is computed, not stored, so the marker
    // is drawn wherever the hash says one stands.
    //
    // This used to sit at the very END of drawTile, on the tail the WATER branch
    // falls through to -- past the `return` above. Since rumourAt() rejects
    // water outright, the marker could never be drawn on any tile at all.
    //
    // Draw order detail (0x5A+v) -> rumour (0x68) -> roads (0x51+d) is byte-read
    // from O513: @0x683F7 detail, @0x68405..@0x68414 rumour, @0x68417 roads.
    // Land-only is behaviourally exact rather than a branch the engine has:
    // O513 @0x683C9 gates on [0x184]/[0x18E], NOT on the water flag [bp-4], so a
    // COASTAL water tile does reach the call at 0x68405 -- it just returns 0,
    // because func_006188's own class gate @0x61A6/@0x61AB rejects 0x19/0x1A.
    if (rumourAt(mx, my)) sheetFrame(ctx, 'PHYS0', PHYS.RUMOUR, px, py);
    drawImprovements(ctx, mx, my, px, py);
    return;
  }

  // --- water tile
  const bits = landBits(mx, my);
  if (!bits) {
    sheetFrame(ctx, 'TERRAIN', ocean, px, py);
  } else {
    const land = haloGround(mx, my);
    const pat = coastPattern(bits);
    if (pat >= 0) {
      sheetFrame(ctx, 'TERRAIN', land >= 0 ? land : ocean, px, py);
      sheetFrame(ctx, 'PHYS0C', PHYS.COAST_EDGE + pat, px, py);
    } else {
      // Quadrant fallback. These frames carry their own sand-and-water shore,
      // and their index-0 holes read as open water -- the halo substitution
      // shows through the clean-edge frames only. (Same diff as above: mode
      // "A" beat both alternatives on the live frame.)
      const codes = quadCodes(bits);
      sheetFrame(ctx, 'TERRAIN', ocean, px, py);
      for (let q = 0; q < 4; q++) {
        const [ox, oy] = Q_OFF[q];
        sheetFrame(ctx, 'PHYS0C', PHYS.QUADRANT + codes[q] * 4 + q, px + ox, py + oy);
      }
    }
  }
  // §6.6 river mouths: a water tile carrying its own river bits draws one frame
  // per cardinal neighbour that is land and has bit 0x40.
  if (v & 0xC0) {
    const base = (v & 0x80) ? PHYS.MOUTH_MAJOR : PHYS.MOUTH_MINOR;
    for (let d = 0; d < 4; d++) {
      const n = at(mx + HALO_DIRS[d][0], my + HALO_DIRS[d][1]);
      if ((n & 0x40) && !tileWater(n)) sheetFrame(ctx, 'PHYS0', base + d, px, py);
    }
  }
  const df = detailFrame(mx, my, v);
  if (df >= 0) sheetFrame(ctx, 'PHYS0', df, px, py);
  drawImprovements(ctx, mx, my, px, py);
}
// Roads are their own layer (@0x6842B, base engine 0x51 + an 8-direction
// connectivity mask, func_067D54 -- brown, and empty on a new map). On disk
// that base is 0x50: 0x50 is the isolated junction stub, 0x51..0x58 are the
// eight spokes in the N, NE, E, SE, S, SW, W, NW order the sheet itself shows
// (rendered and read off the art). A colony counts as a road end, which is what
// makes a road into a colony connect.
//
// A plowed field has no dedicated frame anywhere in PHYS0 -- the byte-verified
// band list (spec/systems/map_system.md, func_0681A8/func_067A24) has river,
// road, mountain, hill, forest, coast, fog, detail and mouth layers and no plow
// layer at all -- so the port marks it with furrows in the ploughed-earth tone
// rather than borrowing a sprite that means something else. STILL INVENTED,
// still flagged in docs/UI_AUDIT_TRACKER.md: what the original draws for a
// plowed tile is UNKNOWN, not "this".
//
// Widened 2026-08-19 from a single 4-dot row at py+12 to three staggered rows
// across the tile. The one row was reported from the board as "off and mostly
// hidden", which it was: 4 dark pixels on the bottom edge of a 16px tile, under
// whatever unit or colony sprite lands on it. Three rows read as furrows at a
// glance and survive a unit standing on the tile. This changes only how big the
// invention is, not its status.
function drawImprovements(ctx, mx, my, px, py) {
  if (hasRoad(mx, my)) {
    sheetFrame(ctx, 'PHYS0', PHYS.ROAD, px, py);
    for (let d = 0; d < 8; d++) {
      const nx = mx + DIR8[d][0], ny = my + DIR8[d][1];
      if (hasRoad(nx, ny) || colonyAt(nx, ny))
        sheetFrame(ctx, 'PHYS0', PHYS.ROAD + 1 + d, px, py);
    }
  }
  if (hasPlow(mx, my)) {
    ctx.fillStyle = ink(0x55);
    for (let r = 0; r < 3; r++)
      for (let k = 0; k < 4; k++)
        ctx.fillRect(px + 2 + k * 3 + (r & 1), py + 5 + r * 4, 2, 1);
  }
}

// §26.7 — viewport (0,8,240,192) 15x12 @16px; sidebar right; menu bar on top.
const VP = { x: 0, y: 8, w: 240, h: 192 };
let _zoomBuf = null;
function zoomBuffer(cols, rows) {
  const w = cols * TILE, h = rows * TILE;
  if (!_zoomBuf || _zoomBuf.canvas.width !== w || _zoomBuf.canvas.height !== h) {
    const c = document.createElement('canvas');
    c.width = w; c.height = h;
    _zoomBuf = c.getContext('2d');
  }
  _zoomBuf.clearRect(0, 0, w, h);
  return _zoomBuf;
}

function drawMap(ctx) {
  // The map screen's chrome is WOODTILE.SS frame 0 (32x24) tiled from the
  // screen origin -- a fine, repeating grain -- NOT the big-swirl WOODPANL.PIK
  // panel used by the full-screen dialogs. Scored against
  // docs/screens/06_ingame_map.png over a text-free sidebar patch: WOODTILE
  // tiled at phase (0,0) = 2.90 mean channel error, WOODPANL = 11.91,
  // OPENTILE = 8.05. (map_view.md's "Sidebar bg: WOODPANL.PIK" is wrong.)
  usePalette('WOODTILE');
  const [tw, th] = frameSize('WOODTILE', 0);
  for (let y = 0; y < H; y += th)
    for (let x = 0; x < W; x += tw) sheetFrame(ctx, 'WOODTILE', 0, x, y);
  ctx.fillStyle = ink(0);
  ctx.fillRect(VP.x, VP.y, VP.w, VP.h);
  const cols = VIEW_COLS(), rows = VIEW_ROWS();
  // Tiles are only drawn at their native 16px, so a zoomed-out view composes
  // the whole span offscreen and scales it into the same 240x192 viewport.
  const tgt = G.zoom === 0 ? ctx : zoomBuffer(cols, rows);
  const ox = G.zoom === 0 ? VP.x : 0, oy = G.zoom === 0 ? VP.y : 0;
  for (let ty = 0; ty < rows; ty++)
    for (let tx = 0; tx < cols; tx++)
      drawTile(tgt, G.view.x + tx, G.view.y + ty, ox + tx * TILE, oy + ty * TILE);
  // Colonies: ICONS disk band 0-3 are the colony map markers, frame = nation.
  for (const c of G.colonies) {
    const tx = c.x - G.view.x, ty = c.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    const px = ox + tx * TILE, py = oy + ty * TILE;
    drawSettlement(tgt, px, py, colonyLevel(c), c.nation, 0);
    if (G.zoom === 0) colonyMarkerExtras(ctx, px, py, c);
  }

  // Native settlements and units.
  for (const v of G.villages) {
    const tx = v.x - G.view.x, ty = v.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    if (!isSeen(v.x, v.y)) continue;
    drawSettlement(tgt, ox + tx * TILE, oy + ty * TILE, v.level, -1,
                   (G.tribes[v.tribe] || {}).color || 8, v.mission);
    // §19.6: the map shows the village's war stance as exclamation marks. The
    // strip is byte-read off the village painter, and the MARK COUNT is now
    // RESOLVED (2026-08-07e -- 0x181F:0x316 = func_0460F8, disassembled):
    //   * the marks show the RAID-TARGET SCORE, not the alarm: the painter
    //     calls the scorer and loops `draw; XB += 2; score -= 4` while the
    //     score stays >= 0 (@0x419F-0x41A7), so count = floor(score/4) + 1
    //   * no viable target (scorer returns < 0) -> no marks at all @0x409F
    //   * the ALARM picks only the COLOUR: level = min(3, alarm >> 5)
    //     (@0x40C6, the alarm word [0x54F6]), tension >= 75 forces level 3
    //     (@0x40DD via 0x5DC:0xE0), colours 0x0A/0x0B/0x0E/0x0C
    //   * a mark drawn while the REMAINING score is <= 2 dims -8 (@0x412F)
    //   * mark shape: 3x7 backing rect at (XB, py+4), 1x5 bar + dot inside,
    //     from XB = px+6 (@0x4126-0x419F)
    if (G.zoom === 0) {
      const rt = raidTargetScore(v);
      if (rt.score >= 0) {
        const alarm = v.alarm || 0;
        const tension = (G.tribes[v.tribe] || {}).tension || 0;
        const level = tension >= 75 ? 3 : Math.min(3, alarm >> 5);
        const colour = [0x0A, 0x0B, 0x0E, 0x0C][level];
        const px2 = ox + tx * TILE, py2 = oy + ty * TILE;
        let xb = px2 + 6;
        for (let s = rt.score; s >= 0; s -= 4) {
          const c2 = s <= 2 ? colour - 8 : colour;
          ctx.fillStyle = ink(0);
          ctx.fillRect(xb, py2 + 4, 3, 7);
          ctx.fillStyle = ink(c2);
          ctx.fillRect(xb + 1, py2 + 5, 1, 4);
          ctx.fillRect(xb + 1, py2 + 9, 1, 1);
          xb += 2;
        }
      }
      // The ICONS-17 sparkle overlay is the CAPITAL marker: the painter tests
      // settlement flags bit 0x04 (`test [0x54EF],4` @0x4051), the byte
      // DATA_MODEL's runtime dumps identify as the capital flag -- which
      // closes the old "sparkle trigger unknown" TBD.
      if (v.capital) {
        const px2 = ox + tx * TILE, py2 = oy + ty * TILE;
        sheetFrame(tgt, 'ICONS', 17, px2, py2);
      }
    }
  }
  // Braves and rival units draw through the SHARED func_00386A composite
  // like every other map unit, and colony tiles hide their occupants.
  for (const n of G.natives) {
    const tx = n.x - G.view.x, ty = n.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    if (!isSeen(n.x, n.y)) continue;
    if (onAnyColony(n.x, n.y)) continue;
    unitPanel(tgt, ox + tx * TILE, oy + ty * TILE, 16, n.type,
              n.flags || 0, n.orders || 0, ownerColour(n), unitIconOf(n));
  }

  // Rival powers: their colonies and units, in their own @COUNTRY colours.
  for (const r of G.rivals) {
    for (const rc of r.colonies) {
      const tx = rc.x - G.view.x, ty = rc.y - G.view.y;
      if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
      if (!isSeen(rc.x, rc.y)) continue;
      drawSettlement(tgt, ox + tx * TILE, oy + ty * TILE, rc.level, rc.nation, 0);
      // func_004314 draws the number + name for EVERY colony -- the MAP
      // census baseline shows St. Louis (French) wearing both.
      if (G.zoom === 0)
        colonyMarkerExtras(ctx, ox + tx * TILE, oy + ty * TILE,
                           { name: rc.name, colonists: { length: rc.pop },
                             recFlags1c: rc.recFlags1c || 0 });
    }
    for (const ru of r.units) {
      const tx = ru.x - G.view.x, ty = ru.y - G.view.y;
      if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
      if (!isSeen(ru.x, ru.y)) continue;
      if (onAnyColony(ru.x, ru.y)) continue;
      unitPanel(tgt, ox + tx * TILE, oy + ty * TILE, 16, ru.type,
                unitFlags(ru), ru.orders || 0, ownerColour(ru), unitIconOf(ru),
                ownerPower(ru));
    }
  }

  // The King's Royal Expeditionary Force. It is not one of the four European
  // powers -- the Crown becomes its own power at the war transition -- so it
  // wears its own plate colour rather than a @COUNTRY one.
  for (const ru of G.refUnits) {
    const tx = ru.x - G.view.x, ty = ru.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    if (onAnyColony(ru.x, ru.y)) continue;
    unitPanel(tgt, ox + tx * TILE, oy + ty * TILE, 16, ru.type,
              unitFlags(ru), ru.orders || 0, KING_COLOUR, unitIconOf(ru), 0x0F);
  }

  // Units, selected one last so a stack draws it on top.
  const order = G.units.map((u, i) => i).sort((a, b) => (a === G.sel) - (b === G.sel));
  for (const i of order) {
    const u = G.units[i];
    const tx = u.x - G.view.x, ty = u.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    drawUnit(tgt, u, ox + tx * TILE, oy + ty * TILE);
  }
  if (G.zoom !== 0) {
    ctx.imageSmoothingEnabled = false;
    ctx.drawImage(tgt.canvas, 0, 0, cols * TILE, rows * TILE, VP.x, VP.y, VP.w, VP.h);
  }
  drawMenuBar(ctx);
  drawSidebar(ctx);
  // The pulldown is drawn AFTER the sidebar: COLONIZOPEDIA's menu overhangs the
  // minimap panel, and drawing it with the bar put the minimap on top of it.
  if (G.openMenu >= 0) drawPulldown(ctx);
  drawDialog(ctx);
}

// The bar is not a filled strip: the wood panel shows straight through, with a
// black 1px rule at y=7 and FONTTINY titles in the HUD green (index 68). CHEAT
// is hidden until the Alt-W/I/N combo, so it is absent here. Title pen origins
// are pixel-measured from docs/screens/06_ingame_map.png (§ map_view.md item 4
// notes the C-recon x-table is low trust; pixels win per the trust hierarchy).
const HUD_INK = 68;
// Every unit on the map wears its owner's nation plate: an 8x9 box at the
// tile's top-left, 1px black outline, filled with the power's @COLORS byte and
// carrying the @ORDERS status letter ("-" No Orders, "S" Sentry, "F" Fortified,
// ...). The unit sprite sits bottom-right in the tile, overlapping the plate's
// right edge. Geometry pixel-measured from docs/screens/06_ingame_map.png.
// The plate identifies the owner by colour. European powers use
// @COUNTRY.color (England 12 red, France 9 blue, Spain 14 yellow, Netherlands
// 13 orange); the tribes use @TRIBES' `value` column, which is the same kind of
// palette index and resolves to eight distinct colours. Natives get the plate
// too, so ownership reads the same way across the map.
// The Crown's own plate colour. It is not in @COUNTRY -- the King is a fifth
// power that only exists once the war starts -- so the port uses the @COLORS
// border white, which is what the REF plates read as in the DOS captures.
const KING_COLOUR = 128;
function ownerColour(u) {
  if (u.nation === -2) return KING_COLOUR;
  if (u.nation >= 0) return DATA.nations[u.nation].color;
  const t = G.tribes[u.tribe];
  return t ? t.color : 8;
}
// func_00386A @0x00386A -- the unit-info panel composite, mode 0x64.
//
// Full decode in spec/ui/render_primitives.md §1b. What matters here:
//
//   plate w = strwidth(status letter) + 3      (0xC2A:6 @0x003AA8)
//   plate h = font height + 3                  (@0x003ABC)
//   dx0     = x + max(0, (W - (pw + sw)) / 2)  (@0x003B23)
//   dx      = dx0 + sw, less (pw + sw - 16) when that exceeds 16
//                                              (@0x003BF5-@0x003C07)
//
// and then, by unit CLASS (@0x003C09):
//   0 foot     plate (dx, y + sh - ph)    sprite dx0, drawn AFTER the plate
//   1 big ship plate (dx, y)              sprite dx0, drawn BEFORE
//   2 wheeled  plate (dx0 - pw/2 + 9, y)  sprite dx0, drawn BEFORE
//   4 = 2 with y + 2 (damaged artillery)
//   3 mounted  plate (dx0, y)             sprite dx0 + pw, pulled back by
//     + small ships                       (pw + sw - 14) when pw + sw + 2 > 16
//
// The plate is a rect of colour 0, a rect inset 1 and 2 smaller in the owner
// colour, and the letter at +2/+2 (@0x003D1C-@0x003D66, @0x003DF8).
//
// The runtime 12-byte sheet table at es:[bx+0x3E] holds the frame's TRIMMED
// width (settled empirically: an adjustment sweep scores 0 > -1 > -2), so the
// port's trimmed frame size IS the engine's. Ship rows enter the shared panel
// verb (0x181F:0x2BC) at func_03954C @0x039843 with bx = [bp-0x56] = 2 (the
// row x); sea-borne LAND units enter at @0x039574 with bx = [bp-0x56]+0x56 =
// 88 (the cargo column). The previously FITTED anchor 4 was compensating for
// func_00380C's own +2 sprite offset, now modelled in unitPanel().
const F7_PANEL_X = 2;
function panelClass(type, flags) {
  switch (DATA.units.findIndex(r => r.name === type)) {
    case 0x0F: case 0x10: case 0x11: case 0x12: return 1;
    case 0x0A: case 0x0C:                       return 2;
    case 0x0B:            return (flags & 0x80) ? 4 : 2;
    case 0x0D: case 0x0E: case 0x04: case 0x05:
    case 0x07: case 0x08: case 0x15: case 0x16: return 3;
    default:                                    return 0;
  }
}
// owner = the power index (0..3 nations, 4..11 tribes, 0xF the Crown): the
// letter ink rule @0x003D96-@0x003DD6 tests it, not the colour.
const ownerPower = (u) => u.nation === -2 ? 0x0F
  : u.nation >= 0 ? u.nation : ((u.tribe | 0) + 4);
// The composite's +0x04 flags input with the LIVE damaged bit (0x80): the
// port keeps damage in u.damaged (the importer maps the SAV bit there for
// ships and artillery and the sim maintains it), so the byte handed to the
// panel is rebuilt from it -- the same helper the C uses off CR.unit_damaged.
const unitFlags = (u) => ((u.flags || 0) & 0x7F) | (u.damaged ? 0x80 : 0);
function unitPanel(ctx, x, y, W, type, flags, orders, colourIdx, frame, owner,
                   mode = 0x64) {
  if (mode !== 0x64) {
    // The mode dispatch @0x003B32-@0x003B44: mode - 0x19 == 0 -> the 0x19
    // path, - 0x19 again == 0 -> the 0x32 path, anything else -> a 2x2
    // owner box at (x, y) (@0x003B46-@0x003B5B). None of these draws the
    // silhouette, the plate or the letter.
    if (mode === 0x32) {
      // @0x003AF8-@0x003B11: 0xC83:2 = func_00EC32 scales the record --
      // w' = (w*pct + 50) / 100, h' likewise (@0x00EC4D-@0x00EC72) -- and
      // [bp-8] = w', so the shared centring @0x003B23 is against w' alone:
      // x_c = x + ((W - w') >> 1) when W > w'. Then @0x003B6C-@0x003BAB: a
      // 2x2 box at (x+5, y+5) in the owner colour ([bp-0xF] = the
      // [0x848+power] byte @0x003A0A) and the half-size sprite through
      // 0xC56:4 = func_00E964 at CENTRE x_c + (w' >> 1), BOTTOM y + h' - 1
      // (@0x003B94-@0x003BA2), pct = mode.
      const [sw, sh] = frameSize('ICONS', frame);
      const w2 = Math.floor((sw * mode + 50) / 100);
      const h2 = Math.floor((sh * mode + 50) / 100);
      const xc = x + (W > w2 ? ((W - w2) >> 1) : 0);
      sheetFrameScaled(ctx, 'ICONS', frame, xc + (w2 >> 1), y + h2 - 1, mode);
      ctx.fillStyle = ink(colourIdx); ctx.fillRect(x + 5, y + 5, 2, 2);
    } else if (mode === 0x19) {
      ctx.fillStyle = ink(colourIdx); ctx.fillRect(x + 1, y + 1, 2, 2); // @0x003B5E
    } else {
      ctx.fillStyle = ink(colourIdx); ctx.fillRect(x, y, 2, 2);         // @0x003B46
    }
    return;
  }
  const key = (DATA.orders[orders] || DATA.orders[0]).key;
  const pw = FONT.tiny.width(key) + 3, ph = FONT.tiny.height + 3;
  const [sw, sh] = frameSize('ICONS', frame);
  const total = pw + sw;
  const dx0 = x + (W > total ? Math.floor((W - total) / 2) : 0);
  let dx = dx0 + sw;
  if (pw + sw > 16) dx -= (pw + sw - 16);
  const cls = panelClass(type, flags);
  let px, py, sx = dx0, after = false;
  switch (cls) {
    case 1: px = dx; py = y; break;
    case 2: px = dx0 - (pw >> 1) + 9; py = y; break;
    case 4: px = dx0 - (pw >> 1) + 9; py = y + 2; break;
    case 3:
      px = dx0; py = y; sx = dx0 + pw;
      if (pw + sw + 2 > 16) sx -= (pw + sw - 14);
      break;
    default: px = dx; py = y + sh - ph; after = true; break;
  }
  // func_00380C, the two-layer sprite draw: layer 1 is the frame as a SOLID
  // BLACK SILHOUETTE at (x, y) (@0x003829-@0x003834), layer 2 the real sprite
  // at (x + 2, y) (`lea dx, [di + 2]` @0x003854) -- a black shadow copy with
  // the sprite two pixels right of it. The class-0 path defers layer 1 until
  // after the plates (@0x003D71); every class draws layer 2 last (@0x003D80).
  if (!after) sheetSilhouette(ctx, 'ICONS', frame, sx, y, 0);
  ctx.fillStyle = ink(0); ctx.fillRect(px, py, pw, ph);
  ctx.fillStyle = ink(colourIdx); ctx.fillRect(px + 1, py + 1, pw - 2, ph - 2);
  if (after) sheetSilhouette(ctx, 'ICONS', frame, sx, y, 0);
  sheetFrame(ctx, 'ICONS', frame, sx + 2, y);
  // The LETTER INK (the tail @0x003D96-@0x003DD9, C4.27 2026-09-02):
  // [bp-0x1f] starts as the owner colour byte [0x848+power] (@0x003A04) and
  // becomes 0 (black) for every order EXCEPT Sentry (1) and Fortified (6)
  // (@0x003D96-@0x003DA2); for those it is colour - 8 when the power is a
  // nation (< 4, @0x003DAA-@0x003DB0) and 8 otherwise (@0x003DB6). A
  // DAMAGED unit ([bp-0x18]: +0x04 bit 0x80 and type != 0x0B, @0x003A17-
  // @0x003A30) overrides to 0xC for power 2, 0xF for the rest (@0x003DC4-
  // @0x003DD6). The verb gets 0xC28:0xA(ax=0xFFFF, dx=bx=ink) then
  // 0xC11:0xC at (px+2, py+2) (@0x003DDF-@0x003E08); FONTTINY's letters
  // are level-1-only glyphs, so every painted level is the ink. The census
  // EUROPE frame shows the three sentried riders' 'S' in index 5 = 13 - 8
  // (the Dutch orange less 8); the port drew every letter black.
  // NOT modelled ([bp-0x1e], @0x003924-@0x003955): a foreign ship's letter
  // is its cargo COUNT as a digit, 'X' for a Frigate under [0x53a2] == 0,
  // ink 0xF -- FLAGGED.
  let li = 0;
  if (orders === 1 || orders === 6) li = owner < 4 ? colourIdx - 8 : 8;
  if ((flags & 0x80) && DATA.units.findIndex(r => r.name === type) !== 0x0B)
    li = owner === 2 ? 0x0C : 0x0F;
  FONT.tiny.draw(ctx, key, px + 2, py + 2, [ink(li), ink(li), ink(li)]);
}
function nationPlate(ctx, x, y, colourIdx, orders) {
  ctx.fillStyle = ink(0); ctx.fillRect(x, y, 8, 9);
  ctx.fillStyle = ink(colourIdx); ctx.fillRect(x + 1, y + 1, 6, 7);
  const key = (DATA.orders[orders] || DATA.orders[0]).key;
  FONT.tiny.center(ctx, key, x + 4, y + 2, [ink(0), ink(0), ink(0)]);
}
// func_004314 (0x181F:0x2A8, the colony marker painter) full-size extras:
// the POPULATION NUMBER left-aligned at (px+7, py+7) in ink 0xF -- or 0xA
// when ColonyRecord +0x1C bit 4, 0xB when bits 4 and 2 (@0x00448B-@0x0044EF)
// -- and the NAME left-aligned at (px+2, py+16) in ink 0xF (@0x0044FA-
// @0x004529). Both gated on the full-size mode (si == 0x64 @0x004483); the
// si <= 0x19 path is the minimap dot. The old centred name was a guess; the
// MAP census baseline measures Isabella's "2" at tile-relative (7,7) and the
// labels left-anchored.
function colonyMarkerExtras(ctx, px, py, c) {
  const pop = (c.colonists || []).length;
  const f = c.recFlags1c || 0;
  const ik = (f & 4) ? ((f & 2) ? 0x0B : 0x0A) : 0x0F;
  // Number font = [0x89E] = FONTTINY, name font = [0x268A] = FONTINTR
  // (spec/ui/fonts_and_colors.md's byte-verified pointer table). FLAT
  // single-colour glyphs: the text verb gets (ink, shadow) with no ramp
  // (0xC28:0xA args dx=0xF bx=0 @0x0044FC), and the baseline's label
  // pixels are pure white + black only.
  FONT.tiny.draw(ctx, String(pop), px + 7, py + 7,
                 [ink(ik), ink(ik), ink(0)]);
  // NO drop shadow: the baseline's glyphs carry only the font's own
  // class-3 black outline -- the 3-offset shadow block read far heavier.
  FONT.intr.draw(ctx, c.name, px + 2, py + 16,
                 [ink(0x0F), ink(0x0F), ink(0)]);
}
function onAnyColony(x, y) {
  if (G.colonies.some(c => c.x === x && c.y === y)) return true;
  return G.rivals.some(r => r.colonies.some(c => c.x === x && c.y === y));
}
function drawUnit(ctx, u, px, py) {
  // The active unit blinks: the engine flashes the unit graphic itself on and
  // off so the tile beneath shows through. There is no selection outline.
  if (G.units[G.sel] === u && !G.blink) return;
  // A unit standing on a COLONY tile is INSIDE the colony and does not draw
  // on the map -- the census MAP baseline shows San Salvador bare while the
  // port stacked the docked Galleon over it.
  if (onAnyColony(u.x, u.y)) return;
  // The map tile draws through the SHARED func_00386A composite: the
  // baseline's ships wear the class-1 plate at the sprite's top-RIGHT with
  // the silhouette layer, exactly like the sidebar and the dock.
  unitPanel(ctx, px, py, 16, u.type, unitFlags(u), u.orders || 0,
            ownerColour(u), unitIconOf(u), ownerPower(u));
}

const BAR_TITLES = [['GAME', 17], ['VIEW', 49], ['ORDERS', 81],
                    ['REPORTS', 119], ['TRADE', 161], ['COLONIZOPEDIA', 259]];
function drawMenuBar(ctx) {
  // Black separators, measured on docs/screens/06_ingame_map.png: a full-width
  // row at y=7 under the menu bar, and a full-height column at x=240 between
  // the viewport and the sidebar. Those are the only two on this screen.
  ctx.fillStyle = ink(0);
  ctx.fillRect(0, 7, W, 1);
  ctx.fillRect(240, 8, 1, H - 8);
  BAR_TITLES.forEach(([t, x], i) => {
    if (i === G.openMenu) {
      ctx.fillStyle = ink(0x37);
      ctx.fillRect(x - 2, 0, FONT.tiny.width(t) + 4, 7);
    }
    FONT.tiny.draw(ctx, t, x, 1, lut(HUD_INK));
  });
}
// The pulldowns, REBUILT against the census captures (docs/screens/census/
// census_menu_*.png, 2026-08-08): the engine draws each menu in GROUPS
// separated by a thin green rule, HIDES rows the selected unit's class can
// never use (a frigate gets no Build Colony row at all), DIMS rows merely
// inapplicable right now (Load Cargo away from a colony), and folds Clear
// Forest / Plow Fields into ONE row whose label follows the active unit's
// tile. Only one of MENU.TXT's two Fortify rows is shown. The grouping and
// gating below are CAPTURE-DERIVED (frigate + wagon frames); the engine's own
// gating tables are unread -- FLAGGED.
const MENU_SEP_H = 7;
const MENU_GROUP_LABELS = {
  GAME: [['Game Options', 'Colony Report Options'], ['Sound Options', 'Pick Music'],
         ['Save Game', 'Load Game'], ['Declare Independence'], ['Retire', 'Exit to DOS']],
  VIEW: [['Move Pieces', 'View Pieces', 'European Status'], ['Find Colony'],
         ['Zoom In', 'Zoom Out'], ['Zoom Level'], ['Show Hidden Terrain', 'Center View']],
  REPORTS: [['F1'], ['F2', 'F3', 'F4', 'F5'], ['F6', 'F7', 'F8', 'F9'], ['F10']],
};
// The sea-lane gate on Return to Europe: the census frigate mid-Ocean shows
// the row DIMMED, so the menu enables it only on the sea-lane column
// (terrain 26). Capture-derived; the engine's own test is unread. FLAGGED.
const onSeaLane = (u) => (at(u.x, u.y) & 0x1F) === 26;
// The nearest sea-lane square, by Chebyshev distance -- ships step 8-way, so
// that IS the turn count. GAME_MANUAL.md p18/p57: a ship bound for Europe
// "must enter a Sea Lane square on the map display, then move toward the
// nearest map edge", so the lane is where a crossing BEGINS and a ship
// ordered home from open water has to sail there under its own power first.
// Ties break on the first square in scan order, which keeps the C port on
// the same answer.
function nearestSeaLane(u) {
  let best = null, bd = Infinity;
  for (let y = 0; y < MAP.h; y++)
    for (let x = 0; x < MAP.w; x++) {
      if ((at(x, y) & 0x1F) !== 26) continue;
      const d = Math.max(Math.abs(x - u.x), Math.abs(y - u.y));
      if (d < bd) { bd = d; best = [x, y]; }
    }
  return best;
}
// "Return to Europe" from anywhere on the map. A ship already ON the lane
// leaves at once; one in open water is ordered to the NEAREST lane and starts
// its crossing the moment it arrives (advanceGoTo). Until 2026-08-17 the port
// took the ship off the map from wherever it stood, which is neither the
// manual's model nor what the player sees. Returns true when the crossing
// began this instant -- the callers use that to decide whether to open the
// Europe screen.
function orderSailHome(u) {
  if (onSeaLane(u)) {
    sailForEurope(u);
    G.euroMsg = `${u.type} sails for ${DATA.nations[G.nation].homeport}.`;
    return true;
  }
  const lane = nearestSeaLane(u);
  if (!lane) { G.msg = `${u.type} can find no sea lane.`; return false; }
  u.sailHome = true;
  setGoTo(u, lane[0], lane[1]);
  G.msg = `${u.type} makes for the sea lane.`;
  return false;
}
function ordersMenuRows() {
  const u = G.units[G.sel];
  if (!u) return DATA.menus[2].rows.map(r => ({ label: r.label, cmd: r.label, dim: true }));
  const ship = !!u.ship;
  const atOwn = !!colonyAt(u.x, u.y);
  const carrier = (Number((unit(u.type) || {}).cargo) || 0) > 0;
  const pioneer = /Pioneer/.test(u.type || '');
  const founder = !ship && !NOT_COLONISTS.includes(u.type);
  const forest = !ship && isForested(tileTerrain(at(u.x, u.y)));
  const hold = (u.hold || []).length > 0 || (u.cargo || []).length > 0;
  const out = [];
  const push = (label, dim, cmd) => out.push({ label, cmd: cmd || label, dim: !!dim });
  const sep = () => out.push({ sep: true });
  push('Activate unit'); push('Wait for next unit'); push('Fortify'); push('Sentry');
  sep();
  if (founder) { push('Build Colony'); push('Join Colony (B)'); }
  if (forest) push('Clear Forest (P)', !pioneer);
  else push('Plow Fields  (P)', ship || !pioneer);
  push('Build Road', ship || !pioneer);
  push('Load Cargo', !(carrier && atOwn));
  push('Unload Cargo', !(carrier && atOwn && hold));
  sep();
  push(ship ? 'Go to Port' : 'Go to Place');
  push('Begin Trade Route');
  if (ship) push('Return to Europe', !onSeaLane(u));
  if (founder) push('Pillage');
  sep();
  push('No Orders (space bar)');
  sep();
  push('Dump Cargo Overboard', !hold);
  push('Disband Unit (shift-D)');
  return out;
}
function menuVisibleRows(mi) {
  const m = DATA.menus[mi];
  const title = (BAR_TITLES[mi] || [])[0];
  if (title === 'ORDERS') return ordersMenuRows();
  const flat = (r) => ({ label: r.label, cmd: r.label,
                         dim: r.disabled || !COMMANDS[r.label], accel: r.accel });
  const spec = MENU_GROUP_LABELS[title];
  if (!spec) return m.rows.map(flat);
  const used = new Set();
  const out = [];
  spec.forEach((prefixes) => {
    const rows = m.rows.filter(r => !used.has(r) &&
                                    prefixes.some(p => r.label.startsWith(p)));
    if (!rows.length) return;
    if (out.length) out.push({ sep: true });
    rows.forEach(r => { used.add(r); out.push(flat(r)); });
  });
  m.rows.forEach(r => { if (!used.has(r)) out.push(flat(r)); });
  return out;
}
function pulldownBox(mi) {
  const rows = menuVisibleRows(mi);
  let w = 0;
  for (const r of rows) if (!r.sep) w = Math.max(w, FONT.tiny.width(r.label));
  w += 16;
  const x = Math.min(BAR_TITLES[mi][1] - 2, W - w - 2);
  const h = rows.reduce((n, r) => n + (r.sep ? MENU_SEP_H : 8), 0) + 4;
  return { x, y: 8, w, h, rows };
}
function drawPulldown(ctx) {
  const m = DATA.menus[G.openMenu], b = pulldownBox(G.openMenu);
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  let y = b.y + 2;
  b.rows.forEach((r, k) => {
    if (r.sep) {
      ctx.fillStyle = ink(HUD_INK);
      ctx.fillRect(b.x + 2, y + 3, b.w - 4, 1);
      y += MENU_SEP_H;
      return;
    }
    const sel = k === G.menuSel;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 2, y, b.w - 4, 8); }
    const dim = r.dim;
    const base = dim ? 0x2F : (sel ? 0xFC : 0xFE);
    // DECLARE INDEPENDENCE draws in capitals (census GAME frame).
    const label = /^Declare Independence/.test(r.label) ? r.label.toUpperCase() : r.label;
    const src = m.rows.find(q => q.label === r.label);
    const ai = src && src.accel ? label.toUpperCase().indexOf(src.accel) : -1;
    let x = b.x + 6;
    if (ai < 0 || dim) FONT.tiny.draw(ctx, label, x, y + 1, lut(base));
    else {
      x = FONT.tiny.draw(ctx, label.slice(0, ai), x, y + 1, lut(base));
      x = FONT.tiny.draw(ctx, label[ai], x, y + 1, lut(0x0E));
      FONT.tiny.draw(ctx, label.slice(ai + 1), x, y + 1, lut(base));
    }
    y += 8;
  });
}
// Which menu-bar title sits under x, or -1 (the same 2px-padded spans the
// click path always used).
function barTitleAt(mx) {
  for (let i = 0; i < BAR_TITLES.length; i++) {
    const [t, x] = BAR_TITLES[i];
    if (mx >= x - 2 && mx < x + FONT.tiny.width(t) + 2) return i;
  }
  return -1;
}
function openMenu(mi) {
  G.openMenu = mi;
  const rows = menuVisibleRows(mi);
  G.menuSel = rows.findIndex(r => !r.sep);
}
function runMenuRow() {
  const rows = G.openMenu >= 0 ? menuVisibleRows(G.openMenu) : [];
  const r = rows[G.menuSel];
  G.openMenu = -1;
  // Disabled rows are skipped, the engine's own rule (`node[0] & 1` skip
  // @0x06E64E) -- a release or Enter on a dimmed row does nothing.
  if (!r || r.sep || r.dim) return;
  // Every MENU.TXT row across the six pulldowns is bound (test_flow asserts
  // it), so the guard is only here to keep an edited MENU.TXT from throwing.
  const fn = COMMANDS[r.cmd];
  if (fn) fn();
  else G.msg = `${r.label}: no handler for this MENU.TXT row.`;
}

// The original labels a unit riding in a hold by its EQUIPMENT or veteran
// status, not by its @UNIT type name: the opening turn's caravel manifest reads
//     Veteran      Sentry
//     100 Tools    Sentry
// not "Soldiers"/"Pioneers" (live DOSBox frame
// docs/screens/live_2026-08-05/07_map_opening_turn.png). "Veteran" is @MISC 65
// -- the first of the three expertise words Veteran/Seasoned/Learned -- and
// "Tools" is @CARGO 14, so the tools line is `<count> <cargo name>`.
//
// Verified for the two units of the starting force only. What a *non*-veteran
// Soldiers or some other carried type shows is TBD, so anything else falls
// back to the type name rather than being guessed at.
const TOOLS_CARGO = 14, MISC_VETERAN = 65;
function carriedLabel(entry) {
  const typeName = typeof entry === 'object' ? entry.type : entry;
  if (typeName === 'Pioneers')
    return `${PIONEER_TOOLS} ${DATA.cargo[TOOLS_CARGO].name}`;
  if (typeName === 'Soldiers') return DATA.text.misc[MISC_VETERAN];
  return typeof entry === 'object' ? entry.name : typeName;
}

// The SAMPLED minimap colour table -- built once, mirroring the engine's
// init loop @0x0668B8-@0x066922: entry = the frame's pixel at (8, 8) of a
// 16x16 render (func_066884 returns [bp-0x80] = buffer offset 0x88 = row 8
// col 8; func_066850 does the same off PHYS0). Base ids 0..7 sample their
// ground frames and are COPIED to the 8..15 / 16..23 bands (one store to
// all three tables), so a forested tile shows its UNFORESTED colour;
// 24/25/26 sample their own frames; slot 0x1B samples the engine's PHYS0
// frame 0x21 (mountains, bundle 0x20), 0x1C frame 0x31 (hills, 0x30).
let _mmTab = null;
function mmSample(sheet, frame) {
  const sh = DATA.sheets[sheet];
  const f = sh && sh.frames[frame];
  if (!f || f.w <= 8 || f.h <= 8) return 'rgb(0,0,0)';
  const c = document.createElement('canvas');
  c.width = c.height = 16;
  const g = c.getContext('2d', { willReadFrequently: true });
  g.drawImage(cycAtlas(sheet, 0), f.x, f.y, f.w, f.h, 0, 0, f.w, f.h);
  const d = g.getImageData(8, 8, 1, 1).data;
  return `rgb(${d[0]},${d[1]},${d[2]})`;
}
function mmTable() {
  if (_mmTab) return _mmTab;
  const t = {};
  for (let i = 0; i < 8; i++) t[i] = mmSample('TERRAIN', groundFrame(i));
  t[0x18] = mmSample('TERRAIN', groundFrame(24));
  t[0x19] = mmSample('TERRAIN', groundFrame(25));
  t[0x1A] = mmSample('TERRAIN', groundFrame(26));
  t[0x1B] = mmSample('PHYS0', PHYS.MOUNTAIN);   // engine 0x21 @0x066909
  t[0x1C] = mmSample('PHYS0', PHYS.HILL);       // engine 0x31 @0x066915
  return (_mmTab = t);
}
function mmOwnerColour(owner) {
  // [0x848 + owner]: powers 0..3, tribes 4..11.
  if (owner < 4) return DATA.nations[owner & 3].color;
  const ti = owner - 4;
  return ti < 8 ? ((G.tribes[ti] || {}).color || 8) : 8;
}
function drawSidebar(ctx) {
  // Minimap: 1px per tile inside the orange frame (251,8)-(308,48) colour 6
  // (@0x066D4F) over the black backdrop fill (241,8,79,41) (@0x066CF8).
  const mm = { x: 252, y: 9, w: 56, h: 39 };
  const tab = mmTable();
  ctx.fillStyle = ink(0); ctx.fillRect(241, 8, 79, 41);
  hollowRect(ctx, mm.x - 1, mm.y - 1, mm.w + 2, mm.h + 2, 6);
  // The WINDOW (verb 0x181F:0x59A = @0x066928): anchored to the map CURSOR
  // [0x17C]/[0x17E] -- the active unit after a load -- with
  // sx = clamp(cx - 0x1C, 1, W - 0x39), sy = clamp(cy - 0x13, 1, H - 0x28).
  // Low bound 1, not 0. With no selection the view centre models the cursor.
  const cu = G.units[G.sel];
  const cx = cu ? cu.x : G.view.x + (VIEW_COLS() >> 1);
  const cy = cu ? cu.y : G.view.y + (VIEW_ROWS() >> 1);
  const sx = Math.max(1, Math.min(MAP.w - 0x39, cx - 0x1C));
  const sy = Math.max(1, Math.min(MAP.h - 0x28, cy - 0x13));
  // Terrain pass (func_066968): fog stays black; hills/mountains (terrain
  // bit 0x20) index 0x1B (bit 0x80 set) / 0x1C; else table[id] with the
  // 8..23 bands folded to their base id.
  for (let y = 0; y < mm.h; y++) for (let x = 0; x < mm.w; x++) {
    if (sx + x >= MAP.w || sy + y >= MAP.h) continue;
    if (!isSeen(sx + x, sy + y)) continue;
    const v = at(sx + x, sy + y);
    let t = v & 0x1F;
    if (v & 0x20) ctx.fillStyle = tab[(v & 0x80) ? 0x1B : 0x1C];
    else {
      if (t >= 16 && t <= 23) t -= 16;
      else if (t >= 8 && t <= 15) t -= 8;
      ctx.fillStyle = tab[t];
    }
    ctx.fillRect(mm.x + x, mm.y + y, 1, 1);
  }
  // Unit dots (the flags-plane bit 1 branch @0x066A96): owner colour; a
  // FOREIGN Privateer with chain_next < 0 greys to 8 (@0x066AED -- the
  // unidentified sail). Gated on the record owner byte's per-power seen
  // mask 0x10 << player (@0x066ABC); the port mirrors that with its
  // sticky-visibility test on the tile.
  const unitDot = (x, y, owner, grey) => {
    const dx = x - sx, dy = y - sy;
    if (dx < 0 || dy < 0 || dx >= mm.w || dy >= mm.h) return;
    if (!isSeen(x, y)) return;
    ctx.fillStyle = ink(grey ? 8 : mmOwnerColour(owner));
    ctx.fillRect(mm.x + dx, mm.y + dy, 1, 1);
  };
  for (const u of G.units) unitDot(u.x, u.y, G.nation, false);
  for (const r of G.rivals)
    for (const ru of r.units)
      unitDot(ru.x, ru.y, ru.nation, ru.type === 'Privateer');
  for (const n of G.natives) unitDot(n.x, n.y, 4 + n.tribe, false);
  // Settlement dots draw ABOVE units (engine priority colony > unit >
  // terrain): villages in tribe colours, colonies of EVERY power.
  for (const v of G.villages) {
    const dx = v.x - sx, dy = v.y - sy;
    if (dx < 0 || dy < 0 || dx >= mm.w || dy >= mm.h) continue;
    if (!isSeen(v.x, v.y)) continue;
    ctx.fillStyle = ink(mmOwnerColour(4 + v.tribe));
    ctx.fillRect(mm.x + dx, mm.y + dy, 1, 1);
  }
  const colonyDot = (x, y, nation) => {
    const dx = x - sx, dy = y - sy;
    if (dx < 0 || dy < 0 || dx >= mm.w || dy >= mm.h) return;
    if (!isSeen(x, y)) return;
    ctx.fillStyle = ink(mmOwnerColour(nation));
    ctx.fillRect(mm.x + dx, mm.y + dy, 1, 1);
  };
  for (const c of G.colonies) colonyDot(c.x, c.y, c.nation);
  for (const r of G.rivals) for (const rc of r.colonies) colonyDot(rc.x, rc.y, rc.nation);
  hollowRect(ctx, mm.x + (G.view.x - sx), mm.y + (G.view.y - sy),
             VIEW_COLS(), VIEW_ROWS(), 0x0F);

  // Sidebar B (240,72,80,64): season/year, gold, tax. All HUD text is the
  // green ink 68, pixel-measured from docs/screens/06_ingame_map.png.
  // Measured off the MAP baseline: x = 242 (not 244), gold row y = 58,
  // and the black minimap backdrop runs one row below the frame (y = 49).
  ctx.fillStyle = ink(0); ctx.fillRect(241, 49, 79, 1);
  const season = DATA.seasons[G.season];
  FONT.tiny.draw(ctx, `${season} ${G.year}`, 242, 51, lut(HUD_INK));
  FONT.tiny.draw(ctx, `Gold: ${G.gold}`, 242, 58, lut(HUD_INK));
  FONT.tiny.draw(ctx, `Tax: ${G.tax}%`, 288, 58, lut(HUD_INK));

  // Sidebar C (240,136,80,64): selected-unit panel.
  const u = G.units[G.sel];
  if (u) {
    // The sidebar unit is the SHARED func_00386A composite -- the MAP census
    // baseline shows the black silhouette layer and the class-1 plate at the
    // frigate's top-right (interior orange measured at (252..256, 69..75)).
    // Anchor (242, 68) is the census sweep's unique minimum (9,332; every
    // neighbour >= 9,489). The old centred sprite + 8x9 plate was
    // capture-era guesswork.
    unitPanel(ctx, 242, 68, 0, u.type, unitFlags(u), u.orders || 0,
              ownerColour(u), unitIconOf(u), ownerPower(u));
    // The budget is in thirds; the HUD shows whole moves, with the odd third
    // spelled out so a road march reads correctly.
    const whole = Math.floor(u.movesLeft / MOVE_UNIT), frac = u.movesLeft % MOVE_UNIT;
    // Text geometry MEASURED off the MAP baseline (glyph tops): Moves
    // (260,69), Locat (260,77) pitch 8; the unit block (242,86)/(242,93)/
    // (242,100) pitch 7. The ORDERS line prints in YELLOW 0x95 -- whether
    // that highlight is active-unit-only or permanent is UNRESOLVED on one
    // frame; this panel only ever shows the active unit either way.
    FONT.tiny.draw(ctx, `Moves: ${whole}${frac ? ` ${frac}/3` : ''}`, 260, 69, lut(HUD_INK));
    FONT.tiny.draw(ctx, `Locat: (${u.x}, ${u.y})`, 260, 77, lut(HUD_INK));
    // The HUD uses NAMES @NATIONABBREV ("Eng.", "Fr.", ...), not the adjective.
    FONT.tiny.draw(ctx, `${DATA.nations[G.nation].abbrev} ${u.type}`, 242, 86, lut(HUD_INK));
    FONT.tiny.draw(ctx, DATA.orders[u.orders].name, 242, 93, lut(0x95));
    FONT.tiny.draw(ctx, `(${terrainName(at(u.x, u.y))})`, 242, 100, lut(HUD_INK));
    let cy = 128;
    for (const c of u.cargo) {
      const cu = unit(entryType(c));
      if (cu) sheetFrame(ctx, 'ICONS', entryIcon(c), 244, cy - 4);
      nationPlate(ctx, 244, cy - 4, DATA.nations[G.nation].color, 1);
      FONT.tiny.draw(ctx, carriedLabel(c), 268, cy, lut(HUD_INK));
      FONT.tiny.draw(ctx, 'Sentry', 268, cy + 8, lut(HUD_INK));
      cy += 20;
    }
  }
  // No status line here: the engine's map sidebar carries only the unit panel
  // (live DOS captures) -- anything the player must read arrives as a popup.
}

// ---------------------------------------------------------------- colonies
// Build Colony (@ORDERS row 7, status letter "B"). A land unit standing on a
// land tile with no colony already on it founds one; @COLONY -- "What shall we
// name this colony?" -- carries no @default directive, so the field is prefilled
// from COLONY.TXT's per-nation list in founding order instead.
// The units that cannot found (or join) a colony -- @ONLYCOL "That function
// can be performed only by colonists." The engine's predicate site is unread;
// excluding the three non-person unit kinds is the port's reading, flagged.
const NOT_COLONISTS = ['Wagon Train', 'Artillery', 'Treasure'];
// A unit that walks into a colony STANDS DOWN to the man underneath: his
// outfit goes into the stores -- the Pioneer's remaining tools, the Soldier's
// muskets, the Dragoon's muskets and horses, the Scout's horses (the same
// EQUIP_* quantities the Europe arming rows trade) -- and the colonist entry
// keeps only his PROFESSION. User report 2026-08-08: a Pioneer joining the
// Blacksmith's House stayed "Pioneers" forever, tools lost.
function unitToColonist(u, c) {
  if (u.tools) c.stock[GOOD.TOOLS] += u.tools;
  if (u.type === 'Soldiers') c.stock[GOOD.MUSKETS] += EQUIP_MUSKETS;
  if (u.type === 'Dragoons') {
    c.stock[GOOD.MUSKETS] += EQUIP_MUSKETS;
    c.stock[GOOD.HORSES] += EQUIP_HORSES;
  }
  if (u.type === 'Scouts') c.stock[GOOD.HORSES] += EQUIP_HORSES;
  const outfit = ['Pioneers', 'Soldiers', 'Dragoons', 'Scouts', 'Missionaries'];
  return { type: outfit.includes(u.type) ? 'Colonists' : u.type,
           profession: u.profession || null, job: null, cell: null };
}
// The reverse of unitToColonist: a colonist LEAVES the colony and waits at the
// fence, which is to say he becomes an ordinary unit standing on the colony
// square. Two GAME.TXT keys pin what "the fence" is:
//   @TUTORIAL4  "To take a colonist OUT OF A COLONY, drag him to the fence
//               (near the water on the colony picture)."
//   @TUTORIAL15 new arrivals wait at the "fence" until dragged "to a field or
//               building" to become citizens.
// So the fence holds people who are ON the colony square but NOT members of it,
// and that is exactly the second group of the byte-verified plaza row: its
// count is `colony+0x1F` (members) + `[0x8D72]` (units on the tile), with the
// 4px break between them (spec/ui/colony_screen.md §3.3, func_0270D0).
//
// Two consequences the user reported as bugs (2026-08-17) and this fixes:
// he stops being drawn among the colonists, and he stops eating -- food is
// `eaten = 2 * pop` over the colony's MEMBERS, BYTE_VERIFIED @0xA5F2 and
// restated by @TUTORIAL16 ("Each colonist eats two units of food per turn").
// Until now an unassigned man stayed in c.colonists, so he drew in the members
// group and went on eating from a job he no longer had.
//
// Refuses to empty a colony: the engine's own behaviour when the LAST colonist
// leaves is unread, and abandonment has its own explicit command (@ABANDON,
// shift-A on the map), so this does not invent a second path to it. FLAGGED.
function colonistToFence(c, i) {
  const p = c.colonists[i];
  if (!p || c.colonists.length <= 1) return null;
  c.colonists.splice(i, 1);
  const u = mkUnit(p.profession || p.type || 'Colonists', c.x, c.y);
  G.units.push(u);
  return u;
}
function buildColony() {
  const u = G.units[G.sel];
  if (!u) return;
  // Founding-colony validation (func_022542, page 01 -- home of the NOPORT /
  // TUTNOSPACES / TUTNOLUMBER emitters; spec/systems/tutorial.md §2). The
  // hard-guard ORDER below is the port's reading (unread in the EXE); the
  // TUT gate + row semantics are byte-cited.
  if (u.ship || tileWater(at(u.x, u.y))) {
    // @SEACOLONY, the engine's own joke key (@width=140).
    showEvent('SEACOLONY');
    return;
  }
  if (NOT_COLONISTS.includes(u.type)) { showEvent('ONLYCOL'); return; }
  // @NOCOLONIESEITHER: "New colonies cannot be founded during the {War of
  // Independence}."
  if (woiLocked() && !colonyAt(u.x, u.y)) { showEvent('NOCOLONIESEITHER'); return; }
  if (tileMountains(at(u.x, u.y))) { showEvent('TOOMOUNTAIN'); return; }
  // @TOONEAR: too close to an existing colony. The engine's radius is unread;
  // the port refuses ADJACENT tiles (chebyshev <= 1), flagged.
  const near = !colonyAt(u.x, u.y) && G.colonies.find(c =>
    Math.max(Math.abs(c.x - u.x), Math.abs(c.y - u.y)) <= 1);
  if (near) { showEvent('TOONEAR', { STRING0: near.name }); return; }
  // @ORDERS "Join Colony (B)" is the same key on a tile that already holds one:
  // the unit walks in and becomes a colonist. That is what saves an Indian
  // Convert from the eight-turn loss-of-faith timer (§19.7).
  const here = colonyAt(u.x, u.y);
  if (here) {
    here.colonists.push(unitToColonist(u, here));
    G.units.splice(G.sel, 1);
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
    G.msg = `${u.profession || u.type} joins ${here.name}.`;
    G.colony = G.colonies.indexOf(here);
    G.screen = 'colony';
    return;
  }
  const names = DATA.colonynames[G.nation];
  const suggested = names[G.colonies.length % names.length];
  // The pre-founding confirms, chained ahead of the name dialog.
  // @NOPORT (landlocked; row 2 proceeds) then the two tutorial site scans
  // (func_022542, byte-cited: gate [0x53A6]<2 @0x22763; @TUTNOSPACES fires on
  // adjacent productive count < 4 @0x2276A, @TUTNOLUMBER on forested count
  // == 0 @0x22782; each proceeds only on row 2 "Build colony anyway").
  // The port's readings, flagged: the relative ORDER of the three confirms,
  // "ocean access" = any adjacent water tile (the engine's lake/ocean split
  // is unmodelled), and "productive" = land that is not mountains/arctic.
  let water = 0, productive = 0, forested = 0;
  for (let dy = -1; dy <= 1; dy++) for (let dx = -1; dx <= 1; dx++) {
    if (!dx && !dy) continue;
    const v = at(u.x + dx, u.y + dy);
    if (v === undefined) continue;
    if (tileWater(v)) { water++; continue; }
    if (isForested(tileTerrain(v))) forested++;
    if (!tileMountains(v) && tileTerrain(v) !== TERR.ARCTIC) productive++;
  }
  const scans = [];
  if (!water) scans.push('NOPORT');
  if (G.difficulty < 2 && productive < 4) scans.push('TUTNOSPACES');
  if (G.difficulty < 2 && !forested) scans.push('TUTNOLUMBER');
  const askScans = (k, then) => {
    if (k >= scans.length) { then(); return; }
    askEvent(scans[k], {}, (choice) => {
      if (choice === 1) askScans(k + 1, then);   // row 2 = proceed
    });
  };
  const startScans = () => askScans(0, () => nameAndFound());
  // The native land claim: founding inside a tribe's country (a village
  // within 2 -- the objection radius, flagged) draws @INDIANLAND (leave /
  // pay -- @INDIANBRIBE acknowledges, Peter Minuit zeroes it / take it,
  // with the population-pressure tension cost). A Content-band tribe
  // instead BOWS: @INDIANTREATY offers the land with a peace treaty (Yes
  // floors their tension), or plain @INDIANBOW. The band split and the
  // price (demandValue(100)) are the port's flagged readings.
  const claimV = G.villages.find(v =>
    Math.abs(v.x - u.x) <= 2 && Math.abs(v.y - u.y) <= 2);
  const claimT = claimV && G.tribes[claimV.tribe];
  if (claimT) {
    G.eventTribe = claimV.tribe;
    if ((claimT.tension || 0) < 20) {
      if (Math.random() < 0.5) {
        askEvent('INDIANTREATY', { STRING0: claimT.name,
                                   STRING1: DATA.nations[G.nation].adjective },
                 (choice) => {
          if (choice === 0) claimT.tension = 0;
          startScans();
        });
      } else {
        showEvent('INDIANBOW', { STRING0: claimT.name,
                                 STRING1: DATA.nations[G.nation].adjective });
        startScans();
      }
      return;
    }
    const pay = G.fathersOwned.includes('Peter Minuit') ? 0 : demandValue(100);
    askEvent('INDIANLAND', { STRING0: claimT.name, NUMBER1: pay }, (choice) => {
      if (choice === 0) return;                       // we leave
      if (choice === 1) {
        if (G.gold < pay) { showEvent('NOTENOUGH', { NUMBER0: G.gold }); return; }
        G.gold -= pay;
        showEvent('INDIANBRIBE', {});
        startScans();
        return;
      }
      adjustTension(claimV.tribe, 15, 5);             // "OUR land now" (@PISS5)
      startScans();
    });
    return;
  }
  startScans();
  function nameAndFound() {
  openDialog('COLONY', (name) => {
    const nm = (name || '').trim() || suggested;
    const nc = {
      name: nm, x: u.x, y: u.y, nation: G.nation,
      // A new colony starts with its founder in the plaza and an empty
      // warehouse; the fixed starting buildings are the three no-cost rows.
      // Colonists carry a job and, if they work a field, the cell they work
      // (signed -2..+2 from the colony centre). The founder starts in the
      // plaza with no job -- which is why a new colony makes no hammers.
      colonists: [],
      stock: DATA.cargo.map(() => 0),
      buildings: STARTING_BUILDINGS.slice(),
      hammers: 0,          // construction points banked
      building: null,      // @BUILDING row being constructed
      sol: 0,
    };
    // The founder stands down like any joiner: a founding Pioneer's tools
    // seed the new warehouse.
    nc.colonists.push(unitToColonist(u, nc));
    // The engine seats the founder AS A FARMER: the create path calls the
    // colonist op with job 0 (0x181F:0xC36(slot, 0) @0x2ED3A -> the mode-0
    // occupation write @0x94D6). The +0x70 cell array stays 0xFF in the
    // create path, so WHICH field he farms is the port's own best-food
    // pick over the eight worker cells (N,E,S,W,NW,NE,SE,SW), FLAGGED.
    {
      const f = nc.colonists[0];
      f.job = DATA.jobs[0];                          // Farmer
      let best = null, bestY = -1;
      for (const cell of [[0, -1], [1, 0], [0, 1], [-1, 0],
                          [-1, -1], [1, -1], [1, 1], [-1, 1]]) {
        const y = fieldYield(nc, { ...f, cell });
        if (y > bestY) { bestY = y; best = cell; }
      }
      f.cell = best;
    }
    G.colonies.push(nc);
    // The founder joins the colony, so it leaves the map.
    G.units.splice(G.sel, 1);
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
    G.colony = G.colonies.length - 1;
    // First colony fires woodcut 2, BUILDING A COLONY (human only) --
    // spec/ui/woodcuts_and_intro.md, func_040C1E @0x040E00.
    if (!G.builtColony) { G.builtColony = true; woodcutOnce(2); }
    else G.screen = 'colony';
  }, suggested);
  }
}
// The starting-building set falls straight out of NAMES.TXT @BUILDING once you
// read the last column: UPKEEP. Exactly eight rows have upkeep 0 -- the free
// base tier that costs nothing to maintain -- and seven of those are available
// to a size-1 colony. The eighth, the Stockade, is gated at min_colony 3, so it
// cannot be present when a colony is founded. That leaves Town Hall,
// Carpenter's Shop, Blacksmith's House, Weaver's House, Tobacconist's House,
// Rum Distiller's House and Fur Trader's House -- derived from the table, not
// guessed. (Every later tier of each chain carries upkeep 5/10/15/20.)
const STARTING_BUILDINGS = DATA.buildings
  .filter(b => b.upkeep === 0 && b.min_colony === 1)
  .map(b => b.name);
const colonyAt = (x, y) => G.colonies.find(c => c.x === x && c.y === y);

// ------------------------------------------- colonial authority + orders
// spec/ui/context_dialogs.md §7. @ABANDON carries `@default=2`, so the
// highlighted row is "Never! That would be folly." -- the engine defends you
// against a stray keypress, and the port keeps that default.
function abandonColony() {
  const c = G.colonies[G.colony];
  if (!c) return;
  // @KEEPSTOCKADE (@width=220): "We cannot voluntarily reduce below three the
  // population of a colony that has a stockade, fort, or fortress."
  // Abandoning always reduces below three, so any stockade level refuses.
  if (colonyLevel(c) > 0) { showEvent('KEEPSTOCKADE'); return; }
  askEvent(G.year >= 1600 ? 'ABANDON2' : 'ABANDON', { STRING0: c.name }, (choice) => {
    // Row 0 abandons ("Yes, it is God's will."), row 1 refuses -- and row 1 is
    // the @default.
    if (choice !== 0) return;
    // The colonists walk back out onto the map.
    for (const p of c.colonists) {
      const u = mkUnit('Colonists', c.x, c.y);
      u.profession = p.profession || null;
      G.units.push(u);
    }
    G.colonies.splice(G.colonies.indexOf(c), 1);
    G.colony = Math.max(0, Math.min(G.colony, G.colonies.length - 1));
    G.screen = 'map';
    notice(`${c.name} is abandoned.`);
  });
}
function renameColony() {
  const c = G.colonies[G.colony];
  if (!c) return;
  openDialog('RENAMECOLONY', (name) => {
    const nm = (name || '').trim();
    if (nm) c.name = nm;
  }, c.name);
}
// @ORDERS row 12, Pillage: a unit standing on a rival's improvement tears it
// out. Its own gating is not in the evidence read, so the port allows it on any
// improved tile that is not yours and says what it destroyed.
function pillage() {
  const u = G.units[G.sel];
  if (!u || u.ship) return;
  const i = u.y * MAP.w + u.x;
  if (colonyAt(u.x, u.y)) { G.msg = 'We will not pillage our own colony.'; return; }
  if (!IMPROVE[i]) { G.msg = 'There is nothing here to destroy.'; return; }
  const what = (IMPROVE[i] & ROAD_BIT) ? 'road' : 'plowed field';
  IMPROVE[i] = 0;
  u.movesLeft = 0;
  G.msg = `The ${what} is destroyed.`;
  advance();
}
// @ORDERS row 3, Go To: the unit walks toward a chosen tile over as many turns
// as it takes. The engine caches the next step per unit; the port keeps the
// destination and steps toward it each turn, which is the same behaviour from
// the player's side.
function beginGoTo() {
  const u = G.units[G.sel];
  if (!u) return;
  beginGoToPage(u, 0);
}
// @TRAVELPLACE (land) / @SAILPORT (ships): the shared destination picker
// func_060026 (spec/ui/trade_routes.md par.3), CENSUS-CORRECTED 2026-08-08
// against census_goto_ship / census_goto_land:
//   * a ship's list opens with the EUROPE ROW FIRST, labelled
//     "<homeport> (<country>)" -- "Amsterdam (Netherlands)" in the frame;
//   * rows page in tens with a "(More)" tail row;
//   * a LAND unit's list carries only colonies on ITS OWN LAND MASS (the
//     frame omits every island colony; func_05FEF4's region match, which the
//     port reads off its REGION plane) and no Europe row.
// Escape leaves click-to-target. Picking Europe sets sail (func_022CDC).
function beginGoToPage(u, page) {
  const entries = [];
  if (u.ship) {
    entries.push({ europe: true,
      label: `${DATA.nations[G.nation].homeport} (${DATA.nations[G.nation].country})` });
    coastalColonies().forEach(c => entries.push({ c, label: c.name }));
  } else {
    const home = REGION[u.y * MAP.w + u.x];
    G.colonies.filter(c => REGION[c.y * MAP.w + c.x] === home)
      .forEach(c => entries.push({ c, label: c.name }));
  }
  if (!entries.length) { G.goTo = u; G.msg = 'Click the tile to travel to.'; return; }
  const PAGE = 10;
  const slice = entries.slice(page * PAGE, (page + 1) * PAGE);
  const rows = slice.map(e => e.label);
  const more = entries.length > (page + 1) * PAGE;
  if (more) rows.push('(More)');            // @MISC's own pager word, verbatim
  askEvent(u.ship ? 'SAILPORT' : 'TRAVELPLACE', {}, (k) => {
    if (k < 0 || k >= rows.length) { G.goTo = u; G.msg = 'Click the tile to travel to.'; return; }
    if (more && k === rows.length - 1) { beginGoToPage(u, page + 1); return; }
    const e = slice[k];
    if (e.europe) {
      if (woiLocked()) { showEvent('EUROPENOTAVAIL'); return; }
      if (orderSailHome(u)) G.screen = 'europe';
      return;
    }
    setGoTo(u, e.c.x, e.c.y);
  }, rows);
}
function setGoTo(u, x, y) {
  u.goal = [x, y];
  u.orders = 3;
  G.goTo = null;
  advance();
}
// The goto stepper -- func_062D84 (0x1a1f:0x210, the per-turn direction
// chooser for goto orders) + its 16x16 pathfinder func_061F02
// (0x1a1f:0x5f0), BYTE MODEL read 2026-08-29 (closes C1.20's
// straight-line stand-in):
//  * adjacent goal (|dx|<=1 and |dy|<=1): step straight (@0x62E55).
//  * within 7 of the goal (@0x62E94): Dijkstra over the 16x16 window
//    centred on the GOAL (origin gx-8/gy-8, byte cost plane [0xA270],
//    queue cap 225 @0x62055, per-tile cost cap 99 @0x6206B), the wave
//    running FROM the goal outward. Step cost onto a tile: 1 when BOTH
//    tiles carry improve road/river bits (&0xA, @0x622A1); 1 when both
//    carry the terrain-plane river bit 0x40 (@0x622C6); 3 for a
//    one-move unit (@UNIT movement thirds <= 3, @0x61F6B/@0x622F2);
//    else 3 x the terrain Movement column [0x2F76] (@0x622FA).
//    Blockers: element mismatch (water = ids 0x19/0x1A only; colony
//    tiles open to both elements @0x621A9), tiles holding a FOREIGN
//    unit or settlement (@0x6220A via owner query 0x6d2), braves avoid
//    rumour tiles (@0x621E8, 0x75e); a HUMAN pays +8 for a tile beside
//    a foreign settlement (@0x6225E, 0x6e6).
//  * step pick (@0x62374..@0x625D3): the neighbour with the lowest
//    plane-cost + step-cost, ties broken by the straight distance
//    0x181f:0x37a to the goal.
//  * farther than 7: the engine paths to a 4x4-sector waypoint
//    (func_061E10, unread) -- the port clamps the goal to a point 7
//    away along the line and paths to that, a flagged proxy.
// Returns [nx, ny] or null.
function gotoPathStep(u, gx, gy) {
  const adx = Math.abs(gx - u.x), ady = Math.abs(gy - u.y);
  const enterable = (x, y, goalX, goalY) => {
    if (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) return false;
    if (x === u.x && y === u.y) return true;
    const t = tileTerrain(at(x, y));
    const water = t === TERR.OCEAN || t === TERR.SEALANE;
    const col = colonyAt(x, y);
    if (col) {
      // colony tiles open to both elements, but a FOREIGN colony blocks
      if (col.nation !== undefined && col.nation !== G.nation) return false;
    } else if (water !== !!u.ship) return false;
    // a foreign unit or village on the tile blocks (0x6d2)
    if (G.natives.some(n => n.x === x && n.y === y)) return false;
    if (G.villages.some(v => v.x === x && v.y === y)) return false;
    if (G.rivals.some(r => r.units.some(q => q.x === x && q.y === y)) ||
        G.rivals.some(r => (r.colonies || []).some(c => c.x === x && c.y === y)))
      return false;
    void goalX; void goalY;
    return true;
  };
  const stepCost = (fx, fy, tx, ty) => {
    if ((impAt(fx, fy) & 0x0A) && (impAt(tx, ty) & 0x0A)) return 1;
    if ((at(fx, fy) & 0x40) && (at(tx, ty) & 0x40)) return 1;
    if ((unit(u.type) || {}).movement === 1) return 3;
    return 3 * terrainMove(at(tx, ty));
  };
  const nearSettle = (x, y) =>
    G.villages.some(v => Math.abs(v.x - x) <= 1 && Math.abs(v.y - y) <= 1) ||
    G.rivals.some(r => (r.colonies || []).some(c =>
      Math.abs(c.x - x) <= 1 && Math.abs(c.y - y) <= 1));
  // adjacent goal steps straight (@0x62E55; the engine leaves validity
  // to the move executor -- the port checks enterability here instead)
  if (adx <= 1 && ady <= 1)
    return enterable(gx, gy, gx, gy) ? [gx, gy] : null;
  // clamp the goal into the window when farther than 7 (the sector proxy)
  let wx = gx, wy = gy;
  if (adx >= 7 || ady >= 7) {
    wx = u.x + Math.max(-7, Math.min(7, gx - u.x));
    wy = u.y + Math.max(-7, Math.min(7, gy - u.y));
  }
  const ox = wx - 8, oy = wy - 8;
  const cost = new Array(256).fill(0);
  const idx = (x, y) => (x - ox) * 16 + (y - oy);
  const inWin = (x, y) => Math.abs(x - wx) < 8 && Math.abs(y - wy) < 8;
  const queue = [[wx, wy]];
  cost[idx(wx, wy)] = 1;
  const DIRS8 = [[1, 0], [-1, 0], [0, 1], [0, -1],
                 [1, 1], [1, -1], [-1, 1], [-1, -1]];
  let bound = 999;
  for (let head = 0; head < queue.length && head < 225; head++) {
    const [cx, cy] = queue[head];
    const c0 = cost[idx(cx, cy)];
    if (c0 > bound) continue;
    if (cx === u.x && cy === u.y) { bound = c0; continue; }
    for (const [ddx, ddy] of DIRS8) {
      const nx = cx + ddx, ny = cy + ddy;
      if (!inWin(nx, ny)) continue;
      if (!enterable(nx, ny, wx, wy) && !(nx === wx && ny === wy)) continue;
      let nc = c0 + stepCost(cx, cy, nx, ny);
      if (nearSettle(nx, ny)) nc += 8;
      const k = idx(nx, ny);
      if (cost[k] !== 0 && cost[k] <= nc) continue;
      cost[k] = nc;
      if (queue.length < 256) queue.push([nx, ny]);
    }
  }
  // step pick from the unit's tile
  let best = null, bestTotal = 99, bestDist = 9999;
  for (const [ddx, ddy] of DIRS8) {
    const nx = u.x + ddx, ny = u.y + ddy;
    if (!inWin(nx, ny) || !enterable(nx, ny, wx, wy)) continue;
    const k = idx(nx, ny);
    if (cost[k] === 0) continue;
    const total = cost[k] + stepCost(u.x, u.y, nx, ny);
    const dist = Math.max(Math.abs(nx - gx), Math.abs(ny - gy));
    if (total < bestTotal || (total === bestTotal && dist < bestDist)) {
      bestTotal = total; bestDist = dist; best = [nx, ny];
    }
  }
  return best;
}
function advanceGoTo() {
  // Ships that reached their lane this turn. Collected, not sailed in place:
  // sailForEurope splices G.units and this loop is iterating it.
  const arrived = [];
  for (const u of G.units) {
    if (u.orders !== 3 || !u.goal) continue;
    const [gx, gy] = u.goal;
    if (u.x === gx && u.y === gy) {
      u.orders = 0; u.goal = null;
      if (u.sailHome) arrived.push(u);
      continue;
    }
    // Steps along the pathfinder's route (func_061F02), spending the
    // unit's move allowance per step like the engine's order loop --
    // C1.3 (one tile a turn whatever the allowance) closed 2026-08-29.
    // The first step is always allowed (the step() rule), later steps
    // need the movement budget.
    let moved = false;
    for (let steps = 0; ; steps++) {
      const next = gotoPathStep(u, gx, gy);
      if (!next || (next[0] === u.x && next[1] === u.y)) break;
      const cost = moveCost(u, u.x, u.y, next[0], next[1]);
      if (steps > 0 && cost > u.movesLeft) break;
      u.movesLeft = cost > u.movesLeft ? 0 : u.movesLeft - cost;
      u.x = next[0]; u.y = next[1];
      reveal(u.x, u.y, sightRadius(u));
      moved = true;
      if (u.x === gx && u.y === gy) break;
    }
    if (moved && u.x === gx && u.y === gy) {
      u.orders = 0; u.goal = null;
      if (u.sailHome) arrived.push(u);
    }
    if (!moved) {
      u.orders = 0; u.goal = null; u.sailHome = false;
      G.msg = `${u.type} can go no further.`;
    }
  }
  // Arrival on the lane IS the departure -- no @SAILHOME ask, the player
  // already gave the order that sent the ship here.
  for (const u of arrived) {
    u.sailHome = false;
    if (u.ship && onSeaLane(u)) sailForEurope(u);
  }
}

// -------------------------------------------------- terrain improvement
// spec/systems/terrain_improvement.md, byte-verified throughout:
//   order 8 Clear/Plow -> func_040656, order 9 Build Road -> func_0409D6
//   (dispatcher @0x051D56, sel = UnitRecord[+0x08] - 7)
//   work counter UnitRecord +0x16, incremented each turn the order is held
//   (@0x04071D clear, @0x040A46 road)
//   threshold = @TERRAIN improvement column (+0x2F78): clear/plow = col + 2
//   (@0x040727/@0x04072D), road = col (@0x040A50); HALVED for a Hardy Pioneer
//   (@0x04074A/@0x040A59)
//   completion writes the tile: clear = id - 8 (@0x040896), plow = |= 0x40
//   (@0x04089F), road = |= 0x08 (@0x040AEC)
//   and debits 20 tools (func_040608 @0x4060F `sub byte[bx+0x3159],0x14`);
//   below 20 the Pioneer reverts to a plain Colonist (@USEDUPTOOLS).
const ORDER_CLEAR = 8, ORDER_ROAD = 9;
const PIONEER_TOOLS = 100, TOOLS_PER_JOB = 20;
// Look a terrain id up in one of the three @TERRAIN bands. Same folding as the
// yield tables (CLAUDE.md rule 3: 16..23 are the forested variants).
function terrainCol(v, table) {
  let t = v & 0x1F;
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  return t <= 7 ? table.unforested[t] : t <= 15 ? table.forested[t - 8]
       : (table.other[t - 24] || 0);
}
const improveWork = (v) => terrainCol(v, DATA.improvework) || 0;
const terrainMove = (v) => terrainCol(v, DATA.terrainmove) || 1;
const isHardy = (u) => u.profession === 'Hardy Pioneers';
function canImprove(u) { return u && !u.ship && (u.tools || 0) >= TOOLS_PER_JOB; }
// The work threshold this unit faces on its tile.
function workThreshold(u, road) {
  const v = at(u.x, u.y);
  let n = improveWork(v) + (road ? 0 : 2);
  if (isHardy(u)) n = n >> 1;
  return Math.max(1, n);
}
// One turn of pioneer work for every unit holding an improvement order.
function advanceImprovements() {
  for (const u of G.units.slice()) {
    if (u.orders !== ORDER_CLEAR && u.orders !== ORDER_ROAD) continue;
    const road = u.orders === ORDER_ROAD;
    const i = u.y * MAP.w + u.x;
    // The job may already be done by someone else, or impossible here.
    if (road && hasRoad(u.x, u.y)) { u.orders = 0; u.work = 0; continue; }
    u.work = (u.work || 0) + 1;
    if (u.work < workThreshold(u, road)) continue;
    u.work = 0;
    u.orders = 0;
    if (road) {
      IMPROVE[i] |= ROAD_BIT;
      G.msg = 'Pioneers complete a road.';
    } else if (isForested(tileTerrain(at(u.x, u.y)))) {
      // CLEAR -- the lumber grant is BYTE_VERIFIED (func_040656 completion
      // @0x40769..@0x4084D, read 2026-08-29), closing the +0x2F80 column
      // CONFLICT: 0x2F80 - 0x2F7B = 5, the LUMBERJACK yield column exactly
      // (the old "that is y_ore" arithmetic forgot the col-0 base). mult =
      // the FOLDED id's lumber column, +1 when the receiving COLONY's own
      // tile carries river or road (improve & 0x0A @0x407C7), forced to 1
      // without a Lumber Mill (@0x407D0); amount = min(warehouse room,
      // mult x 20 x (Hardy ? 2 : 1)) (@0x407E1..@0x407FD), and the colony
      // must be the unit's own power's within distance <= 3 (0x614 search,
      // [0x8db8] gate @0x407A0 -- the engine's metric is unread; Manhattan
      // is the port's reading, FLAGGED).
      let mult = tileYield(at(u.x, u.y), 5);
      // `sub es:[bx],8` is applied to the FOLDED id. Raw ids 16..23 fold to
      // 8..15 first (CLAUDE.md hard rule 3), so a straight -8 on the raw byte
      // would leave a 16..23 tile still forested; folding first lands both
      // halves of the band on their 0..7 unforested base. The non-terrain bits
      // (hills, river) ride through untouched.
      let t = tileTerrain(MAP.tiles[i]);
      if (t >= 16 && t <= 23) t = (t & 7) | 8;
      MAP.tiles[i] = (MAP.tiles[i] & ~0x1F) | (t - 8);
      let c = G.colonies.slice().sort((a, b) =>
        (Math.abs(a.x - u.x) + Math.abs(a.y - u.y)) - (Math.abs(b.x - u.x) + Math.abs(b.y - u.y)))[0];
      if (c && Math.abs(c.x - u.x) + Math.abs(c.y - u.y) > 3) c = null;
      let lumber = 0;
      if (c) {
        if (IMPROVE[c.y * MAP.w + c.x] & 0x0A) mult += 1;
        if (!c.buildings.includes('Lumber Mill')) mult = 1;
        lumber = mult * 20 * (isHardy(u) ? 2 : 1);
        lumber = Math.max(0, Math.min(lumber,
                          warehouseCapacity(c) - c.stock[GOOD.LUMBER]));
      }
      if (c && lumber > 0) {
        c.stock[GOOD.LUMBER] += lumber;
        showEvent('CLEARCUT', { STRING0: c.name, NUMBER0: lumber });
        // @DEFOREST: the cut that leaves no forest standing around the
        // square (adjacency reading, flagged).
        let woods = 0;
        for (let dy2 = -1; dy2 <= 1; dy2++) for (let dx2 = -1; dx2 <= 1; dx2++)
          if (isForested(tileTerrain(at(u.x + dx2, u.y + dy2)))) woods++;
        if (!woods) showEvent('DEFOREST', { STRING0: c.name });
        // @INDIANFOREST2: the completed cut near a settlement is the
        // colony-encroachment notice (no rows), with its tension cost.
        const nearV = G.villages.find(v =>
          Math.abs(v.x - u.x) <= 2 && Math.abs(v.y - u.y) <= 2);
        if (nearV) {
          G.eventTribe = nearV.tribe;
          showEvent('INDIANFOREST2',
                    { STRING0: (G.tribes[nearV.tribe] || {}).name, STRING1: c.name });
          adjustTension(nearV.tribe, 5, 2);
        }
      } else G.msg = 'Pioneers clear the forest.';
    } else {
      IMPROVE[i] |= PLOW_BIT;
      G.msg = 'Pioneers plow the field.';
    }
    spendTools(u);
  }
}
// -20 tools, and below 20 the Pioneer reverts to a plain Colonist.
function spendTools(u) {
  u.tools = (u.tools || 0) - TOOLS_PER_JOB;
  if (u.tools >= TOOLS_PER_JOB) return;
  u.tools = 0;
  const t = unit('Colonists');
  u.type = t.name; u.icon = t.icon;
  u.moves = t.movement * 3;
  showEvent('USEDUPTOOLS', {});
}

// ------------------------------------------------------- colony production
// §3 of spec/systems/colony.md, whose core is byte-verified:
// compute_terrain_yield (file 0x9B9C..0x9FFB), the per-turn driver
// colony_turn_update (0xA222..0xA6A1) and the five raw->finished chains.
//
// Per-terrain job yields from NAMES @UNFORESTED/@FORESTED/@OTHER. The three
// bands are indexed by the folded terrain id: 0..7 unforested, 8..15 forested
// (16..23 fold into it, CLAUDE.md rule 3), 24..26 the @OTHER rows.
const JOB_FARMER = 0;
// The engine's terrain classifier for yields -- BYTE_VERIFIED func_00624E
// @0x624E (the 0x3E4:0xE thunk target): bit5 set means the tile IS Hills
// (28) or, with bit7 also set, Mountains (27), and the yield row is the
// @OTHER Mountains/Hills row -- NOT the base terrain in bits 0..4. This
// is what pays ore miners 4 on mountain tiles (the COLONY_SHIP baseline's
// Vlissingen scene badges, 2026-08-28).
function tileYieldClass(v) {
  if (v & 0x20) return (v & 0x80) ? 27 : 28;    // @0x6254..@0x6266
  return v & 0x1F;
}
function tileYield(v, job) {
  let t = tileYieldClass(v);
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  const y = DATA.yields;
  const row = t <= 7 ? y.unforested[t]
            : t <= 15 ? y.forested[t - 8]
            : y.other[t - 24];
  return row ? (row[job] || 0) : 0;
}
// count of the 8 neighbours whose base terrain id lies in [lo,hi] --
// BYTE_VERIFIED func_0099EE @0x99EE (per-neighbour test @0x99AE). The
// fisherman ladder calls it with (0x19,0x1A) = ocean/sea-lane.
function count8Terr(x, y, lo, hi) {
  let n = 0;
  for (const [dx, dy] of [[0,-1],[1,0],[0,1],[-1,0],[-1,-1],[1,-1],[1,1],[-1,1]]) {
    const tx = x + dx, ty = y + dy;
    if (tx < 0 || ty < 0 || tx >= MAP.w || ty >= MAP.h) continue;
    const t = MAP.tiles[ty * MAP.w + tx] & 0x1F;
    if (t >= lo && t <= hi) n++;
  }
  return n;
}
// The 16 @CARGO goods, by id.
const GOOD = { FOOD: 0, SUGAR: 1, TOBACCO: 2, COTTON: 3, FURS: 4, LUMBER: 5,
               ORE: 6, SILVER: 7, HORSES: 8, RUM: 9, CIGARS: 10, CLOTH: 11,
               COATS: 12, TRADE: 13, TOOLS: 14, MUSKETS: 15 };
// The non-cargo tallies @CARGO lists after the 16 goods -- hammers, crosses and
// liberty bells are accumulators, not warehouse stock, so they get negative ids.
const HAMMERS = -1, BELLS = -2, CROSSES = -3, TEACHING = -4;
// @JOB row -> what that job produces. Rows 0..7 are the eight outdoor columns
// of the terrain tables in order; row 8 (Fisherman) is the ninth column and
// produces FOOD from water. 9..12 and 14..15 are the indoor manufactures,
// 13/16/17/18 the three accumulators and the schoolhouse.
const JOB_GOOD = {
  0: GOOD.FOOD, 1: GOOD.SUGAR, 2: GOOD.TOBACCO, 3: GOOD.COTTON, 4: GOOD.FURS,
  5: GOOD.LUMBER, 6: GOOD.ORE, 7: GOOD.SILVER, 8: GOOD.FOOD,
  9: GOOD.RUM, 10: GOOD.CIGARS, 11: GOOD.CLOTH, 12: GOOD.COATS,
  13: HAMMERS, 14: GOOD.TOOLS, 15: GOOD.MUSKETS, 16: CROSSES, 17: BELLS,
  18: TEACHING,
};
const jobIndex = (name) => DATA.jobs.indexOf(name);
// The workplaces. Each row of @BUILDING belongs to a CHAIN -- the table is laid
// out chain by chain -- and a chain's third link is the FACTORY tier the
// production code tests for (count_building_chain_present > 2, @0x8EA9).
// The five raw->finished pairs are byte-verified from the conversion call sites
// (@0xA660..0xA68C): Ore->Tools, Tobacco->Cigars, Cotton->Cloth, Furs->Coats,
// Sugar->Rum. Muskets<-Tools is the Armory chain: it is NOT one of those five
// call sites, so it is the port's own and flagged. The building->job binding
// itself is inferred from the names; the engine's own table is unread.
const WORKPLACES = [
  { chain: ["Weaver's House", "Weaver's Shop", 'Textile Mill'], job: 'Weaver' },
  { chain: ["Tobacconist's House", "Tobacconist's Shop", 'Cigar Factory'], job: 'Tobacconist' },
  { chain: ["Rum Distiller's House", 'Rum Distillery', 'Rum Factory'], job: 'Distiller' },
  { chain: ["Fur Trader's House", 'Fur Trading Post', 'Fur Factory'], job: 'Fur Trader' },
  { chain: ["Blacksmith's House", "Blacksmith's Shop", 'Iron Works'], job: 'Blacksmith' },
  { chain: ['Armory', 'Magazine', 'Arsenal'], job: 'Gunsmith' },
  { chain: ["Carpenter's Shop", 'Lumber Mill'], job: 'Carpenter' },
  { chain: ['Town Hall'], job: 'Statesman' },
  { chain: ['Church', 'Cathedral'], job: 'Preacher' },
  { chain: ['Schoolhouse', 'College', 'University'], job: 'Teacher' },
];
// Raw input per finished good. The five cited chains, plus hammers from lumber
// (PEDIA @BUILDING35: "the carpenter needs lumber to create hammers") and
// muskets from tools (@BUILDING3, the Armory).
const RAW_FOR = { [GOOD.RUM]: GOOD.SUGAR, [GOOD.CIGARS]: GOOD.TOBACCO,
                  [GOOD.CLOTH]: GOOD.COTTON, [GOOD.COATS]: GOOD.FURS,
                  [GOOD.TOOLS]: GOOD.ORE, [GOOD.MUSKETS]: GOOD.TOOLS,
                  [HAMMERS]: GOOD.LUMBER };
function workplaceFor(building) {
  return WORKPLACES.find(w => w.chain.includes(building));
}
function jobForBuilding(name) {
  const w = workplaceFor(name);
  return w ? w.job : null;
}
// How many links of a job's chain the colony owns. > 2 is the factory tier.
function chainCount(c, job) {
  const w = WORKPLACES.find(x => x.job === job);
  if (!w) return 0;
  return w.chain.filter(b => c.buildings.includes(b)).length;
}
// BUILDING UPKEEP -- CUT CONTENT (RULINGS 2026-09-02). @BUILDING's last
// column is a per-turn gold charge and GAME.TXT's @UPKEEP describes the
// half-efficiency penalty, but VICEROY.EXE never charges it: the key
// string `UPKEEP` does not exist in the EXE's message-key blob (every
// emitted key does -- FORTFIRE, SPOIL1, NOMOREWAGONS all resolve), @MISC
// 91/92 '(Building Upkeep)'/'TOTAL UPKEEP' have no consumer (B3.2), and
// the per-power pass func_02F052 has no gold debit outside the frigate
// tail. The port used to charge the player every turn and halve indoor
// output when it could not pay -- a port invention, removed. colonyUpkeep
// stays for the debug readouts and the Pedia line only.
function colonyUpkeep(c) {
  return c.buildings.reduce((n, b) => {
    const row = DATA.buildings.find(d => d.name === b);
    return n + (row ? row.upkeep : 0);
  }, 0);
}
function totalUpkeep() { return G.colonies.reduce((n, c) => n + colonyUpkeep(c), 0); }
// The Sons-of-Liberty / Tory production penalty -- BYTE_VERIFIED
// @0x9D13..@0x9D98 (and the identical indoor block @0xA029..@0xA0AF):
//   tories = (pop*(100-sol)+50)/100; divisor = 10 - difficulty for a
//   HUMAN colony (an AI colony pays no penalty, @0x9D73);
//   +1 per RECORD flag +0x1C bit2 / bit1 -- NOT the runtime sol.
// A POSITIVE pen is added early in the yield chain (@0x9D9B), a NEGATIVE
// one at the very end (@0x9FD8) -- fieldYield handles the split.
function toryPenalty(c) {
  const pop = c.colonists.length;
  const tories = Math.floor((pop * (100 - c.sol) + 50) / 100);
  let d = -Math.floor(tories / (10 - G.difficulty));
  const f = c.recFlags1c || 0;
  if (f & 4) d += 1;
  if (f & 2) d += 1;
  return d;
}
// Does this colonist master the job they are doing? BYTE_VERIFIED @0x9CDC
// (field) and @0xA01A (indoor): plain byte equality between the profession
// byte and the job id -- profession row 0 IS the Expert Farmer (the
// Vlissingen scene badges 6/5 against the port's old 5/4 were the tell;
// C4.26 resolved 2026-08-28).
function isExpert(p, job) {
  const i = jobIndex(job);
  return i >= 0 && p.profession != null &&
         DATA.jobexpert.indexOf(p.profession) === i;
}
// The indoor class rate keys off the PROFESSION byte (@0xA0D7..@0xA0FD):
// Indentured Servants (25) -> 2, Petty Criminals (26) / Indian Converts
// (27) -> 1, everyone else 3. The Isabella baseline's rum row 4 =
// criminal 1 + free 3.
function indoorClassRate(p) {
  const i = p.profession ? DATA.jobexpert.indexOf(p.profession) : -1;
  if (i === 25) return 2;
  if (i === 26 || i === 27) return 1;
  return 3;
}
// The plow/road yield deltas, byte-verified in compute_terrain_yield: the ROAD
// bit adds `bonus` iff the good index is > 3 (@0x9F01/@0x9F05 -- ore, furs,
// timber and up), the PLOW bit adds it iff the good index is <= 3 (@0x9F1F/
// @0x9F23 -- food and the three planter crops). `bonus` is 1, or 2 for good
// index 5 or a river-adjacent tile (@0x9EC6/@0x9EDD).
function improvementBonus(x, y, g) {
  const imp = impAt(x, y);
  if (!imp) return 0;
  const bonus = (g === 5 || tileRiver(at(x, y))) ? 2 : 1;
  if ((imp & ROAD_BIT) && g > 3) return bonus;
  if ((imp & PLOW_BIT) && g <= 3) return bonus;
  return 0;
}
// the [0xA896] depletion-pressure accumulator -- zeroed by colonyProduce,
// fed by fieldYield, read back into the produce result
let depAccrue = 0;
// compute_terrain_yield for one field worker -- the FULL func_009B9C chain,
// byte-read end to end @0x9B9C..@0x9FFB and cross-checked against every
// per-tile badge in the COLONY_SHIP baseline's worked-tile grid
// (Vlissingen: farmers 6/5, lumberjacks 4/4, miners 4/4, fisherman 4,
// 2026-08-28). Order matters -- see the numbered steps inline; the old
// capture-fitted easy-difficulty bonus is NOT in the bytes and is gone.
function fieldYield(c, p) {
  const job = p.job, col = jobIndex(job);
  if (col < 0 || col > 8) return 0;      // @JOB rows 0..8 are the columns
  const tx = c.x + p.cell[0], ty = c.y + p.cell[1];
  const v = at(tx, ty);
  const imp = IMPROVE[ty * MAP.w + tx] || 0;
  let y = tileYield(v, col);
  const expert = isExpert(p, job);
  const foodish = (col === 0 || col === 8);
  if (y !== 0) {
    if (col >= 8) {                      // fisher ladder @0x9C33..@0x9C87
      const n = count8Terr(tx, ty, 0x19, 0x1A);
      if (n >= 8) y -= 2; else if (n >= 6) y -= 1; else y += 1;
    }
    if (col === 4) {                     // furs: road/river @0x9C87
      if (imp & 0x0A) y += 1;
      if (v & 0x40) { y += 1; if (v & 0x80) y += 1; }
    }
  }
  if (y < 0) y = 0;                      // @0x9CB4
  const pen = toryPenalty(c);
  if (y !== 0 && pen > 0) y += pen;      // @0x9D9B
  if (expert && y !== 0) {               // @0x9DAD..@0x9DD2
    if (foodish) { y += 2; if (pen > 0) y += pen; }
    else y *= 2;
  }
  // PRIME RESOURCES (@0x9DD5..@0x9E10, table func_009AAA; the detail hash
  // IS the resource id -- runtime-confirmed by the "(Minerals)" sidebar
  // line on Vlissingen's centre, 2026-08-28).
  const res = detailId(tx, ty, v);
  {
    let bonus = res >= 0 ? (RES_BONUS[res * 16 + col] || 0) : 0;
    if (res === 7 && y <= 0) bonus = 0;
    if (bonus < 0) y *= 2;
    else { if (expert) bonus *= 2; y += bonus; }
  }
  // depletion pressure accrues per worked mineral (@0x9E13..@0x9E41 on
  // [0xA896], zeroed at each produce @0xA22C): ore on Minerals +1, silver
  // on Minerals +2, silver on a Depleted Mine +1
  if (res === 6) {
    if (col === 6) depAccrue += 1;
    else if (col === 7) depAccrue += 2;
  }
  if (res === 12 && col === 7) depAccrue += 1;
  // silver with no detail and no mine bit (imp&4): 1 with a road or an
  // expert, else 0, and the improvement block is skipped (@0x9E41..@0x9EA6)
  let noMine = false;
  if (col === 7 && res === -1 && !(imp & 4)) {
    noMine = true;
    if (y !== 0) y = ((imp & 0x0A) || expert) ? 1 : 0;
  }
  if (col === 5) y *= 2;                 // the LUMBER column doubles @0x9EAB
  if (y > 0 && !noMine) {                // improvements @0x9EBD..@0x9F4C
    const b = ((expert && !foodish) || col === 5) ? 2 : 1;
    let add = 0;
    if (col === 0) add = b;              // the farmer's inherent +b
    if ((imp & 0x0A) && col > 3) add += b;
    if ((imp & 0x40) && col <= 3) add += b;
    if (v & 0x40) { add += b; if ((v & 0x80) && add === b) add += b; }
    y += add;
  }
  if (col >= 8 && !c.buildings.includes('Docks')) y = 0;   // @0x9F4F
  if (col === 4 && ffOwned('Henry Hudson')) y *= 2;
  if (p.profession === 'Indian Converts' && y > 0 &&
      (col <= 4 || col >= 8)) y += 1;    // @0x9F86..@0x9FB6
  if (y < 0) y = 0;
  if (y !== 0 && pen < 0) y = Math.max(0, y + pen);        // @0x9FD8
  return y;
}
// func_009AAA verbatim: RES_BONUS[id*16 + col]; -1 = double.
// (9,0)+2 (1,0)+2 (2,0)+2 (9,4)+2 (8,4)+3 (3,3)dbl (4,2)dbl (5,1)dbl
// (10,5)+2 (6,6)+3 (13,6)+2 (6,7)+1 (12,7)+2 (7,8)+3
const RES_BONUS = (() => {
  const t = new Int8Array(16 * 16);
  const set = (r, cc, vv) => { t[r * 16 + cc] = vv; };
  set(9, 0, 2); set(1, 0, 2); set(2, 0, 2); set(9, 4, 2); set(8, 4, 3);
  set(3, 3, -1); set(4, 2, -1); set(5, 1, -1);
  set(10, 5, 2); set(6, 6, 3); set(13, 6, 2); set(6, 7, 1); set(12, 7, 2);
  set(7, 8, 3);
  return t;
})();

// Which skills a village teaches is no longer a hand-made list: villageSkill()
// below is the byte model of the teach-weight builder (func_048F34), whose
// reachable rows are 0-4, 6-8, 11, 12 and 22. (The old OUTDOOR_JOBS array and
// its coordinate hash are gone -- C1.6.)
// The NINE FIELD jobs are the nine terrain yield columns, one for one: Farmer,
// Planter (sugar / tobacco / cotton), Fur Trapper, Lumberjack, Ore Miner,
// Silver Miner, Fisherman -- NAMES.TXT:17-19 is the yield-column legend and
// @JOB rows 224+ are the jobs, with Lumberjack row 5 and Ore Miner row 6.
// Corroborated by the engine's job->building table at DS:0x2F4 (func_008D9C,
// file 0x1DC94, 19 signed bytes), where jobs 0..8 are all -1 = outdoor, no
// workplace building.
//
// (Rows 5 and 6 were once omitted here by mistake -- a real bug on the field
// side: a forest cell yields lumber 3 against furs 2, so bestFieldJob could
// never return Lumberjack and every forest worker came out a Fur Trapper.)
const FIELD_JOBS = [0, 1, 2, 3, 4, 5, 6, 7, 8];
// Which of the nine field jobs pays best on the cell this colonist is on.
// A colonist who already masters an outdoor skill keeps it if the tile yields
// anything at all -- that is what makes an Expert Fur Trapper worth moving.
const FIELD_JOB_NAMES = FIELD_JOBS.map(i => DATA.jobs[i]);
function bestFieldJob(c, p) {
  const cell = p.cell;
  let best = 'Farmer', bestY = -1;
  for (const job of FIELD_JOB_NAMES) {
    const probe = { ...p, job };
    const y = fieldYield(c, probe);
    if (y > bestY) { bestY = y; best = job; }
  }
  if (p.profession) {
    const own = FIELD_JOB_NAMES.find(j => isExpert(p, j));
    if (own && fieldYield(c, { ...p, job: own }) > 0) return own;
  }
  void cell;
  return best;
}
// One colonist inside a building -- the FULL func_009FFC, byte-read
// @0x9FFC..@0xA221. Returns what they WANT to make; the raw shortage
// resolves afterwards through the outage plane. Per job (@0xA1E4 jump
// table, cs base 0x82B0):
//   Carpenter 13 @0xA100: (expert?6:class)+pen, x2 with the Lumber Mill
//   Preacher 16 @0xA132:  (expert?6:class)+pen, x2 with the Cathedral,
//                          +50% with William Penn (father 21)
//   Statesman 17 @0xA1C8: class+pen, x2 if expert (press/newspaper act on
//                          the bell TOTAL, @0xA587)
//   Teacher 18 (default @0xA0AF): expert?3:1
//   converters 9-12,14,15 @0xA188: class+pen, +class with the 2nd link,
//                          +50% with the 3rd (factory), x2 if expert
function indoorYield(c, p) {
  const job = p.job, ji = jobIndex(job);
  if (JOB_GOOD[ji] === undefined) return 0;
  const expert = isExpert(p, job);
  const pen = toryPenalty(c);
  const cls = indoorClassRate(p);
  let y;
  if (ji === 13) {
    y = (expert ? 6 : cls) + pen;
    if (c.buildings.includes('Lumber Mill')) y *= 2;
  } else if (ji === 16) {
    y = (expert ? 6 : cls) + pen;
    if (c.buildings.includes('Cathedral')) y *= 2;
    if (ffOwned('William Penn')) y += Math.floor(y / 2);
  } else if (ji === 17) {
    y = cls + pen;
    if (expert) y *= 2;
  } else if (ji >= 9 && ji <= 15) {
    y = cls + pen;
    const n = chainCount(c, job);
    if (n > 1) y += cls;
    if (n > 2) y += Math.floor(y / 2);
    if (expert) y *= 2;
  } else {
    y = expert ? 3 : 1;                  // teacher & the rest @0xA0AF
  }
  return Math.max(0, y);
}
// The whole colony's output for one turn, before anything is banked. The order
// is colony_turn_update's: zero the accumulator, run the tiles, then apply the
// raw->finished chains.
function colonyProduce(c) {
  const out = DATA.cargo.map(() => 0);
  // "Each colony automatically produces one cross per turn" (GAME_MANUAL.md
  // 1534) -- the engine's churchless Jamestown enqueues [0x8DEA]=1 on the
  // plaza strip (census3_colony). The base cross lives in the tally so the
  // strip and the immigration sum read the same number.
  const tally = { [HAMMERS]: 0, [BELLS]: 0, [CROSSES]: 1, [TEACHING]: 0 };
  depAccrue = 0;                    // [0xA896] zeroed at produce start (@0xA22C)
  let fishFood = 0;                 // [0xA895], zeroed alongside (@0xA229)
  // The CENTRE TILE produces with no worker -- and a SECONDARY good that
  // goes straight into production (@0xA3F7..@0xA409). See centreYieldCore.
  const cyc = centreYieldCore(c);
  const centre = cyc.food;
  out[GOOD.FOOD] += centre;
  if (cyc.good >= 0) out[cyc.good] += cyc.amount;
  const indoor = [];
  for (const p of c.colonists) {
    if (!p.job) continue;
    if (p.cell) {
      const g = JOB_GOOD[jobIndex(p.job)];
      if (g >= 0) {
        const y = fieldYield(c, p);
        out[g] += y;
        // [0xA895] += the fisherman's yield (@0xA44D..@0xA456)
        if (jobIndex(p.job) === 8) fishFood += y;
      }
    } else indoor.push(p);
  }
  // The chains: every want accumulates UNCAPPED (@0xA480..@0xA4A0); the
  // raw costs are recorded in full (a factory pays 2/3, @0x8EB1) and the
  // shortages resolve afterwards through the outage plane (func_008E02).
  const consumed = DATA.cargo.map(() => 0);
  const factoryOf = DATA.cargo.map(() => false);
  for (const p of indoor) {
    const job = p.job, g = JOB_GOOD[jobIndex(job)];
    if (g === undefined) continue;
    const want = indoorYield(c, p);
    const raw = RAW_FOR[g];
    if (raw !== undefined) {
      const factory = chainCount(c, job) > 2;
      if (g >= 0) factoryOf[g] = factory;
      consumed[raw] += factory ? Math.floor(want * 2 / 3) : want;
    }
    if (g >= 0) out[g] += want; else tally[g] += want;
  }
  // crosses: +1 per Church / Cathedral on top of the base 1 (@0xA4B0..);
  // bells: base 1 (@0xA4DB), Jefferson +50% (father 15), Paine +tax%
  // (father 17), then Newspaper x2 else Printing Press +50% (@0xA587..).
  if (c.buildings.includes('Church')) tally[CROSSES] += 1;
  if (c.buildings.includes('Cathedral')) tally[CROSSES] += 1;
  // The bells chain keys every father check on the colony OWNER
  // (@0xA4E5/@0xA50B/@0xA544 read +0x1A) and Paine on the OWNER'S tax
  // byte (@0xA525) -- for a rival, the imported record tax (r.tax). The
  // old G.taxRate here was an unassigned name: Paine's bonus would have
  // been NaN, a dormant bug until the fixture owns him.
  tally[BELLS] += 1;
  if (ffOwned('Thomas Jefferson'))
    tally[BELLS] += Math.floor(tally[BELLS] / 2);
  if (ffOwned('Thomas Paine')) {
    const otax = curIsHuman() ? G.tax : ((rivalOf(curPower()) || {}).tax || 0);
    tally[BELLS] += Math.floor(otax * tally[BELLS] / 100);
  }
  // Bolivar (father 18, @0xA539..@0xA57A): AI-CONTROLLED owners add
  // (size+3)/5 -- the gate is the AIPersonality controller byte.
  if (!curIsHuman() && ffOwned('Simon Bolivar'))
    tally[BELLS] += Math.floor((c.colonists.length + 3) / 5);
  if (c.buildings.includes('Newspaper')) tally[BELLS] *= 2;
  else if (c.buildings.includes('Printing Press'))
    tally[BELLS] += Math.floor(tally[BELLS] / 2);
  const gross = out.slice();
  // outage resolution -- set_commodity_band func_008E02 per (raw, product)
  // pair in the engine's order (@0xA64E..@0xA69C): outage[raw] = max(0,
  // consumed - stock - produced); the product loses that many units (a
  // factory loses 3/2 per missing raw pair, or everything when nothing was
  // affordable, @0x8EC9..@0x8EFC). The gunsmith sees the toolsmith's
  // post-outage output (@0x8E5A). The crossed run the panel draws is THIS
  // array, not the consumption -- ore eaten out of a 161-crate warehouse
  // crosses nothing (the Vlissingen baseline).
  const outageAmt = DATA.cargo.map(() => 0);
  const overAmt = DATA.cargo.map(() => 0);
  const outages = new Set();
  const resolve = (raw, product, factory) => {
    const cost = consumed[raw];
    if (cost <= 0) return product;
    overAmt[raw] = Math.max(0, cost - gross[raw]);
    const sh = cost - (c.stock[raw] + out[raw]);
    if (sh <= 0) return product;
    outages.add(raw);
    consumed[raw] = cost - sh;           // only what stock+intake covered
    const loss = factory ? (sh === cost ? product : Math.floor(3 * sh / 2))
                         : sh;
    outageAmt[raw] = loss;
    return Math.max(0, product - loss);
  };
  tally[HAMMERS] = resolve(GOOD.LUMBER, tally[HAMMERS], false);
  for (const [raw, g] of [[GOOD.ORE, GOOD.TOOLS], [GOOD.TOBACCO, GOOD.CIGARS],
                          [GOOD.COTTON, GOOD.CLOTH], [GOOD.FURS, GOOD.COATS],
                          [GOOD.SUGAR, GOOD.RUM], [GOOD.TOOLS, GOOD.MUSKETS]])
    out[g] = resolve(raw, out[g], factoryOf[g]);
  for (let i = 0; i < consumed.length; i++) out[i] -= consumed[i];
  let eaten = 2 * c.colonists.length;                     // BYTE_VERIFIED @0xA5F2
  const horsesBred = horsesBredThisTurn(c, gross[GOOD.FOOD], eaten);
  // the panel's horses cell: the bred WANT into production, the unfed rest
  // crossed out (@0xA632..@0xA63B goods_out[8] += want, [0x8E6A] lost)
  {
    const herd = c.stock[GOOD.HORSES];
    let want = 0;
    if (herd >= 2) {
      const t = c.buildings.includes('Stable') ? 25 : 50;
      want = 2 * Math.ceil(herd / t);
    }
    gross[GOOD.HORSES] += want;   // panel only -- colonyTurn banks horsesBred
    outageAmt[GOOD.HORSES] = want - horsesBred;
  }
  eaten += horsesBred;                                    // BYTE_VERIFIED @0x0A63F
  // the food row's own outage (starvation display, @0xA642)
  {
    const sh = eaten - c.stock[GOOD.FOOD] - gross[GOOD.FOOD];
    if (sh > 0) { outageAmt[GOOD.FOOD] = sh; outages.add(GOOD.FOOD); }
  }
  return { out, gross, consumed, tally, centre, eaten, horsesBred, outages,
           outageAmt, overAmt, secGood: cyc.good, secAmount: cyc.amount,
           depletionPts: depAccrue, fishFood,
           netFood: out[GOOD.FOOD] - eaten };
}
// The centre tile -- compute_colony_center_yields func_00A222, byte-read
// END TO END @0xA222..@0xA3D1 (2026-08-28; the old plow/river/runtime-SoL
// model was capture-fitted and wrong):
//   FOOD: band by the CLASSIFIER id (hills/mountains and forested ids keep
//   their own rows -- NO auto-clear fold): Arctic 0; desert family
//   {1,9,17} 1; forested 8..23 and Hills/Mountains 2; else 3
//   (@0xA247..@0xA290); +2/+1 at difficulty 0/1; +2 when the centre's
//   prime resource is 1, 2 or 9 (@0xA314); +1 per record flag bit2/bit1.
//   SECONDARY (@0xA343..@0xA3D1): best of columns 1..7 skipping 5 on the
//   SAME classified row, resource bonus per column (negative doubles),
//   strict > so the FIRST max wins; the winner gets +1 at difficulty 0,
//   the river bonus (minor 1 / major 2), +1 per flag bit. Vlissingen:
//   rain-forest ore 1 + Minerals 3 = 4 wins, +1 -> 5, closing the panel's
//   ore row at 4+4+5 = 13 (the "(Minerals)" sidebar line, runtime-captured
//   2026-08-28).
function centreYieldCore(c) {
  const cv = at(c.x, c.y);
  const ct = tileYieldClass(cv);
  const cres = detailId(c.x, c.y, cv);
  const band = ct === 24 ? 0
             : (ct === 1 || ct === 9 || ct === 17) ? 1
             : (ct === 27 || ct === 28 || (ct >= 8 && ct <= 23)) ? 2 : 3;
  let food = band;
  if (G.difficulty === 0) food += 2; else if (G.difficulty === 1) food += 1;
  if (cres === 1 || cres === 2 || cres === 9) food += 2;
  const f1c = c.recFlags1c || 0;
  if (f1c & 4) food += 1;
  if (f1c & 2) food += 1;
  let good = -1, amount = 0;
  for (let cc = 1; cc <= 7; cc++) {
    if (cc === 5) continue;
    let yv = tileYield(cv, cc);
    const bb = cres >= 0 ? (RES_BONUS[cres * 16 + cc] || 0) : 0;
    if (bb < 0) yv *= 2; else yv += bb;
    if (yv > amount) { amount = yv; good = cc; }
  }
  if (good >= 0) {
    if (G.difficulty === 0) amount += 1;
    amount += tileRiver(cv);
    if (f1c & 4) amount += 1;
    if (f1c & 2) amount += 1;
  }
  return { food, good, amount: good >= 0 ? amount : 0 };
}
// Warehouse capacity -- BYTE_VERIFIED func_008D00 @0x08D00: 100 flat while
// warehouse_level (+0x95) is 0, else (level + 1) * 100 (cmp byte [bx+0x95],0
// @0x08D0D; inc ax; imul ax,ax,0x64 @0x08D1A).
function warehouseCapacity(c) {
  const lvl = warehouseLevel(c);
  return lvl ? (lvl + 1) * 100 : 100;
}
// Horse breeding -- BYTE_VERIFIED func_00A3E1 @0x0A5B4..0x0A63F.
//
// This block used to be read as a FOOD-growth accumulator on ColonyRecord
// +0xAA, and both engines carried an invented rule from it ("herd >= 25/50,
// then herd += max(1, herd/10)"). +0xAA is not a food field: the colony stock
// array is at +0x9A, u16 per good, indexed by good id -- proved directly by
// `push word ptr [bx+si+0x9a]` @0x08E6E with si = good*2 -- so
// +0x9A + 2*8 = +0xAA is HORSES (cargo row 8), and 0x11 is the Stable
// (buildings row 17).
//
//   herd < 2                     -> no breeding    @0x0A5B4 cmp [bx+0xaa],2
//   T   = Stable ? 25 : 50       @0x0A5BB / @0x0A5C0 push 0x11 / @0x0A5CD
//   cap = 2 * ceil(herd / T)     @0x0A5D6..@0x0A5E2
//   surplus = max(0, producedFood - 2*pop)         @0x0A5F7..@0x0A603
//   accrual = min(ceil(surplus/2), cap)            @0x0A606 / @0x0A609
//   room    = max(0, capacity - herd)              @0x0A614 / @0x0A61F
//   bred    = min(accrual, room)                   @0x0A627
//   food eaten += bred                             @0x0A63F
//
// So the 25/50 Stable pair is the DIVISOR inside the per-turn cap, never the
// gate, and breeding both COSTS food and cannot push the herd past the
// warehouse -- which retires the old "the herd compounds past 65,535" flag,
// since `room` bounds it every turn.
function horsesBredThisTurn(c, producedFood, eaten) {
  const herd = c.stock[GOOD.HORSES];
  if (herd < 2) return 0;
  const t = c.buildings.includes('Stable') ? 25 : 50;
  const cap = 2 * Math.ceil(herd / t);
  const surplus = Math.max(0, producedFood - eaten);
  const accrual = Math.min((surplus + 1) >> 1, cap);
  const room = Math.max(0, warehouseCapacity(c) - herd);
  return Math.min(accrual, room);
}
// Kept for the panel and the tests: the food line only.
function colonyFood(c) {
  const r = colonyProduce(c);
  return { centre: r.centre, fields: r.out[GOOD.FOOD] - r.centre,
           produced: r.out[GOOD.FOOD], eaten: r.eaten, net: r.netFood };
}
function colonyHammers(c) { return colonyProduce(c).tally[HAMMERS]; }

// ------------------------------------------------- schoolhouse teaching
// spec/systems/training.md, byte-verified inside func_02D658 -- the per-colony
// turn processor, not a separate UI routine (a 2026-06-21 correction).
//   faculty cap = 3 per colony: Schoolhouse 1 / College 2 / University 3
//   only a colonist who has MASTERED a profession may teach (@NOTEACHER)
//   eligible students are Free Colonists, Indentured Servants, Petty Criminals
//   turns to graduate = 4 / 6 / 8 by the profession's @JOB skill class 1/2/3;
//     class 4 is not teachable at all (criminals, converts, teachers)
//   the building's level caps the class it may teach (S/C/U = 1/2/3)
//   a per-student counter ticks each turn and resets on graduation
//   @TRAINPROFESSION on graduation, @TRAINFAIL when a teacher has no student
const SCHOOL_LEVEL = { 'Schoolhouse': 1, 'College': 2, 'University': 3 };
const TEACH_TURNS = { 1: 4, 2: 6, 3: 8 };
const STUDENT_TIERS = ['Petty Criminals', 'Indentured Servants', 'Free Colonists'];
function schoolLevel(c) {
  let lv = 0;
  for (const [b, n] of Object.entries(SCHOOL_LEVEL))
    if (c.buildings.includes(b)) lv = Math.max(lv, n);
  return lv;
}
// The teacher's own skill class, from the @JOB row their expert title belongs to.
function professionClass(profession) {
  const i = DATA.jobexpert.indexOf(profession);
  return i < 0 ? 4 : DATA.jobtier[i];
}
// Teacher-assignment guards. The rules are byte-verified in the teaching
// block of func_02D658 (spec/systems/training.md §3: faculty cap = building
// level @0x02DE5B, tier cap = @JOB column 3, class >= 4 not teachable
// @0x02DE7D) and each has its own GAME.TXT refusal; WHERE the engine tests
// them (assignment-time vs turn-time) is unread -- guarding at assignment,
// and this guard ORDER, are the port's reading, flagged.
function teacherGuard(c, p) {
  const lvl = schoolLevel(c);
  if (!lvl) return false;
  const cls = professionClass(p.profession);
  // @NOTEACHER: "Only colonists who have mastered a profession may teach."
  if (!p.profession || cls >= 4) { showEvent('NOTEACHER'); return true; }
  // @NEEDCOLLEGE / @NEEDUNIVERSITY: the profession's tier exceeds the school.
  if (cls > lvl) {
    showEvent(cls === 2 ? 'NEEDCOLLEGE' : 'NEEDUNIVERSITY',
              { STRING0: p.profession });
    return true;
  }
  // @SCHOOL1/@COLLEGE2/@UNIV3: the faculty is full (cap = building level).
  if (c.colonists.filter(q => q !== p && q.job === 'Teacher').length >= lvl) {
    showEvent(['SCHOOL1', 'COLLEGE2', 'UNIV3'][lvl - 1]);
    return true;
  }
  return false;
}
// The schoolhouse pass -- REWRITTEN 2026-08-28 to the byte model
// (@0x2DDAC..@0x2E016); the old port model differed in four ways, all
// corrected:
//   - the taught counter is the TEACHER's own +0x60 nibble (every
//     colonist's nibble ticks +1 per turn, a teacher resets his on
//     graduating) -- not a runtime per-STUDENT counter;
//   - a teacher whose class threshold his nibble reaches produces one
//     graduation, at most THREE per colony per turn (@0x2DE5B), no
//     school-level faculty filter in this pass (the level gates live at
//     assignment); an unskilled teacher teaches at the Servant class
//     (0x1C->0x19 remap @0x2DE64); thresholds 4/6/8 by @JOB class;
//   - the student is picked UNIFORMLY AT RANDOM (random_int @0x2DEC5)
//     from the unskilled colonists (profession none / Free / Servant /
//     Criminal) and removed from the pool by shift;
//   - @TRAINFAIL fires only when a graduation pops with the pool EMPTY.
function runSchool(c) {
  const UNSKILLED = [null, 'Free Colonists', 'Indentured Servants',
                     'Petty Criminals'];
  const ready = [];
  const cand = [];
  for (const p of c.colonists) {
    let cnt = ((p.work || 0) & 0xF) + 1;
    if (UNSKILLED.includes(p.profession)) cand.push(p);
    if (p.job === 'Teacher' && ready.length < 3) {
      const tprof = p.profession || 'Indentured Servants';
      const cls = professionClass(tprof);
      if (cls < 4) {
        const need = cls === 1 ? 4 : cls === 2 ? 6 : 8;
        if (cnt >= need) { ready.push(tprof); cnt = 0; }
      }
    }
    p.work = cnt & 0xF;
  }
  for (const tprof of ready) {
    if (!cand.length) { cev('TRAINFAIL', { STRING0: c.name }); break; }
    const pick = Math.floor(Math.random() * cand.length);
    const s = cand[pick];
    if (s.profession === 'Petty Criminals') {
      s.profession = 'Indentured Servants';
      cev('TRAINCRIMINAL', { STRING0: c.name });
    } else if (s.profession === 'Indentured Servants') {
      // the engine writes profession 0x1C = NONE (@0x2DF35 `push 0x1c`)
      s.profession = null;
      cev('TRAININDENTURED', { STRING0: c.name });
    } else {
      s.profession = tprof;
      cev('TRAINPROFESSION', { STRING0: c.name, STRING1: tprof });
    }
    cand.splice(pick, 1);
  }
}

// --------------------------------------------------------- the colony turn
// Sons of Liberty, byte-verified (sol_membership_pct 0x8524..0x85B1 and the
// per-turn accumulator func_02D658 @0x2DA1C..0x2DAD8). Both terms are 32-bit
// exponential moving averages with a fixed 1/64 decay:
//   B -= B >> 6;  B = max(B, 1);  B += 2*pop            (capacity)
//   A += new_bells - (A >> 6);  A = max(A, 0);  A = min(A, B)
//   sol = A*100/B, +20 with Jan de Witt, capped at 100
// A just-founded colony seeds B = 200, A = 0 -- runtime-confirmed against a
// captured pop-1 Jamestown record.
const REBEL_DIVISOR_SEED = 200;
function updateSoL(c, bells) {
  const pop = c.colonists.length;
  c.rebelB = Math.max(1, (c.rebelB || REBEL_DIVISOR_SEED) - ((c.rebelB || REBEL_DIVISOR_SEED) >> 6));
  c.rebelB += 2 * pop;
  c.rebelA = Math.max(0, (c.rebelA || 0) + bells - ((c.rebelA || 0) >> 6));
  c.rebelA = Math.min(c.rebelA, c.rebelB);
  let sol = Math.floor(c.rebelA * 100 / c.rebelB);
  if (ffOwned('Jan de Witt')) sol += 20;
  c.sol = Math.min(100, sol);
}
// Food store and growth. The store is ColonyRecord +0xAA, bounded by the
// warehouse capacity (level+1)*100 (func_008D00) -- which the corrected spec
// says bounds ONLY this reserve, not per-good stock. The 199-cap / 200-for-a-
// colonist numbers are the manual's, tier R, not byte-located: flagged.
const FOOD_FOR_COLONIST = 200;
function warehouseLevel(c) {
  return (c.buildings.includes('Warehouse') ? 1 : 0) +
         (c.buildings.includes('Warehouse Expansion') ? 1 : 0);
}
// CUSTOM HOUSE auto-sale -- the byte model (func_02D658 loop 1, read
// 2026-08-28; replaces the port's unconditional over-100 auto-export). The
// sale exists ONLY with a Custom House (colony_has @BUILDING 0x12
// @0x2D980) -- without one NOTHING is ever auto-sold; the stock just climbs
// to capacity and warehouseDisposal truncates it. The human gate is the
// per-good +0x8A checkbox bit alone (test_bit_at_8a via 0x181F:0xCFE
// @0x2D9CE; bit set = exported, the .SAV cross-decode's reading); the
// protected-goods list func_02D606 (0x191F:0x9C0, near-thunk @0x2EF55)
// gates only the AI entry (@0x2D6D8/@0x2D9B8) -- rival colonies, not run
// here yet (B3.6). A checked good with stock >= 100 (@0x2D6F7) sells down
// to 50 (@0x2D705) at market price (0x191F:0x9EA -> func_030590); before
// independence the Crown's tax% is cut out (@0x2D733) into the royal fund
// (@0x2D785); after the declaration the sale is TAX-FREE ([0x5382]&1
// @0x2D728). The colony +0x1B & 3 skip (@0x2D995) is unread -- not
// modeled, TBD. Boycott: no test in the disposal bytes; whether the price
// func embeds it is unread -- the skip is kept, FLAGGED.
// Which goods an AI-owned Custom House sells -- func_02D606 (0x191F:0x9C0,
// the AI twin of the human's per-good +0x8A flag test @0x2D9CE): never
// FOOD, LUMBER, HORSES, TOOLS or MUSKETS (@0x2D60F..@0x2D62B); ORE only
// when the colony has no Armory (building 3, @0x2D633) AND made neither
// tools nor muskets this turn (the [0x8DC8] gross-production tally at
// goods 0xE/0xF, @0x2D641/@0x2D647); everything else sells.
function aiCustomSells(c, r, g) {
  if ([GOOD.FOOD, GOOD.LUMBER, GOOD.HORSES, GOOD.TOOLS, GOOD.MUSKETS].includes(g)) return false;
  if (g === GOOD.ORE)
    return !(c.buildings.includes('Armory') ||
             (r && (r.out[GOOD.TOOLS] > 0 || r.out[GOOD.MUSKETS] > 0)));
  return true;
}
function customHouseSale(c, r) {
  if (!c.buildings.includes('Custom House')) return;
  const human = curIsHuman(), p = curPower();
  // @0x2D995: a colony whose +0x1B blockade bits are set (& 3) skips the
  // auto-sale -- a Custom House will not sell from a blockaded harbour.
  // The bits come from blockadeCensus() (func_042138's colony scan).
  // HUMAN ONLY: the skip is gated on the owner's controller byte
  // (@0x2D99B..@0x2D9AE) -- an AI custom house sells through a blockade.
  if (human && (c.blockade & 3)) return;
  const rv = human ? null : rivalOf(p);
  for (let g = 0; g < c.stock.length; g++) {
    if (human) {
      if ((c.customOff || {})[g]) continue;
      // A player boycott is the PLAYER'S PowerRecord +0x20 bit (the sale
      // block itself carries no boycott test @0x2D6ED..@0x2D716; the
      // port's gate here is its own, kept as a flagged choice).
      if (isBoycotted(g)) continue;
    } else if (!aiCustomSells(c, r, g)) continue;
    if (c.stock[g] < 100) continue;
    const amount = c.stock[g] - 50;
    c.stock[g] = 50;
    // The OWNER's own bid (0x191F:0x9EA on the pass's current power, set
    // to the colony owner @0x2D67C), taxed at the OWNER's rate (+0x01
    // @0x2D737) into the OWNER's royal fund (+0x22 @0x2D785) unless the
    // war of independence is on ([0x5382]&1 @0x2D728). The sale runs the
    // Europe SELL accumulator (0x191F:0xA2E @0x2D774): pressure on every
    // pool, and the +0xBC/+0x7C trade counters.
    const gross = amount * bidPriceOf(p, g);
    const tax = human ? G.tax : ((rv && rv.tax) || 0);
    const cut = (human ? G.declared : (G.flags & WOI_DECLARED)) ? 0 : Math.floor(gross * tax / 100);
    if (human) {
      G.gold += gross - cut;
      G.kingsFund += cut;
      G.tradeTons[g] = (G.tradeTons[g] || 0) + amount;
      G.tradeGold[g] = (G.tradeGold[g] || 0) + Math.floor(gross * (100 - tax) / 100);
    } else if (rv) {
      rv.gold = (rv.gold || 0) + gross - cut;
      rv.kingsFund = (rv.kingsFund || 0) + cut;
    }
    poolMove(g, amount, +1, human);
  }
}
// WAREHOUSE disposal + cargo-ready -- the byte model (func_02D658 loops 2
// and 3, @0x2E830..@0x2EA55, read 2026-08-28), replacing the port's
// sale-refuse spoilage and its latched CARGOREADY.
//
// SPOIL (@0x2E830, goods 1..15): overflow = stock - capacity. The part of
// the overflow within TODAY'S production (pre = clamp(0, overflow,
// produced) -- func_0048CC, computed per good in loop 1 @0x2D89A) spoils
// SILENTLY: steady-state production overflow never nags, because the
// player was told once by @CARGOREADY1/2 when the good reached capacity.
// Overflow BEYOND today's production (an unloaded cargo, a shrunk
// capacity) is announced and spoiled, except a residue under 2 tons is
// tolerated to next turn (@0x2E801). One good -> @SPOIL1 (NUMBER0 tons,
// STRING1 name @0x2E88E..@0x2E8B5); several -> @SPOIL2; with a Warehouse
// Expansion the engine literally adds 2 to the key's digit character
// (@0x2E8D8) -> @SPOIL3/@SPOIL4, the variants without the "larger
// warehouse" hint. AI colonies instead SELL their overflow (@0x2E86B
// path; horse overflow feeds the power's pool @0x2E75C, muskets convert
// per 50 @0x2E72A) -- B3.6.
//
// CARGOREADY (@0x2E913, goods 1..15): edge-triggered when the stock
// crosses a 100 multiple upward this turn (floor(start/100) <
// floor(now/100) @0x2E927..@0x2E938, start = the pre-banking snapshot
// @0x2D900); key CARGOREADY0, or CARGOREADY1 when the stock sits AT
// capacity (@0x2E982) -- CARGOREADY2 with a Warehouse Expansion
// (@0x2E993) -- with NUMBER0 = capacity (@0x2E961). Gate: colony-report
// option "Report new cargos available" ([0x5384]&4 @0x2E909, default on).
function warehouseDisposal(c, snapshot, r) {
  const cap = warehouseCapacity(c);
  let count = 0, lastGood = -1, lastQty = 0;
  for (let g = 1; g < c.stock.length; g++) {
    const over = c.stock[g] - cap;
    if (over <= 0) continue;
    // AN AI COLONY SELLS ITS OVERFLOW first (@0x2E857..@0x2E86E: owner
    // controller != 0 -> 0x2E86E; the human jumps straight to the spoil
    // arithmetic @0x2E7BD), then falls into the SAME spoil arithmetic
    // below, so the stock still trims to capacity:
    //   MUSKETS: every 50 tons becomes one free musket lot on the owner's
    //     PowerRecord +0x49 byte (@0x2E72A..@0x2E743; consumed at
    //     @0x52658 -- that power's next 50-musket Europe buy is free);
    //   HORSES: the whole overflow joins the owner's +0x4A horse pool
    //     (@0x2E745..@0x2E760) and nothing is sold;
    //   the remainder sells UNTAXED at the owner's bid (0x84BC byte
    //     @0x2E7A0, gold @0x2E7B7), through the SELL accumulator
    //     (0x191F:0xA2E @0x2E76C, AI k term). The +0xBC/+0x7C counters
    //     the engine also bumps are the F5 report's, player-only here.
    if (!curIsHuman()) {
      const rv = rivalOf(curPower());
      if (rv) {
        let amt = over;
        if (g === GOOD.MUSKETS)
          while (amt >= 50) { amt -= 50; rv.musketLots = ((rv.musketLots || 0) + 1) & 0xFF; }
        if (g === GOOD.HORSES) { rv.horsePool = ((rv.horsePool || 0) + amt) & 0xFFFF; amt = 0; }
        poolMove(g, amt, +1, false);
        rv.gold = (rv.gold || 0) + amt * bidPriceOf(curPower(), g);
      }
    }
    let produced = r.out[g];
    if (g === GOOD.HORSES) produced += r.horsesBred;
    let pre = over;                    // clamp(0, over, produced), func_0048CC
    if (pre > produced) pre = produced;
    if (pre >= over) { c.stock[g] = cap; continue; }
    c.stock[g] -= pre;
    let extra = Math.min(c.stock[g], over - pre);
    if (extra < 2) extra = 0;
    if (extra) { count++; lastGood = g; lastQty = extra; }
    c.stock[g] -= extra;
  }
  if (count === 1)
    cev(warehouseLevel(c) < 2 ? 'SPOIL1' : 'SPOIL3',
              { STRING0: c.name, STRING1: DATA.cargo[lastGood].name,
                NUMBER0: lastQty });
  else if (count > 1)
    cev(warehouseLevel(c) < 2 ? 'SPOIL2' : 'SPOIL4', { STRING0: c.name });
  for (let g = 1; g < c.stock.length; g++) {
    if (Math.floor(snapshot[g] / 100) >= Math.floor(c.stock[g] / 100)) continue;
    if (c.stock[g] === cap) {
      if (curIsHuman())
        askZoom(warehouseLevel(c) < 2 ? 'CARGOREADY1' : 'CARGOREADY2',
                { STRING0: c.name, STRING1: DATA.cargo[g].name, NUMBER0: cap }, c);
    } else
      cev('CARGOREADY0',
                { STRING0: c.name, STRING1: DATA.cargo[g].name });
  }
}
// The upgrade CHAINS: @BUILDING is laid out chain by chain (the same grouping
// BUILDING_GROUP uses for plot sharing), and within a chain each tier requires
// the one below it and hides it once built -- the engine's prereq/supersede
// gates (func_0B900: min_colony @0xB940, prereq entry+3, supersede entry+2).
// Derived from the group table; the Stable shares Warehouse's plot but is NOT
// a Warehouse tier, so it is excluded from the chain logic.
const BUILDING_INDEPENDENT = new Set(['Stable']);
let _buildingChain = null;
function buildingChain() {
  // Lazy: BUILDING_GROUP is defined later in the file than this helper.
  if (_buildingChain) return _buildingChain;
  const byGroup = {};
  DATA.buildings.forEach((b, i) => {
    if (BUILDING_INDEPENDENT.has(b.name)) return;
    const g = BUILDING_GROUP[i];
    (byGroup[g] = byGroup[g] || []).push(b.name);
  });
  const prereq = {}, supersededBy = {};
  for (const g in byGroup) {
    const seq = byGroup[g].filter((n, k, a) => k === 0 || a[k - 1] !== n);
    seq.forEach((n, k) => {
      if (k > 0) prereq[n] = seq[k - 1];
      if (k < seq.length - 1) supersededBy[n] = seq.slice(k + 1);
    });
  }
  _buildingChain = { prereq, supersededBy };
  return _buildingChain;
}
// The FACTORY tier (chain link 3 of the manufacturing chains, plus the Arsenal)
// needs Adam Smith -- GAME_MANUAL.md, the "factory-level buildings require the
// services of Adam Smith" rule.
const BUILDING_FACTORY = new Set(['Textile Mill', 'Cigar Factory', 'Rum Factory',
  'Fur Factory', 'Iron Works', 'Arsenal']);

// ---- per-power pass scaffolding (B3.6) -------------------------------------
// Mirrors the C's turn_power/cur_power/cev/cask (colopy_turn.c): func_02F052
// is a PER-POWER colony pass -- the [bp+6] power selects whose colonies run,
// and everything belonging to a PLAYER rather than a colony (popups, asks,
// the treasury) is gated on it. turnPower = -1 outside a pass (the human).
let turnPower = -1;
const curPower = () => (turnPower < 0 ? G.nation : turnPower);
const curIsHuman = () => turnPower < 0 || turnPower === G.nation;
function cev(key, subs) { if (curIsHuman()) showEvent(key, subs); }
function cask(key, subs, cb, opts) {
  if (curIsHuman()) askEvent(key, subs, cb, opts);
  else cb(0);                       // a rival takes the default row, silently
}
const rivalOf = (n) => (G.rivals || []).find(r => r.nation === n);
// Founding-father consult for the pass: the C's father_owned reads
// CS.powers[cur_power()].founding_fathers -- each power its OWN Congress.
// The rival bitmask is the imported +0x07 dword (r.fathers).
function ffOwned(name) {
  if (curIsHuman()) return G.fathersOwned.includes(name);
  const r = rivalOf(curPower());
  const idx = (DATA.fathers || []).findIndex(f => f.name === name);
  return !!(r && idx >= 0 && ((r.fathers || 0) >>> idx) & 1);
}

// What a colony may build: an @BUILDING row it does not already have, whose
// min_colony gate its population meets, whose predecessor tier is built, that
// is not superseded by a higher tier already up, and whose special prerequisite
// (Peter Stuyvesant / Adam Smith) is met. Cost is the hammers column; tools_x10
// is the tools requirement in tens (§26.8 / @BUILDING).
function buildOptions(c) {
  const pop = c.colonists.length;
  const built = (n) => c.buildings.includes(n);
  const chain = buildingChain();
  return DATA.buildings
    .map((b, i) => ({ i, ...b }))
    .filter(b => !built(b.name) && b.min_colony <= pop)
    // The predecessor tier must already stand, and no higher tier may.
    .filter(b => !chain.prereq[b.name] || built(chain.prereq[b.name]))
    .filter(b => !(chain.supersededBy[b.name] || []).some(built))
    // Peter Stuyvesant enables the Custom House and nothing else does
    // (func_00B900 @0xBA37).
    .filter(b => b.name !== 'Custom House' || G.fathersOwned.includes('Peter Stuyvesant'))
    .filter(b => !BUILDING_FACTORY.has(b.name) || G.fathersOwned.includes('Adam Smith'))
    .concat(unitBuildRows(c));
}
// Colony-built UNITS. The manual (HIGH trust for function) gates them: a
// Wagon Train anywhere, Artillery once an Armory-chain building stands
// ("an armory also allows your carpenters to make artillery units"), ships
// once the Shipyard is up. Materials come from the @UNIT Cost/Tools columns
// ("build materials", GAME_INDEX_TABLES) -- tools scale x10 like @BUILDING's
// tools_x10; the x32 HAMMER scale is inferred from the six known ship costs
// (Caravel 4->128 ... Frigate 16->512) and is flagged, not byte-verified.
// Man-O-War is the King's own and is never offered.
const UNIT_HAMMER_SCALE = 32;
const BUILDABLE_UNITS = ['Wagon Train', 'Artillery', 'Caravel', 'Merchantman',
                         'Galleon', 'Privateer', 'Frigate'];
function unitBuildRow(name) {
  const u = unit(name);
  // BYTE_VERIFIED cost func_00B65A (thunk 0x181F:0xAC4): a buildable unit
  // (production ids 0x2A..0x30 -> @UNIT rows 11..17, classifier
  // func_00B5A8 @0xB5BE) prices at its @UNIT hammers byte x32 (@0x0B6B7
  // shl ax,5) with the clamp ladder <40 -> 40, 40..51 -> 52 (@0x0B6BD..
  // @0x0B6CF; only the 40 floor is reachable for x32 inputs -- it is what
  // prices the Wagon Train's 1x32=32 at the picker's "(40 Hammers)").
  // Tools = the next byte x10 (@0x0B6E3, same x10 as buildings @0x0B694).
  let cost = u.cost * UNIT_HAMMER_SCALE;
  if (cost < 40) cost = 40;
  else if (cost < 52) cost = 52;
  return u && { name, cost, tools_x10: u.tools, isUnit: true };
}
function unitBuildRows(c) {
  return BUILDABLE_UNITS.filter(n => {
    if (n === 'Wagon Train') return true;
    if (n === 'Artillery')
      return ['Armory', 'Magazine', 'Arsenal'].some(b => c.buildings.includes(b));
    return c.buildings.includes('Shipyard');
  }).map(unitBuildRow).filter(Boolean);
}
// One colony's whole turn: produce, bank, eat, grow, build, then dispose of the
// overflow.
// The seven per-good input-outage keys -- each raw feeding a converter chain
// has its own "has run out of X" body (@TOOLS is the gunsmiths').
const OUTAGE_KEY = { [GOOD.SUGAR]: 'CANESUGAR', [GOOD.TOBACCO]: 'TOBACCO',
                     [GOOD.COTTON]: 'COTTON', [GOOD.FURS]: 'FURS',
                     [GOOD.LUMBER]: 'LUMBER', [GOOD.ORE]: 'ORE',
                     [GOOD.TOOLS]: 'TOOLS' };
// @SIEGE: "enemy combat units outnumber friendly combat units in the
// area" -- the land-adjacency siege (diplomacy.md: no blockade mechanic
// exists; SIEGE restricts a besieged colony's production to military
// units). "Area" = radius 1 is the port's reading, flagged; the port
// builds neither Soldiers nor Dragoons in colonies, so the restriction
// lands as construction waiting out the siege.
function colonyBesieged(c) {
  const near = (u) => !u.ship && Math.abs(u.x - c.x) <= 1 && Math.abs(u.y - c.y) <= 1;
  const enemies = G.refUnits.filter(near).length +
    G.rivals.reduce((n, r) => n + (atWar(G.nation, r.nation)
      ? r.units.filter(near).length : 0), 0);
  const friends = G.units.filter(u => near(u) &&
    Number((unit(u.type) || {}).attack) > 0).length;
  return enemies > friends;
}
function colonyTurn(c) {
  // The start-of-turn stocks, captured before anything banks: the food word
  // is the starvation-death gate's [bp-0x6a] (@0x2D6BF), the whole array is
  // the cargo-ready snapshot [bp-0xac] (@0x2D900).
  const snapshot = c.stock.slice();
  const startFood = snapshot[GOOD.FOOD];
  const r = colonyProduce(c);
  c.dbgFE = [r.out[GOOD.FOOD], r.eaten];   // the rcol oracle's `fe`
  // The siege census is player-relative (enemies of G.nation) -- a rival
  // colony has no siege model yet (B3.6, FLAGGED; same gate in the C).
  if (curIsHuman() && colonyBesieged(c)) {
    if (!c.sieged) { c.sieged = true; cev('SIEGE'); }
  } else c.sieged = false;
  // Input-outage latches: a manned converter starved of its raw announces
  // once, and re-arms when the chain runs again. The engine's latch site is
  // unread; the once-per-outage cadence is the port's reading, flagged.
  c.outageLatch = c.outageLatch || {};
  for (const raw of r.outages) {
    if (!OUTAGE_KEY[raw] || c.outageLatch[raw]) continue;
    c.outageLatch[raw] = true;
    cev(OUTAGE_KEY[raw], { STRING0: c.name });
  }
  for (const k of Object.keys(c.outageLatch))
    if (!r.outages.has(Number(k))) delete c.outageLatch[k];
  for (let i = 0; i < r.out.length; i++)
    c.stock[i] = Math.max(0, c.stock[i] + r.out[i]);      // banked with a floor at 0
  // The foals join the herd; their feed is already inside r.eaten
  // (BYTE_VERIFIED func_00A3E1 @0x0A63F -- see horsesBredThisTurn).
  c.stock[GOOD.HORSES] += r.horsesBred;
  // Food: eat first, then the surplus feeds the growth store. The engine posts
  // real popups here (func_02D658), not status-bar lines: a low-food WARNING
  // (@FOODLOW, once, while stores are thin), then STARVATION (@STARVE1) when a
  // colonist is lost, and a BIRTH (@NEWCOLONIST) on growth.
  c.stock[GOOD.FOOD] = Math.max(0, c.stock[GOOD.FOOD] - r.eaten);
  // The Custom House sells checked goods down to 50 right at the banking
  // loop (func_02D658 loop 1), before growth reads the food stock.
  customHouseSale(c, r);
  // FOOD MESSAGES + GROWTH -- the byte model, func_02D658 @0x2E10A..@0x2E36C
  // (read 2026-08-28), replacing the port's latch-based reading. The engine's
  // order is growth, then starvation, then the low-food warning, and the
  // seasonal message variant is picked by the season word [0x538C]
  // (0 = spring @0x2E19A), which only goes nonzero from 1600 -- G.season
  // mirrors it exactly.
  //
  // GROWTH @0x2E10A: threshold = thunk 0x181F:0xCB8 -> func_0098B4 with two
  // null out-args, and that function returns the CONSTANT 0xC8 = 200
  // (@0x98BD) -- the long-flagged 200-food rule is now byte-verified
  // (@0x2E11D compare, @0x2E123 deduct). The child is NOT a colony member:
  // the engine spawns a type-0 (Colonists) UNIT on the colony square via
  // 0x181F:0x95C -> func_006D24 (0, owner, x, y) (@0x2E136) -- he waits at
  // the fence, exactly what @NEWCOLONIST says: "New colonist now
  // available." (id 0xE2F @0x2E156).
  if (c.stock[GOOD.FOOD] >= FOOD_FOR_COLONIST) {
    c.stock[GOOD.FOOD] -= FOOD_FOR_COLONIST;
    // func_006D24 spawns the unit with the COLONY'S owner -- a rival birth
    // joins the rival's unit list (B3.6).
    if (curIsHuman()) G.units.push(mkUnit('Colonists', c.x, c.y));
    else {
      const rv = rivalOf(curPower());
      if (rv) rv.units.push({ type: 'Colonists', icon: unit('Colonists').icon,
                              x: c.x, y: c.y, nation: curPower(),
                              orders: 0, ship: false });
    }
    cev('NEWCOLONIST', { STRING0: c.name });
  }
  const autumn = G.season !== 0;
  // STARVATION @0x2E164: the trigger is the food OUTAGE plane [0x8E5A]
  // (max(0, eaten - start-stock - produced), func_008E02 @0x8E5A) -- not the
  // banked stock. AI powers are forgiven an outage below 3 (@0x2E177 --
  // live for the rival pass, B3.6). A colonist DIES only when the
  // colony ENTERED the turn with no food at all ([bp-0x6a] @0x2D6BF, tested
  // @0x2E1AD); on difficulty <= 1 the death is waived before 1520 (@0x2E1C0)
  // and afterwards survives only a random_int(0, 2-diff) == 0 roll
  // (@0x2E1D4). No death -> @FOOD1/@FOOD2; a death that empties the colony
  // -> @VANISH (@0x2E265, the removal then empties it and the colony is
  // destroyed @0x2E2F8); otherwise @STARVE1/@STARVE2. Each death removes a
  // RANDOM colonist random_int(0, size-1) via func_008FB4 (@0x2E2C6).
  let outage = r.outageAmt[GOOD.FOOD];
  // AI powers are forgiven an outage below 3 (@0x2E177) -- live now that
  // the pass runs rival colonies (B3.6).
  if (!curIsHuman() && outage < 3) outage = 0;
  if (outage > 0) {
    let deaths = startFood === 0 ? 1 : 0;
    if (deaths && G.difficulty <= 1) {
      if (G.year < 1520) deaths = 0;
      else if (Math.floor(Math.random() * (3 - G.difficulty)) !== 0) deaths = 0;
    }
    if (deaths === 0) cev(autumn ? 'FOOD2' : 'FOOD1', { STRING0: c.name });
    else if (c.colonists.length === deaths) cev('VANISH', { STRING0: c.name });
    else cev(autumn ? 'STARVE2' : 'STARVE1', { STRING0: c.name });
    for (let d = 0; d < deaths; d++)
      c.colonists.splice(Math.floor(Math.random() * c.colonists.length), 1);
    if (c.colonists.length === 0) c.vanished = true;   // destroy @0x2E2F8
  } else {
    // @FOODLOW @0x2E30A: fires (no latch) while the OVERDRAW plane [0x8E32]
    // (max(0, eaten - produced)) is nonzero and the banked stock covers fewer
    // than 4 such turns (stock < 4*overdraw, @0x2E314/@0x2E31B), with the
    // stock as %NUMBER (@0x2E33D). Gate: colony-report option "Report food
    // shortages" ([0x5384] bit 0x40, set = suppress, @0x2E321) -- the port
    // has no options dialog yet, so the default all-on applies.
    const overdraw = r.netFood < 0 ? -r.netFood : 0;
    if (overdraw > 0 && 4 * overdraw > c.stock[GOOD.FOOD])
      cev('FOODLOW', { STRING0: c.name, NUMBER0: c.stock[GOOD.FOOD] });
  }
  // Tutorial bindings: TUTORIAL6 (func_02D658 @0x2EA4C) when a sellable
  // cargo has built up; 7 (func_02883E @0x28D41) when the colony can use a
  // stockade; 16 on the first food deficit. Thresholds flagged.
  const sellable = c.stock.map((n, i) => [n, i])
    .filter(s => s[1] !== GOOD.FOOD && s[0] >= 50).sort((a, b) => b[0] - a[0])[0];
  if (sellable)
    tutOnce(6, { NUMBER0: sellable[0], STRING0: DATA.cargo[sellable[1]].name,
                 STRING1: c.name, STRING2: DATA.nations[G.nation].homeport });
  if (c.colonists.length >= 3) tutOnce(7, { STRING0: c.name });
  if (r.netFood < 0) tutOnce(16);
  // MINE DEPLETION -- the full byte model (2026-08-28), replacing the old
  // flagged 1/50-per-silver-cell stand-in: colonyProduce accrued
  // r.depletionPts ([0xA896]) off the worked minerals; each point rolls
  // random_int(0, difficulty+1) (@0x2EA62) and a NONZERO roll bumps the
  // record's +0x97 counter (@0x2EA7B); at 50 it wraps (@0x2EA8A) and the
  // action func_02D30A marks EVERY worked ore/silver cell whose detail is
  // Minerals (6) or a Depleted Mine (12) with improve bit 4 (@0x2D383) --
  // killing the resource bonus and showing the Depleted Mine through
  // detailId's imp&4 gate -- and emits @DEPLETION once (@0x2D3A1).
  for (let pt = 0; pt < (r.depletionPts || 0); pt++) {
    if (Math.floor(Math.random() * (G.difficulty + 2)) === 0) continue;
    c.depletionCounter = (c.depletionCounter || 0) + 1;
    if (c.depletionCounter < 50) continue;
    c.depletionCounter -= 50;
    let fired = false;
    for (const p of c.colonists) {
      if (!p.cell) continue;
      const ji = jobIndex(p.job);
      if (ji !== 6 && ji !== 7) continue;
      const tx = c.x + p.cell[0], ty = c.y + p.cell[1];
      const det = detailId(tx, ty, at(tx, ty));
      if (det !== 6 && det !== 12) continue;
      IMPROVE[ty * MAP.w + tx] |= 4;
      if (!fired) { cev('DEPLETION', { STRING0: c.name }); fired = true; }
    }
  }
  c.crossesTurn = r.tally[CROSSES];
  // bells: the Press/Newspaper multipliers now live INSIDE colonyProduce
  // (@0xA587..@0xA5AC act on the total there) -- applying them again here
  // double-counted
  const bells = r.tally[BELLS];
  c.bellsTurn = bells;
  r.tally[BELLS] = bells;
  updateSoL(c, r.tally[BELLS]);
  solAnnounce(c);
  // @INEFFICIENT/@EFFICIENT: the tory production-penalty latch, announced on
  // each crossing (the solAnnounce latch pattern). NUMBER0 = the byte-cited
  // 10-difficulty tories-per-penalty divisor.
  const pen = toryPenalty(c);
  if (pen < 0 && !c.ineffLatch) {
    c.ineffLatch = true;
    cev('INEFFICIENT', { STRING0: c.name, NUMBER0: 10 - G.difficulty });
  } else if (pen >= 0 && c.ineffLatch) {
    c.ineffLatch = false;
    cev('EFFICIENT', { STRING0: c.name });
  }
  advanceConstruction(c, r.tally[HAMMERS]);
  runSchool(c);
  fieldLearning(c);
  warehouseDisposal(c, snapshot, r);
}
// FIELD LEARN-BY-DOING -- byte-read @0x2E01C..@0x2E107 (2026-08-28), a
// mechanic the port lacked entirely: converts never learn (@0x2E05E); only
// the unskilled tiers may (func_0082B2: none / Free Colonists / Indentured
// Servants / Petty Criminals); only the PLANTER/TRAPPER jobs 1..4 teach
// themselves (@0x2E070); the roll happens only when the power owns ZERO of
// that specialty ([job-0x6BD0], the per-power profession census
// func_042726 builds from every unit record + colonist); odds
// random_int(0, N) == 0 with N = 99 / 199 servant / 299 criminal; success
// sets the profession to the job's expert and emits @TRAINPROFESSION.
function profOwnedCount(title) {
  let n = 0;
  const hit = (t) => { if (t === title) n++; };
  for (const cc of G.colonies)
    for (const p of cc.colonists) hit(p.profession);
  for (const u of G.units) {
    hit(u.profession);
    for (const e of (u.cargo || [])) if (e && e.name) hit(e.name);
  }
  for (const e of G.europe)
    for (const q of (e.passengers || [])) if (q && q.name) hit(q.name);
  for (const q of G.dockUnits) if (q && q.name) hit(q.name);
  return n;
}
function fieldLearning(c) {
  for (const p of c.colonists) {
    if (p.profession === 'Indian Converts') continue;
    if (p.profession && p.profession !== 'Free Colonists' &&
        p.profession !== 'Indentured Servants' &&
        p.profession !== 'Petty Criminals') continue;
    const occ = jobIndex(p.job);
    if (occ < 1 || occ > 4) continue;
    const title = DATA.jobexpert[occ];
    if (profOwnedCount(title) !== 0) continue;
    let n = 99;
    if (p.profession === 'Indentured Servants') n = 199;
    if (p.profession === 'Petty Criminals') n = 99 + 200;
    if (Math.floor(Math.random() * (n + 1)) !== 0) continue;
    p.profession = title;
    cev('TRAINPROFESSION', { STRING0: c.name, STRING1: title });
  }
}
// One turn of construction: bank this colony's hammers, then finish the target
// if it is paid for. Tools are consumed with the hammers.
function advanceConstruction(c, hammers) {
  c.hammers += hammers === undefined ? colonyHammers(c) : hammers;
  const b = c.building && (DATA.buildings.find(d => d.name === c.building) ||
                           (BUILDABLE_UNITS.includes(c.building) &&
                            unitBuildRow(c.building)));
  if (!b) return;
  const needTools = b.tools_x10 * 10;
  if (c.sieged) return;                     // @SIEGE halts completion
  if (c.hammers < b.cost) { c.toolWarned = false; return; }
  // Completion-time guards. @NOMOREWAGONS -- BYTE-READ @0x2D1B3..@0x2D20A
  // (2026-09-02): when the finished target is the Wagon Train (0xC) the
  // owner's unit census [0x924C + p*0x13 + 0xC] is compared with the
  // owner's colony count [0x9298 + p] (@0x2D1C2..@0x2D1CD); at or over
  // it the message fires and the routine RETURNS before spawning. There
  // is NO controller gate -- every power is capped; the message goes
  // through the colony messenger, silent for a rival (cev).
  if (b.isUnit && b.name === 'Wagon Train') {
    const human = curIsHuman(), rv = human ? null : rivalOf(curPower());
    const units = human ? G.units : ((rv && rv.units) || []);
    const ncol = human ? G.colonies.length : ((rv && rv.colonies) || []).length;
    const wagons = units.filter(u => u.type === 'Wagon Train').length;
    if (wagons >= ncol) {
      if (!c.capWarned) {
        c.capWarned = true;
        cev('NOMOREWAGONS', { STRING0: c.name, NUMBER0: ncol });
      }
      return;
    }
  }
  c.capWarned = false;
  // @ALREADYHAVE / @NOMOREWAREHOUSE: the target already stands (reachable
  // when circumstances changed after the pick); the target is cleared.
  if (!b.isUnit && c.buildings.includes(b.name)) {
    cev(b.name === 'Warehouse Expansion' ? 'NOMOREWAREHOUSE' : 'ALREADYHAVE',
              { STRING0: c.name, STRING1: b.name });
    c.building = null;
    return;
  }
  // Hammers are ready but the tools are short: the engine posts @NEEDTOOLS /
  // @NEEDTOOLS0 (STRING0=colony, STRING1=building, NUMBER0=needed, NUMBER1=on
  // hand) and the building waits. Once per stall, not every turn.
  if (c.stock[GOOD.TOOLS] < needTools) {
    if (!c.toolWarned) {
      c.toolWarned = true;               // the latch sets for every owner
      const have = c.stock[GOOD.TOOLS];
      if (curIsHuman())
        askZoom(have > 0 ? 'NEEDTOOLS' : 'NEEDTOOLS0',
                { STRING0: c.name, STRING1: b.name, NUMBER0: needTools, NUMBER1: have }, c);
    }
    return;
  }
  c.toolWarned = false;
  // Completion ZEROES the hammer bank -- surplus is NOT carried
  // (BYTE_VERIFIED @0x2D26C mov word [bx+0x92], 0, the common tail of
  // func_02D0E4; the only debit on the way in is the tools payment
  // @0x2E6A7).
  c.hammers = 0;
  c.stock[GOOD.TOOLS] -= needTools;
  if (b.isUnit) {
    // A finished unit steps onto the colony square (ships sit in port there,
    // the same tile colonyShip reads) -- with the COLONY'S owner: a rival's
    // build joins the rival's unit list (B3.6).
    if (curIsHuman()) G.units.push(mkUnit(b.name, c.x, c.y));
    else {
      const rv = rivalOf(curPower());
      if (rv) rv.units.push({ type: b.name, icon: unit(b.name).icon,
                              x: c.x, y: c.y, nation: curPower(), orders: 0,
                              ship: unit(b.name).hull > 0 });
    }
  } else {
    c.buildings.push(b.name);
    // @MERCANTILISM: a profit-taking manufactory draws the Crown's tax raise
    // (manual-cited pretext; the rate/amount are flagged stand-ins). The
    // Crown taxes only the PLAYER -- a rival's factory raises nothing here.
    if (curIsHuman() &&
        BUILDING_FACTORY.has(b.name) && G.tax < 75 && !(G.flags & WOI_DECLARED)) {
      G.tax += 1;
      cev('MERCANTILISM', { STRING0: b.name,
                                  STRING1: DATA.nations[G.nation].adjective,
                                  NUMBER0: 1, NUMBER1: G.tax });
    }
  }
  c.building = null;
  // @BUILT: "%STRING0 colony produces {%STRING1}." (STRING0=colony, STRING1=the
  // building) -- a popup, not a status line.
  cev('BUILT', { STRING0: c.name, STRING1: b.name });
}

// The rush-buy (@BUYME0 info / @BUYME1 confirm, width 160): pay gold to
// finish the construction target now. BYTE_VERIFIED 2026-08-29
// (@0x2B779..@0x2B8C2, the @BUYME dialog builder):
//   price = 13 x remaining hammers (@0x2B7B2, the x3 x4 +1 chain)
//         + (tools price level [+0x4C+14] + 4) x missing tools (@0x2B7CF)
//   ... then DOUBLED when NO hammers are banked yet (+0x92 == 0,
//   @0x2B7E9) -- which is why census3's untouched Docks quoted 26$/hammer
//   (13 x 2, zero banked) while the older started build did not fit.
// gold >= price -> the @BUYME1 confirm (row 2 = Complete it, [bp-4]==2
// @0x2B872); short -> the @BUYME0 info. Accepting tops the hammer bank to
// the cost (the overage into the +0x98 bought tally @0x2B88A), adds the
// MISSING TOOLS to stock (+0xB6 += shortfall @0x2B8BA) and debits the
// gold (0x181f:0xaf6 @0x2B8A5).
// @CUSTOM "Which cargos shall our {Custom House} export?" -- the per-good
// export toggle. The engine's picker format (runtime rows) is unread; the
// port re-opens the single-pick popup per toggle, '*' marking exported
// goods, flagged. customHouseSale consults the toggles when the house stands.
function customHouseMenu() {
  const c = G.colonies[G.colony];
  if (!c || !c.buildings.includes('Custom House')) return;
  c.customOff = c.customOff || {};
  const rows = DATA.cargo.map((g, i) => `${c.customOff[i] ? '  ' : '* '}${g.name}`)
                         .concat(['Done']);
  askEvent('CUSTOM', {}, (choice) => {
    if (choice < 0 || choice >= DATA.cargo.length) return;
    c.customOff[choice] = !c.customOff[choice];
    customHouseMenu();
  }, rows);
}
function rushBuy() {
  const c = G.colonies[G.colony];
  const b = c && c.building && (DATA.buildings.find(d => d.name === c.building) ||
            (BUILDABLE_UNITS.includes(c.building) && unitBuildRow(c.building)));
  if (!b) return;
  const remH = Math.max(0, b.cost - c.hammers);
  const remT = Math.max(0, b.tools_x10 * 10 - c.stock[GOOD.TOOLS]);
  let cost = 13 * remH + (G.market[GOOD.TOOLS] + 4) * remT;
  if (c.hammers === 0) cost *= 2;                /* unstarted: x2 @0x2B7E9 */
  const S = { STRING0: b.name, NUMBER0: cost, NUMBER1: G.gold };
  if (cost > G.gold) { showEvent('BUYME0', S); return; }
  askEvent('BUYME1', S, (choice) => {
    if (choice !== 1) return;                    // row 2 = "Complete it."
    G.gold -= cost;
    c.hammers = Math.max(c.hammers, b.cost);
    c.stock[GOOD.TOOLS] += remT;                 /* the shortfall @0x2B8BA */
    advanceConstruction(c, 0);
  });
}

// A ship entering the sea lane leaves the map for the home port. Ships carry a
// hold of {good, qty} slots plus passenger units; the crossing takes three
// turns, which is what the sail-state 1/2/3 bands in §26.9 count down.
const SAIL_TURNS = 3;
function sailForEurope(ship) {
  tutOnce(11, { STRING0: ship.type, STRING1: DATA.nations[G.nation].homeport });
  G.europe.push({ type: ship.type, icon: ship.icon, hold: ship.hold || [],
                  passengers: ship.cargo || [], state: 'toEurope', turns: SAIL_TURNS,
                  damaged: ship.damaged || false, work: ship.work || 0,
                  lane: { x: ship.x, y: ship.y } });
  G.units.splice(G.units.indexOf(ship), 1);
  G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
  G.msg = '';
}
// Sail the other way: the ship leaves the dock and reappears on the sea lane.
// Anyone standing on the dock boards first -- that is what the dock queue is
// waiting for.
function sailForNewWorld(e) {
  e.passengers = e.passengers || [];
  // Dock units board the sailing ship in order -- EXCEPT any held back by the
  // @ARMOPTIONS "Don't get on next ship" flag, which wait for a later one.
  for (let i = 0; i < G.dockUnits.length && e.passengers.length < 6; ) {
    const u = G.dockUnits[i];
    if (u && typeof u === 'object' && u.noBoard) { i++; continue; }
    e.passengers.push(u);
    G.dockUnits.splice(i, 1);
  }
  e.state = 'toNewWorld';
  e.turns = SAIL_TURNS;
  G.euroMsg = `${e.type} sets sail.`;
}
// Advance every crossing by one turn; arrivals dock or make landfall.
function advanceCrossings() {
  for (let k = G.europe.length - 1; k >= 0; k--) {
    const e = G.europe[k];
    // Damaged-ship repair, Europe half -- BYTE_VERIFIED func_02F052
    // @0x2F0E0..@0x2F1E2 (read 2026-08-29): every damaged ship ticks +1 a
    // turn; the on-map bounds bonus (@0x2F0FE) fails off-map, so ships in
    // Europe (crossing or docked) repair at HALF the map rate. Complete at
    // the @UNIT defense column (+0x5235 = unit.combat, @0x2F126), @REFIT
    // names the homeport (@0x2F1BA). The counter reset on completion is
    // the port's own hygiene (the engine leaves +0x16 stale), flagged.
    if (e.damaged) {
      e.work = (e.work || 0) + 1;
      if (e.work >= (unit(e.type) || {}).combat) {
        e.damaged = false;
        e.work = 0;
        showEvent('REFIT', { STRING0: e.type,
                             STRING1: DATA.nations[G.nation].homeport });
      }
    }
    if (e.state === 'port') continue;
    if (--e.turns > 0) continue;
    // Docking in Europe brings up the harbour, the way arriving does in game.
    // The units aboard DISEMBARK TO THE DOCK (@TUTORIAL15's "fence" model on
    // the Europe side): that is where the @ARMOPTIONS dock-unit menu lives,
    // and boarding/sailing takes them back aboard.
    if (e.state === 'toEurope') {
      e.state = 'port';
      // (The old instant damage-clear on docking is gone: repair is the
      // byte-verified timer above -- Europe ships mend at 1 tick a turn.)
      for (const p of (e.passengers || [])) G.dockUnits.push(p);
      e.passengers = [];
      G.euroShip = shipsInPort().indexOf(e);
      G.euroMsg = `${e.type} arrives in ${DATA.nations[G.nation].homeport}.`;
      G.screen = 'europe';
      // @SOMEBOYCOTT belongs HERE, not to the interactive sell: the
      // arrival/auto-unload handler func_03314E posts it @0x3331A when the
      // docking hold carries a boycotted good.
      if ((e.hold || []).some(h => h.qty > 0 && isBoycotted(h.good)))
        showEvent('SOMEBOYCOTT');
      // The FIRST arrival carrying cargo plays CARGO FROM THE NEW WORLD
      // (func_041EEA @0x0420EF), then hands back to the harbour.
      if ((e.hold || []).some(h => h.qty > 0)) woodcutOnce(9, 'europe');
      continue;
    }
    // Back on the map, on the sea lane it left from.
    const u = mkUnit(e.type, e.lane ? e.lane.x : MAP.w - 1, e.lane ? e.lane.y : 20,
                     e.passengers);
    u.hold = e.hold;
    if (e.damaged) { u.damaged = true; u.work = e.work || 0; }
    G.units.push(u);
    G.europe.splice(k, 1);
  }
}
const holdQty = (e, i) => { const s = e.hold.find(h => h.good === i); return s ? s.qty : 0; };
function holdAdd(e, i, qty) {
  const s = e.hold.find(h => h.good === i);
  if (s) { s.qty += qty; if (s.qty <= 0) e.hold.splice(e.hold.indexOf(s), 1); }
  else if (qty > 0) e.hold.push({ good: i, qty });
}

// ------------------------------------------------------------ colony screen
// §26.8. Composed in the documented order: WOODTILE region fill from (0,0),
// the building field, the COLONY.PIK town strip at y=128, the 5x5 scene window,
// the three panels, and the stockpile bar. Geometry is the byte-cited region
// table; the field's sand ground is sampled from docs/screens/11_colony_screen.png.
//
// The 15 building plots are the DS:0x266 positions, RAM-read 2026-08-06. The
// per-colony RNG shuffle (func_025D34) that decides WHICH plot each building
// lands on is simulated and verified against two live colonies -- see
// colonyPlacement() below. What a BRAND-NEW colony starts with is still the
// port's own STARTING_BUILDINGS list rather than a byte-cited one: the def
// table 0x8E82 is filled at runtime and its initialiser is untraced, so that
// set would need either the initialiser read or a shipped COLONY??.SAV parsed.
// Plot positions, RAM-READ 2026-08-06 from `[0x266]` (x,y word pairs, stride 4)
// with tools/colony_seed_probe.py -- these are the raw table values; the
// painters blit at (x, y+8), which is why they used to be stored pre-offset.
const PLOTS = [[56,5],[145,7],[173,10],[8,33],[37,37],[67,46],[96,45],[6,6],
               [128,45],[10,68],[15,94],[87,3],[66,79],[123,98],[123,47]];
// `[0x224]` counts and `[0x22A]` starts, same read. The category-per-plot table
// is rebuilt from them each time a colony opens (@0x025D7B).
const PLOT_COUNTS = [7,4,2,1,1], PLOT_STARTS = [0,7,11,13,14];
const PLOT_CATEGORY = PLOT_COUNTS.flatMap((n, cat) => Array(n).fill(cat));
// `[0x260]`: the scenery frame drawn on an empty plot of each category, 0 = none.
const PLOT_DECOR = [45,44,43,0,46,0];
// Which plot each BUILDING GROUP occupies. RAM-read from `[0x8F88 + id*12]`
// (the record's +1 byte; +0 is the category, which is exactly the @BUILDING
// `size` column -- checked against all 42 rows). Buildings in one upgrade chain
// share a group, so an upgrade replaces its predecessor on the same plot; Town
// Hall and Capitol share group 3 for the same reason. This byte is NOT one of
// the five columns the @BUILDING loader parses and its writer is unidentified,
// so the table below is measured, not derived -- flagged as such.
const BUILDING_GROUP = [
  0,0,0, 1,1,1, 2,2,2, 3,3,3, 4,4,4, 5,5,5, 6, 7,7, 8,8,8, 9,9,9,
  10,10,10, 3,3, 11,11,11, 12,12, 13,13, 14,14,14,
];

// ---- colony building placement: `func_025D34 @0x025D34`, simulated ---------
// This was TBD from 2026-06-24 to 2026-08-06 on the grounds that it is "RNG".
// It is -- but the RNG is a plain LCG seeded from a value the port can hold, so
// it simulates exactly. Verified against live DOSBox RAM (two colonies, both
// phases, every element): see notes/rulings/RULINGS.md 2026-08-06b.
//
// `rand`/`srand` are the Microsoft C runtime's, byte-read at file 0x0103D4 /
// 0x0103C2: state = state*214013 + 2531011, result = (state >> 16) & 0x7FFF.
function ColonyRng(seed) { this.s = seed >>> 0; }
ColonyRng.prototype.next = function () {
  // 32-bit multiply in two halves -- JS numbers lose the low bits above 2^53.
  const lo = (this.s & 0xFFFF) * 214013;
  const hi = ((this.s >>> 16) * 214013) & 0xFFFF;
  this.s = ((((lo >>> 16) + hi) & 0xFFFF) * 0x10000 + (lo & 0xFFFF) + 2531011) >>> 0;
  return (this.s >>> 16) & 0x7FFF;
};
// `func_00C322 @0x00C322` (0x181F:0x4D4): lo + ((rand*(hi-lo+1)) >> 15).
ColonyRng.prototype.range = function (lo, hi) {
  return lo + ((this.next() * (hi - lo + 1)) >> 15);
};

// Which BUILDING frame a plot's occupant draws -- `func_026DD4 @0x026DD4`.
// Base frame is def_id+1 (@0x026DE5), with three overrides, all of which are
// **building-presence queries** through `0x181F:0x9FC`, not garrison counts as
// the spec used to gloss them:
//   def 0 and no Stockade built      -> EXE 0x11   (@0x026DEC-0x026E00)
//   def 0x0F/0x11 and no Warehouse   -> EXE 0x2F   (@0x026E11-0x026E1D)
//   ...with Warehouse AND Stable     -> EXE 0x30   (@0x026E1F-0x026E2D)
// Warehouse (0x0F), Warehouse Expansion (0x10) and Stable (0x11) all sit in
// group 5, i.e. they share one plot, so that plot draws a combined sprite for
// whichever pair is standing. Returned in bundle space (EXE-1).
function buildingFrame(c, id) {
  const has = (n) => c.buildings.includes(DATA.buildings[n].name);
  let frame = id + 1;
  if (id === 0 && !has(0)) frame = 0x11;
  if (id === 0x0F || id === 0x11) {
    if (!has(0x0F)) frame = 0x2F;
    else if (has(0x11)) frame = 0x30;
  }
  return frame - 1;
}

// Returns 15 entries, one per plot: the index into DATA.buildings of the
// building standing there, or -1 for an empty plot.
function colonyPlacement(c) {
  // `func_009726 @0x009726`: seed = (y<<8) + x + dword[0x8D80]; the srand
  // wrapper @0x00C30A passes only the low word and masks it (`and ah,0x7f`).
  const seed = (((c.y << 8) + c.x + (G.plotSeedBase >>> 0)) >>> 0) & 0x7FFF;
  const rng = new ColonyRng(seed);
  // Phase C @0x025DBF: each of the 15 slots draws a plot inside its own
  // category, retrying while that plot is taken.
  const shuffle = new Array(15).fill(-1);
  for (let i = 0; i < 15; i++) {
    const cat = PLOT_CATEGORY[i];
    let plot;
    do { plot = rng.range(0, PLOT_COUNTS[cat] - 1) + PLOT_STARTS[cat]; }
    while (shuffle[plot] >= 0);
    shuffle[plot] = i;
  }
  // Phase D loop 1 @0x025E0E: the first building def of each group claims the
  // next free slot within that group's category.
  const groupSlot = new Array(15).fill(-1), nextInCat = [0, 0, 0, 0, 0];
  DATA.buildings.forEach((b, id) => {
    const g = BUILDING_GROUP[id];
    if (groupSlot[g] < 0) {
      const cat = Number(b.size);
      groupSlot[g] = PLOT_STARTS[cat] + nextInCat[cat]++;
    }
  });
  // Phase D loop 2 @0x025E61: for every building the colony HAS (def 0 always),
  // present[ shuffle[slot] ] = def id. Note the engine indexes `[0x8E92]` by
  // SLOT here and by PLOT in phase C -- it reads the permutation both ways
  // round. That is the engine's own quirk, and reproducing it is the only way
  // to get the same layout, so it is reproduced rather than "fixed".
  // @BUILDING has THREE rows literally named "Town Hall" (ids 9/10/11), so a
  // name lookup is ambiguous where the engine's def-id query is not. The port
  // stores building names, so a name resolves to its LOWEST def id -- which is
  // what the live colonies show (Jamestown and Curacao both sit on id 9). A
  // colony that had built one of the higher rows would draw the wrong frame,
  // and fixing that properly means storing def ids on the colony, not names.
  const have = new Set(c.buildings.map(n => DATA.buildings.findIndex(d => d.name === n)));
  have.add(0);
  const present = new Array(15).fill(-1);
  DATA.buildings.forEach((b, id) => {
    if (!have.has(id)) return;
    present[shuffle[groupSlot[BUILDING_GROUP[id]]]] = id;
  });
  return present;
}
// Stockpile digits are NOT white 0x0F as §26.8 states: sampling the capture's
// quantity cells gives (195,219,243) with no pure white anywhere, which is
// palette index 0x31. The SoL band really is near-white (0x10) and the panel
// caption is 0x33, so the three are genuinely different inks.
const STOCK_INK = 0x31, SOL_INK = 0x10, PANEL_INK = 0x33;
// The three stacked buttons at the strip's right edge are the right-panel view
// selectors: region (303,132,17,45), three rows of pitch 15 drawing ICONS disk
// 67/68/69 -- the 14x13 "button plaque" band, confirmed by rendering it against
// the capture: a house, a musket and a hammer, in that order. They drive the
// panel mode [0x337], whose three documented states are the SoL/garrison icon
// bar, cargo+caption, and cargo+caption+hammer strip. Which button selects
// which mode is inferred from the icons, not cited.
const VIEW_BTN = { x: 303, y: 132, w: 15, h: 13, pitch: 15 };
// The multi-function view's three buttons, top to bottom (GAME_MANUAL.md
// "Multi-Function View"): Production / Units / Build. The engine opens the
// colony screen on Production (census3_colony's default frame).
const VIEW_PRODUCTION = 0, VIEW_UNITS = 1, VIEW_BUILD = 2;

function drawColony(ctx) {
  // TUTORIAL4 (func_02C5D4 @0x2C74A): the first Colony Screen visit.
  // Production fills are representative names, flagged.
  tutOnce(4, { STRING0: DATA.cargo[GOOD.FOOD].name,
               STRING1: DATA.cargo[GOOD.LUMBER].name });
  const c = G.colonies[G.colony];
  if (!c) { G.screen = 'map'; return; }
  usePalette('WOODTILE');
  const [tw, th] = frameSize('WOODTILE', 0);
  for (let y = 0; y < H; y += th)
    for (let x = 0; x < W; x += tw) sheetFrame(ctx, 'WOODTILE', 0, x, y);

  // Building field (0,8,199,120). The ground is not a flat fill: the capture
  // shows a per-pixel speckle over the contiguous palette ramp 0x62/0x63/0x64,
  // in roughly 30/52/17 proportion (0x63 base, 0x62 highlight, 0x64 shadow).
  // The engine's noise source is unidentified, so this is a deterministic
  // positional hash matched to those measured proportions -- an approximation
  // of the texture, not a reproduction of the generator. Tracked as TBD.
  groundSpeckle(ctx, 0, 8, 199, 120);
  // Both painters blit at (plotX, plotY+8). An occupied plot draws EXE frame
  // def_id+1, an empty one its category's scenery frame, skipped when that
  // table byte is 0 (`func_026FF2 @0x26FF2`). Both are EXE-sheet indices and
  // the lab bundle is one lower, so both lose a 1 here -- confirmed by matching
  // the live Curacao frame at every plot: buildings hit at bundle frame ==
  // def_id (plots 2/5/6/9/14 at score 0, the rest best-matched there too, their
  // residual pixels being the tooltip and colonists drawn over them), and empty
  // plots at 44/43/42 against the RAM table's 45/44/43.
  const present = colonyPlacement(c);
  PLOTS.forEach(([px, py], i) => {
    const id = present[i];
    if (id < 0) {
      const decor = PLOT_DECOR[PLOT_CATEGORY[i]];
      if (decor) sheetFrame(ctx, 'BUILDING', decor - 1, px, py + 8);
      return;
    }
    sheetFrame(ctx, 'BUILDING', buildingFrame(c, id), px, py + 8);
  });
  // The WORKER + PRODUCTION layer, on top of the plots (spec/ui/
  // colony_screen.md par.0.4, capture-anchored to the live Jamestown frame):
  // a manned building shows its workers standing in the doorway and its
  // per-turn output as a row of commodity icons under the roof.
  //   * production icons at (px + 6j, py + 9) -- the capture's three hammers
  //     at x offsets 0/6/12, y = blit+1, icon = ICONS 54 (PROD_HAMMER_ICON)
  //     for hammers, 0x16+good for goods, 62 bells / 56 crosses.
  //   * the first figure at (px + fw/2 + 5, py + 8 + fh - 13): both axes
  //     solve the capture's (42,111) against the shop's 44x22 frame --
  //     bottom-anchored, the feet standing 4px proud of the sprite base.
  //   * extra workers step 9px left (figure width 8 + 1) -- the capture
  //     holds ONE worker, so the multi-worker pitch and the figure-choice
  //     rule (his specialty figure, else his job's own, else 81) are the
  //     port's reading. FLAGGED.
  PLOTS.forEach(([px, py], i) => {
    const id = present[i];
    if (id < 0) return;
    const name = DATA.buildings[id] && DATA.buildings[id].name;
    if (!name || !c.buildings.includes(name)) return;
    const job = jobForBuilding(name);
    if (!job) return;
    const crew = c.colonists.filter(p => !p.cell && p.job === job).slice(0, 3);
    if (!crew.length) return;
    const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
    const g = JOB_GOOD[jobIndex(job)];
    const icon = g >= 0 ? 0x16 + g
               : g === HAMMERS ? PROD_HAMMER_ICON
               : g === BELLS ? 62 : g === CROSSES ? 56 : null;
    if (icon !== null) {
      const made = crew.reduce((n, p) => n + indoorYield(c, p), 0);
      for (let j = 0; j < Math.min(made, 8); j++)
        sheetFrame(ctx, 'ICONS', icon, px + 6 * j, py + 9);
    }
    crew.forEach((p, k) => {
      sheetFrame(ctx, 'ICONS', colonistFigure(p),
                 px + (fw >> 1) + 5 - 9 * k, py + 8 + fh - 13);
    });
  });
  // HOVER LABEL (census3_after_drop): the building under the cursor wears its
  // name -- the tiny font in WHITE (index 15) on a snug black plate (1px above
  // and below the 5px glyphs, 2px sides), centred on the sprite. The capture's
  // "Town Hall" plate sits 11px below the sprite top; the engine's own zone
  // rects are unread, so centre-x + top+11 is a one-capture anchor. FLAGGED.
  if (!G.colonyPopup && !G.dialog && !G.drag && PTR.x < 200 && PTR.y >= 8 && PTR.y < 128) {
    for (let i = PLOTS.length - 1; i >= 0; i--) {
      const id = present[i];
      if (id < 0) continue;
      const [px, py] = PLOTS[i];
      const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
      if (!hit(PTR.x, PTR.y, { x: px, y: py + 8, w: fw, h: fh })) continue;
      const name = DATA.buildings[id] && DATA.buildings[id].name;
      if (!name) break;
      const tw = FONT.tiny.width(name);
      const lx = Math.max(1, Math.min(199 - tw, px + (fw >> 1) - (tw >> 1)));
      const ly = Math.max(9, py + 8 + 11);
      ctx.fillStyle = ink(0);
      ctx.fillRect(lx - 2, ly - 1, tw + 4, 7);
      FONT.tiny.draw(ctx, name, lx, ly, lut(15));
      break;
    }
  }

  // Title strip (0,0,320,7): name, season, year, gold -- green FONTTINY.
  const title = `${c.name}, ${DATA.seasons[G.season]}, ${G.year}, Gold: ${G.gold}$`;
  FONT.tiny.center(ctx, title, 160, 1, lut(HUD_INK));

  // 5x5 neighbourhood: rendered 80x80 at 16px, stretched x1.5 into
  // (200,8,120,120) -- then the OUTER RING IS OVERDRAWN, so only the central
  // 3x3 shows through at (224,32,72,72) with 24px tiles. Both bounds are
  // confirmed against the capture: the non-wood window there is exactly
  // x 224..295, y 32..103 inside a 1px dark border.
  const scene = document.createElement('canvas');
  scene.width = 80; scene.height = 80;
  const sg = scene.getContext('2d');
  for (let ty = 0; ty < 5; ty++)
    for (let tx = 0; tx < 5; tx++) {
      const wx = c.x - 2 + tx, wy = c.y - 2 + ty;
      // drawTile composites the improvements itself -- calling
      // drawImprovements again here double-blitted roads and ploughs.
      drawTile(sg, wx, wy, tx * 16, ty * 16, true);   // [0x18A] scene mode
      // The scene is the same composited map the main view shows, so the
      // settlements land on their tiles too -- above all, THE COLONY ITSELF on
      // the centre tile, which the panel used to leave as bare terrain.
      const oc = G.colonies.find(q => q.x === wx && q.y === wy);
      if (oc) drawSettlement(sg, tx * 16, ty * 16, colonyLevel(oc), oc.nation, 0);
      const ov = G.villages.find(q => q.x === wx && q.y === wy);
      if (ov) drawSettlement(sg, tx * 16, ty * 16, ov.level, -1,
                             (G.tribes[ov.tribe] || {}).color || 8, ov.mission);
    }
  // The x1.5 upscale is func_00531C's 2->3 duplication, now the LITERAL
  // loop (@0x531C..@0x53DC, decoded 2026-08-28): the FULL 80x80 scene
  // upscales to 120x120 (even source columns and odd source rows double)
  // and the panel shows the (24,24)+72x72 window -- with EVERY written
  // pixel passed through the func_005296 ramp dither (@0x5296..@0x531B):
  // position hash (rows_left&3) + ((dest&3)<<2) plus a running salt bx
  // (+0xD when rows_left%4==0, +0x11 per 4-aligned write, duplicate-write
  // bumps undone at each row pass end); colours outside 0x10..0x87 pass
  // through, band 0x10..0x30 uses mask 0x1F shift 0, 0x31..0x40 mask 0xF
  // shift 2, else mask 7 shift 2, and the delta flips sign at the ramp
  // edge. Model fit vs the DOS COLONY baseline: ~3,844 of 5,184 window
  // pixels exact (the plain resample managed 1,400); the residual is
  // FLAGGED -- a phase or source detail is still unread.
  const up = document.createElement('canvas');
  up.width = 120; up.height = 120;
  const ug = up.getContext('2d');
  const sd = sg.getImageData(0, 0, 80, 80).data;
  const od = ug.createImageData(120, 120);
  const jit = (al, bl, rowsLeft, di) => {
    if (al < 0x10 || al >= 0x88) return al;
    let shift = 2, mask = 7;
    if (al <= 0x30) { shift = 0; mask = 0x1F; }
    else if (al <= 0x40) { shift = 2; mask = 0xF; }
    const dl = (bl + (rowsLeft & 3) + ((di & 3) << 2)) & 0xF;
    if (dl === 0 || dl === 8) return al;
    let dd = dl < 8 ? -((dl + 1) >> shift) : (dl - 7) >> shift;
    const cl = ((al - 0x10) & mask) + dd;
    if (cl < 0 || cl > mask) dd = -dd;
    return (al + dd) & 0xFF;
  };
  if (!drawColony._rgb2idx) {
    const m = new Map();
    for (let i = 0; i < 256; i++) {
      const cc = DATA.palette[i];
      const k = (cc[0] << 16) | (cc[1] << 8) | cc[2];
      if (!m.has(k)) m.set(k, i);
    }
    drawColony._rgb2idx = m;
  }
  const r2i = drawColony._rgb2idx;
  let bx = 0, bp2 = 0, tdl = 0, dsty = 0;
  for (let k = 0; k < 80; k++) {
    const rowsLeft = 80 - k;
    const passes = (k & 1) ? 2 : 1;
    for (let p = 0; p < passes; p++) {
      if ((rowsLeft & 3) === 0) { bx += 0x0D; bp2 = 0; }
      let dstx = 0;
      for (let sx = 0; sx < 80; sx++) {
        const si = (k * 80 + sx) * 4;
        const key = (sd[si] << 16) | (sd[si + 1] << 8) | sd[si + 2];
        const idx = r2i.get(key);
        for (let dup = 0; dup < 2; dup++) {
          if (dup === 0) {
            if ((dstx & 3) === 0) bx += 0x11;
          } else {
            tdl = ~tdl & 0xFF;
            if (!tdl) break;
            if ((dstx & 3) === 0) { bx += 0x11; bp2 += 0x11; }
          }
          const oi = (dsty * 120 + dstx) * 4;
          let r = sd[si], g = sd[si + 1], b = sd[si + 2];
          if (idx !== undefined) {
            const j = jit(idx, bx & 0xFF, rowsLeft, dstx);
            const jc = DATA.palette[j];
            r = jc[0]; g = jc[1]; b = jc[2];
          }
          od.data[oi] = r; od.data[oi + 1] = g;
          od.data[oi + 2] = b; od.data[oi + 3] = 255;
          dstx++;
        }
      }
      bx -= bp2;
      dsty++;
    }
  }
  ug.putImageData(od, 0, 0);
  ctx.imageSmoothingEnabled = false;
  ctx.drawImage(up, 24, 24, 72, 72, 224, 32, 72, 72);
  hollowRect(ctx, 223, 31, 74, 74, 0);
  drawColonyTiles(ctx, c);

  // COLONY.PIK town strip, 320x72 at y=128, then the panel captions over it.
  ctx.drawImage(IMG.COLONY, 0, 128);
  drawColonyPlaza(ctx, c);
  drawColonyPanel(ctx, c);
  drawColonyDock(ctx, c);

  // Stockpile bar (0,179,320,21): 16 cells pitch 19, icon = ICONS good+0x17
  // (engine) at y=181, quantity centred at (9+19i, 194).
  DATA.cargo.forEach((g, i) => {
    // Icons are CENTRED in their cell on 9+19i (the same axis as the digits),
    // not flush at 1+19i: the capture puts the 13px horses sprite at x 156..167
    // in a cell starting at 153. All 16 frames are 12 tall and sit at y=181.
    const [fw] = frameSize('ICONS', 0x16 + i);
    sheetFrame(ctx, 'ICONS', 0x16 + i, 9 + 19 * i - (fw >> 1), 181);
    FONT.tiny.center(ctx, String(c.stock[i]), 9 + 19 * i, 194, lut(STOCK_INK));
  });
  FONT.tiny.draw(ctx, 'Exit', 306, 181, lut(0x31));

  // Black separator rules, measured: a full-width row at y=7 under the title,
  // a full-width row at y=128 above the town strip, and the column at x=199
  // between the building field and the wood panel, spanning those two rows.
  // Drawn BEFORE the popup so a message box sits on top of them.
  ctx.fillStyle = ink(0);
  ctx.fillRect(0, 7, W, 1);
  ctx.fillRect(0, 128, W, 1);
  ctx.fillRect(199, 7, 1, 122);
  if (G.colonyPopup) drawColonyPopup(ctx);
}

// ---- the tile panel: `func_0264A8 @0x0264A8` -----------------------------
// The loop runs 5x5 but the four border rows/columns are skipped outright
// (`cmp [bp-0x12],0 / ,4` and the same for [bp-0x14], @0x0267A8-0x0267BE), so
// only the inner 3x3 is ever drawn -- which is exactly the window the 1px black
// border at (223,31)-(296,104) frames. Cell origin:
//   x = 200 + 24*col   (`imul ax,[bp-0x12],0x18 / add ax,0xc8` @0x027694)
//   y =   8 + 24*row   (`imul ax,[bp-0x14],0x18 / add ax,8`    @0x02769E)
// The map cell each one stands for is (colony.x + col - 2, colony.y + row - 2)
// (@0x0265CA-0x0265E6), so col/row 1..3 are the eight neighbours plus the centre.
//
// Per cell the engine draws, in this order:
//   the worker      `0x181F:0x2BC` at (x+4, y+4)                    @0x026639
//   the yield strip `0x181F:0x236` at (x, y) across a 24px span     @0x026700
//   a zero yield    the good's icon centred in 16px + EXE 0x41 over it
//                                                        @0x02673E/@0x026758
//   selection box   `0x181F:0xCE` rect (x, y)-(x+23, y+23):
//                     colour 0x0A when the cell is the selected colonist's
//                       (`[0x8D7C]`, push 0xa @0x0267EC) -- the green box
//                     colour 0x0F on the separate cursor cell
//                       (`[0x330]`/`[0x332]`, push 0xf @0x02686D)
// The port has no second cursor, so only the green box is drawn; the white one
// needs `[0x330]/[0x332]` modelled and is left out rather than faked. Both were
// checked against the live frame, where the green box sits on the top-left
// worked tile at x 224..247, y 32..55 and no white box is present at all --
// which is what retired the port's old "white rectangle on the centre tile".
function drawColonyTiles(ctx, c) {
  const sel = c.colonists[G.colonistSel];
  const centre = centreYield(c);
  for (let row = 1; row <= 3; row++) {
    for (let col = 1; col <= 3; col++) {
      const x = 200 + 24 * col, y = 8 + 24 * row;
      const dx = col - 2, dy = row - 2;
      if (dx === 0 && dy === 0) {
        // The centre tile is the flag-bit-3 case: it works itself, and it draws
        // TWO strips -- food at (x,y) from `[0xA891]` and a second good at
        // (x, y+13) from `[0xA893]`/`[0xA894]`. Live Curacao reads 4 and furs 3,
        // and its scene cell shows exactly those two rows.
        // The centre tile also wears a WHITE 24x24 hollow rect -- measured at
        // (248,56)-(271,79) on the Isabella baseline. FLAGGED: Vlissingen's
        // sits at (252,59)-(278,84), so the true anchor tracks something
        // runtime (the strip extents?); the fixed cell is the better of the
        // two models measured (net -35 px).
        hollowRect(ctx, x, y, 24, 24, 0x0F);
        proportionalStrip(ctx, 22 + GOOD.FOOD, centre.food, 0, x, y, 24);
        if (centre.good >= 0)
          proportionalStrip(ctx, 22 + centre.good, centre.amount, 0, x, y + 13, 24);
        continue;
      }
      const wx = c.x + dx, wy = c.y + dy;
      // Flag bit 6, the blocked-cell mark: a 24x24 outline in pure red 0x0C
      // (frame draw 0x181F:0xCE @0x026584). Gate READ 2026-08-07z13: the
      // engine tests bit 0x40 of the per-cell STATUS array at DGROUP -0x7210,
      // indexed cell*5+row (`test al,0x40` @0x2655C) -- a runtime worked/blocked
      // flag, set when the surrounding cell cannot be worked. "Another
      // settlement holds the tile" is the port's reading of when that bit is
      // set (the two commonest causes); still a flagged approximation of the
      // full runtime state.
      const blockedCell = G.villages.some(q => q.x === wx && q.y === wy) ||
          G.colonies.some(q => q !== c && q.x === wx && q.y === wy) ||
          G.rivals.some(rv => rv.colonies.some(q => q.x === wx && q.y === wy));
      if (blockedCell) hollowRect(ctx, x, y, 24, 24, 0x0C);
      const p = c.colonists.find(q => q.cell && q.cell[0] === dx && q.cell[1] === dy);
      const good = p ? JOB_GOOD[jobIndex(p.job)] : undefined;
      const amount = p ? fieldYield(c, p) : 0;
      if (good !== undefined && good >= 0) {
        // A worked WATER tile swaps the good icon for EXE 0x3A = bundle 57
        // (the fish, @0x0266D2 when the tile-class query 0xC0E reads 8) --
        // live Curacao's north sea cell draws frame 57, not the food sprite.
        const gf = tileWater(at(wx, wy)) ? GAUGE_ALT : 22 + good;
        if (amount > 0) proportionalStrip(ctx, gf, amount, 0, x, y, 24);
        else {
          const [fw] = frameSize('ICONS', gf);
          sheetFrame(ctx, 'ICONS', gf, x + ((16 - fw) >> 1), y + 1);
          sheetFrame(ctx, 'ICONS', 64, x, y);        // EXE 0x41, the "none" mark
        }
      }
      // Map units STANDING on the surrounding tile -- the flag-0x80 branch
      // @0x265C4..@0x2663D: walk the units at the tile (first via 0x181F:0x7E0,
      // next via 0x2E4) and take the FIRST whose @UNIT attack column is > 1
      // (`cmp byte [bx+0x5236],1; ja`); draw it through 0x181F:0x2BC -- the
      // unit draw BY INDEX, i.e. the func_003710 icon resolver -- at
      // (x+4, y+4). No attack>1 unit at the tile means NOTHING is drawn:
      // civilians and plain braves never appear in the tile panel. (The old
      // port model, PHYS0 0x5A+type, was wrong -- for a Brave it drew frame
      // 0x6D, an 8x8 black-quadrant tile detail.)
      const stander = [...G.natives, ...G.units, ...G.refUnits].find(q =>
          q.x === wx && q.y === wy && Number((unit(q.type) || {}).attack) > 1);
      if (stander) sheetFrame(ctx, 'ICONS', unitIconOf(stander), x + 4, y + 4);
      // THE TOTEM POLE -- ICONS png 108 (EXE 0x6D), byte-read 2026-08-30
      // after a user correction (the earlier "cut content" call was wrong;
      // the sprite was misread at thumbnail scale). The tile-panel prep
      // (@0xA9C8..@0xAAC5) fills a per-cell byte drawn at cell+(8,4) when
      // >= 0 (@0x2658F..@0x265BF, flags byte 0 -- so a blocked cell or a
      // standing unit suppresses it):
      //   candidate = the NEAREST settlement's owner (func_046056 scan)
      //     when its distance <= the tribe's homeland radius, which is
      //     func_00822A BY TECH: 1/1/2/3 (the manual's "1/2" was short);
      //   dropped for: a cell this colony WORKS (occupant @0x8956), a
      //     WATER tile (func_0062B4), an unmet tribe (relation bit 0x20
      //     via func_007F34), or the owner holding father 2 PETER MINUIT
      //     (@0xAAA0 -- his power erases the claims). The 0x88D0 override
      //     and func_046056's exact metric are unread; Chebyshev
      //     nearest-village stands in, FLAGGED.
      const anyStander = stander ||
          G.natives.find(q => q.x === wx && q.y === wy) ||
          G.units.find(q => q.x === wx && q.y === wy) ||
          G.refUnits.find(q => q.x === wx && q.y === wy);
      if (!anyStander && !p && !blockedCell && !tileWater(at(wx, wy)) &&
          wx >= 1 && wx <= MAP.w - 2 && wy >= 1 && wy <= MAP.h - 2 &&
          !G.fathersOwned.includes('Peter Minuit')) {
        let best = null, bd = 99;
        for (const v of G.villages) {
          const d = Math.max(Math.abs(v.x - wx), Math.abs(v.y - wy));
          if (d < bd) { bd = d; best = v; }
        }
        const bt = best && G.tribes[best.tribe];
        const rad = bt ? [1, 1, 2, 3][bt.level || 0] || 1 : 0;
        if (bt && bd <= rad && bt.met)
          sheetFrame(ctx, 'ICONS', 108, x + 8, y + 4);
      }
      // The WORKER is the last thing the cell draws, through `0x181F:0x24A`
      // fed by the colony enumerator `0x181F:0xA74` (@0x026763-0x02677C) -- NOT
      // the `0x2BC` unit-panel call above it, which belongs to flag bit 7 (a
      // map unit standing on the tile; every inner cell reads flags 0 in the
      // live frame, so nothing takes that path there and the port omits it).
      // The pushed anchor is (x+12, y+6); the sprite lands at (x+14, y+6) --
      // ICONS frame 100 matches there at score 0 in the live frame. The y is
      // exact and the x is 2 further out than the push, so `0x24A` adds an
      // inset of its own; with one clean cell to measure, the offset is used as
      // measured and the mechanism is left open.
      if (p) {
        sheetFrame(ctx, 'ICONS', colonistFigure(p), x + 14, y + 6);
      }
      if (p && p === sel) hollowRect(ctx, x, y, 24, 24, 0x0A);
    }
  }
}

// What the colony's own tile makes with nobody on it: the byte model
// (compute_colony_center_yields func_00A222, read end to end -- see
// centreYieldCore). Isabella: savannah sugar 3 + the difficulty +1 = the
// baseline's 4; Vlissingen: rain-forest ore 1 + Minerals 3 + 1 = 5.
function centreYield(c) { return centreYieldCore(c); }

// ---- the plaza panel: `func_0270D0 @0x0270D0` ----------------------------
// Fill (0,130,120,48) (`push 0x30,0x78,0x82,0` @0x0270D6), then three things.
//
// 1. THE COLONIST ROW. Every colonist AND every unit garrisoned in the colony
//    gets a sprite -- the count is `colony+0x1F` plus `[0x8D72]` (@0x0270E6),
//    not just the unassigned ones the port used to draw. y = 142 and the row
//    runs LEFT to RIGHT from x = 2. The pitch is not fixed: pass 1 sums every
//    sprite's width (@0x02710A-0x027141), then the gap starts at 2 and is
//    DECREMENTED -- signed, so it goes negative and the sprites overlap -- until
//      gap*(count-1) + extra + totalwidth < 96          (@0x027160-0x027173)
//    where `extra` is the 4px break between the colonists and the garrison
//    (@0x027148/0x027154). That break is spent after the last colonist
//    (`colony+0x1F - i - 1 == 0`, @0x02729E-0x0272AC).
//    Live check: 11 sprites totalling ~76px solve to gap 1, putting the second
//    sprite at x=11 -- which is where frame 100 matches the capture exactly.
// 2. THE SELECTION BOX, `0x181F:0xCE` rect (x-1, y+1)-(x+w, y+h): colour 0x0A
//    for the selected colonist (@0x0271AE), 0x0F for `[0x8D7E]` (@0x02720F).
//    Measured green box in the live frame: x 1..10, y 143..158, for an 8px
//    sprite at x=2 -- which is what pinned the +/-1 insets above.
// 3. THE FOOD ROW at y=163, x from 2 across a 118px span, gap 4
//    (`ax=2 / bx=0x76 / [bp-0x60]=0xa3` @0x0273CC-0x0273D7): food produced with
//    the eaten part marked, then crosses (EXE 0x39) and bells (EXE 0x3F).
const PLAZA_ROW_Y = 142, PLAZA_ROW_X = 2, PLAZA_ROW_BUDGET = 96, PLAZA_GARRISON_GAP = 4;
const PLAZA_FOOD_Y = 163, PLAZA_FOOD_X = 2, PLAZA_FOOD_SPAN = 118;
// EXE 0x7C/0x7D, the two SoL end-caps: the rebel flag and the king's crown.
const SOL_FLAG = 123, SOL_CROWN = 124, SOL_CROWN_RIGHT = 117;

// The solved row, shared by the painter and the click test so a click always
// lands on the sprite it looks like it landed on.
function plazaRow(c) {
  const people = c.colonists.map(p => colonistFigure(p));
  // Which G.units entry each garrison figure IS, not just its icon: clicking
  // one opens @UNITOPTIONS, so the row has to be able to name the unit.
  // Cargo carriers live in the DOCK strip, not the plaza row -- the
  // Vlissingen DOS baseline shows the Wagon Train beside the Galleon in the
  // dock and absent from the row.
  const garrisonIdx = G.units.map((u, i) => [u, i])
    .filter(([u]) => u.x === c.x && u.y === c.y &&
                     !(Number((unit(u.type) || {}).cargo) > 0))
    .map(([, i]) => i);
  const icons = people.concat(garrisonIdx.map(i => unitIconOf(G.units[i])));
  if (!icons.length) return [];
  const totalW = icons.reduce((a, i) => a + frameSize('ICONS', i)[0], 0);
  const extra = garrisonIdx.length ? PLAZA_GARRISON_GAP : 0;
  let gap = 2;
  while (gap * (icons.length - 1) + extra + totalW >= PLAZA_ROW_BUDGET) gap -= 1;
  const out = [];
  let x = PLAZA_ROW_X;
  icons.forEach((icon, i) => {
    const [w, h] = frameSize('ICONS', icon);
    out.push({ icon, x, w, h, colonist: i < people.length ? i : -1,
               unit: i < people.length ? -1 : garrisonIdx[i - people.length] });
    x += Math.max(1, w + gap);
    if (i === people.length - 1) x += PLAZA_GARRISON_GAP;
  });
  return out;
}

function drawColonyPlaza(ctx, c) {
  // --- the colonist + garrison row ---
  for (const e of plazaRow(c)) {
    sheetFrame(ctx, 'ICONS', e.icon, e.x, PLAZA_ROW_Y);
    if (e.colonist === G.colonistSel)
      hollowRect(ctx, e.x - 1, PLAZA_ROW_Y + 1, e.w + 2, e.h, 0x0A);
  }

  // --- the food / crosses / bells row ---
  // The enqueue site is now FULLY read (@0x027330-0x0273C7): with
  // P = gross food [0x8DC8], E = eaten [0x8E0A], C = centre-tile yield
  // [0xA895], D = deficit [0x8E32]:
  //   surplus/break-even (D==0): TWO corn cells, both bit14 --
  //     (count E,   sub E - min(C,E))          the EATEN run
  //     (count P-E, sub (P-E) - max(0,C-E))    the SURPLUS run
  //   deficit (D>0):
  //     (count P,   sub P-C, bit14)            everything produced
  //     (count D,   sub 0,   bit15)            the shortfall, red-X'd
  // then crosses [0x8DEA] frame 0x39 and bells [0x8DEC] frame 0x3F, each
  // only when nonzero; flush at x=2 y=0xA3 span=0x76 gap=4 (@0x0273CC).
  // (The engine's [0xA895] is stale-zero on a freshly loaded game until the
  // first turn tick; the port computes it live.)
  // Re-read 2026-08-28: the shaded sub-runs split FISH food ([0xA895])
  // from land food -- the old centre-based split matched only when the
  // fixture's fish happened to equal the centre. Surplus branch (@0x27337):
  // cell 1 = eaten, sub eaten-min(fish, eaten); cell 2 = surplus, sub
  // surplus-leftover_fish. Shortfall branch (@0x2737E): cell 1 = produced,
  // sub produced-fish; cell 2 = the overdraw [0x8E32], 0x8000-marked.
  const r = colonyProduce(c);
  const P = r.gross[GOOD.FOOD], E = r.eaten, F = r.fishFood || 0;
  const CORN = 22 + GOOD.FOOD;
  const a = Math.min(F, E), leftover = Math.max(0, F - a);
  const foodCells = E > P
    ? [{ frame: CORN, count: P, sub: Math.max(0, P - F), flags: 0x4000 },
       { frame: CORN, count: E - P, sub: 0, flags: 0x8000 }]
    : [{ frame: CORN, count: E, sub: E - a, flags: 0x4000 },
       { frame: CORN, count: P - E, sub: (P - E) - leftover, flags: 0x4000 }];
  drawCountRow(ctx, foodCells.concat([
    { frame: 56, count: r.tally[CROSSES], sub: 0, flags: 0 },   // EXE 0x39
    { frame: 62, count: r.tally[BELLS], sub: 0, flags: 0 },     // EXE 0x3F
  ]), PLAZA_FOOD_X, PLAZA_FOOD_Y, PLAZA_FOOD_SPAN, 4, !!G.colonyNumbers);

  // --- the SoL band ---
  // `0x181F:0xC86` gives the SoL percentage (@0x0273DC); the Tory figure is
  // 100 minus it, and the headcount split is round(pct*pop/100) with the
  // remainder going to the other side (@0x0273F0-0x02740E). The flag is EXE
  // sprite 0x7C at (2,132) with its text at width+2; the crown is EXE 0x7D with
  // its RIGHT edge pinned to x=117 (`mov ax,0x75 / sub ax,width` @0x027551) and
  // its text right-aligned against it. Both baselines are y=133.
  const pop = c.colonists.length;
  const solPct = c.sol, toryPct = 100 - solPct;
  const toryN = Math.trunc((toryPct * pop + 50) / 100);
  const solN = pop - toryN;
  const band = lut(SOL_INK);
  const [fw] = frameSize('ICONS', SOL_FLAG);
  const [cw] = frameSize('ICONS', SOL_CROWN);
  sheetFrame(ctx, 'ICONS', SOL_FLAG, 2, 132);
  FONT.tiny.draw(ctx, `${solPct}% (${solN})`, fw + 2, 133, band);
  const crownX = SOL_CROWN_RIGHT - cw;
  FONT.tiny.right(ctx, `${toryPct}% (${toryN})`, crownX, 133, band);
  sheetFrame(ctx, 'ICONS', SOL_CROWN, crownX, 132);
}

// Positional-hash speckle over a 3-entry palette ramp. Deterministic so the
// screen does not shimmer between frames.
function groundSpeckle(ctx, x, y, w, h, base) {
  const ramp = base || [0x63, 0x62, 0x64];
  ctx.fillStyle = ink(ramp[0]);
  ctx.fillRect(x, y, w, h);
  for (let j = 0; j < h; j++) {
    for (let i = 0; i < w; i++) {
      const n = ((i * 73856093) ^ (j * 19349663)) >>> 0;
      const r = (n >>> 8) % 100;
      if (r < 30) ctx.fillStyle = ink(ramp[1]);
      else if (r < 47) ctx.fillStyle = ink(ramp[2]);
      else continue;
      ctx.fillRect(x + i, y + j, 1, 1);
    }
  }
}

// ---- colony popups: construction (C), the jobs menu, the occupation menu --
// All use the §3 dialog framework, same as the Europe menus.
//
// The OCCUPATION menu is the engine's field-colonist picker: clicking a
// colonist working an outdoor square lists every outdoor @JOB with THAT
// SQUARE's yield, and committing a row re-occupies him there. The row set is
// runtime-built from NAMES @JOB against the tile's yield table -- there is no
// static GAME.TXT list to cite; the yields themselves are the byte-closed
// terrain tables. Rows that yield nothing on this square still show (at 0),
// which is how the original teaches what a square cannot do.
const OUTDOOR_JOB_ROWS = [0, 1, 2, 3, 4, 5, 6, 7, 8];   // Farmer..Fisherman
function occupationRows(c, p) {
  const rows = OUTDOOR_JOB_ROWS.map(j => {
    const name = DATA.jobs[j];
    const probe = { ...p, job: name };
    const n = fieldYield(c, probe);
    const g = JOB_GOOD[j];
    return { label: name, note: `${n} ${g >= 0 ? DATA.cargo[g].name : ''}`,
             job: name, yield: n };
  });
  // The colony's INDOOR workplaces, appended to the outdoor list.
  //
  // SHELL CHROME, and a deliberate departure from the two-menu split the
  // port had: the field worker's menu offered only crops, and the only
  // route from a field to a building was "Return to the fence", then find
  // the man again in the plaza row, then his jobs menu. Nothing about the
  // screen said so, so "I cannot put colonists in buildings" is what it
  // looks like from the chair -- reported from the board 2026-08-19.
  //
  // This adds no mechanic. Every row commits through the SAME rules the
  // plaza jobs menu already applied: jobForBuilding for the job, the
  // @MORETHANTHREE crew cap, and teacherGuard for the Schoolhouse. It is
  // a second route to a workplace the player could already reach, the way
  // @UNITOPTIONS is a second route to orders the sim already had.
  for (const b of c.buildings) {
    if (!workplaceFor(b)) continue;
    const job = jobForBuilding(b), g = JOB_GOOD[jobIndex(job)];
    const made = g >= 0 ? DATA.cargo[g].name
               : g === HAMMERS ? 'Hammers' : g === BELLS ? 'Bells'
               : g === CROSSES ? 'Crosses' : 'Teaching';
    rows.push({ label: b, note: `${job} - ${made}`, building: b });
  }
  rows.push({ label: 'Return to the fence', note: '', job: null });
  return rows;
}
function colonyPopupRows() {
  const c = G.colonies[G.colony];
  if (G.colonyPopup === 'build') {
    // The engine's construction picker, format read off the live DOSBox frame
    // (docs/screens/... construction_dialog): LABELS @CTITLE 4 titles it,
    // the first row is @CTITLE 5 "(No Production)", and each entry's cost is
    // TWO parenthesised groups "(N Hammers) (M Tools)" -- no "Cost:", no
    // comma, the tools group present only when the building needs tools.
    const none = (DATA.text.ctitle || [])[5] || '(No Production)';
    // census3_build_picker: labels in CAPITALS, the buildable UNITS follow
    // the buildings (the frame lists WAGON TRAIN), costs as
    // "(N Hammers) (M Tools)", and the CURRENT TARGET row is the one the
    // picker opens highlighted on.
    const row = (b) => ({
      label: b.name.toUpperCase(), name: b.name,
      note: `(${b.cost} Hammers)` +
            (b.tools_x10 ? ` (${b.tools_x10 * 10} Tools)` : ''),
    });
    // buildOptions already appends the colony-built units (Wagon Train etc.).
    return [{ label: none, note: '', stop: true }].concat(buildOptions(c).map(row));
  }
  if (G.colonyPopup === 'occupation') {
    const p = c.colonists[G.colonistSel];
    return p && p.cell ? occupationRows(c, p) : [];
  }
  // @UNITOPTIONS / @SHIPOPTIONS -- the two colony context menus, read verbatim
  // from GAME.TXT (spec/ui/context_dialogs.md §4, `directives={}` bare lists).
  // @UNITOPTIONS: "Move to front. / Clear orders. / Sentry / Board ship. /
  // Fortify. / No changes."  Every row's effect is an @ORDERS value the sim
  // already has (BYTE_VERIFIED: 0 No Orders, 1 Sentry, 5 Fortify), so nothing
  // here invents a mechanic -- the menu is a second way to reach them.
  if (G.colonyPopup === 'unitopts')
    return ((DATA.events.UNITOPTIONS || { body: [] }).body)
      .map(l => ({ label: l, note: '' }));
  // @SHIPOPTIONS: "Move to front. / Clear orders. / Sentry. / Anchor in
  // harbor (\"Fortify\"). / Unload all cargo. / No changes."  The row that
  // is not just an @ORDERS write is "Unload all cargo", which empties the
  // whole hold into the warehouse behind the same @WAREHOUSEFULL gate the
  // per-slot 'u' path uses.
  if (G.colonyPopup === 'shipopts')
    return ((DATA.events.SHIPOPTIONS || { body: [] }).body)
      .map(l => ({ label: l, note: '' }));
  // Jobs: the colony's buildings are the workplaces, plus a way back to the
  // plaza. Working a FIELD is done by clicking a cell in the scene panel.
  // Only buildings that actually employ a colonist are offered, and each one
  // names the job and what it makes.
  return [{ label: 'No job (plaza)', note: '' }].concat(
    c.buildings.filter(b => workplaceFor(b)).map(b => {
      const job = jobForBuilding(b), g = JOB_GOOD[jobIndex(job)];
      const made = g >= 0 ? DATA.cargo[g].name
                 : g === HAMMERS ? 'Hammers' : g === BELLS ? 'Bells'
                 : g === CROSSES ? 'Crosses' : 'Teaching';
      return { label: b, note: `${job} - ${made}` };
    }));
}
// The @MORETHANTHREE rule: "We cannot put more than three colonists in any
// one building" (GAME.TXT, verbatim).
function buildingCrew(c, name) {
  const job = jobForBuilding(name);
  return c.colonists.filter(p => !p.cell && p.job === job).length;
}
// census3_build_picker: the construction picker renders in the SMALL font
// (17 rows + title + footer fit the frame only at the small pitches), the
// jobs/occupation popups stay at the framework font (no capture says
// otherwise yet).
function colonyPopupSmall() { return G.colonyPopup === 'build'; }
function colonyPopupBox() {
  const rows = colonyPopupRows();
  const small = colonyPopupSmall(), mf = dFont(small);
  let cw = 0x50;
  for (const r of rows) cw = Math.max(cw, mf.width(r.label) + mf.width(r.note) + 20);
  // The build picker reserves a bottom line for "(F1 for Help)" like the
  // Europe shop menus do (census3_build_picker).
  const foot = small ? 10 : 0;
  const w = cw + 6, h = 6 + dText(small) + 3 + rows.length * dRow(small) + 3 + foot;
  return { x: Math.round(160 - w / 2), y: Math.max(2, Math.round(100 - h / 2)), w, h, rows };
}
function drawColonyPopup(ctx) {
  const c = G.colonies[G.colony], b = colonyPopupBox();
  const small = colonyPopupSmall(), mf = dFont(small), rp = dRow(small);
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  // Titles are the engine's own: LABELS @CTITLE 4 "Select An Item To Build",
  // @CTITLE 8 "Select a Profession for" + the colonist's name.
  // census3_build_picker: the title is the bare @CTITLE 4 string (no
  // hammers/tools tally) in the base green, like every framework body line.
  const who = c.colonists[G.colonistSel];
  // @UNITOPTIONS has no caption section of its own (bare list, `directives={}`),
  // so the port titles it with the unit it is acting on -- the same shape the
  // Europe dock menu uses for its own unit. FLAGGED: the engine's caption for
  // this menu, if any, is unread.
  const uu = G.colonyPopup === 'unitopts' || G.colonyPopup === 'shipopts'
    ? G.units[G.colonyPopupUnit] : null;
  const title = G.colonyPopup === 'build'
    ? (DATA.text.ctitle || [])[4] || 'Select An Item To Build'
    : G.colonyPopup === 'unitopts' || G.colonyPopup === 'shipopts'
      ? (uu ? uu.type : '')
    : `${(DATA.text.ctitle || [])[8] || 'Select a Profession for'} ${who ? (who.profession || who.type) : ''}`;
  mf.draw(ctx, title, b.x + 5, b.y + 6, lut(0xFE));
  const seed = b.y + 6 + dText(small) + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * rp, sel = k === G.colonyPopupRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, rp - 2); }
    // The current target is shown by OPENING ON its row, not by a marker
    // (census3_build_picker: DOCKS is simply the highlighted row). Notes are
    // the same base green as the labels, gold when highlighted.
    mf.draw(ctx, r.label, b.x + 9, y + 1, lut(sel ? 0xFC : 0xFE));
    if (r.note) mf.draw(ctx, r.note, b.x + b.w - 8 - mf.width(r.note), y + 1,
                        lut(sel ? 0xFC : 0xFE));
  });
  if (small) {
    // Bright-gold footer -- census3_build_picker samples (199,162,32) = 0xFC,
    // unlike the Europe menus' dim 0x5D.
    const f1 = '(F1 for Help)';
    mf.draw(ctx, f1, b.x + b.w - 8 - mf.width(f1), b.y + b.h - 11, lut(0xFC));
  }
}
// census3_build_picker: the picker OPENS ON the current construction target's
// row (DOCKS highlighted while Docks was under way); with no target it opens
// on "(No Production)".
function openBuildPicker() {
  const c = G.colonies[G.colony];
  G.colonyPopup = 'build';
  const rows = colonyPopupRows();
  const k = rows.findIndex(r => r.stop ? !c.building : r.name === c.building);
  G.colonyPopupRow = Math.max(0, k);
}
// The garrison-unit menu's five rows (@UNITOPTIONS). "Move to front" reorders
// the unit cycle exactly the way the Europe dock's own front row reorders
// G.dockUnits -- splice out, unshift, select. The three order rows write
// @ORDERS values (BYTE_VERIFIED: 0 No Orders / 1 Sentry / 5 Fortify).
// "Sentry / Board ship" is ONE row in the section: the engine folds boarding
// into sentry, and a unit in a colony with a ship in port boards it by being
// dragged, which the port already does -- so this row sets Sentry and the
// board leg is left to the drag. FLAGGED: whether the engine's row boards
// when a ship is present is unread.
function unitOptionsCommit(k) {
  const u = G.units[G.colonyPopupUnit];
  if (!u) return;
  switch (k) {
    case 0:
      G.units.splice(G.colonyPopupUnit, 1);
      G.units.unshift(u);
      G.sel = 0;
      return;
    case 1: u.orders = 0; return;
    case 2: u.orders = 1; return;
    case 3: u.orders = 5; return;
    default: return;                       // "No changes."
  }
}
// "Unload all cargo" (@SHIPOPTIONS row 4): the WHOLE hold into the warehouse
// in one step, unlike the 'u' key's per-slot @CARGOUNLOAD/@HOWMUCH2 pair. The
// @WAREHOUSEFULL confirm is the same gate, asked once for the first good that
// would cross the byte-read 100-ton threshold (the engine's per-good behaviour
// is unread -- flagged there and here).
function unloadAllCargo(u, c) {
  const doIt = () => {
    for (const h of (u.hold || []).slice()) {
      if (h.qty <= 0) continue;
      c.stock[h.good] += h.qty;
      holdAdd(u, h.good, -h.qty);
    }
  };
  const full = (u.hold || []).find(h => c.stock[h.good] + h.qty > 100);
  if (full) {
    askEvent('WAREHOUSEFULL',
             { STRING0: c.name, STRING1: DATA.cargo[full.good].name,
               NUMBER0: c.stock[full.good], NUMBER1: 100, NUMBER2: full.qty },
             (choice) => { if (choice === 1) doIt(); });
    return;
  }
  doIt();
}
// The colony harbour ship menu's six rows (@SHIPOPTIONS). Rows 0-3 are the
// same shape as @UNITOPTIONS -- reorder, then the byte-verified @ORDERS
// values 0 / 1 / 5 -- with "Anchor in harbor" spelling out that Fortify is
// what a ship in port does.
function shipOptionsCommit(k, c) {
  const u = G.units[G.colonyPopupUnit];
  if (!u) return;
  switch (k) {
    case 0:
      G.units.splice(G.colonyPopupUnit, 1);
      G.units.unshift(u);
      G.sel = 0;
      return;
    case 1: u.orders = 0; return;
    case 2: u.orders = 1; return;
    case 3: u.orders = 5; return;
    case 4: unloadAllCargo(u, c); return;
    default: return;                       // "No changes."
  }
}
function colonyPopupCommit() {
  const c = G.colonies[G.colony], rows = colonyPopupRows(), r = rows[G.colonyPopupRow];
  if (!r) { G.colonyPopup = null; return; }
  if (G.colonyPopup === 'shipopts') {
    const k = G.colonyPopupRow;
    G.colonyPopup = null;                  // close BEFORE the unload ask
    shipOptionsCommit(k, c);
    return;
  }
  if (G.colonyPopup === 'unitopts') {
    unitOptionsCommit(G.colonyPopupRow);
    G.colonyPopup = null;
    return;
  }
  if (G.colonyPopup === 'build') {
    // The construction panel itself shows the new target; the engine raises no
    // message here.
    c.building = r.stop ? null : (r.name || r.label);
  } else if (G.colonyPopup === 'occupation') {
    const p = c.colonists[G.colonistSel];
    if (p) {
      // A BUILDING row: same gates as the plaza jobs menu, then he leaves
      // the field for the workplace.
      if (r.building) {
        const job = jobForBuilding(r.building);
        if (buildingCrew(c, r.building) >= 3 && p.job !== job) {
          showEvent('MORETHANTHREE', {});
          G.colonyPopup = null;
          return;
        }
        if (job === 'Teacher' && p.job !== 'Teacher' && teacherGuard(c, p)) {
          G.colonyPopup = null;
          return;
        }
        p.job = job;
        p.cell = null;
        G.colonyPopup = null;
        return;
      }
      // "Return to the fence" is not a job, it is OUT of the colony.
      if (r.job === null) {
        colonistToFence(c, G.colonistSel);
        G.colonistSel = Math.max(0, Math.min(G.colonistSel,
                                             c.colonists.length - 1));
      }
      else if (r.job === 'Teacher' && teacherGuard(c, p)) {
        G.colonyPopup = null;
        return;
      } else p.job = r.job;
    }
  } else {
    const p = c.colonists[G.colonistSel];
    if (p) {
      const job = G.colonyPopupRow === 0 ? null : jobForBuilding(r.label);
      // @MORETHANTHREE: at most three colonists in any one building.
      if (job && buildingCrew(c, r.label) >= 3 && p.job !== job) {
        showEvent('MORETHANTHREE', {});
        G.colonyPopup = null;
        return;
      }
      if (job === 'Teacher' && p.job !== 'Teacher' && teacherGuard(c, p)) {
        G.colonyPopup = null;
        return;
      }
      p.job = job;
      p.cell = null;                        // a building job means leaving the fields
    }
  }
  G.colonyPopup = null;
}

// ---- the ships-in-port dock: engine region 8 (121,130,84,48) --------------
// Built 2026-08-07 so colony goods drags have somewhere to LAND (drop mode 7's
// byte-cited targets are {5, 8}, and until now the port drew nothing here but
// a caption). Byte-cited pieces:
//   * the hold sub-rect (127,165,72,22)          func_02AFCE @0x2AFEA
//   * six hold cells x = 0x7F + 12i = 127+12i,
//     y = 0xA5 = 165, w = 0x0A = 10, h = 0x16    func_027D84 @0x027D87-0x027DAC,
//     = 22, six-slot loop                        @0x027DF7
//   * the beyond-capacity slot sprite, ICONS
//     engine 0x7B = bundle 122 (the crossed
//     crate the Europe row already uses)         @0x027E25
//   * hold hit index clamp(mx-0x7F,0,0x47)/0x0C  func_02AEDA @0x2AEE9
// The SHIPS LIST is byte-read from func_027DB2 (2026-08-07b):
//   * frame box (121,130,84,48)                  @0x27DB7-0x27DC1
//   * NO SHIPS ([0x33C]==0): the caption string, then ICONS engine 0x7B (the
//     crossed crate, bundle 122) on ALL SIX hold cells
//                                                @0x27DC7-0x27E34 (`mov ax,0x7b` @0x27E25)
//   * ships row: 16x16 cells from x=0x82=130, PITCH 18, up to 4
//     (`mov [bp-0x74],4` @0x27EB9; advance `sbb/and 0xD/add 5` = +18 on row 0
//     @0x27FA2-0x27FAE), unit blit y = 147 with a 1px lift for a ship and one
//     more for slots past the first
//                                                @0x27EAB/@0x28014/@0x2801E-0x2803D
//   * ships 5+ overflow to a 3x4-pip row at (124,139), pitch 5, up to 16 --
//     the "implausible 5px pitch" of the old open item, real after all
//                                                @0x27FE2-0x27FF6
//   * selection box: colour 0x0A on the selected ship [0x33E]; 0x0F as the
//     DROP highlight while the button is held over the dock mid-drag
//                                                @0x27F15-0x27F4E, rect verb @0x27F9D
//   * hold cells: slot >= @UNIT cargo capacity -> the 0x7B cross; an occupied
//     slot -> the goods icon CENTRED, engine 0x17+good full / 0x27+good
//     partial (bundle 0x16/0x26+good); an EMPTY in-capacity slot draws
//     NOTHING -- no dark fill
//                                                @0x280B7-0x2812B
const COLONY_DOCK = { shipX: 130, shipY: 147, shipPitch: 18 };
function colonyShips(c) {
  // Membership = CARGO CAPACITY > 0, not hull: the Vlissingen DOS baseline
  // docks the Wagon Train beside the Galleon (and the engine's y-1
  // @0x2801A applies only to ship types 0x0D..0x12 -- exactly the tell
  // that non-ship carriers reach this strip).
  return G.units.filter(u => Number((unit(u.type) || {}).cargo) > 0 &&
                             u.x === c.x && u.y === c.y);
}
function colonyShip(c) {
  const ships = colonyShips(c);
  if (!ships.length) return null;
  if (G.colonyShipSel >= ships.length) G.colonyShipSel = 0;
  return ships[G.colonyShipSel];
}
function drawColonyDock(ctx, c) {
  const ships = colonyShips(c);
  // Headline: verb 0x181F:0x100 @0x27DCE / @0x27E95 centres the string in
  // the rect x=0x79(121) w=0x54(84) at y=0x84(132) -- centre 163; the DOS
  // baseline measures the text at 135..194 (centre 164.5), rows from 132.
  // (160,130) was the old fitted guess.
  if (!ships.length) {
    FONT.tiny.center(ctx, 'No Ships In Port', 163, 132, lut(PANEL_INK));
    for (let k = 0; k < 6; k++) sheetFrame(ctx, 'ICONS', 122, 127 + 12 * k, 165);
    return;
  }
  FONT.tiny.center(ctx, `Loading: ${colonyShip(c).type}`, 163, 132, lut(PANEL_INK));
  // The ship strip goes through the SHARED panel composite -- @0x28049-
  // @0x2805D calls 0x181F:0x2BC (func_00386A) with mode 0x64, centre-width
  // 0x10, y = 147 minus 1 for a ship type (always here) minus 1 more for
  // ordinal > 0 (@0x2801A-@0x2803D), x = 130 + 18k (@0x27FA2 pitch).
  ships.slice(0, 4).forEach((u, k) => {
    const x = COLONY_DOCK.shipX + k * COLONY_DOCK.shipPitch;
    // The y-1 (and -1 more past ordinal 0) applies ONLY to ship types
    // 0x0D..0x12 (@0x2801A-@0x2803D); a wagon stays at 147.
    const isShipType = Number((unit(u.type) || {}).hull) > 0;
    const y = COLONY_DOCK.shipY - (isShipType ? 1 + (k > 0 ? 1 : 0) : 0);
    unitPanel(ctx, x, y, 16, u.type, unitFlags(u), u.orders || 0,
              DATA.nations[G.nation].color, unitIconOf(u), G.nation);
    if (k === G.colonyShipSel)
      hollowRect(ctx, x - 1, COLONY_DOCK.shipY - 1, 18, 18, 0x0A);
    // The drop highlight while a goods payload is over the dock. The engine's
    // test reads its hover word ([0x8D54]==8 with the button held) -- the
    // port's equivalent condition is a live goods drag; INFERRED, flagged.
    if (G.drag && G.drag.kind === 'good' && k === G.colonyShipSel &&
        hit(PTR.x, PTR.y, { x: 121, y: 130, w: 84, h: 48 }))
      hollowRect(ctx, x - 1, COLONY_DOCK.shipY - 1, 18, 18, 0x0F);
  });
  // Overflow ships 5+ as 3x4 pips at (124,139) pitch 5, in the owner colour.
  ships.slice(4, 20).forEach((u, k) => {
    ctx.fillStyle = ink(ownerColour(u));
    ctx.fillRect(124 + 5 * k, 139, 3, 4);
  });
  const ship = colonyShip(c);
  const cap = Number((unit(ship.type) || {}).cargo) || 0;
  const hold = ship.hold || [];
  const taken = (ship.cargo || []).length;         // units aboard occupy holds too
  for (let k = 0; k < 6; k++) {
    const x = 127 + 12 * k;
    if (k >= cap) { sheetFrame(ctx, 'ICONS', 122, x, 165); continue; }
    if (k < taken) {
      // A carried unit's own icon marks its hold -- the port's convention;
      // which query the engine answers for a unit-held slot is unread.
      const cu = unit(entryType(ship.cargo[k]));
      if (cu) sheetFrame(ctx, 'ICONS', entryIcon(ship.cargo[k]), x, 168);
      continue;
    }
    // The runtime hold MERGES same-good slots; the engine draws per RECORD
    // slot -- expand one crate per 100 plus a partial, like the F7 grid.
    const crates = [];
    for (const h of hold) {
      let q = h.qty;
      while (q >= 100) { crates.push(0x16 + h.good); q -= 100; }
      if (q > 0) crates.push(0x26 + h.good);
    }
    const f = crates[k - taken];
    if (f !== undefined) {
      const [fw] = frameSize('ICONS', f);
      // Crate placement @0x28063-@0x280AF: x centred as cellx + (cellw-1)/2
      // - w/2 + 1 = x + 5 - w/2, y = the cell y verbatim -- NO vertical
      // centring.
      sheetFrame(ctx, 'ICONS', f, x + 5 - (fw >> 1), 165);
    }
  }
}

// The BUY / CHANGE buttons of the Build view: white FONTTINY text at y=140
// (BUY x219, CHANGE x273 -- census3_colony_view2 pixel positions) inside a
// bordered plate. The plate metrics (2px pad, 1px border) are drawn to the
// capture's look; the engine's own button chrome is unread, flagged.
const BUILD_BTN = {
  buy: { x: 216, y: 137, w: 18, h: 11 },
  change: { x: 270, y: 137, w: 29, h: 11 },
};
function drawPanelButton(ctx, b, label) {
  ctx.fillStyle = ink(1);
  ctx.fillRect(b.x, b.y, b.w, b.h);
  hollowRect(ctx, b.x, b.y, b.w, b.h, 0x0F);
  FONT.tiny.center(ctx, label, b.x + (b.w >> 1), b.y + 3, lut(15));
}
// Right panel (207,130,95,48) plus the three view buttons beside it.
function drawColonyPanel(ctx, c) {
  const cmisc = DATA.text.cmisc || [];
  if (G.colonyView === VIEW_UNITS) {
    // "Units Present" -- LABELS @CMISC row 1, centred dim-blue at y=132
    // (census3_colony_view1; same ink as "No Ships In Port").
    FONT.tiny.center(ctx, cmisc[1] || 'Units Present', 254, 132, lut(PANEL_INK));
    const inside = G.units.filter(u => u.x === c.x && u.y === c.y);
    inside.slice(0, 6).forEach((u, i) => {
      const [fw, fh] = frameSize('ICONS', unitIconOf(u));
      sheetFrame(ctx, 'ICONS', unitIconOf(u), 209 + i * 15, 162 - fh);
      nationPlate(ctx, 209 + i * 15, 150, ownerColour(u), u.orders);
    });
  } else if (G.colonyView === VIEW_BUILD) {
    // The Build view (census3_colony_view2): the construction target's name
    // centred at y=132 in the panel ink ("Docks"; @MISC 32 "Nothing" when
    // idle), BUY left / CHANGE right.
    FONT.tiny.center(ctx, c.building || (DATA.text.misc || [])[32] || 'Nothing',
                     254, 132, lut(PANEL_INK));
    drawPanelButton(ctx, BUILD_BTN.buy, (DATA.text.ctitle || [])[2] || 'BUY');
    drawPanelButton(ctx, BUILD_BTN.change, (DATA.text.ctitle || [])[3] || 'CHANGE');
  } else {
    drawProductionStrips(ctx, c);
  }
  // View buttons.
  for (let k = 0; k < 3; k++) {
    const by = VIEW_BTN.y + k * VIEW_BTN.pitch;
    sheetFrame(ctx, 'ICONS', 67 + k, VIEW_BTN.x, by);
    if (k === G.colonyView) hollowRect(ctx, VIEW_BTN.x - 1, by - 1, 16, 15, 0x0F);
  }
}

// ---- the production panel: `func_0275CE` (panel mode 0 of `func_02814C`) ---
// Three FIXED rows, not a free flow -- each one is an enqueue/flush pass over a
// contiguous slice of the commodity table, so a good always lands in the same
// row whatever else the colony makes:
//   row 0  y=134  raw goods 1..7, skipping food (0) and lumber (5), which have
//                 rows of their own    (loop `cmp [bp-6],7` @0x0275EA-0x02761E)
//   row 1  y=148  manufactured goods 8..15, each paired with the raw it eats
//                 (`byte[bx+0x2a2]` names the source, @0x027646)
//   row 2  y=162  lumber and hammers, surplus then consumed
// All three flush at x=213 across an 89px span (`ax=0xd5 / bx=0x59`
// @0x027620-0x02762B); the row y starts at 0x86=134 and steps 14
// (`add [bp-4],0xe` @0x027630). Rows 0 and 1 pass gap 2, row 2 passes gap 4.
//
// Verified against docs/screens/live_1653_save/colony_curacao.png: feeding the
// frame's own counts through drawCountRow puts furs at 223, ore at 234..269,
// silver at 281..291 (row 0), cloth at 240..260 and tools at 270..290 (row 1),
// and the lumber/hammer runs at pitch 6 with their last marks at 243 and 287
// (row 2) -- every one of those matches a template hit in the capture exactly.
const PROD_X0 = 213, PROD_SPAN = 89, PROD_Y0 = 134, PROD_PITCH = 14;
const PROD_GOOD_ICON = 22, PROD_HAMMER_ICON = 54;

function drawProductionStrips(ctx, c) {
  // func_0275CE loads the badge gate from the same saved [0x336] byte as the
  // plaza strip (`mov al,[0x336]` @0x0275D3) -- numbers only when the toggle
  // is on (census3: the engine's 4-sugar row carries no badge).
  const rows = productionRows(colonyProduce(c));
  const nums = !!G.colonyNumbers;
  drawCountRow(ctx, rows[0], PROD_X0, PROD_Y0, PROD_SPAN, 2, nums);
  drawCountRow(ctx, rows[1], PROD_X0, PROD_Y0 + PROD_PITCH, PROD_SPAN, 2, nums);
  drawCountRow(ctx, rows[2], PROD_X0, PROD_Y0 + 2 * PROD_PITCH, PROD_SPAN, 4, nums);
}

// The three rows' cells, split out from the painter so the byte-read rules can
// be replayed against the live production tables in the tests.
function productionRows(r) {
  const cell = (i, count, sub, flags) =>
    ({ frame: PROD_GOOD_ICON + i, count, sub, flags: flags || 0 });
  // Row 0 (@0x027604-0x027612): count = produced + [0x8E32], sub = [0x8E32].
  // [0x8E32] is the [-0x71CE] plane (set_commodity_band @0x8E20): max(0,
  // consumed - produced) = the part drawn from the WAREHOUSE -- which is why
  // Vlissingen's 13 ore (miners 8 + centre Minerals secondary 5) crosses
  // nothing while its toolsmith eats 6 out of a 161-crate store. A good with
  // NOTHING produced is skipped even if consumed (`cmp word[bx-0x7238],0 /
  // je` @0x0275F1) -- live Curacao eats 6 cotton and shows no cotton entry.
  const raw = [];
  for (let i = 1; i <= 7; i++) {
    if (i === 5 || r.gross[i] === 0) continue;          // lumber has its own row
    const over = r.overAmt ? r.overAmt[i] : 0;
    raw.push(cell(i, r.gross[i] + over, over));
  }
  // Row 1: manufactures. Each good i names a source good in `byte[0x2A2+i]`
  // and crosses out `word[0x8E5A + src*2]`; count = max(want, that), sub =
  // that (@0x027646-0x027688). [0x8E5A] is the OUTAGE plane ([-0x71A6],
  // @0x8E32-0x8E40): max(0, consumed - stock - produced), factory-converted
  // to product units -- re-resolved 2026-08-28, and every live read fits:
  //   Curacao   lumber consumed 6, stock covered      -> 0
  //   Vlissingen lumber want 12, stock 0, produced 8  -> 4
  //   Curacao   cotton consumed 6 from stock          -> 0
  // and the Horses slot (which sources ITSELF, [0x8E6A]) is the foals that
  // found no food: Curacao 4 of 4 lost, Vlissingen 3 of 4 -- the old
  // "unknown filler" resolved.
  const SRC = { 8: 8, 9: GOOD.SUGAR, 10: GOOD.TOBACCO, 11: GOOD.COTTON,
                12: GOOD.FURS, 14: GOOD.ORE, 15: GOOD.TOOLS };
  const made = [];
  for (let i = 8; i < r.gross.length; i++) {
    const src = SRC[i];
    const amt = src === undefined ? 0 : (r.outageAmt ? r.outageAmt[src] : 0);
    made.push(cell(i, Math.max(r.gross[i], amt), amt));
  }
  // Row 2: lumber then hammers. Bit 15 marks every icon of a consumed run and
  // reddens its badge (`ax=0x801c` @0x0276F1, `ax=0x8037` @0x02771F).
  // FOUR cells, each surplus-then-shortfall: lumber PRODUCED plain, the
  // lumber OUTAGE ([0x8E64]) marked, the POST-OUTAGE hammers plain, then
  // the hammer shortfall marked -- the Vlissingen baseline draws
  // [8 planks][4X][8 hammers][4X] as four separate groups.
  const lumberOut = r.outageAmt ? r.outageAmt[GOOD.LUMBER] : 0;
  const work = [
    cell(GOOD.LUMBER, r.gross[GOOD.LUMBER], 0),
    cell(GOOD.LUMBER, lumberOut, 0, 0x8000),
    { frame: PROD_HAMMER_ICON, count: r.tally[HAMMERS], sub: 0, flags: 0 },
    { frame: PROD_HAMMER_ICON, count: lumberOut, sub: 0, flags: 0x8000 },
  ];
  return [raw, made, work];
}

// The dock's candidate ladder, §17.6. Three slots; each holds a UNIT TYPE, not
// a price band. The cited roll, with threshold (lvl+3)>>1 and lvl = difficulty:
//   random(1,15) <= thr -> Petty Criminal
//   else random(1,10) <= thr -> Indentured Servant
//   else Free Colonist
// so harder difficulty really does crowd the dock with low-tier arrivals. Every
// fourth turn (turn & 3 == 0) the generator draws a PROFESSIONAL instead.
//
// Passage price comes from @CLASS.transport_cost. Rows 0 and 1 of that table
// are literally named "Petty Criminals" and "Indentured Servants", matching the
// first two ladder outcomes exactly; the remaining six rows are profession
// bands (600..2000). Free Colonists and the professionals are mapped onto those
// bands by nearest @JOB europe_value -- a mapping between two shipped tables,
// but INFERRED, not cited. Tracked in docs/UI_AUDIT_TRACKER.md.
const CLASS_CRIMINAL = 0, CLASS_SERVANT = 1, CLASS_FREE = 2;
function bandFor(europeValue) {
  let best = 2;
  for (let i = 2; i < DATA.classes.length; i++)
    if (Math.abs(DATA.classes[i].cost - europeValue) <
        Math.abs(DATA.classes[best].cost - europeValue)) best = i;
  return best;
}
function rollImmigrant() {
  const thr = (G.difficulty + 3) >> 1;
  if ((G.turn & 3) === 0 && G.turn > 0) {
    const j = DATA.jobtrain[Math.floor(Math.random() * DATA.jobtrain.length)];
    return { name: j.expert, band: bandFor(j.cost) };
  }
  if (Math.floor(Math.random() * 15) + 1 <= thr)
    return { name: DATA.classes[CLASS_CRIMINAL].name, band: CLASS_CRIMINAL };
  if (Math.floor(Math.random() * 10) + 1 <= thr)
    return { name: DATA.classes[CLASS_SERVANT].name, band: CLASS_SERVANT };
  return { name: 'Free Colonists', band: CLASS_FREE };
}

// ------------------------------------------------------------ the market
// §9.2-9.4. Each good carries a price with a floor/ceiling, a visible bid/ask
// spread of burden+1, and a traffic accumulator. The accumulator gains the
// attrition drift every turn and +-(qty << volatility) per trade; when it
// reaches -100*rise the price steps up, at +100*fall it steps down, and the
// threshold is handed back each time.
function seedMarket() {
  G.market = DATA.cargo.map(c => c.start1 + Math.floor(Math.random() * (c.start2 - c.start1 + 1)));
  // Four traffic pools (PowerRecord +0x5C each; see the importer note);
  // the player's is G.accum, aliased into G.rivalAccum[nation].
  G.rivalAccum = [0, 1, 2, 3].map(() => DATA.cargo.map(() => 0));
  G.accum = G.rivalAccum[G.nation];
  // Four PRICE-LEVEL rows (PowerRecord +0x4C each): every power has its own
  // market. At new game the engine computes all four from ONE shared random
  // price base with empty pools (func_036574's tail @0x367E8..@0x36809 runs
  // the drift for each power in turn over [0x53EA]), so the rivals start
  // level-for-level with the player: copies, no extra draws. G.market is
  // the player's row, aliased.
  G.rivalMarket = [0, 1, 2, 3].map(p => (p === G.nation ? G.market : G.market.slice()));
  // The whole-game PowerRecord trade counters the F5 report reads: net units
  // (+0xBC) and net value (+0x7C), zeroed at game start (func @0x366E7).
  G.tradeTons = DATA.cargo.map(() => 0);
  G.tradeGold = DATA.cargo.map(() => 0);
}
// G.market[i] is the record's PRICE LEVEL (+0x4C), and neither quoted number
// equals it -- they straddle it. BYTE-VERIFIED:
//
//   BID  func_030590 @0x030590:  al = power[+0x4C + good]; dec ax;
//                                jns -> keep, else 0   => max(0, level - 1)
//   ASK  commodity_current_price @0x030566:  cx = [good*9 - 0x6900];
//                                al = power[+0x4C + good]; add ax, cx;
//                                jns -> keep, else 0   => max(0, level + spread)
//
// The @CARGO table at [good*9 - 0x6900] (stride 9) holds the spread, which is
// the number DATA.cargo[i].burden already carries. The port used to quote the
// level itself as the bid and `burden + 1` as the ask, so BOTH numbers came out
// one high -- which is exactly what the census measured against the live 1653
// Europe market bar: DOS 0/8 6/8 4/6 4/6 5/7 ... 1/2 9/10 where the port
// printed 1/9 7/9 5/7 5/7 6/8 ... 2/3 10/11, all sixteen goods, both halves.
// Not a new finding either: docs/COLONIZATION_TECHNICAL_REFERENCE.md:1421 has
// read "Display: sell = level - 1, buy = level + burden" since the PowerRecord
// table was written, with the worked example at :1433. Neither engine did it.
const bidPrice = (i) => Math.max(0, G.market[i] - 1);
const askPrice = (i) => Math.max(0, G.market[i] + DATA.cargo[i].burden);
// The same bid for ANY power's own market: the engine keeps a per-power bid
// byte table at DGROUP 0x84BC + power*16 + good = max(0, level - 1), built
// for all four powers at boot (func_005760 @0x57A5..@0x57BB) and rebuilt for
// the current power by every drift (@0x30B14..@0x30B24); the AI custom
// house and overflow sales read it for the OWNER (@0x2E7A0).
const marketRow = (p) => (G.rivalMarket && G.rivalMarket[p]) || G.market;
const bidPriceOf = (p, i) => Math.max(0, marketRow(p)[i] - 1);
function stepPrice(i) { stepPriceOf(G.nation, i); }
function stepPriceOf(p, i) {
  const c = DATA.cargo[i];
  const row = marketRow(p);
  const acc = G.rivalAccum ? G.rivalAccum[p] : G.accum;
  const before = row[i];
  while (acc[i] <= -100 * c.rise && row[i] < c.high) {
    row[i] += 1; acc[i] = w16(acc[i] + 100 * c.rise);
  }
  while (acc[i] >= 100 * c.fall && row[i] > c.low) {
    row[i] -= 1; acc[i] = w16(acc[i] - 100 * c.fall);
  }
  // @PRICEUP/@PRICEDOWN fire from the drift fn itself (func_0305A8, RULINGS
  // 2026-06-19), so BOTH movement paths announce: the per-power pass's
  // Europe update (func_0363A2 @0x363D3, called from func_02F052 @0x2F218)
  // and the single-good re-drift after a buy/sell (@0x32902/@0x32D99).
  // Live frames wear MSS2 with the good + number hilited
  // (SESSION_UI_CATALOG frames 1310280609..). FLAGGED reading: the
  // announced number is the record's PRICE LEVEL -- whether the engine
  // prints the level, the bid or the ask is unread. A rival's market
  // moves silently (the port's reading; the human gate on the message
  // path inside the drift is unread).
  if (p === G.nation && row[i] !== before && G.eventQueue)
    showEvent(row[i] > before ? 'PRICEUP' : 'PRICEDOWN',
              { STRING0: c.name, STRING1: DATA.nations[G.nation].homeport,
                NUMBER0: row[i] });
}
// The traded-lot market pressure -- BYTE_VERIFIED func_03234A (sell) /
// func_0322D0 (buy), read 2026-08-29:
//   value = qty << volatility (the @CARGO row byte +8)
//         + trunc(qty * k / 100),  k = (human ? difficulty - 2 : -2) * 16
//           (func_032294 -- easy difficulties and AI sellers UNDER-pressure
//           the market by up to 32%; Viceroy over-pressures; at difficulty
//           2 the term is 0)
// A SELL adds the value to ALL FOUR powers' +0x5C traffic words (the
// shared world market), the DUTCH (power 3) accruing only 2/3
// (@0x32396..@0x323A1 -- their prices fall slower); a BUY subtracts the
// FULL value from all four (@0x322FF -- no discount, so Dutch prices also
// recover faster). The record word is a SIGNED 16-bit accumulator (word
// add/sub, no widening) -- every write wraps to s16 to match. The port
// sells only as the human player, so k uses the human term (the AI -2
// case lands with B3.6).
const w16 = (x) => (x << 16) >> 16;
// `human` selects func_032294's k term: the human seller's difficulty
// term, or the flat -2 for an AI seller (@0x322A5 controller test ->
// @0x322B8 `mov [bp-2],0xFFFE`). The AI custom house and overflow sales
// run this same accumulator (0x191F:0xA2E @0x2D774 / @0x2E76C).
function poolMove(i, qty, sign, human = true) {
  const k = (human ? G.difficulty - 2 : -2) * 16;
  const val = ((qty * k / 100) | 0) + (qty << DATA.cargo[i].volatility);
  for (let p = 0; p < 4; p++) {
    let v = val;
    if (sign > 0 && p === 3) v = (v * 2 / 3) | 0;
    const arr = G.rivalAccum ? G.rivalAccum[p] : (p === G.nation ? G.accum : null);
    if (arr) arr[i] = w16(arr[i] + (sign > 0 ? v : -v));
  }
}
function driftMarket() { driftMarketOf(G.nation); }
// The per-power drift. Every power's market moves once a turn: the
// per-power pass func_02F052 calls the Europe update func_0363A2 for ITS
// power (@0x2F218, after the colony loop), which sets the current power
// (@0x363B5) and runs drift(0, -1) @0x363D3 -- so a rival's prices move
// on the rival's own pool exactly as the player's do (read 2026-09-02;
// the old "rivals' drift cadence unread" flag is closed). The port's
// attrition/threshold model is oracle-locked; it is applied per power.
//   AI PRICE CAP (@0x30ABB..@0x30B0A, inside the drift, AI powers only):
//   for HORSES (8), TOOLS (0xE) and MUSKETS (0xF) the level is clamped to
//   3 + ((4 - difficulty) * 3 >> 1) -- an AI power never pays more than
//   that for its arms and tools.
function driftMarketOf(p) {
  const row = marketRow(p), acc = G.rivalAccum ? G.rivalAccum[p] : G.accum;
  DATA.cargo.forEach((c, i) => { acc[i] = w16(acc[i] + c.attrition); stepPriceOf(p, i); });
  if (p !== G.nation) {
    const cap = 3 + (((4 - G.difficulty) * 3) >> 1);
    for (const g of [GOOD.HORSES, GOOD.TOOLS, GOOD.MUSKETS])
      if (row[g] > cap) row[g] = cap;
  }
}
// SELL: gross = price*qty, tax = gross*rate/100, you keep the rest and the
// King's fund gains the tax. Selling floods the market, so the accumulator
// rises and the price falls.
// A boycotted good cannot be traded in Europe at all -- the mask is tested on
// every trade (@0x030B47), and only paying the back tax or seating Jakob Fugger
// clears it.
const isBoycotted = (i) => G.boycotts.includes(i);
function sellGoods(i, qty) {
  if (qty <= 0 || isBoycotted(i)) return 0;
  const gross = bidPrice(i) * qty;
  const tax = Math.floor(gross * G.tax / 100);
  G.gold += gross - tax;
  G.kingsFund += tax;
  // PowerRecord trade counters (byte-cited updater table, §PowerRecord):
  // EU supply +0xBC += qty; traded value +0x7C += price*qty*(100-tax)/100,
  // truncated PER LOT (which is why the F5 gold column undershoots
  // tons x bid on goods sold in many small lots). Warehouse-overflow forced
  // exports never run these updaters -- and the port's overflow discards
  // rather than sells, so that asymmetry holds here by construction.
  G.tradeTons[i] = (G.tradeTons[i] || 0) + qty;
  G.tradeGold[i] = (G.tradeGold[i] || 0) + Math.floor(gross * (100 - G.tax) / 100);
  poolMove(i, qty, +1);
  stepPrice(i);
  return gross - tax;
}
// BUY is untaxed and pays the ask; buying drains the market, so the price rises.
function buyGoods(i, qty) {
  if (isBoycotted(i)) return 0;
  const cost = askPrice(i) * qty;
  if (cost > G.gold) return 0;
  G.gold -= cost;
  // Purchases run the counters the other way: supply -= qty, value -= ask*qty.
  G.tradeTons[i] = (G.tradeTons[i] || 0) - qty;
  G.tradeGold[i] = (G.tradeGold[i] || 0) - cost;
  poolMove(i, qty, -1);
  stepPrice(i);
  return cost;
}

// ------------------------------------------------------------ Europe screen
// §26.9. EUROPE.PIK carries the dock town, market grid and the red "E"; the
// engine draws the title band, the market prices, the dock/panel captions and
// the recruit menu.
const EURO_ROWS = DATA.eurolabel.slice(0, 3);
// The Europe purchase catalog is byte-cited in §17.6: Artillery 500, Caravel
// 1000, Merchantman 2000, Galleon 3000, Privateer 2000, Frigate 5000 -- and
// only Artillery escalates, +100 per unit already bought.
const PURCHASE_CATALOG = [
  { unit: 'Artillery', price: 500, escalates: true },
  { unit: 'Caravel', price: 1000 },
  { unit: 'Merchantman', price: 2000 },
  { unit: 'Galleon', price: 3000 },
  { unit: 'Privateer', price: 2000 },
  { unit: 'Frigate', price: 5000 },
];
const purchasePrice = (r) => r.price + (r.escalates ? G.artilleryBought * 100 : 0);

function shipsInPort() { return G.europe.filter(e => e.state === 'port'); }
function activeShip() { return shipsInPort()[G.euroShip] || null; }

// Dock-unit and ship-in-harbour box layouts. Module scope, because the click
// handler hit-tests the same boxes the painter draws -- keeping them local was
// how the Europe hit-test ended up carrying a different rect from the art.
// Slot geometry CAPTURE-PINNED 2026-08-07 with three recruits + two bought
// ships live (docs/screens/live_2026-08-07/europe_dock_3units.png /
// europe_port_2ships.png): dock figures at x=235+17k (cell x=232+17k, 18x18,
// figure at cell+3) -- pitch 17, not the old 14 guess; in-port ships at
// sprite x=149+18k (cell x=145+18k, sprite at cell+4) -- pitch 18, not 12.
// The selected ship's cell tracks the "Loading:" caption (the boxed ship IS
// the caption's ship in the two-ship frame).
const EURO_DOCK = { x: 232, y: 137, pitch: 17 };
const EURO_SHIP = { x: 145, y: 145, pitch: 18 };

// The little NATION SACK every waiting entity carries -- dock units, in-port
// ships and crossing passengers all wear it (all three captures above).
// It matches no decoded ICONS frame exactly (nearest shape: the furs bundle
// at 0.86), so this is the OBSERVED 7x9 pixel block itself, capture-derived:
// N = the nation colour (the Dutch 13 in the captures), b = its EGA dark
// partner (colour-8: 13->5 = (170,73,0), verified pixel-exact), K = black.
const SACK_ROWS = [
  '.KKKKK.', 'KNNNNNK', 'KNNbbNK', 'KNbNNNK', 'KNNbNNK',
  'KNNNbNK', 'KNbbNNK', 'KNNNNNK', 'KKKKKKK',
];
function drawSack(ctx, x, y) {
  const c = DATA.nations[G.nation].color;
  // ink(), not lut(): lut() is the 3-level FONT palette array, which is not a
  // canvas fillStyle -- feeding it one left every N/b pixel painted with the
  // previous style (black), turning the sack into a black box.
  const cols = { K: ink(0), N: ink(c), b: ink(c - 8) };
  SACK_ROWS.forEach((row, dy) => {
    for (let dx = 0; dx < row.length; dx++) {
      if (row[dx] === '.') continue;
      ctx.fillStyle = cols[row[dx]];
      ctx.fillRect(x + dx, y + dy, 1, 1);
    }
  });
}
function drawEurope(ctx) {
  // TUTORIAL17: the first European Status visit (binding flagged).
  tutOnce(17, { STRING0: DATA.nations[G.nation].homeport,
                STRING1: DATA.nations[G.nation].country });
  // The MASTER palette, not EUROPE.PIK's — census C4.5, 2026-08-19. The DOS
  // capture matches VICEROY.PAL at all 22 indices where the two disagree
  // (checked at 54..59). Measured: 12,817 -> 5,448 px on the census EUROPE
  // row. Scoped to Europe; the report plates agree with the master anyway so
  // they cannot tell us whether this generalises. usePalette(null) falls back
  // to DATA.palette, the master.
  usePalette(null);
  ctx.drawImage(IMG.EUROPE, 0, 0);
  // SEVEN rows of wood, y0..6, then a black separator at y7 --
  // spec/ui/europe_screen.md:51, measured from capture. Both engines clipped
  // to 8 and drew no separator, so row 7 was wood instead of black: 320 px
  // wrong on every visit, invisible to every C-vs-JS gate because both were
  // wrong the same way. Found by the DOS census 2026-08-19 (C4.6).
  const [tw2] = frameSize('WOODTILE', 0);
  ctx.save(); ctx.beginPath(); ctx.rect(0, 0, W, 7); ctx.clip();
  for (let x = 0; x < W; x += tw2) sheetFrame(ctx, 'WOODTILE', 0, x, 0);
  ctx.restore();
  ctx.fillStyle = ink(0); ctx.fillRect(0, 7, W, 1);
  const n = DATA.nations[G.nation];
  // TWO spaces after the country, not one. The census caught it as a clean
  // 2 px width difference: the top bar matched the original EXACTLY either
  // side of one point -- every 8-px window left of x=136 fit at shift +1 with
  // zero differing pixels, every window right of x=144 fit at shift -1 with
  // zero -- and the gap between "Netherlands." and "Autumn" measured 7 px on
  // the original against the port's 5, which is precisely the difference
  // between the double space this string already uses after the year (7 px on
  // both sides) and a single one. One character; 578 px of the screen.
  const band = `${n.homeport}, ${n.country}.  ${DATA.seasons[G.season]}, ${G.year}.` +
               `  Tax:${G.tax}%  Gold: ${G.gold}$`;
  FONT.tiny.center(ctx, band, 160, 1, lut(HUD_INK));

  // Market bar: icons centred on 19i + 10 at y=181, bid/ask at y=194.
  //
  // The ICON blit is now read from the bar's OWN drawer, func_0310B4
  // (C4.10, 2026-09-02): cell_x starts at 1 (@0x0310CA) and steps 0x13
  // (@0x03124C); the frame is 0x17 + i in EXE numbering (@0x0310F2 = bundle
  // 0x16 + i); the width is the runtime sheet record's +8 word for THAT
  // frame (`mov cx, es:[bx+si+0x152]` @0x0310FC, 0x152 = 0x36 + 8 + 12*0x17),
  // and x = cell_x - (w >> 1) + 9 (`sar cx,1; sub dx,cx; add dx,9`
  // @0x031101-@0x031105) = 19i + 10 - (w >> 1), blitted through 0x181F:0x254
  // = func_00E76A, which adds NO per-frame offset (@0x00E7E7 uses the
  // passed x verbatim). y = 0xB5 = 181 @0x0310CF. That is the formula below;
  // the census EUROPE frame fits every one of the sixteen icons at shift 0
  // (per-cell sweep -2..+2, 2026-09-02), so the "one pixel left" note the
  // ledger carried from before C4.24 is stale: measured delta 0 -> 0.
  //
  // The SELECTION CURSOR is the hollow rect 0x181F:0xCE with x0 = cell_x - 1
  // = 19i (`dec ax` @0x031241), x1 = cell_x + 0x12 = 19i + 19, y0 = 179
  // (`dec dx; dec dx` off 181 @0x031245), y1 = 199 (pushed 181 + 0x12): the
  // line verbs are endpoint-INCLUSIVE -- the DOS frame paints column 19 in
  // ink 14 on rows 179..199 while the port stopped at 18 -- so the cell is
  // 20 wide, not 19. Measured: 40 px of cells 0/1 (the two edge columns).
  // Ink 0xA normally, 0xE under the drag gates @0x0311EF-@0x03121A; the
  // port keeps its 0xE (the census state matches).
  //
  // Scoped to EUROPE. The colony screen has its own market strip drawn by a
  // different function, and no census capture of that screen exists yet, so it
  // keeps its capture-derived 9 until one does.
  DATA.cargo.forEach((g, i) => {
    const [fw] = frameSize('ICONS', 0x16 + i);
    sheetFrame(ctx, 'ICONS', 0x16 + i, 10 + 19 * i - (fw >> 1), 181);
    FONT.tiny.center(ctx, `${bidPrice(i)}/${askPrice(i)}`, 9 + 19 * i, 194, lut(0x2F));
    if (i === G.marketSel) hollowRect(ctx, 19 * i, 179, 20, 21, 0x0E);
  });

  // Panels. "Expected Soon" lists crossings inbound to Europe, "Bound For" the
  // ones outbound, "Loading" the ship at the dock and its hold.
  //
  // func_031298 @0x031298 -- the column layout by RUNNING ORDINAL (C4.11,
  // 2026-09-02). Bins ordinal n into a band and returns the cell:
  //   n < 4        band 0, k = n      (@0x0312AC `cmp ax,4; jge`)
  //   n < 12       band 1, k = n - 4  (@0x0312BB-@0x0312C3)
  //   n - 12 < cap band 2, k = n - 12 (@0x0312CF-@0x0312D9)
  //   else         band 3, undrawn (func_031366 tests band < 3)
  // step = 0x10 >> band (@0x0312E5) is both the cell h and the pitch; band 0
  // adds `arg` to the pitch (@0x0312F0-@0x0312F8), band 2 adds 1 (`inc
  // [bp-4]` @0x031300: pitch 5, not 4); w = h = step; x = k * pitch + base
  // (@0x031310-@0x03131C); then per band (@0x03135A): 0 -> y 0x92 (146);
  // 1 -> x += 2, w -= 2, y 0x89 (137); 2 -> x += 1, w -= 1, y 0x84 (132).
  const crossLayout = (n, baseX, cap, arg) => {
    let band = 0, k = 0;
    if (n < 4) k = n;
    else if (n - 4 < 8) { band = 1; k = n - 4; }
    else if (n - 12 < cap) { band = 2; k = n - 12; }
    else band = 3;
    const step = 0x10 >> band;
    const pitch = step + (band === 0 ? arg : band === 2 ? 1 : 0);
    const c = { band, x: k * pitch + baseX, y: 0, w: step, h: step };
    if (band === 0) c.y = 0x92;
    else if (band === 1) { c.x += 2; c.w -= 2; c.y = 0x89; }
    else if (band === 2) { c.x += 1; c.w -= 1; c.y = 0x84; }
    return c;
  };
  // func_031366 @0x031366 -- draw ONE unit at the ordinal and advance it
  // (`inc word ptr [bx]` @0x0314A9, unconditional): a ship and its riders
  // share one sequence, in the sentinel tile's occupancy-chain order.
  //   band 0/1 (@0x031393): the func_00386A composite (0x181F:0x2BC
  //     @0x0313C2) with mode 0x64 >> band (@0x0313A1-@0x0313A9: full for
  //     band 0, 0x32 half-size for band 1), W = 0x10 (@0x03139F),
  //     x - (band == 1 ? 4 : 0) (@0x0313AA-@0x0313BB), flags 0. Then a SHIP
  //     (type 0x0D..0x12 @0x0313CB/@0x0313D5) in band 0 with arg < 2
  //     (@0x0313E8) and a non-empty hold (+0x0C @0x0313EE) wears its hold-0
  //     good's icon 0x17 + get_nth_cargo(unit, 0) (0x181F:0xBE6 = func_00B2A2,
  //     the +0x0D low nibble) at (x, y) @0x0313F5-@0x031417. Crossings pass
  //     arg 1, the harbour 2 -- only a crossing ship shows its cargo.
  //   band 2 (@0x031420): the scaled blit 0x181F:0x2F8 = func_00E964 of the
  //     @UNIT icon byte [0x5232 + 14*type] at centre x + (w >> 1) - 1, bottom
  //     y + h - 1, pct 0x64 >> 2 = 25 (@0x031426-@0x031468).
  //   cursor: colour >= 0 and band < 3 (@0x03146D-@0x031477) -> hollow rect
  //     (x-1, y-1)-(x+w, y+h) via 0x181F:0xCE (@0x0314A1), endpoint-inclusive
  //     (RULINGS 2026-09-02c): w+2 by h+2.
  const crossUnit = (type, frame, colourIdx, orders, cargoGood, baseX, cap,
                     arg, ord, cursorColour) => {
    const c = crossLayout(ord.n++, baseX, cap, arg);
    const row = DATA.units.findIndex(r => r.name === type);
    if (c.band < 2) {
      unitPanel(ctx, c.x - (c.band === 1 ? 4 : 0), c.y, 0x10, type, 0, orders,
                colourIdx, frame, G.nation, 0x64 >> c.band);
      if (row >= 0x0D && row <= 0x12 && c.band === 0 && arg < 2 &&
          cargoGood >= 0)
        sheetFrame(ctx, 'ICONS', 0x16 + cargoGood, c.x, c.y);
    } else if (c.band < 3) {
      sheetFrameScaled(ctx, 'ICONS', (unit(type) || {}).icon,
                       c.x + (c.w >> 1) - 1, c.y + c.h - 1, 0x64 >> 2);
    }
    if (cursorColour >= 0 && c.band < 3)
      hollowRect(ctx, c.x - 1, c.y - 1, c.w + 2, c.h + 2, cursorColour);
  };
  // One crossing panel: func_0318D2 ("Expected Soon", base 2 @0x031915) and
  // func_0317CC ("Bound For", base 0x49 = 73 @0x031841). Each resets the
  // ordinal once (@0x03191A / @0x031846) and walks TWO sentinel-tile
  // occupancy chains through 0x181F:0x7E0 = func_0066CC (the head of the
  // first record at (p-0x10, p-0x10) then (p-0xC, ..) for Expected Soon
  // @0x03191F/@0x031954; (p-0x1C) then (p-0x18) for Bound For @0x03184B/
  // @0x031880), stepping the +0x1A link (0x181F:0x2E4 = func_0066BA), and
  // calls func_031366 for EVERY unit on them (cap 0xD, arg 1, colour -1).
  // The port's crossing is {ship, passengers in chain order} (the importer's
  // __ridx pass), so ship-then-riders IS the chain the fixture carries
  // (Galleon #56 heads 87 -> 86 -> 85). FLAGGED: two ships on one sentinel
  // interleave by the tile chain, and neither the cross-ship link nor which
  // of the pair's bases (0xE4/0xE8, 0xF0/0xF4) a ship sat on is kept -- save
  // state the ports do not carry (research TBD 4).
  const drawCrossingPanel = (state, baseX) => {
    const ord = { n: 0 };
    const colour = DATA.nations[G.nation].color;
    G.europe.filter(e => e.state === state).forEach(e => {
      const hold = e.hold || [];
      crossUnit(e.type, e.icon, colour, 0, hold.length ? hold[0].good : -1,
                baseX, 0xD, 1, ord, -1);
      // A professioned entry is {name, type}: name is what the man IS, type
      // what he is EQUIPPED as; entryIcon routes through func_003710 (the
      // veteran art with the matching profession, else the plain variant).
      // The plate LETTER is the rider's OWN order byte ([bx+0x314c]
      // @0x003907 -> [0x54DE + order]): a unit aboard a ship is SENTRY (1)
      // -- the fixture's three riders 85/86/87 carry +0x08 = 1 (the Galleon
      // 0), 9 of the save's 10 ship-borne land units do, and a unit CREATED
      // in Europe is born sentried (func_030C68: spawn_unit at the 0xEC+p
      // sentinel, then `mov [bx+0x314c], 1` @0x030CFA). The dock->ship
      // boarding write itself is unread (FLAGGED); the map's @UNITOPTIONS
      // row folds "Sentry / Board ship" into order 1. The port's rider entry
      // carries no order byte and no modelled path un-sentries a rider
      // aboard, so the letter is 1 here. FLAGGED: a rider un-sentried in a
      // harbour before sailing reads '-' there.
      (e.passengers || []).forEach(p =>
        crossUnit(entryType(p), entryIcon(p), colour, 1, -1, baseX, 0xD, 1,
                  ord, -1));
    });
  };
  // THE THREE PANEL HEADINGS -- centred, ink 69, and the port had all three
  // wrong.
  //
  // Ink: every heading is palette 69, not the 68 the top bar uses. Measured on
  // four independent captures (the census baseline plus the three 2026-08-07
  // Europe frames). 69 is not a @COLORS slot, so the VALUE comes from the
  // frames and its SOURCE is unidentified -- flagged.
  //
  // Centring, and why it has to be centring rather than the fixed x's the port
  // carried: panel 3's heading MOVES with its content. Across those frames "No
  // Ships In Port" sits at 156..209 while "Loading:" sits at 168..194 with the
  // ship's name on a SECOND line at 160..205 -- so the port was wrong twice
  // there, once about the x and once about putting the ship name on the same
  // line. Panel 2 settles the convention: "Bound For" (ink 33) at 91 and the
  // region name (ink 56) at 79 are two strings of different widths that solve
  // to the SAME centre under FONT.center's own rule, cx = 107 -- and they must
  // be centred anyway, because DATA.regionname varies by nation and a fixed x
  // could only ever be right for one. Panel 3's two strings likewise both
  // solve to cx = 183.
  //
  // FLAGGED: "Loading:" alone solves to cx = 181..181.5, ~1.5 px off the 183
  // its own second line gives. A trailing space in the engine's string would
  // close it exactly -- that is a guess, and is not made here. Panel 1's
  // heading never changes, so its cx = 36 is a one-string fit,
  // indistinguishable from a fixed x = 12 on every frame available.
  const EU_PANEL_INK = 69;
  FONT.tiny.center(ctx, 'Expected Soon', 36, 120, lut(EU_PANEL_INK));
  drawCrossingPanel('toEurope', 2);       // base 2 @0x031915 (the old 13 had no byte)
  // While a ship is being dragged, the Bound For panel lights up as the drop
  // target (engine region 2, rect @0x32094; the highlight itself is port UI).
  if (G.drag && G.drag.kind === 'ship' &&
      hit(PTR.x, PTR.y, { x: 72, y: 118, w: 70, h: 51 }))
    hollowRect(ctx, 72, 118, 70, 51, 0x0F);
  FONT.tiny.center(ctx, 'Bound For', 107, 120, lut(EU_PANEL_INK));
  FONT.tiny.center(ctx, DATA.regionname[G.nation], 107, 127, lut(EU_PANEL_INK));
  drawCrossingPanel('toNewWorld', 0x49);  // 73 @0x031841

  const ship = activeShip();
  FONT.tiny.center(ctx, ship ? 'Loading:' : 'No Ships In Port', 183, 120,
                   lut(EU_PANEL_INK));
  if (ship) FONT.tiny.center(ctx, ship.type, 183, 127, lut(EU_PANEL_INK));

  // Dock units and ships in port, REBUILT 2026-08-06 from the live frame
  // (docs/screens/live_2026-08-05/30_europe.png). Measured there:
  //   dock slot 0   box (232,137)-(249,154), ICONS frame 102 at (235,138)
  //   ship slot 0   box (145,145)-(162,162), ICONS frame   5 at (149,146)
  // so a sprite sits at box + (3, 1). RE-READ 2026-08-07 (user report): the
  // hollow green cell is the SELECTION cursor around the ACTIVE entry, not a
  // frame every entry wears -- the port had boxed everything, which is wrong.
  // CONFIRMED against docs/screens/10_europe_screen.png: three units stand on
  // the pier in distinct type sprites and only the FIRST (selected) one wears
  // the green cell; the docked Caravel wears its own. So: the selected ship
  // and the selected dock unit each wear one cell; everything else draws bare.
  //
  // The frame has ONE ship and ONE dock unit, so the SLOT PITCH is unmeasured;
  // the port keeps its previous 14 (units) and 12 (ships) rather than inventing
  // new numbers, and a capture with several of each would settle it.
  G.dockUnits.slice(0, 6).forEach((e, k) => {
    const u = unit(entryType(e)) || unit('Colonists');
    const x = EURO_DOCK.x + k * EURO_DOCK.pitch;
    // A waiting recruit/trainee (a plain profession string) draws his
    // PROFESSION FIGURE -- the game's own art, capture-pinned from the F4
    // Labor report (professionIcon, RULINGS 2026-08-07z2: @JOB 0..17 = png
    // 81+i, class tail 58-61/66/100/106/107). Once ARMED ({name,type}) he
    // draws as what he is equipped as, the @UNIT sprite.
    // The nation sack at his side (slot2 figure (269,138) / sack (275,145)
    // in europe_dock_3units.png -> cell+9/+8), then the figure over it.
    drawSack(ctx, x + 9, EURO_DOCK.y + 8);
    // Same rule as the crossing manifest: a {name, type} entry still shows his
    // PROFESSION figure while he is equipped as a plain colonist, and only
    // switches to the @UNIT sprite once Europe arms him as something else.
    // Kept in step with the C, whose entry_prof_figure() is shared by the dock
    // and the crossings.
    const fi = entryIcon(e);   // func_003710, like the crossings
    // func_00380C silhouette layer, 2 px left of the sprite (neutral on the
    // census fixture -- no dock unit in frame -- kept for the shared verb).
    sheetSilhouette(ctx, 'ICONS', fi, x + 1, EURO_DOCK.y + 1, 0);
    sheetFrame(ctx, 'ICONS', fi, x + 3, EURO_DOCK.y + 1);
    if (k === G.euroDockSel)
      hollowRect(ctx, x, EURO_DOCK.y, 18, 18, 0x0A);
  });
  // Ships in port: the same func_031366 verb from the dock painter
  // func_0314DC -- base 0x92 = 146 (@0x031631), cap 5, arg 2 (@0x0316AD-
  // @0x0316B1), ordinal reset once (@0x031638), iterating the ship LIST
  // 0..[0xFA2] (@0x031642-@0x0316C7, not a tile chain), cursor 0xA for the
  // selected index [0x9E1C] (@0x03166C; the 0xF drag states @0x031686/
  // @0x0316A1 are pointer states the harness pins off). So ordinal k sits at
  // x = 146 + 18k, y = 146, composite W = 16 -- the capture-pinned "sack at
  // cell+(1,1), sprite at cell+(4,1)" (europe_port_2ships.png: Merchantman
  // (149,146)) IS this composite's class-3 plate at x_c and its sprite at
  // x_c + LW - max(0, LW+SW-14) + 2 = 149 for a 13-wide hull; the separate
  // sack the port drew over the plate is gone. Cursor (x-1, y-1)-(x+16,
  // y+16) inclusive = the old (145+18k, 145, 18, 18). arg 2: no cargo icon.
  {
    const ord = { n: 0 };
    shipsInPort().forEach((e, k) =>
      crossUnit(e.type, e.icon, DATA.nations[G.nation].color, 0, -1, 0x92, 5,
                2, ord, k === G.euroShip ? 0x0A : -1));
  }

  // The active ship's CARGO ROW -- six slots at x = 147 + 12k, y = 165. That
  // geometry was already right (frame 122 template-matches the live row at
  // 171/183/195/207 at score 0, i.e. pitch 12 back to 147); what was wrong is
  // that the port drew it FOR the ships, one crate per ship, instead of drawing
  // the selected ship's hold. In the live frame the caravel's own two holds are
  // dark and the four slots beyond its capacity carry frame 122's cross.
  //
  // The dark hold is not a sprite I can name: nothing in ICONS matches those two
  // cells better than 0.62, so they are drawn as a plain dark cell here and the
  // real source is left open.
  //
  // The grid is now BYTE-VERIFIED too: func_0314AE @0x0314AE stores slot i at
  // x = 12*i + 0x93 (147), y = 0xA5 (165), w = 0x0A (10), h = 0x0C (12).
  //
  // And the row is drawn UNCONDITIONALLY. This loop used to hang off `if
  // (ship)`, so an empty harbour left the row as bare backdrop; func_0314DC
  // @0x0314F1 branches the other way -- with no ship selected ([0xFA2] == 0) it
  // walks i = 0..5 through the same grid and paints EVERY slot from one sprite
  // (@0x03154F). The census caught it on the 1653 frame, where the original
  // reads "No Ships In Port" over six drawn-empty slots, and frame 122 matches
  // the original's cells pixel-for-pixel there.
  {
    const holds = ship ? (Number((unit(ship.type) || {}).cargo) || 0) : 0;
    for (let k = 0; k < 6; k++) {
      const x = 147 + 12 * k;
      if (k < holds) { ctx.fillStyle = ink(0); ctx.fillRect(x, 165, 10, 12); }
      else sheetFrame(ctx, 'ICONS', 122, x, 165);
    }
  }

  // Recruit menu rows (281, 89+11r, 37, 9); accelerator letter yellow.
  // Buttons at (281, 89+11r, 37, 9): a 1px dark-blue border with the PIK panel
  // showing through -- NOT a filled bar. Text is white with the accelerator
  // (first) letter in yellow. Border colour 0x7D and text 0x10 sampled from
  // docs/screens/10_europe_screen.png; the geometry is the cited one, confirmed
  // against the capture once its 10px/29px letterbox offsets are taken out.
  EURO_ROWS.forEach((r, k) => {
    const y = 89 + 11 * k;
    // The frame is a BEVEL, not a one-colour hollow rect: top edge and left
    // column 0x39, bottom edge and right column 0x30. Read straight off the
    // census frame, where all three buttons carry it identically -- rows 89
    // and 97 are 37 px of 0x39 and 0x30 respectively, and rows 90..96 have
    // 0x39 at x=281 and 0x30 at x=317. The port drew a flat 0x7D box, which
    // is why the two edge rows differed across their whole width.
    //
    // FLAGGED: the original shows NO selected row on any Europe frame
    // available, so the 0x0F highlight is the port's own affordance for a
    // click cursor the original may not have.
    if (k === G.euroRow) hollowRect(ctx, 281, y, 37, 9, 0x0F);
    else {
      ctx.fillStyle = ink(0x39); ctx.fillRect(281, y, 37, 1);
      ctx.fillRect(281, y, 1, 9);
      ctx.fillStyle = ink(0x30); ctx.fillRect(281, y + 8, 37, 1);
      ctx.fillRect(317, y, 1, 9);
    }
    const w = FONT.tiny.width(r), x0 = 281 + (37 - w) / 2;
    FONT.tiny.draw(ctx, r[0], x0, y + 2, lut(0x0E));
    // The tail of the label is 0x0F (white), not 0x10 -- measured on the
    // census frame, where "ECRUIT"/"URCHASE"/"RAIN" are all 0x0F while only
    // the accelerator letter is 0x0E.
    FONT.tiny.draw(ctx, r.slice(1), x0 + FONT.tiny.width(r[0]), y + 2, lut(0x0F));
  });

  if (G.euroMenu) drawEuroMenu(ctx);
  if (G.euroMsg) FONT.tiny.center(ctx, G.euroMsg, 160, 172, lut(0x0E), ink(0));
  FONT.tiny.draw(ctx, 'Exit', 306, 181, lut(0x0F));
}

// A dock/passenger entry is a plain string (a @UNIT type or a profession name)
// until Europe ARMS it, after which it is { name, type }: name is what the man
// IS (his profession or class), type what he is equipped AS. Both readers below
// accept either form, and mkUnit consumes either on landfall.
const entryName = (e) => typeof e === 'object' ? e.name : e;
const entryType = (e) => typeof e === 'object' ? e.type
  : unit(e) ? e : (PROFESSION_UNIT[e] || 'Colonists');
// A carried/dock entry's icon through the same resolver: a {name,type}
// armed pair carries its profession in `name`; a bare profession string IS
// the profession; a bare type name has none.
const entryIcon = (e) => unitIconOf({
  type: entryType(e),
  profession: typeof e === 'object' ? (e.name && !unit(e.name) ? e.name : null)
            : (unit(e) ? null : e),
  icon: (unit(entryType(e)) || {}).icon,
});

// ---- the Europe dock-unit menu: GAME @EUROPEARM + @ARMOPTIONS -------------
// The 12 @ARMOPTIONS rows are grep-verified GAME.TXT (spec/ui/context_dialogs.md
// §4, `directives={}` bare list) and are now READ FROM THE SECTION rather than
// retyped -- the port used to hand-write English approximations of them, which
// dropped both the {brace} highlight markup every option row carries and the
// section's own %NUMBER price slots. Section row order:
//   0 don't board   1 board next ship   2 move to front of dock
//   3 arm Muskets   4 sell Muskets      5 equip Tools
//   6 sell Tools    7 equip Horses      8 sell Horses
//   9 bless        10 cancel Missionary status   11 no changes
// so ARM_VERBS lines up 1:1 with section rows 3..8.
//
// The quantities are the manual's (GAME_MANUAL.md 1962-1971: 50 muskets, 50
// horses, 50+50 for a dragoon; tools cap 100 = the Pioneer's UnitRecord +0x15
// start). Which rows the engine SHOWS per unit state is unread, so the port
// offers the applicable ones -- its own gating, flagged as such. Prices are the
// live market: buying charges the ask (buyGoods), selling returns the bid less
// tax (sellGoods), both moving the price like any other trade.
//
// FLAGGED -- the section gives each good ONE number, used by both its buy row
// ("costs {%NUMBER0$}") and its sell row ("save {%NUMBER0$}"), while the two
// transactions are worth different amounts here. Which figure the engine puts
// in that slot is unread. The buy price goes in, because that is the one the
// player is being asked to commit to; the sell rows therefore DISPLAY the ask
// while PAYING the bid less tax. Do not "fix" this by making them agree --
// that would be inventing a rule.
const EQUIP_MUSKETS = 50, EQUIP_HORSES = 50, EQUIP_TOOLS = 100;
const ARMOPT_ROWS = () => (DATA.events.ARMOPTIONS || { body: [] }).body;
// type -> type under each equip/unequip verb; `row` is its @ARMOPTIONS index.
const ARM_VERBS = [
  { row: 3, good: GOOD.MUSKETS, qty: EQUIP_MUSKETS,
    buy: true, map: { Colonists: 'Soldiers', Scouts: 'Dragoons' } },
  { row: 4, good: GOOD.MUSKETS, qty: EQUIP_MUSKETS,
    buy: false, map: { Soldiers: 'Colonists', Dragoons: 'Scouts' } },
  { row: 5, good: GOOD.TOOLS, qty: EQUIP_TOOLS,
    buy: true, map: { Colonists: 'Pioneers' } },
  { row: 6, good: GOOD.TOOLS, qty: EQUIP_TOOLS,
    buy: false, map: { Pioneers: 'Colonists' } },
  { row: 7, good: GOOD.HORSES, qty: EQUIP_HORSES,
    buy: true, map: { Colonists: 'Scouts', Soldiers: 'Dragoons' } },
  { row: 8, good: GOOD.HORSES, qty: EQUIP_HORSES,
    buy: false, map: { Scouts: 'Colonists', Dragoons: 'Soldiers' } },
];
// NUMBER0/1/2 = the BUY price of Muskets / Tools / Horses at this turn's ask.
function armOptionSubs() {
  return { NUMBER0: askPrice(GOOD.MUSKETS) * EQUIP_MUSKETS,
           NUMBER1: askPrice(GOOD.TOOLS) * EQUIP_TOOLS,
           NUMBER2: askPrice(GOOD.HORSES) * EQUIP_HORSES };
}
function dockUnitRows() {
  const e = G.dockUnits[G.euroDockSel];
  if (e === undefined) return [];
  const t = entryType(e);
  const src = ARMOPT_ROWS(), subs = armOptionSubs();
  const row = (i, fallback) =>
    src[i] === undefined ? fallback : fillTemplate(src[i], subs);
  const rows = [];
  // @ARMOPTIONS row 0/1: the auto-board flag. A dock unit boards the next
  // ship that sails UNLESS it is held back; both rows always show so you can
  // set either state (the engine offers the pair -- func_04B308 family).
  if (e && e.noBoard) rows.push({ label: row(1, 'Board next ship.'), act: 'board' });
  else rows.push({ label: row(0, "Don't get on next ship."), act: 'noboard' });
  rows.push({ label: row(2, 'Move to front of dock.'), act: 'front' });
  for (const v of ARM_VERBS) {
    const to = v.map[t];
    if (!to) continue;
    // What the transaction actually pays -- NOT what the row displays. See the
    // FLAGGED note on armOptionSubs: the section carries one number per good.
    const price = v.buy ? askPrice(v.good) * v.qty
                : Math.floor(bidPrice(v.good) * v.qty * (100 - G.tax) / 100);
    rows.push({ label: row(v.row, ''), act: 'arm', verb: v, to,
                dim: v.buy && (price > G.gold || isBoycotted(v.good)) });
  }
  if (t === 'Colonists')
    rows.push({ label: row(9, 'Bless as {Missionaries}.'), act: 'bless' });
  if (t === 'Missionaries')
    rows.push({ label: row(10, 'Cancel {Missionary} Status.'), act: 'unbless' });
  rows.push({ label: row(11, 'No changes.'), act: 'close' });
  return rows;
}
// The Europe harbour ship menu: GAME @EUROPESHIPCLICK + @EUROPESHIPOPTIONS,
// both grep-verified (spec/ui/context_dialogs.md §4). The four rows are read
// from the section rather than retyped -- see the @ARMOPTIONS note above.
// "Unload" in Europe means selling: the market is the only place cargo can go.
const EUROSHIP_ACTS = ['shipfront', 'sail', 'sellall', 'close'];
const EUROSHIP_FALLBACK = ['Move to front.', 'Set sail for the New World.',
                           'Unload all cargo.', 'No changes.'];
function euroShipRows() {
  const src = (DATA.events.EUROPESHIPOPTIONS || { body: [] }).body;
  return EUROSHIP_ACTS.map((act, i) => ({
    label: src[i] === undefined ? EUROSHIP_FALLBACK[i] : src[i], act,
  }));
}

// The three sub-menus. Each is a plaque list: rows of "<label> <price>" with
// the affordable ones lit and the rest dimmed.
function euroMenuRows() {
  // Census 2026-08-08 (census_euro_recruit / census_euro_train): the RECRUIT
  // list opens with a "(None)" row and shows NO per-row price (the passage
  // price is in the body); TRAIN opens with @MISC's "None" and prints each
  // price as "(Cost: N)" -- @MISC 13/14 are the "(Cost:" and ")" fragments.
  if (G.euroMenu === 'recruit')
    return [{ label: '(None)', none: true }].concat(
      G.dock.map(c => ({ label: c.name, cost: DATA.classes[c.band].cost,
                         hideCost: true })));
  if (G.euroMenu === 'train')
    return [{ label: (DATA.text.misc || [])[3] || 'None', none: true }].concat(
      DATA.jobtrain.map(j => ({ label: j.expert, cost: j.cost }))
                   .sort((a, b) => a.cost - b.cost));
  if (G.euroMenu === 'dockunit') return dockUnitRows();
  if (G.euroMenu === 'ship') return euroShipRows();
  return PURCHASE_CATALOG.map(r => ({ label: r.unit, cost: purchasePrice(r) }));
}
// The sub-menus are dialogs in the §3 framework, not ad-hoc lists: body text
// from the GAME.TXT section, option rows below it, box_w = content + 2*inset,
// centred. The ECONOMIC ADVISER portrait (MSS2 -- the merchant in the plumed
// hat, identified by rendering all six MSS sheets) sits above the box, which is
// where func_06BF66 draws the speaker.
const EURO_MENU_KEY = { recruit: 'RECRUIT', purchase: 'PURCHASE', train: null,
                        dockunit: null, ship: null };
const TRAIN_CAPTION = () => (DATA.events.KINGRECRUIT || {}).body ||
                            ['Which skill shall we request?'];
// The economic adviser speaks for RECRUIT and PURCHASE -- the two menus with a
// GAME.TXT body he is quoting -- and not for TRAIN, which is a bare list. He
// sits 4px lower than the box top, not flush against it.
const ADVISER_ECONOMIC = 'MSS2';
const ADVISER_DROP = 5;
const hasAdviser = () => EURO_MENU_KEY[G.euroMenu] !== null;
function euroMenuBox() {
  const rows = euroMenuRows();
  const key = EURO_MENU_KEY[G.euroMenu];
  let body = key ? DATA.dialogs[key].body : [G.euroMenu.toUpperCase()];
  // TRAIN quotes @KINGRECRUIT (the Royal University body, smallfont).
  if (G.euroMenu === 'train') body = TRAIN_CAPTION();
  // The two harbour context menus carry their own GAME.TXT caption sections.
  if (G.euroMenu === 'dockunit') {
    const e = G.dockUnits[G.euroDockSel];
    const cap = DATA.events.EUROPEARM;
    body = cap ? cap.body.slice() : ['European dock options:'];
    if (e !== undefined) body.push(`{${entryName(e)}}` +
      (entryType(e) !== entryName(e) ? ` (${entryType(e)})` : ''));
  } else if (G.euroMenu === 'ship') {
    const cap = DATA.events.EUROPESHIPCLICK;
    const ship = activeShip();
    body = (cap ? cap.body : ['European harbor options for {%STRING0}:'])
      .map(l => fillTemplate(l, { STRING0: ship ? ship.type : '' }));
  }
  // @RECRUIT quotes the passage in its body ("{%NUMBER0 gold}") -- fill it from
  // the highlighted candidate, which is the one that slot would cost.
  if (key === 'RECRUIT') {
    const rows0 = euroMenuRows();
    const price = rows0[G.euroMenuRow] ? rows0[G.euroMenuRow].cost : 0;
    body = body.map(l => l.replace('%NUMBER0', String(price)));
  }
  let cw = key ? DATA.dialogs[key].width : 0x50;
  const mf = dFont(G.euroMenu === 'train');
  for (const l of body) cw = Math.max(cw, mf.width(l));
  for (const r of rows)
    cw = Math.max(cw, mf.width(r.label.replace(/[{}]/g, '')) +
                      (r.cost === undefined ? 0 : mf.width(`(Cost: ${r.cost})`)) + 20);
  const small = G.euroMenu === 'train';       // @KINGRECRUIT is @SMALLFONT
  const w = cw + 6;
  const textH = body.length * dText(small);
  const foot = ['recruit', 'purchase', 'train'].includes(G.euroMenu) ? 10 : 0;
  const h = 6 + textH + 3 + rows.length * dRow(small) + 3 + foot;
  // Keep the whole thing on screen: where the adviser speaks he needs headroom
  // above the box, less the 4px he is dropped by. TRAIN has no portrait, so it
  // just centres.
  const [, ph] = frameSize(ADVISER_ECONOMIC, 0);
  const need = hasAdviser() ? ph - ADVISER_DROP + 2 : 2;
  const y = Math.max(need, Math.round(100 - h / 2));
  return { x: Math.round(160 - w / 2), y: Math.min(y, H - h - 2), w, h, textH, body, rows };
}
function drawEuroMenu(ctx) {
  const b = euroMenuBox();
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  const small = G.euroMenu === 'train';
  const mf = dFont(small), rp = dRow(small);
  b.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * dText(small),
                                    0xFE, 0xFC, mf));
  const seed = b.y + 6 + b.textH + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * rp;
    const sel = k === G.euroMenuRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, rp - 2); }
    // Unaffordable rows are DIMMED, not blacked out -- they still have to be
    // readable so you can see what you are saving up for. Action rows (the
    // harbour context menus) carry their price inside the label and dim on
    // their own `dim` flag instead.
    const afford = r.cost === undefined || r.none ? !r.dim : r.cost <= G.gold;
    const inkIdx = !afford ? 0x5D : (sel ? 0xFC : 0xFE);
    // Option rows span-paint like every other dialog row: the hilite ink is
    // gated on the {brace} flag (func_06C346 @0x06C365), never on selection.
    // The GAME.TXT harbour rows carry those braces around Muskets / Tools /
    // Horses / Missionaries; a dimmed row paints flat, since an unaffordable
    // row highlighting its own good would read as available.
    spanText(ctx, r.label, b.x + 9, y + 1, inkIdx, afford ? 0xFC : inkIdx, mf);
    if (r.cost !== undefined && !r.hideCost) {
      // "(Cost: N)" -- @MISC 13/14, the census TRAIN frame's own format.
      const c = `${(DATA.text.misc || [])[13] || '(Cost:'} ${r.cost}${(DATA.text.misc || [])[14] || ')'}`;
      mf.draw(ctx, c, b.x + b.w - 8 - mf.width(c), y + 1, lut(inkIdx));
    }
  });
  // "(F1 for Help)" sits inside the box's bottom-right corner on the three
  // shop menus (census_euro_recruit / census_euro_train).
  if (['recruit', 'purchase', 'train'].includes(G.euroMenu)) {
    const f1 = '(F1 for Help)';
    mf.draw(ctx, f1, b.x + b.w - 8 - mf.width(f1), b.y + b.h - 11, lut(0x5D));
  }
  // The adviser is drawn LAST so he sits on top of the box, centred on it,
  // dropped 4px so he overlaps the frame rather than floating clear of it.
  const [pw, ph] = frameSize(ADVISER_ECONOMIC, 0);
  if (pw && hasAdviser())
    sheetFrame(ctx, ADVISER_ECONOMIC, 0,
               Math.round(b.x + (b.w - pw) / 2), b.y - ph + ADVISER_DROP);
}

function openEuroMenu(k) {
  G.euroMenu = ['recruit', 'purchase', 'train'][k];
  G.euroRow = k;
  G.euroMenuRow = 0;
  G.euroMsg = '';
}
// Selling empties the hold of that good; buying fills it. Both need a ship at
// the dock -- there is nowhere else in Europe to put goods.
function sellFromShip(i, qty) {
  if (i < 0) return;
  const ship = activeShip();
  if (!ship) { G.euroMsg = 'No ships in port.'; return; }
  if (isBoycotted(i)) {
    // Interactive sell of a boycotted good = the @KISSUP back-tax dialog
    // (byte-verified: sell handler @0x415A6 -> lift dialog @0x415B5; amount
    // = sell_price x 500 @0x333AF; pay -> treasury-, king's fund+, bit
    // cleared @0x3340C..0x33423; can't afford -> not lifted @0x333DD, the
    // @KISSSORRY shortfall). Row 2 pays.
    const tax = bidPrice(i) * 500;
    askEvent('KISSUP', { STRING0: DATA.cargo[i].name,
                         STRING1: DATA.nations[G.nation].homeport,
                         NUMBER0: tax }, (choice) => {
      if (choice !== 1) return;
      if (G.gold < tax) { showEvent('KISSSORRY', { NUMBER0: G.gold }); return; }
      G.gold -= tax;
      G.kingsFund += tax;
      G.boycotts = G.boycotts.filter(g => g !== i);
    });
    return;
  }
  const have = holdQty(ship, i);
  if (!have) { G.euroMsg = `No ${DATA.cargo[i].name} aboard.`; return; }
  const finish = (qty) => {
    if (!qty) return;
    const net = sellGoods(i, qty);
    holdAdd(ship, i, -qty);
    G.euroMsg = `Sold ${qty} ${DATA.cargo[i].name} for ${net}$` +
                (G.tax ? ` (${G.tax}% tax)` : '');
  };
  // An explicit qty (the trade routes' automated stop) sells without asking;
  // the interactive path runs @HOWMUCH5 "sold (at N$) to %STRING2 (0-N)".
  if (qty !== undefined) { finish(Math.min(qty, have)); return; }
  askAmount('HOWMUCH5', { STRING0: DATA.cargo[i].name, NUMBER1: bidPrice(i),
                          STRING2: DATA.nations[G.nation].homeport },
            have, finish);
}
function buyToShip(i, qty) {
  if (i < 0) return;
  const ship = activeShip();
  if (!ship) { G.euroMsg = 'No ships in port.'; return; }
  // The transfer executor's space clamp (func_02A8EC, see colonyDrop): a
  // purchase never overfills the holds -- capacity*100 less what is aboard,
  // with the merge slot's headroom.
  const cap = Number((unit(ship.type) || {}).cargo) || 0;
  const slot = (ship.hold || []).find(h => h.good === i);
  const used = (ship.passengers || []).length + (ship.hold || []).length;
  const space = Math.max(0, cap - used) * 100 +
                (slot ? Math.max(0, 100 - slot.qty) : 0);
  if (space <= 0) { G.euroMsg = `The ${ship.type}'s holds are full.`; return; }
  qty = Math.min(qty, space);
  const paid = buyGoods(i, qty);
  if (!paid) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
  holdAdd(ship, i, qty);
  G.euroMsg = `Bought ${qty} ${DATA.cargo[i].name} for ${paid}$`;
}

// Committing a harbour context-menu row (@ARMOPTIONS / @EUROPESHIPOPTIONS).
function euroContextCommit(r) {
  G.euroMenu = null;
  const k = G.euroDockSel, e = G.dockUnits[k];
  switch (r.act) {
    case 'board': {
      const ship = activeShip();
      if (!ship) { G.euroMsg = 'No ships in port.'; return; }
      ship.passengers = ship.passengers || [];
      if (ship.passengers.length >= 6) { G.euroMsg = 'That ship is full.'; return; }
      G.dockUnits.splice(k, 1);
      // Boarding clears any "wait on the dock" hold.
      const board = (typeof e === 'object' && e.noBoard) ? { ...e, noBoard: false } : e;
      ship.passengers.push(board);
      G.euroMsg = `${entryName(e)} boards the ${ship.type}.`;
      return;
    }
    case 'noboard': {
      const held = typeof e === 'object' ? { ...e, noBoard: true }
                 : { name: e, type: entryType(e), noBoard: true };
      G.dockUnits[k] = held;
      G.euroMsg = `${entryName(e)} will wait on the dock.`;
      return;
    }
    case 'front':
      G.dockUnits.splice(k, 1);
      G.dockUnits.unshift(e);
      return;
    case 'arm': {
      const v = r.verb;
      if (v.buy) {
        if (r.dim) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
        const paid = buyGoods(v.good, v.qty);
        if (!paid) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
        G.euroMsg = `${entryName(e)} equipped (${paid}$).`;
      } else {
        const net = sellGoods(v.good, v.qty);
        G.euroMsg = `Equipment sold for ${net}$.`;
      }
      G.dockUnits[k] = { name: entryName(e), type: r.to };
      return;
    }
    case 'bless':
      G.dockUnits[k] = { name: entryName(e), type: 'Missionaries' };
      G.euroMsg = `${entryName(e)} blessed as a Missionary.`;
      return;
    case 'unbless':
      G.dockUnits[k] = { name: entryName(e), type: 'Colonists' };
      G.euroMsg = 'Missionary status cancelled.';
      return;
    case 'shipfront': {
      const ship = activeShip();
      if (!ship) return;
      G.europe.splice(G.europe.indexOf(ship), 1);
      G.europe.unshift(ship);
      G.euroShip = 0;
      return;
    }
    case 'sail': {
      const ship = activeShip();
      if (ship) confirmSailAway(ship);
      return;
    }
    case 'sellall': {
      const ship = activeShip();
      if (!ship) return;
      for (const h of (ship.hold || []).slice()) sellFromShip(h.good, h.qty);
      return;
    }
    default:
      return;
  }
}

// Committing a sub-menu row.
function euroMenuCommit() {
  const rows = euroMenuRows();
  const r = rows[G.euroMenuRow];
  if (!r) return;
  // The "(None)" / "None" head row just closes the menu (census frames).
  if (r.none) { G.euroMenu = null; return; }
  if (G.euroMenu === 'dockunit' || G.euroMenu === 'ship') { euroContextCommit(r); return; }
  if (r.cost > G.gold) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
  G.gold -= r.cost;
  if (G.euroMenu === 'recruit') {
    // Recruits and trainees wait ON THE DOCK until a ship carries them over.
    // (Row 0 is the "(None)" head, so the dock slot is the row LESS ONE.)
    G.dockUnits.push(r.label);
    G.dock[G.euroMenuRow - 1] = rollImmigrant();
    G.euroMsg = `${r.label} recruited.`;
  } else if (G.euroMenu === 'train') {
    G.dockUnits.push(r.label);
    G.euroMsg = `${r.label} trained.`;
    // @PURCHASETAX: "use of Crown resources" (the Royal University) draws a
    // tax raise. The engine's trigger rate is unread -- a 1-in-3 roll and a
    // +1 raise are the port's flagged stand-ins.
    if (Math.floor(Math.random() * 3) === 0 && G.tax < 75) {
      G.tax += 1;
      showEvent('PURCHASETAX', { NUMBER0: 1, NUMBER1: G.tax });
    }
  } else {
    const buy = PURCHASE_CATALOG[G.euroMenuRow];
    // @REALLYBUY: "Purchase %STRING0 for %NUMBER0$?" -- Yes/No.
    askEvent('REALLYBUY', { STRING0: buy.unit, NUMBER0: purchasePrice(buy) },
             (k) => {
      if (k !== 0) return;
      if (buy.escalates) G.artilleryBought += 1;
      if (unit(buy.unit).hull > 0) {
        // A purchased ship joins the fleet at the dock, empty.
        G.europe.push({ type: buy.unit, icon: unit(buy.unit).icon,
                        hold: [], passengers: [], state: 'port' });
        G.euroShip = shipsInPort().length - 1;
      } else {
        G.dockUnits.push(buy.unit);
      }
      G.euroMsg = `${buy.unit} purchased.`;
    });
  }
  G.euroMenu = null;
}

// ------------------------------------------------------------ natives
// §19. Each tribe carries a tension meter toward the player, 0..100: **75 and
// above is hostile, 100 is war**, and the village-entry code swaps "Trade With
// Village" for "Enter Hostile Village" at 75. Every change goes through
// adjust_tension, which clamps to 0..100 and HALVES every positive (angering)
// delta for France and for anyone holding Pocahontas.
//
// Settlement seeding: the alarm seed is byte-cited as random_int(0,14) + 2d for
// the human (§18.11). The PLACEMENT itself (func_065D26, up to 84 settlements
// from the map seed) is not in the evidence here, so villages are scattered on
// land by a deterministic hash -- flagged in docs/UI_AUDIT_TRACKER.md.
const TENSION_HOSTILE = 75, TENSION_WAR = 100;
// There are TWO parallel settlement bands in ICONS, both 21x16:
//   disk 0..3   -- European colonies. Every one carries a blue PENNANT, and
//                  they run bare logs (3), low fence (0), wooden palisade (1),
//                  stone walls (2): the stockade / fort / fortress progression.
//   disk 10..13 -- NATIVE settlements, no pennant: conical tipi camp (10),
//                  pueblo (11), stepped pyramid (12), terraced stone city (13).
//                  That is exactly @TRIBES.level 0..3 -- Apache/Sioux/Tupi are
//                  level 0 camps, Arawak/Iroquois/Cherokee 1, Aztec 2, Inca 3.
// Identified by rendering the whole sheet as a grid; the level -> frame order
// follows the art's own progression.
// BYTE-CITED (2026-08-07b): func_004314 counts the colony's fortifications
// with verb 0x5EB:0x35E -- resident file 0x860E, a plain bitset membership
// test, bit id&7 of byte [colony*0xCA + (id>>3) + 0x5DCA] -- then maps the
// count with `mov ax,di; dec al; and ax,3` @0x43AE-0x43B5 and draws engine
// sprite di+1. Count 0 -> (0-1)&3 = 3 -> engine 4 -> bundle 3; count 1 -> 0
// -> bundle 0; and so on. That is exactly this table, indexed by tier.
const COLONY_FRAME = [3, 0, 1, 2];
// BYTE-CITED (2026-08-07b): the village painter's body blit is `min(level,3) +
// 0x0B; lcall 0xC56:4` @0x3E9D-0x3EB6, the level read from the tribe record's
// first byte ([bx+0x5AD8], stride 0x4E) via the village's tribe byte
// [0x54EE]-4. Engine 0x0B..0x0E = bundle 10..13, which is this base + level --
// the old by-eye identification, now anchored at the draw site.
const NATIVE_FRAME_BASE = 10;
const PENNANT_BASE = 118;
// A colony's own level: no stockade, Stockade, Fort, Fortress.
function colonyLevel(c) {
  if (c.buildings.includes('Fortress')) return 3;
  if (c.buildings.includes('Fort')) return 2;
  if (c.buildings.includes('Stockade')) return 1;
  return 0;
}
function drawSettlement(ctx, px, py, level, nation, tribeColour, mission) {
  const lv = Math.max(0, Math.min(3, level));
  const frame = nation >= 0 ? COLONY_FRAME[lv] : NATIVE_FRAME_BASE + lv;
  // The marker frames are 21x16 in a 16px tile, so they hang 2px off the left.
  // func_004314 @0x0043D2 sets D=0x10 and @0x0043D5-0x0043E5 anchors at
  // (X + D/2, Y + D - 1); the blit verb 0x0C56:0x0004 = file 0x00E964 turns an
  // anchor into a top-left with x -= w>>1 @0x00EA38 and y -= h, y += 1
  // @0x00EA45 -- for a 21x16 frame that is (X-2, Y). Written out rather than
  // left as a fractional (TILE-fw)/2 leaning on sheetFrame's rounding. (That
  // the engine's X equals the port's tile origin px is NOT independently
  // established -- func_067182 is unread. The pennant below does not depend on
  // it: (5,0) is a marker-relative delta.)
  sheetFrame(ctx, 'ICONS', frame, px - 2, py);
  if (nation >= 0) {
    // The nation pennant goes ON THE FLAGPOLE, not beside it. ICONS colony
    // frames 0-3 ship with FRANCE'S BLUE PENNANT BAKED INTO THEIR PIXELS at
    // frame-local (5,0) -- sliding frame 119 over each of frames 0/1/2/3 finds
    // exactly one offset where all 15 of its opaque pixels match, (5,0), on all
    // four levels. The engine's blit lands there and overwrites it, so exactly
    // one flag is ever visible. The port was anchoring to the tile's right edge
    // (px+9, py+1) = frame-local (11,1), which left the baked blue standing and
    // stamped a second flag beside it: France looked right by coincidence and
    // every other power flew two flags.
    //
    // (px+3, py) is the same point reached from the bytes: func_004314 @0x0043FB
    // (X+6 -> [bp-0x0a]) and @0x004404-0x004409 + @0x00441A (Y+4 -> [bp-0x0c])
    // on the si==0x64 100%-scale branch, through the same anchor->top-left
    // conversion as above: (X+6-3, Y+4-4) = (X+3, Y).
    //
    // Frames 118-121 are red/blue/yellow/orange = England/France/Spain/
    // Netherlands, so PENNANT_BASE + nation was already right; only the
    // placement was wrong. Frames 0-3 encode LEVEL, not nation
    // (func_004314 @0x004455 `add cx,0x77` applies to the pennant alone), so
    // per-nation marker frames are not the answer.
    sheetFrame(ctx, 'ICONS', PENNANT_BASE + nation, px + 3, py);
  } else {
    // UNCITED -- port-invented art. No engine equivalent: nothing in the
    // village painter draws an ownership patch, and the native marker frames
    // 10-13 carry no baked pennant (the same slide test finds no match at any
    // offset). The engine's real per-village overlays are the alarm marks and
    // the mission cross, both rect primitives.
    ctx.fillStyle = ink(0); ctx.fillRect(px + TILE - 8, py, 8, 7);
    ctx.fillStyle = ink(tribeColour); ctx.fillRect(px + TILE - 7, py + 1, 6, 5);
  }
  // §19.7: a village carrying a mission is marked with a CROSS in the founding
  // power's colour. The SHAPE and the Y offsets are byte-read off the village
  // painter, func_0041AD-func_00423C, all relative to a base XB = [bp-2]:
  //   backing rect (XB,   py+5, 5, 6)  colour 0   @0x0041D7
  //   vertical bar (XB+2, py+6, 1, 4)             @0x004203
  //   horizontal   (XB+1, py+7, 3, 1)             @0x004222
  if (mission) {
    // XB: the engine's base is px+6 (@0x00407D `mov ax,[bp-0x64]; add ax,6`),
    // stepped +2 per alarm mark plus a final +2 after the mark loop
    // (@0x419F/@0x41A9) -- so px+6 with no marks, px+8+2*marks with them. The
    // port draws its alarm strip elsewhere, so px+6 is the matching case.
    const XB = px + 6;
    // Colours RESOLVED (2026-08-07b): DGROUP:0x848 dumps as 0C 09 0E 0D = the
    // four @COUNTRY colours (England 12, France 9, Spain 14, Netherlands 13),
    // and @0x41C6-0x41D4 (`sbb al,al; and al,0xF8; add al,[bx+0x848]`) SUBTRACTS
    // 8 when the mission byte's 0x10 bit is clear. So an expert (Brebeuf)
    // mission draws the bright nation colour and an ordinary one draws
    // colour-8, the dim half of the same ramp. DATA.nations[].color IS that
    // table, checked value for value.
    const base = DATA.nations[mission.power] ? DATA.nations[mission.power].color : 0x0F;
    ctx.fillStyle = ink(0);
    ctx.fillRect(XB, py + 5, 5, 6);
    ctx.fillStyle = ink(mission.expert ? base : base - 8);
    ctx.fillRect(XB + 2, py + 6, 1, 4);
    ctx.fillRect(XB + 1, py + 7, 3, 1);
  }
}
// The engine keeps TWO parallel anger meters, and they are not the same scale:
//   * the per-(settlement, power) TENSION word at DGROUP 0x5B1C, range 0..100,
//     hostile at 75 and war at 100 -- the one the village-entry menu reads;
//   * the per-(settlement, power) ALARM word at DGROUP 0x54F6, which arms RAIDS
//     at 128 (byte-verified: the raid-target scan @0x04734E and the two
//     colony-placement gates @0x04CAD7 / @0x053D4E all test `cmp [..+0x54F6],0x80`).
// Only the applier's own tail (neighbour propagation, clamps to 0x20/0x60) is
// traced for the alarm word; what drives it up in the first place is NOT in the
// evidence. So the port runs the alarm word off the SAME delta ledger as the
// tension meter, on the 0..255 scale -- the port's own coupling, flagged in
// docs/UI_AUDIT_TRACKER.md, not a byte-verified rule. The two thresholds
// themselves (75/100 and 128) are byte-verified and are used as such.
const ALARM_RAID = 0x80;
// The F9 band thresholds as an index, shared with the @PISS* announcements.
function tensionBandIdx(n) {
  return n >= TENSION_WAR ? 4 : n >= TENSION_HOSTILE ? 3
       : n >= 40 ? 2 : n >= 20 ? 1 : 0;
}
// @PISS0-5: "the {tribe} tribe is now %STRING2 {%STRING3}" -- STRING3 is the
// @ATTITUDE band word, STRING2 an @ATTITUDINAL modifier. The engine's
// modifier pick and its announce trigger are unread: the port announces on
// an UPWARD band crossing, modifier by depth into the band, flagged. The
// cause code (1 roads, 2 forest, 3 missionaries, 4 attack, 5 population)
// is passed by the caller that knows it; 0 is the generic body.
function adjustTension(tribe, delta, cause) {
  const t = G.tribes[tribe];
  if (!t) return;
  // France, and Pocahontas, halve anger.
  if (delta > 0 && (G.nation === 1 || G.fathersOwned.includes('Pocahontas')))
    delta = Math.floor(delta / 2);
  const before = tensionBandIdx(t.tension);
  t.tension = Math.max(0, Math.min(TENSION_WAR, t.tension + delta));
  const after = tensionBandIdx(t.tension);
  // @INDIANWAR: reaching the War band is the tribe's own declaration
  // ("your crimes cry out for vengeance"); @INDIANPEACE marks the climb
  // back down from it (the peace pipe). Both replace the generic @PISS
  // band message at those two edges; every other crossing keeps @PISS.
  if (after === 4 && before < 4) {
    G.eventTribe = tribe;
    showEvent('INDIANWAR', { STRING0: t.name });
  } else if (before === 4 && after < 4) {
    G.eventTribe = tribe;
    showEvent('INDIANPEACE', { STRING0: t.name,
                               STRING1: DATA.nations[G.nation].adjective });
  } else if (after > before && DATA.attitudinal) {
    const spans = [[0, 20], [20, 40], [40, 75], [75, 100], [100, 101]];
    const [lo, hi] = spans[after];
    const depth = Math.min(4, Math.floor((t.tension - lo) * 5 / (hi - lo)));
    G.eventTribe = tribe;
    showEvent(`PISS${cause || 0}`, {
      STRING0: DATA.nations[G.nation].adjective, STRING1: t.name,
      STRING2: DATA.attitudinal[4 - depth].toLowerCase(),
      STRING3: (DATA.attitude[after] || '').toLowerCase() });
  }
  for (const v of G.villages)
    if (v.tribe === tribe) v.alarm = Math.max(0, Math.min(255, (v.alarm || 0) + delta));
}
// Settlement placement is NOT procedural: TRIBE.TXT ships the exact site list,
// one @<TRIBE> section per tribe with "x,y" per line -- 59 sites across the
// eight playable tribes. Its x coordinates sit TWO columns left of the stored
// map plane: testing every offset in dx -1..+3, dy -2..+2 against AMER2.MP,
// dx=+2 puts 0 of 59 sites in water where the next best leaves 7. A clean sweep
// over 59 independent points settles it. (The MP format notes a leading plane
// column, so an origin shift of this kind is expected; the exact derivation of
// 2 is not in the evidence.) Tribes are matched by @TRIBES' `singular` column,
// which is what TRIBE.TXT's section names are.
const TRIBE_SITE_DX = 2, TRIBE_SITE_DY = 0;
function seedNatives() {
  G.tribes = DATA.tribes.map(t => ({
    name: t.name, singular: t.singular, level: t.level, color: t.color,
    tension: Math.floor(Math.random() * 15) + 2 * G.difficulty,
  }));
  G.villages = [];
  G.natives = [];
  G.tribes.forEach((t, ti) => {
    const sites = DATA.tribesites[t.singular.toUpperCase()] || [];
    // Placement is the BYTE MODEL of func_065D26's TRIBE.TXT mode
    // (@0x660C4..@0x66246, read 2026-08-29): each file site scatters by a
    // TRIANGULAR +-2 jitter (random_int(-1,1) + random_int(-1,1) per
    // axis), retried up to 100 times against: passable tile, improve
    // bits & 3 clear, terrain < 0x18 with (id & 7) not Desert(1) and not
    // Swamp(7) (@0x6618B..@0x661A3), and a nearest-settlement distance
    // over 3 (tries < 0x21), 2 (< 0x42), then 1 (@0x661BB..@0x661E4).
    // The FIRST placed site is the capital (flags |= 4, @0x66222) --
    // byte-confirmed, no longer flagged. TRIBE_SITE_DX/DY stays the
    // port's coordinate calibration, flagged as before.
    let placedFirst = false;
    sites.forEach(([sx, sy]) => {
      const bx = sx + TRIBE_SITE_DX, by = sy + TRIBE_SITE_DY;
      let px = -1, py = -1;
      for (let tries = 1; tries <= 100; tries++) {
        const dx = (Math.floor(Math.random() * 3) - 1) +
                   (Math.floor(Math.random() * 3) - 1);
        const dy = (Math.floor(Math.random() * 3) - 1) +
                   (Math.floor(Math.random() * 3) - 1);
        const x = bx + dx, y = by + dy;
        if (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) continue;
        const tv = at(x, y), tt = tileTerrain(tv);
        if (tileWater(tv) || tt >= 0x18) continue;
        if ((tt & 7) === 1 || (tt & 7) === 7) continue;   // Desert, Swamp
        if (impAt(x, y) & 3) continue;
        const need = tries < 0x21 ? 3 : tries < 0x42 ? 2 : 1;
        const nearD = G.villages.reduce((m, w) =>
          Math.min(m, Math.max(Math.abs(w.x - x), Math.abs(w.y - y))), 99);
        if (nearD <= need) continue;
        px = x; py = y;
        break;
      }
      if (px < 0) return;                    // 100 tries exhausted: skip
      // mission: null, or {power, expert} -- settlement +0x05.
      // Starting population is not in the evidence -- villages open at
      // their target size (func_046DE0: 2*level+3, capital 3*level+4).
      const v = { x: px, y: py, tribe: ti, name: t.name, level: t.level,
                  alarm: t.tension, mission: null, tributePaid: false,
                  capital: !placedFirst, growth: 0, taught: false,
                  chiefSeen: false, braveOwed: false, pop: 1 };
      placedFirst = true;
      v.pop = settlementCap(v);
      G.villages.push(v);
      // HOMELAND CLAIM: settlement creation writes the tribe into the
      // plane-3 owner nibble via the claim writer func_005E18
      // ((byte & 0xF) | owner<<4, @0x5E7E..@0x5E8B; the create path
      // calls it on the village tile @0x46E9E). The RADIUS is the
      // engine's own getter func_00822A: 1/1/2/3 by TRIBE TECH
      // (byte-read 2026-08-30; the manual's "1/2" was short). First
      // claim wins, FLAGGED. This keeps rumour medallions off native
      // country: the
      // marker predicate needs an UNCLAIMED nibble (func_006188 @0x61BC).
      {
        const rad = [1, 1, 2, 3][(t.level || 0) & 3];   // func_00822A
        for (let cy = py - rad; cy <= py + rad; cy++)
          for (let cx = px - rad; cx <= px + rad; cx++) {
            if (cx < 0 || cy < 0 || cx >= MAP.w || cy >= MAP.h) continue;
            const mi = cy * MAP.w + cx;
            if (RESOURCE[mi] !== 0x0F) continue;
            RESOURCE[mi] = ti + 4;
          }
      }
    });
  });
  // §19.11: map creation spawns exactly ONE brave per village, linked to it;
  // a village only builds another when its own dies. Done in a second pass so a
  // brave never lands on a site that has not been placed yet.
  for (const v of G.villages) spawnBrave(v);
}

// §19.5 -- what a village wants. The engine's village_supply_demand is a
// three-phase model (claimed-tile mask, 5x5 terrain scan, tribe-level
// formulas); this reads the same 5x5 neighbourhood for the raw goods the land
// yields, then applies the two cited headline behaviours: a CAPITAL doubles
// demand for raw goods (x1.5 for tools/muskets/trade goods) and doubles its
// supply of manufactures. The exact phase-1/3 formulas are not reproduced, so
// this is PARTIAL and flagged in the tracker.
const RAW_GOODS = [0, 1, 2, 3, 4, 5, 6, 7];        // Food..Silver
const MANUFACTURES = [9, 10, 11, 12];              // Rum, Cigars, Cloth, Coats
function villageDemand(v) {
  if (v.demand) return v.demand;
  const d = DATA.cargo.map(() => 0);
  for (let dy = -2; dy <= 2; dy++)
    for (let dx = -2; dx <= 2; dx++) {
      const tv = at(v.x + dx, v.y + dy);
      if (tileWater(tv)) continue;
      for (let j = 0; j < 9; j++) d[j] += tileYield(tv, j);
    }
  const capital = v.level >= 2;
  for (const g of RAW_GOODS) d[g] = Math.floor(d[g] * (capital ? 2 : 1));
  for (const g of [13, 14, 15]) d[g] = Math.floor((d[g] + 4) * (capital ? 1.5 : 1));
  for (const g of MANUFACTURES) d[g] = Math.max(d[g], capital ? 8 : 4);
  v.demand = d;
  return d;
}
// func_008262 (0x181f:0xa60): the attitude band the haggle prices off --
// tension <25 -> 0, <50 -> 1, <75 -> 2, else 3. BYTE_VERIFIED.
function attBand(tension) {
  return tension >= 75 ? 3 : tension >= 50 ? 2 : tension >= 25 ? 1 : 0;
}
// The sell quote -- the BYTE MODEL of func_049600 @0x4999C..@0x49B02
// (tail read 2026-08-29; §19.5's reconstruction corrected against it):
//   mood = random_int(1,5)                                   @0x4999C
//   base = 6, or 7 for goods 9..15                           @0x499AB
//     Trade Goods (13): -random_int(0,7)                     @0x499C3
//     Muskets (15): +12 - tribe muskets counter (+0x07)      @0x499D9
//     Horses (8):   +10 - tribe horses counter (+0x08)       @0x499F0
//     Tools (14):   +1                                       @0x49A05
//   att = 2 x attBand(tension), 0 for muskets/horses, HALVED
//     when the good's want >= 20                             @0x49A0A..@0x49A3B
//   seed = 2*(base - difficulty - att + mood + 4)            @0x49A42
//   offer = max(1, (max(0, seed*want) + 5*mood)*qty/100 / 2) @0x49A5C..@0x49A93
// want is func_048F34's per-good want table [0x9E58+g*2]; the port's
// villageDemand() terrain scan stands in for that builder (flagged).
// (The old §19.5 guesses -- Furs -rand8, Trade Goods +1, the want term
// inside the seed -- are corrected: the -rand belongs to Trade Goods,
// the +1 to Tools, and the seed subtracts the ATTITUDE, not the want.)
function sellQuote(v, good, qty) {
  const t = G.tribes[v.tribe] || {};
  const want = villageDemand(v)[good] || 0;
  const mood = 1 + Math.floor(Math.random() * 5);
  let base = good >= 9 ? 7 : 6;
  if (good === 13) base -= Math.floor(Math.random() * 8);            // Trade Goods
  if (good === 15) base += 12 - (t.musketsKnown || 0);               // Muskets
  if (good === 8) base += 10 - (t.horsesKnown || 0);                 // Horses
  if (good === 14) base += 1;                                        // Tools
  let att = 2 * attBand(t.tension || 0);
  if (good === 15 || good === 8) att = 0;
  if (want >= 20) att >>= 1;
  const seed = 2 * (base - G.difficulty - att + mood + 4);
  const offer = Math.max(1,
    Math.floor(Math.floor((Math.max(0, seed * want) + 5 * mood) * qty / 100) / 2));
  return { offer, want, att, mood };
}
function villageOffer(v, good, qty) { return sellQuote(v, good, qty).offer; }
// Selling cools the village directly -- alarm drops by the quantity and a full
// 100-load zeroes it -- and muskets or horses ARM the tribe: +1 lore at 25
// units, +2 at 50, with horses also adding a quarter of the load to the herd.
// A -4 tension credit rides along.
function villageSell(v, good, qty, price, tensionCredit) {
  const t = G.tribes[v.tribe];
  // The haggle loop passes the negotiated price; a bare call takes the quote.
  const paid = price !== undefined ? price : villageOffer(v, good, qty);
  G.gold += paid;
  // the goods land in the TRIBE's stock words (TribeRecord +0x0E..+0x2D,
  // @0x49BAC) -- there is no per-village store.
  t.stock = t.stock || DATA.cargo.map(() => 0);
  t.stock[good] += qty;
  // TWO separate credits, and they land on the two separate meters:
  //   * the TRIBE's tension credit: the haggle loop passes its own byte
  //     amount (-2 x remaining budget on a sale @0x49BD0, -4 x (budget+1)
  //     on a gift @0x49E8D); a bare call keeps the flat -4 (@0x5C41E, the
  //     non-haggle path);
  //   * the VILLAGE's alarm word drops by the QUANTITY sold, and a full
  //     100-load zeroes it outright (@0x49BE4..@0x49BF8).
  v.alarm = qty >= 100 ? 0 : Math.max(0, (v.alarm || 0) - qty);
  adjustTension(v.tribe, tensionCredit !== undefined ? tensionCredit : -4);
  if (good === 15) t.musketsKnown = (t.musketsKnown || 0) + (qty >= 50 ? 2 : qty >= 25 ? 1 : 0);
  if (good === 8) {
    t.horsesKnown = (t.horsesKnown || 0) + (qty >= 50 ? 2 : qty >= 25 ? 1 : 0);
    t.herd = (t.herd || 0) + Math.floor(qty / 4);
  }
  return paid;
}
// The buy ask -- the BYTE MODEL (@0x4A025..@0x4A0E1, read 2026-08-29):
//   ask = 200; goods >= 8: (8 - tribe tech byte +0x02) * 50 REPLACES it
//   goods >= 7 (silver up): += goods-value[0x84BC+p*16+g] * (15 + 2*diff)
//     (the port's market level stands in for the value table, flagged)
//   += random_int(0, ask); -= 4 * the good's DEMAND entry ([0x9E78]);
//   += 4 * tension; ask = qty*ask/100; += (random_int(0,2)+diff)*10;
//   floor 50 (applied once, at the end).
function villageAsk(v, good, qty) {
  const t = G.tribes[v.tribe];
  let ask = good >= 8 ? (8 - t.level) * 50 : 200;
  if (good >= 7) ask += G.market[good] * (2 * G.difficulty + 15);
  ask += Math.floor(Math.random() * (ask + 1));
  ask -= 4 * (villageDemand(v)[good] || 0);
  ask += 4 * (t.tension || 0);
  ask = Math.floor(qty * ask / 100);
  ask += (G.difficulty + Math.floor(Math.random() * 3)) * 10;
  return Math.max(50, ask);
}
// What the village will part with: the goods its land yields a surplus of.
function villageSurplus(v) {
  const d = villageDemand(v);
  return d.map((n, i) => ({ good: i, qty: Math.min(100, n * 5) }))
          .filter(r => r.qty >= 25 && RAW_GOODS.includes(r.good))
          .slice(0, 3);
}
function villageBuy(v, good, qty, price) {
  const t = G.tribes[v.tribe] || {};
  if (price === undefined) price = villageAsk(v, good, qty);
  if (price > G.gold) return 0;
  G.gold -= price;
  t.stock = t.stock || DATA.cargo.map(() => 0);
  t.stock[good] = Math.max(0, (t.stock[good] || 0) - qty);
  // (No tension credit here: the byte-cited -4 trade credit @0x5C41E is the
  // SELL side's; the -2 this used to apply was the port's invention.)
  return price;
}

// A gift cools anger faster than a sale (manual-attested; the exact credit is
// untraced, so the port uses twice the sale credit and says so).
// A gift (@0x49E4C): the tension credit is the haggle loop's
// -4 x (budget+1) (@0x49E8D; -8 stands for a bare call), the village
// alarm drops DOUBLE the quantity (100-load zeroes, @0x49EAC..@0x49ED0),
// and muskets/horses arm the tribe exactly as a sale does (@0x49ED5..).
function villageGift(v, good, qty, credit) {
  const t = G.tribes[v.tribe] || {};
  t.stock = t.stock || DATA.cargo.map(() => 0);
  t.stock[good] += qty;
  v.alarm = qty >= 100 ? 0 : Math.max(0, (v.alarm || 0) - 2 * qty);
  adjustTension(v.tribe, credit !== undefined ? credit : -8);
  if (good === 15) t.musketsKnown = (t.musketsKnown || 0) + 1;
  if (good === 8) {
    t.herd = (t.herd || 0) + Math.floor(qty / 4);
    t.horsesKnown = (t.horsesKnown || 0) + 1;   /* @0x49EFA -> @0x49C66 */
  }
}

// ------------------------------------------------- missions and conversion
// §19.7. Establish Mission is @ACTIONS row 2, offered to a MISSIONARY standing
// in a village that carries no mission (settlement +0x05 < 0). Founding writes
// the power into that byte, with bit 0x10 -- the EXPERT bit -- set when the
// founder holds Jean de Brebeuf (`or [bx+5],0x10` @0x48C81, gated on
// has_father(0x16) @0x48C71; FF row 0x16 = Brebeuf). Acquiring Brebeuf later
// upgrades every mission you already own (@0x3BE77).
//
// Founding also applies a NEGATIVE tension delta (@0x571EB) whose magnitude is
// the one residual the applier study never resolved -- what IS byte-verified is
// the clamp: the delta is trimmed so the resulting meter lands at 70 or below
// (`cmp ax,0x46; jg` @0x571DA). The port applies exactly that clamp and nothing
// more, so no invented magnitude enters the model.
const MISSION_ANGER_CAP = 0x46;          // 70
function missionBand(v) {
  // Which of @MISSION0..3 the founding announcement uses. The engine bands the
  // settlement's colonial-presence score at -5 / 0 / 10 into Content / Uneasy /
  // Restless / Angry (@0x048B62..0x048B90, byte-verified cutoffs); the score's
  // own composition is multi-term and NOT decomposed, so the port bands the
  // tension meter it does keep. Flagged in docs/UI_AUDIT_TRACKER.md.
  const t = G.tribes[v.tribe];
  const n = t ? t.tension : 0;
  return n >= TENSION_HOSTILE ? 3 : n >= 40 ? 2 : n >= 20 ? 1 : 0;
}
function establishMission(v, u) {
  const band = missionBand(v);
  v.mission = { power: G.nation, expert: G.fathersOwned.includes('Jean de Brebeuf') };
  const t = G.tribes[v.tribe];
  if (t && t.tension > MISSION_ANGER_CAP) {
    adjustTension(v.tribe, MISSION_ANGER_CAP - t.tension);
  }
  // The missionary is spent into the mission -- it leaves the map.
  const k = G.units.indexOf(u);
  if (k >= 0) { G.units.splice(k, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
  showEvent(`MISSION${band}`, {
    STRING0: DATA.missionpre[G.nation],
    STRING1: t ? t.singular : '',
    STRING2: `${t ? t.name : ''} ${DATA.levelname[v.level]}`,
    STRING3: t ? t.name : '',
    NUMBER0: G.year,
  });
}
// @ACTIONS row 3. Two endings, @HERESY0 (you win the flock and the mission
// changes hands) and @HERESY1 (your missionary burns at the stake). The
// win/lose roll is UNTRACED -- the manual says so and ties it only loosely to
// the two powers' standing with the tribe. The port uses a fair coin rather
// than inventing a weighting, and says so here and in the tracker. Either way
// the missionary is spent: it founds the new mission or it dies.
function denounceHeresy(v, u) {
  const t = G.tribes[v.tribe];
  const rival = v.mission.power;
  const win = Math.random() < 0.5;
  const k = G.units.indexOf(u);
  if (k >= 0) { G.units.splice(k, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
  if (win) v.mission = { power: G.nation, expert: G.fathersOwned.includes('Jean de Brebeuf') };
  showEvent(win ? 'HERESY0' : 'HERESY1', {
    STRING0: DATA.nations[G.nation].adjective,
    STRING1: DATA.nations[rival] ? DATA.nations[rival].adjective : 'foreign',
    STRING2: t ? t.name : '',
  });
}

// The conversion roll, byte-verified (func_0572E6 @0x572E6):
//   threshold = TribeData[+2] + 2         -- the @TRIBES level column
//   threshold *= 2  when the mission carries the expert bit (Brebeuf)
//   roll = random_int(0, 15)              -- bound 0x0F @0x5730A
//   convert fires when roll < threshold   -- fails on roll >= threshold @0x57316
// On success a unit is created at the colony and stamped class 0x1B, the Indian
// Convert (@JOB row 27) -- the half-rate worker with the +1 staple bonus.
// WHEN the roll fires ("each eligible turn") is untraced; the port rolls once
// per mission per turn. Flagged in docs/UI_AUDIT_TRACKER.md.
const CONVERT_CLASS = 'Indian Converts';
function conversionThreshold(v) {
  const t = G.tribes[v.tribe];
  let th = (t ? t.level : 0) + 2;
  if (v.mission && v.mission.expert) th *= 2;
  return th;
}
function attemptConversions() {
  for (const v of G.villages) {
    G.eventTribe = v.tribe;
    if (!v.mission || v.mission.power !== G.nation) continue;
    if (!G.colonies.length) continue;
    // Convert headroom: settled converts never age (the byte model), so a
    // mission-heavy game floods the pool without a bound. Both engines
    // stop converting at 100 LIVING CONVERTS -- a shared port capacity
    // limit, not a byte claim (the DOS pool is finite too, size unread --
    // FLAGGED). The count is over the player's own unit list, a
    // digest-compared quantity, so the two engines agree exactly; checked
    // BEFORE the roll to keep the RNG stream lockstep.
    if (G.units.filter(u => u.profession === CONVERT_CLASS).length >= 100)
      continue;
    if (Math.floor(Math.random() * 16) >= conversionThreshold(v)) continue;
    // "created at the colony" -- the handler is passed a ColonyRecord's map_x /
    // map_y / owner, so the convert appears on a colony tile. The port picks the
    // colony nearest the village.
    const c = G.colonies.slice().sort((a, b) =>
      (Math.abs(a.x - v.x) + Math.abs(a.y - v.y)) - (Math.abs(b.x - v.x) + Math.abs(b.y - v.y)))[0];
    const u = mkUnit('Colonists', c.x, c.y);
    u.profession = CONVERT_CLASS;
    G.units.push(u);
    showEvent('INDIANSCONVERT', { STRING0: c.name });
    tutOnce(19);
  }
}
// @DEADCONVERTS -- BYTE_VERIFIED func_02EF64 (0x191F:0xA58, read
// 2026-08-29), replacing the port's unconditional 8-turn countdown: a
// CONVERT unit (type 0 Colonists with profession 0x1B, @0x2EF99/@0x2EFA3)
// ticks its +0x16 counter only while he is ON the map (@0x2EF86), NOT
// standing on a settlement tile (village-or-colony lookup 0x181F:0x6BE ->
// func_005FD4, improve bit 2, @0x2EFB5) and ALONE (his tile stack counts
// fewer than 2 via the chain walker func_0073A8 verb 2, @0x2EFC9) -- an
// escorted or parked convert keeps his faith. Past 8 qualifying turns
// (@0x2EFDA, the text's own "eight turns") he is eliminated (@0x2F00B)
// with @DEADCONVERTS per convert and a view-center for the human owner
// (@0x2F000). The counter is the SAV's own +0x16 field, so the timer
// survives a save.
function ageConverts() {
  for (let i = G.units.length - 1; i >= 0; i--) {
    const u = G.units[i];
    if (u.profession !== CONVERT_CLASS || u.type !== 'Colonists') continue;
    if (colonyAt(u.x, u.y) ||
        G.villages.some(v => v.x === u.x && v.y === u.y)) continue;
    if (G.units.filter(q => q.x === u.x && q.y === u.y).length >= 2) continue;
    u.work = (u.work || 0) + 1;
    if (u.work <= 8) continue;
    G.units.splice(i, 1);
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
    showEvent('DEADCONVERTS', {});
  }
}

// --------------------------------------------- what the natives demand of you
// §19.8. War-footing tribes press claims, and the land/road objections carry a
// BUY-OFF row: pay the named compensation and the tribe withdraws it. Peter
// Minuit in Congress zeroes every land payment.
//   @INDIANWAGONS the contents of a wagon train passing through their land
//   @INDIANCITY   goods from a colony's stores
//   @INDIANROAD   an objection to a road, with its compensation row
// (@INDIANGOLD is DEAD GAME.TXT content -- zero hits in VICEROY.EXE, like
// @KINGMERCY -- and is gone.) The claim CONTENT is the byte model of the
// native-meeting handler (0x5755C..0x57A15, 2026-08-29); the TRIGGER
// cadence (the engine's brave-adjacency meeting) stays the port's flagged
// per-turn roll.
function nativeDemands() {
  if (!G.colonies.length) return;
  for (const t of G.tribes) {
    if (!t || t.dead) continue;
    G.eventTribe = G.tribes.indexOf(t);
    // The FRIENDLY half (Content band): gifts, begging and the two flavour
    // notices. Triggers and amounts are NOT traced -- same flagged model as
    // the hostile claims below (rare roll, a colony near their country).
    if ((t.tension || 0) < 20) {
      if (Math.floor(Math.random() * 24) !== 0) continue;
      const ti2 = G.tribes.indexOf(t);
      const nearC = G.colonies.find(cc => G.villages.some(v =>
        v.tribe === ti2 && Math.abs(v.x - cc.x) <= 3 && Math.abs(v.y - cc.y) <= 3));
      if (!nearC) continue;
      const roll = Math.floor(Math.random() * 5);
      if (roll === 0 && nearC.stock[GOOD.FOOD] < 100) {
        // @INDIANGIVEFOOD -- the plentiful-harvest gift (amount flagged).
        const gift = 20 + Math.floor(Math.random() * 30);
        nearC.stock[GOOD.FOOD] += gift;
        showEvent('INDIANGIVEFOOD', { STRING0: t.name, NUMBER0: gift });
      } else if (roll === 1) {
        // @INDIANGIVESTUFF -- a raw-goods gift (good + amount flagged).
        const g = RAW_GOODS[Math.floor(Math.random() * RAW_GOODS.length)];
        const gift = 10 + Math.floor(Math.random() * 20);
        nearC.stock[g] += gift;
        showEvent('INDIANGIVESTUFF', { STRING0: t.name, STRING1: nearC.name,
                                       NUMBER0: gift, STRING2: DATA.cargo[g].name });
      } else if (roll === 2 && nearC.stock[GOOD.FOOD] >= 40) {
        // @INDIANBEGFOOD -- rows: refuse / share half (the offered split is
        // the port's reading of NUMBER0-of-NUMBER1).
        const have = nearC.stock[GOOD.FOOD], offer = Math.floor(have / 2);
        askEvent('INDIANBEGFOOD', { STRING0: t.name, STRING1: nearC.name,
                                    NUMBER0: offer, NUMBER1: have }, (choice) => {
          if (choice === 1) { nearC.stock[GOOD.FOOD] -= offer; adjustTension(ti2, -8); }
          else adjustTension(ti2, 5);
        });
      } else if (roll === 3) {
        showEvent('INDIANCOMMENT', { STRING0: t.name,
                                     STRING1: DATA.nations[G.nation].adjective });
      } else {
        showEvent('INDIANCOME', { STRING0: t.name });
      }
      continue;
    }
    if ((t.tension || 0) < TENSION_HOSTILE) continue;
    if (Math.floor(Math.random() * 24) !== 0) continue;   // rare, per tribe, per turn
    const ti = G.tribes.indexOf(t);
    // @WANTSTUFF: the land-befouling reparations demand (rows: refuse /
    // share). Pressed when a colony sits in their country; the goods picked
    // are the colony's largest stock. USA suffix once independent.
    const wantC = G.colonies.find(cc => G.villages.some(v =>
      v.tribe === ti && Math.abs(v.x - cc.x) <= 3 && Math.abs(v.y - cc.y) <= 3));
    if (wantC && Math.random() < 0.4) {
      const top = wantC.stock.map((n, i) => [n, i]).filter(s => s[0] >= 10)
                       .sort((a, b) => b[0] - a[0])[0];
      if (top) {
        const qty = Math.min(top[0], 15 + 5 * G.difficulty);
        askEvent((G.flags & WOI_DECLARED) ? 'WANTSTUFFUSA' : 'WANTSTUFF',
                 { STRING0: t.name, NUMBER0: qty,
                   STRING1: DATA.cargo[top[1]].name, STRING2: t.name }, (k) => {
          if (k === 1) { wantC.stock[top[1]] -= qty; adjustTension(ti, -10); }
          else adjustTension(ti, 15, 5);
        });
        return;
      }
    }
    // @INDIANBURN: at war the tribe burns our missions (rare, flagged).
    if ((t.tension || 0) >= TENSION_WAR && Math.random() < 0.2) {
      const mv = G.villages.find(v => v.tribe === ti && v.mission &&
                                      v.mission.power === G.nation);
      if (mv) {
        mv.mission = null;
        showEvent('INDIANBURN', { STRING0: t.name,
                                  STRING1: DATA.nations[G.nation].adjective });
        return;
      }
    }
    // @RID: at the top of the War band the tribe orders the player out of
    // the region outright (a notice; the drive-them-into-the-sea raids are
    // the raid engine's job).
    if ((t.tension || 0) >= TENSION_WAR && Math.random() < 0.25) {
      showEvent('RID' + ((G.flags & WOI_DECLARED) ? 'USA' : ''),
                { STRING0: t.name, STRING1: DATA.regionname[G.nation] });
      return;
    }
    // The claim CONTENT is now the byte model of the native-meeting
    // demand handler (0x5755C..0x57A15, read 2026-08-29); the TRIGGER
    // cadence stays the port's flagged per-turn roll (the engine's is
    // the brave-adjacency meeting).
    const dv = G.villages.find(v => v.tribe === ti &&
      (G.colonies.some(cc => Math.abs(v.x - cc.x) <= 3 && Math.abs(v.y - cc.y) <= 3) ||
       G.units.some(u => u.type === 'Wagon Train' &&
                         Math.abs(v.x - u.x) <= 3 && Math.abs(v.y - u.y) <= 3)));
    // @INDIANWAGONS (@0x5787E..): the wagon's slots pressed one at a
    // time -- each surrender empties the slot, credits tension by
    // -bid*qty*4/100 and ZEROES the village alarm (@0x579B7..@0x579F9,
    // the loop re-enters for the next slot); a refusal spikes the
    // village alarm +128 (@0x57A0B) and ends the meeting.
    const wagon = G.units.find(u => u.type === 'Wagon Train' && (u.hold || []).some(h => h.qty > 0) &&
      G.villages.some(v => v.tribe === ti && Math.abs(v.x - u.x) <= 3 && Math.abs(v.y - u.y) <= 3));
    if (wagon) {
      const pressSlot = () => {
        const h = (wagon.hold || []).find(x => x.qty > 0);
        if (!h) return;
        askEvent('INDIANWAGONS', { STRING0: DATA.nations[G.nation].adjective,
                                   STRING1: t.name, STRING2: DATA.cargo[h.good].name,
                                   NUMBER0: h.qty }, (choice) => {
          if (choice === 0) {
            adjustTension(ti,
              -Math.floor(Math.max(0, G.market[h.good] - 1) * h.qty * 4 / 100));
            if (dv) dv.alarm = 0;
            holdAdd(wagon, h.good, -h.qty);
            pressSlot();                       // the engine's give-loop
          } else if (dv) dv.alarm = Math.min(255, (dv.alarm || 0) + 128);
        });
      };
      pressSlot();
      return;
    }
    // @INDIANCITY (@0x5755C..@0x577F7): the demanded good is the ARGMAX
    // of value x min(100, stock) over the colony's stores, value =
    // max(0, price level - 1) (the [0x84BC] bid table), horses valued
    // value - tribe horse counter + 10, muskets + random_int(1,4) -
    // tech + difficulty + 4. Nothing worth demanding -> @INDIANCOMMENT
    // and the village alarm clears (@0x5787A). The amount halves on a
    // random_int(0, difficulty+1) == 0 roll (@0x5762B..@0x57640).
    const c = G.colonies.find(cc => G.villages.some(v =>
      v.tribe === ti && Math.abs(v.x - cc.x) <= 3 && Math.abs(v.y - cc.y) <= 3)) ||
      G.colonies[0];
    let bestG = -1, bestScore = 0, bestQty = 0;
    for (let g = 0; g < 16; g++) {
      const qty = Math.min(100, c.stock[g] || 0);
      let val = Math.max(0, (G.market[g] || 0) - 1);
      if (g === 8) val = val - (t.horsesKnown || 0) + 10;
      if (g === 15)
        val += 1 + Math.floor(Math.random() * 4) - (t.level || 0) + G.difficulty + 4;
      const score = val * qty;
      if (score > bestScore) { bestScore = score; bestG = g; bestQty = qty; }
    }
    if (bestG < 0) {
      if (dv) dv.alarm = 0;
      showEvent('INDIANCOMMENT', { STRING0: t.name,
                                   STRING1: DATA.nations[G.nation].adjective });
      return;
    }
    let qty = bestQty;
    if (Math.floor(Math.random() * (G.difficulty + 2)) === 0) qty >>= 1;
    askEvent('INDIANCITY', { STRING0: DATA.nations[G.nation].adjective,
                             STRING1: t.name, STRING2: DATA.cargo[bestG].name,
                             STRING3: c.name, NUMBER0: qty }, (choice) => {
      if (choice === 1) {
        // the give path (@0x57740..@0x577F7): village alarm zeroed, the
        // tension credit -score*4/100 grown by -5 steps until the meter
        // lands at or under 70, the stores debited; muskets/horses ARM
        // the tribe (the engine upgrades the demanding brave -- no brave
        // rides the port's trigger, so the counter/herd halves stand in,
        // flagged).
        if (dv) dv.alarm = 0;
        let credit = -Math.floor(bestScore * 4 / 100);
        while ((t.tension || 0) + credit > 70) credit -= 5;
        adjustTension(ti, credit);
        c.stock[bestG] = Math.max(0, (c.stock[bestG] || 0) - qty);
        if (bestG === 15) t.musketsKnown = (t.musketsKnown || 0) + 1;
        if (bestG === 8) {
          t.herd = (t.herd || 0) + 50;
          t.horsesKnown = (t.horsesKnown || 0) + 1;
        }
      } else if (dv) dv.alarm = Math.min(255, (dv.alarm || 0) + 128);
    });
    return;
  }
}
// The forest objection (@INDIANFOREST), same 3-row shape as @INDIANROAD:
// stop / pay / cut anyway. Cloned gates (village within 2, tension >= 40,
// Peter Minuit zeroes the buy-off) -- the engine's own gates are unread,
// flagged like roadObjection's.
function clearObjection(u) {
  const near = G.villages.find(v => Math.abs(v.x - u.x) <= 2 && Math.abs(v.y - u.y) <= 2);
  if (!near) return false;
  G.eventTribe = near.tribe;
  const t = G.tribes[near.tribe];
  if (!t || (t.tension || 0) < 40) return false;
  const pay = G.fathersOwned.includes('Peter Minuit') ? 0 : demandValue(100);
  askEvent('INDIANFOREST', { STRING0: t.name, NUMBER1: pay }, (choice) => {
    if (choice === 0) { u.orders = 0; u.work = 0; return; }
    if (choice === 1) {
      if (G.gold >= pay) { G.gold -= pay; adjustTension(near.tribe, -5); }
      else { u.orders = 0; u.work = 0; G.msg = 'We cannot afford the compensation.'; }
      return;
    }
    adjustTension(near.tribe, 10, 2);   // @PISS2: destroying the forest
  });
  return true;
}
// A road cut through their land draws an objection with a buy-off. Peter Minuit
// zeroes the payment.
function roadObjection(u) {
  const near = G.villages.find(v => Math.abs(v.x - u.x) <= 2 && Math.abs(v.y - u.y) <= 2);
  if (near) G.eventTribe = near.tribe;
  if (!near) return false;
  const t = G.tribes[near.tribe];
  if (!t || (t.tension || 0) < 40) return false;
  const pay = G.fathersOwned.includes('Peter Minuit') ? 0 : demandValue(100);
  askEvent('INDIANROAD', { STRING0: t.name, NUMBER1: pay }, (choice) => {
    // Row 0 stops the work, row 1 pays, row 2 builds anyway.
    if (choice === 0) { u.orders = 0; u.work = 0; return; }
    if (choice === 1) {
      if (G.gold >= pay) { G.gold -= pay; adjustTension(near.tribe, -5); }
      else { u.orders = 0; u.work = 0; G.msg = 'We cannot afford the compensation.'; }
      return;
    }
    adjustTension(near.tribe, 10, 1);    // @PISS1: roadbuilding
  });
  return true;
}

// ------------------------------------------------------------ native raids
// §19.9 / func_05BE84. A settlement whose alarm toward a power has reached 128
// is on a war footing and becomes a raid source (@0x04734E). The dispatch:
//   gate roll  = random_int(1,12) - 1, plus (difficulty - 2) against a human
//                European owner, tested against threshold 3*K + 1 (@0x5BEE5),
//                where K = the target colony's fortification count (see
//                nativeRaid below -- the old RAID_GATE_K=0 TBD is CLOSED).
//   outcome    = random_int(1,4), downgraded while turn < 40*(2-difficulty)
//                (the early-game softener), then dispatched 5 ways:
//                1 STORES, 2 WREAK, 3 GOLD, 4 BURN/SHIP, 0 NOTHING.
// The payloads behind wreak / gold / burn / ship are unmapped in the evidence;
// what each one takes is the port's own, and every one of them is flagged.
// @INDIANSURPRISE: a raid from a village whose TRIBE is still calm is the
// "chief denies involvement" bulletin (band < restless, flagged).
function surpriseRaidCheck(v, target) {
  const t = G.tribes[v.tribe];
  if (t && tensionBandIdx(t.tension || 0) < 2)
    showEvent('INDIANSURPRISE', { STRING0: t.name,
                                  STRING1: target ? target.name : '',
                                  STRING2: t.name });
}
function raidOutcome() {
  let out = 1 + Math.floor(Math.random() * 4);
  if (G.turn < 40 * (2 - G.difficulty)) out -= 1;
  return Math.max(0, out);
}
// ---- the raid-target scorer: func_0460F8 = 0x181F:0x316, byte-ported ------
// Disassembled 2026-08-07e (RULINGS.md). Per settlement it scores the best
// human-controlled colony within taxi distance 6 and returns that score --
// which is exactly what the map's exclamation strip shows, and what the raid
// AI targets. The pieces, each at its site in func_0460F8:
//   * AREA STRENGTH: over the village's 20-tile work ring (the DGROUP:0xC8/
//     0xDE delta tables, read out of the EXE image at +0x1D9A0), sum the
//     @UNIT attack column (>1 only, ships excluded @0x46172-0x4617E) of the
//     units on each land tile; halve on a layer-2 bit-0x02 tile (0x181F:0x6BE
//     -- approximated here as "a settlement stands there", flagged) and halve
//     again beyond ring distance 1 (@0x461CC-0x46207); bank per owning power.
//   * PER-COLONY SCORE @0x4630E-0x4636A:
//       fort  = (buildings*w/div - 8) >> 2, (w,div) by difficulty from
//               {(1,2),(3,4),(1,1),(3,2),(2,1)} (@0x46425 switch) -- the
//               engine counts the +0x84 bitset; the port counts the colony's
//               building list, flagged
//       score = ((2*max(0,pop-6) + min(pop/2, tribeLevel) + min(pop,6)
//                + fort) * 2 - dist - 1) / (dist + 4)
//       halved when village and colony sit in different map regions
//       (0x181F:0x722 = the layer-3 low nibble, func_005D9C -- imported from
//       a save, flood-filled for a fresh map), then + areaStrength[owner];
//       halved for FRANCE (@0x46388,
//       the byte behind the French tension break) and halved again under
//       power-attribute bit 0x10 (@0x46391 -- Pocahontas's flag).
//   * MISSION TAIL @0x4645E-0x464AD: another power's mission on the village
//     makes raiding the owner MORE attractive (expert x2, plain x1.5); the
//     owner's own mission protects (expert /2, plain -25%).
// Returns { colony, score }; score < 0 = no viable target.
const RAID_RING_DX = [0, 1, 0, -1, -1, 1, 1, -1, 0, 2, 0, -2, -1, 1, -1, 1, -2, -2, 2, 2];
const RAID_RING_DY = [-1, 0, 1, 0, -1, -1, 1, 1, -2, 0, 2, 0, -2, -2, 2, 2, -1, 1, -1, 1];
const RAID_FORT_WEIGHT = [[1, 2], [3, 4], [1, 1], [3, 2], [2, 1]];
function raidTargetScore(v) {
  const area = [0, 0, 0, 0];
  for (let k = 0; k < 20; k++) {
    const x = v.x + RAID_RING_DX[k], y = v.y + RAID_RING_DY[k];
    if (x < 1 || y < 1 || x >= MAP.w - 1 || y >= MAP.h - 1) continue;
    if (tileWater(at(x, y))) continue;
    let s = 0, owner = -1;
    const take = (u, own) => {
      if (u.ship) return;
      const a = Number((unit(u.type) || {}).attack) || 0;
      if (a > 1) s += a;
      if (owner < 0) owner = own;
    };
    for (const u of G.units) if (u.x === x && u.y === y) take(u, G.nation);
    for (const r of G.rivals)
      for (const u of r.units) if (u.x === x && u.y === y) take(u, r.nation);
    if (owner < 0 || !s) continue;
    if (colonyAt(x, y) ||
        G.rivals.some(r => r.colonies.some(c => c.x === x && c.y === y))) s >>= 1;
    if (Math.abs(RAID_RING_DX[k]) > 1 || Math.abs(RAID_RING_DY[k]) > 1) s >>= 1;
    area[owner] += s;
  }
  const [w, dv] = RAID_FORT_WEIGHT[Math.max(0, Math.min(4, G.difficulty))];
  const lvl = (G.tribes[v.tribe] || {}).level || 0;
  let best = null, bestScore = -1;
  for (const c of G.colonies) {
    const dist = Math.abs(c.x - v.x) + Math.abs(c.y - v.y);
    if (dist > 6) continue;
    const pop = c.colonists.length;
    const fort = (Math.floor(c.buildings.length * w / dv) - 8) >> 2;
    let s = Math.floor(((2 * Math.max(0, pop - 6) + Math.min(pop >> 1, lvl) +
                         Math.min(pop, 6) + fort) * 2 - dist - 1) / (dist + 4));
    // Different region (0x181F:0x722 = layer-3 low nibble) halves the score.
    if (REGION[v.y * MAP.w + v.x] !== REGION[c.y * MAP.w + c.x]) s >>= 1;
    s += area[G.nation];
    if (G.nation === 1) s >>= 1;
    if (G.fathersOwned.includes('Pocahontas')) s >>= 1;
    if (s > bestScore) { bestScore = s; best = c; }
  }
  if (best && bestScore > 0 && v.mission) {
    if (v.mission.power !== G.nation)
      bestScore = v.mission.expert ? bestScore << 1 : bestScore + (bestScore >> 1);
    else
      bestScore = v.mission.expert ? bestScore >> 1 : bestScore - (bestScore >> 2);
  }
  return { colony: best, score: best ? bestScore : -1 };
}

// One raid ATTEMPT by village v against colony c. The gate is func_05BE84's:
// roll random_int(1,12)-1 (@0x5BEFD), +(difficulty-2) for a human owner
// (@0x5BF1A), against threshold 3*K+1 (@0x5BEE5) -- and K is now BYTE-READ
// (RULINGS.md 2026-08-07c): the `push 0; lcall 0x181f,0xab0` @0x5BED9 resolves
// to func_00864E, which walks the BUILDING UPGRADE CHAIN from id 0 counting the
// links the colony has -- chain 0 is Stockade -> Fort -> Fortress, so K is the
// colony's FORTIFICATION COUNT, exactly what colonyLevel() already computes.
// A raid that fails the gate simply does not happen (the @0x5BF32 exit).
function nativeRaid(v, c) {
  G.eventTribe = v.tribe;
  const gate = 1 + Math.floor(Math.random() * 12) - 1 + (G.difficulty - 2);
  if (gate < 3 * colonyLevel(c) + 1) return;
  surpriseRaidCheck(v, c);
  {
    const t = G.tribes[v.tribe];
    const S = { STRING0: t ? t.name : '', STRING1: c.name,
                STRING3: DATA.nations[G.nation].adjective };
    switch (raidOutcome()) {
      case 1: {                                    // @RAIDSTORES
        // The good picker, BYTE-READ 2026-08-29 (@0x5C03E..@0x5C0C7): up
        // to 100 tries of random_int(0,15), accepted at stock >= 10; on
        // the FIRST try, a tribe with no horse counter facing a pick
        // stocked past 52 flips a coin for HORSES instead (@0x5C05F..
        // @0x5C084). The muskets magnitude check (@0x5C08F, the
        // random(0,200)-diff*tries register) has an unread consumer --
        // omitted, flagged. No pick in 100 tries -> @RAIDNOTHING.
        const t2 = G.tribes[v.tribe] || {};
        let good = -1;
        for (let tries = 1; tries <= 100 && good < 0; tries++) {
          const pick = Math.floor(Math.random() * 16);
          if (tries === 1 && !(t2.horsesKnown || 0) &&
              (c.stock[pick] || 0) > 52 &&
              Math.floor(Math.random() * 2) === 0) { good = 8; break; }
          if ((c.stock[pick] || 0) >= 10) good = pick;
        }
        if (good < 0 || !(c.stock[good] > 0)) {
          showEvent('RAIDNOTHING', S); break;
        }
        // amount = clamp(1, stock, random_int(min(10, stock/2), stock/2))
        // (@0x5C370..@0x5C3AD) -- the raid takes a LOAD, not the slot.
        const half = c.stock[good] >> 1;
        const lo = Math.min(10, half);
        let qty = lo + Math.floor(Math.random() * (half - lo + 1));
        qty = Math.max(1, Math.min(c.stock[good], qty));
        c.stock[good] -= qty;
        const g = [qty, good];
        // The haul arms the TRIBE (corrected 2026-08-29 -- the old
        // "+0x08 raid budget / +0x0A wealth" gloss misread the tribe
        // pointer): stolen HORSES bump the herd-counter byte +0x08 and
        // add 25 to the herd word +0x0A (@0x5C3DD..@0x5C3E4); stolen
        // MUSKETS bump the muskets counter +0x07, twice at a 50+ load
        // (@0x5C3EE..@0x5C3FB). Other goods are simply gone.
        if (g[1] === 8) {
          t2.horsesKnown = (t2.horsesKnown || 0) + 1;
          t2.herd = (t2.herd || 0) + 25;
        }
        if (g[1] === 15)
          t2.musketsKnown = (t2.musketsKnown || 0) + (g[0] >= 50 ? 2 : 1);
        // The sated-raid tension credit, byte-read: -4 for a stores raid
        // (push -4 @0x5C416; the gold raid's is -16).
        adjustTension(v.tribe, -4, 0);
        showEvent('RAIDSTORES', { ...S, STRING2: DATA.cargo[g[1]].name });
        break;
      }
      case 2: {                                    // @RAIDWREAK
        // Payload byte-read (func_05BE84 @0x5C42A..): the raid DECREMENTS a
        // building tier (dec ColonyRecord+0x95/+0x96 by target id, name
        // substituted). The port's flat building list models the decrement
        // as removing one non-starting building.
        const smash = c.buildings.filter(b => !STARTING_BUILDINGS.includes(b));
        if (smash.length) {
          const b = smash[Math.floor(Math.random() * smash.length)];
          c.buildings.splice(c.buildings.indexOf(b), 1);
        }
        showEvent('RAIDWREAK', S);
        break;
      }
      case 3: {                                    // @RAIDGOLD
        // Amount byte-read (@0x5C2D4..0x5C2F1): random(0x32, min(gold,
        // 0x7FFF)) -- 50 up to the whole treasury -- followed by the -16
        // tension credit (push -0x10 @0x5C5BC, the raid is sated).
        const cap = Math.min(G.gold, 0x7FFF);
        const take = cap >= 0x32
          ? 0x32 + Math.floor(Math.random() * (cap - 0x32 + 1))
          : G.gold;
        G.gold -= take;
        adjustTension(v.tribe, -16, 0);
        showEvent('RAIDGOLD', { ...S, NUMBER0: take });
        break;
      }
      case 4: {                                    // @RAIDBURN / @RAIDSHIP
        const ship = G.units.find(u => u.ship && u.x === c.x && u.y === c.y);
        if (ship) { ship.damaged = true; showEvent('RAIDSHIP', { ...S, STRING2: ship.type }); break; }
        const burnable = c.buildings.filter(b => !STARTING_BUILDINGS.includes(b));
        // @INDIANBURNCOLONY: a burn raid on an undefended one-man colony
        // razes it outright ("Colony burned to the ground! King demands
        // explanation!") -- the threshold reading is flagged.
        if (!burnable.length && c.colonists.length <= 1 &&
            !G.units.some(du => !du.ship && du.x === c.x && du.y === c.y)) {
          showEvent('INDIANBURNCOLONY',
                    { STRING0: S.STRING0, STRING1: S.STRING3, STRING3: c.name });
          c.vanished = true;
          break;
        }
        // @INDIANWINCOLONY (byte-attributed @0x5E01F, func_05CA7E: the
        // human-visible massacre; INDIANWINCOLONY2 is its !human bulletin
        // twin @0x5E026). The aftermath window decrements settlement size
        // while size > 1 (dec [bx+4] @0x5D67A) -- mirrored: an undefended
        // multi-colonist colony loses one colonist to the massacre; the
        // trigger placement inside the raid ladder is the port's, flagged.
        if (!burnable.length && c.colonists.length > 1 &&
            !G.units.some(du => !du.ship && du.x === c.x && du.y === c.y)) {
          const dead = c.colonists.pop();
          showEvent('INDIANWINCOLONY',
                    { STRING0: S.STRING0, STRING1: S.STRING3,
                      STRING2: dead.profession || dead.type, STRING3: c.name });
          break;
        }
        if (!burnable.length) { showEvent('RAIDWREAK', S); break; }
        const b = burnable[Math.floor(Math.random() * burnable.length)];
        c.buildings.splice(c.buildings.indexOf(b), 1);
        showEvent('RAIDBURN', { ...S, STRING2: b });
        break;
      }
      default:                                     // @RAIDNOTHING
        showEvent('RAIDNOTHING', S);
        break;
    }
    // A raid on a HUMAN colony plays woodcut 13, INDIAN RAID (@0x05D219).
    if (!G.raidSeen) { G.raidSeen = true; woodcutOnce(13); }
  }
}

// ---- the native unit mover -------------------------------------------------
// The engine drives every native unit through the per-unit order pipeline
// (func_04E2D6); its idle-movement half is the 9-candidate heading scorer
// func_046FFA, whose terms are byte-decoded and REPRODUCED here term by term:
//   * 9 candidates: the 8 compass tiles + stay ([bp-0x34] 0..8 @0x047371)
//   * base 200 per candidate                                     @0x0473A4
//   * dest Ocean / Sea Lane / Arctic (engine ids 0x19/0x1A/0x18): reject
//                                                                @0x0473BB
//   * dest occupied by another unit: reject                      @0x047A1D
//   * heading continuity, against the unit's stored heading 0x314F:
//       same direction +4      @0x047A79
//       ADJACENT direction +3  @0x047A99 (0x181F:0x384 = func_0049FC,
//                              `(a±1)&7 == b` -- an adjacent-compass test)
//       REVERSE (xor 4) -6     @0x047AB0
//   * the HOME-SETTLEMENT LEASH @0x047AD0-0x047B39: d = distance from the
//     CANDIDATE tile to the unit's settlement; d > 2 costs -3*d. (ai.md §3's
//     "score = 3*dist" gloss had the sign wrong -- `sub [bp-0x24],ax`
//     @0x047B39 is a penalty. The table's halving predicates 0x902/0x8D0 are
//     unread and OMITTED, as are the +4 flag pair @0x047AC6, the frontier
//     gate 0x984, and the era/resource/colony-site terms -- omitted, not
//     replaced.)
//   * RNG jitter +random_int(1,5)                                @0x047F44
//   * clamp at 0, strict max wins, 8 = no move                   @0x047F6E
// A village on a war footing (alarm >= 0x80, the @0x04734E test) instead has
// its brave EXECUTE the planner's raid mission: goto-target = the raid
// scorer's colony (func_0460F8), stepped one tile a turn -- the port's
// straight-line step stands in for the goto executor's own path scoring
// (func_04E2D6 step 5, unported) -- and func_05BE84's raid dispatch fires on
// arrival.
function headingScore(u, home) {
  const DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]];
  const occupied = (x, y) =>
    G.natives.some(q => q !== u && q.x === x && q.y === y) ||
    G.units.some(q => q.x === x && q.y === y) ||
    G.rivals.some(r => r.units.some(q => q.x === x && q.y === y)) ||
    G.villages.some(w => w.x === x && w.y === y) ||
    G.colonies.some(c => c.x === x && c.y === y);
  let best = 8, bestScore = -1;
  for (let cand = 0; cand <= 8; cand++) {
    const x = cand === 8 ? u.x : u.x + DIRS[cand][0];
    const y = cand === 8 ? u.y : u.y + DIRS[cand][1];
    if (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) continue;
    const t = tileTerrain(at(x, y));
    if (t === TERR.OCEAN || t === TERR.SEALANE || t === 24) continue;  // 24 = Arctic
    if (cand !== 8 && occupied(x, y)) continue;
    let s = 200;
    if (cand !== 8 && u.heading !== undefined && u.heading < 8) {
      if (cand === u.heading) s += 4;
      else if (((u.heading + 1) & 7) === cand || ((u.heading + 7) & 7) === cand) s += 3;
      else if ((u.heading ^ 4) === cand) s -= 6;
    }
    if (home) {
      const d = Math.max(Math.abs(x - home.x), Math.abs(y - home.y));
      if (d > 2) {
        // the leash penalty 3*d, HALVED for an armed unit (func_00765C:
        // types 1/4/0xB/0x14/0x16 -- Armed Braves, Mtd. Warriors here,
        // @0x47B14) and QUARTERED for a mounted one (func_007630: types
        // 4/5/0x15/0x16 -- Mtd. Braves, Mtd. Warriors, @0x47B26); both
        // stack to an eighth. (The war-party halving @0x47B05 never
        // applies here -- war-footing braves ride the raid mission.)
        let pen = 3 * d;
        const armed = u.type === 'Armed Braves' || u.type === 'Mtd. Warriors';
        const mounted = u.type === 'Mtd. Braves' || u.type === 'Mtd. Warriors';
        if (armed) pen >>= 1;
        if (mounted) pen >>= 2;
        s -= pen;
      }
    }
    // the FRONTIER term (@0x47B3C..@0x47C96, gate func_00704C: a foreign
    // party adjacent to the candidate on the same landmass -- the port
    // skips the landmass check, flagged):
    //   another TRIBE's brave adjacent: -25 (@0x47C96)
    //   a European adjacent: +50 unless the 0x20 peace bit stands
    //   (unmodeled for tribes -> always, flagged), and when the attitude
    //   band (func_008262) is above Content, a further
    //   (tension - 50) >> 2 (@0x47B5F..@0x47BB2). The port scans the
    //   player's pieces only (rival tension is unmodeled, B3.6-adjacent).
    {
      const t = G.tribes[u.tribe] || {};
      let foreignTribe = false, euro = false;
      for (const [ddx, ddy] of DIRS) {
        const nx = x + ddx, ny = y + ddy;
        if (G.natives.some(q => q !== u && q.tribe !== u.tribe &&
                                q.x === nx && q.y === ny)) foreignTribe = true;
        if (G.units.some(q => q.x === nx && q.y === ny) ||
            G.colonies.some(c => c.x === nx && c.y === ny)) euro = true;
      }
      if (euro) {
        s += 50;
        if (attBand(t.tension || 0) > 0) s += ((t.tension || 0) - 50) >> 2;
      } else if (foreignTribe) s -= 25;
    }
    // the COLONY-DRIFT term (@0x47C9A..@0x47D45): the nearest player
    // colony within distance 12 pulls by (attitude band + 1)*(12-d)/4 --
    // idle braves loiter nearer colonies the worse relations get. (The
    // engine gates on same-region (0x181f:0x6b4) and a preselected
    // colony index from the function head; the port takes the nearest
    // player colony and skips the region check, flagged. The +5 term on
    // the unknown [bp-6] flag @0x47CA4 is omitted, not invented.)
    {
      const t = G.tribes[u.tribe] || {};
      let bestD = 99;
      for (const c of G.colonies) {
        const d2 = Math.max(Math.abs(x - c.x), Math.abs(y - c.y));
        if (d2 < bestD) bestD = d2;
      }
      if (bestD < 12)
        s += ((attBand(t.tension || 0) + 1) * (12 - bestD)) >> 2;
    }
    s += 1 + Math.floor(Math.random() * 5);
    if (s < 0) s = 0;
    if (s > bestScore) { bestScore = s; best = cand; }
  }
  if (best < 8) {
    u.x += DIRS[best][0];
    u.y += DIRS[best][1];
    u.heading = best;
  }
}
function nativeMoveAI() {
  for (const n of G.natives) {
    const v = n.home;
    if (!v) continue;
    const hostile = (v.alarm || 0) >= ALARM_RAID && G.colonies.length;
    if (hostile) {
      const c = raidTargetScore(v).colony || G.colonies.slice().sort((a, b) =>
        (Math.abs(a.x - n.x) + Math.abs(a.y - n.y)) -
        (Math.abs(b.x - n.x) + Math.abs(b.y - n.y)))[0];
      if (Math.max(Math.abs(c.x - n.x), Math.abs(c.y - n.y)) <= 1) {
        // At the palisade: the raid fires, and the party turns for home.
        nativeRaid(v, c);
        n.x = v.x; n.y = v.y + 1;
        if (tileWater(at(n.x, n.y))) { n.x = v.x + 1; n.y = v.y; }
        n.heading = undefined;
        continue;
      }
      const DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]];
      const step = DIRS
        .map(([dx, dy]) => [n.x + dx, n.y + dy])
        .filter(([x, y]) => x >= 0 && y >= 0 && x < MAP.w && y < MAP.h &&
                !tileWater(at(x, y)) &&
                !G.villages.some(w => w.x === x && w.y === y) &&
                !G.natives.some(q => q !== n && q.x === x && q.y === y) &&
                !G.units.some(q => q.x === x && q.y === y) &&
                !G.colonies.some(q => q.x === x && q.y === y))
        .sort((a, b) => (Math.abs(c.x - a[0]) + Math.abs(c.y - a[1])) -
                        (Math.abs(c.x - b[0]) + Math.abs(c.y - b[1])))[0];
      if (step) { n.x = step[0]; n.y = step[1]; }
      continue;
    }
    // At peace: the func_046FFA scorer decides, including the stay candidate.
    headingScore(n, v);
  }
}

// ------------------------------------------- the native background economy
// §19.11, and RULINGS.md 2026-08-01 (the native-background-economy pass, which
// supersedes natives.md §3/§6 -- that section's per-settlement tension model is
// recorded there as WRONG: the 0x5B1C table is TribeData +0x46, per TRIBE x
// power, stride 0x4E, and the applier's first arg is the tribe index [0x8D52].
// The port's per-tribe tension meter is therefore the right shape).
//
// Per village, per turn:
//   * growth accumulator += population, acting at 20 (settlement +0x06);
//   * on acting: replace a fallen brave if one is owed (flags 0x01), else grow
//     by one while below the TARGET SIZE from func_046DE0 --
//       cap = 2*level + 3, or 3*level + 4 for a capital;
//   * a standing mission ticks: M = (expert ? 4 : 1), doubled in a capital,
//     doubled again with Bartolome de las Casas (FF 0x18) and halved with Juan
//     de Sepulveda (FF 0x17); the tribe's fractional feeder gains M and every 8
//     of it becomes one visible -1 tension tick, while the village's alarm word
//     falls by 3*M.
// That last rule is what binds Sepulveda and las Casas to the conversion
// pipeline -- the manual's "+4/-4 on the conversion metric" is this doubler,
// so the earlier TBD on their binding is closed.
function settlementCap(v) {
  const lv = G.tribes[v.tribe] ? G.tribes[v.tribe].level : 0;
  return v.capital ? 3 * lv + 4 : 2 * lv + 3;
}
function missionStrength(v) {
  if (!v.mission) return 0;
  let m = v.mission.expert ? 4 : 1;
  if (v.capital) m *= 2;
  if (G.fathersOwned.includes('Bartolome de las Casas')) m *= 2;
  if (G.fathersOwned.includes('Juan de Sepulveda')) m = Math.floor(m / 2);
  return m;
}
function nativeTick() {
  for (const v of G.villages) {
    // Growth.
    v.growth = (v.growth || 0) + v.pop;
    if (v.growth >= 20) {
      v.growth = 0;
      if (v.braveOwed) {
        v.braveOwed = false;
        spawnBrave(v);
      } else if (v.pop < settlementCap(v)) v.pop += 1;
    }
    // The mission tick.
    const m = missionStrength(v);
    if (!m || v.mission.power !== G.nation) continue;
    const t = G.tribes[v.tribe];
    t.frac = (t.frac || 0) + m;
    while (t.frac >= 8) { t.frac -= 8; adjustTension(v.tribe, -1); }
    v.alarm = Math.max(0, (v.alarm || 0) - 3 * m);
  }
}
// One brave per village, and a village only builds another when its own dies
// (the unit-removal path stamps the request; the next 20-tick fills it).
function spawnBrave(v) {
  const spot = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    .map(([dx, dy]) => [v.x + dx, v.y + dy])
    .find(([bx, by]) => !tileWater(at(bx, by)) &&
                        !G.villages.some(w => w.x === bx && w.y === by) &&
                        !G.natives.some(n => n.x === bx && n.y === by));
  if (!spot) return;
  G.natives.push({ type: 'Braves', icon: unit('Braves').icon, x: spot[0], y: spot[1],
                   tribe: v.tribe, orders: 0, nation: -1, home: v });
}

// --------------------------------------------- the five remaining @ACTIONS
// §19.4. Live Among The Natives, Ask to Speak With Chief, Incite Indians,
// Demand Tribute and Attack Village.

// --- r4 Live Among The Natives -------------------------------------------
// C1.6 CLOSED 2026-08-29: which skill a village teaches is the BYTE MODEL of
// the Live Among handler `func_04A426` + the weight builder `func_048F34`
// (reached through stub 0x1CA24 -- the same routine that fills the goods
// DEMAND table at [0x9E58]; the teach weights are its sibling table at
// [0x9E78], 16 words indexed by @JOB row).
//
// The pick is DETERMINISTIC PER SITE: the handler seeds the runtime LCG with
// `srand(((y<<8) + x + dword[0x8D80]) & 0x7FFF)` (@0x4A49B..@0x4A4C7 via the
// srand wrapper @0x00C30A) -- the same construct as colony building placement
// (`func_009726`) -- draws the pick, then re-seeds from the clock
// (0x181F:0x4CA -> @0x00C2F8, arg ignored). So it never touches the main
// stream, and the port reuses ColonyRng + G.plotSeedBase.
//
// The 20-tile ring offsets are the plot tables at DS:0xC8/0xDE (file
// 0x1DA68/0x1DA7E) -- the 5x5 box minus centre and corners.
const SKILL_RING = [[0, -1], [1, 0], [0, 1], [-1, 0], [-1, -1], [1, -1],
                    [1, 1], [-1, 1], [0, -2], [2, 0], [0, 2], [-2, 0],
                    [-1, -2], [1, -2], [-1, 2], [1, 2], [-2, -1], [-2, 1],
                    [2, -1], [2, 1]];
function villageSkill(v) {
  const t = G.tribes[v.tribe] || {};
  const tech = t.level || 0;
  // ---- mask: box cells worked by ANY colony (@0x48F7D..@0x4904A). The
  // colony's worked-plot array is read through `lookup_byte_from_pair`
  // (0x8956 -> 0x8892: box coords - 2 looked up in the SAME ring tables,
  // so centre and corners never match) with the colony CENTRE special-cased
  // (@0x48FE4). Transcribed literally, including the engine's own quirk:
  // both the bounds probe (interior check func_005BFA on 1..W-2/1..H-2,
  // @0x48FC0) and the marked index use village-relative arithmetic where
  // colony-box coordinates belong.
  const mask = new Uint8Array(25);
  const boxes = [];
  for (const c of G.colonies) {
    const cells = [[2, 2]];
    for (const p of c.colonists) if (p.cell) cells.push([p.cell[0] + 2, p.cell[1] + 2]);
    boxes.push({ x: c.x, y: c.y, cells });
  }
  for (const r of G.rivals || [])
    for (const rc of r.colonies || []) boxes.push({ x: rc.x, y: rc.y, cells: [[2, 2]] });
  for (const b of boxes)
    for (const [dx0, dy0] of b.cells) {
      const rx = v.x - b.x + dx0, ry = v.y - b.y + dy0;         // [bp-4]/[bp-0x5A]
      if (!(rx - 2 >= 1 && rx - 2 <= MAP.w - 2 &&
            ry - 2 >= 1 && ry - 2 <= MAP.h - 2)) continue;      // 0x181F:0x302
      if (rx < 0 || rx >= 5 || ry < 0 || ry >= 5) continue;
      mask[dy0 * 5 + dx0] = 1;                                  // @0x49002
    }
  // ---- 5x5 terrain scan (@0x4904A..@0x49242). Terrain ids come from
  // func_00627A: 0..7 base, 8..0x17 forested, 0x18 Arctic, 0x19/0x1A water,
  // 0x1B mountains / 0x1C hills (func_00624E: relief bit 0x20, bit 0x80
  // splitting mountain from hill) -- exactly the port's detailClass().
  let mtn = 0, hills = 0, cArc = 0, furPrime = 0, forest = 0, food = 0,
      sugar = 0, tobacco = 0, cotton = 0, ore2 = 0, oreCnt = 0, waterRun = 0;
  for (let ty = v.y - 2; ty <= v.y + 2; ty++)
    for (let tx = v.x - 2; tx <= v.x + 2; tx++) {
      if (!(tx >= 1 && tx <= MAP.w - 2 && ty >= 1 && ty <= MAP.h - 2)) continue;
      if (mask[(ty - v.y + 2) * 5 + (tx - v.x + 2)]) continue;
      const tt = detailClass(at(tx, ty));
      if (tt === 0x1B) mtn++;                                   // @0x49195
      else if (tt === 0x1C) hills++;                            // @0x4919E
      else if (tt === 0x18) cArc += 4;                          // @0x491A7
      if (tt >= 8 && tt < 0x18) {                               // forest variants
        food++;                                                 // @0x491C5
        const base = tt >= 0x10 ? tt - 0x10 : tt - 8;
        if (base < 3) { furPrime++; cArc += 2; }                // @0x4905C
        else {
          forest++; oreCnt++;                                   // @0x491F9
          if (base === 5) sugar += 2;
          if (base === 4) tobacco += 2;
          if (base === 3) cotton += 2;
        }
      } else if (tt === 0x19 || tt === 0x1A) {                  // water @0x49072
        waterRun += tech + 1;
        while (waterRun >= 3) { food += 2; waterRun -= 3; }
      } else if (tt < 8) {                                      // @0x4909B..
        if (tt === 5) sugar += 4;
        if (tt === 7) sugar += 2;
        if (tt === 4) tobacco += 4;
        if (tt === 6) tobacco += 2;
        if (tt === 3) cotton += 4;
        if (tt === 0) ore2 += 2;
        if (tt === 2) { cotton += 1; food += 2; }
        if (tt > 1) {                                           // @0x490E4
          food += 2;
          if (tt >= 6) ore2++;
          else {
            food++;
            if (tt & 4) oreCnt += 2;                            // 4, 5
            else cArc += 2;                                     // 2, 3
          }
        } else if (tt === 1) oreCnt += 4;                       // @0x49112
        else cArc += 3;                                         // tt === 0
      }
    }
  // ---- weight assembly (@0x49242..@0x49386) + the caller's tech gates
  // (@0x4A4CF..@0x4A51D). Rows 5, 9, 10 and 13..15 are never written.
  const pop1 = (v.pop || 0) + 1;
  const vcount = G.villages.filter(w => w.tribe === v.tribe).length;
  const w = new Array(16).fill(0);
  w[0] = Math.trunc(((tech + pop1) * food) / (7 - tech));       // Farmer
  w[1] = sugar;                                                 // Sugar Planter
  w[2] = tobacco;                                               // Tobacco Planter
  w[3] = cotton;                                                // Cotton Planter
  w[4] = Math.trunc((2 * furPrime + (forest >> 1)) / (tech + 1)); // Fur Trapper
  if (tech >= 1) {
    w[6] = 2 * hills + mtn + ore2;                              // Ore Miner
    if (tech >= 2)                                              // Silver Miner:
      // tribe hoard word (+0x0C, role otherwise unread -- FLAGGED) over the
      // tribe's settlement count, plus 4 per mountain (8 at tech 3).
      w[7] = Math.trunc((t.hoard || 0) / Math.max(1, vcount)) +
             (tech > 2 ? 8 : 4) * mtn;
  }
  w[12] = 2 * ((w[4] + tech) >> 1);                             // Fur Trader
  w[11] = 2 * ((w[3] + tech) >> 1);                             // Weaver
  if (tech < 1) { w[12] = 0; w[6] = 0; w[0] >>= 1; }
  if (tech < 2) { w[11] = 0; w[7] = 0; w[0] -= w[0] >> 2; }
  if (tech === 3) w[7] += w[7] >> 1;                            // @0x4A512
  // ---- the seeded pick (@0x4A521..@0x4A5F1).
  const rng = new ColonyRng((((v.y << 8) + v.x + (G.plotSeedBase >>> 0)) >>> 0) & 0x7FFF);
  const sum = w.reduce((a, x) => a + x, 0);
  if (sum < 1) return 0;         // all-zero table: the EXE would walk off it
  let cnt = rng.range(1, sum), j = -1;
  do { cnt -= w[++j]; } while (cnt > 0);
  // Seasoned Scout: pick 4 converts when (x + y) % 3 == 0 (@0x4A56B).
  if (j === 4 && (v.x + v.y) % 3 === 0) j = 0x16;
  // Expert Fisherman: pick 0 converts when random_int(1,20) < the count of
  // water tiles ((raw & 0x1F) == 0x19/0x1A, func_0062B4) on the 20-ring
  // (@0x4A595..@0x4A5EB).
  if (j === 0) {
    let n = 0;
    for (const [dx, dy] of SKILL_RING) {
      const raw = at(v.x + dx, v.y + dy) & 0x1F;
      if (raw === 0x19 || raw === 0x1A) n++;
    }
    if (rng.range(1, 20) < n) j = 8;
  }
  return j;
}
// The handler ladder, in func_04A426's own order (@0x4A64C..@0x4A78E). The
// GAME.TXT keys are composed as "LEARN"+suffix in the EXE (strcpy/strcat of
// the suffix strings "MAD"/"CRIMINAL"/"MASTER"/"ALREADY"/"SLOW"/"LATER"/
// "DONE" onto base key 0x162A) -- the same full keys the port already uses.
function liveAmong(v, u) {
  const t = G.tribes[v.tribe];
  const job = villageSkill(v);
  const S = { STRING0: t.name, STRING1: DATA.jobs[job] };
  // @LEARNMAD: attitude band (func_008262: 25/50/75) above 1 -- i.e.
  // tension >= 50 -- refuses AND costs 3 tension (the applier call with
  // delta 3, category 0, @0x4A669).
  if (attBand((t && t.tension) || 0) > 1) {
    showEvent('LEARNMAD', S);
    adjustTension(v.tribe, 3, 0);
    return;
  }
  if (u.profession === 'Petty Criminals') { showEvent('LEARNCRIMINAL', S); return; }
  // @TEACHCONVERT: "Indian converts already know the Indian ways." -- the
  // convert refusal is its own key (training.md §Native learning), not the
  // generic @LEARNMASTER a convert would otherwise fall into.
  if (u.profession === CONVERT_CLASS) { showEvent('TEACHCONVERT', S); return; }
  if (u.profession && u.profession !== 'Free Colonists' &&
      u.profession !== 'Indentured Servants') {
    showEvent('LEARNMASTER', S); return;
  }
  // The taught latch (settlement +0x03 bit 1) only blocks NON-capitals: the
  // @0x4A6EE test skips @LEARNALREADY when the capital flag (bit 2) is set.
  if (v.taught && !v.capital) { showEvent('LEARNALREADY', S); return; }
  askEvent('LEARNSTAY', S, (choice) => {
    if (choice !== 0) { showEvent('LEARNLATER', S); return; }
    // The failure roll only runs at attitude band > 0 (tension >= 25,
    // @0x4A728) -- a content tribe always teaches. Roll @0x4A72C:
    // random_int(1,1000) < 200*difficulty + 100 -> @LEARNSLOW, may retry.
    if (attBand((t && t.tension) || 0) > 0 &&
        1 + Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100) {
      showEvent('LEARNSLOW', S);                    // unskilled -- may retry
      return;
    }
    v.taught = true;                                // flags |= 2 @0x4A78A
    u.profession = DATA.jobexpert[job];
    showEvent('LEARNDONE', S);
  });
}

// --- r5 Ask to Speak With Chief ------------------------------------------
// REBUILT 2026-08-07 from func_04A7CA (the real chief handler; RULINGS
// 2026-08-07z9). Byte-read ladder, in the engine's order:
//   1. seasoned = (profession byte == 0x16, Seasoned Scouts)
//   2. tension >= 75: the scout is taken (attribute-bit-6 exemption unread;
//      the exempt path falls to the polite nothing)
//   3. ONE roll = random(0, 100 + 40*seasoned) serves two gates:
//      roll <= tension/4 (only at tension >= 25)  -> @CHIEFKILL
//      (Aztec extra: tribe idx 2, random(0,(8-difficulty)<<seasoned)==0
//       -> kill too, @0x4A843)
//   4. the @CHIEFHOWDY demand briefing plays on every surviving audience
//   5. roll <= tension -> the polite nothing (@CHIEFBORED)
//   6. settlement once-flag bit 8 (v.chiefSeen) -> @CHIEFBORED; else set it
//   7. random(1,3): 1 -> @CHIEFGUIDES, and the scout BECOMES a Seasoned
//      Scout (profession write @0x4A9DD; a seasoned scout falls to arm 2)
//      2 -> @CHIEFAREA + the map reveal (helper 0xE08(x,y,0); its radius
//           is inside the helper, unread -- the port has no fog to lift)
//      3 -> @CHIEFGIFT, amount = random(1,6) * (3d(10-difficulty)) * 4
//           * (tribeLevel+1)   (@0x4AAD0..0x4AB2D, byte-exact)
function speakToChief(v, u) {
  const t = G.tribes[v.tribe];
  const S = { STRING0: t.name, STRING1: DATA.nations[G.nation].adjective };
  const seasoned = u.profession === 'Seasoned Scouts' ? 1 : 0;
  const ten = t.tension || 0;
  const kill = () => {
    const i = G.units.indexOf(u);
    if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
    showEvent('CHIEFKILL', S);
  };
  const roll = Math.floor(Math.random() * (101 + 40 * seasoned));
  if (ten >= TENSION_HOSTILE) { kill(); return; }
  if (ten >= 25 && roll <= (ten >> 2)) { kill(); return; }
  if (v.tribe === 2 &&
      Math.floor(Math.random() * (((8 - G.difficulty) << seasoned) + 1)) === 0) {
    kill(); return;
  }
  // The demand briefing plays on every surviving audience.
  const d = villageDemand(v);
  const top = d.map((n, i) => [n, i]).sort((a, b) => b[0] - a[0]).map(r => r[1]);
  showEvent('CHIEFHOWDY', { STRING0: t.treasure || DATA.cargo[top[0]].name,
                            STRING1: DATA.cargo[top[0]].name,
                            STRING2: DATA.cargo[top[1]].name,
                            STRING3: DATA.cargo[top[2]].name });
  if (roll <= ten) { showEvent('CHIEFBORED', S); return; }
  if (v.chiefSeen) { showEvent('CHIEFBORED', S); return; }
  v.chiefSeen = true;
  let arm = 1 + Math.floor(Math.random() * 3);
  if (arm === 1 && seasoned) arm = 2;
  if (arm === 1) {
    u.profession = 'Seasoned Scouts';
    showEvent('CHIEFGUIDES', { ...S, STRING1: DATA.levelname[v.level].toLowerCase() });
  } else if (arm === 2) {
    showEvent('CHIEFAREA', S);
  } else {
    const n = 10 - G.difficulty;
    const d3 = () => 1 + Math.floor(Math.random() * n);
    const gold = (1 + Math.floor(Math.random() * 6)) * (d3() + d3() + d3()) * 4 *
                 ((v.level || 0) + 1);
    G.gold += gold;
    showEvent('CHIEFGIFT', { ...S, NUMBER0: gold });
  }
}

// --- r6 Incite Indians ----------------------------------------------------
// "We will gladly drive the {rival} from our ancestral lands in exchange for
// {N}" (@INDIANWARPATH2). The asking price's formula and the payment's tension
// writes are BOTH untraced -- and the +100/-100 pair once filed here belongs to
// the post-Declaration war council instead (RULINGS.md 2026-08-01 item 6), so
// it is deliberately NOT used. The manual names the three factors (your
// missions with the tribe, their attitude to you, their attitude to the target)
// without a formula; the port prices it off those three and flags it.
function incitePrice(v, target) {
  const t = G.tribes[v.tribe];
  const missions = G.villages.filter(w => w.mission && w.mission.power === G.nation &&
                                          w.tribe === v.tribe).length;
  const base = 1000 + 20 * (t.tension || 0) - 100 * missions;
  return Math.max(100, Math.floor(base / 100) * 100 + 100 * target);
}
function inciteIndians(v, u) {
  const t = G.tribes[v.tribe];
  const mets = G.rivals.filter(r => r.met);
  if (!mets.length) { notice('We have met no other power to incite them against.'); return; }
  // @INDIANWARPATH: "Whom would you like us to attack?" -- the target
  // picker, when there is a choice to make.
  if (mets.length > 1) {
    G.eventTribe = v.tribe;
    askEvent('INDIANWARPATH', { STRING0: t.name }, (k) => {
      if (k >= 0 && k < mets.length) inciteAgainst(v, u, mets[k]);
    }, mets.map(r => DATA.nations[r.nation].adjective));
    return;
  }
  inciteAgainst(v, u, mets[0]);
}
function inciteAgainst(v, u, target) {
  const t = G.tribes[v.tribe];
  const price = incitePrice(v, target.nation);
  askEvent('INDIANWARPATH2', { STRING0: DATA.nations[target.nation].adjective,
                               NUMBER0: price }, (choice) => {
    if (choice !== 0) return;
    if (G.gold < price) { showEvent('NOTENOUGH', { NUMBER0: G.gold }); return; }
    G.gold -= price;
    t.warWith = target.nation;
    showEvent('INDIANWARFARE', {
      STRING0: t.name, STRING1: DATA.nations[G.nation].adjective,
      STRING2: t.name, STRING3: DATA.nations[target.nation].adjective,
    });
  });
}

// --- r7 Demand Tribute ----------------------------------------------------
// func_04AC00. The demand is in GOODS, not gold, and the coded clamp collapses:
//   tribute = clamp(raw, 10, min(3*wealth_word + 10, 100))
// with the wealth word only ever written zero, so the ceiling is always 10 and
// every successful demand in the shipped game is exactly TEN units
// (RULINGS.md 2026-08-01 item 7; ceiling @0x4AEA2, floor @0x4AEB0). Each
// village pays once ever -- settlement flags bit 0x10, the tribute-once latch.
// The strength contest that decides success is described but not traced: your
// regional military score against the tribe's, each side rolling
// random(0..strength), with Spain and Hernan Cortes counting x1.5. The port
// implements exactly that shape and flags the score's own definition.
const TRIBUTE_UNITS = 10;
function militaryScore() {
  let s = G.units.filter(u => !u.ship).reduce((n, u) => n + unit(u.type).combat, 0);
  if (G.nation === 2 || G.fathersOwned.includes('Hernan Cortes')) s = Math.floor(s * 3 / 2);
  return s;
}
function demandTribute(v, u) {
  const t = G.tribes[v.tribe];
  const S = { STRING0: G.leader || DATA.nations[G.nation].leader, STRING1: t.name,
              STRING2: t.name };
  if (v.tributePaid) { showEvent('EXTORTPOOR', S); return; }
  const mine = Math.floor(Math.random() * (militaryScore() + 1));
  const theirs = Math.floor(Math.random() * (2 * v.pop * (t.level + 1) + 1));
  adjustTension(v.tribe, 3);
  if (mine <= theirs) {
    showEvent(t.tension >= TENSION_HOSTILE ? 'EXTORTLAUGH' : 'EXTORTNO',
              { ...S, STRING0: DATA.nations[G.nation].adjective, STRING1: G.leader,
                STRING2: t.name });
    return;
  }
  v.tributePaid = true;
  // The goods land in the visitor's hold if it carries one, else in the nearest
  // colony's stores; the good is the village's best surplus.
  const surplus = villageSurplus(v);
  const good = surplus.length ? surplus[0].good : 4;      // Furs by default
  const dest = G.colonies.slice().sort((a, b) =>
    (Math.abs(a.x - v.x) + Math.abs(a.y - v.y)) - (Math.abs(b.x - v.x) + Math.abs(b.y - v.y)))[0];
  if (u && u.hold) holdAdd(u, good, TRIBUTE_UNITS);
  else if (dest) dest.stock[good] += TRIBUTE_UNITS;
  showEvent('EXTORTSTUFF', { ...S, NUMBER0: TRIBUTE_UNITS,
                             STRING2: DATA.cargo[good].name,
                             STRING3: dest ? dest.name : DATA.nations[G.nation].homeport });
}

// --- r8 Attack Village ----------------------------------------------------
// §19.10. The POPULATION IS THE COUNTER: byte-located @0x5D67A inside the
// combat resolution func_05CA7E -- every battle the village loses does pop--
// while pop > 1, and at the last point the village is destroyed (a human
// attacker also stamps the tribe's avenge flag +0x03 |= 0x40 @0x5D6A1) and
// remove_settlement @0x5D6A9 runs. So a size-8 village takes eight lost
// battles to erase.
//
// The raze payout is byte-verified and cross-checks against the manual's own
// ceiling table (size factor 21 at Discoverer -> 30*6*4*21 = 15 120):
//   gold = (SUM of 3 x random_int(0, 10 - difficulty)) * random_int(0,6) * 4 * (size + 1)
// credited straight to the attacker's gold (32-bit add @0x4AB66) -- no x100 and
// no Treasure unit on this path. The size operand is the VILLAGE POPULATION per
// the user-verified 2026-05-30 ruling (the raw instruction reads the tribe's
// level byte -- the "Apache richer than Aztec" bug). A capital-only bonus
// exists whose magnitude is unmapped, so it is not applied.
function razeGold(v) {
  const d = G.difficulty;
  let sum = 0;
  for (let i = 0; i < 3; i++) sum += Math.floor(Math.random() * (11 - d));
  return sum * Math.floor(Math.random() * 7) * 4 * (v.pop + 1);
}
function removeVillage(v) {
  // Native units of the village are detached, then the record is retired. If it
  // was the tribe's last village the tribe is extinct (@EXTINCT), and a
  // surviving tribe has its horse herd and horse lore scaled by n/(n+1) --
  // the TRIBE's record, not the dead village's (corrected 2026-08-01).
  const t = G.tribes[v.tribe];
  for (let i = G.natives.length - 1; i >= 0; i--)
    if (G.natives[i].home === v) G.natives.splice(i, 1);
  G.villages.splice(G.villages.indexOf(v), 1);
  const left = G.villages.filter(w => w.tribe === v.tribe).length;
  if (!left) { t.dead = true; showEvent('EXTINCT', { STRING0: t.name }); return; }
  const n = left;
  t.herd = Math.floor((t.herd || 0) * n / (n + 1));
  t.horsesKnown = Math.floor((t.horsesKnown || 0) * n / (n + 1));
}
function attackVillage(v, u) {
  askEvent('WHACKINDIANS', { STRING0: G.tribes[v.tribe].name }, (choice) => {
    if (choice !== 0) return;
    const t = G.tribes[v.tribe];
    // @INDIANSHUN: the tribe's defiance the first time this power attacks
    // them -- "Prepare for WAR!" (binding flagged; once per tribe).
    if (!t.shunned) {
      t.shunned = true;
      G.eventTribe = v.tribe;
      showEvent('INDIANSHUN', { STRING0: t.name });
    }
    adjustTension(v.tribe, 100, 4);                 // an attack is an act of war (@PISS4)
    // The village defends with a brave's strength on its own tile, plus the
    // settlement's own standing -- the port uses the settlement level as the
    // fortification the engine's colony bonus would supply.
    const defender = { type: 'Braves', x: v.x, y: v.y, orders: 6, nation: -1,
                       tribe: v.tribe };
    const A = combatStrength(u, false);
    const D = Math.floor(combatStrength(defender, true) * (4 + v.level) / 4);
    const win = 1 + Math.floor(Math.random() * (A + D)) <= A;
    if (!win) {
      const i = G.units.indexOf(u);
      if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
      G.msg = `${u.type} destroyed attacking the ${t.name}.`;
      return;
    }
    u.movesLeft = 0;
    if (v.pop > 1) { v.pop -= 1; G.msg = `The ${t.name} ${DATA.levelname[v.level].toLowerCase()} is reduced.`; return; }
    const gold = razeGold(v);
    G.gold += gold;
    t.avenge = true;                                // the post-Declaration flag
    // @LOOT (with the recovered treasure) / @NOLOOT (nothing found); @LOOT2
    // is kept for the mission-present variant -- which body maps to which
    // razing state is unread, this split is flagged.
    const razeS = { STRING0: DATA.nations[G.nation].adjective,
                    STRING1: t.name, STRING2: DATA.levelname[v.level],
                    NUMBER0: gold };
    G.eventTribe = v.tribe;
    showEvent(gold > 0 ? 'LOOT' : (v.mission ? 'LOOT2' : 'NOLOOT'), razeS);
    // @INDIANSLAVES: with a mission of ours at the razed village the
    // frightened flock converts (flagged reading of the body).
    if (v.mission && v.mission.power === G.nation) {
      const cnear = G.colonies[0];
      if (cnear) {
        cnear.colonists.push({ type: 'Colonists', profession: 'Indian Converts',
                               job: null, cell: null });
        showEvent('INDIANSLAVES', { STRING0: t.name,
                                    STRING1: DATA.nations[G.nation].adjective });
      }
    }
    removeVillage(v);
  });
}

// ------------------------------------------------------------ event popups
// The GAME.TXT event templates render through the same centred-dialog engine as
// everything else (@width=190 on all of these). They carry no option rows: the
// engine shows the body and waits for an acknowledgement. Several can fire in
// one turn, so they queue.
function fillTemplate(line, subs) {
  // %COUNTRY is the engine's own-nation substitution (@UNREST uses it).
  // A '$' after the placeholder is KEPT: it is the gold-coin glyph the
  // fonts carry ("1352$." renders with the coin, census3_buy_prompt).
  return line.replace(/%COUNTRY/g, DATA.nations[G.nation].country)
             .replace(/%(STRING|NUMBER)(\d)/g, (m, kind, n) => {
    const v = subs[`${kind}${n}`];
    return v === undefined ? '' : String(v);
  });
}
// ---- popup speaker channels (spec/ui/popups.md §2.7) ----------------------
// The engine dispatches the portrait through three DGROUP words: [0x1F5C] = 8
// -> KING1.SS (func_06F5DA @0x06F5DD), [0x1F5C] = tribe -> IND<n>A<pose>.SS
// (func_06BE92), [0x1F5E] = n -> MSS<n>.SS (func_06BF12; the military wrapper
// func_040C1E pushes 5 @0x040CD3, the trade popups 2/3/4 @0x034E5E-98). Which
// message key runs through which wrapper is only partially byte-mapped
// (POPUP_TEMPLATE_AUDIT.md caller map), so the port routes by KEY FAMILY --
// its own reading of that map, flagged as such. Native families read the tribe
// from G.eventTribe, which every native dispatcher stamps before it fires.
// KING1: the tax/boycott region sets [0x1F5C]=8 (func_06F5DA; orphan sites
// @0x03457A/0x0345D8 cover @TAXOPTIONS/@TEAPARTY), and the treasure-delivery
// family is byte-cited to the same channel (spec/ui/popups.md:398-402), so
// @CASHTREASURE/@LOOT*/@NOLOOT join it. LOOTCAPTURE stays military.
const SPEAKER_KING = /^(KING|TAXOPTIONS|TEAPARTY|UPKEEP|CASHTREASURE|LOOT(?!CAPTURE)|NOLOOT|MERCENARIES|REFIT)/;
const SPEAKER_MILITARY = /^(DEMOTE|COLONISTCAPTURE|WAGONCAPTURE|CARGOCAPTURE|LOOTCAPTURE|ARTILLERY|SHIPDAMAGE|SHIPSUNK|VETERAN|VALOR|WELLSEASONED|SHIPCOMBAT|EVASIVE|FORTFIRE|MOBILIZE|WARN)/;
const SPEAKER_NATIVE = /^(RAID|INDIAN|CHIEF|LEARN|EXTORT|VILLAGE|MISSION|HERESY|BURIAL|WHACK|EXTINCT|MADAT|DEADCONVERTS|PISS|BUY0|BUY1|BUYWHICH|TRADE0|TRADE1|TRADEWHICH|BADHAGGLE|BADCARGO|TRADENOCARGO|TRADENOWANT)/;
// MSS2 merchant: price/trade wrapper func_034DD4 sets 2 @0x034E98 and the
// live @PRICEDOWN/@PRICERISE frames wear it; @SUCCESSION is cited to MSS2
// directly. @UNREST's index is unread -- MSS2 is the port's reading (the
// immigration adviser the Europe RECRUIT menu already uses).
const SPEAKER_TRADE = /^(PRICE|SOMEBOYCOTT|SUCCESSION|UNREST)/;
// MSS3 pioneer: colony-siting warnings from func_022542 -- @TUTNOSPACES /
// @TUTNOLUMBER push arg 3 (@0x22772/@0x2278A); the live @NOOCEANCOLONY frame
// wears the same fur-hat portrait. Family routing beyond the two TUT keys is
// the port's reading.
const SPEAKER_SITE = /^(TOONEAR|NOPORT|SEACOLONY|TOOMOUNTAIN|TUTNO|NOOCEAN)/;
// MSS1: @FOREIGNNOTAVAIL pushes 1 (spec/ui/advisor_reports.md:283); the
// diplomacy ANNOUNCEMENT family (width-190 keys) is cited to the advisor
// channel "MSS1/MSS2" without a per-key split -- MSS1 is the port's pick.
const SPEAKER_DIPLO = /^(FOREIGNNOTAVAIL|DECLAREWAR|SIGNTREATY|WITHDRAW|THREATS|GIVECASH|TRIBUTE|WORTHY)/;
// MSS0: the colony-event wrapper func_032FE2 sets 0 @0x03300D; which keys
// route through it is unread, so the colony production/food family here is
// the port's reading of "colony-event popup".
// BUYME added 2026-08-08: the census3 BUY prompt wears the bonneted colony
// advisor (census3_buy_prompt).
const SPEAKER_COLONY = /^(BUILT|NEWCOLONIST|CLEARCUT|USEDUPTOOLS|FOODLOW|FOOD\d|STARVE|SPOIL|NEEDTOOLS|WAREHOUSEFULL|CARGOREADY|BUYME)/;
function eventSpeaker(key) {
  // MSS0 and MSS5 were SWAPPED until the 2026-08-08 census run: the live
  // combat bulletin ("French defeat Dutch Colonists near Roanoke!") wears the
  // MSS0 naval officer and the colony-supply popups (tools shortages, cargo
  // ready, the rush-buy prompt) wear the MSS5 bonneted advisor
  // (census_combat_bulletin / census_turnevent_* / 81_colony_build_prompt).
  if (SPEAKER_MILITARY.test(key)) return 'MSS0';
  if (SPEAKER_KING.test(key)) return 'KING1';
  if (SPEAKER_NATIVE.test(key))
    return G.eventTribe >= 0 ? `IND${G.eventTribe % 8}A0` : null;
  if (SPEAKER_TRADE.test(key)) return 'MSS2';
  if (SPEAKER_SITE.test(key)) return 'MSS3';
  if (SPEAKER_DIPLO.test(key)) return 'MSS1';
  if (SPEAKER_COLONY.test(key)) return 'MSS5';
  return null;
}
// The speaker sits at the screen's bottom-right UNDER the plaque -- the same
// placement the village screen already uses for its chief portrait; the
// engine's own landing pixel is runtime cel state (§2.7.1), not a literal.
function drawSpeakerSheet(ctx, sheet, box) {
  if (!sheet) return;
  const [pw, ph] = frameSize(sheet, 0);
  if (!pw) return;
  // The engine's landing pixel is runtime cel state -- no static coordinate
  // exists in the EXE (spec/ui/popups.md par.2.7.1). The port anchors each
  // family where the live captures put the figure: the MSS/MYR advisors
  // STANDING ON THE BOX when its rect is known -- centred on it, hands
  // resting 4px behind its top edge (census3_buy_prompt: the bonneted
  // advisor spans y~40..104 over the box at 104) -- else top-anchored left
  // of centre (60_landfall); the tribe figures full-height at the right
  // edge (61_arawak_first_contact), the King centred. FLAGGED as a
  // capture-anchored approximation (per-frame cel variance remains).
  if (/^IND/.test(sheet)) sheetFrame(ctx, sheet, 0, W - pw - 20, H - ph - 8);
  else if (/^KING/.test(sheet)) sheetFrame(ctx, sheet, 0, 160 - (pw >> 1), 6);
  else if (box) sheetFrame(ctx, sheet, 0,
                           box.x + (box.w >> 1) - (pw >> 1),
                           Math.max(0, box.y - ph + 4));
  else sheetFrame(ctx, sheet, 0, 120 - (pw >> 1), 8);
}
function showEvent(key, subs, speaker) {
  const t = DATA.events[key];
  if (!t) return;
  // The GAME.TXT key rides along for the test suite and debugging -- the
  // renderer never reads it. (The vertical anchor is derived from the
  // speaker at draw time -- see drawEvent/layoutDialog.)
  G.eventQueue.push({ key, lines: t.body.map(l => fillTemplate(l, subs || {})),
                      width: t.width, small: !!t.small,
                      speaker: speaker !== undefined ? speaker : eventSpeaker(key) });
}
// Ad-hoc notice popup: port phrasing, NOT a GAME.TXT event -- used where the
// engine's own message key is not yet byte-identified (flagged in the popup
// audit ledger) and for port-status notices (save/load). Identical
// back-to-back notices collapse ("No moves left." mashed twice).
function notice(s) {
  // The engine never wraps -- GAME.TXT lines come pre-broken -- so this wrap
  // exists only because port-authored strings arrive as one line. It breaks
  // at the 190px @width every gameplay popup carries (histogram 190:336),
  // less the +10 line margin, so the box comes out the canonical 196 wide.
  const lines = wrapText(DFONT(), s, 180);
  const tail = G.eventQueue[G.eventQueue.length - 1];
  if (tail && !tail.speaker && tail.lines.join('\n') === lines.join('\n')) return;
  G.eventQueue.push({ lines, width: 190, speaker: null });
}
// The colony-supply announcements (tools shortages, cargo-ready, the
// warehouse warnings) carry the engine's two @MISC action rows "Continue
// turn." / "Zoom to colony." (census_turnevent_2/3/5 + census_cargoready);
// row 1 opens the colony the message is about. The engine shows each modally
// in turn; the port's queue holds one dialog at a time, so any beyond the
// first fall back to plain popups this turn (port reconciliation, flagged).
function askZoom(key, subs, c) {
  if (G.dialog) { showEvent(key, subs); return; }
  const misc = DATA.text.misc || [];
  askEvent(key, subs, (k) => {
    if (k !== 1) return;
    const i = G.colonies.indexOf(c);
    if (i >= 0) { G.colony = i; G.screen = 'colony'; }
  }, [misc[34] || 'Continue turn.', misc[35] || 'Zoom to colony.']);
}
// A GAME.TXT event that carries a second paragraph carries OPTION ROWS, so it
// runs through the ordinary dialog framework instead of the notice queue.
function askEvent(key, subs, onDone, optsKey, speaker) {
  const t = DATA.events[key];
  if (!t) { if (onDone) onDone(-1); return; }
  // Most event popups carry their own rows in a second paragraph; the King's
  // tax demand instead pairs its pretext body with the shared @TAXOPTIONS
  // rows, and the runtime-built menus (@MILITARY's target list, @TRADEWHICH's
  // cargo picker) pass their rows as an ARRAY.
  const rowsFrom = Array.isArray(optsKey) ? optsKey
    : optsKey && DATA.events[optsKey] ? DATA.events[optsKey].body : t.tail;
  const rows = rowsFrom.map(l => fillTemplate(l, subs || {}));
  G.dialog = {
    body: t.body.map(l => fillTemplate(l, subs || {})),
    tail: rows, width: t.width, onDone, opts: rows,
    small: !!t.small,
    speaker: speaker !== undefined ? speaker : eventSpeaker(key),
    // Same one-based @default as openDialog above.
    sel: t.default && /^\d+$/.test(t.default)
      ? Math.max(0, Math.min(rows.length - 1, +t.default - 1)) : 0,
  };
}
function drawEvent(ctx) {
  const e = G.eventQueue[0];
  if (!e) return;
  // Body-only box: the option block ("+3 + rows*8 + 3") exists only when
  // there ARE rows (dialog_framework.md §3), and there is no OK / Cancel /
  // Continue anywhere in the EXE -- dismissal is any key/click, each popup
  // waiting its turn (the old func_004A80 "120-tick timeout" reading is
  // overturned -- see frameBody).
  const f = dFont(e.small), tp = dText(e.small);
  let cw = e.width;
  for (const l of e.lines)
    cw = Math.max(cw, f.width(l.replace(/[{}]/g, '')) + 10);
  const w = cw + 6, h = 6 + e.lines.length * tp + 3;
  // A popup with an adviser figure centres on y=130 (census_turnevent_0:
  // box top 119 for the two-line bulletin), figureless ones on 100 -- the
  // same speaker rule as layoutDialog. FLAGGED (positioning code unread).
  const low = e.speaker && /^(MSS|MYR)/.test(e.speaker);
  const x = Math.round(160 - w / 2), y = Math.round((low ? 130 : 100) - h / 2);
  const ik = dialogInks();
  drawSpeakerSheet(ctx, e.speaker, { x, y, w, h });
  plaque(ctx, x, y, w, h, 'WOODTILE');
  e.lines.forEach((l, i) => spanText(ctx, l, x + 5, y + 6 + i * tp,
                                     ik.base, ik.hi, f));
}

// Walking into a village opens the ten-row @ACTIONS menu (spec/ui/
// context_dialogs.md §6 -- func_04B308 is that table's only consumer).
function enterVillage(v, visitor) {
  // @DONTKNOWSHIPS: "We must contact the Indians on land first" -- a ship
  // cannot open the village.
  if (visitor && visitor.ship) { showEvent('DONTKNOWSHIPS'); return; }
  // @INDIANHELLO1/2: the once-per-village greeting -- "most worthy" below
  // the restless band, "most ruthless" at it and above (band split flagged).
  // The very first TRIBE contact takes the woodcut + @INDIANWELCOME chain
  // instead; the greeting begins with the second village.
  if (!v.greeted && (G.tribes[v.tribe] || {}).met) {
    v.greeted = true;
    const gt = G.tribes[v.tribe] || {};
    G.eventTribe = v.tribe;
    showEvent((gt.tension || 0) < 40 ? 'INDIANHELLO1' : 'INDIANHELLO2',
              { STRING0: gt.name || '', STRING1: G.leader || DATA.nations[G.nation].leader,
                STRING2: DATA.nations[G.nation].adjective });
  }
  // TUTORIAL8: an unskilled COLONIST at a village can learn (flagged --
  // scouts and other unit kinds cannot, per the live-among rules).
  if (visitor && visitor.type === 'Colonists' && !visitor.profession)
    tutOnce(8, { STRING0: visitor.type });
  G.village = v;
  G.eventTribe = v.tribe;                          // the popup speaker channel
  G.villageVisitor = visitor;
  G.villageRow = 0;
  G.villageMode = 'actions';
  G.screen = 'village';
  // First contact with this TRIBE fires its welcome plate + @INDIANWELCOME
  // (func_056C3E); the first village ever entered fires ENTERING INDIAN
  // VILLAGE (func_04B308 @0x04B56C). Contact outranks the generic plate.
  firstTribeContact(v);
  if (G.screen === 'village') woodcutOnce(7, 'village');
}
// The per-row show/enable predicates, all byte-cited in that spec section. Rows
// whose gate reads the tribe-record POSTURE byte (+0x5236) cannot be reproduced
// -- that byte is traced but its semantic is not decoded -- so those rows are
// offered unconditionally and the gap is flagged.
function villageActions() {
  const v = G.village, u = G.villageVisitor, t = G.tribes[v.tribe] || {};
  const hostile = (t.tension || 0) >= TENSION_HOSTILE;
  const mine = v.mission && v.mission.power === G.nation;
  // The "+0x5236 posture byte" is RESOLVED 2026-08-29: func_04B308's row
  // gates read [visitor_type x 14 + 0x5236] -- the VISITOR's @UNIT
  // ATTACK column (the imul-14 chain @0x4B820..@0x4B838), not a tribe
  // field. Armed rows need attack != 0 and not a ship (@0x4B838/@0x4B883
  // with the 0xD..0x12 excludes); Live Among needs attack < 2; the
  // Attack row needs attack > 1 (context_dialogs.md par.6, corrected).
  const atk = u ? (Number((unit(u.type) || {}).attack) || 0) : 0;
  const armed = u && !u.ship && atk !== 0;
  const rows = [];
  rows.push({ id: hostile ? 1 : 0 });                       // r0 / r1, exclusive
  if (u && u.type === 'Missionaries' && !v.mission) rows.push({ id: 2 });
  if (v.mission && !mine) rows.push({ id: 3 });
  if (!hostile && u && u.type !== 'Scouts' && atk < 2) rows.push({ id: 4 });
  if (u && u.type === 'Scouts') rows.push({ id: 5 });
  if (armed) rows.push({ id: 6 });
  if (armed) rows.push({ id: 7 });
  if (u && !u.ship && atk > 1) rows.push({ id: 8 });
  rows.push({ id: 9 });
  return rows.map(r => ({ ...r, label: actionLabel(r.id) }));
}
function villageRowCount() {
  return villageActions().length;
}
function actionLabel(id) {
  const v = G.village;
  // Row 3's label carries the rival's name: "Denounce Heresy of %Fs Mission".
  if (id === 3 && v.mission) {
    const n = DATA.nations[v.mission.power];
    return DATA.actions[3].replace('%Fs', `${n ? n.adjective : 'foreign'}`);
  }
  return DATA.actions[id];
}
function runVillageAction(id) {
  const v = G.village, u = G.villageVisitor;
  switch (id) {
    case 0: case 1: openVillageTrade(v, u); return;
    case 2: G.screen = 'map'; G.village = null; establishMission(v, u); advance(); return;
    case 3: G.screen = 'map'; G.village = null; denounceHeresy(v, u); advance(); return;
    case 4: G.screen = 'map'; G.village = null; liveAmong(v, u); advance(); return;
    case 5: G.screen = 'map'; G.village = null; speakToChief(v, u); advance(); return;
    case 6: G.screen = 'map'; G.village = null; inciteIndians(v, u); advance(); return;
    case 7: G.screen = 'map'; G.village = null; demandTribute(v, u); advance(); return;
    case 8: G.screen = 'map'; G.village = null; attackVillage(v, u); return;
    default: G.screen = 'map'; G.village = null; advance(); return;   // 9 Cancel
  }
}

// ---- the village trade haggle (func_049600) -------------------------------
// The loop's first 186 bytes are disassembled; its tail (0x0496BA..0x04A37A,
// the round arithmetic) is NOT -- so structure and prices are cited and the
// three loop numbers are flagged stand-ins. Session order per the manual:
// sell-or-gift first, then the village offers its own goods to buy
// (@TRADE* -> @BUYWHICH -> @BUY*). Prices are §19.5's byte-cited formulas
// (villageOffer / villageAsk); the haggle BUDGET is §19.5's
// "random(1..rounds) + qty/4", rounds = min(3, (demand-want+4)/10), and the
// village walks away when it is spent. TBD stand-ins, flagged: each counter
// spends a flat 10 budget, the player's counter is quote+50% (sell) /
// quote-25% (buy), and the village moves halfway toward it per round.
// Latches: @BADHAGGLE0/1 lock the sell side PER GOOD, @BADHAGGLE2/3 lock the
// buy side; selling something of value clears the buy lock (the texts' own
// "until you bring us something of value").
function tradeSpeaker(v) { return `IND${v.tribe % 8}A${Math.min(3, villageBand(v))}`; }
function openVillageTrade(v, u) {
  // The anger refusals: @MADATWAGONS shuts trade entirely on the hostile
  // band; @MADATSHIPS distrusts SHIPS on the restless band ("approach us in
  // wagons ... we might trade"). The engine's bands are unread -- these are
  // the F9 thresholds, flagged.
  const t = G.tribes[v.tribe] || {};
  if ((t.tension || 0) >= TENSION_HOSTILE) {
    const laden = u && u.type === 'Wagon Train' && (u.hold || []).some(h => h.qty > 0);
    if (laden) {
      // @CONFISCATE: "we shall confiscate all the {goods} in these wagons."
      const h0 = u.hold.find(h => h.qty > 0);
      showEvent('CONFISCATE', { STRING0: t.name,
                                STRING1: DATA.cargo[h0.good].name }, tradeSpeaker(v));
      u.hold = [];
      return;
    }
    showEvent('MADATWAGONS', { STRING0: t.name }, tradeSpeaker(v));
    return;
  }
  if ((t.tension || 0) >= 40 && u && u.ship) {
    showEvent('MADATSHIPS', { STRING0: t.name }, tradeSpeaker(v));
    return;
  }
  if ((t.tension || 0) >= 40 && u && u.type === 'Wagon Train')
    showEvent('GRUDGEWAGONS', { STRING0: t.name }, tradeSpeaker(v));
  const cargo = ((u && u.hold) || []).filter(h => h.qty > 0);
  // an empty hold meets @DEFICIT and the visit ends (@0x49F0E -- the
  // engine reaches the buy-phase precheck with no sale and bails there);
  // @TRADENOCARGO is not this site's key.
  if (!cargo.length) { showEvent('DEFICIT', {}, tradeSpeaker(v)); return; }
  tradeSellPick(v, u);
}
function tradeSellPick(v, u) {
  const cargo = ((u && u.hold) || []).filter(h => h.qty > 0);
  if (!cargo.length) { tradeBuyPhase(v, u); return; }
  if (cargo.length === 1) { tradeSellOffer(v, u, cargo[0]); return; }
  // @TRADEWHICH heads a picker built from the hold, like @PICKACARGO; its
  // engine trigger is unestablished (audit L83), so >1 cargo is the binding.
  askEvent('TRADEWHICH', {}, (k) => {
    // cancel ends the session (@0x49845 -> @0x4A362) -- no buy phase.
    if (k >= 0 && k < cargo.length) tradeSellOffer(v, u, cargo[k]);
  }, cargo.map(h => `${h.qty} ${DATA.cargo[h.good].name}.`).concat(['Never mind.']),
     tradeSpeaker(v));
}
function tradeSellOffer(v, u, h) {
  const good = h.good, qty = h.qty, name = DATA.cargo[good].name;
  // settlement +0x07 is the single "walked away" memory: offering THAT good
  // again meets @BADHAGGLE1 (@0x49976); a sale or gift clears it to 0xFF
  // (@0x49BB3/@0x49E65). (The old per-good v.haggleSell latch is gone --
  // the byte model keeps ONE slot.)
  if (v.walkedGood === good) {
    showEvent('BADHAGGLE1', { STRING0: name }, tradeSpeaker(v));
    tradeBuyPhase(v, u, good); return;
  }
  const demand = villageDemand(v)[good] || 0;
  // "A village never buys the same good twice in a row -- muskets excepted"
  // (settlement +0x08 last_bought). The engine's 0xFF-exception check
  // compares the UNIT INDEX against 15/8 (@0x49BFD `cmp [bp+6],0xf`) -- an
  // authentic engine bug (the good was meant); the port keeps the intended
  // good semantics, noted in natives.md.
  if (v.lastBought === good && good !== 15) {
    const wantList = villageDemand(v).map((d, i) => [d, i])
      .filter(x => x[1] !== good).sort((a, b) => b[0] - a[0])
      .slice(0, 3).map(x => DATA.cargo[x[1]].name);
    showEvent('BADCARGO', { STRING0: name, STRING1: wantList[0] || '',
                            STRING2: wantList[1] || '', STRING3: wantList[2] || '' },
              tradeSpeaker(v));
    return;                      // @BADCARGO ends the session (@0x4996F)
  }
  if (demand <= 1) {
    showEvent('TRADENOWANT', { NUMBER0: qty, STRING0: name }, tradeSpeaker(v));
    tradeBuyPhase(v, u, good); return;
  }
  // -- the byte model of the session setup (@0x4999C..@0x49B02) --
  const q = sellQuote(v, good, qty);
  tradeSellRound(v, u, h, {
    offer: q.offer, round: 0, want: q.want, att: q.att,
    // haggle budget = random_int(0,1) + (want - att + 4)>>2   @0x49AB4
    budget: Math.floor(Math.random() * 2) + ((q.want - q.att + 4) >> 2),
    // ask ceiling = (want+1)*4 + the opening offer            @0x49AD1
    ceiling: (q.want + 1) * 4 + q.offer,
  });
}
// The sell rounds -- func_049600's @TRADE<n> loop, BYTE_VERIFIED 2026-08-29
// (@0x49B02..@0x49E4C). Rows: accept / haggle / gift (round 0 only) /
// never mind. There is NO player-named counter-price: a haggle asks the
// village to raise its OWN offer.
function tradeSellRound(v, u, h, st) {
  const good = h.good, qty = h.qty, name = DATA.cargo[good].name;
  // %STRING0 = the @VALUES quality ladder, index clamp3((want-att+4)/10)
  // (@0x49A96..@0x49AB0 -- the same numerator the budget shifts).
  const quality = (DATA.values || [])[
    Math.max(0, Math.min(3, Math.floor((st.want - st.att + 4) / 10)))] || '';
  askEvent(st.round === 0 ? 'TRADE0' : 'TRADE1',
           { STRING0: quality, STRING1: name, NUMBER0: st.offer, NUMBER1: st.ceiling },
           (k) => {
    const giftRow = st.round === 0 ? 2 : -1;
    if (k === 0) {
      // accept (@0x49B80): cargo out, gold in, village stock in, the walked
      // memory cleared, tension credit -2 x remaining budget (@0x49BD0).
      villageSell(v, good, qty, st.offer, -2 * Math.max(0, st.budget));
      holdAdd(u, good, -qty);
      v.walkedGood = undefined;
      v.lastBought = good === 15 || good === 8 ? undefined : good;
      tradeBuyPhase(v, u, good); return;
    }
    if (k === 1) {
      // haggle (@0x49D76): while budget lasts, the village folds when
      // random_int(1, 8 x budget) > difficulty -- one budget point per
      // fold -- and raises its offer by
      // random_int(want/2+1, 2*want+1) x qty/100 (min 1) (@0x49DA0..);
      // at the ceiling the ceiling stretches +10 (@0x49DDC).
      if (st.budget > 0 &&
          1 + Math.floor(Math.random() * (8 * st.budget)) > G.difficulty) {
        st.budget -= 1;
        const lo = (st.want >> 1) + 1, hi = 2 * st.want + 1;
        const bump = Math.max(1, Math.floor(
          (lo + Math.floor(Math.random() * (hi - lo + 1))) * qty / 100));
        st.offer += bump;
        if (st.offer >= st.ceiling) st.ceiling = st.offer + 10;
        st.round = 1;
        tradeSellRound(v, u, h, st); return;
      }
      // the walk-away (@0x49DFE): the village remembers the good
      // (settlement +0x07), tension rises att/2+1, and the session ENDS
      // (the buy phase is skipped, [bp-0xc4]=0). @BADHAGGLE0's emit is
      // gated on a relation-0x40 test in the engine (@0x49E21) the port
      // has no tribe analogue for -- shown unconditionally, flagged.
      v.walkedGood = good;
      adjustTension(v.tribe, (st.att >> 1) + 1);
      showEvent('BADHAGGLE0', { STRING1: name }, tradeSpeaker(v));
      return;
    }
    if (k === giftRow) {
      // gift (@0x49E4C, round 0 only): tension credit -4 x (budget+1)
      // (@0x49E8D), alarm drops DOUBLE the quantity (@0x49EAC, 100-load
      // zeroes), counters as a sale, then on to the buy phase.
      villageGift(v, good, qty, -4 * (Math.max(0, st.budget) + 1));
      holdAdd(u, good, -qty);
      v.walkedGood = undefined;
      v.lastBought = good === 15 || good === 8 ? undefined : good;
      tradeBuyPhase(v, u, good); return;
    }
    // never mind (@0x49B7D -> @0x49E42): the session ends -- no buy phase.
  }, undefined, tradeSpeaker(v));
}
// The buy phase -- @0x49C72..@0x4A362. Entered only off a completed sale
// or gift; needs a free cargo slot (@UNIT cargo column vs load @0x49C92).
function tradeBuyPhase(v, u, soldGood) {
  const cap = Number((unit(u.type) || {}).cargo) || 0;
  const used = ((u.cargo || []).length + (u.hold || []).length);
  if (cap - used < 1) return;
  // the insult latch shares settlement +0x07 with the walked-good memory:
  // 0xFE there means @BADHAGGLE3 (@0x49D5E)
  if (v.walkedGood === 'insult') {
    showEvent('BADHAGGLE3', {}, tradeSpeaker(v)); return;
  }
  // @BRING (@0x49CF0..@0x49D52): when the sold good is not among the top
  // two wants, the village names its want trio.
  const wants = villageDemand(v).map((n, i) => [n, i]).sort((a, b) => b[0] - a[0]);
  if (soldGood !== undefined &&
      wants[0][1] !== soldGood && wants[1][1] !== soldGood) {
    showEvent('BRING', { STRING0: DATA.cargo[wants[0][1]].name,
                         STRING1: DATA.cargo[wants[1][1]].name,
                         STRING2: DATA.cargo[wants[2][1]].name },
              tradeSpeaker(v));
  }
  const offers = villageSurplus(v);
  if (!offers.length) return;
  const names = offers.map(r => DATA.cargo[r.good].name);
  askEvent('BUYWHICH',
           { STRING0: names[0] || '', STRING1: names[1] || '', STRING2: names[2] || '' },
           (k) => { if (k >= 0 && k < offers.length) tradeBuyOffer(v, u, offers[k]); },
           undefined, tradeSpeaker(v));
}
function tradeBuyOffer(v, u, r) {
  // The load is clamped to the hold the way the transfer executor clamps.
  const cap = Number((unit(u.type) || {}).cargo) || 0;
  const slot = (u.hold || []).find(x => x.good === r.good);
  const used = (u.cargo || []).length + (u.hold || []).length;
  const space = Math.max(0, cap - used) * 100 + (slot ? Math.max(0, 100 - slot.qty) : 0);
  // ships carry away a QUARTER load (@0x4A012 `sar [0x8dc4],2` for types
  // 0xD..0x12).
  const qty = Math.min(u.ship ? r.qty >> 2 : r.qty, space);
  if (qty <= 0) return;
  const demand = villageDemand(v)[r.good] || 0;
  const ask = villageAsk(v, r.good, qty);
  tradeBuyRound(v, u, r.good, qty, {
    ask, round: 0, demand,
    // floor = max(10, ask/2), step = max(1, ask/4)  @0x4A15F..@0x4A17E
    floor: Math.max(10, ask >> 1), step: Math.max(1, ask >> 2),
  });
}
// The buy rounds -- @0x4A144..@0x4A34C. Rows: pay / haggle / never mind.
function tradeBuyRound(v, u, good, qty, st) {
  askEvent(st.round === 0 ? 'BUY0' : 'BUY1',
           { STRING0: DATA.cargo[good].name, STRING1: u.type, NUMBER0: st.ask,
             NUMBER1: st.floor, NUMBER2: qty, NUMBER3: G.gold },
           (k) => {
    if (k === 0) {
      // pay (@0x4A1C8): short of gold -> @NOTENOUGH and tension +1
      // (@0x4A24E); else pay, stock out, cargo in, the rum exception on
      // the last-sold memory (settlement +0x09, @0x4A1F2), tension
      // credit -random_int(0, ask/25 + 1) (@0x4A21D).
      if (st.ask > G.gold) {
        showEvent('NOTENOUGH', { NUMBER0: G.gold }, tradeSpeaker(v));
        adjustTension(v.tribe, 1);
        return;
      }
      villageBuy(v, good, qty, st.ask);
      u.hold = u.hold || [];
      holdAdd(u, good, qty);
      v.lastSold = good === 9 ? undefined : good;
      adjustTension(v.tribe,
        -Math.floor(Math.random() * (Math.floor(st.ask / 25) + 2)));
      return;
    }
    if (k === 1) {
      // haggle (@0x4A27E): the village folds when
      // random_int(0, demand/25 + 8) > difficulty+1 and the ask is still
      // above 10 -- dropping one step (floor 10), with a
      // 1-in-(8-difficulty) chance of tension +1 (@0x4A2CA); otherwise
      // tension +2, the INSULT latch (settlement +0x07 = 0xFE) and
      // @BADHAGGLE2 end the session (@0x4A30E).
      const roll = Math.floor(Math.random() * (Math.floor(st.demand / 25) + 9));
      if (st.ask > 10 && roll > G.difficulty + 1) {
        st.ask = Math.max(10, st.ask - st.step);
        if (1 + Math.floor(Math.random() * (8 - G.difficulty)) === 1)
          adjustTension(v.tribe, 1);
        st.round = 1;
        tradeBuyRound(v, u, good, qty, st); return;
      }
      adjustTension(v.tribe, 2);
      v.walkedGood = 'insult';            /* settlement +0x07 = 0xFE */
      showEvent('BADHAGGLE2', {}, tradeSpeaker(v));
      return;
    }
  }, undefined, tradeSpeaker(v));
}
// The village interaction is a §3 POPUP over the map, not a screen of its own
// (spec/ui/context_dialogs.md §6: the enabled rows are sized by §2 and run by
// §3, func_06E3D0). The greeting is the popup's body block -- one of the five
// GAME.TXT @VILLAGE* bodies, banded by attitude -- and the chief speaks through
// the tribe channel [0x1F5C] -> IND<tribe>A<pose>.SS (popups.md §2.7). The
// engine's exact portrait position is NOT traced (§2.7.1: no box-relative
// formula survives; it would need a running capture), so it takes the same
// centred-above-the-box placement the economic adviser uses.
const VILLAGE_GREETING = ['VILLAGEHAPPY', 'VILLAGEMEDIUM', 'VILLAGESAVAGE',
                          'VILLAGEBAD', 'VILLAGEWAR'];
function villageBand(v) {
  // Band 4 (War) is the alarm >= 128 state, not a tension band.
  return (v.alarm || 0) >= ALARM_RAID ? 4 : missionBand(v);
}
function villageBody() {
  const v = G.village, t = G.tribes[v.tribe];
  const e = DATA.events[VILLAGE_GREETING[villageBand(v)]];
  const lines = (e ? e.body : ['']).map(l => l
    .replace('%STRING0', DATA.levelname[v.level])
    .replace(/%STRING1/g, t.name));
  if (v.mission) {
    const n = DATA.nations[v.mission.power];
    lines.push(`A {${n ? n.adjective : 'foreign'}} mission stands here` +
               `${v.mission.expert ? ' (expert)' : ''}.`);
  }
  return lines;
}
function villageBox() {
  const rows = villageActions();
  const body = villageBody();
  let cw = 190;                                   // @width=190 on the @VILLAGE* keys
  for (const l of body) cw = Math.max(cw, DFONT().width(l));
  for (const r of rows)
    cw = Math.max(cw, DFONT().width(r.label) + DFONT().width(r.note || '') + 20);
  const w = cw + 6, textH = body.length * DTEXT;
  const h = 6 + textH + 3 + rows.length * DROW + 3;
  // Box placement is the byte-cited builder math: centred, X = 160 - W/2. The
  // chief stands behind it at the bottom-right (his own position is untraced,
  // §2.7.1), so the box overlaps him rather than being squeezed beside him.
  return { x: Math.round(160 - w / 2), y: Math.max(10, Math.round(100 - h / 2)),
           w, h, textH, body, rows };
}
function villageSpeaker() {
  const v = G.village;
  return `IND${v.tribe % 8}A${Math.min(3, villageBand(v))}`;
}
function drawVillage(ctx) {
  drawMap(ctx);                                   // the map stays underneath
  const b = villageBox();
  const sheet = villageSpeaker();
  const [pw, ph] = frameSize(sheet, 0);
  if (pw) sheetFrame(ctx, sheet, 0, W - pw, H - ph);
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  b.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * DTEXT,
                                    0xFE, 0xFC, DFONT()));
  const seed = b.y + 6 + b.textH + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * DROW, sel = k === G.villageRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, DROW - 2); }
    DFONT().draw(ctx, r.label, b.x + 9, y + 1, lut(sel ? 0xFC : 0xFE));
    if (r.note) DFONT().draw(ctx, r.note, b.x + b.w - 9 - DFONT().width(r.note),
                             y + 1, lut(sel ? 0xFC : 0x0E));
  });
}
function villageCommit() {
  // Trade rows no longer live in this menu: rows 0/1 open the haggle popup
  // chain (openVillageTrade) and everything runs through askEvent from there.
  const a = villageActions()[G.villageRow];
  if (a) runVillageAction(a.id);
}

// ------------------------------------------------------------ combat
// §14. One attack, one roll over two fully modified strengths.
//
//  base            @UNIT combat column; carriers add the attack column;
//                  a damaged ship takes -2
//  terrain/fort    strength*(bonus+4)/4 * 3/2, where bonus accumulates
//                  colony +2, fortified +4, river/road +(n+1)*2 and the
//                  terrain's own Defensive value
//  handicap        a HUMAN combatant gets += (4 - difficulty) on BOTH sides
//  colony          defender on a colony tile: +50%
//  SoL             strength * SoL%/100
//  difficulty      strength * difficulty/20
//  roll            random_int(1, ATK+DEF); the attacker wins iff roll <= ATK
//
// Step 8 of §14.3 -- RESOLVED 2026-08-29: the "further doubling" is the
// NATIVE SETTLEMENT branch of the tile-defence filler func_007D3E
// (@0x7D8B: a settlement on the tile takes its own EXCLUSIVE branch --
// base 2, owning tribe tech level >= 2 -> 4 (@0x7DB5), and the CAPITAL
// flag (settlement +0x03 & 4) DOUBLES it (@0x7DCA..@0x7DD4, the [0x8D02]
// 0x20 flag). Not a difficulty gate at all. defenceBonus below carries
// the branch; the filler's other branches are exclusive too (settlement
// > feature > terrain, each jmp @0x7EFE) -- the port's additive shape
// for the European cases stays, flagged.
function terrainDefence(v) {
  let t = v & 0x1F;
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  const d = DATA.defensive;
  const row = t <= 7 ? d.unforested[t] : t <= 15 ? d.forested[t - 8] : d.other[t - 24];
  return row || 0;
}
function defenceBonus(u) {
  // func_007D3E's settlement branch (exclusive, @0x7D8D..@0x7DD9):
  // 2 / 4 at tribe tech >= 2 / x2 for the capital.
  const vil = G.villages.find(w => w.x === u.x && w.y === u.y);
  if (vil) {
    let b = ((G.tribes[vil.tribe] || {}).level || 0) >= 2 ? 4 : 2;
    if (vil.capital) b *= 2;
    return b;
  }
  let bonus = terrainDefence(at(u.x, u.y));
  if (colonyAt(u.x, u.y)) bonus += 2;
  if (u.orders === 5 || u.orders === 6) bonus += 4;      // Fortify / Fortified
  if (tileRiver(at(u.x, u.y))) bonus += 2;
  return bonus;
}
// §14.1-14.3. The chain is run ONCE and itemised as it goes, because the
// Combat Analysis dialog (§14.4) prints exactly the modifiers that drove it --
// one row per modifier that fires, labelled from LABELS.TXT @MISC.
//   @MISC 62 Cargo   65 Veteran   76 Fatigue   77 Attack Bonus   78 Ambush
//        79 Terrain  80 Colony    81 Fortified 82 Spain Bonus    84 Artillery
//        In Open     90 Drake     104 Bombard  129 Artillery Vs. Raid
//        132 Tory Unrest  133 Rebel Unrest
const MISC = (n) => (DATA.text.misc[n] || '').trim();
function combatAnalysis(u, isDefender) {
  const t = unit(u.type);
  const rows = [];
  if (!t) return { base: 1, rows, total: 1 };
  // §14.1: base is the combat column, carriers add the attack column, and a
  // damaged ship takes -2.
  let s = t.combat + (t.cargo && t.hull ? t.attack : 0);
  if (u.damaged) s -= 2;
  const base = Math.max(1, s);
  s = base;
  // A veteran fights at +50%.
  if (u.profession === 'Veteran Soldiers' || u.profession === 'Veteran Dragoons' ||
      u.veteran) {
    rows.push({ label: MISC(65), value: '+50%' });
    s = Math.floor(s * 3 / 2);
  }
  // Fatigue: attacking with troops that have already spent their moves costs
  // a third of their strength, and two thirds if they are truly spent. The
  // @HALF prompt below offers the choice before the roll.
  if (u.fatigue) {
    rows.push({ label: MISC(76), value: u.fatigue === 2 ? '-66%' : '-33%' });
    s = Math.floor(s * (u.fatigue === 2 ? 1 : 2) / 3);
  }
  // Cargo aboard costs -12.5% per used hold.
  const holds = (u.cargo ? u.cargo.length : 0) + (u.hold ? u.hold.length : 0);
  if (holds) {
    rows.push({ label: MISC(62), value: `-${holds * 12}%` });
    s = Math.floor(s * (8 - Math.min(8, holds)) / 8);
  }
  // §14.3 step 1: the accumulated terrain/fort bonus, then the flat 3/2.
  const terr = terrainDefence(at(u.x, u.y));
  if (terr) {
    rows.push({ label: MISC(isDefender ? 79 : 78), value: `+${terr * 25}%` });
  }
  s = Math.floor(Math.floor(s * (defenceBonus(u) + 4) / 4) * 3 / 2);
  // §14.3 step 2: the difficulty handicap, applied to BOTH sides.
  s += (4 - G.difficulty);
  // §14.3 step 4: a colony on the defending tile.
  if (isDefender && colonyAt(u.x, u.y)) {
    const c = colonyAt(u.x, u.y);
    rows.push({ label: MISC(80), value: `+${(colonyLevel(c) + 1) * 50}%` });
    s = Math.floor(s * 3 / 2);
  }
  // Fortified.
  if (u.orders === 5 || u.orders === 6) {
    rows.push({ label: MISC(81), value: '+50%' });
    s = Math.floor(s * 3 / 2);
  }
  // Artillery caught in the open defends at a quarter.
  if (isDefender && u.type === 'Artillery' && !colonyAt(u.x, u.y)) {
    rows.push({ label: MISC(84), value: '-75%' });
    s = Math.floor(s / 4);
  }
  // Sir Francis Drake's privateers.
  if (u.type === 'Privateer' && G.fathersOwned.includes('Francis Drake')) {
    rows.push({ label: MISC(90), value: '+50%' });
    s = Math.floor(s * 3 / 2);
  }
  // Spain's bonus against the natives.
  if (G.nation === 2 && u.nation === G.nation && isDefender === false) {
    rows.push({ label: MISC(82), value: '+50%' });
    s = Math.floor(s * 3 / 2);
  }
  // §14.3 step 5: wartime bombardment of the King's landed force.
  if ((G.flags & WOI_DECLARED) && u.nation === -2) {
    rows.push({ label: MISC(104), value: '+50%' });
    s = Math.floor(s * 3 / 2);
  }
  // Tory / Rebel unrest, off the colony the unit stands in.
  const home = colonyAt(u.x, u.y);
  if (home) {
    if (home.sol >= 50) rows.push({ label: MISC(133), value: `+${home.sol}%` });
    else rows.push({ label: MISC(132), value: `-${100 - home.sol}%` });
  }
  // §14.3 step 7.
  s += Math.floor(s * G.difficulty / 20);
  return { base, rows, total: Math.max(1, s) };
}
function combatStrength(u, isDefender) { return combatAnalysis(u, isDefender).total; }
// ---------------------------------------------------------- naval combat
// §14.5. Ship-vs-ship does NOT run the modifier chain: the roll uses the RAW
// guns/hull columns -- `roll = random_int(1, guns_A + hull_D)`. Only Privateers
// and Frigates may START a ship attack (@SHIPCOMBAT). A sinking ship carrying
// cargo scatters it (@CARGOCAPTURE on seizure).
const SHIP_ATTACKERS = ['Privateer', 'Frigate', 'Man-O-War'];
function navalAttack(att, def) {
  if (!SHIP_ATTACKERS.includes(att.type)) { showEvent('SHIPCOMBAT', {}); return false; }
  const A = unit(att.type).attack || unit(att.type).combat;
  const D = unit(def.type).hull || unit(def.type).combat;
  const win = 1 + Math.floor(Math.random() * (A + D)) <= A;
  // @EVASIVE: "%STRING0 %STRING1 evades %STRING2 %STRING3." The engine's
  // evade condition is unmapped (COLONIZATION_TECHNICAL_REFERENCE §14.6) --
  // the port's flagged stand-in: a gunless ship (not a SHIP_ATTACKER) that
  // survives the roll ESCAPES rather than damaging the attacker.
  if (!win && !SHIP_ATTACKERS.includes(def.type)) {
    showEvent('EVASIVE', { STRING0: ownerAdjective(def), STRING1: def.type,
                           STRING2: ownerAdjective(att), STRING3: att.type });
    att.movesLeft = 0;
    return true;
  }
  const loser = win ? def : att, winner = win ? att : def;
  // A hold going down is seized rather than simply lost -- and a MULTI-slot
  // hold runs @PICKACARGO ("Which cargo shall we capture?") first.
  const spoils = (loser.hold || []).filter(h => h.qty > 0);
  const seize = (h) => {
    showEvent('CARGOCAPTURE', { STRING0: ownerAdjective(loser),
                                NUMBER0: h.qty, STRING1: DATA.cargo[h.good].name,
                                STRING2: ownerAdjective(winner), STRING3: winner.type });
    holdAdd(winner, h.good, h.qty);
  };
  if (spoils.length && loser.damaged) {
    if (spoils.length === 1 || winner.nation !== G.nation) seize(spoils[0]);
    else askEvent('PICKACARGO', {}, (k) => {
      seize(spoils[k >= 0 && k < spoils.length ? k : 0]);
    }, spoils.map(h => `${h.qty} ${DATA.cargo[h.good].name}`));
  }
  applyDefeat(loser, winner);
  att.movesLeft = 0;
  return true;
}
// Shore fire from a colony's fort is DETERMINISTIC -- no roll:
//   strength = artillery in the colony x fort level x 4
// A ship of a power you are at war with that ends its move beside the colony
// takes it (@FORTFIRE).
function shoreBombardment() {
  for (const c of G.colonies) {
    const level = colonyLevel(c);
    if (!level) continue;
    const guns = G.units.filter(u => u.type === 'Artillery' && u.x === c.x && u.y === c.y).length;
    if (!guns) continue;
    const strength = guns * level * 4;
    for (const r of G.rivals) {
      if (!atWar(G.nation, r.nation)) continue;
      const ship = r.units.find(u => u.ship &&
        Math.abs(u.x - c.x) <= 1 && Math.abs(u.y - c.y) <= 1);
      if (!ship || !strength) continue;
      showEvent('FORTFIRE', { STRING0: level >= 2 ? 'Fortress guns' : 'Fort guns',
                              STRING1: c.name, STRING2: ownerAdjective(ship),
                              STRING3: ship.type });
      if (!ship.damaged) ship.damaged = true;
      else r.units.splice(r.units.indexOf(ship), 1);
      return;
    }
  }
}

// -------------------------------------------------------- scout at a colony
// spec/systems/exploration.md §3, func_05A20E: a FOUR-option @SCOUTCOLONY
// dialog. Meet With Mayor is blocked during the revolution
// (@NOMAYORSDURINGREV). Infiltrate succeeds on random_int(1,36) <= (X+6)*2,
// HALVED for a Seasoned Scout, with +(difficulty-2) against a human target;
// success reveals the colony, failure loses the scout.
function scoutColony(u, target, name) {
  askEvent('SCOUTCOLONY', { STRING0: name }, (choice) => {
    if (choice === 3 || choice < 0) return;
    if (choice === 0) {
      if (G.flags & WOI_DECLARED) { showEvent('NOMAYORSDURINGREV', {}); return; }
      reveal(target.x, target.y, 3);
      G.msg = `The mayor of ${name} receives our scout.`;
      return;
    }
    if (choice === 1) {
      const X = (target.colonists ? target.colonists.length : 3);
      let need = (X + 6) * 2 + (G.difficulty - 2);
      if (u.profession === 'Seasoned Scouts') need = need >> 1;
      if (1 + Math.floor(Math.random() * 36) <= need) {
        reveal(target.x, target.y, 4);
        G.msg = `Our scout returns with a full account of ${name}.`;
      } else {
        removeUnit(u);
        G.msg = 'Our scout was caught and is lost.';
      }
      return;
    }
    // Attack Colony.
    G.msg = `${name} is defended.`;
  });
}

// -------------------------------------------- the War of the Spanish Succession
// func_03C638. Single-player only. It ranks the four powers, picks the WEAKEST
// eligible AI as the ceding power and the STRONGEST as the beneficiary, then
// transfers every map tile, unit and colony from one to the other -- the Treaty
// of Utrecht. The dispatcher calls it while the national SoL meter is BELOW 75
// and no power has seceded yet.
function powerStrength(r) {
  return (r.colonies ? r.colonies.length * 3 : 0) + (r.units ? r.units.length : 0);
}
function spanishSuccession() {
  if (G.succession) return;
  if (G.flags & WOI_DECLARED) return;
  if (nationalSoL() >= 75) return;
  const live = G.rivals.filter(r => r.met !== undefined);
  if (live.length < 2) return;
  if (Math.floor(Math.random() * 600) !== 0) return;      // rare; the cadence is the port's
  const sorted = live.slice().sort((a, b) => powerStrength(a) - powerStrength(b));
  const ceding = sorted[0], winner = sorted[sorted.length - 1];
  if (ceding === winner) return;
  G.succession = true;
  showEvent('SUCCESSION', { STRING0: DATA.nations[ceding.nation].country,
                            STRING1: DATA.nations[ceding.nation].adjective,
                            STRING2: DATA.nations[winner.nation].adjective,
                            STRING3: DATA.nations[ceding.nation].adjective });
  // The full asset transfer, loser to winner.
  for (const c of ceding.colonies) { c.nation = winner.nation; winner.colonies.push(c); }
  for (const u of ceding.units) { u.nation = winner.nation; winner.units.push(u); }
  ceding.colonies = []; ceding.units = [];
  ceding.dead = true;
}

// ------------------------------------------------- the combat aftermath
// §14.6, apply_combat_result. A defeated land unit does NOT simply die.
//
// THE DEMOTION LADDER: it falls one rung instead. A demoted-to-Colonist with
// the Missionary profession becomes a Missionaries unit instead, and a Veteran
// Soldier loses veteran status on the way down (@DEMOTE / @COLONISTCAPTURE2).
const DEMOTES_TO = {
  'Dragoons': 'Soldiers',
  'Soldiers': 'Colonists',
  'Cont. Cav.': 'Cont. Army',
  'Cavalry': 'Regulars',
  'Cont. Army': 'Colonists',
};
// CAPTURE INSTEAD OF DEATH: only these three types are capture-eligible, and
// only from a European owner.
const CAPTURABLE = { 'Colonists': 'COLONISTCAPTURE', 'Treasure': 'LOOTCAPTURE',
                     'Wagon Train': 'WAGONCAPTURE' };
const ownerAdjective = (u) => u.nation >= 0 && DATA.nations[u.nation]
  ? DATA.nations[u.nation].adjective
  : u.tribe !== undefined && G.tribes[u.tribe] ? G.tribes[u.tribe].name : 'the King';
function removeUnit(u) {
  const i = G.units.indexOf(u);
  if (i >= 0) { G.units.splice(i, 1); if (G.sel >= G.units.length) G.sel = 0; }
  const k = G.refUnits.indexOf(u);
  if (k >= 0) G.refUnits.splice(k, 1);
  for (const r of G.rivals) {
    const m = r.units.indexOf(u);
    if (m >= 0) r.units.splice(m, 1);
  }
  const j = G.natives.indexOf(u);
  if (j >= 0) {
    // §19.11: a brave's death stamps its village's rebuild request (flags 0x01);
    // the next 20-tick produces the replacement instead of growth.
    if (u.home) u.home.braveOwed = true;
    G.natives.splice(j, 1);
  }
}
function becomeType(u, name) {
  const t = unit(name);
  if (!t) return;
  u.type = t.name; u.icon = t.icon;
  u.moves = t.movement * MOVE_UNIT;
  u.movesLeft = Math.min(u.movesLeft, u.moves);
  u.ship = t.hull > 0;
}
// The whole aftermath for one loser. Returns nothing; it mutates the world.
function applyDefeat(loser, winner) {
  // @HOWTOWIN: the one-shot "road to freedom" strategy card, after the
  // player's first victory over the King's forces.
  if (loser.nation === -2 && winner.nation === G.nation && !G.howToWon) {
    G.howToWon = true;
    showEvent('HOWTOWIN');
  }
  const t = unit(loser.type);
  const S = { STRING0: ownerAdjective(loser), STRING1: loser.type,
              STRING2: '', STRING3: winner.type };
  // SHIPS: damaged first, sunk only if already damaged.
  if (t && t.hull > 0) {
    if (!loser.damaged) {
      loser.damaged = true;
      showEvent('SHIPDAMAGE', { ...S, STRING2: DATA.nations[G.nation].homeport });
      return;
    }
    removeUnit(loser);
    showEvent('SHIPSUNK', { ...S, STRING2: ownerAdjective(winner), STRING3: winner.type });
    return;
  }
  // ARTILLERY: a loss flips it to Damaged; a damaged piece that loses again is
  // destroyed.
  if (loser.type === 'Artillery') {
    if (!loser.damaged) {
      loser.damaged = true;
      showEvent('ARTILLERY', S);
      return;
    }
    removeUnit(loser);
    showEvent('ARTILLERY2', S);
    return;
  }
  // CAPTURE: Colonists, Treasure and Wagon Trains change hands intact rather
  // than dying -- but only from a European owner.
  const capKey = CAPTURABLE[loser.type];
  if (capKey && loser.nation >= 0) {
    const veteranLost = loser.profession === 'Veteran Soldiers';
    loser.nation = winner.nation;
    loser.orders = 0;
    if (veteranLost) loser.profession = null;
    // A captured unit passes to the winner's side of the world.
    removeUnit(loser);
    if (winner.nation === G.nation) G.units.push(loser);
    else if (winner.nation === -2) G.refUnits.push(loser);
    else G.natives.push(loser);
    if (winner.nation === -2) {
      // @SEIZURELAND / @SEIZURESEA: the Crown's own captures.
      showEvent(loser.ship ? 'SEIZURESEA' : 'SEIZURELAND',
                { STRING0: loser.type });
      return;
    }
    const key = (capKey === 'COLONISTCAPTURE' && veteranLost) ? 'COLONISTCAPTURE2' : capKey;
    showEvent(key, { STRING0: S.STRING0, STRING1: ownerAdjective(winner),
                     NUMBER0: (loser.treasure || 0) * 100 });
    return;
  }
  // THE DEMOTION LADDER.
  const down = DEMOTES_TO[loser.type];
  // @LOSTOURSCOUTS: a Scout party captured by the tribe.
  if (loser.type === 'Scouts' && loser.nation === G.nation &&
      winner.tribe !== undefined) {
    const wt2 = G.tribes[winner.tribe];
    const near2 = G.colonies[0];
    G.eventTribe = winner.tribe;
    showEvent('LOSTOURSCOUTS', { STRING0: (wt2 && wt2.name) || '',
                                 STRING1: near2 ? near2.name : DATA.regionname[G.nation] });
  }
  // @LOSTTHEIRSCOUTS: taking a rival's Scouts yields their horses (50 --
  // the equip quantum, flagged).
  if (loser.type === 'Scouts' && loser.nation >= 0 &&
      loser.nation !== G.nation && winner.nation === G.nation) {
    const c2 = G.colonies[0];
    if (c2) c2.stock[GOOD.HORSES] += EQUIP_HORSES;
    showEvent('LOSTTHEIRSCOUTS', { STRING0: ownerAdjective(loser),
                                   STRING1: c2 ? c2.name : DATA.regionname[G.nation],
                                   NUMBER0: EQUIP_HORSES });
  }
  // @INDIANWIN0/1/2: braves ambush the player's men -- Muskets/Horses seized
  // by the demotion from Soldiers/Dragoons, the plain body otherwise. The
  // engine's fills: STRING0 tribe, STRING1/2 the victim, STRING3 the place,
  // STRING4 the tribe again.
  if (down && loser.nation === G.nation && winner.tribe !== undefined) {
    const wt = G.tribes[winner.tribe];
    const place = G.colonies.slice().sort((a, b) =>
      (Math.abs(a.x - loser.x) + Math.abs(a.y - loser.y)) -
      (Math.abs(b.x - loser.x) + Math.abs(b.y - loser.y)))[0];
    const key = loser.type === 'Soldiers' ? 'INDIANWIN1'
              : loser.type === 'Dragoons' ? 'INDIANWIN2' : 'INDIANWIN0';
    G.eventTribe = winner.tribe;
    showEvent(key, { STRING0: (wt && wt.name) || '', STRING1: S.STRING0,
                     STRING2: loser.type,
                     STRING3: place ? place.name : DATA.regionname[G.nation],
                     STRING4: (wt && wt.name) || '' });
  }
  if (down) {
    const wasVeteran = loser.profession === 'Veteran Soldiers' ||
                       loser.profession === 'Veteran Dragoons';
    // A demoted-to-Colonist carrying the Missionary profession becomes a
    // Missionaries unit instead of a plain colonist.
    if (down === 'Colonists' && loser.profession === 'Jesuit Missionaries')
      becomeType(loser, 'Missionaries');
    else becomeType(loser, down);
    if (wasVeteran) loser.profession = null;              // veteran status is lost
    showEvent('DEMOTE', { STRING0: S.STRING0, STRING1: S.STRING1, STRING2: loser.type });
    return;
  }
  removeUnit(loser);
  G.msg = `${loser.type} destroyed.`;
}
// PROMOTION, §14.6: P = winner_strength / (ATK + DEF +/- difficulty - class
// penalty), rolled as random_int(1, S); a human gets +difficulty, an AI -it,
// and Petty Criminals cost 10, Indentured Servants 5. George Washington skips
// the roll entirely. The class ladder walks the winner up one rung; at the
// soldier ceiling the unit TYPE advances instead.
const RANK_LADDER = { 'Petty Criminals': 'Indentured Servants',
                      'Indentured Servants': 'Free Colonists',
                      'Free Colonists': 'Veteran Soldiers',
                      null: 'Veteran Soldiers' };
function tryPromote(winner, wStrength, total) {
  if (winner.nation !== G.nation) return;                 // only your own men
  const penalty = winner.profession === 'Petty Criminals' ? 10
                : winner.profession === 'Indentured Servants' ? 5 : 0;
  const S = Math.max(1, total + G.difficulty - penalty);
  const auto = G.fathersOwned.includes('George Washington');
  if (!auto && 1 + Math.floor(Math.random() * S) > wStrength) return;
  // A Scout hardens to Seasoned rather than climbing the soldier ladder.
  if (winner.type === 'Scouts' && winner.profession !== 'Seasoned Scouts') {
    winner.profession = 'Seasoned Scouts';
    showEvent('WELLSEASONED', {});
    return;
  }
  const from = winner.profession;
  const next = RANK_LADDER[from === undefined ? null : from];
  if (next && from !== 'Veteran Soldiers') {
    winner.profession = next;
    if (next === 'Veteran Soldiers') showEvent('VETERAN', { STRING0: winner.type });
    else showEvent('VALOR', { STRING0: DATA.nations[G.nation].adjective,
                              STRING1: from || 'Free Colonists', STRING2: next });
    return;
  }
  // At the ceiling the TYPE advances -- but only once the war has begun, which
  // is what a Continental Army is.
  if ((G.flags & WOI_DECLARED) && CONTINENTAL_OF[winner.type]) {
    const to = CONTINENTAL_OF[winner.type];
    const from = winner.type;
    becomeType(winner, to);
    // @CONTINENTAL "Our {Veteran %STRING0} have hardened to {Continental
    // Army} status" -- the type-advance has its own key, not @VALOR.
    showEvent('CONTINENTAL', { STRING0: from });
  }
}
// The attacker wins iff roll <= ATK.
function resolveAttack(att, def) {
  const AA = combatAnalysis(att, false), DD = combatAnalysis(def, true);
  const A = AA.total, D = DD.total;
  const roll = 1 + Math.floor(Math.random() * (A + D));
  const win = roll <= A;
  // §14.4: the Combat Analysis dialog itemises the modifiers that drove the
  // roll. The engine shows it after the roll but BEFORE resolution renders;
  // the port applies the result first and then shows the same numbers over the
  // map, which changes nothing about the arithmetic. Flagged in the tracker.
  if (G.combatAnalysis) {
    G.combat = { att: { type: att.type, icon: unitIconOf(att), ...AA },
                 def: { type: def.type, icon: unitIconOf(def), ...DD },
                 roll, win };
  }
  const loser = win ? def : att, winner = win ? att : def;
  applyDefeat(loser, winner);
  tryPromote(winner, win ? A : D, A + D);
  // The winner takes the emptied tile.
  if (win && !colonyAt(def.x, def.y) && !G.units.some(u => u.x === def.x && u.y === def.y)
      && !G.natives.some(u => u.x === def.x && u.y === def.y)
      && !G.refUnits.some(u => u.x === def.x && u.y === def.y)) {
    att.x = def.x; att.y = def.y;
  }
  att.movesLeft = 0;
  return { A, D, roll, win };
}

// ------------------------------------------------- Combat Analysis dialog
// spec/ui/combat_analysis.md (func_05E9B0, page 0x11). Byte-cited geometry:
// x = 53, w = 214, h = rows*20 + 6, VERTICALLY CENTRED; the title is
// "COMBAT ANALYSIS" (LABELS @MISC 75); the attacker column pens at x = 56 and
// the defender at x = 160, each value right-aligned at col_x + 0x50 (+80);
// row pitch 20. Each column shows its unit sprite and then one row per
// modifier that fired.
const CA = { x: 53, w: 214, colA: 56, colB: 160, valOff: 0x50, pitch: 20 };
function combatBox() {
  const c = G.combat;
  const rows = 1 + Math.max(c.att.rows.length, c.def.rows.length) + 1;  // head + mods + total
  const h = rows * CA.pitch + 6;
  return { x: CA.x, y: Math.round(100 - h / 2), w: CA.w, h, rows };
}
function drawCombat(ctx) {
  const c = G.combat;
  if (!c) return;
  const b = combatBox();
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  FONT.tiny.center(ctx, MISC(75), 160, b.y + 3, lut(0xFC));
  const cols = [[CA.colA, c.att], [CA.colB, c.def]];
  for (const [cx, side] of cols) {
    // The unit itself, over its name and base strength.
    const [fw, fh] = frameSize('ICONS', side.icon);
    if (fw) sheetFrame(ctx, 'ICONS', side.icon, cx, b.y + 11);
    FONT.tiny.draw(ctx, side.type, cx + 18, b.y + 13, lut(0xFE));
    const bs = String(side.base);
    FONT.tiny.draw(ctx, bs, cx + CA.valOff - FONT.tiny.width(bs), b.y + 13, lut(0xFC));
    side.rows.forEach((r, i) => {
      const y = b.y + 11 + (i + 1) * CA.pitch;
      FONT.tiny.draw(ctx, r.label, cx, y, lut(0xFE));
      FONT.tiny.draw(ctx, r.value, cx + CA.valOff - FONT.tiny.width(r.value), y, lut(0x0E));
    });
    // The fully modified strength closes the column.
    const ty = b.y + 11 + (b.rows - 1) * CA.pitch;
    FONT.tiny.draw(ctx, 'Strength', cx, ty, lut(0xFC));
    const tt = String(side.total);
    FONT.tiny.draw(ctx, tt, cx + CA.valOff - FONT.tiny.width(tt), ty, lut(0xFC));
  }
  // The roll itself, which the engine prints only in cheat mode -- shown here
  // because it is the whole point of the panel for a player learning the odds.
  const line = `Roll ${c.roll} of ${c.att.total + c.def.total}  --  ` +
               `${c.win ? 'attacker' : 'defender'} wins`;
  FONT.tiny.center(ctx, line, 160, b.y + b.h - 9, lut(c.win ? 0x0E : 0x0C));
}

// ---------------------------------------------------- rival European powers
// The other three powers start at their own @SCENARIO position -- the same
// table that gives the human theirs -- and found colonies as the game runs.
// First contact with one fires woodcut 10, MEETING FELLOW EUROPEANS
// (spec/ui/woodcuts_and_intro.md, func_057F4E @0x057FDF), once per game.
//
// Their turn logic is a deliberate stand-in: the engine's AI (func_059B90 and
// the heading planner) is largely unmapped, so rivals here sail inland, plant a
// colony when they reach a coast, and otherwise hold. Flagged in the tracker.
function seedRivals() {
  G.rivals = [];
  for (let n = 0; n < 4; n++) {
    if (n === G.nation) continue;
    const [sx, sy] = DATA.starts[n];
    G.rivals.push({
      nation: n, met: false,
      colonies: [], nextColony: 0,
      units: [{ type: n === 3 ? 'Merchantman' : 'Caravel',
                icon: unit(n === 3 ? 'Merchantman' : 'Caravel').icon,
                x: sx, y: sy, nation: n, orders: 0, ship: true }],
    });
  }
}
// A rival is "met" once any of its units or colonies is within sight of
// something of yours.
function checkContact() {
  for (const r of G.rivals) {
    if (r.met) continue;
    const near = (a, b) => Math.abs(a.x - b.x) <= 2 && Math.abs(a.y - b.y) <= 2;
    const seen = r.units.some(ru => G.units.some(u => near(u, ru)) ||
                                    G.colonies.some(c => near(c, ru))) ||
                 r.colonies.some(rc => G.units.some(u => near(u, rc)) ||
                                       G.colonies.some(c => near(c, rc)));
    if (!seen) continue;
    r.met = true;
    setWar(G.nation, r.nation, REL.MET, true);
    setWar(r.nation, G.nation, REL.MET, true);
    if (r.attitude === undefined) r.attitude = 8;
    if (r.gold === undefined) r.gold = 1000 + Math.floor(Math.random() * 4000);
    G.msg = `We have made contact with the ${DATA.nations[r.nation].adjective}.`;
    if (!G.metAnyone) { G.metAnyone = true; woodcutOnce(10); }
  }
}
// One rival turn: ships work west until they find a coast, then plant.
// The rival-power turn. The engine drives every AI power through the
// strategic planner func_04CC50 (per-power mission assignment over the plan
// map) and the per-unit pipeline func_04E2D6 -- both decoded in
// spec/systems/ai.md but far larger than the port carries. Under the
// no-invented-behaviour rule, the port runs ONLY what the evidence supports:
// ships explore westward and found colonies (the settler role the planner's
// +500 colony-site term drives, ai.md §3); land units garrison in place at
// peace (the engine's sentry state, order 5) and at war execute the attack
// mission -- goto the nearest enemy colony, striking through resolveAttack.
// AI colony DEVELOPMENT (growth, construction, unit production) runs through
// the engine's colony machinery under planner missions that are NOT yet
// decoded, so rival colonies here do not grow or raise troops out of
// nothing -- a fresh game's rivals field only what their ships landed with,
// and an imported save's rivals field exactly what the save carries. The
// straight-line war march stands in for the goto executor's path scoring
// (func_04E2D6 step 5, unported); both stand-ins are flagged here rather
// than papered over with invented cadences.
// ------------------------------------------------------- news bulletins
// The third-party outcome bus (COMPLETION_PLAN Phase 3). The engine
// resolves AI battles and bulletins what the player learns of; the port's
// reduced AI fights only the player, so this ticker SIMULATES the
// native-vs-rival raiding the engine genuinely has (manual: natives raid
// every European power) with FLAGGED parameters -- the 1/24 rate, the
// outcome split and the war-band-within-4 sourcing are the port's own.
// The rival-vs-rival segment below simulates the engine's AI wars with
// byte-read bulletin conditions (func_05CA7E, RULINGS 2026-08-07z8):
// @EUROPEWIN/@EUROPELOSE for settlement-less battles, @CAPTURED2/@BURNED3
// for third-party colony falls. The war START drivers stay omitted
// (2026-08-07m) -- the tick rates are flagged. @LOOTFOREIGN (rival
// treasure fleets) still has no port model.
function newsTick() {
  for (const r of G.rivals) {
    if (!r.met) continue;
    // The independence bulletin -- BYTE_VERIFIED end to end 2026-08-29
    // (func_02F736..@0x2F962, per AI power): pct = min(100,
    // PowerRecord[+0x19] x population_census / 100) (@0x2F8B1) against a
    // GRANT threshold of (8 - difficulty) x 10 (@0x2F8CA..@0x2F8DE:
    // Discoverer 80 .. Viceroy 40). Rising past the stored last-announced
    // value (+0x1A) posts @OTHERMIGHT and stores; falling 5 below it
    // posts @OTHERLESS and stores (@0x2F774..@0x2F87D -- NUMBER0 = pct,
    // NUMBER1 = the population census, NUMBER2 = the threshold). At the
    // threshold @OTHERGRANTED sets the power's flag +0x00 bit 2 and
    // resets its diplomacy vs everyone (@0x2F94D..@0x2F95E -- the write
    // pair's semantics are unread, not modeled).
    //
    // The +0x19 SENTIMENT DRIVER is func_03C424 (stored @0x3E8AA by the
    // per-power updater func_03E844): the power's population-weighted
    // average colony SoL, sum(size x colonySoL) / sum(size), colonySoL =
    // func_008524 = 100 x (+0xC2)/(+0xC6). The port carries each rival
    // colony's imported SoL -- static, since rival colonies produce no
    // bells (B3.6); the old random-walk stand-in is gone.
    if (G.year >= 1650 && !r.independent && !(G.flags & WOI_DECLARED)) {
      let sp = 0, ss = 0;
      for (const c of (r.colonies || [])) {
        sp += c.pop || 0;
        ss += (c.pop || 0) * (c.sol || 0);
      }
      const sent = sp ? Math.floor(ss / sp) : 0;   // PowerRecord +0x19
      const thr = (8 - G.difficulty) * 10;
      const rpop = r.units.length +
        (r.colonies || []).reduce((n, c) => n + (c.pop || 0), 0);
      const v = Math.min(100, Math.floor(sent * rpop / 100)); // @0x2F8B1
      r.rebelPct = v;
      const S2 = { STRING0: DATA.nations[r.nation].country,
                   STRING1: DATA.nations[r.nation].adjective,
                   STRING2: DATA.nations[r.nation].leader,
                   NUMBER0: v, NUMBER1: rpop, NUMBER2: thr };
      if (v >= thr) {
        r.independent = true;
        showEvent('OTHERGRANTED', S2);
      } else if (v > (r.lastPct || 0)) {
        r.lastPct = v;
        showEvent('OTHERMIGHT', S2);
      } else if ((r.lastPct || 0) - 5 > v) {
        r.lastPct = v;
        showEvent('OTHERLESS', S2);
      }
    }
    // @VIOLATE: a rival unit loitering beside one of our colonies at peace.
    if (!atWar(G.nation, r.nation) && Math.floor(Math.random() * 24) === 0) {
      const tres = r.units.find(u => G.colonies.some(c =>
        Math.abs(c.x - u.x) <= 1 && Math.abs(c.y - u.y) <= 1));
      const nearC = tres && G.colonies.find(c =>
        Math.abs(c.x - tres.x) <= 1 && Math.abs(c.y - tres.y) <= 1);
      if (nearC)
        showEvent('VIOLATE', { STRING0: DATA.nations[r.nation].adjective,
                               STRING1: DATA.nations[G.nation].adjective,
                               STRING2: nearC.name });
    }
    // @SNEAK: a rival unit beside the player's people opens hostilities
    // without a declaration (rare, flagged) -- war is set as it lands.
    if (!atWar(G.nation, r.nation) && Math.floor(Math.random() * 60) === 0) {
      const agg = r.units.find(x => !x.ship && G.units.some(pu =>
        !pu.ship && Math.abs(pu.x - x.x) <= 1 && Math.abs(pu.y - x.y) <= 1));
      const prey = agg && G.units.find(pu => !pu.ship &&
        Math.abs(pu.x - agg.x) <= 1 && Math.abs(pu.y - agg.y) <= 1);
      if (agg && prey) {
        showEvent('SNEAK', { STRING0: DATA.nations[r.nation].adjective });
        setWar(r.nation, G.nation, REL.WAR, true);
        resolveAttack(agg, prey);
        continue;
      }
    }
    // @LOOTFOREIGN (func_04E2D6 @0x5099E): a rival treasure fleet reaches
    // home. The engine's treasure trains ride real conquests; the port
    // SIMULATES the arrival on the news bus (rate 1/60 and the amount
    // 100 x random(2..12) both flagged; the bulletin subs are the body's).
    if (Math.floor(Math.random() * 60) === 0 && r.colonies.length) {
      const booty = 100 * (2 + Math.floor(Math.random() * 11));
      r.gold = (r.gold || 0) + booty;
      showEvent('LOOTFOREIGN', { STRING0: DATA.nations[r.nation].adjective,
                                 STRING1: DATA.nations[r.nation].homeport,
                                 NUMBER0: booty });
    }
    // @GIVECASH: a threatened AI colony buys the player off (rows: spare /
    // "it is God's will"). Once per colony, purse flagged.
    if (atWar(G.nation, r.nation)) {
      const scared = r.colonies.find(rc => !rc.spared && G.units.some(pu =>
        !pu.ship && Number((unit(pu.type) || {}).attack) > 0 &&
        Math.abs(pu.x - rc.x) <= 1 && Math.abs(pu.y - rc.y) <= 1));
      if (scared && Math.floor(Math.random() * 6) === 0) {
        scared.spared = true;
        const purse = 100 + 50 * (scared.pop || 1);
        askEvent('GIVECASH', { NUMBER0: purse }, (k) => {
          if (k === 0) { G.gold += purse; r.gold = Math.max(0, (r.gold || 0) - purse); }
        });
      }
    }
    if (!r.colonies.length || Math.floor(Math.random() * 24) !== 0) continue;
    const rc = r.colonies[Math.floor(Math.random() * r.colonies.length)];
    const v = G.villages.find(w => (w.alarm || 0) >= ALARM_RAID &&
      Math.abs(w.x - rc.x) <= 4 && Math.abs(w.y - rc.y) <= 4);
    if (!v) continue;
    const t = G.tribes[v.tribe];
    if (!t) continue;
    const S = { STRING0: t.name, STRING1: DATA.nations[r.nation].adjective,
                STRING2: 'Soldiers', STRING3: rc.name, STRING4: 'defeat' };
    const roll = Math.random();
    if (roll < 0.2 && (rc.pop || 1) <= 1) {
      r.colonies.splice(r.colonies.indexOf(rc), 1);
      showEvent('INDIANBURNCOLONY2', S);
    } else if (roll < 0.5) {
      rc.pop = Math.max(1, (rc.pop || 1) - 1);
      showEvent('INDIANWINCOLONY2', S);
    } else {
      showEvent('INDIANLOSE', S);
    }
  }
  // Rival-vs-rival wars. The engine genuinely fights AI wars and bulletins
  // them through func_05CA7E; the port SIMULATES the war tick. RESOLVED
  // 2026-08-29: there IS no autonomous Euro-Euro war-start driver in the
  // EXE (the full war-bit-2 writer sweep, diplomacy.md par.3) -- engine
  // wars start at diplomatic meetings (@0x58A7B/@0x59A71), from attacks
  // (func_03ECF0), or as the King's bit-0x10 war (kingWarCycle); the port
  // runs no rival-rival meetings, so the 1/80 start/stop and battle rates
  // here stay the flagged SIMULATION of that traffic. The BULLETIN
  // conditions and wording are byte-read: a unit-vs-unit battle with no
  // settlement emits @EUROPEWIN/@EUROPELOSE with the @MISC 73/74
  // "defeat"/"defeats" verb chosen by the subject's plurality
  // ([bp-0x8c]<7 test @0x5D9F8); a third-party colony fall emits
  // @CAPTURED2 (capture, @0x5DEEA) or @BURNED3 (razing, @0x5DB12).
  for (let i = 0; i < G.rivals.length; i++) {
    for (let j = i + 1; j < G.rivals.length; j++) {
      const a = G.rivals[i], b = G.rivals[j];
      if (!a.met || !b.met) continue;
      const k = `rr${a.nation}:${b.nation}`;
      G.rivalWars = G.rivalWars || {};
      if (!G.rivalWars[k]) {
        if (Math.floor(Math.random() * 80) === 0) G.rivalWars[k] = true;
        continue;
      }
      if (Math.floor(Math.random() * 80) === 0) { delete G.rivalWars[k]; continue; }
      const roll = Math.random();
      if (roll < 1 / 12) {
        // A battle bulletin: winner/loser drawn between the pair.
        const win = Math.random() < 0.5 ? a : b;
        const lose = win === a ? b : a;
        const types = ['Soldiers', 'Dragoons', 'Artillery', 'Caravel', 'Frigate'];
        const ut = types[Math.floor(Math.random() * types.length)];
        const near = (lose.colonies[0] || win.colonies[0] || {}).name ||
                     DATA.regionname[G.nation];
        const plural = (unit(ut) || {}).icon <= 6 || /s$/.test(ut);
        const S = { STRING0: DATA.nations[win.nation].country,
                    STRING1: DATA.nations[lose.nation].adjective,
                    STRING2: ut, STRING3: near,
                    STRING4: DATA.text.misc[plural ? 73 : 74] || 'defeat' };
        showEvent(Math.random() < 0.5 ? 'EUROPEWIN' : 'EUROPELOSE', S);
      } else if (roll < 1 / 12 + 1 / 40 && b.colonies.length) {
        // A colony falls between them: capture (CAPTURED2) or razing
        // (BURNED3), the same split the aftermath window draws.
        const victim = Math.random() < 0.5 && a.colonies.length ? a : b;
        const winner = victim === a ? b : a;
        const vc = victim.colonies[Math.floor(Math.random() * victim.colonies.length)];
        victim.colonies.splice(victim.colonies.indexOf(vc), 1);
        if (Math.random() < 0.5 && winner.colonies.length < 6) {
          winner.colonies.push({ ...vc, nation: winner.nation });
          showEvent('CAPTURED2', { STRING0: DATA.nations[winner.nation].country,
                                   STRING2: vc.name });
        } else {
          showEvent('BURNED3', { STRING0: DATA.nations[winner.nation].country,
                                 STRING1: DATA.nations[victim.nation].adjective,
                                 STRING3: vc.name });
        }
      }
    }
  }
}
function rivalTurn() {
  for (const r of G.rivals) {
    // B3.6: the per-power colony pass. func_02F052 runs ONE pass per power
    // over the same records; a rival's fully-imported colonies (the ones
    // with a colonists array -- runtime-founded stubs have none) run the
    // SAME colonyTurn body with turnPower set: popups silenced (cev/cask),
    // births and built units join r.units, the Custom House pays r.gold,
    // fathers come from the rival's own Congress (ffOwned).
    turnPower = r.nation;
    for (const c of r.colonies) if (c.colonists) colonyTurn(c);
    turnPower = -1;
    // The pass's Europe update (func_0363A2 @0x2F218, after the colony
    // loop): the rival's own market drifts on its own pool.
    driftMarketOf(r.nation);
    for (const c of r.colonies) if (c.colonists) c.pop = c.colonists.length;
    r.colonies = r.colonies.filter(c => !c.vanished);
    const war = atWar(G.nation, r.nation);
    for (const u of r.units.slice()) {
      if (u.ship) {
        const landAhead = [[-1, 0], [0, -1], [0, 1]]
          .map(([dx, dy]) => [u.x + dx, u.y + dy])
          .find(([x, y]) => !tileWater(at(x, y)));
        if (landAhead && r.colonies.length < 6 &&
            !G.colonies.some(c => c.x === landAhead[0] && c.y === landAhead[1]) &&
            !r.colonies.some(c => c.x === landAhead[0] && c.y === landAhead[1]) &&
            !G.villages.some(v => v.x === landAhead[0] && v.y === landAhead[1])) {
          const names = DATA.colonynames[r.nation];
          r.colonies.push({ x: landAhead[0], y: landAhead[1], nation: r.nation,
                            name: names[r.nextColony++ % names.length],
                            level: 0, pop: 1 });
          u.x = Math.min(MAP.w - 1, u.x + 3);    // stand off and look for another site
          continue;
        }
        const nx = u.x - 1;
        if (nx >= 0 && tileWater(at(nx, u.y))) u.x = nx;
        else u.y += (u.y % 2) ? 1 : -1;
        continue;
      }
      // Land units. At peace they hold their garrison (the engine's sentry
      // state, order 5); at war they take the attack mission. A soldier
      // standing in one of his power's colonies stays as its garrison unless
      // another already holds it -- the planner's garrison-first shape.
      if (!war) {
        // The AI-INITIATED meeting (func_046FFA @0x0481CB -> func_059B90):
        // a rival unit beside the player's people opens the same dispatcher,
        // B speaking first. parleyEligible carries the byte-cited gates and
        // the 16-turn cooldown keeps it from nagging.
        if (parleyEligible(r) && G.screen === 'map' && !G.dialog &&
            (G.units.some(p => Math.abs(p.x - u.x) <= 1 && Math.abs(p.y - u.y) <= 1) ||
             G.colonies.some(c => Math.abs(c.x - u.x) <= 1 && Math.abs(c.y - u.y) <= 1)))
          runMeeting(r, u);
        continue;
      }
      const inOwnColony = r.colonies.some(c => c.x === u.x && c.y === u.y);
      const stacked = r.units.some(v => v !== u && !v.ship &&
                                        v.x === u.x && v.y === u.y);
      if (inOwnColony && !stacked) continue;
      const target = G.colonies.slice().sort((a, b) =>
        (Math.abs(a.x - u.x) + Math.abs(a.y - u.y)) -
        (Math.abs(b.x - u.x) + Math.abs(b.y - u.y)))[0];
      if (!target) continue;
      const foe = G.units.find(p => !p.ship &&
        Math.abs(p.x - u.x) <= 1 && Math.abs(p.y - u.y) <= 1);
      if (foe) { resolveAttack(u, foe); continue; }
      if (Math.max(Math.abs(target.x - u.x), Math.abs(target.y - u.y)) <= 1) {
        // At the palisade with no defender outside: the colony's garrison
        // inside defends; an EMPTY colony falls and is burned (the engine's
        // capture path moves it to the attacker -- the port burns it and
        // flags the difference, since rival colony management of our records
        // is not modelled).
        const inside = G.units.find(p => p.x === target.x && p.y === target.y && !p.ship);
        if (inside) { resolveAttack(u, inside); continue; }
        // The burn-vs-capture selector is BYTE-READ (2026-08-29,
        // func_05CA7E @0x5D574..@0x5D5D0): a EUROPEAN winner ALWAYS takes
        // the capture path (transfer + plunder + the @CAPTURED family
        // split @0x5DED1, declared -> CAPTURED3); only a TRIBE winner
        // burns, and only a size-1 colony (@0x5D59A -> the removal
        // @0x5D651 with the musket/horse loot @0x5D627/@0x5D63D and the
        // @BURNED1/2/3 involvement split) -- a bigger colony just loses
        // one colonist to a tribal win (0x181f:0xa9c @0x5D5A2). So the
        // rival capture below is unconditional; the razing fallback runs
        // only at the port's own colony-array capacity, a capacity
        // artifact, not the engine's rule.
        G.colonies.splice(G.colonies.indexOf(target), 1);
        if (r.colonies.length < 48) {
          const plunder = Math.min(G.gold, 50 * Math.max(1, target.colonists.length));
          G.gold -= plunder;
          r.colonies.push({ x: target.x, y: target.y, nation: r.nation,
                            name: target.name, level: 0,
                            pop: Math.max(1, target.colonists.length) });
          showEvent(G.declared ? 'CAPTURED3' : 'CAPTURED',
                    { STRING0: DATA.nations[r.nation].adjective,
                      STRING2: target.name, NUMBER0: plunder });
        } else {
          showEvent('BURNED2', { STRING0: DATA.nations[G.nation].country,
                                 STRING1: DATA.nations[r.nation].country,
                                 STRING3: target.name });
        }
        continue;
      }
      const step = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
        .map(([dx, dy]) => [u.x + dx, u.y + dy])
        .filter(([x, y]) => x >= 0 && y >= 0 && x < MAP.w && y < MAP.h &&
                !tileWater(at(x, y)) &&
                !r.units.some(v => v !== u && v.x === x && v.y === y) &&
                !G.villages.some(v => v.x === x && v.y === y))
        .sort((a, b) => (Math.abs(target.x - a[0]) + Math.abs(target.y - a[1])) -
                        (Math.abs(target.x - b[0]) + Math.abs(target.y - b[1])))[0];
      if (step) { u.x = step[0]; u.y = step[1]; }
    }
  }
  checkContact();
}

// -------------------------------------------------- Continental Congress
// §17. Liberty bells accrue per turn from every colony; when the pool reaches
// the next father's cost he joins.
//
// father_cost (§17.2), byte-cited:
//   base   = human (d+3)*16   [AI (14-d)*8]
//   each era gate 1600/1650/1700/1750 passed compounds it x1.5
//   cost   = (fathers_owned + 1) * base + 1
//   first father is half price; after the Declaration, cost = d*1500 + 2000
// Cross-check from the manual: Explorer human, one father, pre-1600 ->
// (1+1)*((1+3)*16)+1 = 129, the live-verified "Brewster next = 129".
function fatherCost() {
  let base = (G.difficulty + 3) * 16;
  for (const gate of [1600, 1650, 1700, 1750])
    if (G.year >= gate) base += base >> 1;
  let cost = (G.fathersOwned.length + 1) * base + 1;
  if (G.fathersOwned.length === 0) cost >>= 1;
  if (G.declared) cost = G.difficulty * 1500 + 2000;
  return cost;
}
const currentEra = () => G.year < 1600 ? 0 : G.year < 1700 ? 1 : 2;
// Bells: the Town Hall is the base producer, and a colonist working as a
// Statesman adds his own. (The per-building bell rates are not in the evidence
// here, so this is the same flagged-placeholder shape as the cross accrual.)
function bellsPerTurn() {
  return G.colonies.reduce((n, c) => n + (c.bellsTurn || 0), 0);
}
// One candidate per category, drawn by weighted random over the un-owned
// fathers with a nonzero weight in the current era (§17.3): budget =
// random_int(1, sum of weights), then subtract-walk until <= 0.
function fatherCandidates() {
  const era = currentEra();
  const out = [];
  for (let cat = 0; cat < 5; cat++) {
    const pool = DATA.fathers.filter(f => f.category === cat &&
      f.weights[era] > 0 && !G.fathersOwned.includes(f.name));
    if (!pool.length) continue;
    const total = pool.reduce((n, f) => n + f.weights[era], 0);
    let budget = 1 + Math.floor(Math.random() * total);
    let pick = pool[pool.length - 1];
    for (const f of pool) { budget -= f.weights[era]; if (budget <= 0) { pick = f; break; } }
    out.push(pick);
  }
  return out;
}
function updateCongress() {
  G.bellsPerTurn = bellsPerTurn();
  if (!G.bellsPerTurn) return;
  G.bells += G.bellsPerTurn;
  G.bellsTotal += G.bellsPerTurn;
  if (!G.fatherInProgress) {
    const cands = fatherCandidates();
    if (!cands.length) return;
    // @WHICHFREEDOM: "Which Founding Father shall we appoint as its next
    // member?" -- the pick dialog, rows = the category candidates. The
    // engine's dialog cannot be cancelled; Escape keeps the first candidate.
    G.fatherInProgress = cands[0].name;
    askEvent('WHICHFREEDOM', {}, (k) => {
      if (k >= 0 && k < cands.length) G.fatherInProgress = cands[k].name;
    }, cands.map(c => c.name));
  }
  const cost = fatherCost();
  if (G.bells < cost) return;
  G.bells -= cost;
  G.fathersOwned.push(G.fatherInProgress);
  // @FREEDOM: "%STRING1 Founding Fathers announce that {%STRING0} has
  // joined the Continental Congress!"
  showEvent('FREEDOM', { STRING0: G.fatherInProgress,
                         STRING1: DATA.nations[G.nation].adjective });
  applyFatherEffect(G.fatherInProgress);
  G.fatherInProgress = null;
}
// The instant effects the acquisition dispatcher applies. Only the ones whose
// state this build keeps are wired; the rest are inert but recorded as owned.
function applyFatherEffect(name) {
  if (name === 'Jakob Fugger') G.boycotts = [];      // clear all boycotts
  // Jean de Brebeuf: every mission you already own becomes expert
  // (settlement +5 |= 0x10, @0x3BE77).
  if (name === 'Jean de Brebeuf')
    for (const v of G.villages)
      if (v.mission && v.mission.power === G.nation) v.mission.expert = true;
  // Bartolome de las Casas: every Indian Convert you own becomes a Free
  // Colonist on the spot (class 0x1B -> 0x1C, @0x3BEB2).
  if (name === 'Bartolome de las Casas') {
    for (const u of G.units)
      if (u.profession === CONVERT_CLASS) { u.profession = 'Free Colonists'; u.work = 0; }
    for (const c of G.colonies)
      for (const p of c.colonists)
        if (p.profession === CONVERT_CLASS) p.profession = 'Free Colonists';
  }
}

// -------------------------------------------------------- trade routes
// spec/systems/trade_routes.md. The route table is byte-verified: a record per
// route, MAX 12 (@TRADEMANY "Only 12 routes"), each carrying a 32-byte name, a
// type byte (0 = sea, 1 = land), a stop cursor, and UP TO FOUR STOPS. A stop's
// destination is a colony id or 999 = Europe; each stop carries a load list and
// an unload list. A unit is bound to a route through its own record: the low
// nibble is the route index and the high nibble the current stop.
//
// The port keeps the same shape and the same caps. What it does NOT reproduce
// is the per-stop good-list editor: the engine lets you name each good to load
// and unload at each stop, and this build uses the natural default -- load a
// colony's surplus, unload everything at Europe and sell it. Flagged.
const MAX_ROUTES = 12, MAX_STOPS = 4, STOP_EUROPE = 999;
const ORDER_TRADE = 2;
function routeStopName(stop) {
  if (stop === STOP_EUROPE) return DATA.nations[G.nation].homeport;
  const c = G.colonies[stop];
  return c ? c.name : '?';
}
// The engine names a route from @TRADENAMES -- Run / Ferry / Cargo / Transport
// / Triangle -- and the port picks by stop count, which is what makes a
// three-stop route a Triangle.
function routeName(stops) {
  const n = DATA.tradenames;
  const noun = stops.length >= 3 ? n[4] : n[G.routes.length % 3];
  return `${routeStopName(stops[0])} ${noun}`;
}
function createRoute(stops, sea, name) {
  if (G.routes.length >= MAX_ROUTES) {
    showEvent('TRADEMANY', { NUMBER0: MAX_ROUTES });
    return null;
  }
  const r = { name: name || routeName(stops), sea, stops: stops.slice(0, MAX_STOPS), cursor: 0,
              // Per-stop cargo lists -- the route record's nibble-packed lanes
              // (stop +0x03..+0x05 LOAD / +0x06..+0x08 UNLOAD, count nibbles at
              // +0x02; trade_routes.md par.2). Six goods per lane. They start
              // empty, exactly as a fresh record does; the Edit Trade Route
              // screen fills them (B3.4).
              loads: stops.map(() => []), unloads: stops.map(() => []) };
  G.routes.push(r);
  return r;
}
// One turn of automation for a unit running a route: sail or drive toward the
// current stop, and on arrival unload, load, and advance the cursor.
function runTradeRoute(u) {
  const r = G.routes[u.route];
  if (!r) { u.orders = 0; return; }
  // @ROUTELOOP: a route reduced to one stop cannot run.
  if (r.stops.length < 2) {
    showEvent('ROUTELOOP', { STRING0: r.name });
    u.route = undefined; u.orders = 0;
    return;
  }
  // @KILLWAGONS / @LOOTWAGONS: a wagon crossing a war-band tribe's country
  // may vanish without a trace or lose its cargo (1/40 each side, flagged).
  if (u.type === 'Wagon Train') {
    const hostileV = G.villages.find(v => (v.alarm || 0) >= ALARM_RAID &&
      Math.abs(v.x - u.x) <= 2 && Math.abs(v.y - u.y) <= 2);
    if (hostileV && Math.floor(Math.random() * 40) === 0) {
      const ht = G.tribes[hostileV.tribe] || {};
      G.eventTribe = hostileV.tribe;
      if (Math.random() < 0.5) {
        showEvent('KILLWAGONS', { STRING0: ht.name || '' });
        const i = G.units.indexOf(u);
        if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
        return;
      }
      const near3 = G.colonies[0];
      showEvent('LOOTWAGONS', { STRING0: ht.name || '',
                                STRING3: near3 ? near3.name : DATA.regionname[G.nation] });
      u.hold = [];
    }
  }
  const stop = r.stops[u.stopIndex % r.stops.length];
  if (stop === STOP_EUROPE) {
    // Europe: the ship sails for the sea lane and sells what it carries on
    // arrival, which the crossing code already does.
    if (!u.ship) { u.orders = 0; return; }
    sailForEurope(u);
    return;
  }
  const c = G.colonies[stop];
  if (!c) { u.orders = 0; return; }
  if (u.x === c.x && u.y === c.y) {
    // Each stop has its own LOAD and UNLOAD good list (the route record's
    // nibble lanes; automation loop @0x411D8..@0x4128C iterates them against
    // the cargo primitives -- UNLOAD func_00B8D0 adds the unit's tons to
    // ColonyRecord +0x9A+good*2, LOAD func_00B880 draws up to 100 (@0xB8A5)).
    // When the route carries NO lists at all (they start empty, and the
    // harness can never fill them), the port keeps its documented default:
    // the FIRST stop loads everything worth moving, every other stop
    // unloads -- a convenience stand-in, not the engine rule.
    u.hold = u.hold || [];
    const si = u.stopIndex % r.stops.length;
    const hasLists = (r.loads || []).some(l => l.length) ||
                     (r.unloads || []).some(l => l.length);
    if (hasLists) {
      const cap = unit(u.type).cargo || 0;
      for (const g of (r.unloads[si] || []))
        for (const h of u.hold.slice())
          if (h.good === g) { c.stock[g] += h.qty; holdAdd(u, g, -h.qty); }
      for (const g of (r.loads[si] || [])) {
        if (u.hold.length >= cap) break;
        const take = Math.min(100, c.stock[g]);            // @0xB8A5 cap
        if (take <= 0) continue;
        c.stock[g] -= take;
        holdAdd(u, g, take);
      }
    } else if (si === 0) {
      const cap = unit(u.type).cargo || 0;
      for (let i = 0; i < c.stock.length && (u.hold.length < cap); i++) {
        if (i === GOOD.FOOD || c.stock[i] < 50) continue;
        const take = Math.min(100, c.stock[i]);
        c.stock[i] -= take;
        holdAdd(u, i, take);
      }
    } else {
      for (const h of u.hold.slice()) { c.stock[h.good] += h.qty; holdAdd(u, h.good, -h.qty); }
    }
    u.stopIndex = (u.stopIndex + 1) % r.stops.length;
    return;
  }
  // Step toward the stop, one tile a turn, respecting the unit's element.
  const dx = Math.sign(c.x - u.x), dy = Math.sign(c.y - u.y);
  const tries = [[dx, dy], [dx, 0], [0, dy]];
  for (const [mx, my] of tries) {
    if (!mx && !my) continue;
    const nx = u.x + mx, ny = u.y + my;
    if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) continue;
    const water = tileWater(at(nx, ny));
    if (u.ship !== water && !(colonyAt(nx, ny) && !u.ship)) continue;
    u.x = nx; u.y = ny;
    reveal(nx, ny, sightRadius(u));
    return;
  }
}
function advanceTradeRoutes() {
  for (const u of G.units) if (u.orders === ORDER_TRADE && u.route !== undefined) runTradeRoute(u);
}
// The TRADE menu. Creating a route walks the stop list; the port asks for the
// stops one at a time from a menu of your colonies plus Europe.
function tradeStopChoices() {
  return G.colonies.map((c, i) => ({ id: i, label: c.name }))
    .concat([{ id: STOP_EUROPE, label: DATA.nations[G.nation].homeport }]);
}
function openTradeMenu(mode) {
  if (mode !== 'create' && !G.routes.length) { showEvent('TRADENONE', {}); return; }
  if (mode === 'create' && !G.colonies.length) {
    G.msg = 'We have no colonies to trade between.';
    return;
  }
  G.trade = { mode, stops: [], row: 0 };
  G.screen = 'trade';
}
function tradeRows() {
  const t = G.trade;
  if (t.mode === 'create') {
    const rows = tradeStopChoices().map(s => ({ id: s.id, label: s.label }));
    if (t.stops.length >= 2) rows.push({ id: 'done', label: 'Done -- create the route' });
    return rows;
  }
  // The cargo editor (B3.4): route -> stop -> LOAD lane -> UNLOAD lane. The
  // lanes are the record's six-nibble good lists; a row toggles membership.
  if (t.mode === 'edit') {
    if (t.phase === 'stop') {
      const r = G.routes[t.route];
      return r.stops.map((s, i) => ({ id: i, label: routeStopName(s) }));
    }
    if (t.phase === 'load' || t.phase === 'unload') {
      const r = G.routes[t.route];
      const lane = (t.phase === 'load' ? r.loads : r.unloads)[t.stop];
      const rows = DATA.cargo.map((g, i) =>
        ({ id: i, label: `${lane.includes(i) ? '* ' : '  '}${g.name}` }));
      rows.push({ id: 'done', label: t.phase === 'load'
        ? 'Done -- choose what to unload' : 'Done' });
      return rows;
    }
  }
  return G.routes.map((r, i) => ({ id: i, label: `${r.name} (${r.stops.map(routeStopName).join(' - ')})` }));
}
function tradeCommit() {
  const t = G.trade, row = tradeRows()[t.row];
  if (!row) { G.screen = 'map'; G.trade = null; return; }
  if (t.mode === 'create') {
    if (row.id === 'done') {
      // The engine ASKS the route class (@TRADETYPE: "Sea route" / "Land
      // route") and then names it through the @TRADENAME entry dialog --
      // replacing the port's old infer-from-stops + auto-name shortcut.
      const stops = t.stops;
      G.screen = 'map'; G.trade = null;
      askEvent('TRADETYPE', {}, (choice) => {
        if (choice < 0) return;
        openDialog('TRADENAME', (name) => {
          const r = createRoute(stops, choice === 0,
                                (name || '').trim() || routeName(stops));
          if (r) G.msg = `Trade route "${r.name}" created.`;
        }, routeName(stops));
      });
      return;
    }
    if (t.stops.length < MAX_STOPS && !t.stops.includes(row.id)) t.stops.push(row.id);
    return;
  }
  if (t.mode === 'edit') {
    if (!t.phase) {                       // route pick
      const r = G.routes[row.id];
      if (!r) { G.screen = 'map'; G.trade = null; return; }
      r.loads = r.loads || r.stops.map(() => []);
      r.unloads = r.unloads || r.stops.map(() => []);
      t.route = row.id; t.phase = 'stop'; t.row = 0;
      return;
    }
    if (t.phase === 'stop') { t.stop = row.id; t.phase = 'load'; t.row = 0; return; }
    const r = G.routes[t.route];
    const lane = (t.phase === 'load' ? r.loads : r.unloads)[t.stop];
    if (row.id === 'done') {
      if (t.phase === 'load') { t.phase = 'unload'; t.row = 0; return; }
      G.screen = 'map'; G.trade = null;
      G.msg = `${r.name}: cargo set for ${routeStopName(r.stops[t.stop])}.`;
      return;
    }
    const at = lane.indexOf(row.id);
    if (at >= 0) lane.splice(at, 1);
    else if (lane.length < 6) lane.push(row.id);   // six nibble slots a lane
    return;
  }
  if (t.mode === 'delete') {
    // @SUREDELETE: "Are you sure you want to delete the {%STRING0}?"
    const victim = G.routes[row.id];
    G.screen = 'map'; G.trade = null;
    askEvent('SUREDELETE', { STRING0: victim.name }, (k) => {
      if (k !== 0) return;
      const idx = G.routes.indexOf(victim);
      if (idx < 0) return;
      G.routes.splice(idx, 1);
      for (const u of G.units) if (u.route === idx) { u.route = undefined; u.orders = 0; }
      G.msg = `Trade route "${victim.name}" deleted.`;
    });
    return;
  }
  // 'assign' -- put the selected unit on this route.
  const u = G.units[G.sel];
  G.screen = 'map'; G.trade = null;
  if (u && (u.ship || u.type === 'Wagon Train') &&
      !G.routes.some(rt => !!rt.sea === !!u.ship)) {
    // @TRADENONE2: "You have not yet defined any {sea|land} trade routes."
    showEvent('TRADENONE2', { STRING0: u.ship ? 'sea' : 'land' });
    return;
  }
  if (!u || (!u.ship && u.type !== 'Wagon Train')) {
    G.msg = 'Only ships and wagon trains can run a trade route.';
    return;
  }
  u.route = row.id; u.stopIndex = 0; u.orders = ORDER_TRADE; u.movesLeft = 0;
  G.msg = `${u.type} joins the ${G.routes[row.id].name}.`;
  advance();
}
function drawTrade(ctx) {
  drawMap(ctx);
  const t = G.trade, rows = tradeRows();
  // Titles are the bundled GAME.TXT bodies (@TRADESTART/@TRADEDELETE/
  // @TRADESELECT), no longer paraphrased copies; the create mode's "So far"
  // line is the port's own running summary, kept.
  const stopName = t.mode === 'edit' && t.phase && t.phase !== 'stop'
    ? routeStopName((G.routes[t.route] || { stops: [] }).stops[t.stop] || 0) : '';
  const head = t.mode === 'create'
    ? [fillTemplate(DATA.events.TRADESTART.body[0], { NUMBER0: t.stops.length + 1 }),
       t.stops.length ? `So far: ${t.stops.map(routeStopName).join(' - ')}` : '']
    : t.mode === 'delete' ? [DATA.events.TRADEDELETE.body[0]]
    // The cargo editor titles are the engine's own @CARGOLOAD / @CARGOUNLOAD
    // ("Select a cargo to load/unload at {%STRING0}." -- func_060D8C's pair).
    : t.mode === 'edit' && t.phase === 'load'
      ? [fillTemplate((DATA.events.CARGOLOAD || { body: ['Select a cargo to load at {%STRING0}.'] }).body[0], { STRING0: stopName })]
    : t.mode === 'edit' && t.phase === 'unload'
      ? [fillTemplate((DATA.events.CARGOUNLOAD || { body: ['Select a cargo to unload at {%STRING0}.'] }).body[0], { STRING0: stopName })]
    : t.mode === 'edit' && t.phase === 'stop' ? ['Select a stop to edit:']
    : [DATA.events.TRADESELECT.body[0]];
  const body = head.filter(Boolean);
  let cw = 190;
  for (const l of body) cw = Math.max(cw, FONT.tiny.width(l));
  for (const r of rows) cw = Math.max(cw, FONT.tiny.width(r.label) + 20);
  const w = cw + 6, textH = body.length * 6;
  const h = 6 + textH + 3 + rows.length * 8 + 3;
  const x = Math.round(160 - w / 2), y = Math.max(10, Math.round(100 - h / 2));
  plaque(ctx, x, y, w, h, 'WOODTILE');
  body.forEach((l, i) => spanText(ctx, l, x + 5, y + 6 + i * 6, 0xFE, 0xFC));
  const seed = y + 6 + textH + 3;
  rows.forEach((r, k) => {
    const ry = seed + k * 8, sel = k === t.row;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(x + 3, ry, w - 6, 8); }
    FONT.tiny.draw(ctx, r.label, x + 9, ry + 1, lut(sel ? 0xFC : 0xFE));
  });
}

// -------------------------------------------------------- options dialogs
// spec/ui/options_dialogs.md. Each is a CHECKBOX dialog (the @directives say so:
// `checkbox=true options=true`), the first body line is the title and the rest
// are the rows. The bit layout is byte-verified per dialog:
//   Game Options   word [0x5383]: 0x8000 Show Indian Moves, 0x4000 Show Foreign
//                  Moves, 0x1000 Fast Piece Slide, 0x0800 End of Turn,
//                  0x0400 Autosave, 0x0200 Combat Analysis,
//                  0x0100 Water Color Cycling (INVERTED -- set means OFF),
//                  0x0080 Tutorial Hints
//   Colony Report Options word [0x5384]: ALL TEN BITS INVERTED -- a set bit
//                  means "suppress this report"
//   Sound Options  three rows
const GAME_OPTION_BITS = [0x8000, 0x4000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100, 0x0080];
const GAME_OPTION_INVERTED = [0x0100];
const OPTION_KEYS = { game: 'GAMEOPTIONS', colony: 'COLONYOPTIONS', sound: 'SOUNDOPTIONS' };
function optionWord(which) {
  return which === 'colony' ? G.colonyOptions : which === 'sound' ? G.soundOptions : G.gameOptions;
}
function setOptionWord(which, v) {
  if (which === 'colony') G.colonyOptions = v;
  else if (which === 'sound') G.soundOptions = v;
  else G.gameOptions = v;
}
function optionBit(which, row) {
  if (which === 'game') return GAME_OPTION_BITS[row] || 0;
  return 1 << (row + 1);              // Colony Report bits run 0x0002 upward
}
// A row reads CHECKED when its bit means "on". Water cycling and every colony
// report row are inverted, so a set bit reads as unchecked.
function optionChecked(which, row) {
  const bit = optionBit(which, row);
  const on = (optionWord(which) & bit) !== 0;
  const inverted = which === 'colony' || GAME_OPTION_INVERTED.includes(bit);
  return inverted ? !on : on;
}
function openOptions(which) {
  const t = DATA.events[OPTION_KEYS[which]];
  if (!t) return;
  G.options = { which, rows: t.body.slice(1), title: t.body[0], row: 0 };
  G.screen = 'options';
}
function optionsCommit() {
  const o = G.options;
  setOptionWord(o.which, optionWord(o.which) ^ optionBit(o.which, o.row));
  // Combat Analysis is the one option this build acts on beyond display.
  if (o.which === 'game') G.combatAnalysis = optionChecked('game', 5);
}
function drawOptions(ctx) {
  drawMap(ctx);
  // Census-corrected 2026-08-08 (census2_game_options / _colreport_options /
  // _sound_options): the options dialogs draw in the POPUP font at the
  // framework pitches, and each row wears a ROUND radio mark -- a ring with
  // an orange centre dot when the option is on -- not a square checkbox.
  // Ring/dot inks read off the frame (ring = base ink, dot = the 0x0E
  // accent), flagged.
  const o = G.options;
  let cw = 190;
  for (const r of o.rows) cw = Math.max(cw, DFONT().width(r) + 28);
  const w = cw + 6, h = 6 + DTEXT + 3 + o.rows.length * DROW + 3;
  const x = Math.round(160 - w / 2), y = Math.max(10, Math.round(100 - h / 2));
  plaque(ctx, x, y, w, h, 'WOODTILE');
  DFONT().draw(ctx, o.title, x + 5, y + 6, lut(0xFC));
  const seed = y + 6 + DTEXT + 3;
  o.rows.forEach((label, k) => {
    const ry = seed + k * DROW, sel = k === o.row;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(x + 3, ry, w - 6, DROW - 2); }
    // The radio mark: a ring, dotted orange when the option is on.
    const mx2 = x + 10, my2 = ry + 4;
    ctx.fillStyle = ink(0xFE);
    ctx.fillRect(mx2 - 2, my2 - 3, 4, 1); ctx.fillRect(mx2 - 2, my2 + 2, 4, 1);
    ctx.fillRect(mx2 - 3, my2 - 2, 1, 4); ctx.fillRect(mx2 + 2, my2 - 2, 1, 4);
    if (optionChecked(o.which, k)) {
      ctx.fillStyle = ink(0x0E);
      ctx.fillRect(mx2 - 1, my2 - 1, 2, 2);
    }
    spanText(ctx, label, x + 18, ry + 1, sel ? 0xFC : 0xFE, 0x0E, DFONT());
  });
}
// GAME "Pick Music" -- func_023344 @0x023344 drives the main picker and all
// three class sub-pickers off one switch (spec/ui/options_dialogs.md §3).
//
// Both of that function's jump tables were byte-read for this port. The
// dispatch is `dec ax; cmp ax,0x0E; ja default; shl ax,1; jmp cs:[bx+0x265A]`
// (file 0x023530), so the table at file 0x02353A holds 15 near targets, one
// per @PICKMUSIC row; segment offset + 0x020EE0 = file offset. Rows 1-12 are
// each a bare `mov word [bp-8],imm16` -- the tune id below. Note rows 9-12 are
// NOT contiguous with rows 1-8: the picker lists the four late folk tunes in
// the order Hornpipe / Bonny Morn / Hole In The Wall / Nightingale, whose ids
// run 0x39, 0x38, 0x3A, 0x3B (files 0x0234C0/0x0234C8/0x0234D0/0x0234D8).
const MUSIC_ROW_ID = [0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
                      0x39, 0x38, 0x3A, 0x3B];
// Rows 13/14/15 open a class sub-picker and bias the row it returns. Each
// handler is `lea bx,<section>; call 0x181f:0x3fe; test ax,ax; jz cancel;
// add ax,<bias>` at files 0x0234E0 / 0x0234F8 / 0x02350E. The Indian handler
// carries one extra step, `cmp ax,2; jle +4; inc ax` (file 0x02351A): id 0x34
// is event-only and has no row, so selections past the second skip over it.
const MUSIC_SUBMENU = [
  { key: 'PICKINDEPENDENCE', bias: 0x28 },
  { key: 'PICKMILITARY', bias: 0x2D },
  { key: 'PICKINDIAN', bias: 0x31, skipAfter: 2 },
];
// The reverse table -- id -> highlighted row -- is the 28-entry jump table at
// file 0x0233E4, indexed `sub ax,0x20; cmp ax,0x1B; ja default`. Ids 0x28-0x2D
// all preselect row 13, 0x2E-0x31 row 14, and 0x32/0x33/0x35/0x36 row 15: a
// tune picked from a sub-picker highlights its submenu row, not the tune.
// Ids 0x34 and 0x37 fall through to the default with no row at all.
function musicRow(id) {
  const i = MUSIC_ROW_ID.indexOf(id);
  if (i >= 0) return i;
  if (id >= 0x28 && id <= 0x2D) return 12;
  if (id >= 0x2E && id <= 0x31) return 13;
  if (id === 0x32 || id === 0x33 || id === 0x35 || id === 0x36) return 14;
  return 0;                       // 0x34 / 0x37 / unset: no row preselected
}
// Setting the tune is all this build can do with it: playback is the external
// "$sound$" driver overlay (§5), which has no port. The id is real state --
// the same [0x96] the picker preselects from -- so the round trip is honest.
function playTune(id) {
  G.tune = id;
  G.msg = `Music: ${DATA.events.PICKMUSIC.tail[musicRow(id)]} (no audio in this build).`;
}
function pickMusic() {
  askEvent('PICKMUSIC', {}, (choice) => {
    if (choice < 0) return;
    if (choice < MUSIC_ROW_ID.length) { playTune(MUSIC_ROW_ID[choice]); return; }
    const sub = MUSIC_SUBMENU[choice - MUSIC_ROW_ID.length];
    askEvent(sub.key, {}, (pick) => {
      if (pick < 0) return;
      let row = pick + 1;                       // the picker returns 1-based
      if (sub.skipAfter && row > sub.skipAfter) row++;
      playTune(row + sub.bias);
    });
  });
  G.dialog.sel = musicRow(G.tune);
}
// GAME "Exit to DOS": @DOS is the confirmation, and there is no DOS to exit
// to, so Yes unwinds to the main menu the way quitting and relaunching would.
function exitToDos() {
  askEvent('DOS', {}, (choice) => {
    if (choice !== 0) return;
    G.screen = 'title';
    G.menuRow = 0;
    G.msg = '';
  });
}

// ------------------------------------------------------------- tutorial
// spec/systems/tutorial.md (BYTE_VERIFIED): state is a 16-bit shown-bitmask
// [0x5386]/[0x5387], seeded 0x0E at new-game init (@0x755EB); each step owns
// one bit and fires ONCE at its own event site. Byte-attributed bits:
// TUTORIAL1=0x0010 (func_020F50 @0x20FFB), TUTORIAL4=0x0080 / TUTORIAL12=
// 0x8000 (func_02C5D4 @0x2C74A/@0x2C7BC), TUTORIAL5=0x0100 (func_033F6A
// @0x3651F), TUTORIAL6=0x0200 (func_02D658 @0x2EA4C), TUTORIAL7=0x0400
// (func_02883E @0x28D41). The func_020F50 window is now READ (2026-08-07,
// RULINGS 2026-08-07z6): steps 1 and 3..12 occupy CONSECUTIVE bits 4..15 of
// the [0x5386/7] word (bit 5 / 0x0020 is unassigned there -- possibly one of
// the emitter-less 16..18); steps 13/14/15/19 guard on the [0x5380]
// once-flags byte (0x01/0x02/0x08/0x80, or-ed at @0x210C4/@0x021104/
// @0x21157/@0x215FA); step 2 guards on [0x5382]&0x80 (func_020EE0
// @0x20F3A). Every guard bit is byte-cited; only 16/17/18 remain in the
// side set (no emitter found for them in the EXE). The seed's 0x0E marks
// the SOUND switches (the shared-word reading), not tutorial steps.
// The difficulty gate is the sibling TUT keys' [0x53A6]<2, flagged for
// TUTORIALn itself.
const TUT_BIT = { 1: 0x0010, 3: 0x0040, 4: 0x0080, 5: 0x0100, 6: 0x0200,
                  7: 0x0400, 8: 0x0800, 9: 0x1000, 10: 0x2000, 11: 0x4000,
                  12: 0x8000 };
const TUT_FLAG = { 13: 0x01, 14: 0x02, 15: 0x08, 19: 0x80 };   // [0x5380]
const TUT_PHASE = { 2: 0x80 };                                 // [0x5382]
function tutOnce(n, subs) {
  // Tutorials are DISCOVERER-ONLY: the COLONY02 census save (Explorer,
  // tutMask 0x0E = no step bits) opens its colony screen with NO tutorial
  // card under DOSBox, while COLONY04 (Discoverer) accumulates step bits
  // (0x41DE). The earlier "<2" reading was flagged; live evidence 2026-08-08.
  if (G.difficulty >= 1) return;
  if (TUT_BIT[n]) {
    if (G.tutMask & TUT_BIT[n]) return;
    G.tutMask |= TUT_BIT[n];
  } else if (TUT_FLAG[n]) {
    if (G.onceFlags & TUT_FLAG[n]) return;
    G.onceFlags |= TUT_FLAG[n];
  } else if (TUT_PHASE[n]) {
    if (G.phaseFlags & TUT_PHASE[n]) return;
    G.phaseFlags |= TUT_PHASE[n];
  } else {
    G.tutSide = G.tutSide || {};
    if (G.tutSide[n]) return;
    G.tutSide[n] = true;
  }
  showEvent(`TUTORIAL${n}`, subs || {});
}

// The endgame sequence: the @EXPLOITS rating card with an @SCORE joke name,
// the F10 score page, then the @SCORED lock ("That's all." ends the game,
// "Keep playing anyway." continues with scoring closed). Which @SCORE row
// the engine picks is runtime-driven and unread -- a random row is the
// flagged stand-in.
function endGameSequence() {
  if (G.scored) return;
  G.retired = true;
  const s = scoreParts();
  // The Hall of Fame entry (HALLFAME.DAT record semantics).
  // HALLFAME.DAT semantics (capture-pinned 2026-08-07): score = the POINTS
  // (+0x24, scoreParts base), rating = the Colonization Rating % (+0x26,
  // scoreParts total -- the ranking key), plus year/difficulty/flags.
  hofWrite({ name: G.leader || DATA.nations[G.nation].leader,
             nation: G.nation, year: G.year, difficulty: G.difficulty,
             score: s.base, rating: s.total,
             declared: !!(G.flags & WOI_DECLARED),
             independent: !!(G.flags & WOI_WON) });
  const name = G.leader || DATA.nations[G.nation].leader;
  showEvent('EXPLOITS', { NUMBER0: s.total,
                          STRING0: DATA.nations[G.nation].country });
  const rows = DATA.scorenames || [];
  if (rows.length)
    notice(rows[Math.floor(Math.random() * rows.length)]
             .replace(/%STRING0/g, name));
  G.report = 'F10';
  G.screen = 'report';
  askEvent('SCORED', {}, (choice) => {
    G.scored = true;
    if (choice === 0) { G.screen = 'title'; G.menuRow = 0; }
  });
}
// The War-of-Independence screen lockouts: Europe and the Foreign Affairs
// report close for the duration (@EUROPENOTAVAIL is byte-cited to push
// MSS1; the others share the family).
function woiLocked() {
  return (G.flags & WOI_DECLARED) && !(G.flags & WOI_WON);
}
// GAME "Retire": @RETIRE carries `@default=2`, so "No" is highlighted.
function retire() {
  askEvent('RETIRE', {}, (choice) => {
    if (choice !== 0) return;
    endGameSequence();
  });
}

// ---------------------------------------------------------- diplomacy
// spec/systems/diplomacy.md. Two 4x4 per-pair byte matrices, both byte-verified:
//   the WAR matrix (PowerRecord +0x34): 0x01 resolved, 0x02 AT WAR, 0x08 pending
//     grievance, 0x20 peace-pending, 0x40 met/contacted, 0x80 privateer
//     hidden-attribution (set INSTEAD of the war bit when the attacker is a
//     Privateer, so the aggression is not openly imputed);
//   the TREATY matrix (PowerRecord +0x40), written SYMMETRICALLY: 0x02 hostile,
//     0x20 peace-pending, 0x40 existing treaty.
// A treaty cooldown of turn + 0x10 is a 16-turn re-parley lockout.
const REL = { RESOLVED: 0x01, WAR: 0x02, GRIEVANCE: 0x08, PEACE_PENDING: 0x20,
              MET: 0x40, PRIVATEER: 0x80, TREATY: 0x40 };
const PARLEY_LOCKOUT = 0x10;
function relKey(a, b) { return `${a},${b}`; }
const relWar = (a, b) => (G.warMatrix[relKey(a, b)] || 0);
const relTreaty = (a, b) => (G.treatyMatrix[relKey(a, b)] || 0);
function setWar(a, b, bits, on) {
  const k = relKey(a, b);
  G.warMatrix[k] = on ? ((G.warMatrix[k] || 0) | bits) : ((G.warMatrix[k] || 0) & ~bits);
}
// The treaty matrix is written both ways round -- matrix[A][B] = matrix[B][A].
function setTreaty(a, b, bits, on) {
  for (const k of [relKey(a, b), relKey(b, a)])
    G.treatyMatrix[k] = on ? ((G.treatyMatrix[k] || 0) | bits) : ((G.treatyMatrix[k] || 0) & ~bits);
}
const atWar = (a, b) => (relWar(a, b) & REL.WAR) !== 0 || (relWar(b, a) & REL.WAR) !== 0;
const haveTreaty = (a, b) => (relTreaty(a, b) & REL.TREATY) !== 0;
function declareWarOn(a, b) {
  setWar(a, b, REL.WAR, true);
  setTreaty(a, b, REL.TREATY, false);
  showEvent('DECLAREWAR', { STRING0: DATA.nations[a].adjective,
                            STRING1: DATA.nations[b].adjective });
}
function signTreaty(a, b, silent) {
  setWar(a, b, REL.WAR, false);
  setWar(b, a, REL.WAR, false);
  setTreaty(a, b, REL.TREATY, true);
  G.parleyLock[b] = G.turn + PARLEY_LOCKOUT;
  // @SIGNTREATY is the AI-AI ticker's announcement (audit row 16): the
  // player's own acceptance in the meeting flow passes silent.
  if (!silent) showEvent('SIGNTREATY', { STRING0: DATA.nations[a].adjective,
                                         STRING1: DATA.nations[b].adjective });
}
// Target eligibility for a parley, byte-verified @0x57B1A: the turn must be at
// least 0x28 (40) and at least one side's attitude byte must be >= 8. The port
// keeps a per-rival attitude that first contact seeds and treaties raise.
const PARLEY_FIRST_TURN = 0x28, PARLEY_ATTITUDE = 8;
function parleyEligible(r) {
  if (G.turn < PARLEY_FIRST_TURN) return false;
  if ((G.parleyLock[r.nation] || 0) > G.turn) return false;
  return (r.attitude || 0) >= PARLEY_ATTITUDE || (G.attitude || 0) >= PARLEY_ATTITUDE;
}
// The tribute/demand value, scaled by the byte-cited difficulty terms: the
// value is scaled 10*(diff+8)/100 (x0.8 .. x1.2) and carries a flat surcharge
// of 500*(diff+1).
function demandValue(base) {
  return Math.floor(base * 10 * (G.difficulty + 8) / 100) + 500 * (G.difficulty + 1);
}
// ---- the European meeting (func_057F4E, spec/ui/diplomacy_popups.md) ------
// The meeting is a CHAIN OF POPUPS over the map -- the engine has no parley
// screen -- and it is always framed as power B speaking to the player: every
// option row is the player's ANSWER. Conversations (width 220) speak through
// channel [0x1F60] = B -> MYR<B>.SS; announcements (width 190) stay on the
// MSS advisor channel. Byte-cited pieces kept: the eligibility gates
// (turn >= 0x28, attitude >= 8 @0x57B1A, 16-turn cooldown @0x58075), the
// action gate random(1000) < 200*diff+100 (@0x58315), the grace period
// 10*(10-diff) turns (@0x58374), demandValue's scaler (@0x583A0/@0x5842B),
// the withdraw price 25*(diff+2)*forces min 100 x2-at-war -50/unit
// Franklin/2, and the greeting key build (@0x0588CD-0x058939).
// The MEEK/MANLY tone predicate is READ (func_057F4E @0x5881F, RULINGS
// 2026-08-07z14): B speaks MEEKLY when B's power metric ([0x941C+power·2],
// the per-power strength word) is BELOW the player's, MANLY when it is
// >= (jae -> MANLY). It is a MILITARY-STRENGTH comparison, not attitude.
// The port has no single strength word, so it compares a FORCE PROXY --
// total combat power of each side's units plus colonies -- flagged as a
// proxy for [0x941C]. Still FLAGGED with no byte cite: PEACE-vs-OLDPEACE =
// standing treaty, the per-meeting topic priority, the withdraw/threat
// sub-branch selection, and the smite price (demandValue(1000) stand-in).
function powerMetric(power) {
  const isMe = power === G.nation;
  const r = isMe ? null : G.rivals.find(x => x.nation === power);
  const units = isMe ? G.units : (r ? r.units : []);
  const colonies = isMe ? G.colonies : (r ? r.colonies : []);
  return units.reduce((n, u) => n + Number((unit(u.type) || {}).combat || 0), 0) +
         colonies.length * 3;
}
const meetingTone = (r) => powerMetric(r.nation) < powerMetric(G.nation);
function meetingSubs(r) {
  return {
    STRING0: `${DATA.difficulty[G.difficulty]} ${G.leader || DATA.nations[G.nation].leader}`,
    STRING1: DATA.regionname[r.nation],
    STRING2: DATA.diplotext.GREATKINGS[r.nation],
    STRING3: DATA.diplotext.GREATDEEDS[r.nation],
  };
}
function runMeeting(r, unitIn) {
  const myr = `MYR${r.nation}`;
  // key = "HELLO" + (not yet greeted ? (ship ? AHOY : FIRST) : tone) with the
  // independent USA override (@0x0588CD-0x058923).
  const key = (G.flags & WOI_DECLARED) ? 'HELLOUSA'
    : !r.greeted ? (unitIn && unitIn.ship ? 'HELLOAHOY' : 'HELLOFIRST')
    : meetingTone(r) ? 'HELLOMEEK' : 'HELLOMANLY';
  r.greeted = true;
  G.parleyLock[r.nation] = G.turn + PARLEY_LOCKOUT;   // stamp @0x58075
  showEvent(key, meetingSubs(r), myr);
  meetingTopic(r);
}
function meetingTopic(r) {
  const myr = `MYR${r.nation}`;
  const gate = () => Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100;
  const inGrace = G.turn < 10 * (10 - G.difficulty);
  // @PIRACY: B's accusation when the Privateer hidden-attribution bit is
  // set against him (the census the spec names; topic priority flagged).
  // Rows: deny ("NEVER condoned piracy!") / withdraw -- withdrawal sends
  // the player's Privateers home. STRING3 = the @MEEKNESS request/demand
  // verb by B's tone (attitude>=8 reused, flagged).
  if ((relWar(G.nation, r.nation) & REL.PRIVATEER) && !atWar(G.nation, r.nation)) {
    setWar(G.nation, r.nation, REL.PRIVATEER, false);
    askEvent((G.flags & WOI_DECLARED) ? 'PIRACYUSA' : 'PIRACY',
             { STRING0: DATA.diplotext.GREATLEADER[r.nation],
               STRING1: DATA.nations[G.nation].adjective,
               STRING2: DATA.regionname[r.nation],
               STRING3: DATA.diplotext.MEEKNESS[meetingTone(r) ? 0 : 1] },
             (k) => {
      if (k === 1)
        for (const pu of G.units.filter(x => x.type === 'Privateer').slice())
          sailForEurope(pu);
      meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  const usa = (k) => (G.flags & WOI_DECLARED) ? k + 'USA' : k;
  // @SIEGES: B objects to player forces beside HIS colonies. Rows stay(0) /
  // withdraw(1) -- and the handler acts on ROW 2 even for SIEGESUSA, whose
  // rows are swapped in the data (the engine's own latent bug, replicated).
  const besiegers = !atWar(G.nation, r.nation) && G.units.filter(u => !u.ship &&
    Number((unit(u.type) || {}).attack) > 0 && r.colonies.some(rc =>
      Math.abs(rc.x - u.x) <= 1 && Math.abs(rc.y - u.y) <= 1));
  if (besiegers && besiegers.length && gate()) {
    askEvent(usa('SIEGES'), { STRING0: DATA.diplotext.GREATLEADER[r.nation],
                              STRING1: DATA.nations[G.nation].adjective,
                              STRING2: DATA.nations[r.nation].adjective,
                              STRING3: DATA.diplotext.MEEKNESS[meetingTone(r) ? 0 : 1] },
             (k) => {
      if (k === 1) {
        // Withdrawal pulls the offending units back to the nearest own
        // colony (the engine sends them "to Europe" -- the port's nearest-
        // colony recall is the flagged stand-in).
        for (const bu of besiegers) {
          const home = G.colonies.slice().sort((a, b) =>
            (Math.abs(a.x - bu.x) + Math.abs(a.y - bu.y)) -
            (Math.abs(b.x - bu.x) + Math.abs(b.y - bu.y)))[0];
          if (home) { bu.x = home.x; bu.y = home.y; }
        }
      }
      meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  // @APOSTATES: B demands you cancel your treaty with a third power. Rows:
  // refuse / "crush the foul-smelling X together" (break + join B's side).
  const third = G.rivals.find(x => x !== r && x.met &&
    haveTreaty(G.nation, x.nation) && atWar(r.nation, x.nation));
  if (third && gate()) {
    askEvent(usa('APOSTATES'), { STRING0: DATA.nations[third.nation].adjective,
                                 STRING1: DATA.diplotext.MEEKNESS[meetingTone(r) ? 0 : 1] },
             (k) => {
      if (k === 1) {
        setTreaty(G.nation, third.nation, REL.TREATY, false);
        declareWarOn(G.nation, third.nation);
      }
      meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  // @HEATHEN: B recruits you against a tribe he is subduing. The port has no
  // tribe-vs-rival relations -- a hostile-band tribe stands in, flagged.
  const heathen = G.tribes.find(t => t && !t.dead && (t.tension || 0) >= 40);
  if (heathen && !atWar(G.nation, r.nation) && gate() && Math.random() < 0.34) {
    askEvent(usa('HEATHEN'), { STRING0: heathen.name, STRING1: heathen.name },
             (k) => {
      if (k === 1) adjustTension(G.tribes.indexOf(heathen), 100, 4);
      meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  // B's gold extortion (@TRIBUTE -- and note ACCEPT IS ROW 2 in the text).
  if (!inGrace && !atWar(G.nation, r.nation) && gate()) {
    const want = demandValue(500);
    askEvent(usa('TRIBUTE'), { STRING0: DATA.diplotext.GREATLEADER[r.nation],
                          STRING1: DATA.nations[G.nation].adjective,
                          STRING2: DATA.regionname[r.nation], NUMBER0: want }, (k) => {
      if (k === 1) {
        if (G.gold < want) { showEvent('NOTENOUGH', { NUMBER0: G.gold }, myr); }
        else { G.gold -= want; r.gold = (r.gold || 0) + want; }
        meetingPeaceHub(r);
      } else if (gate()) {
        // The refusal escalation: B declares war with the tone-keyed body
        // (@WARMEEK/@WARMANLY -- "Prepare for WAR!"). Which refusal escalates
        // is the action gate's roll; the ladder's exact rule stays flagged.
        showEvent(meetingTone(r) ? 'WARMEEK' : 'WARMANLY',
                  { STRING0: DATA.diplotext.GREATKINGS[r.nation],
                    STRING1: DATA.regionname[r.nation] }, myr);
        declareWarOn(r.nation, G.nation);
      } else meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  // B proposes the demarcation treaty (@WORTHY is AI-proposed).
  if (!haveTreaty(G.nation, r.nation) && !atWar(G.nation, r.nation) && gate()) {
    // "by order of %STRING0" takes the short @GREATLEADER row ("Our King") --
    // the long @GREATKINGS line overflows the 320px screen, which the engine
    // never does on this popup.
    askEvent('WORTHY', { STRING0: DATA.diplotext.GREATLEADER[r.nation],
                         STRING1: DATA.nations[G.nation].adjective,
                         STRING2: DATA.nations[r.nation].adjective }, (k) => {
      if (k === 0) acceptTreaty(r);
      else meetingPeaceHub(r);
    }, undefined, myr);
    return;
  }
  meetingPeaceHub(r);
}
// The standing-peace hub: 4 fixed rows -- peace / withdraw-demand / threat /
// alliance -- from @PEACE*/@OLDPEACE* by tone and standing treaty.
function meetingPeaceHub(r) {
  const myr = `MYR${r.nation}`;
  // Once independent the hub takes its own body (@PEACEUSA), like the
  // HELLOUSA greeting.
  const key = (G.flags & WOI_DECLARED) ? 'PEACEUSA'
    : haveTreaty(G.nation, r.nation)
    ? (meetingTone(r) ? 'OLDPEACEMEEK' : 'OLDPEACEMANLY')
    : (meetingTone(r) ? 'PEACEMEEK' : 'PEACEMANLY');
  askEvent(key, { STRING0: DATA.nations[G.nation].adjective,
                  STRING1: DATA.nations[r.nation].adjective,
                  STRING2: DATA.difficulty[G.difficulty],
                  STRING3: G.leader || DATA.nations[G.nation].leader }, (k) => {
    if (k === 0) acceptTreaty(r);
    else if (k === 1) meetingWithdraw(r);
    else if (k === 2) meetingThreat(r);
    else if (k === 3) meetingAlliance(r);
  }, undefined, myr);
}
function acceptTreaty(r) {
  // Treaty both ways + respect := 1 + the cooldown; @SIGNTREATY itself
  // belongs to the AI-AI ticker (audit row 16), so the player's acceptance
  // announces nothing beyond the row he picked.
  signTreaty(G.nation, r.nation, true);
  r.respect = 1;
}
function rivalForcesNearby(r) {
  return r.units.filter(u => !u.ship && G.colonies.some(c =>
    Math.abs(c.x - u.x) <= 1 && Math.abs(c.y - u.y) <= 1));
}
function meetingWithdraw(r) {
  const myr = `MYR${r.nation}`, adj = DATA.nations[r.nation].adjective;
  const forces = rivalForcesNearby(r);
  if (!forces.length) { showEvent('NOTHINGWITHDRAW', {}, myr); return; }
  // price = 25*(diff+2)*forces, min 100, x2 at war, -50 per unit, Franklin /2.
  let price = Math.max(100, 25 * (G.difficulty + 2) * forces.length - 50 * forces.length);
  if (atWar(G.nation, r.nation)) price *= 2;
  if (G.fathersOwned.includes('Benjamin Franklin')) price >>= 1;
  // WHICH of WITHDRAW/NOTWITHDRAW/MAYBEWITHDRAW fires is decoded only for
  // the no-forces case; the action gate picks paywall vs refusal here.
  if (Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100) {
    askEvent('MAYBEWITHDRAW', { STRING0: adj, NUMBER0: price }, (k) => {
      if (k === 0) {
        if (G.gold < price) { showEvent('NOTENOUGH', { NUMBER0: G.gold }, myr); return; }
        G.gold -= price;
        r.units = r.units.filter(u => !forces.includes(u));
        showEvent('WITHDRAW', {}, myr);
      } else if (k === 1) showEvent('THREATS', {}, myr);
    }, undefined, myr);
  } else showEvent('NOTWITHDRAW', { STRING0: adj }, myr);
}
function meetingThreat(r) {
  const myr = `MYR${r.nation}`;
  // @GIFTS / @THREATS / @PROVOKE selection is TBD; the port keys it on the
  // action gate and B's purse (the affordability compare @0x58E1F).
  const want = demandValue(500);
  const gate = () => Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100;
  if ((r.gold || 0) >= want && gate()) {
    r.gold -= want; G.gold += want;
    showEvent('GIFTS', { NUMBER0: want }, myr);
  } else if (gate()) {
    showEvent('PROVOKE', {}, myr);
    declareWarOn(r.nation, G.nation);
  } else showEvent('THREATS', {}, myr);
}
function meetingAlliance(r) {
  const myr = `MYR${r.nation}`;
  // @MILITARY's rows are built at runtime (lea 0x19FA @0x05976D): one per
  // rival power + tribe.
  const targets = [];
  for (const o of G.rivals) if (o !== r) targets.push({ kind: 'power', o });
  G.tribes.forEach((t, ti) => {
    if (G.villages.some(v => v.tribe === ti)) targets.push({ kind: 'tribe', ti });
  });
  const rows = targets.map(t => t.kind === 'power'
    ? `The ${DATA.nations[t.o.nation].adjective}.` : `The ${G.tribes[t.ti].name}.`)
    .concat(['Never mind.']);
  askEvent('MILITARY', {}, (k) => {
    if (k < 0 || k >= targets.length) return;
    const t = targets[k];
    const name = t.kind === 'power' ? DATA.nations[t.o.nation].adjective : G.tribes[t.ti].name;
    if (t.kind === 'power' && !t.o.met) { showEvent('NOCONTACT', { STRING0: name }, myr); return; }
    if (t.kind === 'power' && atWar(r.nation, t.o.nation)) {
      showEvent('ALREADYSMITE', { STRING0: name }, myr); return;
    }
    // The smite price formula is unread; the demand scaler is the stand-in.
    const price = demandValue(1000);
    askEvent(t.kind === 'power' ? 'SMITEEUROPE' : 'SMITEINDIANS',
             { STRING0: name, NUMBER0: price }, (kk) => {
      if (kk !== 0) return;
      if (G.gold < price) { showEvent('UNFORTUNATE', {}, myr); return; }
      G.gold -= price;
      if (t.kind === 'power') declareWarOn(r.nation, t.o.nation);
      else G.tribes[t.ti].warWith = r.nation;
      showEvent('MERCENARY', { STRING0: DATA.nations[r.nation].adjective, STRING1: name }, myr);
    }, undefined, myr);
  }, rows, myr);
}
// The AI-AI diplomacy ticker (func_057DC0): every 3rd turn per met pair,
// turn >= 40, attitude gate, the action gate -- peace signings announce
// @SIGNTREATY. (The AI-AI war path's grievance drivers are unread; omitted.)
function aiDiplomacyTick() {
  if (G.turn < 0x28 || G.turn % 3) return;
  const met = G.rivals.filter(r => r.met);
  for (let i = 0; i < met.length; i++)
    for (let j = i + 1; j < met.length; j++) {
      const a = met[i], b = met[j];
      if ((a.attitude || 8) < 8 && (b.attitude || 8) < 8) continue;
      if (Math.floor(Math.random() * 1000) >= 200 * G.difficulty + 100) continue;
      if (atWar(a.nation, b.nation)) {
        setWar(a.nation, b.nation, REL.WAR, false);
        setWar(b.nation, a.nation, REL.WAR, false);
        showEvent('SIGNTREATY', { STRING0: DATA.nations[a.nation].adjective,
                                  STRING1: DATA.nations[b.nation].adjective });
      } else if (!haveTreaty(a.nation, b.nation)) {
        setTreaty(a.nation, b.nation, REL.TREATY, true);
        showEvent('SIGNTREATY', { STRING0: DATA.nations[a.nation].adjective,
                                  STRING1: DATA.nations[b.nation].adjective });
      }
    }
}

// ------------------------------------------------- treasure transport
// func_05C878, fully byte-verified (2026-06-19).
//   treasure gold = 100 * UnitRecord[+0x15]   (the class byte holds value/100)
//   post-independence ([0x5382]&1): no King -- cashed IN FULL, no cut
//   pre-independence: the King offers to ship it, and his cut is
//     with Hernan Cortes (FF #10)  -> cut% = your tax rate
//     without                      -> cut% = max(5*difficulty + 50, 2*tax), <= 90
//   the player receives treasure - cut.
// @KINGGALLEON3 is the offer when you own a galleon fleet, @KINGGALLEON2 when
// you do not; @LOOTCASH reports the arrival, @CASHTREASURE the King-less sale.
function kingsCut() {
  if (G.fathersOwned.includes('Hernan Cortes')) return G.tax;
  return Math.min(90, Math.max(5 * G.difficulty + 50, 2 * G.tax));
}
const treasureValue = (u) => (u.treasure || 0) * 100;
const hasGalleon = () => G.units.some(u => u.type === 'Galleon') ||
                         G.europe.some(e => e.type === 'Galleon');
// Cash a treasure the player shipped home themselves: no cut at all, which is
// the whole point of owning a Galleon.
function cashTreasureInFull(u) {
  const gold = treasureValue(u);
  G.gold += gold;
  removeUnit(u);
  showEvent('CASHTREASURE', { NUMBER0: gold });
}
// The King's offer, raised once per treasure unit standing in one of your
// colonies.
function offerGalleon(u) {
  u.offered = true;
  const gross = treasureValue(u);
  // With independence declared there is no Crown to take a share.
  if (G.flags & WOI_DECLARED) { cashTreasureInFull(u); return; }
  const cut = kingsCut();
  askEvent(hasGalleon() ? 'KINGGALLEON3' : 'KINGGALLEON2', {
    STRING0: kingSalutation(), STRING1: G.leader || DATA.nations[G.nation].leader,
    STRING2: DATA.nations[G.nation].country, NUMBER0: cut,
  }, (choice) => {
    // Row 0 accepts the Crown's share, row 1 refuses.
    if (choice !== 0) return;                        // ship it yourself, then
    const take = Math.floor(gross * cut / 100);
    G.gold += gross - take;
    G.kingsFund += take;
    removeUnit(u);
    showEvent('LOOTCASH', { STRING0: DATA.nations[G.nation].adjective,
                            STRING1: DATA.nations[G.nation].homeport,
                            NUMBER0: gross, NUMBER1: cut, NUMBER2: gross - take });
  });
}
// Per turn: any treasure sitting in one of your colonies draws the offer once.
function checkTreasure() {
  for (const u of G.units.slice()) {
    if (u.type !== 'Treasure' || u.offered) continue;
    if (colonyAt(u.x, u.y)) { offerGalleon(u); return; }   // one offer per turn
  }
}

// ------------------------------------------------------------- fog of war
// spec/systems/exploration.md, byte-verified. Visibility is its own map layer
// (far-ptr [0x168]) with ONE BIT PER POWER -- bit (player + 4) -- and the bit is
// STICKY once set. The reveal is a (2R+1)x(2R+1) SQUARE centred on the unit
// (func_006468's double loop), with R from func_006608:
//   normal land unit                            R = 1
//   Scout (@UNIT type 5)                        R = 2
//   Galleon / Privateer / Frigate (0x0F..0x11)  R = 2
//   any naval (0x0D..0x12) with de Soto (FF 7)  R = 2
//   other ships without de Soto                 R = 1
const SEEN = new Uint8Array(MAP.w * MAP.h);
const SEEN_BIT = () => 1 << (G.nation + 4);
const isSeen = (x, y) => (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) ||
                         G.showHidden || (SEEN[y * MAP.w + x] & SEEN_BIT()) !== 0;
const NAVAL_LO = 13, NAVAL_HI = 18;                  // @UNIT rows 0x0D..0x12
function sightRadius(u) {
  const idx = DATA.units.findIndex(r => r.name === u.type);
  if (u.type === 'Scouts') return 2;
  if (idx >= 15 && idx <= 17) return 2;              // Galleon, Privateer, Frigate
  if (idx >= NAVAL_LO && idx <= NAVAL_HI &&
      G.fathersOwned.includes('Hernando de Soto')) return 2;
  return 1;
}
function reveal(x, y, r) {
  const bit = SEEN_BIT();
  for (let dy = -r; dy <= r; dy++)
    for (let dx = -r; dx <= r; dx++) {
      const tx = x + dx, ty = y + dy;
      if (tx < 0 || ty < 0 || tx >= MAP.w || ty >= MAP.h) continue;
      SEEN[ty * MAP.w + tx] |= bit;
    }
}
// Everything you own reveals its surroundings, every turn and after every move.
function revealAll() {
  for (const u of G.units) reveal(u.x, u.y, sightRadius(u));
  for (const c of G.colonies) reveal(c.x, c.y, 2);
}

// ------------------------------------------ the King's tax demands
// spec/systems/king.md, byte-verified throughout.
//
// CADENCE (func_036138 @0x36150..0x361BA): nothing before turn 30; then a demand
// fires only when turn % interval == 0, where interval starts at 18 and shrinks
// to 15 / 12 / 9 as the year crosses 1600 / 1700 / 1750, further reduced by a
// human-player difficulty term (difficulty - 2). Skipped once tax > 85.
function taxInterval() {
  // base 18 / 15 past 1600 / 12 past 1700 / 9 past 1750, MINUS
  // 2 x (difficulty - 2) for the human (@0x361AE shl dx,1)
  const base = G.year >= 1750 ? 9 : G.year >= 1700 ? 12 : G.year >= 1600 ? 15 : 18;
  return Math.max(2, base - 2 * (G.difficulty - 2));
}
// RAISE (func_034AE0, read instruction by instruction):
//   delta       = ((difficulty & 0xFE) << 1) + 4
//   turn_factor = (turn / 400) + 1
//   candidate   = delta * turn_factor
// -- that math belongs to the PETITION path; the demand cycle below no
// longer uses it (2026-08-29). The 75 hard clamp on application stands
// (func_034318 @0x03434F).
const TAX_CAP = 75;
function taxRaise() {
  const delta = ((G.difficulty & 0xFE) << 1) + 4;
  const turnFactor = Math.floor(G.turn / 400) + 1;
  return delta * turnFactor;
}
// The Crown's tax/war cycle -- BYTE_VERIFIED end to end 2026-08-29
// (king_tax_demand_and_pretext, func_036138 @0x36138..@0x363A0):
//   severity = random_int(1,1000) + 5*(2*rebel_meter - tax) + gold/100
//            + population census + turn/30
//   < 100    @KINGVICTORY: tax CUT min(random_int(2,5), tax) -- zero = no
//            event -- naming the REMEMBERED @KINGWAR country ([0x53A8])
//   < 650    @KINGWIFE +1 while the wedding counter [0x53A7] < 30 -- the
//            30-entry @ORDINAL list IS the cap; at 30 the band falls
//            through to the war test
//   < 950    @KINGWAR +2; country = random_int(1,8) rerolled while equal
//            to the last, remembered
//   < 1100   @KINGNAVACT +random_int(3,4)
//   else     @KINGSTAMPACT +random_int(5,8)
// [0x53A7]/[0x53A8] live in the persisted globals block the importers do
// not read yet, FLAGGED.
const KING_COUNTRIES = ['the Holy Roman Empire', 'the Portuguese',
  'the Ottoman Turks', 'the Barbary Pirates', 'Russia', 'Prussia',
  'Sweden', 'Denmark'];
const KING_ORDINAL = ['first', 'second', 'third', 'fourth', 'fifth',
  'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth',
  'thirteenth', 'fourteenth', 'fifteenth', 'sixteenth', 'seventeenth',
  'eighteenth', 'nineteenth', 'twentieth', 'twenty first',
  'twenty second', 'twenty third', 'twenty fourth', 'twenty fifth',
  'twenty sixth', 'twenty seventh', 'twenty eighth', 'twenty ninth',
  'thirtieth'];
// The Crown addresses you by your difficulty rank -- [0x8394] is a 5-entry table
// of salutation strings, one per difficulty (RESOLVED 2026-06-20). @DIFFICULTY
// carries exactly those five names.
const kingSalutation = () => DATA.difficulty[G.difficulty];
function kingTaxDemand() {
  if (G.flags & WOI_DECLARED) return;              // no King to obey any more
  if (!G.colonies.length) return;                  // @0x36146
  if (G.turn < 30 || G.tax > 85) return;
  if (G.turn % taxInterval() !== 0) return;
  // The [-0x6BF0] census: colony sizes + valid units (0x181F:0xB78
  // validity unread -- every player unit counts here, FLAGGED).
  const pop = G.colonies.reduce((n, c) => n + c.colonists.length, 0) +
              G.units.length;
  const sev = 1 + Math.floor(Math.random() * 1000)
    + (2 * nationalSoL() - G.tax) * 5
    + Math.floor(G.gold / 100) + pop
    + Math.floor(G.turn / 30);
  let raise, key, s2 = null;
  if (sev < 100) {
    // @KINGVICTORY: the war is won, the tax drops -- applied directly (no
    // tea party against good news; the port's reading of the negative
    // amount @0x3627D, FLAGGED).
    const cut = Math.min(2 + Math.floor(Math.random() * 4), G.tax);
    if (cut <= 0) return;
    G.tax -= cut;
    const wc = G.kingWarCountry >= 1 && G.kingWarCountry <= 8 ? G.kingWarCountry : 1;
    showEvent('KINGVICTORY', { STRING0: kingSalutation(),
      STRING1: G.leader || DATA.nations[G.nation].leader,
      STRING2: KING_COUNTRIES[wc - 1], NUMBER0: cut, NUMBER1: G.tax });
    return;
  } else if (sev < 0x28A && (G.kingWeddings || 0) < 30) {
    raise = 1;
    G.kingWeddings = (G.kingWeddings || 0) + 1;
    key = 'KINGWIFE';
    s2 = KING_ORDINAL[G.kingWeddings - 1];
  } else if (sev < 0x3B6) {
    raise = 2;
    let pick;
    do { pick = 1 + Math.floor(Math.random() * 8); } while (pick === G.kingWarCountry);
    G.kingWarCountry = pick;
    key = 'KINGWAR';
    s2 = KING_COUNTRIES[pick - 1];
  } else if (sev < 0x44C) {
    raise = 3 + Math.floor(Math.random() * 2);
    key = 'KINGNAVACT';
  } else {
    raise = 5 + Math.floor(Math.random() * 4);
    key = 'KINGSTAMPACT';
    s2 = DATA.nations[G.nation].country;
  }
  // The good the Sons of Liberty would throw into the sea: the one your colonies
  // hold most of, which is what a Party costs you.
  const stock = DATA.cargo.map((_, i) =>
    G.colonies.reduce((n, c) => n + c.stock[i], 0));
  let good = 0;
  for (let i = 1; i < 16; i++) if (stock[i] > stock[good]) good = i;
  const party = DATA.cargo[good].name;
  const subs = { STRING0: kingSalutation(), STRING1: G.leader || DATA.nations[G.nation].leader,
                 STRING2: s2 || DATA.nations[G.nation].adjective, STRING3: party,
                 NUMBER0: raise, NUMBER1: G.tax + raise };
  askEvent(key, subs, (choice) => {
    // @TAXOPTIONS row 0 kisses the ring, row 1 holds the Party.
    if (choice === 1) {
      teaParty(good);
      return;
    }
    G.tax = Math.min(TAX_CAP, G.tax + raise);
  }, 'TAXOPTIONS');
}
// The Tea Party: the good is thrown into the sea at one colony, the tax is NOT
// raised, and the good is boycotted -- PowerRecord +0x20 is a 16-bit mask, bit i
// per good (`or [bx+0x20], 1<<good` @0x034717), tested on every trade
// (@0x030B47) and cleared in full by Jakob Fugger (@0x03BD45).
function teaParty(good) {
  const c = G.colonies.find(x => x.stock[good] > 0) || G.colonies[0];
  const tons = c ? c.stock[good] : 0;
  if (c) c.stock[good] = 0;
  if (!G.boycotts.includes(good)) G.boycotts.push(good);
  showEvent('TEAPARTY', { STRING0: DATA.cargo[good].name,
                          STRING1: c ? c.name : DATA.nations[G.nation].homeport,
                          STRING3: DATA.cargo[good].name, NUMBER0: tons });
}

// ------------------------------------------------ Lost City Rumours
// Rumour PRESENCE is procedural, not a stored marker. func_006188 @0x6188:
//   [0x190] != 0                                      gate @0x6191
//   terrain class not in {0x18, 0x19, 0x1A}           gate @0x61A6/@0x61AB/@0x61B0
//   func_005DF0 >= 0 suppresses                       gate @0x61BC/@0x61C5
//   (((y>>2)*0x13 + (x>>2)*0x11 + word[0x190] + 8) & 0x1F) - ((x&3)<<2) == (y&3)
//                                                     hash @0x61C7-0x61F6
//
// THE AXES WERE TRANSPOSED. arg1 = [bp+6] is X, arg2 = [bp+8] is Y, anchored at
// the CALL SITE rather than inferred: the call pushes [0xa5a2] then [0xa5a0],
// and the only write to [0xa5a0] is the inner loop variable @0x68803, bounded
// @0x6880D-0x68812 against word[0x853a]-1 = the map WIDTH. So [0xa5a0] is the
// column. Transposing x and y is not cosmetic -- measured over AMER2 (58x72),
// the two orientations pick 33-44 tiles each and overlap on 0-3 of them.
// docs/manual_src/part2.md 6.10 has it right; spec/systems/events.md,
// docs/manual_src/part5.md:285 and docs/UI_AUDIT_TRACKER.md:424 are transposed
// and are corrected with this change. See RULINGS.md 2026-08-07.
//
// The func_005DF0 gate is REPRODUCED (2026-08-29): the plane-3 high
// nibble is the TERRITORY OWNER (both identities in the old dispute were
// half-right -- low nibble region, high nibble owner/feature), imported
// verbatim into RESOURCE[] and checked below. Fresh games stay unclaimed
// (the engine's claim writer is unread, flagged).
function rumourAt(x, y) {
  if (!G.mapSeed) return false;             // [0x190] == 0 disables them @0x6191
  const t = tileTerrain(at(x, y));
  // The engine gates on the classify thunk 0x3E4:0x3A, not on the raw id; the
  // two agree on every id the .MP loader can produce.
  if (t >= 0x18) return false;                     // Arctic, Ocean, Sea Lane
  // The C1.2 gate, RESOLVED 2026-08-29 (@0x61BC in func_006188 = the
  // rumour hash itself): a tile whose plane-3 OWNER nibble is claimed
  // (func_005DF0 >= 0, i.e. anything but 0xF) never carries a rumour --
  // the DOS suppression the port was missing.
  if (RESOURCE[y * MAP.w + x] !== 0x0F) return false;
  const h = ((y >> 2) * 0x13 + (x >> 2) * 0x11 + G.mapSeed + 8) & 0x1F;
  // `rumoursDone` is the port's own consumed-rumour bookkeeping -- UNCITED. The
  // engine consumes a rumour by writing the tile's high nibble at 0x5DCC.
  return h - (x & 3) * 4 === (y & 3) && !G.rumoursDone.has(y * MAP.w + x);
}
// The scout bonus, byte-verified in func_061454: +1 for a Scout, +1 for a
// Seasoned Scout, +1 if the power holds Hernando de Soto (who also forces a
// positive-outcome reroll).
function scoutLevel(u) {
  let s = 0;
  if (u.type === 'Scouts') s += 1;
  if (u.profession === 'Seasoned Scouts') s += 1;
  if (G.fathersOwned.includes('Hernando de Soto')) s += 1;
  return s;
}
const d = (n) => 1 + Math.floor(Math.random() * n);
const dsum = (k, n) => { let t = 0; for (let i = 0; i < k; i++) t += d(n); return t; };
// The outcome index is random_int(1,9) raised to an ANTI-STREAK FLOOR that
// climbs by one per rumour and caps at 3 -- so the two good low outcomes
// (1 Fountain of Youth, 2 Cibola) are only reachable on the first rumours.
// A quality roll random_int(1,100) + scout*10 against thresholds 10/25 then
// demotes them, and each is capped once per game.
function enterRumour(u, x, y) {
  G.rumoursDone.add(y * MAP.w + x);
  const s = scoutLevel(u);
  let n = Math.max(G.rumourFloor, d(9));
  G.rumourFloor = Math.min(G.rumourFloor + 1, 3);
  const quality = d(100) + s * 10;
  if (n === 1 && (G.foundFountain || quality < 10)) n = quality < 10 ? 5 : 6;
  if (n === 2 && (G.foundCibola || quality < 25)) n = 4;
  const tribe = G.tribes[Math.floor(Math.random() * G.tribes.length)];
  switch (n) {
    case 1: {                                      // Fountain of Youth: 8 immigrants
      G.foundFountain = true;
      // THE FOUNTAIN OF YOUTH plate precedes the message (func_061454
      // @0x0618F9); the queued @LOSTCITY1 popup shows once the map is back.
      woodcutOnce(8);
      showEvent('LOSTCITY1', {});
      // @LOSTCITY0 "Which of the following individuals shall we recruit?" --
      // the engine lets you PICK each arrival. Three candidates per pick (the
      // Europe recruit-pool convention) and the pick count = the 8 arrivals;
      // the engine's list size is unread, flagged.
      const pickOne = (k) => {
        if (k >= 8) return;
        const cands = [rollImmigrant(), rollImmigrant(), rollImmigrant()];
        askEvent('LOSTCITY0', {}, (choice) => {
          const who = cands[choice] || cands[0];
          G.dockUnits.push(who.name || 'Colonists');
          pickOne(k + 1);
        }, cands.map(x => x.name || 'Colonists'));
      };
      pickOne(0);
      break;
    }
    case 2: {                                      // Cibola: a Treasure unit
      G.foundCibola = true;
      const value = 10 * (s + 2) + d(20);
      const t = mkUnit('Treasure', x, y);
      t.treasure = value;                          // the class byte holds value/100
      G.units.push(t);
      showEvent('LOSTCITY2', { NUMBER1: value * 100 });
      break;
    }
    case 3: {                                      // ruins: gold = 10 * 3d8, scaled
      const gold = Math.floor(10 * dsum(3, 8) * (s + 2) / 2);
      G.gold += gold;
      showEvent('LOSTCITY3', { NUMBER0: gold });
      break;
    }
    case 4: {                                      // burial mounds
      // @LOSTCITY4 asks FIRST ("Let us search for treasure!" / "Stay clear
      // of those!"); the burial roll only runs if the expedition digs.
      askEvent('LOSTCITY4', {}, (choice) => {
        if (choice !== 0) return;                  // stayed clear
        const roll = d(3);
        if (roll === 1) showEvent('BURIAL1', {});
        else if (roll === 2) {
          const gold = 10 * dsum(3, 8);
          G.gold += gold;
          showEvent('BURIAL2', { NUMBER0: gold });
        } else {
          const value = 2 * (d(8) + 2 * (s + 5));
          const t = mkUnit('Treasure', x, y);
          t.treasure = value;
          G.units.push(t);
          showEvent('BURIAL3', { NUMBER1: value * 100 });
        }
        // @SCREWED (byte-cited, func_061454 map): desecrating a HOSTILE
        // tribe's grounds -- "Now you must die!" -- the unit is lost and
        // the tribe goes +100 to the war footing (func_045DF2 @0x61B84).
        if (tribe && (tribe.tension || 0) >= TENSION_HOSTILE) {
          G.eventTribe = G.tribes.indexOf(tribe);
          showEvent('SCREWED', { STRING0: tribe.name });
          const i = G.units.indexOf(u);
          if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
          adjustTension(G.tribes.indexOf(tribe), 100, 4);
        }
      });
      break;
    }
    case 5: {                                      // the expedition vanishes
      const i = G.units.indexOf(u);
      if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
      showEvent('LOSTCITY5', {});
      return false;                                // the unit is gone: do not step
    }
    case 6:
      showEvent('LOSTCITY6', {});
      break;
    case 7: {                                      // a friendly tribe's gift
      const gold = 2 * dsum(4, 10);
      G.gold += gold;
      showEvent('LOSTCITY7', { NUMBER0: gold });
      break;
    }
    case 8:                                        // trespass on holy ground
      if (tribe) adjustTension(G.tribes.indexOf(tribe), 20);
      showEvent('LOSTCITY8', { STRING0: tribe ? tribe.name : '' });
      break;
    default: {                                     // survivors swear allegiance
      const c = G.colonies[0];
      if (c) c.colonists.push({ type: 'Colonists', profession: null, job: null, cell: null });
      else G.units.push(mkUnit('Colonists', x, y));
      showEvent('LOSTCITY9', { STRING0: DATA.nations[G.nation].country });
      break;
    }
  }
  return true;
}

// ------------------------------------- the Declaration and the REF war
// spec/systems/revolution.md + king.md + ref_growth.md + scoring.md.
//
// The national SoL meter [0x53D0] is a 0..100 "Bolivar meter" separate from the
// per-colony percentages. Its own per-turn driver is not in the evidence here,
// so the port takes the population-weighted mean of the colony meters -- which
// is what the F3 screen shows and what the declare gate reads. The +20 from
// Simon Bolivar IS byte-cited (`add [0x53D0],0x14` @0x3BE64, capped 100).
function nationalSoL() {
  const pop = G.colonies.reduce((n, c) => n + c.colonists.length, 0);
  let m = 0;
  if (pop) m = Math.floor(G.colonies.reduce((n, c) => n + c.sol * c.colonists.length, 0) / pop);
  if (G.fathersOwned.includes('Simon Bolivar')) m += 20;
  return Math.max(0, Math.min(100, m));
}
// game.flags [0x5382]: bit 0 War of Independence declared, bit 1 foreign
// intervention active, bit 3 independence WON.
const WOI_DECLARED = 1, WOI_INTERVENTION = 2, WOI_WON = 8;
const REF_TYPES = ['Regulars', 'Cavalry', 'Man-O-War', 'Artillery'];
// New-game REF seed, byte-verified in new_game_setup: 8d+15 Regulars,
// 5d+5 Cavalry, 3d+2 Man-O-War, 6d+2 Artillery for difficulty d.
function seedREF() {
  const d = G.difficulty;
  G.ref = { Regulars: 8 * d + 15, Cavalry: 5 * d + 5,
            'Man-O-War': 3 * d + 2, Artillery: 6 * d + 2 };
  G.refUnits = [];
  G.royalFund = 0;
  G.flags = 0;
  G.declaredYear = 0;
}
// The royal fund accrues (8*difficulty + 10) * 2^era per turn, and every 1800
// banked buys one REF unit (func_03E162: accrue @0x3E181, gate `>= 0x708`
// @0x3E1C6, `SUB [bx+0x22],0x708` @0x3E271). Era doubles as the year passes
// 1600 / 1700 / 1750. The port's own sales tax feeds the same fund, which is
// the point of the loop: your taxes buy the army sent against you.
function refEra() {
  return G.year >= 1750 ? 3 : G.year >= 1700 ? 2 : G.year >= 1600 ? 1 : 0;
}
// The tax PETITION (func_034AE0, READ 2026-08-07z11 -- the KINGRAISE body
// "You DARE to demand lower taxes!" identifies the handler as the player's
// demand-lower-taxes request). Byte-read outcome ladder:
//   tax <= 1            -> @KINGRAISE, tax += 2*random(1, difficulty)
//   tax >  cap          -> 1/(difficulty+1) chance of @KINGLOWER,
//                          tax -= random(1, 5-difficulty), where
//                          cap = ((difficulty&~1)*2+4)*(turn/400 + 1)
//   otherwise           -> the no-change dialog (0x109C = @KINGNOTHING by
//                          the page-table neighbourhood, inferred)
// The ENGINE'S ENTRY POINT is unmapped (no menu row, no caller in the
// graph) -- the port surfaces the petition on the Europe screen, key K:
// a port-authored entry, flagged; the ladder itself is byte-exact.
function petitionLowerTaxes() {
  if (G.tax <= 1) {
    const delta = 2 * (1 + Math.floor(Math.random() * Math.max(1, G.difficulty)));
    G.tax += delta;
    showEvent('KINGRAISE', { NUMBER0: delta, NUMBER1: G.tax });
    return;
  }
  const cap = ((G.difficulty & ~1) * 2 + 4) * (Math.floor(G.turn / 400) + 1);
  if (G.tax > cap + 5 &&
      1 + Math.floor(Math.random() * (G.difficulty + 1)) === 1) {
    const delta = Math.min(G.tax,
      1 + Math.floor(Math.random() * Math.max(1, 5 - G.difficulty)));
    G.tax -= delta;
    showEvent('KINGLOWER', { NUMBER0: delta, NUMBER1: G.tax });
    return;
  }
  showEvent('KINGNOTHING', {});
}
const REF_UNIT_COST = 1800;
function growREF() {
  G.royalFund += (8 * G.difficulty + 10) * (1 << refEra());
  while (G.royalFund >= REF_UNIT_COST) {
    G.royalFund -= REF_UNIT_COST;
    // The slot is chosen by ratio; the port buys into the type that is furthest
    // below its share of the seeded mix.
    const seed = { Regulars: 8 * G.difficulty + 15, Cavalry: 5 * G.difficulty + 5,
                   'Man-O-War': 3 * G.difficulty + 2, Artillery: 6 * G.difficulty + 2 };
    const total = REF_TYPES.reduce((n, t) => n + G.ref[t], 0) || 1;
    const seedTotal = REF_TYPES.reduce((n, t) => n + seed[t], 0);
    let pick = REF_TYPES[0], worst = Infinity;
    for (const t of REF_TYPES) {
      const gap = G.ref[t] / total - seed[t] / seedTotal;
      if (gap < worst) { worst = gap; pick = t; }
    }
    G.ref[pick] += 1;
    // The REF-growth surface splits on the declaration (func_03E162
    // @0x3E2DB, RULINGS 2026-08-07z11): before it, @KINGBUY ("King
    // increases military spending"); after it, @KINGMOBILIZE ("Parliament
    // votes additional funds to suppress revolution in X. {unit} mobilized
    // in Y" -- subs byte-read: the power's home region, the unit name, the
    // nation word).
    if (G.flags & WOI_DECLARED)
      showEvent('KINGMOBILIZE', { STRING0: DATA.regionname[G.nation],
                                  STRING1: pick,
                                  STRING2: DATA.nations[G.nation].country });
    else
      showEvent('KINGBUY', { STRING0: pick });
  }
}
// The blockade census -- func_042138's colony scan (@0x424F3..@0x42557,
// spec/systems/colony.md Custom House note): each colony's +0x1B gets
// bit 0 when another power's SHIP (EXE types 0xD..0x12) stands within the
// +-5 box with a water-path distance (0x1A1F:0x27E) <= 5, bit 1 when that
// ship is a FRIGATE (type 0x11); the bits are cleared and recomputed each
// pass (@0x4268C). The port tests the +-5 box only -- the water-path walk
// is unported, FLAGGED. [0xA89A]/[0xA89B] are the census tallies of
// colonies carrying bit 0 / bit 1; blockadeCensus() returns them.
function blockadeCensus() {
  let any = 0, frig = 0;
  for (const c of G.colonies) {
    c.blockade = 0;
    for (const r of G.rivals) {
      for (const u of r.units) {
        if (!u.ship) continue;
        if (Math.abs(u.x - c.x) > 5 || Math.abs(u.y - c.y) > 5) continue;
        c.blockade |= 1;
        if (u.type === 'Frigate') c.blockade |= 2;
      }
    }
    if (c.blockade & 1) any++;
    if (c.blockade & 2) frig++;
  }
  return { any, frig };
}
// The Crown's European-war cycle -- the byte model (read 2026-08-29).
//
// @KINGNEWWAR driver = func_035E80 (file 0x035E80..0x036137, called per
// player turn from the immigration/king tick func_0363A2 @0x3656E via the
// ljmp stub 0x368A9 -> 0x191f:0xc84). Gates, in EXE order:
//   - power < 4 and HUMAN (AIPersonality.controller == 0 @0x35EA5);
//   - power attribute bit 0x13 clear (@0x35EAF -- the independence flag);
//   - (difficulty+2) * turn >= 800 (@0x35EC1..@0x35ECF);
//   - scan rivals b: T = treaty partners (relation & 0x40), P = pairs in
//     the royal peace-pending state ((rel & 0x60) == 0x20) -- P must be 0
//     (@0x35F82) and T >= 1 (@0x35F75);
//   - roll random_int(0, ((P+2)*2 - T) * 20) <= difficulty (@0x35F9E..).
// Target: reroll random_int(0,3) until a treaty partner (@0x35FC6..).
// Amounts: soldiers = 1, grant = (diff+1)*100 (@0x35FF6..@0x36004); if the
// target's census strength byte [0x942C+b] exceeds ours, d = theirs-ours,
// soldiers = (d>>3)+1, grant += 25*d (@0x36007..@0x3602F); clamps
// soldiers <= 6-diff, grant <= (5-diff)*500 (@0x36032..@0x3605C). Effects:
// gold += grant; the Veteran Soldier units spawn at NEGATIVE map coords =
// the EUROPE DOCK (@0x360DC spawn_unit, profession 0x15 @0x36F8);
// treaty bit 0x40 cleared + king-war bit 0x10 set (@0x36108..@0x36120);
// [0x53C8 + b*2] = turn (@0x36128). The war EXPIRES at the next diplomatic
// meeting once 16 turns have passed (diplomacy_meeting_dispatch @0x57FFF:
// stamp+0x10 <= turn -> clear bit 0x10); the port clears on expiry directly
// (it has no player-rival meeting dispatcher) -- proxy, flagged.
//
// @KINGFRIGATE = the func_02F052 upkeep tail (@0x2F286..@0x2F39D): every
// 8th turn (test [0x538E],7), pre-independence ([0x5382]&1 clear), when
// the census says >=1 colony carries the Frigate-blockade bit ([0xA89B])
// or >3 colonies carry the any-ship bit ([0xA89A] @0x2F28D), and the
// per-power byte [0x925D + p*0x13] is 0 (@0x2F29B -- identity OPEN, the
// port omits that gate, TBD). Humans get the ask (id 0xEF5 @0x2F314);
// answer "Yes" spawns a free Frigate on the Europe dock (@0x2F32D,
// negative coords) and then RAISES THE TAX by 10 via @KINGTAX
// (func_034318(0xF01, 10) @0x2F390 -- tax += delta capped at 75
// @0x3434F). AI powers auto-accept (@0x2F322). There is NO latch -- the
// blockade tallies and the tax cost re-gate it. @KINGMERCY is DEAD
// CONTENT: the key exists in GAME.TXT but not in VICEROY.EXE (0 hits),
// no engine path emits it. @KINGVICTORY belongs solely to the tax-demand
// band of func_036138 (kingTaxDemand); it is not a war-end message.
//
// The port's strength term is a PROXY: the EXE census strength byte
// [0x942C+p] saturates a per-unit strength query (0x181f:0x9c8, unread)
// over the power's units; the port sums @UNIT attack+defense, capped 255.
function unitListStrength(units) {
  let s = 0;
  for (const u of units) {
    const t = unit(u.type || u.name);
    if (t) s = Math.min(255, s + (t.attack || 0) + (t.combat || 0));
  }
  return s;
}
function kingWarCycle() {
  if (G.retired) return;
  const S = { STRING0: DATA.difficulty[G.difficulty],
              STRING1: G.leader || DATA.nations[G.nation].leader };
  // King-war expiry: 16 turns after the declaration stamp (@0x57FFF).
  G.kingWars = G.kingWars || {};
  for (const n of Object.keys(G.kingWars)) {
    if (G.turn >= G.kingWars[n] + 16) {
      setWar(G.nation, +n, REL.WAR, false);
      delete G.kingWars[n];
    }
  }
  if (G.flags & WOI_DECLARED) return;
  // ---- @KINGFRIGATE (func_02F052 tail) ----
  if ((G.turn & 7) === 0) {
    const { any, frig } = blockadeCensus();
    // The [0x925D + p*0x13] gate (@0x2F29B) is RESOLVED 2026-09-02: 0x924C
    // is the per-power UNIT CENSUS by type, stride 0x13 (inc @0x2D240 on a
    // build, dec @0x5BA92 on a loss, zeroed @0x42181), and 0x925D = base +
    // 0x11 = the FRIGATE row -- the King only sends a frigate to a power
    // that has none.
    const hasFrigate = G.units.some(u => u.type === 'Frigate') ||
                       G.europe.some(e => e.type === 'Frigate');
    if (!hasFrigate && (frig !== 0 || any > 3)) {
      askEvent('KINGFRIGATE',
               { ...S, STRING2: DATA.nations[G.nation].adjective },
               (choice) => {
        if (choice !== 0) return;
        G.europe.push({ type: 'Frigate', icon: unit('Frigate').icon,
                        hold: [], passengers: [], state: 'port' });
        // func_034318(+10): tax += 10, capped at 75 (@0x3434F), @KINGTAX.
        const raise = Math.min(10, 75 - G.tax);
        if (raise > 0) {
          G.tax += raise;
          showEvent('KINGTAX', { NUMBER0: raise, NUMBER1: G.tax });
        }
      });
    }
  }
  // ---- @KINGNEWWAR (func_035E80) ----
  if ((G.difficulty + 2) * G.turn < 800) return;
  const partners = G.rivals.filter(r => r.met &&
                                        haveTreaty(G.nation, r.nation));
  const T = partners.length;
  if (!T) return;
  // P (royal peace-pending pairs, (rel&0x60)==0x20) is unmodeled -> 0.
  if (Math.floor(Math.random() * ((4 - T) * 20 + 1)) > G.difficulty) return;
  // Target: the EXE rerolls random_int(0,3) until it lands on a treaty
  // partner; the port draws from the partner list directly (same
  // distribution over valid targets).
  const foe = partners[Math.floor(Math.random() * T)];
  let soldiers = 1, grant = (G.difficulty + 1) * 100;
  const theirs = unitListStrength(foe.units);
  const ours = unitListStrength(G.units);
  if (theirs > ours) {
    const d = theirs - ours;
    soldiers = (d >> 3) + 1;
    grant += 25 * d;
  }
  soldiers = Math.min(soldiers, 6 - G.difficulty);
  grant = Math.min(grant, (5 - G.difficulty) * 500);
  G.gold += grant;
  // The King's veterans arrive ON THE EUROPE DOCK (@0x360DC spawns at
  // negative coords), not in a colony.
  for (let k = 0; k < soldiers; k++) G.dockUnits.push('Veteran Soldiers');
  setTreaty(G.nation, foe.nation, REL.TREATY, false);
  setWar(G.nation, foe.nation, REL.WAR, true);
  G.kingWars[foe.nation] = G.turn;
  showEvent('KINGNEWWAR', { ...S, STRING2: DATA.nations[foe.nation].adjective,
                            NUMBER0: grant, NUMBER1: soldiers });
}
// GAME menu "DECLARE INDEPENDENCE" -> the declaration gate (func_03E984).
// Three steps, all byte-cited: already-revolting, then the SoL floor of 50,
// then the @DECLARE confirm.
function declareIndependence() {
  if (G.flags & WOI_DECLARED) { showEvent('ALREADYREVOLUTION', {}); return; }
  const meter = nationalSoL();
  if (meter < 50) { showEvent('TOOTORY', { NUMBER0: meter }); return; }
  askEvent('DECLARE', { STRING0: DATA.nations[G.nation].country }, (choice) => {
    // @DECLARE row 0 is the loyal refusal, row 1 the declaration.
    if (choice !== 1) return;
    G.flags |= WOI_DECLARED;
    G.declared = true;
    G.declaredYear = G.year;
    mobilizeContinentals();
    // @INDIANGRUDGE: tribes on the war footing hold War Council and join
    // the Tory side (the body's own terms; the muskets/horses subsidy is
    // narrative -- the raid engine already runs their war).
    for (const t of G.tribes)
      if (t && !t.dead && (t.tension || 0) >= TENSION_HOSTILE) {
        G.eventTribe = G.tribes.indexOf(t);
        showEvent('INDIANGRUDGE', { STRING0: t.name,
                                    STRING1: DATA.nations[G.nation].adjective });
      }
    // There is no Declaration woodcut: @WOODCUT's 17 captions have none, and
    // 11/12 are COLONY BURNING / COLONY DESTROYED. So the declaration is the
    // popup alone.
    showEvent('INDEPENDENCE', { STRING0: G.leader || DATA.nations[G.nation].leader });
    // @SEIZURE: every ship in the home port or on the crossing is seized
    // by the Royal Navy at the declaration (the wartime-seizure family).
    for (const e of G.europe)
      showEvent('SEIZURE', { STRING0: e.type });
    G.europe = [];
    // The Crown becomes a real power on the map, and the first wave sails.
    refWave();
  });
}
// mobilize_continentals, byte-verified: for every colony with SoL >= 50 a budget
// of ((SoL - 50) * (size / 2)) / 50, clamped to at least 1, of the veteran
// Soldiers and Dragoons standing in that colony are promoted IN PLACE --
// @UNIT type 1 Soldiers -> 9 Cont. Army, type 4 Dragoons -> 7 Cont. Cav. No
// units are created.
const CONTINENTAL_OF = { Soldiers: 'Cont. Army', Dragoons: 'Cont. Cav.' };
function mobilizeContinentals() {
  // @CANTMOBILIZE: "Continental Army can mobilize in colonies which contain
  // at least {N muskets} only" -- the muskets gate the byte-read mobilize
  // lacked. No emit site survives in the EXE scan; the threshold here is
  // the standard 50-musket equip cost, flagged.
  const NEED_MUSKETS = 50;
  if (!G.colonies.some(c => (c.stock[GOOD.MUSKETS] || 0) >= NEED_MUSKETS)) {
    showEvent('CANTMOBILIZE', { NUMBER0: NEED_MUSKETS });
    return;
  }
  let promoted = 0;
  for (const c of G.colonies) {
    if ((c.stock[GOOD.MUSKETS] || 0) < NEED_MUSKETS) continue;
    if (c.sol < 50) continue;
    let budget = Math.max(1, Math.floor((c.sol - 50) * Math.floor(c.colonists.length / 2) / 50));
    for (const u of G.units) {
      if (budget <= 0) break;
      if (u.x !== c.x || u.y !== c.y) continue;
      const to = CONTINENTAL_OF[u.type];
      if (!to) continue;
      const t = unit(to);
      u.type = t.name; u.icon = t.icon; u.moves = t.movement * MOVE_UNIT;
      u.movesLeft = Math.min(u.movesLeft, u.moves);
      budget -= 1; promoted += 1; c.mobilized = (c.mobilized || 0) + 1;
    }
    // @MOBILIZE: the per-colony mobilization card.
    if (c.mobilized) {
      showEvent('MOBILIZE', { STRING0: c.name, STRING1: 'Soldiers' });
      c.mobilized = 0;
    }
  }
  if (promoted) showEvent('MOBILIZE2', { STRING0: G.colonies[0].name, NUMBER0: promoted });
}
// A REF wave lands at a population-weighted pick over the coastal colonies, the
// same land_intervention_force the free intervention force uses: a Man-O-War
// makes the beach, the troops come ashore carried, and every land unit is a
// veteran.
const REF_WAVE = 6;
function coastalColonies() {
  return G.colonies.filter(c =>
    HALO_DIRS.some(([dx, dy]) => tileWater(at(c.x + dx, c.y + dy))));
}
function refWave() {
  const pool = coastalColonies();
  if (!pool.length || !G.colonies.length) return;
  const weights = pool.map(c => Math.max(1, c.colonists.length));
  let roll = 1 + Math.floor(Math.random() * weights.reduce((a, b) => a + b, 0));
  let target = pool[0];
  for (let i = 0; i < pool.length; i++) { roll -= weights[i]; if (roll <= 0) { target = pool[i]; break; } }
  // The beach: a water tile beside the colony for the Man-O-War, and the
  // troops come ashore onto the colony's own tile.
  const beach = HALO_DIRS.map(([dx, dy]) => [target.x + dx, target.y + dy])
    .find(([x, y]) => tileWater(at(x, y)));
  // @INVASION: "Royal Expeditionary Force lands near {colony}!" -- and the
  // first landing carries the @AMBUSHHINT tactics card (one-shot).
  showEvent('INVASION', { STRING0: target.name });
  if (!G.ambushHinted) { G.ambushHinted = true; showEvent('AMBUSHHINT'); }
  let landed = 0;
  for (const type of ['Regulars', 'Cavalry', 'Artillery']) {
    for (let k = 0; k < REF_WAVE && G.ref[type] > 0 && landed < REF_WAVE; k++) {
      G.ref[type] -= 1;
      const u = mkUnit(type, target.x, target.y);
      u.nation = -2;                      // the King's own power, not a rival
      u.veteran = true;
      G.refUnits.push(u);
      landed += 1;
    }
  }
  if (beach && G.ref['Man-O-War'] > 0) {
    G.ref['Man-O-War'] -= 1;
    const s = mkUnit('Man-O-War', beach[0], beach[1]);
    s.nation = -2;
    G.refUnits.push(s);
  }
  if (landed) showEvent('WARN2', { NUMBER1: G.colonies.length, STRING0: target.name });
}
// The per-turn war resolver. It runs while the declared bit is set and the won
// bit is clear: it counts the King's surviving land units and, when they are
// spent and no more can sail, the rebels have won.
function runWar() {
  if (!(G.flags & WOI_DECLARED) || (G.flags & WOI_WON)) return;
  growREF();
  // The NATIONAL rebel-sentiment announcements (@REBELUP/@REBELUP50/
  // @REBELDOWN), the solAnnounce band pattern at the national mirror --
  // the 10%-band trigger is the port's reading, flagged.
  const natPct = nationalSoL();
  const natBand = Math.floor(natPct / 10);
  if (G.natBand === undefined) G.natBand = natBand;
  else if (natBand > G.natBand) {
    showEvent(natPct >= 50 && G.natBand < 5 ? 'REBELUP50' : 'REBELUP',
              { NUMBER0: natPct });
    G.natBand = natBand;
  } else if (natBand < G.natBand) {
    showEvent('REBELDOWN', { NUMBER0: natPct });
    G.natBand = natBand;
  }
  // The three loss conditions + their warnings (the manual's capitulation
  // ladder; the port razes rather than occupies, so "control" reads as
  // colonies LOST -- flagged): all ports (@LOSING1, warned by @WARN1 at
  // one left), all colonies (@LOSING2), 90% of the population (@LOSING3,
  // warned by @WARN3 from 75%) with pct = razed/(razed+alive), flagged.
  const S = { STRING0: DATA.nations[G.nation].country };
  const ports = coastalColonies().length;
  if (G.colonies.length && ports === 1 && !G.warnedPorts) {
    G.warnedPorts = true;
    showEvent('WARN1', { ...S, NUMBER0: 1 });
  }
  const popPct = Math.floor(100 * (G.razed || 0) /
                            Math.max(1, (G.razed || 0) + G.colonies.length));
  if (popPct >= 75 && popPct < 90 && !G.warnedPop) {
    G.warnedPop = true;
    showEvent('WARN3', { ...S, NUMBER2: popPct });
  }
  if (!G.lostWar && G.colonies.length) {
    if (ports === 0) { G.lostWar = true; showEvent('LOSING1', S); endGameSequence(); return; }
    if (popPct >= 90) { G.lostWar = true; showEvent('LOSING3', S); endGameSequence(); return; }
  }
  // REF units march on the nearest colony; contact resolves as ordinary combat.
  for (let i = G.refUnits.length - 1; i >= 0; i--) {
    const u = G.refUnits[i];
    u.movesLeft = u.moves;
    if (u.ship) continue;
    const c = G.colonies.slice().sort((a, b) =>
      (Math.abs(a.x - u.x) + Math.abs(a.y - u.y)) - (Math.abs(b.x - u.x) + Math.abs(b.y - u.y)))[0];
    if (!c) continue;
    const dx = Math.sign(c.x - u.x), dy = Math.sign(c.y - u.y);
    if (dx === 0 && dy === 0) {
      // Standing in a rebel colony: fight whatever defends it, and take it if
      // nothing does.
      const def = G.units.find(d => d.x === c.x && d.y === c.y && !d.ship);
      if (def) { resolveAttack(u, def); continue; }
      G.colonies.splice(G.colonies.indexOf(c), 1);
      G.razed += 1;
      // A burning colony plays WDCUT11 (byte-confirmed 2026-07-30: WDCUT11 is
      // fired @0x05DADC/@0x05DFCB in func_05CA7E; WDCUT12 has NO caller in the
      // EXE -- the port had been firing the caller-less 12 here). @BURNED is
      // the message; STRING3 is the colony (the body reads "{%STRING0} burn
      // {%STRING3} to the ground!").
      // COLONY BURNING is once-only like every plate ([0x540A] bitmask); the
      // engine fires it from resolve_attack for ANY burned colony
      // (func_05CA7E @0x05DADC/@0x05DFCB) -- the REF razing loop is the only
      // path in this build that burns one.
      woodcutOnce(11);
      showEvent('BURNED', { STRING0: DATA.nations[G.refNation !== undefined
                              ? G.refNation : G.nation].adjective,
                            STRING3: c.name });
      continue;
    }
    if (!tileWater(at(u.x + dx, u.y + dy))) { u.x += dx; u.y += dy; }
    else if (!tileWater(at(u.x + dx, u.y))) u.x += dx;
    else if (!tileWater(at(u.x, u.y + dy))) u.y += dy;
  }
  // Fresh waves keep sailing while the Crown has troops left.
  const afloat = REF_TYPES.reduce((n, t) => n + G.ref[t], 0);
  if (afloat > 0 && G.refUnits.filter(u => !u.ship).length === 0) refWave();
  // Victory: the King's land units are gone and none remain to send.
  const landed = G.refUnits.filter(u => !u.ship).length;
  if (landed === 0 && afloat === 0) {
    G.flags |= WOI_WON;
    showEvent('KINGLOSE', {});
    // @WINNING: Parliament's declaration, with the General's name.
    showEvent('WINNING', { STRING0: G.leader || DATA.nations[G.nation].leader });
  }
  // Defeat: the King holds every colony. @KINGWIN is the Crown's own gloat --
  // @KINGVICTORY belongs to the European-war tax cut, not to this.
  if (!G.colonies.length && !(G.flags & WOI_WON) && !G.lostWar) {
    G.lostWar = true;
    showEvent('LOSING2', { STRING0: DATA.nations[G.nation].country });
    showEvent('KINGWIN', { STRING0: DATA.nations[G.nation].country });
    endGameSequence();
  }
}
// ------------------------------------------------------------ mercenaries
// spec/systems/mercenary.md. Both offer paths share one price shape, and it is
// byte-verified:
//   gold_per_unit = ((difficulty + K)*2 + random_int(0,6)) * 100
//   qty           = (catA + catC)*2 + count
//   price         = gold_per_unit * qty
// with K = 4 on the PEACETIME path and K = 3 on the WARTIME path.
// Wartime: count = random_int(2, (4-difficulty)/2 + 2), and a single coin picks
// exactly one category, so qty = count + 2. The offer only appears if you can
// afford it, and paying debits the treasury.
function mercPrice(K, count, cats) {
  const perUnit = ((G.difficulty + K) * 2 + Math.floor(Math.random() * 7)) * 100;
  return perUnit * (cats * 2 + count);
}
const MERC_WARTIME = ['Cont. Cav.', 'Artillery'];
function offerMercenaries() {
  if (!(G.flags & WOI_DECLARED)) return;
  // A per-power one-shot bit: an offer is possible only from the second call on,
  // and then on a 1-in-3 gate.
  if (!G.mercSeen) { G.mercSeen = true; return; }
  if (Math.floor(Math.random() * 3) !== 0) return;
  const hi = Math.floor((4 - G.difficulty) / 2) + 2;
  const count = 2 + Math.floor(Math.random() * Math.max(1, hi - 1));
  const price = mercPrice(3, count, 1);
  if (price > G.gold) return;                        // only offered if affordable
  const extra = MERC_WARTIME[Math.floor(Math.random() * MERC_WARTIME.length)];
  // The offer body is @MERCENARIES -- "The King of %STRING0 has offered to
  // send us a force of trained {mercenaries} (%STRING1) in exchange for
  // {%NUMBER0$}" -- with its own rows: 0 "No thank you.", 1 "Pay {N$}.".
  // (@KINGRECRUIT belongs to the Europe TRAIN chooser, where the audit sends
  // it back.) WHICH King offers is unread; a met rival's is the port's pick.
  const seller = G.rivals.find(r => r.met) || null;
  askEvent('MERCENARIES', {
    NUMBER0: price,
    STRING0: seller ? DATA.nations[seller.nation].country : 'Europe',
    STRING1: `${count} Cont. Army, 1 ${extra}`,
  }, (choice) => {
    if (choice !== 1 || G.gold < price) return;
    G.gold -= price;
    const c = G.colonies[0];
    const x = c ? c.x : G.units[0].x, y = c ? c.y : G.units[0].y;
    for (let i = 0; i < count; i++) {
      const u = mkUnit('Cont. Army', x, y);
      u.veteran = true;
      G.units.push(u);
    }
    G.units.push(mkUnit(extra, x, y));
    // @MERCS -- "%STRING1 mercenaries arrive in %STRING0."
    showEvent('MERCS', { STRING0: c ? c.name : DATA.nations[G.nation].homeport,
                         STRING1: count + 1 });
  });
}

// ---------------------------------------------- Tory uprising and sentiment
// The four SoL hysteresis announcements, byte-verified in func_02D658 with
// their latch bits on ColonyRecord +0x1C (0x04 = rebel-majority announced,
// 0x02 = rebel-unanimous announced). Each fires ONCE per crossing.
//   rises to >= 50   @REBELMAJORITY    set 0x04
//   rises to  = 100  @REBELUNANIMOUS   set 0x02
//   falls  <  95     @TORYMINORITY     clear 0x02
//   falls  <  50     @TORYMAJORITY     clear 0x04
function solAnnounce(c) {
  c.latch = c.latch || 0;
  // The incremental "Sons of Liberty is up/down to N%" notices (@SONSUP /
  // @SONSDOWN) fire on crossing a 10% band, in whichever direction moved.
  const band = Math.floor(c.sol / 10);
  if (c.solBand === undefined) c.solBand = band;
  else if (band > c.solBand) { cev('SONSUP', { STRING0: c.name, NUMBER0: c.sol }); c.solBand = band; }
  else if (band < c.solBand) { cev('SONSDOWN', { STRING0: c.name, NUMBER0: c.sol }); c.solBand = band; }
  if (c.sol >= 50 && !(c.latch & 0x04)) {
    c.latch |= 0x04; cev('REBELMAJORITY', { STRING0: c.name });
  }
  if (c.sol >= 100 && !(c.latch & 0x02)) {
    c.latch |= 0x02; cev('REBELUNANIMOUS', { STRING0: c.name });
  }
  if (c.sol < 95 && (c.latch & 0x02)) {
    c.latch &= ~0x02; cev('TORYMINORITY', { STRING0: c.name });
  }
  if (c.sol < 50 && (c.latch & 0x04)) {
    c.latch &= ~0x04; cev('TORYMAJORITY', { STRING0: c.name });
  }
}
// The uprising's own gate is byte-exact: random_int(0, difficulty+1), and it
// proceeds on a NONZERO roll -- so probability (difficulty+1)/(difficulty+2),
// 50% at Discoverer rising to ~83% at Viceroy. How often the war loop calls it
// is not pinned, so the port calls it once a turn per Tory-majority colony.
function toryUprising() {
  if (!(G.flags & WOI_DECLARED) || (G.flags & WOI_WON)) return;
  for (const c of G.colonies) {
    if (c.sol >= 50) continue;                        // a rebel colony has no Tories to rise
    if (Math.floor(Math.random() * (G.difficulty + 2)) === 0) continue;
    if (Math.floor(Math.random() * 12) !== 0) continue;   // the call frequency is the port's
    const u = mkUnit('Regulars', c.x, c.y);
    u.nation = -2;                                    // Tory militia fights for the Crown
    G.refUnits.push(u);
    showEvent('TORYUPRISING', { STRING0: c.name });
    return;
  }
}

// -------------------------------------------------- foreign intervention
// §18.3 bit 1. A foreign power watches the war and joins on the rebel side once
// you have generated enough liberty bells (@CONSIDER names the figure, and the
// arrival is the same population-weighted coastal landing the REF uses). The
// bell threshold itself is not in the evidence here, so the port sets it from
// the same 1000-bell scale the score uses and flags it.
const INTERVENTION_BELLS = 2000;
function checkIntervention() {
  if (!(G.flags & WOI_DECLARED) || (G.flags & WOI_INTERVENTION)) return;
  const ally = G.rivals.find(r => r.met && !atWar(G.nation, r.nation));
  if (!ally) return;
  if (!G.interventionWatch) {
    G.interventionWatch = true;
    showEvent('CONSIDER', { STRING0: DATA.nations[ally.nation].country,
                            NUMBER0: INTERVENTION_BELLS });
    return;
  }
  if (G.bellsTotal < INTERVENTION_BELLS) return;
  G.flags |= WOI_INTERVENTION;
  showEvent('INTERVENTION', { STRING0: DATA.nations[ally.nation].country,
                              STRING1: DATA.nations[G.nation].country,
                              STRING2: DATA.nations[ally.nation].adjective,
                              STRING3: G.colonies.length ? G.colonies[0].name : '',
                              STRING4: DATA.nations[ally.nation].adjective });
  // The intervention force lands like the REF, but on your side.
  const pool = coastalColonies();
  const target = pool[0] || G.colonies[0];
  if (!target) return;
  // @INTERVENE: the ally's force arriving at the landing colony.
  showEvent('INTERVENE', { STRING0: target.name,
                           STRING1: DATA.nations[ally.nation].adjective });
  for (let i = 0; i < 4; i++) {
    const u = mkUnit(i === 3 ? 'Artillery' : 'Cont. Army', target.x, target.y);
    u.veteran = true;
    G.units.push(u);
  }
}

// ------------------------------------------------------------------ score
// func_039EE2's seven components, byte-verified 2026-06-28, then the difficulty
// multiplier of func_03A9C0.
//   1 population   per colonist: +1 for an Indentured Servant / Petty Criminal /
//                  Indian Convert, +2 for a Free Colonist, +4 for anyone with a
//                  real profession
//   2 fathers      +5 each
//   3 sentiment    the national SoL meter, x1
//   4 razed        razed colonies x -(1 + difficulty)
//   5 gold         min(gold/100, 100)
//   6 liberty      the bell pool / 1000
//   7 revolution   (1780 - the declaration year) x 2, only once independence is won
// The multiplier is computed, not tabled: difficulty + 4, +1 at 3, +1 at 4 ->
// {4, 5, 6, 8, 10}.
const SCORE_PLAIN = ['Indentured Servants', 'Petty Criminals', 'Indian Converts'];
function scoreParts() {
  let population = 0;
  for (const c of G.colonies)
    for (const p of c.colonists) {
      if (SCORE_PLAIN.includes(p.profession)) population += 1;
      else if (!p.profession || p.profession === 'Free Colonists') population += 2;
      else population += 4;
    }
  const fathers = G.fathersOwned.length * 5;
  const sentiment = nationalSoL();
  const razed = (G.razed || 0) * -(1 + G.difficulty);
  const gold = Math.min(Math.floor(G.gold / 100), 100);
  const liberty = Math.floor(G.bellsTotal / 1000);
  const revolution = (G.flags & WOI_WON) && G.declaredYear
    ? (1780 - G.declaredYear) * 2 : 0;
  const base = population + fathers + sentiment + razed + gold + liberty + revolution;
  const mult = G.difficulty + 4 + (G.difficulty >= 3 ? 1 : 0) + (G.difficulty >= 4 ? 1 : 0);
  return { population, fathers, sentiment, razed, gold, liberty, revolution,
           base, mult, total: Math.floor(mult * base / 100) >> 1 };
}

// ------------------------------------------------------------ reports
// The F-key adviser ladder (§27.1). Four of the nine can be populated from
// state this build actually keeps; the rest name themselves rather than showing
// an empty frame. Each is a WOODPANL page with the adviser's own portrait.
// Each report composites over its own REPORT<N>.PIK, not WOODPANL. The N is
// NOT simply the F-key number: matching every shipped REPORT<N>.PIK against the
// DOS captures in docs/screens/reports/ over the full frame gives
//   F2 -> REPORT2 (2.7)   F3 -> REPORT3 (6.6)   F5 -> REPORT5 (14.5)
//   F6 -> REPORT6 (2.4)   F8 -> REPORT8 (5.4)   F9 -> REPORT1 (3.3)
// each at least 15 points clear of its runner-up. F9 taking REPORT1 is the
// surprise, and it cross-checks: advisor_reports.md says the shared palette is
// "identical across REPORT2/3/4/5/7/8/9" -- the two plates left out of that
// group are 1 and 6, and 1 and 6 are exactly the two this matching assigns to
// the two visually distinct reports (Indian and Colony).
// F4 -> REPORT4 is the spec's own N=4; F7 -> REPORT7 by elimination. Their
// captures could not be used: F4_labor.png and F7_naval.png are both map
// screenshots, not reports.
// F1 is not a report at all -- it is the Colonizopedia TERRAIN page
// (CLAUDE.md hard rule 7), so it routes there.
const REPORT_PIK = { F2: 'REPORT2', F3: 'REPORT3', F4: 'REPORT4', F5: 'REPORT5',
                     F6: 'REPORT6', F7: 'REPORT7', F8: 'REPORT8', F9: 'REPORT1' };
const REPORTS = {
  F2: { title: DATA.text.misc[30], draw: drawReligiousReport, body: () => {
    const thr = immigrationThreshold();
    return [`Crosses: (${G.crosses} of ${thr})`,
            `Produced per turn: ${crossesPerTurn()}`,
            '',
            'A larger empire needs more crosses:',
            'the threshold counts every colonist',
            'and every unit you own.'];
  } },
  // @MISC 206 'European Trade' -- the view the live capture shows.
  F5: { title: DATA.text.misc[50], subtitle: DATA.text.misc[206],
        draw: drawEconomicReport, body: () => {
    const l = [`Treasury: ${G.gold} gold`, `Tax rate: ${G.tax}%`,
               `Paid to the Crown: ${G.kingsFund} gold`, '', 'Market  bid / ask'];
    DATA.cargo.forEach((g, i) => {
      if (i % 2 === 0) l.push('');
      l[l.length - 1] += `  ${g.name} ${bidPrice(i)}/${askPrice(i)}`;
    });
    return l;
  } },
  F6: { title: DATA.text.misc[51], get subtitle() { return DATA.text.misc[206 + (G.f6View || 0)]; },
        draw: drawColonyReport, body: () => {
    if (!G.colonies.length) return ['You have founded no colonies.'];
    return G.colonies.map(c => {
      const f = colonyFood(c);
      return `${c.name}: ${c.colonists.length} colonists, food ` +
             `${f.net >= 0 ? '+' : ''}${f.net}, ${colonyHammers(c)} hammers` +
             (c.building ? `, building ${c.building}` : '');
    });
  } },
  F3: { title: DATA.text.misc[37], draw: drawCongressReport, body: () => {
    const cost = fatherCost();
    const l = [`Liberty bells: (${cost - G.bells} in ${cost})`,
               `Produced per turn: ${bellsPerTurn()}`,
               G.fatherInProgress ? `Working toward: ${G.fatherInProgress}` : 'No candidate chosen',
               ''];
    if (!G.fathersOwned.length) l.push('No Founding Fathers have joined yet.');
    else { l.push('In Congress:'); for (const f of G.fathersOwned) l.push(`  ${f}`); }
    return l;
  } },
  F4: { title: DATA.text.misc[49], subtitle: DATA.text.misc[56],
        draw: drawLaborReport, body: () => {
    if (!G.colonies.length) return ['You have no colonies.'];
    const l = [];
    for (const c of G.colonies) {
      l.push(`${c.name}: ${c.colonists.length} colonists`);
      const jobs = {};
      for (const p of c.colonists) {
        const k = p.cell ? `${p.job} (field)` : (p.job || 'idle');
        jobs[k] = (jobs[k] || 0) + 1;
      }
      for (const k of Object.keys(jobs)) l.push(`   ${jobs[k]} x ${k}`);
    }
    return l;
  } },
  // The seven byte-verified score components (func_039EE2) and the computed
  // difficulty multiplier {4,5,6,8,10}.
  F10: { title: DATA.text.misc[114], draw: drawScoreReport, body: () => {
    const s = scoreParts();
    return [
      `Population        ${s.population}`,
      `Founding Fathers  ${s.fathers}`,
      `Rebel sentiment   ${s.sentiment}`,
      `Colonies razed    ${s.razed}`,
      `Gold              ${s.gold}`,
      `Liberty bells     ${s.liberty}`,
      `Revolution bonus  ${s.revolution}`,
      '',
      `Difficulty x${s.mult}   TOTAL ${s.total}`,
    ];
  } },
  F8: { title: DATA.text.misc[93], draw: drawForeignReport, body: () => {
    if (!G.rivals.length) return ['No other powers are in the New World.'];
    return G.rivals.map(r => {
      const n = DATA.nations[r.nation];
      if (!r.met) return `${n.country}: no contact`;
      return `${n.country}: ${r.colonies.length} colonies, ${r.units.length} units`;
    });
  } },
  F9: { title: DATA.text.misc[29], draw: drawIndianReport, body: () => {
    const band = (n) => n >= TENSION_WAR ? 'War'
                     : n >= TENSION_HOSTILE ? 'Hostile'
                     : n >= 40 ? 'Restless' : n >= 20 ? 'Uneasy' : 'Content';
    return G.tribes.map(t => {
      const villages = G.villages.filter(v => G.tribes[v.tribe] === t).length;
      return `${t.name}: ${band(t.tension)} (${t.tension})  ${villages} settlements`;
    });
  } },
  F7: { title: DATA.text.misc[52], draw: drawNavalReport, body: () => {
    const l = [];
    for (const u of G.units) if (u.ship) l.push(`${u.type} at (${u.x}, ${u.y})`);
    for (const e of G.europe)
      l.push(`${e.type} ${e.state === 'port' ? 'in port' : 'at sea'}`);
    return l.length ? l : ['You have no ships.'];
  } },
};
// ---- advisor reports: the shared frame (spec/ui/advisor_reports.md §2.1) ----
// Background plate + centred title + OK button. There is NO advisor portrait:
// the shared draw chain is plate / title / footer rule / OK, and the painted
// scene in REPORT<N>.PIK *is* the advisor. The port used to blit an MSS0-5
// portrait over the plate -- that was invented, and the live captures
// (docs/screens/live_2026-08-05/2*_report_*.png) show no such sprite.
//
// Title colour 0x90 = (255,255,190), glyph top y=5, centred on 160; the
// subtitle sits at y=12. Both measured off 20_report_F4_labor.png, and both
// match the spec's byte cites.
const REPORT_TITLE_INK = 0x90;
const REPORT_SUB_INK = 0x91;     // (255,255,142) -- the subtitle line at y=12
const REPORT_NAME_INK = 0x92;    // (255,243,93) -- row labels
const REPORT_VALUE_INK = 0x61;   // (247,243,199) -- counts
const REPORT_RULE_INK = 0x77;    // (134,0,0) dark red -- separators
const REPORT_GREEN_INK = 0x0A;   // (85,255,85) -- F5's Tons/Gold columns

function drawReport(ctx) {
  const r = REPORTS[G.report];
  const pik = REPORT_PIK[G.report] || 'WOODPANL';
  usePalette(pik);
  ctx.drawImage(IMG[pik] || IMG.WOODPANL, 0, 0);
  if (!r) { FONT.tiny.center(ctx, 'Not in this build.', 160, 96, lut(0xFE)); return; }
  FONT.tiny.center(ctx, r.title.toUpperCase(), 160, 5, lut(REPORT_TITLE_INK));
  // The subtitle is a different ink from the title: 0x91 (255,255,142), not
  // 0x90. Measured on both 20_report_F4_labor.png and 74_report_F5_economic.png
  // -- the two live frames that have one.
  if (r.subtitle) FONT.tiny.center(ctx, r.subtitle, 160, 12, lut(REPORT_SUB_INK));
  // Per-report body: a byte-cited table where we have one, else the old text
  // stack (still portrait-free) for the reports not yet rebuilt.
  if (r.draw) r.draw(ctx);
  else {
    let y = 26;
    for (const line of r.body()) {
      for (const l2 of wrapText(FONT.tiny, line, 300)) {
        FONT.tiny.draw(ctx, l2, 2, y, lut(REPORT_NAME_INK));
        y += FONT.tiny.height + 2;
      }
      if (!line) y += 2;
    }
  }
  okButton(ctx);
}

// The OK widget the shared chain closes with (@MISC 46), bottom right.
// Measured off the live frames: a ONE-pixel hollow rectangle in the rule ink
// 0x77 at x=286..315 (w=30) y=184..197 (h=14), with no fill -- the report plate
// shows through -- and the caption in 0x92 at y=188, centred on the box. The
// port used to paint the box solid dark red with a cream border and cream text.
const OK_BOX = [286, 184, 30, 14];
function okButton(ctx) {
  const [x, y, w, h] = OK_BOX;
  hollowRect(ctx, x, y, w, h, REPORT_RULE_INK);
  FONT.tiny.center(ctx, DATA.text.misc[46] || 'OK', x + w / 2, y + 4,
                   lut(REPORT_NAME_INK));
}

// ---- F4 Labor: the occupation matrix -------------------------------------
// Three columns of [unit sprite][expert name] with the count under the name.
// All of this is measured off the live frame and cross-checked with the spec:
//   column bases x = 2 / 107 / 212        (spec: profession column di, name di+0xC)
//   name x = base + 12, ink 0x92          (spec @0x3889F)
//   count x = base + 39, ink 0x61         (spec: label_x + 0x27, @0x38675)
//   first row y = 26, row pitch 18, count 8px under its name
//   icon at (base + 2, y - 2)
// The icon is ICONS frame **81 + job index** -- found by matching the live
// pixels against every ICONS frame: Farmer->81, Sugar Planter->82,
// Fisherman(job 8)->89, all three at score 1.000.
//
// Profession -> ICONS figure, CAPTURE-PINNED 2026-08-07: every row of the
// live F4 report (docs/screens/live_2026-08-07/f4_labor.png) template-matched
// against the decoded sheet at score 1.0. @JOB rows 0..17 run contiguously at
// png 81+i (Expert Farmers 81 .. Elder Statesmen 98); the class tail uses a
// scattered cluster: Free Colonists 100 (= the Colonist unit art), Hardy
// Pioneers 58, Veteran Soldiers 59, Seasoned Scouts 60, Jesuit Missionaries
// 61, Indentured Servants 106, Petty Criminals 107, Indian Converts 66.
// Expert Teachers (99) extends the 81+i run but the engine's report omits the
// row, so 99 is a pattern extension, unobserved; Veteran Dragoons is also
// omitted and has no observed figure -- it falls back to the Dragoons unit
// sprite (104) rather than inventing one.
const PROFESSION_FIGURE = { 18: 99, 19: 100, 20: 58, 21: 59, 22: 60, 23: 104,
                            24: 61, 25: 106, 26: 107, 27: 66 };
function professionIcon(job) {
  if (job < 0 || job == null) return null;
  if (job <= 17) return 81 + job;
  return PROFESSION_FIGURE[job] !== undefined ? PROFESSION_FIGURE[job] : null;
}
const professionIconByName = (name) =>
  professionIcon((DATA.jobexpert || []).indexOf(name));
// A colonist's FIGURE everywhere the colony screen draws him: his
// profession's figure, else the plain free-colonist 100 (the F4 class
// figure). The live Curacao frame draws FIGURES in the plaza row and on
// the worked cells (the field worker matched frame 100 at score 0 -- the
// free colonist's own figure), not the map unit icons.
function colonistFigure(p) {
  const byProf = p.profession ? professionIconByName(p.profession) : null;
  if (byProf !== null && byProf !== undefined) return byProf;
  if (p.type === 'Indian Convert') {
    const f = professionIconByName('Indian Converts');
    if (f !== null && f !== undefined) return f;
  }
  return 100;
}

// The capture also fixes the ROW ORDER: 8 field jobs / 9 indoor trades /
// 9 class rows with Free Colonists LAST -- Expert Teachers and Veteran
// Dragoons are omitted by the engine's own report (26 rows, not 28).
const F4_COLS = [2, 107, 212];
const F4_ORDER = [
  [0, 1, 2, 3, 4, 5, 6, 7],
  [8, 9, 10, 11, 12, 13, 14, 15, 16],
  [17, 20, 21, 22, 24, 25, 26, 27, 19],
];
const F4_ROW0 = 26, F4_PITCH = 18;

function drawLaborReport(ctx) {
  const experts = DATA.jobexpert || [];
  F4_ORDER.forEach((jobs, c) => {
    const base = F4_COLS[c];
    jobs.forEach((job, row) => {
      const name = experts[job];
      if (!name) return;
      const y = F4_ROW0 + row * F4_PITCH;
      sheetFrame(ctx, 'ICONS', professionIcon(job), base + 2, y - 2);
      FONT.tiny.draw(ctx, name, base + 12, y, lut(REPORT_NAME_INK));
      FONT.tiny.center(ctx, String(countProfession(job)), base + 39, y + 8,
                       lut(REPORT_VALUE_INK));
    });
  });
}

// ---- shared report primitives --------------------------------------------
// `0x236` (func_002EE4): a segment-sprite GAUGE. It tiles the FILLED sprite
// across `span` up to the value, then the EMPTY sprite 0x38 past the
// threshold. Not a coloured bar -- a row of little sprites.
// Engine sprite numbers are one ahead of the atlas index (port README), so an
// engine 0x39 is disk frame 0x38.
//
// REBUILT 2026-08-06 on the byte-read verb (`func_002EE4` + its geometry helper
// `func_002D74`), replacing the old "9 slots at span/9, measured off one frame"
// stand-in. The two report call sites push `flags = 1`, and bit 0 is what turns
// a flat pitch into the spread row those screens show:
//
//   pitch    = clamp((span - w) / (slots - 1), 1, w + 1)     @0x002DCB-0x002DDA
//   totalRun = (slots - 1) * pitch >> shift, + w             @0x002DFF
//   shift    grows while totalRun would overflow the span    @0x002DF6-0x002E12
//   leftover = span - totalRun                               @0x002E25
//   per icon x += pitch, then a Bresenham pass spreads `leftover`
//            over `slots` steps                              @0x002FBA-0x002FD4
//   when the caller passes a non-zero `centre` arg the row is also shifted
//            right by leftover/2                             @0x002E36-0x002E44
//
// `slots` is the DENOMINATOR (crosses needed, bells needed) and `drawn` is how
// many icons actually appear -- the row grows toward a fixed layout rather than
// rescaling. Verified against the live F2 row: 6 crosses, 9 slots, span 300,
// w 8 reproduces x = 10, 43, 76, 110, 143, 177 exactly, and 8 or 10 slots do
// not. That also retires the old GAUGE_SLOTS constant: 9 was the live
// threshold, not a property of the widget. The overlay sprite is GAUGE_MARK,
// declared with the other strip primitives above -- it is the same EXE 0x38.

function gaugeLayout(frame, slots, span, flags, centreArg) {
  const [w0] = frameSize('ICONS', frame);
  const w = (flags & 2) ? w0 + 2 : w0;
  const pitch = slots <= 1 ? 1
    : Math.max(1, Math.min(w + 1, Math.trunc((span - w) / (slots - 1))));
  const run = (slots - 1) * pitch;
  let shift = 0;
  while ((run >> shift) > span - w && shift < 16) shift += 1;
  const totalRun = (run >> shift) + w;
  const base = (centreArg - 1 > totalRun) ? centreArg : span;
  const leftover = base - totalRun;
  return { w, pitch, shift, leftover,
           x0: centreArg ? (leftover >> 1) : 0 };
}

// `0x181F:0x236` in full. `drawn` icons of `frame`, laid out as if there were
// `slots` of them; icons past `drawn - sub` also take GAUGE_MARK.
// `numbers` is the engine's `[0x336]` -> `[0x70]` gate (@0x002FFE): the colony
// panels run with it set and the reports with it clear, which is why the live F2
// row carries no count badge. A pitch of 1 with a count above 1 forces the badge
// on regardless, since the icons are then stacked and unreadable (@0x003004).
function gauge(ctx, frame, drawn, sub, slots, x, y, span, flags, centreArg, numbers) {
  if (drawn <= 0 || slots <= 0) return;
  flags = flags || 0;
  if (numbers === undefined) numbers = 1;
  const g = gaugeLayout(frame, slots, span, flags, centreArg || 0);
  const n = drawn >> g.shift, filled = (drawn - sub) >> g.shift;
  const b = slots >> g.shift;
  let cx = x + g.x0, acc = 0, markX = null;
  for (let i = 0; i < n; i++) {
    sheetFrame(ctx, 'ICONS', frame, cx, y + 1);
    if (i === filled) markX = cx;
    if (i >= filled) sheetFrame(ctx, 'ICONS', GAUGE_MARK, cx, y + 1);
    cx += g.pitch;
    if (flags & 1) {
      acc += g.leftover;
      while (b > 0 && acc >= b) { acc -= b; cx += 1; }
    }
  }
  if (!numbers && !(g.pitch === 1 && drawn > 1)) return;
  countBadge(ctx, drawn - sub, x + g.x0 + 2, y, 0x0F);
  if (markX !== null) countBadge(ctx, sub, markX + 2, y, 0x0C);
}

// ---- F2 Religious: one crosses gauge -------------------------------------
// spec §4: X=0xA, Y=0x19, span 0x12C, FILLED sprite 0x39, EMPTY 0x38.
function drawReligiousReport(ctx) {
  // (x=0xA, y=0x19, span=0x12C, flags=1, sprite EXE 0x39, drawn = crosses so
  // far `[bx+0x2E]`, slots = crosses needed `[bx+0x30]`) -- @0x037990-0x0379B4.
  // The live frame carries NO count badge and no "n / m" caption -- the strip is
  // the whole readout -- so numbers are off and the caption the port used to add
  // is gone.
  // The gauge SPAN is the STORED threshold, PowerRecord +0x30 (func_037958
  // reads the pair @0x0379AB/AE). Recomputing at draw time gave 268 where the
  // record holds 284 -- the port's G.units excludes Europe-side and
  // aboard-ship records that the original's count iterates -- which spread
  // the crosses ~6% wider and leaked sprite edges through the smear (C4.23).
  gauge(ctx, 0x39 - 1, G.crosses, 0, G.crossThreshold || immigrationThreshold(),
        0x0A, 0x19, 0x12C, 1, 0, 0);
}

// ---- F3 Continental Congress ---------------------------------------------
// spec §4: bell gauge (X=4, span 0x12C, FILLED 0x3F); rebel/tory sprite strip
// (rebel 0x7C x rebel-count, tory 0x7D x tory-count, x=4); FF name grid at
// columns {4,82,160,238}, step 0x4E, 4 per row, colour 0x61.
const F3_FF_COLS = [4, 82, 160, 238];
function drawCongressReport(ctx) {
  const fh = FONT.tiny.height + 2;
  const m = DATA.text.misc;
  let y = 24;
  // Live frame names the father under debate: "...Session: (Adam Smith)".
  FONT.tiny.draw(ctx, `${m[112] || 'Next Continental Congress Session'}:` +
                      (G.fatherInProgress ? ` (${G.fatherInProgress})` : ''),
                 4, y, lut(REPORT_NAME_INK));
  y += fh;
  // Same shape, sprite EXE 0x3F, x from `[bp-0x56]` and y from `[bp-0x5A]`
  // (@0x037BCE-0x037BF5).
  //
  // UNVERIFIED, and known not to match the one live frame that has bells on it.
  // `docs/screens/live_1653_save/report_F3.png` shows a "252" badge and 22 bell
  // icons whose steps are [4 x11, 3, 4 x9] -- and no (slots, drawn) pair
  // reproduces that sequence under the byte-read gauge geometry; 6000 slot
  // counts were searched and none fits, and 252 cannot be any `drawn >> shift`
  // that yields 22 icons. So either the call site's arguments differ from the
  // reading above or a different path draws that row. Left as the F2 analogy
  // with the discrepancy recorded rather than tuned to fit.
  gauge(ctx, 0x3F - 1, G.bells, 0, fatherCost(), 4, y, 0x12C, 1, 0, 0);
  y += 12;
  // Rebel sentiment = the mean Sons-of-Liberty percentage across colonies.
  const rebel = G.colonies.length
    ? Math.round(G.colonies.reduce((a, c) => a + (c.sol || 0), 0) / G.colonies.length)
    : 0;
  // @MISC 69/70/71 = Rebel / Tory / Sentiment -- the live frame reads
  // "Rebel Sentiment: 10%  Tory Sentiment: 90%".
  FONT.tiny.draw(ctx, `${m[69] || 'Rebel'} ${m[71] || 'Sentiment'}: ${rebel}%  ` +
                      `${m[70] || 'Tory'} ${m[71] || 'Sentiment'}: ${100 - rebel}%`,
                 4, y, lut(REPORT_NAME_INK));
  y += fh;
  // One icon PER PERCENT (the live tory row is a dense ~90-crown run). The
  // spec's sprite ids 0x7C/0x7D are 1-based like every other report sprite
  // (F2's crosses pass 0x39-1): rebel = flag frame 0x7B, tory = crown 0x7C.
  drawCountRow(ctx, [{ frame: 0x7B, count: rebel, sub: 0, flags: 0 },
                     { frame: 0x7C, count: 100 - rebel, sub: 0, flags: 0 }],
               4, y, 0x12C, 2);
  y += 12;
  FONT.tiny.draw(ctx, `${DATA.nations[G.nation].adjective} ${m[85] || 'Expeditionary Force'}:`,
                 4, y, lut(REPORT_NAME_INK));
  y += fh;
  // REF quartet -- @UNIT icon column (1-based; UNITS[] already holds icon-1):
  // Regulars 126->125 red-coat, Cavalry 127->126 mounted, Artillery 10->9
  // cannon, Man-O-War 128->127 warship. Verified against the live 1653 frame.
  drawCountRow(ctx,
    [{ frame: unit('Regulars').icon, count: G.ref.Regulars || 0, sub: 0, flags: 0 },
     { frame: unit('Cavalry').icon, count: G.ref.Cavalry || 0, sub: 0, flags: 0 },
     { frame: unit('Artillery').icon, count: G.ref.Artillery || 0, sub: 0, flags: 0 },
     { frame: unit('Man-O-War').icon, count: G.ref['Man-O-War'] || 0, sub: 0, flags: 0 }],
    4, y, 0x12C, 2);
  y += 14;
  FONT.tiny.draw(ctx, `${m[89] || 'Founding Fathers'}:`, 4, y,
                 lut(REPORT_NAME_INK));
  y += fh;
  G.fathersOwned.forEach((name, i) => {
    FONT.tiny.draw(ctx, name, F3_FF_COLS[i % 4], y + Math.floor(i / 4) * fh,
                   lut(REPORT_VALUE_INK));
  });
}

// ---- F5 Economic ----------------------------------------------------------
// REBUILT from the live frame (docs/screens/live_2026-08-05/74_report_F5_economic.png).
// It is a 16-row ruled price table with FOUR right-aligned numeric columns and
// NO commodity icons -- the good's name starts at the very left margin.
//
//   subtitle    @MISC 206 'European Trade', centred y=12, ink 0x91
//   headers     y=25, ink 0x92, drawn LEFT at x = 76 / 131 / 170 / 220
//               (@MISC 58 Tons / 59 Gold / 203 Bid Price / 204 Ask Price;
//               the spec's cited 76/170/220 are three of those four x's)
//   rules       y = 33 + 8*i for i=0..16, x 2..312 inclusive, ink 0x77
//   good name   x=2, y = 35 + 8*i, ink 0x92
//   values      right-aligned (advance edge) at x = 92 / 145 / 200 / 251;
//               Tons and Gold in 0x0A bright green, the two prices in 0x61
//   the Gold column and both price columns carry a trailing '$'
//
// There is NO second view (B3.2 closed 2026-08-29): @MISC 91 '(Building
// Upkeep)' / 92 'TOTAL UPKEEP' have no consumer anywhere in VICEROY.EXE --
// their pointer slots [0x2E70]/[0x2E72] are never read and no constant 91/92
// reaches the by-index printer func_00C09A. They are orphans of the cut
// building-upkeep feature; European Trade is the whole report.
const F5_RULE0 = 33, F5_PITCH = 8;
const F5_HEAD_X = [76, 131, 170, 220];
const F5_VAL_X = [92, 145, 200, 251];
const F5_HEAD_MISC = [58, 59, 203, 204];

function drawEconomicReport(ctx) {
  F5_HEAD_MISC.forEach((mi, c) =>
    FONT.tiny.draw(ctx, DATA.text.misc[mi], F5_HEAD_X[c], 25,
                   lut(REPORT_NAME_INK)));
  ctx.fillStyle = ink(REPORT_RULE_INK);
  for (let i = 0; i <= DATA.cargo.length; i++)
    ctx.fillRect(2, F5_RULE0 + i * F5_PITCH, 311, 1);
  // The VERTICAL rule between the commodity names and the price columns:
  // x = 67, rows 25..176, same rule ink -- measured off the census baseline
  // (137 of its 152 rows are the untouched ink; the rest is where text
  // crosses it).
  ctx.fillRect(67, 25, 1, 152);
  DATA.cargo.forEach((g, i) => {
    const y = F5_RULE0 + 2 + i * F5_PITCH;
    FONT.tiny.draw(ctx, g.name, 2, y, lut(REPORT_NAME_INK));
    const cells = [
      [String(europeTons(i)), REPORT_GREEN_INK],
      [`${f5Gold(europeGold(i))}$`, REPORT_GREEN_INK],
      [`${bidPrice(i)}$`, REPORT_VALUE_INK],
      [`${askPrice(i)}$`, REPORT_VALUE_INK],
    ];
    cells.forEach(([s, k], c) =>
      FONT.tiny.right(ctx, s, F5_VAL_X[c], y, lut(k)));
  });
}
// Tons and Gold are the PowerRecord's whole-game NET TRADE counters, resolved
// 2026-08-07 against the 1653 frame (report_F5.png): Tons = +0xBC net units
// through Europe (Muskets 0t / 351$ rules out any inventory reading), Gold =
// +0x7C net value -- sale proceeds after tax minus purchase costs.
const europeTons = (g) => (G.tradeTons && G.tradeTons[g]) || 0;
const europeGold = (g) => (G.tradeGold && G.tradeGold[g]) || 0;
// Large values abbreviate at EXACTLY 10000, floor-truncated -- CAPTURE-PINNED
// 2026-08-07 with 16 probe values patched into a save's net-trade array
// (docs/screens/live_2026-08-07/f5_k_probe.png): 9999 prints in full, 10000
// prints "10K", 12999 prints "12K". The old 6072..12999 uncertainty is closed.
const f5Gold = (v) => Math.abs(v) >= 10000 ? `${Math.trunc(v / 1000)}K` : String(v);

// ---- F6 Colony ------------------------------------------------------------
// spec §4: base x=2, rows pitch 0x11=17, 9 per page, colony NAME ink 0x92 at
// x=base+0x17=25 and y=row+7; four centred captions ink 0x92 in boxes
// (2,80)/(82,80)/(162,80)/(242,76). The spec cites the caption band at y=27 and
// the row base at y=0x14=20, which cannot both hold -- captions are treated as
// the column header here and the rows start under them. TBD.
const F6_CAPS = [[2, 80], [82, 80], [162, 80], [242, 76]];
function drawColonyReport(ctx) {
  // @MISC 206 European Trade / 207 Cargo in Port / 208 Military Garrisons /
  // 209 Sons of Liberty -- the four consecutive strings that exist for exactly
  // this row of captions.
  // The four captions are the report's VIEW MODES, not a static header row:
  // the live frame's subtitle line reads "Military Garrisons"
  // (docs/screens/live_2026-08-05/71_report_F6.png), i.e. caption[2]. They are
  // drawn as a selector strip with the active one highlighted.
  // No caption strip is drawn: the live frame shows the active view's name in
  // the SUBTITLE line only ("Military Garrisons"), with the body under it.
  // F6_CAPS keeps the cited box geometry for when the selector is wired up.
  G.colonies.slice(0, 9).forEach((c, i) => {
    const y = 32 + i * 17;
    // ICONS disk band 0-3 are the colony markers, frame = nation.
    drawSettlement(ctx, 2, y - 2, colonyLevel(c), c.nation, 0);
    FONT.tiny.draw(ctx, c.name, 25, y + 7, lut(REPORT_NAME_INK));
    FONT.tiny.draw(ctx, String(c.colonists.length), 122, y + 7, lut(REPORT_VALUE_INK));
    // Cargo in port: one goods sprite per stocked commodity.
    let cx = 162;
    c.stock.forEach((n, g) => {
      if (n > 0 && cx < 238) { sheetFrame(ctx, 'ICONS', 0x16 + g, cx, y); cx += 10; }
    });
    FONT.tiny.draw(ctx, String(garrisonOf(c)), 250, y + 7, lut(REPORT_VALUE_INK));
  });
}
const garrisonOf = (c) =>
  G.units.filter(u => !u.ship && u.x === c.x && u.y === c.y).length;

// ---- F7 Naval -------------------------------------------------------------
// CORRECTED against the live frame (docs/screens/live_2026-08-05/75_report_F7_naval.png).
// The spec's row geometry holds -- first row y=0x2A=42, pitch 0x14=20, 7 ships
// per page, name LEFT ink 0x61 at x=26, Location/Destination centred in the
// boxes at 162 w=80 and 242 w=76 -- but two of its statements do not:
//
//   * "Exactly ONE rule per page = footer" is WRONG. The live report is a full
//     grid: horizontal rules at y = 40 + 20*i for i=0..7 spanning x 2..314, and
//     three column separators at x = 82 / 162 / 242 running y=25..180.
//   * the four headers are centred in THOSE columns, not over the fields:
//     Ship (2..82) -> 42, Cargo (82..162) -> 122, Location (162..242) -> 202,
//     Destination (242..314) -> 278. Header glyph top y=27, ink 0x92.
//
// The port previously centred Ship on 68 and Cargo on 137, which is what the
// spec's field x's imply; the frame says otherwise.
const F7_ROW0 = 42, F7_PITCH = 20, F7_PER_PAGE = 7;
const F7_COLX = [2, 82, 162, 242, 314];   // column edges, left to right
// Header/value centres. The first three are their columns' midpoints; the last
// is 280, i.e. the midpoint of the spec's Destination BOX (x=242 w=76 -> 318),
// which runs past the grid's right rule at 314. Measured: the "Destination"
// header's ink starts at x=262, which is 280-centred, not 278-centred.
const F7_CENTRE = [42, 122, 202, 280];
const F7_GRID_TOP = 25, F7_GRID_BOT = 180, F7_RULE0 = 40;
function drawNavalReport(ctx) {
  ctx.fillStyle = ink(REPORT_RULE_INK);
  for (let y = F7_RULE0; y <= F7_GRID_BOT; y += F7_PITCH)
    ctx.fillRect(F7_COLX[0], y, F7_COLX[4] - F7_COLX[0] + 1, 1);
  for (let c = 1; c < 4; c++)
    ctx.fillRect(F7_COLX[c], F7_GRID_TOP, 1, F7_GRID_BOT - F7_GRID_TOP + 1);
  [61, 62, 63, 64].forEach((mi, c) =>
    FONT.tiny.center(ctx, DATA.text.misc[mi], F7_CENTRE[c], 27,
                     lut(REPORT_NAME_INK)));
  // Location column @0x0396A4 (formatter 0x191F:0xF82): the colony NAME when
  // the ship sits on a colony tile, else "(x, y)".
  const ships = G.units.filter(u => u.ship)
    .map(u => {
      const col = G.colonies.find(c => c.x === u.x && c.y === u.y);
      return { u, loc: col ? col.name : `(${u.x}, ${u.y})`, dest: '' };
    })
    .concat(G.europe.map(e => ({
      u: e,
      loc: DATA.nations[G.nation].homeport,
      dest: e.state === 'port' ? '' : (DATA.text.misc[10] || 'Bound For'),
    })));
  ships.slice(0, F7_PER_PAGE).forEach((s, i) => {
    const y = F7_ROW0 + i * F7_PITCH;
    const cu = unit(s.u.type);
    // Ship cell: the func_00386A composite. The old rule -- plate at a fixed
    // (2,y), hull right-aligned in a 16-wide box -- could not be right, and the
    // comment that used to sit here said so: the Frigate landed a pixel off
    // "unexplained". It is explained now. The plate's SIDE depends on the unit
    // CLASS: a Galleon or Frigate (class 1) wears it to the RIGHT of the hull,
    // a Merchantman or Caravel (class 3) to the LEFT. See unitPanel().
    if (cu) unitPanel(ctx, F7_PANEL_X, y, 0, s.u.type,
                      unitFlags(s.u), s.u.orders || 0,
                      DATA.nations[G.nation].color, cu.icon, G.nation);
    FONT.tiny.draw(ctx, s.u.type, 26, y + 6, lut(REPORT_VALUE_INK));
    // Cargo column (func_03954C): one crate per occupied HOLD, engine frame =
    // (qty >= 0x64 ? 0x17 : 0x27) + good (@0x039605 full, @0x0395A8 partial;
    // goods via 0x181F:0xBE6, qty via 0xC68) = bundle icon 22 + good full /
    // 38 + good partial, at x = 88 + 12k, y = row + 3. Units aboard draw the
    // generic crate (icon 22) after the goods.
    let cx = F7_CARGO_X;
    if (s.u.ship) {
      // The runtime hold MERGES same-good slots (holdAdd), but the engine
      // draws per RECORD slot -- one crate per 100 plus a partial (rec 0's
      // two full fur holds sit merged as {furs, 200} and the baseline shows
      // TWO crates).
      (s.u.hold || []).forEach((h) => {
        if (h.qty <= 0) return;
        let q = h.qty;
        while (q >= 100) {
          sheetFrame(ctx, 'ICONS', 22 + h.good, cx, y + 3);
          cx += F7_CARGO_PITCH;
          q -= 100;
        }
        if (q > 0) {
          sheetFrame(ctx, 'ICONS', 38 + h.good, cx, y + 3);
          cx += F7_CARGO_PITCH;
        }
      });
      (s.u.cargo || []).forEach(() => {
        sheetFrame(ctx, 'ICONS', F7_CARGO_ICON, cx, y + 3);
        cx += F7_CARGO_PITCH;
      });
    }
    FONT.tiny.center(ctx, s.loc, F7_CENTRE[2], y + 6, lut(REPORT_VALUE_INK));
    FONT.tiny.center(ctx, s.dest, F7_CENTRE[3], y + 6, lut(REPORT_VALUE_INK));
  });
}
const F7_CARGO_X = 88, F7_CARGO_PITCH = 12, F7_CARGO_ICON = 22;

// ---- F8 Foreign Affairs ---------------------------------------------------
// REBUILT against the live frame (docs/screens/live_2026-08-05/70_report_F8.png).
// It is NOT the 6-row Colonies/Population/... strength table I first built from
// the spec's label list -- with no colonies founded the report is four per-power
// blocks, and the geometry is exact:
//     separator rule   y = 10 + 45*i   (full width, dark)
//     power header     y = 16 + 45*i   "<Leader>'s <Nationality>:" at x=2
//     counts           y = 27 + 45*i   "Rebels: N" at x=2, "Tories: N" at x=80
// Block pitch 45, four powers. Whether the strength labels @MISC 95-100 appear
// in this same body once colonies exist is UNVERIFIED -- the capture was taken
// on turn 1.
const F8_BLOCK = 45, F8_RULE0 = 10, F8_HEAD0 = 16, F8_ROW0 = 27, F8_TORY_X = 80;
function drawForeignReport(ctx) {
  DATA.nations.forEach((n, i) => {
    const ry = F8_RULE0 + i * F8_BLOCK;
    ctx.fillStyle = ink(0); ctx.fillRect(0, ry, 320, 1);
    const r = G.rivals.find(v => v.nation === i);
    const leader = (i === G.nation ? G.leader : '') || DATA.nations[i].leader;
    FONT.tiny.draw(ctx, `${leader}'s ${n.adjective}:`, 2, F8_HEAD0 + i * F8_BLOCK,
                   lut(REPORT_NAME_INK));
    const y = F8_ROW0 + i * F8_BLOCK;
    const mine = i === G.nation;
    const rebels = mine ? G.colonies.filter(c => (c.sol || 0) >= 50).length
                        : ((r && r.colonies) || []).length;
    const tories = mine ? G.colonies.filter(c => (c.sol || 0) < 50).length
                        : ((r && r.units) || []).length;
    // @MISC 86 'Rebels' / 87 'Tories' -- the plurals, which is what the live
    // frame prints (69/70 are the singular 'Rebel'/'Tory' used by F3's strip).
    FONT.tiny.draw(ctx, `${DATA.text.misc[86]}: ${rebels}`, 2, y,
                   lut(REPORT_VALUE_INK));
    FONT.tiny.draw(ctx, `${DATA.text.misc[87]}: ${tories}`, F8_TORY_X, y,
                   lut(REPORT_VALUE_INK));
  });
}

// ---- F9 Indian ------------------------------------------------------------
// REBUILT from the live frame (docs/screens/live_2026-08-05/76_report_F9_indian.png).
// A per-tribe block, not a status grid. For the one tribe met on the capture
// turn (Tupi):
//
//   tribe portrait   16x16 at (10, 25)
//   tribe name       x=30, glyph top y=28, ink 0x47 = (4,93,4) dark green
//   settlement count x=41, y=36, ink BLACK -- "13 Camps", the @LEVELS plural
//   tech level       right-aligned at x=311, y=28, ink 0x47 ("Semi-Nomadic")
//
// Two things the spec gets differently and the frame overrules:
//   * cell colour is index 0x47, not the @COLORS "basic" 68. Under the
//     REPORT1.PIK palette 68 is (85,150,52) and 71 is (4,93,4); only the
//     latter appears in the frame.
//   * the count line is drawn in black, with no dark-core shadow of its own.
//
// Row geometry, measured on the 1653 frame (docs/screens/live_1653_save/
// report_F9.png), which has seven tribes on it:
//   icon bands 25..40, 46..61, 67..82, 88..103, 109..124, 130..145, 151..166
//   -> icon top y = 25 + 21*i, so the block PITCH is 21, not the 18 guessed
//   before. Name y = 28 + 21*i, count line y = 36 + 21*i.
//
// A tribe with no settlements left prints "<Name>: Extinct" (@MISC 130) on the
// name line and nothing else. A tribe holding muskets or horses adds two more
// cells on the count line, at x=152 and x=209 (one sample each: the Apache row
// reads "50 Muskets" and "1 Horse Herds").
const F9_ICON_X = 10, F9_NAME_X = 30, F9_COUNT_X = 40, F9_LEVEL_RX = 311;
// The sub-line is FOUR cells at pitch 0x38 = 56, decoded from the row loop
// itself -- `add word ptr [bp-0x68], 0x38` three times, @0x037728, @0x037783,
// @0x0377D2 -- so the grid is 40 + 56k: settlements 40, missions 96, muskets
// 152, horse herds 208. The two x's the port already carried came from a
// capture and landed on 152 and 209; 208 is the decoded one.
const F9_MUSKET_X = 152, F9_HORSE_X = 208;
// Seven blocks fill the plate (25 + 7*21 = 172, and the OK box starts at 184),
// which is why the 1653 frame stops at seven. The spec calls F9 "multi-page via
// paginator func_039E98"; that paginator is NOT wired up here, so an eighth
// contacted tribe would simply not be shown. TBD.
// F9_PER_PAGE is 8, straight from the row loop's own bound `cmp
// [bp-0x64], 8` (quoted below): the engine draws ALL EIGHT tribes in one
// pass at pitch 21 -- there is no F9 paginator. (The ledger's old B3.3
// blamed func_039E98 for a missing pager; that function is byte-disproved
// as the SCORE screen's population-icon flow placer -- see
// docs/REMAINING_WORK.md B3.3.) The port's 7 was the actual bug: an 8th
// contacted tribe was silently dropped.
const F9_ICON_Y = 25, F9_ROW0 = 28, F9_PITCH = 21, F9_PER_PAGE = 8;
// ICONS 113..117 are five near-identical native portraits. The 1653 frame uses
// 116 for five of its seven rows, 115 for the Apache and 113 for the Sioux --
// no rule derivable from tribe index, tech level or settlement count, which is
// what an animation counter looks like. UNRESOLVED; 116 is the modal frame.
const F9_PORTRAIT = 116;
// The report body's SHADOWED text.
//
// The original draws these labels with a black drop shadow at exactly three
// offsets -- (+1,0), (0,+1) and (+1,+1) -- and the coloured glyph on top. That
// is not a guess: on the census F9 frame the model reproduces the black pixels
// EXACTLY on two independent rows, 134/134 and 88/88, with zero missing and
// zero extra. The 4- and 8-neighbour outlines both over-predict (48 and 83
// extra pixels on the same row), so the shadow is the down-right quadrant and
// nothing else. The port drew the glyph alone, so every label on the screen
// came out thinner and lighter than the original's.
// FONT.draw's OWN `shadow` argument already draws exactly these three offsets
// (see the [[1,0],[0,1],[1,1]] loop in the class); F9 simply never passed it.
const f9Shadow = (ctx, str, x, y, tk) =>
  FONT.tiny.draw(ctx, str, x, y, tk, ink(0));
function drawIndianReport(ctx) {
  const black = [ink(0), ink(0), ink(0)];
  // WHICH TRIBES GET A ROW -- byte-verified at @0x03784C-@0x037860. The row
  // loop calls the relation getter (0x181F:0xA38 = func_007F34) with
  // (tribe + 4, power) and draws the row when `al & 0x20`; failing that it
  // falls back on TribeRecord +0x03 bit 0x80, and only if BOTH are clear does
  // it skip to the next tribe. The pitch in that same loop is
  // `add [bp-0x5C], 0x15` = 21 (F9_PITCH) and the bound is `cmp [bp-0x64], 8`.
  //
  // The port used to list a tribe when it had a village on an EXPLORED tile.
  // That is a different question, and it got the census frame wrong twice
  // over: it dropped the three EXTINCT tribes the original lists (Incas,
  // Aztecs, Tupi -- contacted, then wiped out, drawn as "<name>: Extinct"),
  // and it agreed about the Iroquois only by accident. The original skips the
  // Iroquois because their relation byte is 0 -- never contacted -- even
  // though they own ELEVEN villages on that save.
  const listed = G.tribes
    .map((t, i) => [t, i])
    .filter(([t]) => t.met || (t.recFlags & 0x80));
  listed.slice(0, F9_PER_PAGE).forEach(([t, i], row) => {
    const y = F9_ROW0 + row * F9_PITCH;
    const n = G.villages.filter(v => v.tribe === i).length;
    const lv = tribeLevel(t);
    sheetFrame(ctx, 'ICONS', F9_PORTRAIT, F9_ICON_X, F9_ICON_Y + row * F9_PITCH);
    // The name ink is the tribe's OWN colour -- @TRIBES' last column, the same
    // palette index the minimap uses. Verified pixel-exact for all seven tribes
    // on the 1653 frame (Inca 97 cream, Aztec 149 gold, Arawak 54 blue,
    // Cherokee 67 green, Apache 111 tan, Sioux 118 dark red, Tupi 71 dark
    // green). The spec's "cell colour = @COLORS basic 68" does not hold.
    // The Sioux row is HARDCODED red: the row painter sets the ink from
    // [0x848 + power] and then overrides power index 0xA -- tribe 6, the
    // Sioux -- to 0x0C (`cmp bx, 0xA; mov [bp-0x6E], 0xC` @0x037496-
    // @0x03749B). The census flag "one tribe, cause UNKNOWN" is closed:
    // it is a literal special case in the EXE.
    const tk = lut(i === 6 ? 0x0C : t.color);
    if (!n) {
      f9Shadow(ctx, `${t.name}: ${DATA.text.misc[130]}`, F9_NAME_X, y, tk);
      return;
    }
    f9Shadow(ctx, t.name + ':', F9_NAME_X, y, tk);
    FONT.tiny.right(ctx, lv.name, F9_LEVEL_RX, y, tk, ink(0));
    FONT.tiny.draw(ctx, `${n} ${n === 1 ? lv.one : lv.many}`, F9_COUNT_X, y + 8, black);
    // MUSKETS (@0x03766D-@0x0376B1): seed from TribeRecord +0x07, add one per
    // unit of that tribe whose type is 0x14 (Armed Braves) or 0x16 (Mtd.
    // Warriors) -- `cmp [bx+0x3146], 0x14 / 0x16` @0x03768E and @0x037695 --
    // then multiply by 50 (`mov ax, 0x32; imul` @0x0376AB). Drawn only when
    // nonzero (@0x037787).
    // HORSE HERDS (@0x0377D6): TribeRecord +0x08 verbatim, drawn only when
    // nonzero. On the census fixture the Apache carry +0x07 = 0 with one Armed
    // Brave -> "50 Muskets", and +0x08 = 1 -> "1 Horse Herds" -- exactly the
    // original's row. The port used to read both from a RUNTIME v.stock map
    // the import leaves empty, so neither cell ever drew.
    //
    // NOT implemented: the MISSIONS cell at x = 96 (@0x037650 counts this
    // tribe's settlements whose mission byte's low nibble equals the power,
    // drawn with the singular/plural pair [0x2DF0]/[0x2DF2]). The counting
    // rule is byte-cited; the two STRINGS are not resolved and the census
    // fixture has no Dutch mission to show them. Flagged, not invented.
    const armed = G.natives.filter(u => u.tribe === i &&
      (u.type === (DATA.units[0x14] || {}).name ||
       u.type === (DATA.units[0x16] || {}).name)).length;
    const muskets = ((t.musketsKnown || 0) + armed) * 50;
    const horses = t.horsesKnown || 0;
    if (muskets)
      FONT.tiny.draw(ctx, `${muskets} ${DATA.cargo[15].name}`, F9_MUSKET_X, y + 8, black);
    if (horses)
      FONT.tiny.draw(ctx, `${horses} ${DATA.text.misc[45]}`, F9_HORSE_X, y + 8, black);
  });
}
// NAMES @LEVELS: "<tech name>, <settlement singular>, <settlement plural>".
const TRIBE_LEVELS = [
  { name: 'Semi-Nomadic', one: 'Camp', many: 'Camps' },
  { name: 'Agrarian', one: 'Village', many: 'Villages' },
  { name: 'Advanced', one: 'City', many: 'Cities' },
  { name: 'Civilized', one: 'City', many: 'Cities' },
];
const tribeLevel = (t) => TRIBE_LEVELS[Math.min(t.level || 0, 3)];
const tribeStock = (ti, good) =>
  (((G.tribes[ti] || {}).stock || [])[good] || 0);
const tensionBand = (n) => n >= TENSION_WAR ? 'War'
  : n >= TENSION_HOSTILE ? 'Hostile' : n >= 40 ? 'Restless'
  : n >= 20 ? 'Uneasy' : 'Content';

// ---- F10 Colonization Score ----------------------------------------------
// REBUILT from the live frame (docs/screens/live_2026-08-05/73_report_F10.png).
// Not a table of big FONTINTR figures -- it is a green score BREAKDOWN with a
// sprite row under each component:
//     title      y=5   centred, gold
//     subtitle   y=13  centred, gold:
//                "<Difficulty> <Leader> of the <Nationality>: <Season> <Year>"
//     component  x=16  green, "<Nationality> <Component>: +N", pitch 28,
//                with a row of the counted sprites under it
//     tail             Gold and Total Score at the bottom
// Measured green rows: 24, 52, 150.
const F10_X = 16, F10_ROW0 = 24, F10_PITCH = 28, F10_GREEN = 68;
function drawScoreReport(ctx) {
  const s = scoreParts();
  const nat = DATA.nations[G.nation];
  FONT.tiny.center(ctx,
    `${DATA.difficulty[G.difficulty]} ${G.leader} of the ${nat.adjective}: ` +
    `${DATA.seasons[G.season] || ''} ${G.year}`,
    160, 13, lut(REPORT_TITLE_INK));
  // Citizens, then the Continental Congress contribution.
  const rows = [[DATA.text.misc[115], s.population, 0x66],
                [DATA.text.misc[196] || 'Continental Congress', s.fathers, 0x3F]];
  rows.forEach(([label, value, sprite], i) => {
    const y = F10_ROW0 + i * F10_PITCH;
    FONT.tiny.draw(ctx, `${nat.adjective} ${label}: +${value}`, F10_X, y,
                   lut(F10_GREEN));
    drawCountRow(ctx, [{ frame: sprite, count: Math.min(value, 12), sub: 0, flags: 0 }],
                 F10_X, y + 8, 0x12C, 2);
  });
  FONT.tiny.draw(ctx, `${DATA.text.misc[59]}: (${G.gold}$ x${s.mult})`,
                 F10_X, 150, lut(F10_GREEN));
  FONT.tiny.draw(ctx, `${DATA.text.misc[121]}: ${s.total}`, F10_X, 162,
                 lut(F10_GREEN));
}

// Colonists working that job, across every colony, plus units in the field
// carrying the matching profession.
function countProfession(job) {
  const expert = (DATA.jobexpert || [])[job];
  let n = 0;
  for (const col of G.colonies)
    for (const c of col.colonists)
      if (c.job === job || c.profession === expert) n++;
  for (const u of G.units) if (u.profession === expert) n++;
  return n;
}

// ------------------------------------------------------------ immigration
// §17.6. The THRESHOLD is byte-cited:
//   accum = Σ colony populations + 1 per owned unit
//   if accum < 4000: accum *= 2 ; accum += 8 ; clamp 4000
//   difficulty scale x(8-d)/8 for the human; England x2/3
// A bigger empire therefore SLOWS immigration. When the cross accumulator
// passes it a colonist appears on the Europe dock, announced through @UNREST.
//
// The per-turn cross ACCRUAL site (church/cathedral production) is explicitly
// unidentified in the repo, so the rate below is a flagged placeholder: one
// cross per colony per turn, plus one more per Church and per Cathedral.
// Tracked in docs/UI_AUDIT_TRACKER.md.
// BYTE_VERIFIED end to end 2026-08-28 (func_035D9A): count = colony
// populations + ONE PER OWNED UnitRecord, owner nibble +0x03 only
// (@0x35DDE..@0x35DF8) -- Europe-parked ships, their riders, in-port dock
// units and riders aboard on-map ships ALL count (C4.29: the port's
// on-map-only membership read 130 where the fixture's stored 284 = 2*138+8).
// Then min(2*count+8, 4000), *(8-difficulty)/8 human, *2/3 England.
function immigrationCount() {
  let n = G.colonies.reduce((s, c) => s + c.colonists.length, 0)
        + G.units.length + G.europe.length + G.dockUnits.length;
  for (const u of G.units) if (u.ship && u.cargo) n += u.cargo.length;
  for (const e of G.europe) n += (e.passengers || []).length;
  return n;
}
function immigrationThreshold() {
  let accum = immigrationCount();
  if (accum < 4000) accum *= 2;
  accum += 8;
  accum = Math.min(4000, accum);
  accum = Math.floor(accum * (8 - G.difficulty) / 8);
  if (G.nation === 0) accum = Math.floor(accum * 2 / 3);      // England
  return accum;
}
// Crosses come from the production pass -- a Preacher in a Church makes them
// like any other indoor job, and the flat one-per-colony (GAME_MANUAL.md
// 1534) is seeded INTO the tally by colonyProduce, so the plaza strip's cross
// run and this immigration sum read the same number ([0x8DEA]=1 on the
// churchless census3 frame).
function crossesPerTurn() {
  return G.colonies.reduce(
    (n, c) => n + (c.crossesTurn === undefined ? 1 : c.crossesTurn), 0);
}
function checkImmigration() {
  G.crosses += crossesPerTurn();
  G.crossThreshold = immigrationThreshold();   // mirror of PowerRecord +0x30
  const thr = immigrationThreshold();
  if (G.crosses < thr) return;
  G.crosses -= thr;
  // The arrival takes one of the three dock slots at random and that slot
  // refills from the generator.
  if (G.fathersOwned.includes('William Brewster')) {
    // @RECRUITCHOOSE -- Brewster's documented function: "Whom shall we
    // recruit?" over the three dock candidates.
    const pool = G.dock.map(d => d.name);
    askEvent('RECRUITCHOOSE', { STRING0: DATA.nations[G.nation].homeport },
             (k) => {
      const slot2 = (k >= 0 && k < 3) ? k : 0;
      G.dockUnits.push(G.dock[slot2].name);
      tutOnce(5, { STRING0: DATA.nations[G.nation].homeport,
                   STRING1: G.dockUnits[G.dockUnits.length - 1] });
      G.dock[slot2] = rollImmigrant();
    }, pool);
    return;
  }
  const slot = Math.floor(Math.random() * 3);
  G.dockUnits.push(G.dock[slot].name);
  // TUTORIAL5 (func_033F6A @0x3651F): recruits are waiting on the docks.
  tutOnce(5, { STRING0: DATA.nations[G.nation].homeport,
               STRING1: G.dockUnits[G.dockUnits.length - 1] });
  G.dock[slot] = rollImmigrant();
  showEvent('UNREST', { STRING0: DATA.nations[G.nation].homeport,
                        STRING1: G.dock[0] && (G.dock[0].name || G.dock[0]) || 'Colonists' });
}

// ------------------------------------------------------------ save / load
// The whole of G is the save: it holds the map view, the units, the colonies,
// the market and the Europe state, and nothing is derived from anything outside
// it except the immutable DATA tables.
const SAVE_KEY = 'colonization.save';

// ------------------------------------------------ the COLONY##.SAV importer
// The shipped save format is BYTE-VERIFIED end to end (spec/systems/save.md):
// "COLONIZE"+0x1A, a version word, map w/h, then 43 raw DGROUP blocks written
// by func_0734F8 -- game globals 0x5380, 4x AIPersonality, the four record
// tables (ColonyRecord 0xCA / UnitRecord 0x1C / PowerRecord 0x13C /
// NativeSettlement 0x12), TribeData, and a tail of AI arrays -- followed by
// the FOUR MAP PLANES the spec's block table stopped short of (the writer's
// tail @0x73938-0x739BC: terrain [0x15C], improvements [0x160], resources
// [0x164], per-power fog [0x168], each w*h bytes). Offsets used here are the
// runtime record layouts of spec/systems/unit.md and docs/DATA_MODEL.md, all
// re-validated against the ten shipped COLONY0#.SAV files before this was
// written. Two labels were CORRECTED by that validation: PowerRecord +0x4C is
// the CURRENT PRICE array (the js-dos "market_sensitivity" gloss does not fit
// the values -- they are the live bid prices), and ColonyRecord +0x20 is the
// per-colonist CURRENT-JOB array (@JOB row), parallel to the +0x40 specialty
// array. What the importer cannot see it does not invent: europe crossings,
// trade routes, and the diplomacy matrices load empty/at peace, flagged.
const SAV_PROFESSION = (v) =>
  (v >= 1 && v < (DATA.jobexpert || []).length) ? DATA.jobexpert[v] : null;
// ...and the same byte, read for a EUROPE MANIFEST entry, where row 0 counts.
//
// Profession 0 IS a profession -- Expert Farmers, @JOBEXPERT row 0 -- and the
// census frame proves it: the Galleon's three riders are records 85/86/87 with
// bytes 15/9/0, and the 2026-08-07 capture analysis matched their figures 1.0
// as Expert Farmer / Master Distiller / Master Gunsmith, which only works if 0
// is the farmer. The no-specialty value is 28, the row count
// (spec/systems/save.md, ColonyRecord +0x20: "28 = no specialty"), and the
// fixture agrees: byte 28 appears 47 times on braves, artillery and plain
// colonists, byte 0 appears 22 times and on only TWO colonist records in the
// whole save.
//
// SCOPED to the manifest ON PURPOSE. The same reading almost certainly applies
// to isExpert, scoutLevel and the ColonyRecord specialty array, all of which
// carry the same `>= 1` guard -- but relaxing it there changes production and
// combat numbers, and nothing available tests those against the original. A
// colony-screen census entry would. Tracked as C4.26.
const SAV_PROFESSION0 = (v) =>
  (v >= 0 && v < (DATA.jobexpert || []).length) ? DATA.jobexpert[v] : null;
// The off-map sentinel is not ONE state -- it is five.
//
// A UnitRecord parked off the map stores x == y == BASE + power, and the BASE
// says where in the Atlantic the unit is:
//
//   0xEC + power  IN EUROPE (harbour + dock). BYTE-VERIFIED at three
//                 independent sites, all testing `unit.x - power == 0xEC`:
//                 @0x0421EF (func_042138's per-power recount), @0x035E01 (the
//                 immigration accumulator) and @0x058B8F (the REF/war sweep).
//   0xF0 + power  BOUND FOR EUROPE ("Expected Soon"). BYTE-VERIFIED:
//   0xF4 + power  func_042138 recounts BOTH bases into the same per-power
//                 counter [power-0x6BAA] (@0x042455 / @0x04243F), the counter
//                 the sail-for-Europe path increments @0x041B2F before
//                 stamping UnitRecord+0x07 = 0x45 @0x041B6D -- and the
//                 fixture's only 0xF4-class record (#31) carries exactly that
//                 0x45. 0xEC feeds the OTHER counter, [power-0x6BA6]
//                 (@0x0421F6).
//   0xE4 + power  BOUND FOR THE NEW WORLD ("Bound For <region>").
//   0xE8 + power  CAPTURE-VERIFIED for 0xE4: sav1653's Dutch Galleon (record
//                 #56, x == y == 0xE7 == 0xE4 + 3) is drawn by the ORIGINAL
//                 under "Bound For New Netherlands" with its three passengers
//                 aboard, while the same screen reads "No Ships In Port"
//                 (docs/screens/census/baseline/census_EUROPE.png). 0xE8 is
//                 the remaining slot; its direction follows from the pairing
//                 and has NO site of its own. FLAGGED.
//
// NOT decoded: the progress ORDER inside each pair (0xE4 vs 0xE8, 0xF0 vs
// 0xF4). A restored crossing gets a full SAIL_TURNS timer rather than a
// guessed remainder -- a flagged approximation, not a reading of the byte.
function euroSentinel(x, power) {
  const base = x - power;
  if (base === 0xF0 || base === 0xF4) return 'toEurope';
  if (base === 0xE4 || base === 0xE8) return 'toNewWorld';
  return 'port';                 // 0xEC, and any base not in the table
}

function importSav(bytes) {
  const d = bytes instanceof Uint8Array ? bytes : new Uint8Array(bytes);
  const u16 = (o) => d[o] | (d[o + 1] << 8);
  const i32 = (o) => (d[o] | (d[o + 1] << 8) | (d[o + 2] << 16) | (d[o + 3] << 24)) | 0;
  const str = (o, n) => {
    let s = '';
    for (let i = 0; i < n && d[o + i]; i++) s += String.fromCharCode(d[o + i]);
    return s;
  };
  if (str(0, 8) !== 'COLONIZE' || d[9] !== 0x1A) { notice('Not a COLONIZE save.'); return false; }
  let o = 10 + 2;
  const w = u16(o), h = u16(o + 2); o += 4;
  if (w !== MAP.w || h !== MAP.h) { notice(`Unsupported map size ${w}x${h}.`); return false; }
  const g = o; o += 0x8E;
  const year = u16(g + 0x0A), season = u16(g + 0x0C), turn = u16(g + 0x0E);
  const nation = u16(g + 0x14) & 3, diff = d[g + 0x26];
  const nvill = u16(g + 0x1A), nunit = u16(g + 0x1C), ncol = u16(g + 0x1E);
  o += 0xD0 + 0x18;
  const colBase = o; o += ncol * 0xCA;
  const unitBase = o; o += nunit * 0x1C;
  const powBase = o; o += 0x4F0;
  const villBase = o; o += nvill * 0x12;
  const tribeBase = o; o += 0x270;
  o += 727;                                   // blocks 11-43, all fixed sizes
  const planeBase = o, plane = w * h;
  if (planeBase + 4 * plane > d.length) { notice('Save file truncated.'); return false; }

  // Fresh state in the save's shoes, then overwrite what the file carries.
  G.nation = nation;
  beginGame();
  G.year = year; G.season = season; G.turn = turn; G.difficulty = diff;
  G.landHo = true; G.builtColony = true; G.metAnyone = true;
  // The [0x190] map-detail salt is not among the save's 43 serialized
  // blocks; the load pins it like the C's cr_reset_from_load does. The LOW
  // NIBBLE places the fish/detail sprites and is MEASURED against the MAP
  // census baseline (nibble 9 = the unique sweep minimum); the full value
  // stays unknowable from one frame.
  G.mapSeed = 1657;
  // [0x8D80] (the plot/skill seed base) is the BIOS launch tick, per-SESSION
  // -- also not in the save. Loads pin it to the census session's measured
  // clock (1410965; & 0x7FFF = 0x795) exactly as the C's cr_reset_from_load
  // does, so the seeded picks (colony layouts, village teach skills) agree
  // across both engines and with the census baselines.
  G.plotSeedBase = 1410965;
  // The globals block (0x5380, 0x8E bytes -- the serializer's block 3,
  // func_0734F8 @0x073562, full 43-block order read 2026-08-07) carries the
  // engine's own once-flags at fixed offsets; restore them verbatim:
  //   g+0x06 = [0x5386] the shared flags word -- upper bits are the tutorial
  //            step-shown guards (the low three are the sound switches, which
  //            the port ignores; the two readings of 0x5386 coexist).
  //   g+0x8A = [0x540A] the woodcut shown-bitmask, same 1<<plate convention.
  G.tutMask = u16(g + 0x06);
  // The other two once-flag homes (func_020F50/020EE0 read): g+0 = [0x5380]
  // (steps 13/14/15/19 + other once-flags), g+2 = [0x5382] (step 2 at 0x80).
  G.onceFlags = d[g];
  G.phaseFlags = u16(g + 0x02);
  // Only 16/17/18 remain side-set (no emitter in the EXE); keep them marked
  // shown on import so none re-fire mid-game.
  G.tutSide = Object.fromEntries(Array.from({ length: 19 }, (_, i) => [i + 1, true]));
  G.wcSeen = u16(g + 0x8A);
  // Block 34 = the single byte [0x336], the colony-strip NUMBERS toggle
  // (the badge gate, see drawCountRow): it sits 564 bytes past the tribe
  // table (blocks 11-33). The 1653 save carries 1, the census3 save 0 --
  // exactly the badge difference between their two live colony frames.
  G.colonyNumbers = !!d[tribeBase + 0x270 + 564];
  // CONTACT comes from the record, not from a blanket true.
  //
  // This used to read `G.tribes.forEach(t => { t.met = true; })`. The original
  // does not work that way: TribeRecord + 0x3A + power is the per-(tribe,
  // power) RELATION byte, and 0 means never contacted. Byte-verified by the
  // shared accessor func_007F34 @0x007F46 -- for a native party (a >= 4) it
  // reads `[b + a*0x4E + 0x59D8]`, and the tribe array base is 0x5AD6
  // (func_0081E6 @0x0081EA `add ax, 0x5ad6`, corroborated by func_00822A
  // @0x008232 reading the tech level at +0x5AD8 = record+2), so the field
  // resolves to record + 0x3A + b. func_007F62 @0x007F76 is the setter. For a
  // European party the same accessor reads the PowerRecord war matrix.
  //
  // The F9 row loop tests it directly (@0x03784C get_relation(tribe+4, power),
  // @0x037854 test al, 0x20), and on the census fixture that predicts the
  // original's list exactly: seven tribes drawn, the Iroquois skipped despite
  // owning ELEVEN villages, because their relation byte is 0.
  //
  // Only bit 0x20 is decoded. The rest of the 0x60/0x62/0x64/0x66 values the
  // fixture carries are NOT -- FLAGGED, not guessed.
  G.tribes.forEach((t, i) => {
    const tb = tribeBase + i * 0x4E;
    t.relation = d[tb + 0x3A + nation];
    t.recFlags = d[tb + 3];
    // (+0x07/+0x08 feed both the F9 census row -- x50 muskets, herds
    // verbatim (@0x03766D/@0x0377D6) -- and the haggle counters above;
    // one pair of fields serves both.)
    t.met = !!(t.relation & 0x20);
  });
  // PowerRecord +0x2E is the CROSSES ACCUMULATOR -- byte-verified at the F2
  // gauge caller func_037958, which reads +0x2E/+0x30 off [0x84fc]
  // (@0x0379AB/@0x0379AE) and hands them to the icon-strip gauge 0x181F:0x236.
  // +0x30 is the stored immigration threshold; the byte-cited formula in
  // immigrationThreshold() computes exactly the stored 284 on this fixture, so
  // only the accumulator needs seeding. Without it F2's gauge drew nothing on
  // a loaded game (census C4.23).
  G.crosses = u16(powBase + nation * 0x13C + 0x2E);
  G.crossThreshold = u16(powBase + nation * 0x13C + 0x30);
  // REF strength: [0x53DA/DC/DE/E0] = Regulars / Cavalry / Man-O-War /
  // Artillery (COLONIZATION_TECHNICAL_REFERENCE.md 1117) = g+0x5A..0x60.
  G.ref = { Regulars: u16(g + 0x5A), Cavalry: u16(g + 0x5C),
            'Man-O-War': u16(g + 0x5E), Artillery: u16(g + 0x60) };

  // Map planes: terrain verbatim; improvements masked to the road/plow bits
  // the port models; fog verbatim -- SEEN already uses the engine's own
  // 1<<(power+4) bit convention, so the plane drops straight in.
  const terr = d.subarray(planeBase, planeBase + plane);
  MAP.tiles.set ? MAP.tiles.set(terr) : MAP.tiles.splice(0, MAP.tiles.length, ...terr);
  // Bits 2 and 4 now carried too: bit 2 marks a PRIME-RESOURCE tile
  // (func_005F82 pairs it with the resource nibble), bit 4 suppresses the
  // detail band (tile_terrain_variant_hash @0x00616A).
  for (let i = 0; i < plane; i++) IMPROVE[i] = d[planeBase + plane + i] & 0x4E;
  // Plane 3's LOW NIBBLE is the region id (func_005D9C reads [0x164]) --
  // carried verbatim, replacing the flood-fill approximation.
  for (let i = 0; i < plane; i++) {
    REGION[i] = d[planeBase + 2 * plane + i] & 0x0F;
    RESOURCE[i] = d[planeBase + 2 * plane + i] >> 4;
  }
  SEEN.set(d.subarray(planeBase + 3 * plane, planeBase + 4 * plane));

  // The player's PowerRecord.
  const pb = powBase + nation * 0x13C;
  G.tax = d[pb + 1];
  G.gold = i32(pb + 0x2A);
  G.kingsFund = i32(pb + 0x22);
  G.bells = u16(pb + 0x0C);
  G.artilleryBought = u16(pb + 0x1E);
  const boy = u16(pb + 0x20);
  G.boycotts = [];
  for (let i = 0; i < 16; i++) if (boy & (1 << i)) G.boycotts.push(i);
  const ffbits = i32(pb + 0x07) >>> 0;
  G.fathersOwned = (DATA.fathers || [])
    .filter((f, i) => ffbits & (1 << i)).map(f => f.name);
  G.market = [];
  // The record byte is the PRICE LEVEL, taken verbatim. The old
  // Math.max(1, ...) clamped the LEVEL; the original clamps the RESULT
  // instead (func_030590/func_030566 both `jns` after the arithmetic),
  // so a level of 0 or 1 is legal and quotes a bid of 0.
  for (let i = 0; i < 16; i++) G.market.push(d[pb + 0x4C + i]);
  // The whole-game net-trade counters the F5 report reads: +0xBC units,
  // +0x7C value (s32[16] each).
  G.tradeTons = []; G.tradeGold = [];
  for (let i = 0; i < 16; i++) {
    G.tradeTons.push(i32(pb + 0xBC + i * 4));
    G.tradeGold.push(i32(pb + 0x7C + i * 4));
  }
  // The traffic ACCUMULATOR is the record's own +0x5C word array (s16[16])
  // -- RESOLVED 2026-08-29 by the byte read of the sale bookkeeping
  // func_03234A: the per-power pool it moves at DGROUP
  // [-0x779C + p*0x13C + g*2] is exactly PowerRecord+0x5C (power-0 base
  // -0x77F8), so the accumulator is SAV-persistent and EVERY power carries
  // one (a sell adds pressure to all four, the Dutch x2/3). The player's
  // pool IS G.accum; G.rivalAccum[p] aliases it at p = nation.
  G.rivalAccum = [];
  for (let p = 0; p < 4; p++) {
    const rb = powBase + p * 0x13C;
    const arr = [];
    for (let i = 0; i < 16; i++) arr.push((u16(rb + 0x5C + i * 2) << 16) >> 16);
    G.rivalAccum.push(arr);
  }
  G.accum = G.rivalAccum[nation];

  // Tribes: level from the record's +0x02 byte ([0x5AD8], stride 0x4E) and
  // tension toward the player from the +0x46 per-power word (the 0x5B1C
  // table, RULINGS 2026-08-01).
  G.tribes.forEach((t, i) => {
    const tb = tribeBase + i * 0x4E;
    t.level = d[tb + 2];
    t.tension = Math.max(0, Math.min(100, u16(tb + 0x46 + nation * 2)));
    // The trade state the haggle reads (func_049600, read 2026-08-29):
    // +0x07/+0x08 muskets/horses-bought counters, +0x0A the horse herd
    // word, +0x0E..+0x2D the tribe's sixteen goods-stock words (a sale
    // adds there @0x49BAC, a purchase draws there @0x4A20A).
    t.musketsKnown = d[tb + 7];
    t.horsesKnown = d[tb + 8];
    t.herd = u16(tb + 0x0A);
    // +0x0C: the word the teach-weight builder divides by the tribe's
    // settlement count for the Silver Miner weight (@0x492B8). Its writer
    // is unread -- imported verbatim, FLAGGED as "hoard".
    t.hoard = u16(tb + 0x0C);
    t.stock = [];
    for (let g = 0; g < 16; g++) t.stock.push(u16(tb + 0x0E + g * 2));
  });

  // Villages.
  G.villages = []; G.natives = [];
  for (let i = 0; i < nvill; i++) {
    const b = villBase + i * 0x12;
    const tribe = Math.max(0, d[b + 2] - 4);
    const m = d[b + 5];
    G.villages.push({
      x: d[b], y: d[b + 1], tribe, name: (G.tribes[tribe] || {}).name,
      level: (G.tribes[tribe] || {}).level || 0,
      capital: !!(d[b + 3] & 0x04), chiefSeen: !!(d[b + 3] & 0x08),
      pop: d[b + 4], growth: d[b + 6],
      // settlement +0x07/+0x08/+0x09 -- the haggle memories (func_049600):
      // walked-away good (0xFE = the buy-insult latch, 0xFF = none), last
      // good bought, last good sold. Out-of-range bytes read as none.
      walkedGood: d[b + 7] === 0xFE ? 'insult'
                : d[b + 7] <= 15 ? d[b + 7] : undefined,
      lastBought: d[b + 8] <= 15 ? d[b + 8] : undefined,
      lastSold: d[b + 9] <= 15 ? d[b + 9] : undefined,
      mission: m === 0xFF ? null : { power: m & 0x0F, expert: !!(m & 0x10) },
      alarm: d[b + 0x0A + nation * 2],
      // +0x03 bit 1 is the taught latch (`or [bx+3],2` @0x4A78A).
      tributePaid: false, taught: !!(d[b + 3] & 0x02), braveOwed: false,
    });
  }

  // Colonies -- ours in full, everyone else's as rival colonies.
  G.colonies = [];
  G.rivals = [];
  for (let n = 0; n < 4; n++) {
    if (n === nation) continue;
    G.rivals.push({ nation: n, met: true, attitude: 8,
                    gold: i32(powBase + n * 0x13C + 0x2A),
                    // the rival's own Congress (+0x07 bitmask) and tax
                    // byte (+0x01) -- the per-power colony pass consults
                    // both (B3.6)
                    fathers: i32(powBase + n * 0x13C + 0x07) >>> 0,
                    tax: d[powBase + n * 0x13C + 0x01],
                    // the rival's royal fund (+0x22), its free musket
                    // lots (+0x49) and horse pool (+0x4A) -- the AI
                    // overflow sale writes the last two (@0x2E73B /
                    // @0x2E75C); the lots are spent by that power's
                    // Europe musket buy (@0x52658), unported
                    kingsFund: i32(powBase + n * 0x13C + 0x22),
                    musketLots: d[powBase + n * 0x13C + 0x49],
                    horsePool: u16(powBase + n * 0x13C + 0x4A),
                    colonies: [], nextColony: 0, units: [] });
  }
  const rivalOf = (n) => G.rivals.find(r => r.nation === n);
  // Every power's PRICE-LEVEL row (+0x4C, 16 bytes): the rivals' own
  // markets. The player's row is G.market (read above), aliased in.
  G.rivalMarket = [];
  for (let p = 0; p < 4; p++) {
    const rb = powBase + p * 0x13C;
    if (p === nation) { G.rivalMarket.push(G.market); continue; }
    const row = [];
    for (let i = 0; i < 16; i++) row.push(d[rb + 0x4C + i]);
    G.rivalMarket.push(row);
  }
  // The WAR MATRIX (B4.6): PowerRecord[a] + 0x34 + b, one byte per pair
  // (@0x58A72; bits 0x01 resolved @0x5318F, 0x02 war @0x58A7B, 0x08
  // grievance @0x3F0D7, 0x20 peace-pending @0x57DF0, 0x40 TREATY -- set
  // by SIGNTREATY @0x57E91, cleared by CANCELTREATY/DECLAREWAR @0x57F3C
  // and by the @TRADEATWAR gate's "no contact" reading @0x5A450 -- and
  // 0x80 privateer @0x3F0A1), loaded verbatim so a save's wars are live
  // from turn one. The +0x40 row is the per-pair TIMER the grievance
  // cycle decrements (@0x531A3; 1 at signing @0x57EC5), kept for the
  // unported cycle. The rows are 12 wide (the newgame zero loop @0x7583A
  // runs to 0xC: 4 powers + 8 tribes); only the European 4x4 is a
  // relation the port models.
  G.warMatrix = {}; G.treatyMatrix = {}; G.relTimer = {};
  for (let a = 0; a < 4; a++) {
    for (let b = 0; b < 4; b++) {
      const w = d[powBase + a * 0x13C + 0x34 + b];
      G.warMatrix[relKey(a, b)] = w;
      G.treatyMatrix[relKey(a, b)] = (w & 0x40) ? REL.TREATY : 0;
      G.relTimer[relKey(a, b)] = d[powBase + a * 0x13C + 0x40 + b];
    }
  }
  // Worker-slot order is N,E,S,W,NW,NE,SE,SW (smcol tile_N..tile_SW; the
  // prior row-major guess put every worker on the wrong cell -- census3:
  // Jamestown's slots 4/6/7 are NW/SE/SW, and only with this order does the
  // colony's food come out at the engine's 9 = centre + two worked farms).
  const CELL_OF_WORKER = [[0, -1], [1, 0], [0, 1], [-1, 0], [-1, -1], [1, -1], [1, 1], [-1, 1]];
  for (let i = 0; i < ncol; i++) {
    const b = colBase + i * 0xCA;
    const owner = d[b + 0x1A] & 3, pop = d[b + 0x1F];
    const name = str(b + 2, 24);
    // Buildings are the 48-bit TIER-PACKED field at +0x84 -- NOT a flat
    // per-index bitmask, and NOT at +0x60 (that is the colonists' job-duration
    // nibble array). Bit groups LSB-first per chain, and each group's low bit
    // NUMBER equals its chain's first @BUILDING index, so the table below is
    // [base/bit, width, chain length]:
    //   fortification(3@0) armory(3@3) docks(3@6) townhall(3@9) school(3@12)
    //   warehouse(1@15) unused(1@16) stables(1@17) customhouse(1@18)
    //   printing(2@19) weaver(3@21) tobacco(3@24) rum(3@27) capitol(2@30)
    //   fur(3@32) carpenter(2@35) church(2@37) blacksmith(3@39).
    // Layout = smcol_sav_struct.json (SAVE_FORMAT_CROSSREF); pinned
    // EMPIRICALLY by census3_build_picker: the engine's own Jamestown build
    // list decodes bit-exactly from these bytes (RULINGS 2026-08-08h). A
    // tier t marks the chain's first t entries built.
    const bAt = (i) => (d[b + 0x84 + (i >> 3)] >> (i & 7)) & 1;
    // PREFIX COUNT, not binary value: the field is a unary mask, one bit per
    // built tier. Proven by San Salvador's fortification bits 1,1,0 -- the
    // binary read said 3 (Fortress) while the colony's own map frame byte
    // (+0xBE, read by func_004314 @0x004385) says 2 (Fort). The readings
    // only differ at two-of-three bits set, which the Jamestown pin never hit.
    const tier = (lo, w) => { let t = 0; while (t < w && bAt(lo + t)) t++; return t; };
    const FAMS = [[0, 3, 3], [3, 3, 3], [6, 3, 3], [9, 3, 3], [12, 3, 3],
                  [15, 1, 1], [17, 1, 1], [18, 1, 1], [19, 2, 2], [21, 3, 3],
                  [24, 3, 3], [27, 3, 3], [30, 2, 2], [32, 3, 3], [35, 2, 2],
                  [37, 2, 2], [39, 3, 3]];
    const buildings = [];
    for (const [lo, wdt, len] of FAMS) {
      const t = Math.min(tier(lo, wdt), len);
      for (let j = 0; j < t; j++) buildings.push(DATA.buildings[lo + j].name);
    }
    // warehouse_level (+0x95): 2 = the Expansion standing on the Warehouse.
    if (d[b + 0x95] >= 2 && !buildings.includes('Warehouse Expansion'))
      buildings.push('Warehouse Expansion');
    // B3.6 slice B: rival-owned records now get the SAME full parse as the
    // player's (colonists, cells, buildings, stock, construction) -- the
    // engine runs one colony pass per power over identical records
    // (func_02F052, owner match @0x2F256), so the reference model must hold
    // identical data. The stub fields (pop/grow/level/sol) ride on top for
    // the existing consumers.
    const depletionCounter = d[b + 0x97];   // +0x97, the mine-wear counter
    const colonists = [];
    for (let k = 0; k < pop; k++) {
      const occ = d[b + 0x20 + k];
      colonists.push({ type: 'Colonists',
                       // +0x60 job-duration nibble (the teaching counter)
                       work: (d[b + 0x60 + (k >> 1)] >> ((k & 1) ? 4 : 0)) & 0xF,
                       // profession byte 0 = Expert Farmers here too: the
                       // DOS field-yield expert test is plain byte equality
                       // (@0x9CDC) and the Vlissingen scene badges 6/5 only
                       // fit with prof-0 farmers as experts (C4.26 resolved
                       // 2026-08-28).
                       profession: SAV_PROFESSION0(d[b + 0x40 + k]),
                       job: occ < (DATA.jobs || []).length ? DATA.jobs[occ] : null,
                       cell: null });
    }
    for (let k = 0; k < 8; k++) {
      const wkr = d[b + 0x70 + k];
      if (wkr !== 0xFF && colonists[wkr]) colonists[wkr].cell = CELL_OF_WORKER[k];
    }
    // A field job needs a field: a cell-less colonist whose job is an outdoor
    // column rests in the plaza instead of producing from nowhere.
    for (const p of colonists)
      if (!p.cell && p.job && FIELD_JOB_NAMES.includes(p.job)) p.job = null;
    const dividend = i32(b + 0xC2), divisor = i32(b + 0xC6);
    // Construction state: banked hammers u16 @+0x92, the target's @BUILDING
    // index @+0x94 (0xFF = none; Jamestown's 0x06 = Docks matches the
    // census3 picker's highlighted row). An index past the 42 buildings
    // would be a colony-built unit target -- unobserved, left null.
    const bip = d[b + 0x94];
    const c = { name, x: d[b], y: d[b + 1], nation: owner, colonists,
                stock: [], buildings, hammers: u16(b + 0x92),
                // +0x1C flags byte, kept verbatim: the map's population-number
                // ink reads bits 4/2 (func_004314 @0x00448B-@0x0044A4).
                recFlags1c: d[b + 0x1C],
                depletionCounter,
                building: (DATA.buildings[bip] || {}).name || null,
                // FLOOR, not round: the DOS colony screen prints 36% for
                // Isabella (107/292 = 36.64) and 5% for Vlissingen
                // (64/1082 = 5.92) -- the engine's integer division
                // truncates. Round read both one high.
                sol: divisor > 0 ? Math.max(0, Math.min(100,
                     Math.floor(100 * dividend / divisor))) : 0 };
    // custom_house_flags @+0x8A: bit i = good i EXPORTED (smcol hint; the
    // port stores the inverse "off" map). Dormant until a Custom House stands.
    const chf = u16(b + 0x8A);
    c.customOff = {};
    for (let k = 0; k < 16; k++) if (!(chf & (1 << k))) c.customOff[k] = true;
    for (let k = 0; k < 16; k++) c.stock.push(u16(b + 0x9A + k * 2));
    if (owner !== nation) {
      const r = rivalOf(owner);
      if (r) {
        // The stub fields the existing consumers read (pop/grow/level and
        // the +0x19 sentiment feed) sit on the full object.
        c.pop = pop; c.grow = 0;
        c.level = ['Fortress', 'Fort', 'Stockade'].findIndex(f => buildings.includes(f)) >= 0
          ? 3 - ['Fortress', 'Fort', 'Stockade'].findIndex(f => buildings.includes(f)) : 0;
        r.colonies.push(c);
      }
      continue;
    }
    G.colonies.push(c);
  }

  // Units: ours to G.units (a land unit standing on water is cargo aboard the
  // ship there), rival powers' to their lists, natives to the brave list.
  G.units = [];
  for (let pass = 0; pass < 2; pass++) {
    for (let i = 0; i < nunit; i++) {
      const b = unitBase + i * 0x1C;
      const type = DATA.units[d[b + 2]];
      if (!type) continue;
      const own = d[b + 3] & 0x0F;
      const x = d[b], y = d[b + 1];
      const isShip = Number(type.hull) > 0;
      if (pass === 0 !== isShip) continue;          // ships first, riders second
      if (own >= 4) {
        if (pass === 1) {
          const home = G.villages.filter(v => v.tribe === own - 4)
            .sort((a, q) => (Math.abs(a.x - x) + Math.abs(a.y - y)) -
                            (Math.abs(q.x - x) + Math.abs(q.y - y)))[0];
          G.natives.push({ type: type.name, icon: unit(type.name).icon, x, y,
                          tribe: own - 4, orders: 0, nation: -1, home });
        }
        continue;
      }
      if (own !== nation) {
        const r = rivalOf(own);
        if (r) r.units.push({ type: type.name, icon: unit(type.name).icon, x, y,
                              nation: own, orders: 0, ship: isShip });
        continue;
      }
      // Coordinates off the map are the engine's "in Europe / on the high
      // seas" sentinel: those ships dock in the harbour, their riders stay
      // aboard as passengers, and a landless walker waits on the dock.
      const offMap = x >= MAP.w || y >= MAP.h;
      if (!isShip && (offMap || tileWater(at(x, y)))) {
        const prof = SAV_PROFESSION0(d[b + 0x17]);
        const entry = prof ? { name: prof, type: type.name } : type.name;
        const ship = G.units.find(s => s.ship && s.x === x && s.y === y);
        // The record index rides along so the manifest can be put in CHAIN
        // order below; it is deleted once that is done.
        if (ship) { ship.cargo.push(entry); (ship.__ridx || (ship.__ridx = [])).push(i); }
        else if (offMap) G.dockUnits.push(entry);
        continue;
      }
      const u = mkUnit(type.name, x, y);
      u.__rec = i;                       // for the chain-order pass below
      // ORDERS (C1.18, 2026-08-28): record byte +0x08 indexes the same
      // @ORDERS table as the status letter (1 Sentry / 5 Fortify /
      // 6 Fortified) -- those stable states are RESTORED, so a fortified
      // defender keeps its combat standing across a load. 8 (Clear/Plow)
      // and 9 (Build Road) restore as of 2026-08-29: their only companion
      // state is the +0x16 work counter imported below, and the work
      // processors are byte-modeled -- a pioneer resumes mid-job. Values
      // with unread companion state (trade route, goto, live-in-village,
      // 7, the 11/12 internals) still reset to 0, FLAGGED.
      const ro = d[b + 0x08];
      if (ro === 1 || ro === 5 || ro === 6 || ro === 8 || ro === 9) u.orders = ro;
      // Go To (orders 3): the goal rides in +0x09/+0x0A -- the setter
      // @0x41B62/@0x41B69 writes them with orders 3 for the human
      // (@0x41B4B). Restored when the goal is on the map; a garbage goal
      // leaves the order reset (the guard is the port's own, FLAGGED).
      if (ro === 3) {
        const gx = d[b + 0x09], gy = d[b + 0x0A];
        if (gx >= 1 && gx < MAP.w - 1 && gy >= 1 && gy < MAP.h - 1) {
          u.orders = 3;
          u.goal = [gx, gy];
        }
      }
      // Per-unit SAV state (read 2026-08-29): the damaged flag is +0x04
      // bit 0x80 (tested @0x2F084 -- the repair pass runs it on ships;
      // artillery carries its demotion in the same bit); +0x16
      // turns_worked is the shared pioneer/convert/repair counter
      // (@0x4071D/@0x2EFD6/@0x2F0E0). Both import only where a consumer
      // is LIVE -- a stale counter on an idle colonist is inert in the
      // engine too, and this model loses it through the ship-rider
      // round-trip, so importing it everywhere desyncs the two engines.
      if ((d[b + 0x04] & 0x80) && (isShip || type.name === 'Artillery'))
        u.damaged = true;
      if (u.orders === 8 || u.orders === 9 || u.damaged ||
          d[b + 0x17] === 27)
        u.work = d[b + 0x16];
      // Row 0 counts here too (C4.26 unit side, resolved 2026-08-30): the
      // icon resolver func_003710 applies its `prof + 0x52` arithmetic to
      // byte 0 unconditionally and maps the 0x1C sentinel to the plain
      // colonist -- the same semantics the manifest capture proved. The
      // combat consumers (scoutLevel/profIs) test rows >= 20 by name and
      // are untouched by an Expert Farmers profession.
      const prof = SAV_PROFESSION0(d[b + 0x17]);
      if (prof) u.profession = prof;
      if (d[b + 0x15]) u.tools = d[b + 0x15];
      if (isShip) {
        u.hold = [];
        const n = Math.min(6, d[b + 0x0C]);
        for (let k = 0; k < n; k++) {
          const good = (d[b + 0x0D + (k >> 1)] >> ((k & 1) ? 4 : 0)) & 0x0F;
          // Only the first two quantity bytes are mapped; further slots load
          // as full holds. Flagged.
          const qty = k < 2 ? d[b + 0x10 + k] : 100;
          if (qty) holdAdd(u, good, qty);
        }
      }
      G.units.push(u);
    }
  }
  // A ship's MANIFEST is in CHAIN order, not record order.
  //
  // UnitRecord +0x18/+0x1A are the alias-confirmed chain links, and a ship is
  // the HEAD of its own manifest: on the census fixture the Dutch Galleon (#56)
  // has chain_prev = 0xFFFF and chain_next = 87, #87 links on to 86 and 86 to
  // 85 -- the reverse of the order those three records appear in the file.
  // Corroborated on two other ships in the same save (#28's only rider #52
  // carries chain_prev = 28; nation 1's #49 heads #40).
  //
  // It matters because the manifest is drawn left to right. The 2026-08-07
  // capture analysis identified the Galleon's three passengers as Expert Farmer
  // / Master Distiller / Master Gunsmith in that order, matched 1.0 -- which is
  // professions 0, 9, 15, i.e. records 87, 86, 85. The port collected them 85,
  // 86, 87 and drew the manifest backwards.
  //
  // Riders not on the chain keep their relative order behind the ones that are,
  // rather than being dropped.
  for (const sh of G.units) {
    if (!sh.__ridx || sh.__rec === undefined) { delete sh.__rec; continue; }
    const rank = sh.__ridx.map((_, k) => 1000 + k);
    let r = 0, cur = u16(unitBase + sh.__rec * 0x1C + 0x1A), guard = 0;
    while (cur !== 0xFFFF && cur < nunit && guard++ < nunit) {
      const k = sh.__ridx.indexOf(cur);
      if (k >= 0) rank[k] = r++;
      cur = u16(unitBase + cur * 0x1C + 0x1A);
    }
    const order = sh.__ridx.map((_, k) => k).sort((p, q) => rank[p] - rank[q]);
    sh.cargo = order.map(k => sh.cargo[k]);
    delete sh.__ridx; delete sh.__rec;
  }

  // Ships parked off the map. The sentinel coordinate is not ONE state --
  // it is five, and which one decides whether the ship is in the harbour or
  // still at sea. See euroSentinel() above for the byte citations; the short
  // version is 0xEC+power = in Europe, 0xF0/0xF4+power = bound for Europe,
  // 0xE4/0xE8+power = bound for the New World. A ship in Europe unloads its
  // riders onto the dock; a ship at sea keeps them aboard.
  for (let i = G.units.length - 1; i >= 0; i--) {
    const u = G.units[i];
    if (u.x < MAP.w && u.y < MAP.h) continue;
    G.units.splice(i, 1);
    if (u.ship) {
      const state = euroSentinel(u.x, nation);
      const e = { type: u.type, icon: u.icon, hold: u.hold || [],
                  passengers: [], state };
      if (state === 'port') for (const p of (u.cargo || [])) G.dockUnits.push(p);
      else { e.passengers = u.cargo || []; e.turns = SAIL_TURNS; }
      G.europe.push(e);
    }
  }
  G.euroShip = 0;
  G.sel = Math.max(0, G.units.findIndex(u => !u.ship));
  if (G.units[G.sel]) centerOn(G.units[G.sel].x, G.units[G.sel].y);
  else if (G.colonies[0]) centerOn(G.colonies[0].x, G.colonies[0].y);
  G.screen = 'map';
  notice(`${DATA.seasons[G.season]} ${G.year} — the ${DATA.nations[nation].adjective} game restored.`);
  return true;
}
const b64bytes = (s) => Uint8Array.from(atob(s), c => c.charCodeAt(0));

// The main-menu LOAD GAME flow: the browser save, the shipped 1653 save
// bundled with the port, or any COLONY##.SAV picked off disk.
function openLoadMenu() {
  const rows = ['Saved game (browser)',
                'Autumn 1653 - the shipped Dutch game (COLONY00.SAV)',
                'Import a COLONY##.SAV file...',
                'Cancel'];
  G.dialog = {
    body: ['Load which game?'], tail: rows, opts: rows, width: 0x50, sel: 0,
    onDone: (i) => {
      if (i === 0) {
        if (loadGame()) G.screen = 'map';
      } else if (i === 1) {
        if (DATA.sav1653) importSav(b64bytes(DATA.sav1653));
      } else if (i === 2) {
        const inp = document.createElement('input');
        inp.type = 'file';
        inp.accept = '.SAV,.sav';
        inp.onchange = () => {
          const f = inp.files && inp.files[0];
          if (!f) return;
          f.arrayBuffer().then(buf => importSav(new Uint8Array(buf)));
        };
        inp.click();
      }
    },
  };
}
// The browser save now carries the three MAP PLANES and the rumour set --
// the old one serialized G alone, so a load came back with a fresh map, no
// fog history, and a broken (JSON-emptied) rumoursDone Set.
function saveGame() {
  try {
    localStorage.setItem(SAVE_KEY, JSON.stringify({
      v: 2, G, tiles: Array.from(MAP.tiles), improve: Array.from(IMPROVE),
      seen: Array.from(SEEN), region: Array.from(REGION),
      rumours: Array.from(G.rumoursDone || []),
    }));
    notice('Game saved.');
  } catch (e) { notice('Could not save.'); }
}
function loadGame() {
  try {
    const raw = localStorage.getItem(SAVE_KEY);
    if (!raw) { notice('No saved game.'); return false; }
    const s = JSON.parse(raw);
    if (s.v !== 2) { notice('Old save format - not loadable.'); return false; }
    Object.assign(G, s.G);
    MAP.tiles.set ? MAP.tiles.set(s.tiles) : MAP.tiles.splice(0, MAP.tiles.length, ...s.tiles);
    IMPROVE.set(s.improve);
    SEEN.set(s.seen);
    if (s.region) REGION.set(s.region); else buildRegions();
    G.rumoursDone = new Set(s.rumours || []);
    if (!G.tradeTons) { G.tradeTons = DATA.cargo.map(() => 0); G.tradeGold = DATA.cargo.map(() => 0); }
    // The per-power market rows: JSON breaks the G.market alias, so
    // re-point it; an older save has no rows at all.
    if (!G.rivalMarket) G.rivalMarket = [0, 1, 2, 3].map(p => (p === G.nation ? G.market : G.market.slice()));
    else G.market = G.rivalMarket[G.nation];
    if (!G.relTimer) G.relTimer = {};
    G.openMenu = -1; G.dialog = null; G.colonyPopup = null; G.euroMenu = null;
    // Saves are version-2 across MANY builds, so a stale one may predate
    // fields the live code relies on. Re-establish the invariants instead of
    // letting the first draw/interaction throw on them.
    G.drag = null; G.dragArm = null; G.goTo = null; G.combat = null;
    for (const k of ['units', 'colonies', 'europe', 'dockUnits', 'natives',
                     'villages', 'tribes', 'rivals', 'refUnits', 'routes',
                     'boycotts', 'eventQueue', 'fathersOwned'])
      if (!Array.isArray(G[k])) G[k] = [];
    for (const c of G.colonies) {
      if (!Array.isArray(c.stock)) c.stock = DATA.cargo.map(() => 0);
      while (c.stock.length < DATA.cargo.length) c.stock.push(0);
      if (!Array.isArray(c.buildings)) c.buildings = [];
      if (!Array.isArray(c.colonists)) c.colonists = [];
      // Saves from before the stand-down rule hold colonists still wearing
      // their outfits: shed the gear into the stores and keep the man.
      c.colonists.forEach((p, i) => {
        if (!['Pioneers', 'Soldiers', 'Dragoons', 'Scouts', 'Missionaries'].includes(p.type)) return;
        const conv = unitToColonist(
          { type: p.type, profession: p.profession,
            tools: p.type === 'Pioneers' ? EQUIP_TOOLS : 0 }, c);
        c.colonists[i] = { ...conv, job: p.job || null, cell: p.cell || null };
      });
    }
    for (const u of [...G.units, ...G.europe])
      if (u && u.hold && !Array.isArray(u.hold)) u.hold = [];
    if (!G.ref || typeof G.ref !== 'object') G.ref = {};
    if (!(G.rumoursDone instanceof Set)) G.rumoursDone = new Set();
    notice('Game loaded.');
    return true;
  } catch (e) { notice('Could not load.'); return false; }
}

// ------------------------------------------------------- Colonizopedia
// spec/ui/colonizopedia.md. WOODPANL background; screen title
// "ENCYCLOPEDIA OF COLONIZATION" centred at y=5; entry header
// "<name>  <category>" centred at y = font_h + 7; body seeded at
// header_y + font_h + 0xE with x = 10. Seven categories from MENU.TXT @PEDIA
// plus "Complete", which merges them all into one alphabetised index.
const PEDIA_KEYS = ['CARGO', 'UNIT', 'TERRAIN', 'JOB', 'BUILDING', 'FATHER', null];
// The pedia's terrain rows, alphabetised, each keeping the ENGINE terrain id
// its PEDIA.TXT article is keyed by. Those ids are NOT contiguous: @UNFORESTED
// is 0..7, @FORESTED 8..15 and @OTHER 24..28. Ids 16..23 are the auto-forest
// variants (CLAUDE.md hard rule 3) -- they have articles but no index row,
// which is exactly why PEDIA.TXT ships 29 TERRAIN articles behind a 21-row
// index. 21 = 8 + 8 + 5, confirmed against the live capture.
let _terrainPedia = null;
Object.defineProperty(globalThis, 'TERRAIN_PEDIA', { get() {
  if (_terrainPedia) return _terrainPedia;
  const t = DATA.terrain, suffix = t.othernames[0];
  const rows = t.unforested.map((n, i) => ({ name: n, id: i }))
    .concat(t.forested.map((n, i) => ({ name: `${n} ${suffix}`, id: 8 + i })),
            t.other.map((n, i) => ({ name: n, id: 24 + i })));
  rows.sort((a, b) => a.name.localeCompare(b.name));
  _terrainPedia = rows;
  return rows;
} });

function pediaNames(cat) {
  switch (cat) {
    case 0: return DATA.cargo.map(c => c.name);
    case 1: return DATA.units.map(u => u.name);
    // Terrain: @UNFORESTED(8) + @FORESTED(8) each suffixed with @OTHER_NAMES[0]
    // -- the literal string "Forest", which is what that entry is for -- plus
    // @OTHER(5) = 21 names, which the index then sorts alphabetically. Verified
    // name-for-name against the live index
    // (docs/screens/live_2026-08-05/40_pedia_terrain_index.png).
    //
    // The earlier reading treated @OTHER_NAMES as five more terrain entries and
    // padded to 29 with invented "Terrain 26..28" rows. It is a suffix/label
    // table: Forest, River, Major River, Minor River, Unexplored.
    case 2: return TERRAIN_PEDIA.map(t => t.name);
    case 3: return DATA.jobs;
    case 4: return DATA.buildings.map(b => b.name);
    case 5: return DATA.fathers.map(f => f.name);
    // @MISCELLANEOUS opens with a COUNT, then that many concept names; the
    // rest of the section is comment lines belonging to later sections.
    case 6: {
      const lines = DATA.pedia.entries.MISCELLANEOUS.split('\n');
      const n = parseInt(lines[0], 10) || 0;
      return lines.slice(1, 1 + n).map(l => l.trim());
    }
    default: return [];
  }
}
// "Complete" (category 7) is every entry, alphabetised, each remembering the
// category and index it came from.
// Terrain rows carry the engine id their article is keyed by; every other
// category keys its article by row position.
const pediaArticleId = (cat, row) => (cat === 2 ? TERRAIN_PEDIA[row].id : row);
function pediaComplete() {
  const all = [];
  for (let c = 0; c < 7; c++)
    pediaNames(c).forEach((n, i) => all.push({ name: n, cat: c, idx: pediaArticleId(c, i) }));
  return all.sort((a, b) => a.name.localeCompare(b.name));
}
function pediaList() {
  if (G.pediaCat === 7) return pediaComplete();
  return pediaNames(G.pediaCat)
    .map((n, i) => ({ name: n, cat: G.pediaCat, idx: pediaArticleId(G.pediaCat, i) }));
}
function pediaBody(cat, idx) {
  const key = PEDIA_KEYS[cat];
  if (!key) return null;                      // Game Concept: no article shipped
  return DATA.pedia.entries[key + idx] || null;
}
// The stat block each page adds under its article, from the NAMES tables.
function pediaStats(cat, idx) {
  if (cat === 0) { const c = DATA.cargo[idx];
    return [`Price ${c.start1}-${c.start2} gold`, `Spread ${c.burden + 1}`]; }
  if (cat === 1) { const u = DATA.units[idx]; if (!u) return [];
    return [`Moves ${u.movement}   Attack ${u.attack}   Defend ${u.combat}`,
            u.cargo ? `Cargo ${u.cargo}` : '', u.hull ? `Hull ${u.hull}` : ''].filter(Boolean); }
  if (cat === 4) { const b = DATA.buildings[idx]; if (!b) return [];
    return [`${b.cost} hammers` + (b.tools_x10 ? `, ${b.tools_x10 * 10} tools` : ''),
            `Needs ${b.min_colony} colonists`, b.upkeep ? `Upkeep ${b.upkeep}` : 'No upkeep']; }
  return [];
}
function drawPedia(ctx) {
  usePalette('WOODPANL');
  ctx.drawImage(IMG.WOODPANL, 0, 0);
  const fh = FONT.tiny.height;
  // The masthead is WHITE (255,255,255) in the live frame, not the HUD green
  // the rest of the browser uses -- WOODPANL index 15.
  FONT.tiny.center(ctx, DATA.text.misc[108] || 'ENCYCLOPEDIA OF COLONIZATION',
                   160, 5, lut(15));
  const list = pediaList();
  if (G.pediaMode === 'index') {
    // Index: column-major, 22 rows per column, up to three columns, pitch 7,
    // first row at y=26 and left column at x=7. Measured off the live index
    // (docs/screens/live_2026-08-05/40_pedia_terrain_index.png): rows run
    // 26,33,40,…,166 for the 21 terrain entries, which is why a short category
    // renders as ONE column -- the fill only spills right when it overflows.
    //
    // The live screen carries no category sub-heading and no keyboard hint; the
    // only chrome is "(Exit)" at the top right (and "(More)" when the list
    // pages), both @MISC strings. Both of the removed lines were the port's own.
    const perCol = 22, cols = 3;
    const page = Math.floor(G.pediaSel / (perCol * cols)) * (perCol * cols);
    for (let k = 0; k < perCol * cols && page + k < list.length; k++) {
      const x = 7 + (k / perCol | 0) * 104, y = 26 + (k % perCol) * 7;
      const sel = page + k === G.pediaSel;
      if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(x - 2, y - 1, 102, 7); }
      FONT.tiny.draw(ctx, list[page + k].name, x, y, lut(sel ? 0xFC : 0xFE));
    }
    if (page + perCol * cols < list.length)
      FONT.tiny.draw(ctx, DATA.text.misc[109], 246, 5, lut(HUD_INK));
    FONT.tiny.draw(ctx, DATA.text.misc[110], 295, 5, lut(HUD_INK));
    return;
  }
  // Entry page.
  const e = list[G.pediaSel];
  if (!e) { G.pediaMode = 'index'; return; }
  FONT.tiny.center(ctx, `${e.name}   ${DATA.pedia.categories[e.cat]}`,
                   160, fh + 7, lut(0xFC));
  let y = fh + 7 + fh + 0xE;
  const body = pediaBody(e.cat, e.idx);
  if (body) {
    for (const para of body.split('\n')) {
      if (!para.trim()) { y += 4; continue; }
      for (const line of wrapText(FONT.tiny, para.trim(), 300)) {
        spanText(ctx, line, 10, y, 0xFE, 0xFC);
        y += fh + 1;
      }
    }
  } else {
    FONT.tiny.draw(ctx, '(no article in PEDIA.TXT for this entry)', 10, y, lut(0x5D));
    y += fh + 4;
  }
  y += 4;
  for (const l of pediaStats(e.cat, e.idx)) { FONT.tiny.draw(ctx, l, 10, y, lut(0x0E)); y += fh + 1; }
  FONT.tiny.center(ctx, '(Esc back)', 160, 190, lut(0x5D));
}

// ---------------------------------------------------------------- turn
function endTurn() {
  G.turn += 1;
  // Year cadence (§20.1): 1 turn = 1 year before 1600; from 1600 seasons toggle
  // and the year steps every second turn.
  if (G.year < 1600) G.year += 1;
  else {
    // @TIMECHANGE, the one-shot help card at the 1600 time-scale change
    // ("from one turn per year to two turns per year").
    if (!G.timeChanged) { G.timeChanged = true; showEvent('TIMECHANGE'); }
    G.season = (G.season + 1) % 2;
    if (G.season === 0) G.year += 1;
  }
  for (const u of G.units) { u.movesLeft = u.moves; u.slipChecked = false; }
  revealAll();
  blockadeCensus();
  for (const c of G.colonies) colonyTurn(c);
  // @VANISH removals, deferred out of the loop above.
  if (G.colonies.some(c => c.vanished)) {
    G.colonies = G.colonies.filter(c => !c.vanished);
    G.colony = Math.max(0, Math.min(G.colony, G.colonies.length - 1));
  }
  // Damaged-ship repair, map half -- BYTE_VERIFIED func_02F052
  // @0x2F084..@0x2F1E2 (read 2026-08-29), replacing the Drydock/Shipyard
  // one-turn stand-in: every damaged ship of the power (Artillery keeps
  // its demotion, @0x2F08F) ticks its +0x16 counter +1 a turn (@0x2F0E0)
  // and +1 MORE when its coordinates pass the map-bounds test
  // (is_xy_in_map_bounds via 0x181F:0x302 @0x2F0FE) -- so ships anywhere
  // ON the map, port or open sea, mend at 2 a turn, no building needed.
  // Complete at the @UNIT defense column (+0x5235 = unit.combat,
  // @0x2F126): the flag clears (@0x2F135) and @REFIT names the colony
  // under the ship (@0x2F1A4); at sea the engine's location slot is
  // stale -- the port passes the empty string. The counter reset is the
  // port's own hygiene (the engine leaves +0x16 as-is), flagged.
  for (const u of G.units) {
    if (!u.ship || !u.damaged) continue;
    u.work = (u.work || 0) + 2;
    if (u.work < (unit(u.type) || {}).combat) continue;
    u.damaged = false;
    u.work = 0;
    const home = colonyAt(u.x, u.y);
    showEvent('REFIT', { STRING0: u.type, STRING1: home ? home.name : '' });
  }
  advanceImprovements();
  checkImmigration();
  updateCongress();
  checkTreasure();
  // §19.11: the native pass runs BEFORE the European powers move
  // (func_04891A -> func_0485F6 -> func_04830E).
  nativeTick();
  nativeDemands();
  attemptConversions();
  ageConverts();
  // Raids now arrive on foot: nativeMoveAI marches each war-footing brave at
  // his target and fires nativeRaid when he gets there, so a raid takes as
  // many turns to come as the ground takes to cross -- the old
  // every-village-every-turn raid loop is gone with its RAID_GATE_K stub.
  nativeMoveAI();
  // Raid-razed colonies (@INDIANBURNCOLONY) leave here, like the starved.
  if (G.colonies.some(c => c.vanished)) {
    G.colonies = G.colonies.filter(c => !c.vanished);
    G.colony = Math.max(0, Math.min(G.colony, G.colonies.length - 1));
  }
  rivalTurn();
  newsTick();
  kingWarCycle();
  kingTaxDemand();
  advanceTradeRoutes();
  advanceGoTo();
  runWar();
  toryUprising();
  shoreBombardment();
  spanishSuccession();
  aiDiplomacyTick();
  offerMercenaries();
  checkIntervention();
  driftMarket();
  advanceCrossings();
  // The retirement clock (the manual's 1800/1850 endgame dates): 1800
  // auto-retirement unless a War of Independence is on, 1850 war-weary
  // surrender unless it is WON. The 1790/1840 warning lead times are the
  // port's flagged reading -- the engine's lead is unread.
  if (!G.retired) {
    const S = { STRING0: DATA.difficulty[G.difficulty],
                STRING1: G.leader || DATA.nations[G.nation].leader,
                STRING2: DATA.nations[G.nation].homeport };
    if (!(G.flags & WOI_DECLARED)) {
      // @LOSENOCOLONIES: "our efforts have proven fruitless" -- the King
      // revokes the charter when no colonies stand after 1600 (@ABANDON2's
      // own warning names the rule).
      if (G.year >= 1600 && !G.colonies.length && G.turn > 30) {
        showEvent('LOSENOCOLONIES', S);
        endGameSequence();
        return;
      }
      if (G.year >= 1790 && !G.soonWarned) { G.soonWarned = true; showEvent('SOONRETIRING0', S); }
      if (G.year >= 1800) { showEvent('RETIRING', S); endGameSequence(); }
    } else if (!(G.flags & WOI_WON)) {
      if (G.year >= 1840 && !G.soonWarned2) { G.soonWarned2 = true; showEvent('SOONRETIRING1', S); }
      if (G.year >= 1850) { showEvent('RETIRING2', S); endGameSequence(); }
    }
  }
  G.msg = '';
  if (G.units[G.sel]) centerOn(G.units[G.sel].x, G.units[G.sel].y);
}

// What one step costs, in thirds. The terrain table's `movement` column is the
// cost in whole moves; a road at BOTH ends, or a cardinal step along a river
// that runs through both tiles, costs a single third.
function moveCost(u, fx, fy, tx, ty) {
  if (u.ship) return MOVE_UNIT;
  if (hasRoad(fx, fy) && hasRoad(tx, ty)) return 1;
  if (tileRiver(at(fx, fy)) && tileRiver(at(tx, ty)) && (fx === tx || fy === ty)) return 1;
  return MOVE_UNIT * terrainMove(at(tx, ty));
}
function step(u, nx, ny) {
  // A unit that has not moved yet may always take one step, however dear the
  // ground -- otherwise a one-move unit could never enter a mountain.
  const cost = moveCost(u, u.x, u.y, nx, ny);
  u.movesLeft = (cost > u.movesLeft) ? 0 : u.movesLeft - cost;
  u.x = nx; u.y = ny;
  reveal(nx, ny, sightRadius(u));
  // DISCOVERY ON FIRST SIGHTING: the woodcut + @LANDHO fire the moment
  // land first enters a player ship's view (running-game observation,
  // 2026-08-30 -- the top trust tier; the handler is func_020EFE, called
  // from the ship-move chain func_03FDDE, its exact sighting predicate
  // unread -- the any-land-within-sight scan here is FLAGGED). The old
  // landfall-time trigger fired a whole voyage later.
  if (!G.landHo && u.ship && u.nation === G.nation) {
    const r = sightRadius(u);
    let land = false;
    for (let dy = -r; dy <= r && !land; dy++)
      for (let dx = -r; dx <= r && !land; dx++)
        if (!tileWater(at(nx + dx, ny + dy))) land = true;
    if (land) { G.landHo = true; woodcutOnce(1); }
  }
  // Tutorial bindings (flagged; the byte sites are the dispatcher
  // func_020F50 / func_02C5D4): a ship docking at a colony teaches loading
  // (12) -- or colonist delivery (15) when it carries passengers; a pioneer
  // on workable ground teaches plow/clear (10) or roads (9); soldiers
  // teach defence (14).
  const tc = colonyAt(nx, ny);
  if (u.ship && tc) {
    if ((u.cargo || []).length) tutOnce(15, { STRING0: tc.name });
    else tutOnce(12, { STRING0: tc.name });
  }
  if (!u.ship && canImprove(u)) {
    if (isForested(tileTerrain(at(nx, ny))) || !hasPlow(nx, ny)) tutOnce(10);
    else if (!hasRoad(nx, ny)) tutOnce(9);
  }
  if (u.type === 'Soldiers') tutOnce(14);
  if (!u.ship && !NOT_COLONISTS.includes(u.type) && !tileWater(at(nx, ny)))
    tutOnce(3, { STRING0: terrainName(at(nx, ny)) });
  G.msg = '';
  if (nx - G.view.x < 3 || nx - G.view.x > VIEW_COLS() - 4 ||
      ny - G.view.y < 3 || ny - G.view.y > VIEW_ROWS() - 4) centerOn(nx, ny);
  if (u.movesLeft <= 0) advance();
}

// Once a unit has spent its moves the turn passes to the next one that still
// has some; when none do, the turn is over and the new one starts on the first
// unit again.
function advance() {
  if (!nextUnit()) { endTurn(); nextUnit(); }
}

// Space passes on the active unit: it keeps its position, gives up the rest of
// its moves for this turn, and play moves on.
function skipUnit() {
  const u = G.units[G.sel];
  if (!u) return;
  u.movesLeft = 0;
  G.msg = '';
  advance();
}

// "Land Ho! What shall we call this new land, Your Excellency?" -- the naming
// prompt that follows the discovery woodcut (GAME.TXT @LANDHO, @default=America).
function askLandName() {
  // TUTORIAL2: uncharted land found -- make landfall (binding flagged).
  tutOnce(2);
  openDialog('LANDHO', (name) => {
    G.newLand = (name || '').trim() || DATA.dialogs.LANDHO.default;
    G.msg = `${G.newLand}!`;
  });
}

// A ship carrying land units that is ordered onto a land tile gets @LANDFALL:
// "Shall we make landfall, Your Excellency, and leave the ships behind?"
// Row 1 (Make Landfall, the @default) puts the cargo ashore on that tile and
// leaves the ship where it is; row 0 cancels the move.
function landfall(ship, nx, ny) {
  // @LANDFALL2 is the river-mouth variant ("Our ships cannot navigate up
  // this river") -- same two rows, row 1 makes landfall. Picked when the
  // landing tile carries a river; the engine's own key selector is unread.
  openDialog(tileRiver(at(nx, ny)) ? 'LANDFALL2' : 'LANDFALL', (choice) => {
    if (choice !== 1) return;
    const first = G.units.length;
    for (const name of ship.cargo) G.units.push(mkUnit(name, nx, ny));
    ship.cargo = [];
    ship.movesLeft = 0;
    G.sel = first;   // the party ashore takes over from the ship
    // First landfall fires woodcut 1, DISCOVERY OF THE NEW WORLD
    // (spec/ui/woodcuts_and_intro.md trigger table, func_020EFE @0x020F00),
    // and it is shown once per game.
    if (!G.landHo) {
      G.landHo = true;
      woodcutOnce(1);
    }
    // TUTORIAL13: the pioneers have stepped ashore (binding flagged --
    // exact func_020F50 site pending the Phase 4 disasm).
    tutOnce(13);
  });
}

function moveSel(dx, dy) {
  const u = G.units[G.sel];
  if (!u) return;
  if (u.movesLeft <= 0) { G.msg = 'No moves left.'; return; }
  const nx = u.x + dx, ny = u.y + dy;
  if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) return;
  const water = tileWater(at(nx, ny));
  if (u.ship && !water) {
    // Ships never enter a land square. With land units aboard the attempt is
    // the landfall offer; empty, the order is simply illegal (the engine has no
    // message for it).
    if (u.cargo.length) {
      // @LANDFIRST: "Land units cannot enter an enemy occupied square from on
      // board a ship." -- the landing square must be empty or friendly.
      const hostile =
        G.natives.some(n => n.x === nx && n.y === ny) ||
        G.refUnits.some(n => n.x === nx && n.y === ny) ||
        G.rivals.some(r => r.met && atWar(G.nation, r.nation) &&
          (r.units.some(ru => ru.x === nx && ru.y === ny) ||
           r.colonies.some(rc => rc.x === nx && rc.y === ny)));
      if (hostile) { showEvent('LANDFIRST'); return; }
      landfall(u, nx, ny);
    }
    return;
  }
  if (!u.ship && water) return;   // land units cannot walk onto water
  if (u.ship && water) {
    // @SHIPLAKE (func_03FDDE @0x3FF2A): ships cannot enter inland LAKE
    // squares -- water disconnected from the ocean. The engine's test is
    // region-based; the port compares the destination's region id against
    // the sea lane's (the right-edge column is always ocean-connected).
    const seaRegion = REGION[(ny) * MAP.w + (MAP.w - 1)];
    const dstRegion = REGION[ny * MAP.w + nx];
    if (dstRegion !== seaRegion &&
        REGION[u.y * MAP.w + u.x] === seaRegion) {
      showEvent('SHIPLAKE');
      return;
    }
    // The interception zone (func_059B90): sailing beside a HOSTILE warship
    // either slips past (@SHIPRUN) or is slowed (@SHIPSLOW -- the byte-read
    // effect is a movement-counter penalty, add [unit+0x3149] @0x59DD7).
    // The engine's odds are upstream of the emits, unread -- 50/50 flagged.
    const menace = G.rivals.flatMap(r =>
      (r.met && atWar(G.nation, r.nation)) ? r.units : [])
      .find(ru => ru.ship && Math.abs(ru.x - nx) <= 1 && Math.abs(ru.y - ny) <= 1 &&
                  Number((unit(ru.type) || {}).attack) > 0);
    if (menace && !u.slipChecked) {
      u.slipChecked = true;   // once per move order, not per step
      const owner = G.rivals.find(r => r.units.includes(menace));
      if (Math.random() < 0.5) {
        showEvent('SHIPRUN', { STRING0: u.type,
                               STRING1: DATA.nations[owner.nation].adjective,
                               STRING2: DATA.nations[G.nation].adjective,
                               STRING3: menace.type });
      } else {
        u.movesLeft = Math.max(0, u.movesLeft - MOVE_UNIT);
        showEvent('SHIPSLOW', { STRING0: u.type,
                                STRING1: DATA.nations[owner.nation].adjective,
                                STRING2: menace.type });
      }
    }
  }
  // Moving onto a tile held by a native, a rival or the King's expeditionary
  // force is an attack (§14).
  const foe = G.natives.find(n => n.x === nx && n.y === ny) ||
              G.refUnits.find(n => n.x === nx && n.y === ny);
  if (foe) {
    // @CANNOTATTACK: a unit whose @UNIT attack rating is 0 cannot attack --
    // data-driven from the same column combat reads.
    if (!u.ship && !(Number((unit(u.type) || {}).attack) > 0)) {
      showEvent('CANNOTATTACK');
      return;
    }
    // §14.3: tired troops are offered the choice BEFORE the roll -- charge at
    // reduced strength, or rest. A unit that has already spent its budget this
    // turn is the tired case.
    const tired = u.movesLeft < u.moves;
    const strike = () => {
      resolveAttack(u, foe);
      if (foe.tribe !== undefined) adjustTension(foe.tribe, 100, 4);   // an act of war (@PISS4)
      u.fatigue = 0;
      advance();
    };
    if (tired && !u.ship) {
      // -33% or -66%: the engine has two fatigue flags (F&0x100 and S&8) but
      // not, in the evidence read, the rule that picks between them. The port
      // uses "less than a third of the budget left" for the heavier penalty
      // and flags the threshold as its own.
      u.fatigue = u.movesLeft * 3 <= u.moves ? 2 : 1;
      askEvent('HALF', { NUMBER0: u.fatigue === 2 ? 1 : 2 }, (choice) => {
        // Row 0 "Charge!", row 1 "Then let them rest."
        if (choice !== 0) { u.fatigue = 0; u.movesLeft = 0; advance(); return; }
        strike();
      });
      return;
    }
    u.fatigue = 0;
    strike();
    return;
  }
  // Moving onto a rival power's unit or colony. At peace that opens the parley;
  // at war it is an attack. During the War of Independence foreign colonies
  // cannot be attacked at all (@NOWARSDURINGREV, enforcement byte-verified at
  // func_05A862 @0x5A912).
  const rival = G.rivals.find(r => r.met &&
    (r.units.some(ru => ru.x === nx && ru.y === ny) ||
     r.colonies.some(rc => rc.x === nx && rc.y === ny)));
  if (rival) {
    const isColony = rival.colonies.some(rc => rc.x === nx && rc.y === ny);
    // The Privateer's HIDDEN attribution (byte-verified: the war-declaration
    // resolver checks unit type 0x10 @0x3F092 and sets war_matrix 0x80
    // @0x3F0A1 INSTEAD of the war bit): a Privateer may strike rival
    // shipping at peace without an open declaration.
    const ruP = rival.units.find(x => x.x === nx && x.y === ny);
    if (!atWar(G.nation, rival.nation) && u.ship && u.type === 'Privateer' &&
        ruP && ruP.ship) {
      setWar(G.nation, rival.nation, REL.PRIVATEER, true);
      if (navalAttack(u, ruP)) advance();
      return;
    }
    // @HAVETREATY: attacking a treaty partner asks first ("Cancel Action."
    // / "Break Treaty."); breaking announces @CANCELPEACE and opens the war.
    if (!atWar(G.nation, rival.nation) && haveTreaty(G.nation, rival.nation) &&
        ruP && !(u.ship !== !!ruP.ship)) {
      askEvent('HAVETREATY', { STRING0: DATA.nations[rival.nation].adjective },
               (choice) => {
        if (choice !== 1) return;
        showEvent('CANCELPEACE', { STRING0: DATA.nations[G.nation].adjective,
                                   STRING1: DATA.nations[rival.nation].adjective });
        declareWarOn(G.nation, rival.nation);
      });
      return;
    }
    if (atWar(G.nation, rival.nation)) {
      if (isColony && (G.flags & WOI_DECLARED)) { showEvent('NOWARSDURINGREV', {}); return; }
      // @CANNOTATTACK, same data-driven rating gate as the native branch.
      if (!u.ship && !(Number((unit(u.type) || {}).attack) > 0)) {
        showEvent('CANNOTATTACK');
        return;
      }
      const ru = rival.units.find(x => x.x === nx && x.y === ny);
      // Ship against ship runs the raw guns/hull roll, not the modifier chain.
      if (ru && u.ship && ru.ship) { if (navalAttack(u, ru)) advance(); return; }
      if (ru) { resolveAttack(u, ru); advance(); return; }
      if (isColony && !u.ship) {
        // An undefended foreign colony FALLS: @CAPTURED, with a plunder of its
        // treasury share. The engine transfers the whole ColonyRecord; the
        // port re-founds it as ours at the same site with its people as plain
        // colonists -- the interior (buildings/stock) is not visible to us
        // pre-capture and is not invented. Flagged.
        const rc = rival.colonies.find(x => x.x === nx && x.y === ny);
        rival.colonies.splice(rival.colonies.indexOf(rc), 1);
        // The plunder AMOUNT formula is unread -- this roll is the port's
        // own placeholder, flagged (the raze formula in §19 is the native
        // villages', not this one).
        const loot = 10 * (1 + Math.floor(Math.random() * 10)) * (1 + (rc.pop || 1));
        G.gold += loot;
        const c = { name: rc.name, x: nx, y: ny, nation: G.nation,
                    colonists: Array.from({ length: Math.max(1, Math.min(3, rc.pop || 1)) },
                      () => ({ type: 'Colonists', profession: null, job: null, cell: null })),
                    stock: DATA.cargo.map(() => 0),
                    buildings: STARTING_BUILDINGS.slice(),
                    hammers: 0, building: null, sol: 0 };
        G.colonies.push(c);
        // Byte-read split (func_05CA7E @0x5DED1): a human-involved capture
        // announces @CAPTURED before the declaration and @CAPTURED3 (no
        // plunder line) once [0x5382]&1 -- the declared flag -- is set.
        showEvent(G.declared ? 'CAPTURED3' : 'CAPTURED',
                  { STRING0: DATA.nations[G.nation].adjective,
                    STRING2: rc.name, NUMBER0: loot });
        u.movesLeft = 0; advance(); return;
      }
      if (isColony && u.ship) {
        // @TRADEATWAR (byte-cited @0x05A458): ships cannot enter the
        // colonies of powers at war.
        showEvent('TRADEATWAR');
        return;
      }
      G.msg = `The ${DATA.nations[rival.nation].adjective} colony holds.`;
      u.movesLeft = 0; advance(); return;
    }
    // Foreign-colony TRADE (func_05A40E): a cargo carrier at a rival colony
    // at peace. Requires Jan de Witt (the byte-cited mercantilism gate
    // @0x05A469); no cargo aboard is the @DEFICIT refusal; the @TRADEWITH
    // barter offers goods or gold for the first hold slot (both offers the
    // port's flagged pricing: goods 2:1 by value, gold = market +25%).
    if (isColony && (u.ship || u.type === 'Wagon Train')) {
      const hold = (u.hold || []).filter(h => h.qty > 0);
      if (!G.fathersOwned.includes('Jan de Witt')) {
        showEvent('TRADEMERCANTILISM',
                  { STRING0: DATA.diplotext.GREATKINGS[rival.nation] });
        return;
      }
      if (!hold.length) { showEvent('DEFICIT'); return; }
      const h = hold[0];
      const myVal = bidPrice(h.good) * h.qty;
      const offerGold = Math.floor(myVal * 5 / 4);
      let og = (h.good + 1) % 16;
      while (og === h.good || askPrice(og) <= 0) og = (og + 1) % 16;
      const offerQty = Math.max(1, Math.floor(myVal * 2 / askPrice(og)));
      askEvent('TRADEWITH', { NUMBER0: offerQty, STRING0: DATA.cargo[og].name,
                              NUMBER1: h.qty, STRING1: DATA.cargo[h.good].name,
                              NUMBER2: offerGold }, (k) => {
        if (k === 0) { holdAdd(u, h.good, -h.qty); holdAdd(u, og, offerQty); }
        else if (k === 1) { holdAdd(u, h.good, -h.qty); G.gold += offerGold; }
      });
      u.movesLeft = 0;
      return;
    }
    // A SCOUT at a foreign colony gets its own four-option dialog instead of
    // the parley (func_05A20E).
    if (isColony && u.type === 'Scouts') {
      const rc = rival.colonies.find(x => x.x === nx && x.y === ny);
      u.movesLeft = 0;
      scoutColony(u, rc, rc.name || DATA.nations[rival.nation].adjective);
      advance();
      return;
    }
    if (!parleyEligible(rival)) {
      G.msg = `The ${DATA.nations[rival.nation].adjective} will not receive us yet.`;
      return;
    }
    u.movesLeft = 0;
    runMeeting(rival, u);
    return;
  }
  const vil = G.villages.find(v => v.x === nx && v.y === ny);
  if (vil) { u.movesLeft = 0; enterVillage(vil, u); return; }
  // The right-edge sea-lane column is the route home. Entering it asks
  // @SAILHOME -- "We have reached the high seas ... Shall we sail for Europe?"
  // (@default=1 highlights "Yes, steady as she goes."); declining leaves the
  // ship in these waters. The tile itself is hard rule 2 (terrain 26); the
  // ask-on-entry binding is the manual's description of the high seas, the
  // engine's own trigger site being unread.
  if (u.ship && tileTerrain(at(nx, ny)) === TERR.SEALANE) {
    // During the War of Independence the crossing is closed
    // (@EUROPENOTLEAVE); otherwise the @SAILHOME ask.
    if (woiLocked()) { showEvent('EUROPENOTLEAVE'); return; }
    openDialog('SAILHOME', (choice) => { if (choice === 0) sailForEurope(u); });
    return;
  }
  // A land unit entering a rumour square triggers the exploration event, and
  // one outcome destroys the unit before it ever arrives.
  if (!u.ship && rumourAt(nx, ny)) { if (!enterRumour(u, nx, ny)) { advance(); return; } }
  step(u, nx, ny);
}

// Cycle to the next unit that still has moves -- the engine's Tab/next-unit.
// Returns false when every unit is spent.
function nextUnit() {
  // A unit under a STANDING ORDER is NOT offered.  @ORDERS (NAMES.TXT,
  // BYTE_VERIFIED, spec/systems/unit.md) is 0=No Orders, 1=Sentry,
  // 2=Trade Route, 3=Go To, 4=Live In Village, 5=Fortify, 6=Fortified,
  // 7=Build Colony, 8=Clear/Plow, 9=Build Road -- anything non-zero is busy.
  // Without the `!u.orders` test a pioneer given Clear/Plow or Build Road came
  // back as the active unit every single turn once its moves refreshed, and
  // moving it silently threw the part-done work away (user report 2026-08-17).
  // setOrder() zeroes movesLeft, which only covers the turn the order is given.
  //
  // Adding it changed WHICH unit is active, and that flushed out three latent
  // JS/C divergences the fixed oracle scripts had never reached (all fixed
  // 2026-08-17): the C's end_turn was missing this endTurn's own recentre
  // tail, the C's unloadCargo was missing the @WAREHOUSEFULL gate, and the
  // input oracle projected the dialog SHAPE on the JS side against the dialog
  // KIND on the C side.
  for (let i = 1; i <= G.units.length; i++) {
    const k = (G.sel + i) % G.units.length;
    const u = G.units[k];
    if (u.movesLeft > 0 && !u.orders) { G.sel = k; centerOn(u.x, u.y); return true; }
  }
  return false;
}

// ------------------------------------------------------------ commands
// One entry per MENU.TXT row label. Rows with no entry render greyed and report
// themselves as absent rather than silently doing nothing -- the menu tree is
// the shipped one, so every row the real game has is visible here whether or
// not this build implements it.
function setOrder(n) {
  const u = G.units[G.sel];
  if (!u) return;
  u.orders = n;
  u.movesLeft = 0;
  advance();
}
// Clear/Plow and Build Road are only open to a unit carrying tools, and the
// tile has to be worth the work: no road where one already runs, no plow on a
// tile already plowed or still forested (that is a clear), no work at sea.
function improveOrder(n) {
  const u = G.units[G.sel];
  if (!u) return;
  // @ONLYPIO (@width=120): improvement orders need a pioneer (a unit carrying
  // tools). The engine's predicate site is unread; refusing every non-pioneer,
  // ships included, is the port's reading, flagged.
  if (!canImprove(u)) { showEvent('ONLYPIO'); return; }
  if (tileWater(at(u.x, u.y))) { showEvent('ONLYPIO'); return; }
  // @NOROAD / @NOPLOW: the already-improved refusals, keyed.
  if (n === ORDER_ROAD && hasRoad(u.x, u.y)) { showEvent('NOROAD'); return; }
  if (n === ORDER_CLEAR && !isForested(tileTerrain(at(u.x, u.y))) && hasPlow(u.x, u.y)) {
    showEvent('NOPLOW'); return;
  }
  u.orders = n;
  u.work = 0;
  u.movesLeft = 0;
  G.msg = `${DATA.orders[n].name}: ${workThreshold(u, n === ORDER_ROAD)} turns.`;
  // A road cut near a settlement draws the tribe's objection, with its
  // buy-off -- and clearing their forest draws @INDIANFOREST the same way.
  if (n === ORDER_ROAD) roadObjection(u);
  if (n === ORDER_CLEAR && isForested(tileTerrain(at(u.x, u.y)))) clearObjection(u);
  advance();
}
// ORDERS "Return to Europe" (E) sends the selected ship home; VIEW "European
// Status" (also E, one level down) opens the harbour. E does both here: the
// ship is ordered home AND the harbour comes up, so the crossing is visible in
// the Bound For panel straight away.
function returnToEurope() {
  if (woiLocked()) { showEvent('EUROPENOTAVAIL'); return; }
  const u = G.units[G.sel];
  // A ship off the lane is sent TO the lane and the harbour stays shut until
  // it gets there; only a crossing that actually began opens Europe.
  if (u && u.ship && !orderSailHome(u)) return;
  G.screen = 'europe';
}
function centreView() { const u = G.units[G.sel]; if (u) centerOn(u.x, u.y); }
function activateUnit() {
  const u = G.units[G.sel];
  if (!u) return;
  u.orders = 0;
  if (!u.movesLeft) u.movesLeft = u.moves;
}
function loadCargo() {
  // The Load order at a colony runs the engine's pickers: @CARGOLOAD
  // (width 120) chooses the good, @HOWMUCH1 the amount.
  const u = G.units[G.sel];
  if (!u || !u.ship) { G.msg = 'Only a ship can load cargo.'; return; }
  const c = colonyAt(u.x, u.y);
  if (!c) { G.msg = 'No colony here.'; return; }
  u.hold = u.hold || [];
  const stocked = c.stock.map((q, i) => [q, i]).filter(s => s[0] > 0);
  if (!stocked.length) { G.msg = 'Nothing to load.'; return; }
  askEvent('CARGOLOAD', { STRING0: c.name }, (k) => {
    if (k < 0 || k >= stocked.length) return;
    const [q, i] = stocked[k];
    askAmount('HOWMUCH1', { STRING0: DATA.cargo[i].name, STRING1: u.type },
              Math.min(q, 100), (qty) => {
      if (!qty) return;
      c.stock[i] -= qty;
      holdAdd(u, i, qty);
      G.msg = `Loaded ${qty} ${DATA.cargo[i].name}.`;
    });
  }, stocked.map(s => `${s[0]} ${DATA.cargo[s[1]].name}`));
}
function unloadCargo() {
  const u = G.units[G.sel];
  if (!u || !u.ship) { G.msg = 'Only a ship can unload cargo.'; return; }
  const c = colonyAt(u.x, u.y);
  if (!c) { G.msg = 'No colony here.'; return; }
  const doUnload = () => {
    // @CARGOUNLOAD (width 120) chooses the slot, @HOWMUCH2 the amount.
    const slots = (u.hold || []).filter(h => h.qty > 0);
    if (!slots.length) { G.msg = 'Nothing to unload.'; return; }
    askEvent('CARGOUNLOAD', { STRING0: c.name }, (k) => {
      if (k < 0 || k >= slots.length) return;
      const h = slots[k];
      askAmount('HOWMUCH2', { STRING0: DATA.cargo[h.good].name,
                              STRING1: u.type, STRING2: c.name }, h.qty, (qty) => {
        if (!qty) return;
        holdAdd(u, h.good, -qty);
        c.stock[h.good] += qty;
        G.msg = `Unloaded ${qty} ${DATA.cargo[h.good].name}.`;
      });
    }, slots.map(h => `${h.qty} ${DATA.cargo[h.good].name}`));
  };
  // @WAREHOUSEFULL: the pre-unload spoilage warning, a 2-row confirm ("Never
  // mind." / "Unload the %STRING1 anyway."). Capacity = the byte-read 100-ton
  // overflow threshold; asked once for the first over-full good even when
  // several are (the engine's per-good behaviour is unread), flagged.
  const full = (u.hold || []).find(h => c.stock[h.good] + h.qty > 100);
  if (full) {
    askEvent('WAREHOUSEFULL',
             { STRING0: c.name, STRING1: DATA.cargo[full.good].name,
               NUMBER0: c.stock[full.good], NUMBER1: 100, NUMBER2: full.qty },
             (choice) => { if (choice === 1) doUnload(); });
    return;
  }
  doUnload();
}
function dumpCargo() {
  const u = G.units[G.sel];
  if (!u || !(u.hold || []).length) { G.msg = 'Nothing to dump.'; return; }
  // @OVERBOARD: "What cargo shall we throw overboard?" -- rows = the hold.
  const slots = u.hold.filter(h => h.qty > 0);
  askEvent('OVERBOARD', {}, (k) => {
    if (k < 0 || k >= slots.length) return;
    const i = u.hold.indexOf(slots[k]);
    if (i >= 0) u.hold.splice(i, 1);
    G.msg = 'Cargo dumped overboard.';
  }, slots.map(h => `${h.qty} ${DATA.cargo[h.good].name}`));
}
function disbandUnit() {
  if (!G.units.length) return;
  const u = G.units[G.sel];
  // @DISBANDSHIP: "We cannot disband a ship at sea while it is carrying
  // units." In port (a colony square) the men step ashore instead.
  if (u.ship && (u.cargo || []).length && !colonyAt(u.x, u.y)) {
    showEvent('DISBANDSHIP');
    return;
  }
  // @SUREDISBAND: "Really {disband} %STRING0?" -- Yes/No.
  askEvent('SUREDISBAND', { STRING0: u.type }, (k) => {
    if (k !== 0) return;
    G.msg = `${u.type} disbanded.`;
    const i = G.units.indexOf(u);
    if (i >= 0) G.units.splice(i, 1);
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
  });
}
// VIEW "Find Colony" is the @FINDCITY ENTRY dialog -- "Where the heck
// is . . . / Colony:" (census2_find_colony.png), not a cycler: type a name,
// Enter centres on the match, a miss posts @NOCITY ('"%STRING0" not
// found.', census2_find_colony_after.png). The engine's matcher is unread;
// case-blind prefix is the port's reading, flagged.
function findColony() {
  const t = DATA.dialogs.FINDCITY;
  if (!t) { G.msg = 'No colonies yet.'; return; }
  G.dialog = {
    body: t.body, tail: t.tail, width: t.width, small: !!t.small,
    entry: '', opts: null,
    onDone: (v) => {
      if (v === -1 || v === undefined) return;
      const q = String(v).trim().toLowerCase();
      const c = q && G.colonies.find(x => x.name.toLowerCase().startsWith(q));
      if (c) centerOn(c.x, c.y);
      else showEvent('NOCITY', { STRING0: String(v).trim() });
    },
  };
}
// §26.7 zoom: spans 0xF<<z by 0xC<<z tiles at 0x10>>z pixels.
function setZoom(z) {
  G.zoom = Math.max(0, Math.min(3, z));
  const u = G.units[G.sel];
  if (u) centerOn(u.x, u.y); else centerOn(G.view.x + 7, G.view.y + 6);
}
const COMMANDS = {
  // ORDERS
  'Activate unit': activateUnit,
  'Wait for next unit': () => nextUnit(),
  'Fortify': () => setOrder(5),
  'Sentry': () => setOrder(1),
  'Build Colony': buildColony,
  'Join Colony (B)': buildColony,
  'Clear Forest (P)': () => improveOrder(ORDER_CLEAR),
  'Plow Fields  (P)': () => improveOrder(ORDER_CLEAR),
  'Build Road': () => improveOrder(ORDER_ROAD),
  'Load Cargo': loadCargo,
  'Unload Cargo': unloadCargo,
  'Go to Port': returnToEurope,
  'Return to Europe': returnToEurope,
  'No Orders (space bar)': skipUnit,
  'Dump Cargo Overboard': dumpCargo,
  'Disband Unit (shift-D)': disbandUnit,
  // VIEW
  'Move Pieces': () => { G.viewMode = false; },
  'View Pieces': () => { G.viewMode = true; },
  'European Status': () => {
    if (woiLocked()) { showEvent('EUROPENOTAVAIL'); return; }
    G.screen = 'europe';
  },
  'Find Colony': findColony,
  // MENU.TXT spells these rows "Zoom In#   ~Z" / "Zoom Out   ~X", so the parsed
  // label carries the accelerator letter and both spellings must resolve.
  'Zoom In': () => setZoom(G.zoom - 1),
  'Zoom Out': () => setZoom(G.zoom + 1),
  'Zoom In   Z': () => setZoom(G.zoom - 1),
  'Zoom Out   X': () => setZoom(G.zoom + 1),
  'Zoom Level 15 x 12': () => setZoom(0),
  'Zoom Level 30 x 24': () => setZoom(1),
  'Zoom Level 60 x 48': () => setZoom(2),
  'Zoom Level 120 x 96': () => setZoom(3),
  'Show Hidden Terrain': () => { G.showHidden = !G.showHidden; },
  'Center View': centreView,
  // TRADE
  'Create Trade Route': () => openTradeMenu('create'),
  // Edit = the DOS route editor's stop/cargo pass (func_060C34/func_060D8C):
  // pick a route, a stop, then its LOAD and UNLOAD good lists (B3.4).
  'Edit Trade Route': () => openTradeMenu('edit'),
  'Delete Trade Route': () => openTradeMenu('delete'),
  'Begin Trade Route': () => openTradeMenu('assign'),
  'Pillage': pillage,
  'Go to Place': beginGoTo,
  // REPORTS -- the four advisers this build can populate from real state.
  'F1 Terrain Information': () => openPedia(2),
  'F2 Religious Adviser': () => { G.report = 'F2'; G.screen = 'report'; },
  'F3 Continental Congress': () => { G.report = 'F3'; G.screen = 'report'; },
  'F5 Economic Adviser': () => { G.report = 'F5'; G.screen = 'report'; },
  'F6 Colony Adviser': () => { G.report = 'F6'; G.screen = 'report'; },
  'F7 Naval Adviser': () => { G.report = 'F7'; G.screen = 'report'; },
  'F4 Labor Adviser': () => { G.report = 'F4'; G.screen = 'report'; },
  'F8 Foreign Affairs Advisor': () => {
    if (woiLocked()) { showEvent('FOREIGNNOTAVAIL'); return; }
    G.report = 'F8'; G.screen = 'report';
  },
  'F9 Indian Adviser': () => { G.report = 'F9'; G.screen = 'report'; },
  'F10 Colonization Score': () => { G.report = 'F10'; G.screen = 'report'; },
  // COLONIZOPEDIA -- the seven categories plus Complete (category 7).
  // GAME
  'DECLARE INDEPENDENCE': declareIndependence,
  // Game Options bit 0x0200 is the Combat Analysis checkbox
  // (spec/ui/options_dialogs.md §6). The full options dialog is not built, so
  // the row toggles the one option this build honours.
  'Game Options': () => openOptions('game'),
  'Colony Report Options': () => openOptions('colony'),
  'Sound Options': () => openOptions('sound'),
  'Pick Music': pickMusic,
  'Exit to DOS': exitToDos,
  'Retire': retire,
  'Save Game': saveGame,
  'Load Game': loadGame,
  'Cargo Types': () => openPedia(0),
  'Unit Types': () => openPedia(1),
  'Terrain Types': () => openPedia(2),
  'Colonist Skills': () => openPedia(3),
  'Colony Buildings': () => openPedia(4),
  'Founding Fathers': () => openPedia(5),
  'Miscellaneous': () => openPedia(6),
  'Complete': () => openPedia(7),
};
function openPedia(cat) {
  G.pediaCat = cat; G.pediaSel = 0; G.pediaMode = 'index'; G.screen = 'pedia';
}

// ---------------------------------------------------------------- input
function hit(mx, my, r) { return mx >= r.x && my >= r.y && mx < r.x + r.w && my < r.y + r.h; }

// ============================================================ drag and drop
// The port had NO drag model at all: the canvas carried a `click` listener and
// nothing else, so every interaction the DOS game does by dragging had either
// been approximated by a click or was simply missing.
//
// The engine's model, from the mouse module func_00D106 @0x0D106-0x0D1C9, which
// publishes five separate booleans per poll -- a DOM `click` collapses all of
// them into one event and throws the motion away:
//   [0x7EC]  down-edge         @0xD194   pressed since the last poll
//   [0x7F2]  press latch       @0xD19C
//   [0x7F4]  release edge      @0xD140
//   [0x7F6]  any button down   @0xD1BB
//   [0x7F0]  moved             @0xD188
//   [0x7E8]/[0x7EA]  cursor x/y
// There is NO pixel drag threshold: @0xD16F compares the poll-start snapshot
// [0x7F8]/[0x7FA] against the current position, so ONE pixel counts as moved.
// Left vs right is [0x7E4] = !(buttons & 1) (spec/ui/input.md §2, resolved
// 2026-06-25 at @0xD1A2-0xD1AE).
//
// On top of those the engine keeps a "what am I carrying" word -- [0x8D54] in
// the colony screen, [0x9E3A] in Europe -- which normally holds the region id
// under the cursor and is OVERWRITTEN with a payload mode while a drag is live.
// The payload detail sits beside it: source kind [0xA88C]/[0x9E22], good
// [0xA88D]/[0x9E24], amount [0xA88E]/[0x9E26], source hold [0xA88F]/[0x9E1E].
// G.drag below is that word plus those fields.
const PTR = {
  down: false, right: false, x: 0, y: 0, downX: 0, downY: 0, moved: false,
  // Set after a real drag so the synthetic DOM `click` that follows `pointerup`
  // does not also fire. UNCITED -- the click-after-release ordering is a DOM
  // artefact with no DOS analogue. A press and release with no payload is NOT
  // suppressed: in the engine the click paths and the drag paths live in the
  // same handlers, and a colonist press that never reaches the hold deadline
  // falls through to the click branch (@0x29CBD).
  suppressClick: false,
};

// How long the button must be held over a colonist before the drag arms.
// func_02C5D4 @0x2C87A sets the deadline to `timer + 8` (@0x2C887 arms it), and
// the tick rate is now BYTE-RESOLVED (RULINGS.md 2026-08-07b), the whole chain:
//   * the timer getter is lcall 0xC0C:6 (bytes 9a 06 00 0c 0c @0x2C868) ->
//     resident file 0xE4C6, which returns the dword behind far ptr [0x267A];
//   * install @0xC824-0xC860 hooks INT 8 (AH=35h/25h int 21h), reprograms the
//     PIT with divisor 0x7A8 = 1960 (`push 0x7a8; lcall 0xC10:8` @0xC843, the
//     setter `mov al,0x36; out 0x43` at file 0xE508) -> 1193182/1960 =
//     608.766 Hz raw, and points [0x267A] at DGROUP [0x92E8];
//   * the ISR (entry file 0xC694) counts [0x8338]++ every interrupt, exits on
//     odd ticks (`test [0x8338],1` @0xC6A5 -> /2), and a reload-5 divider
//     [0x376] (@0xC6F5, reload @0xC70B) gates the rest -> [0x92E8]++ @0xC741
//     at 608.766 / 2 / 5 = 60.8766 Hz -- EXACTLY the engine timer CYCLE.DAT
//     already established, which is the cross-check.
// So 8 ticks = 8 / 60.8766 Hz = 131.4 ms. (Sanity: the same loop's repaint
// cadence +0x14 = 20 ticks = 329 ms, message dwell 0x78 = 120 ticks = 1.97 s.)
const DRAG_HOLD_MS = 131;

// Region tables, byte-exact and IN THE ENGINE'S OWN TEST ORDER -- the order is
// load-bearing, not cosmetic: id 5 is tested before id 8, so any y >= 179
// resolves to the warehouse strip whatever else overlaps it.
// func_0299A0 @0x0299A0-0x029ABE, one block per push site.
const COLONY_REGIONS = [
  { r: { x: 200, y: 8, w: 120, h: 120 }, id: 1 },    // @0x299A9  tile panel
  { r: { x: 305, y: 179, w: 15, h: 21 }, id: 9 },    // @0x299C8  exit / gold
  { r: { x: 0, y: 130, w: 120, h: 48 }, id: 0 },     // @0x299E8  plaza row
  { r: { x: 0, y: 8, w: 199, h: 120 }, id: 2 },      // @0x29A08  building field
  { r: { x: 303, y: 132, w: 17, h: 45 }, id: 3 },    // @0x29A28  view buttons
  { r: { x: 0, y: 179, w: 305, h: 21 }, id: 5 },     // @0x29A48  warehouse strip
  { r: { x: 211, y: 130, w: 91, h: 48 }, id: 4 },    // @0x29A66  right panel
  { r: { x: 121, y: 130, w: 84, h: 48 }, id: 8 },    // @0x29A84  units in port
  { r: { x: 0, y: 0, w: 320, h: 7 }, id: 0xA },      // @0x29AA0  title strip
];
// func_03200A @0x03200A-0x0320EC.
const EUROPE_REGIONS = [
  { r: { x: 305, y: 179, w: 15, h: 21 }, id: 0xB },  // @0x3200E  exit
  { r: { x: 281, y: 89, w: 37, h: 32 }, id: 5 },     // @0x32034  menu buttons
  { r: { x: 0, y: 179, w: 305, h: 21 }, id: 0 },     // @0x32054  market strip
  { r: { x: 143, y: 118, w: 81, h: 60 }, id: 1 },    // @0x32074  ships + holds
  { r: { x: 72, y: 118, w: 70, h: 51 }, id: 2 },     // @0x32094  bound-for list
  { r: { x: 1, y: 118, w: 70, h: 51 }, id: 3 },      // @0x320B2  expected list
  { r: { x: 224, y: 120, w: 96, h: 59 }, id: 4 },    // @0x320CE  dock list
];
// The rect test itself is verb 0x181F:0x3CA = func_004B16 @0x04B16, literally
// x <= cursorX <= x+w-1 && y <= cursorY <= y+h-1 -- the same half-open box hit()
// already implements.
function regionAt(table, mx, my, none) {
  for (const e of table) if (hit(mx, my, e.r)) return e.id;
  return none;
}
const colonyRegionAt = (mx, my) => regionAt(COLONY_REGIONS, mx, my, 0x14);
const europeRegionAt = (mx, my) => regionAt(EUROPE_REGIONS, mx, my, 0xF);

// Which payload mode may be dropped on which region -- literal tables read off
// the engine, colony func_02BB8A @0x2BBBD-0x2BBF9 and Europe func_0353DE
// @0x35416-0x35464. A refused drop does NOT snap back quietly: the engine
// overwrites the mode with the no-region id (`mov [0x8D54],0x14` @0x2A4BA, the
// Europe twin @0x32555/@0x32718), i.e. the payload is dropped on the floor.
const DROP_OK = {
  colony: { 6: [0, 1, 2], 7: [5, 8] },
  europe: { 0xA: [0, 1], 8: [1, 2, 3], 9: [2, 3] },
};
function dropAllowed(screen, mode, target) {
  const t = DROP_OK[screen] && DROP_OK[screen][mode];
  return !!t && t.includes(target);
}

// The scene panel's 3x3, in cell coordinates relative to the colony centre.
// Cells are 24px at x = 200 + 24*col, y = 8 + 24*row for col/row 1..3, so the
// visible window is (224,32,72,72) and the centre works itself.
function colonyCellAt(mx, my) {
  if (!hit(mx, my, { x: 224, y: 32, w: 72, h: 72 })) return null;
  const cx = Math.floor((mx - 224) / 24) - 1, cy = Math.floor((my - 32) / 24) - 1;
  if (cx === 0 && cy === 0) return null;
  return [cx, cy];
}
// Which plaza-row colonist is under the cursor, or -1. Same solved pack the
// painter uses, so the sprites are hit-tested where they actually sit.
// The garrison half of the plaza row: which G.units index is under the cursor,
// or -1. Members are `colonist >= 0` and keep the drag-arm; units are the
// figures past the byte-verified 4px break (func_0270D0 counts colony+0x1F
// members then [0x8D72] units on the tile) and open @UNITOPTIONS instead.
function plazaUnitAt(c, mx, my) {
  for (const e of plazaRow(c)) {
    if (e.unit < 0) continue;
    if (mx < e.x || mx >= e.x + e.w) continue;
    if (my < PLAZA_ROW_Y || my >= PLAZA_ROW_Y + e.h) continue;
    return e.unit;
  }
  return -1;
}
function plazaColonistAt(c, mx, my) {
  for (const e of plazaRow(c)) {
    if (e.colonist < 0) continue;
    if (mx < e.x || mx >= e.x + e.w) continue;
    if (my < PLAZA_ROW_Y || my >= PLAZA_ROW_Y + e.h) continue;
    return e.colonist;
  }
  return -1;
}
// Which BUILDING plot is under the cursor in the building field (region 2), or
// null. The plots are the same PLOTS table the painter walks; each sprite is
// blitted at (px, py+8), so the box is measured from there. Only a building
// that actually employs a colonist is a drop target.
function colonyPlotAt(c, mx, my) {
  const present = colonyPlacement(c);
  // Walk backwards: later plots are painted last, so they are on top.
  for (let i = PLOTS.length - 1; i >= 0; i--) {
    const id = present[i];
    if (id < 0) continue;
    const [px, py] = PLOTS[i];
    const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
    if (!hit(mx, my, { x: px, y: py + 8, w: fw, h: fh })) continue;
    const name = DATA.buildings[id] && DATA.buildings[id].name;
    if (name && c.buildings.includes(name) && workplaceFor(name)) return name;
  }
  // Between the sprites: take the nearest employing building within 20px of
  // its plot origin, so a drop "at" a building does not fall through a gap in
  // its sprite's bounding box. Port tolerance -- the engine resolves region-2
  // drops through its own per-building zones, which are hover-label rects.
  let best = null, bestD = 21 * 21;
  PLOTS.forEach(([px, py], i) => {
    const id = present[i];
    if (id < 0) return;
    const name = DATA.buildings[id] && DATA.buildings[id].name;
    if (!name || !c.buildings.includes(name) || !workplaceFor(name)) return;
    const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
    const dx = mx - (px + (fw >> 1)), dy = my - (py + 8 + (fh >> 1));
    const d = dx * dx + dy * dy;
    if (d < bestD) { bestD = d; best = name; }
  });
  return best;
}
// Which INDOOR worker figure is under the cursor in the building field
// (region 2), or -1. The boxes are the painter's own crew anchors (see
// drawColonyBuildings: figure k of a shop's crew stands at
// (px + fw/2 + 5 - 9k, py + 8 + fh - 13)), so the hit is exactly where the
// sprite sits. Port addition -- the engine resolves region 2 through
// per-building hover zones whose action bodies are unread; clickable indoor
// workers give the same select-then-menu rhythm the plaza row has.
function buildingWorkerAt(c, mx, my) {
  const present = colonyPlacement(c);
  let found = -1;
  PLOTS.forEach(([px, py], i) => {
    const id = present[i];
    if (id < 0) return;
    const name = DATA.buildings[id] && DATA.buildings[id].name;
    if (!name || !c.buildings.includes(name)) return;
    const job = jobForBuilding(name);
    if (!job) return;
    const crew = c.colonists.map((p, q) => [p, q])
      .filter(([p]) => !p.cell && p.job === job).slice(0, 3);
    const [fw, fh] = frameSize('BUILDING', buildingFrame(c, id));
    crew.forEach(([p, q], k) => {
      const x = px + (fw >> 1) + 5 - 9 * k, y = py + 8 + fh - 13;
      const [w, h] = frameSize('ICONS', colonistFigure(p));
      if (hit(mx, my, { x, y, w, h })) found = q;
    });
  });
  return found;
}
// Europe: the selected ship's six holds, sub-rect (147,165,72,12) with the hold
// index (mx - 0x93) / 12 -- func_033716 @0x03371A and func_0335FA @0x033610.
function euroHoldAt(mx, my) {
  if (!hit(mx, my, { x: 147, y: 165, w: 72, h: 12 })) return -1;
  return Math.min(5, Math.floor((mx - 147) / 12));
}
// Europe: the market strip cell, clamp(mx,0,0x131)/0x13 rejected at >= 16
// (func_033A52 @0x33AB6-0x33AD3). The colony warehouse strip uses the same
// math (@0x2BA24-0x2BA3E).
function goodCellAt(mx) {
  const i = Math.floor(Math.min(Math.max(mx, 0), 0x131) / 0x13);
  return i >= 0 && i < 16 ? i : -1;
}

function dragGhostFrame(kind, good, amount, icon) {
  // Goods: ICONS ENGINE 0x17 + good for a full load, 0x27 + good for a part
  // load -- func_029BBE @0x29BD0/@0x29BD6/@0x29BD9, Europe twin func_0320EE
  // @0x32100/@0x32106/@0x32109. The bundle is engine MINUS ONE (the same
  // off-by-one the stockpile bar's 0x16+i already carries), so 0x16/0x26 here;
  // pixel-checked: bundle 0x16 is the food corn icon, 0x17 is tobacco.
  if (kind === 'good') return (amount >= 100 ? 0x16 : 0x26) + good;
  // Units: the Europe drag paths read byte [0x5232 + 14*type] (@0x321D6 and
  // @0x3221E) -- the runtime @UNIT record array NAMES.TXT fills (stride 14;
  // the file image holds unrelated code at that DGROUP offset, confirming it
  // is runtime-loaded data). Its icon field IS the @UNIT icon column, which is
  // exactly what u.icon carries -- so the port's frame is the engine's, with
  // the read site byte-cited and the table content NAMES-tier. (The colony
  // path's lcall 0x181F:0xA74 = file 0x0091CC turned out to resolve unit
  // NAMES/professions, not sprites -- disassembled 2026-08-07, it maps
  // profession ids through +0x52/+0x36 string bands.)
  return icon;
}

function beginDrag(d) {
  G.drag = d;
  G.dragArm = null;
}
function cancelDrag() { G.drag = null; G.dragArm = null; }

function onPointerDown(mx, my, right, shift) {
  // A right press cancels a live drag and is otherwise inert here.
  if (right) { if (G.drag) cancelDrag(); return; }
  if (G.combat || G.eventQueue.length || G.dialog) return;
  if (G.screen === 'colony') return colonyPointerDown(mx, my, shift);
  if (G.screen === 'europe') return europePointerDown(mx, my, shift);
  if (G.screen === 'map') {
    // A pulldown OPENS ON THE PRESS EDGE, like the engine's (the pulldown is
    // entered from the poll's held-button branch and lives only while held,
    // @0x6ECCF) -- the port used to open it only from the synthetic click
    // event, which made the native press-drag-release gesture a dead press
    // followed by a stray map click.
    if (G.openMenu >= 0) {
      const row = menuRowAt(mx, my);
      if (row >= 0) { G.menuSel = row; return; }
      const t = barTitleAt(mx);
      if (my < 8 && t >= 0) { openMenu(t); return; }
      G.openMenu = -1;
      return;
    }
    if (my < 8) {
      const t = barTitleAt(mx);
      if (t >= 0) openMenu(t);
    }
  }
}

function colonyPointerDown(mx, my, shift) {
  const c = G.colonies[G.colony];
  if (!c || G.colonyPopup) return;
  const region = colonyRegionAt(mx, my);
  // A colonist is HELD before it lifts: press, wait, then drag. Arm it now and
  // let onPointerMove/frame promote it once the deadline passes -- a quick
  // press and release stays a click, which is what selects him.
  if (region === 0) {
    // A GARRISON figure is a unit, not a member: it arms no drag. The
    // @UNITOPTIONS menu opens on the CLICK path, not this pointer-down one.
    if (plazaUnitAt(c, mx, my) >= 0) return;
    const i = plazaColonistAt(c, mx, my);
    if (i >= 0) G.dragArm = { at: G.wallClock, kind: 'unit', colonist: i, from: 'plaza' };
    return;
  }
  if (region === 1) {
    const cell = colonyCellAt(mx, my);
    if (!cell) return;
    const i = c.colonists.findIndex(p => p.cell && p.cell[0] === cell[0] && p.cell[1] === cell[1]);
    if (i >= 0) G.dragArm = { at: G.wallClock, kind: 'unit', colonist: i, from: 'field' };
    return;
  }
  // An indoor worker lifts out of his building the same way -- so he can be
  // dragged to a field cell, another shop, or the plaza (which idles him,
  // the jobs menu's "No job (plaza)" row).
  if (region === 2) {
    const i = buildingWorkerAt(c, mx, my);
    if (i >= 0) G.dragArm = { at: G.wallClock, kind: 'unit', colonist: i, from: 'building' };
    return;
  }
  // Goods off the warehouse strip start on the DOWN EDGE, with no hold -- and
  // note the engine re-probes the held button every poll rather than latching
  // the edge (func_02B9DC @0x2BA46 `cmp [0x7F6],0` plus @0x2BAAC `cmp [0x7E4],0`,
  // with no [0x7EC] test anywhere in that path). Starting it strictly here is
  // the port's simplification of that, and is flagged.
  //
  // It has nowhere to LAND, though: the engine's mode-7 targets are {5, 8}, and
  // region 8 is the colony's ships-in-port dock -- a panel the port does not
  // draw at all (drawColonyPanel paints only Buildings/Garrison/Production).
  // So the drag is armed for the ghost and the message, and the drop is a
  // no-op until that panel exists. Flagged in docs/UI_AUDIT_TRACKER.md.
  if (region === 5) {
    const g = goodCellAt(mx);
    if (g < 0 || !c.stock[g]) return;
    // Amount is min(stock, 100) -- @0x2BB10 `cmp ax,0x64`. Shift takes a part
    // load: func_004A22 @0x04A22 reads BDA 0040:0017 & 3 and passes it as the
    // last argument to every transfer routine.
    const amount = shift ? Math.min(c.stock[g], 10) : Math.min(c.stock[g], 100);
    beginDrag({ screen: 'colony', mode: 7, kind: 'good', good: g, amount,
                srcKind: 1, srcRegion: region,
                frame: dragGhostFrame('good', g, amount) });
    return;
  }
  // The dock: goods lifted OFF a hold cell start on the down-edge, like the
  // Europe hold path (func_02AEDA @0x2AF5A cmp [0x7EC],0). Cell math is the
  // byte-cited clamp(mx-0x7F,0,0x47)/0x0C @0x2AEE9; slots holding a carried
  // UNIT are skipped -- unloading units is the map's landfall path, not a
  // colony drag the evidence names.
  if (region === 8) {
    const ship = colonyShip(c);
    if (!ship || !hit(mx, my, { x: 127, y: 165, w: 72, h: 22 })) return;
    const cell = Math.min(5, Math.floor(Math.min(Math.max(mx - 127, 0), 0x47) / 12));
    const slot = (ship.hold || [])[cell - (ship.cargo || []).length];
    if (!slot) return;
    beginDrag({ screen: 'colony', mode: 7, kind: 'good', good: slot.good,
                amount: slot.qty, srcKind: 0, srcRegion: region,
                frame: dragGhostFrame('good', slot.good, slot.qty) });
  }
}

function europePointerDown(mx, my, shift) {
  if (G.euroMenu) return;
  const region = europeRegionAt(mx, my);
  const ship = activeShip();
  // Goods drags are mode 0xA, whose targets are {0, 1} -- the market strip and
  // the ships. That single mode covers both directions: hold -> market sells,
  // market -> ship buys.
  if (region === 0) {
    const g = goodCellAt(mx);
    if (g < 0) return;
    const amount = shift ? 10 : 100;      // @0x33BB8 `mov word [0x9E26],0x64`
    beginDrag({ screen: 'europe', mode: 0xA, kind: 'good', good: g, amount,
                srcKind: 1, srcRegion: region,
                frame: dragGhostFrame('good', g, amount) });
    return;
  }
  if (region === 1) {
    const h = euroHoldAt(mx, my);
    if (h >= 0 && ship) {
      const slot = ship.hold[h];
      if (!slot) return;
      beginDrag({ screen: 'europe', mode: 0xA, kind: 'good', good: slot.good,
                  amount: slot.qty, srcKind: 0, srcHold: h, srcRegion: region,
                  frame: dragGhostFrame('good', slot.good, slot.qty) });
      return;
    }
    // A ship lifted out of the harbour list is the engine's unit mode 9,
    // whose legal targets are {2, 3} (drop table func_0353DE @0x35464).
    // Dropping it on the Bound For panel asks @SAILAWAY before the crossing.
    const ships = shipsInPort();
    for (let k = 0; k < Math.min(ships.length, 6); k++) {
      if (!hit(mx, my, { x: EURO_SHIP.x + EURO_SHIP.pitch * k, y: EURO_SHIP.y, w: 18, h: 18 }))
        continue;
      beginDrag({ screen: 'europe', mode: 9, kind: 'ship', shipSlot: k,
                  srcRegion: region,
                  frame: dragGhostFrame('unit', 0, 0, ships[k].icon) });
      return;
    }
    return;
  }
  // A unit waiting on the dock, dragged onto a ship to board it. The engine's
  // own unit drags are modes 8 and 9 out of regions 1/2/3; the port draws its
  // dock list inside region 4 instead, on geometry that is itself UNCITED
  // (EURO_DOCK), so this binding is the port's own and is marked as such.
  if (region === 4) {
    for (let k = 0; k < Math.min(G.dockUnits.length, 6); k++) {
      if (!hit(mx, my, { x: EURO_DOCK.x + k * EURO_DOCK.pitch, y: EURO_DOCK.y, w: 18, h: 18 }))
        continue;
      const u = unit(entryType(G.dockUnits[k])) || unit('Colonists');
      beginDrag({ screen: 'europe', mode: 8, kind: 'unit', dockSlot: k,
                  srcRegion: region, frame: dragGhostFrame('unit', 0, 0, u.icon) });
      return;
    }
  }
}

function onPointerMove(mx, my) {
  // Promote an armed colonist once the hold deadline passes. Deliberately NOT
  // conditional on having moved: in the engine the timer alone lifts him, so
  // the ghost appears under a stationary held button and you can see you are
  // carrying him. A press that releases without ever moving is turned back into
  // a click in onPointerUp instead.
  // ... OR as soon as the press travels beyond click jitter: the engine's
  // timer-only lift made a quick flick (press-drag-release inside 131 ms)
  // drop the man silently, which read as "assignment is broken". Distance
  // promotion is the port reconciling its event-driven input with the
  // engine's poll loop (where a flick that fast cannot exist). UNCITED.
  if (G.dragArm && PTR.down &&
      (G.wallClock - G.dragArm.at >= DRAG_HOLD_MS ||
       Math.abs(mx - PTR.downX) > 3 || Math.abs(my - PTR.downY) > 3)) {
    const c = G.colonies[G.colony];
    const p = c && c.colonists[G.dragArm.colonist];
    if (p) {
      beginDrag({ screen: 'colony', mode: 6, kind: 'unit', colonist: G.dragArm.colonist,
                  from: G.dragArm.from, srcRegion: G.dragArm.from === 'plaza' ? 0 : 1,
                  frame: dragGhostFrame('unit', 0, 0, colonistFigure(p)) });
    } else G.dragArm = null;
  }
  // An open pulldown tracks the cursor while the button is held: the engine
  // re-hit-tests only when the moved flag is set (@0x6E5B1) and walks the row
  // rects (@0x6E5BB-0x6E667).
  if (G.screen === 'map' && G.openMenu >= 0 && PTR.down) {
    const row = menuRowAt(mx, my);
    if (row >= 0) G.menuSel = row;
    // Sliding along the bar while held walks the open pulldown across the
    // titles, as the engine's held-poll re-hit-tests the bar every pass.
    else if (my < 8) {
      const t = barTitleAt(mx);
      if (t >= 0 && t !== G.openMenu) openMenu(t);
    }
  }
  // The pre-game pickers are drag-live too: the cell under the cursor is
  // committed to the selection word on every poll while the button is down
  // (difficulty func_070580 @0x70677/@0x7071E, nation func_070A1A
  // @0x70B1C/@0x70BE1), and the RELEASE in the exit zone is what leaves.
  if (PTR.down && G.screen === 'difficulty')
    for (let n = 0; n < 5; n++) if (hit(mx, my, DIFF_CELL(n))) { G.difficulty = n; break; }
  if (PTR.down && G.screen === 'nation')
    for (let i = 0; i < 4; i++) if (hit(mx, my, NAT_CELL(i))) { G.nation = i; break; }
}

function onPointerUp(mx, my, right) {
  G.dragArm = null;
  if (right) return;
  // A pulldown commits on the RELEASE edge (@0x6EC70) and stays open only while
  // the button is held (@0x6ECCF). The menu gesture owns the whole press, so
  // the browser's synthetic click that follows is suppressed -- without that,
  // the click either re-closed the menu the press had just opened or leaked
  // through to whatever the row's command put on screen.
  if (G.screen === 'map' && G.openMenu >= 0) {
    PTR.suppressClick = true;
    const row = menuRowAt(mx, my);
    if (row >= 0) { G.menuSel = row; runMenuRow(); return; }
    // Released on the bar: the menu stays open, so a plain CLICK on the title
    // leaves a browsable pulldown (the port's click-click mode; the engine has
    // only the held gesture).
    if (my < 8 && barTitleAt(mx) >= 0) return;
    G.openMenu = -1;
    return;
  }
  const d = G.drag;
  if (!d) return;
  G.drag = null;
  // A press that never moved is a CLICK, not a zero-length drag: let it fall
  // through to onClick rather than "dropping" the payload where it started.
  // (The engine has no equivalent because it has no synthetic click event --
  // this is the port reconciling the two input models. UNCITED.)
  //
  // And a press that WOBBLED A PIXEL OR TWO is a click as well. The engine's
  // own moved flag has no threshold (@0xD16F), but its 320x200 mouse moved in
  // whole coarse pixels; the port's cursor runs at 2-3x scale, where the jitter
  // inside an ordinary click crosses a logical pixel easily. Without the
  // allowance, every deliberate click on a plaza colonist resolved as a
  // zero-distance drag-and-drop back onto the plaza -- which both swallowed the
  // click AND cleared the man's job. Port reconciliation, UNCITED.
  if (!PTR.moved) return;
  if (Math.abs(mx - PTR.downX) <= 2 && Math.abs(my - PTR.downY) <= 2) return;
  PTR.suppressClick = true;
  const target = d.screen === 'colony' ? colonyRegionAt(mx, my) : europeRegionAt(mx, my);
  if (!dropAllowed(d.screen, d.mode, target)) return;   // refused: payload dropped
  if (d.screen === 'colony') colonyDrop(d, target, mx, my);
  else europeDrop(d, target, mx, my);
}

function colonyDrop(d, target, mx, my) {
  const c = G.colonies[G.colony];
  if (!c) return;
  if (d.kind === 'unit') {
    const p = c.colonists[d.colonist];
    if (!p) return;
    G.colonistSel = d.colonist;
    if (target === 1) {
      const cell = colonyCellAt(mx, my);
      if (!cell) return;
      // Evicting whoever holds the target cell is UNCITED -- the manual only
      // describes dropping on an empty location.
      // @NODOCKS: no fishing boats without Docks.
      if (tileWater(at(c.x + cell[0], c.y + cell[1])) &&
          !c.buildings.includes('Docks')) {
        showEvent('NODOCKS', { STRING0: c.name });
        return;
      }
      const on = c.colonists.find(q => q !== p && q.cell &&
                                       q.cell[0] === cell[0] && q.cell[1] === cell[1]);
      if (on) { on.cell = null; on.job = null; }
      p.cell = cell;
      p.job = bestFieldJob(c, p);
      return;
    }
    if (target === 0) {
      // Lifting a man out of the plaza and putting him back down is identity,
      // not an unassignment: only a drop FROM THE FIELDS clears his work.
      // (Port's own reading; the engine's drop-action bodies are unread.)
      if (d.from === 'plaza') return;
      // Out of a BUILDING onto the plaza: he goes idle but stays a member --
      // the jobs menu's "No job (plaza)" row, not the fence.
      if (d.from === 'building') { p.cell = null; p.job = null; return; }
      // Dropped out of the fields with no new job: same as the menu's
      // "Return to the fence" -- he leaves the colony and waits outside.
      colonistToFence(c, c.colonists.indexOf(p));
      return;
    }
    if (target === 2) {
      // Dropped on the building field: if it landed on a building that employs
      // anyone, that is the new job. A drop on bare ground is a no-op rather
      // than a silent plaza return.
      const b = colonyPlotAt(c, mx, my);
      if (!b) return;
      // @MORETHANTHREE: at most three colonists in any one building.
      if (buildingCrew(c, b) >= 3 && p.job !== jobForBuilding(b)) {
        showEvent('MORETHANTHREE', {});
        return;
      }
      if (jobForBuilding(b) === 'Teacher' && p.job !== 'Teacher' &&
          teacherGuard(c, p)) return;
      p.cell = null;
      p.job = jobForBuilding(b);
    }
    return;
  }
  // Goods. Mode 7's byte-cited targets are {5, 8}: the warehouse strip and the
  // ships-in-port dock. What each PAIRING does (load vs unload) is the port's
  // reading of the obvious direction -- the drop-action bodies func_02A6A6 /
  // func_02A8EC are on the open-items ledger and their refusal conditions are
  // not yet byte-read.
  if (d.kind === 'good') {
    const ship = colonyShip(c);
    if (target === 8 && d.srcKind === 1) {
      // Warehouse -> ship. Needs a ship and a hold: units aboard occupy holds
      // too, and a same-good slot merges (holdAdd) rather than taking a second
      // slot -- the port's own convention, shared with the trade routes.
      //
      // The engine's transfer executor func_02A8EC (byte-read 2026-08-07f)
      // clamps the moved amount at 0x64 = 100 AND at the destination's free
      // space before anything moves (the 0x181F:0xB96/0xC68 pair), refusing
      // with a timed message when there is no room -- so a hold slot never
      // exceeds a 100-load. Under the merge convention that space is
      // (free slots)*100 plus the headroom in the merge slot.
      if (!ship) { notice('No ships in port.'); return; }
      const cap = Number((unit(ship.type) || {}).cargo) || 0;
      const slot = (ship.hold || []).find(h => h.good === d.good);
      const used = (ship.cargo || []).length + (ship.hold || []).length;
      const space = Math.max(0, cap - used) * 100 +
                    (slot ? Math.max(0, 100 - slot.qty) : 0);
      if (space <= 0) { notice(`The ${ship.type}'s holds are full.`); return; }
      // @HOWMUCH1 "How much X should be loaded onto Y (0-N)" -- the bounded
      // amount entry (shift-drag keeps the old grab-all fast path).
      const most = Math.min(c.stock[d.good], space, 100);
      if (!most) return;
      askAmount('HOWMUCH1', { STRING0: DATA.cargo[d.good].name,
                              STRING1: ship.type }, most, (qty) => {
        if (!qty) return;
        c.stock[d.good] -= qty;
        ship.hold = ship.hold || [];
        holdAdd(ship, d.good, qty);
      });
      return;
    }
    if (target === 5 && d.srcKind === 0) {
      // Ship -> warehouse: @HOWMUCH2 "unloaded from Y to Z (0-N)".
      if (!ship) return;
      const have = holdQty(ship, d.good);
      if (!have) return;
      askAmount('HOWMUCH2', { STRING0: DATA.cargo[d.good].name,
                              STRING1: ship.type, STRING2: c.name }, have, (qty) => {
        if (!qty) return;
        holdAdd(ship, d.good, -qty);
        c.stock[d.good] += qty;
      });
    }
  }
}

function europeDrop(d, target, mx, my) {
  const ship = activeShip();
  if (d.kind === 'good') {
    if (target === 0 && d.srcKind === 0) { sellFromShip(d.good); return; }
    if (target === 1 && d.srcKind === 1) {
      if (!ship) { G.euroMsg = 'No ships in port.'; return; }
      if (isBoycotted(d.good)) {
        G.euroMsg = `${DATA.cargo[d.good].name} is under boycott.`;
        return;
      }
      // @HOWMUCH4 "How much X (at N$) should be purchased and loaded onto
      // Y (0-N)" -- bounded by hold space and the treasury.
      const cap = Number((unit(ship.type) || {}).cargo) || 0;
      const slot = (ship.hold || []).find(h => h.good === d.good);
      const used = (ship.passengers || []).length + (ship.hold || []).length;
      const space = Math.max(0, cap - used) * 100 +
                    (slot ? Math.max(0, 100 - slot.qty) : 0);
      const most = Math.min(space, Math.floor(G.gold / askPrice(d.good)), 100);
      if (most <= 0) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
      tutOnce(18, { STRING0: DATA.cargo[d.good].name, NUMBER0: askPrice(d.good) });
      askAmount('HOWMUCH4', { STRING0: DATA.cargo[d.good].name,
                              STRING1: ship.type, NUMBER1: askPrice(d.good) },
                most, (qty) => { if (qty) buyToShip(d.good, qty); });
      return;
    }
    // Market -> market, or hold -> hold: nothing moves.
    return;
  }
  if (d.kind === 'unit' && target === 1) {
    // Board the selected ship. Six passengers is the cap the sailing code uses.
    if (!ship) { G.euroMsg = 'No ships in port.'; return; }
    ship.passengers = ship.passengers || [];
    if (ship.passengers.length >= 6) { G.euroMsg = 'That ship is full.'; return; }
    const e = G.dockUnits[d.dockSlot];
    if (e === undefined) return;
    G.dockUnits.splice(d.dockSlot, 1);
    ship.passengers.push(e);
    G.euroMsg = `${entryName(e)} boards the ${ship.type}.`;
    void mx; void my;
    return;
  }
  // A ship dropped on the Bound For panel (region 2): @SAILAWAY -- "Shall we
  // set sail for the New World?" -- then the crossing. The drop's legality is
  // byte-cited (mode 9 -> {2,3}); the confirm-on-drop binding is the port's.
  if (d.kind === 'ship' && target === 2) {
    const s = shipsInPort()[d.shipSlot];
    if (s) confirmSailAway(s);
  }
}

// @SAILAWAY (GAME.TXT @width=190 @default=1): row 0 "Yes, steady as she goes."
// is the highlighted default; row 1 declines. Every route west -- Bound For
// drop, ship menu row, the S key -- goes through this one confirm.
function confirmSailAway(e) {
  openDialog('SAILAWAY', (choice) => { if (choice === 0) sailForNewWorld(e); });
}

// The engine does not draw a second sprite for the payload -- it SWAPS THE
// CURSOR SPRITE (the mouse module's 16x16 software cursor, blit @0xCE98), so
// there is exactly one image following the pointer. Same here.
//
// The hotspot is RESOLVED (2026-08-07b): func_00DB80 reads the frame
// descriptor's dimension words and HALVES them -- `mov ax,es:[si+0x3e]; sar
// ax,1` / `mov cx,es:[si+0x40]; sar cx,1` @0xDC09-0xDC18 -- caches the pair in
// [0x262C]/[0x262E] @0xDC65-0xDC68 and pushes them to lcall 0xA58:0x1D9
// @0xDC71-0xDC77, which is file 0xCB59 = the mouse module's set_hotspot. So
// the ghost is CENTRED on the pointer.
function drawDragGhost(ctx) {
  if (!G.drag || G.drag.frame === undefined) return;
  const [fw, fh] = frameSize('ICONS', G.drag.frame);
  sheetFrame(ctx, 'ICONS', G.drag.frame, PTR.x - (fw >> 1), PTR.y - (fh >> 1));
}

// Which pulldown row the cursor is over, or -1. Reads the same pulldownBox()
// the painter uses, and the same `b.y + 2 + k*8` row pitch it draws with.
function menuRowAt(mx, my) {
  if (G.openMenu < 0) return -1;
  const b = pulldownBox(G.openMenu);
  if (!hit(mx, my, b)) return -1;
  const row = Math.floor((my - (b.y + 2)) / 8);
  return row >= 0 && row < DATA.menus[G.openMenu].rows.length ? row : -1;
}

function onClick(mx, my) {
  if (G.combat) { G.combat = null; return; }
  if (G.eventQueue.length) { G.eventQueue.shift(); return; }
  if (G.dialog) { dialogClick(mx, my); return; }
  switch (G.screen) {
    case 'title': {
      const b = MENU_BOX;
      for (let k = 0; k < MENU_OPTS.length; k++) {
        if (hit(mx, my, { x: b.x + 4, y: 106 + 8 * k, w: 158, h: 7 })) { G.menuRow = k; commitMenu(); return; }
      }
      break;
    }
    case 'difficulty': {
      for (let n = 0; n < 5; n++) if (hit(mx, my, DIFF_CELL(n))) { G.difficulty = n; return; }
      // Commit zone: click with mouseY<103 & mouseX<128 (§26.2)
      if (my < 103 && mx < 128) G.screen = 'nation';
      break;
    }
    case 'nation': {
      for (let i = 0; i < 4; i++) if (hit(mx, my, NAT_CELL(i))) { G.nation = i; return; }
      if (mx < 112) { G.leader = DATA.nations[G.nation].leader; G.screen = 'name'; }
      break;
    }
    case 'name': G.briefPage = 0; G.screen = 'briefing'; break;
    // The audience commissions the voyage, so it precedes it: the @BUILD cards
    // narrate the expedition already under way ("Commissioned and Blessed by
    // the King of England", "A Ship loaded with Pioneers and Soldiers Set
    // Sail"), which only follows the throne room.
    case 'briefing':
      if (G.briefPage === 0) G.briefPage = 1;
      else G.screen = 'king';
      break;
    case 'king': G.card = 0; G.screen = 'cards'; break;
    case 'cards':
      if (G.card < 9) G.card++;
      else { beginGame(); G.screen = 'map'; }
      break;
    case 'woodcut': {
      // Woodcut 1 is the discovery plate and hands over to the naming prompt;
      // woodcut 2 is BUILDING A COLONY and hands over to the new colony.
      // Everything else lands wherever its trigger parked in G.wcAfter (the
      // village behind the first-contact plates, Europe behind CARGO FROM THE
      // NEW WORLD), or back on the map.
      const after = G.wcAfter; G.wcAfter = null;
      if (G.woodcut === 1) { G.screen = 'map'; askLandName(); }
      else if (G.woodcut === 2) G.screen = 'colony';
      else if (typeof after === 'function') after();
      else G.screen = after || 'map';
      break;
    }
    case 'report':
      G.screen = 'map';
      break;
    case 'village': {
      const b = villageBox(), seed = b.y + 6 + b.textH + 3;
      for (let r = 0; r < b.rows.length; r++)
        if (hit(mx, my, { x: b.x + 3, y: seed + r * DROW, w: b.w - 6, h: DROW })) {
          G.villageRow = r; villageCommit(); return;
        }
      break;
    }
    case 'pedia': {
      // The index is two columns of 22 rows; a click on an entry page returns
      // to the index, which is what Esc does from there too.
      if (G.pediaMode !== 'index') { G.pediaMode = 'index'; return; }
      const n = pediaList().length;
      const r = Math.floor((my - 24) / 7), i = (mx >= 160 ? 22 : 0) + r;
      if (r >= 0 && r < 22 && i < n) { G.pediaSel = i; G.pediaMode = 'entry'; }
      break;
    }
    case 'colony': {
      if (G.colonyPopup) {
        const sm = colonyPopupSmall(), rp = dRow(sm);
        const b = colonyPopupBox(), seed = b.y + 6 + dText(sm) + 3;
        for (let k = 0; k < b.rows.length; k++)
          if (hit(mx, my, { x: b.x + 3, y: seed + k * rp, w: b.w - 6, h: rp })) {
            G.colonyPopupRow = k; colonyPopupCommit(); return;
          }
        // A click outside the rows dismisses the popup and FALLS THROUGH to
        // the normal colony hit-tests, so the click is not wasted. UNCITED --
        // dismissal semantics are the port's own choice; the reopen-on-reclick
        // below is the manual's (GAME_MANUAL.md 1930-1931).
        G.colonyPopup = null;
      }
      const c = G.colonies[G.colony];
      // Scene panel: a click on one of the nine visible cells puts the selected
      // plaza colonist to work that field, or calls a worker back in.
      if (c && hit(mx, my, { x: 224, y: 32, w: 72, h: 72 })) {
        const cx = Math.floor((mx - 224) / 24) - 1, cy = Math.floor((my - 32) / 24) - 1;
        if (cx === 0 && cy === 0) return;                 // the centre works itself
        const on = c.colonists.find(p => p.cell && p.cell[0] === cx && p.cell[1] === cy);
        // A click on a WORKING colonist selects him; a second click opens his
        // OCCUPATION menu -- every outdoor job with this square's yields --
        // the same select-then-menu rhythm as the plaza row. Taking him off
        // the field is a drag (to the fence) or the menu's bottom row, not a
        // bare click: the old click-evicts behaviour threw workers off their
        // squares when the player was trying to inspect them.
        if (on) {
          const i = c.colonists.indexOf(on);
          if (G.colonistSel === i) { G.colonyPopup = 'occupation'; G.colonyPopupRow = 0; }
          else G.colonistSel = i;
          return;
        }
        {
          // Move the SELECTED colonist. This used to grab the first colonist
          // with no cell, which broke the interaction two ways: a different
          // colonist than the one you picked would walk out to the field, and
          // once everyone held a cell `find` returned undefined and the click
          // did nothing at all -- so a working colonist could never be moved.
          //
          // GAME_MANUAL.md: "you may move a colonist within the colony area or
          // settlement views simply by clicking the location to which you want
          // him to move." Manual-tier, not byte-verified: see the note above.
          // The engine puts him on the field's BEST job; ties go to the earlier
          // @JOB row, which puts Farmer first.
          const who = c.colonists[G.colonistSel];
          if (who) {
            // @NODOCKS: no fishing boats without Docks.
            if (tileWater(at(c.x + cx, c.y + cy)) && !c.buildings.includes('Docks')) {
              showEvent('NODOCKS', { STRING0: c.name });
              return;
            }
            who.cell = [cx, cy];
            who.job = bestFieldJob(c, who);
          }
        }
        return;
      }
      // Plaza: click a colonist to select, click again for the jobs menu.
      if (c && hit(mx, my, { x: 0, y: 130, w: 120, h: 48 })) {
        // A GARRISON figure -- one of the entries past the byte-verified 4px
        // break (func_0270D0 counts colony+0x1F members, then [0x8D72] units
        // on the tile) -- is a unit, and opens @UNITOPTIONS.
        const gu = plazaUnitAt(c, mx, my);
        if (gu >= 0) {
          G.colonyPopup = 'unitopts';
          G.colonyPopupUnit = gu;
          G.colonyPopupRow = 0;
          return;
        }
        // The row is the solved pack, so hit-test the sprites themselves. The
        // garrison entries are units, not colonists, and have no jobs menu.
        for (const e of plazaRow(c)) {
          if (e.colonist < 0) continue;
          if (mx < e.x || mx >= e.x + e.w) continue;
          if (my < PLAZA_ROW_Y || my >= PLAZA_ROW_Y + e.h) continue;
          if (G.colonistSel === e.colonist) { G.colonyPopup = 'jobs'; G.colonyPopupRow = 0; }
          else G.colonistSel = e.colonist;
          return;
        }
        return;
      }
      // Building field: the crew figures under each shop are clickable like
      // the plaza row -- click selects the man, a second click opens his
      // JOBS menu (see buildingWorkerAt for the geometry and the port-
      // addition note).
      if (c && hit(mx, my, { x: 0, y: 8, w: 199, h: 120 })) {
        const i = buildingWorkerAt(c, mx, my);
        if (i >= 0) {
          if (G.colonistSel === i) { G.colonyPopup = 'jobs'; G.colonyPopupRow = 0; }
          else G.colonistSel = i;
          return;
        }
      }
      // Dock: click a ship box to make it the one the hold row shows. Boxes
      // are the byte-cited 16x16 cells at x = 130 + 18k, y = 147 (see
      // drawColonyDock's citations).
      if (c) {
        const ships = colonyShips(c);
        for (let k = 0; k < Math.min(ships.length, 4); k++) {
          if (hit(mx, my, { x: COLONY_DOCK.shipX + k * COLONY_DOCK.shipPitch,
                            y: COLONY_DOCK.shipY, w: 16, h: 16 })) {
            // Select, then click the SAME box again for @SHIPOPTIONS -- the
            // select-then-menu rhythm the plaza row and the Europe harbour
            // ship box both use.
            if (G.colonyShipSel === k) {
              G.colonyPopup = 'shipopts';
              G.colonyPopupUnit = G.units.indexOf(ships[k]);
              G.colonyPopupRow = 0;
            } else G.colonyShipSel = k;
            return;
          }
        }
      }
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: VIEW_BTN.x, y: VIEW_BTN.y + k * VIEW_BTN.pitch,
                          w: VIEW_BTN.w, h: VIEW_BTN.h })) { G.colonyView = k; return; }
      }
      // Build view: BUY rushes the target (@BUYME0/1), CHANGE opens the
      // construction picker (census3_colony_view2's two buttons).
      if (G.colonyView === VIEW_BUILD) {
        if (hit(mx, my, BUILD_BTN.buy)) { rushBuy(); return; }
        if (hit(mx, my, BUILD_BTN.change)) { openBuildPicker(); return; }
      }
      // "To see a numeric representation, click anywhere in the multi-
      // function view after you have clicked the Production button"
      // (GAME_MANUAL.md, Production View) -- the engine's toggle flips the
      // SAVED [0x336] byte (@0x02B99E / @0x02BF7C), which also drives the
      // plaza-strip badges.
      if (G.colonyView === VIEW_PRODUCTION &&
          hit(mx, my, { x: 207, y: 130, w: 95, h: 48 })) {
        G.colonyNumbers = !G.colonyNumbers; return;
      }
      // x=305, not 306: func_0299A0 @0x299C8 pushes 0x15,0x0F,0xB3,0x131 =
      // h=21,w=15,y=179,x=0x131=305 for colony region 9. (spec/ui/input.md:522
      // carries the off-by-one.) That this region EXITS is the port's own
      // reading -- UNCITED; the spec glosses region 9 as the warehouse/gold
      // readout built on heap string [0x2F5E], and the region-id -> action
      // switch is overlay-resident and undecoded.
      if (hit(mx, my, { x: 305, y: 179, w: 15, h: 21 })) G.screen = 'map';
      break;
    }
    case 'europe': {
      if (G.euroMenu) {
        const b = euroMenuBox();
        const seed = b.y + 6 + b.textH + 3;
        const erp = dRow(G.euroMenu === 'train');
        for (let k = 0; k < b.rows.length; k++) {
          if (hit(mx, my, { x: b.x + 3, y: seed + k * erp, w: b.w - 6, h: erp })) {
            G.euroMenuRow = k; euroMenuCommit(); return;
          }
        }
        G.euroMenu = null;                       // click outside closes it
        return;
      }
      // x=305 -- func_03200A @0x3200E pushes 0x15,0x0F,0xB3,0x131 for Europe
      // region 0xB. Note spec/ui/input.md:571 is wrong twice over: it gives 306
      // AND cites @0x032034, which is the id-5 block. Exit semantics UNCITED,
      // as for the colony twin above.
      if (hit(mx, my, { x: 305, y: 179, w: 15, h: 21 })) { G.screen = 'map'; return; }
      // Menu buttons.
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: 281, y: 89 + 11 * k, w: 37, h: 9 })) {
          G.euroRow = k; openEuroMenu(k); return;
        }
      }
      // Ship boxes select the ship being loaded. These are the boxes the port
      // actually PAINTS (EURO_SHIP, 18x18 at its pitch) -- the rect here used to
      // be the CARGO-HOLD strip's geometry wearing a ship-select action, so a
      // click meant for a hold silently re-picked a ship instead.
      //
      // The engine splits its region 1 (143,118,81,60) on the sub-rect
      // (147,165,72,12): inside = the selected ship's six holds, outside = the
      // ships-in-harbour list. func_033716 @0x03371A pushes 0x0C,0x48,0xA5,0x93
      // = h,w,y,x; the hold index is (mx-0x93)/12 @0x033610. The port had the
      // two inverted. The 145/145/12/18x18 box layout itself is UNCITED (the
      // engine lays the list out through func_031298 @0x0312E5, which the port
      // does not implement); the holds are drag targets and are wired below.
      const ships = shipsInPort();
      for (let k = 0; k < Math.min(ships.length, 6); k++) {
        if (hit(mx, my, { x: EURO_SHIP.x + EURO_SHIP.pitch * k, y: EURO_SHIP.y, w: 18, h: 18 })) {
          // Click selects; a click on the ship already selected opens its
          // @EUROPESHIPOPTIONS menu (Set sail / Unload / Move to front) -- the
          // same select-then-menu rhythm the colony plaza uses.
          if (G.euroShip === k) { G.euroMenu = 'ship'; G.euroMenuRow = 0; G.euroMsg = ''; }
          else G.euroShip = k;
          return;
        }
      }
      // A unit waiting on the dock: its @ARMOPTIONS context menu (board, move
      // to front, arm with muskets / tools / horses, missionary status).
      for (let k = 0; k < Math.min(G.dockUnits.length, 6); k++) {
        if (hit(mx, my, { x: EURO_DOCK.x + k * EURO_DOCK.pitch, y: EURO_DOCK.y, w: 18, h: 18 })) {
          G.euroDockSel = k; G.euroMenu = 'dockunit'; G.euroMenuRow = 0; G.euroMsg = '';
          return;
        }
      }
      // The market bar routes clicks to the SELL handler (§9.4).
      if (my >= 179) {
        const i = Math.floor(mx / 19);
        if (i >= 0 && i < 16) { G.marketSel = i; sellFromShip(i); }
      }
      break;
    }
    case 'map': {
      if (G.openMenu >= 0) {
        const b = pulldownBox(G.openMenu);
        if (hit(mx, my, b)) {
          G.menuSel = Math.max(0, Math.min(DATA.menus[G.openMenu].rows.length - 1,
                                           Math.floor((my - b.y - 2) / 8)));
          runMenuRow();
        } else G.openMenu = -1;
        return;
      }
      if (my < 8) {
        for (let i = 0; i < BAR_TITLES.length; i++) {
          const [t, x] = BAR_TITLES[i];
          if (mx >= x - 2 && mx < x + FONT.tiny.width(t) + 2) { openMenu(i); return; }
        }
        return;
      }
      if (hit(mx, my, VP)) {
        const tx = G.view.x + Math.floor((mx - VP.x) / TILE_PX());
        const ty = G.view.y + Math.floor((my - VP.y) / TILE_PX());
        // A pending "Go to Place" takes the next map click as its destination.
        if (G.goTo) { setGoTo(G.goTo, tx, ty); return; }
        // Clicking your own colony opens its screen -- the COLONY WINS over
        // any unit stack standing on the square.  GAME_MANUAL.md p40 puts no
        // "unoccupied" condition on it, and a colony square nearly always
        // holds units, so the old `&& !on.length` guard made the colony
        // screen almost unreachable by clicking (user report 2026-08-17).
        // Clicking a stack with no colony still cycles through the units.
        const ci = G.colonies.findIndex(c => c.x === tx && c.y === ty);
        const on = G.units.map((u, i) => i).filter(i => G.units[i].x === tx && G.units[i].y === ty);
        if (ci >= 0) { G.colony = ci; G.screen = 'colony'; }
        else if (on.length) G.sel = on[(on.indexOf(G.sel) + 1) % on.length];
        else centerOn(tx, ty);
      }
      break;
    }
  }
}

const HOF_KEY = 'colonization.hof';
function hofLoad() {
  try { return JSON.parse(localStorage.getItem(HOF_KEY) || '[]'); }
  catch (e) { return []; }
}
function hofWrite(rec) {
  const list = hofLoad();
  // Descending insertion on the +0x26 RATING word (func_03ADA6 @0x3AECD --
  // the int16 the screen prints as "Colonization Rating: N%"), max 6.
  let k = 0;
  while (k < list.length && (list[k].rating || 0) >= (rec.rating || 0)) k++;
  list.splice(k, 0, rec);
  while (list.length > 6) list.pop();
  try { localStorage.setItem(HOF_KEY, JSON.stringify(list)); } catch (e) {}
}
// The Hall of Fame table, REBUILT 2026-08-07 from a live capture driven by a
// hand-authored HALLFAME.DAT (tools/dosbox_harness/shots/hof_01_table.png /
// hof_02_round2.png -- the Phase 4 capture that closed drawHof's column TBD).
// The real screen is NOT a column table: each record is THREE text lines.
// Measured geometry (native 320x200): title glyph-top y=3 centred on x=160;
// record k at y=20+36k, lines at +0/+11/+22; rank "N." at x=10, text at x=25;
// line 3 centred on x=160; every glyph in the single green ink 68 (85,150,52)
// = HUD_INK. Field semantics pinned by the two crafted-DAT rounds:
//   +0x18 nation (doubles as the 0xFFFF empty sentinel)   +0x1a declared flag
//   +0x1c independence-won flag   +0x1e year   +0x22 difficulty
//   +0x24 score points   +0x26 Colonization Rating % (the ranking key)
// Line templates (all fragments are @MISC / NAMES data):
//   1: "<k>.  <difficulty> <NAME> of the [Free ]<adjective>"
//   2: "President, <@INDEPENDENT[nation]>" | "General, Continental Army"
//      | "Leader, <adjective> Colonies", then "to A.D. <year>.  Score: <pts>"
//   3: "--- Colonization Rating: <rating>% ---"
function drawHof(ctx) {
  usePalette('WOODPANL');
  if (IMG.WOODPANL) ctx.drawImage(IMG.WOODPANL, 0, 0);
  else { ctx.fillStyle = '#000'; ctx.fillRect(0, 0, W, H); }
  const m = DATA.text.misc, ink = lut(HUD_INK);
  FONT.intr.center(ctx, m[192] || 'COLONIZATION HALL OF FAME', 160, 3, ink);
  const list = hofLoad().slice(0, 5);
  list.forEach((rec, k) => {
    const y = 20 + 36 * k;
    const adj = DATA.nations[rec.nation] ? DATA.nations[rec.nation].adjective : '';
    const diff = DATA.difficulty[rec.difficulty || 0] || '';
    FONT.intr.draw(ctx, `${k + 1}.`, 10, y, ink);
    FONT.intr.draw(ctx,
      `${diff} ${rec.name} of the ${rec.declared ? (m[191] || 'Free') + ' ' : ''}${adj}`,
      25, y, ink);
    const career = rec.independent
      ? `${m[195] || 'President'}, ${(DATA.independent || [])[rec.nation] || ''}`
      : rec.declared ? (m[196] || 'General, Continental Army')
      : `${m[197] || 'Leader'}, ${adj} Colonies`;
    FONT.intr.draw(ctx,
      `${career} ${m[193] || 'to'} ${m[194] || 'A.D.'} ${rec.year}.  ` +
      `${m[198] || 'Score'}: ${rec.score}`, 25, y + 11, ink);
    FONT.intr.center(ctx,
      `--- ${(m[199] || 'Colonization_Rating').replace(/_/g, ' ')}: ` +
      `${rec.rating}% ---`, 160, y + 22, ink);
  });
}
function commitMenu() {
  // Real dispatch ladder @0x075C6D: rows 0-2 all enter the new-game setup path;
  // 3 = LOAD Game (browser save / the shipped 1653 save / a .SAV off disk);
  // 4 = View Hall of Fame.
  if (G.menuRow <= 2) G.screen = 'difficulty';
  else if (G.menuRow === 3) openLoadMenu();
  else if (G.menuRow === 4) G.screen = 'hof';
}

function onKey(e) {
  const k = e.key;
  // Backtick toggles the debug column. Checked first so it works even while a
  // popup is modal -- that is exactly when you want to look at the state.
  if (k === '`' || k === '~') { dbgToggle(); e.preventDefault(); return; }
  // The combat panel and the event popups are modal: each swallows the next key
  // and pops itself.
  if (G.combat) { G.combat = null; e.preventDefault(); return; }
  if (G.eventQueue.length) { G.eventQueue.shift(); e.preventDefault(); return; }
  if (G.dialog) { dialogKey(k); e.preventDefault(); return; }
  if (G.screen === 'name') {
    if (k === 'Enter') { if (!G.leader) G.leader = DATA.nations[G.nation].leader;
                         G.briefPage = 0; G.screen = 'briefing'; }
    else if (k === 'Backspace') G.leader = G.leader.slice(0, -1);
    else if (k.length === 1 && G.leader.length < 23) G.leader += k;
    e.preventDefault();
    return;
  }
  switch (G.screen) {
    case 'hof':
      if (k === 'Escape' || k === 'Enter' || k === ' ') { G.screen = 'title'; G.menuRow = 0; }
      break;
    case 'title':
      if (k === 'ArrowUp') G.menuRow = (G.menuRow + MENU_OPTS.length - 1) % MENU_OPTS.length;
      if (k === 'ArrowDown') G.menuRow = (G.menuRow + 1) % MENU_OPTS.length;
      if (k === 'Enter' || k === ' ') commitMenu();
      break;
    case 'difficulty':
      // Keys (§26.2): up = (level+4)%5, down = (level+1)%5
      if (k === 'ArrowUp') G.difficulty = (G.difficulty + 4) % 5;
      if (k === 'ArrowDown') G.difficulty = (G.difficulty + 1) % 5;
      if (k === 'Enter') G.screen = 'nation';
      if (k === 'Escape') G.screen = 'title';
      break;
    case 'nation':
      if (k === 'ArrowLeft' || k === 'ArrowUp') G.nation = (G.nation + 3) % 4;
      if (k === 'ArrowRight' || k === 'ArrowDown') G.nation = (G.nation + 1) % 4;
      if (k === 'Enter') { G.leader = DATA.nations[G.nation].leader; G.screen = 'name'; }
      if (k === 'Escape') G.screen = 'difficulty';
      break;
    case 'briefing':
    case 'cards':
    case 'king':
    case 'woodcut':
      if (k === 'Enter' || k === ' ') onClick(-1, -1);
      if (k === 'Escape' && G.screen === 'cards') G.screen = 'briefing';
      break;
    case 'report':
      if (k === 'Escape' || k === 'x' || /^F\d+$/.test(k)) G.screen = 'map';
      break;
    case 'options': {
      const n = G.options.rows.length;
      if (k === 'ArrowUp') G.options.row = (G.options.row + n - 1) % n;
      if (k === 'ArrowDown') G.options.row = (G.options.row + 1) % n;
      if (k === 'Enter' || k === ' ') optionsCommit();
      if (k === 'Escape' || k === 'x') { G.screen = 'map'; G.options = null; }
      break;
    }
    case 'trade': {
      const n = tradeRows().length;
      if (k === 'ArrowUp') G.trade.row = (G.trade.row + n - 1) % n;
      if (k === 'ArrowDown') G.trade.row = (G.trade.row + 1) % n;
      if (k === 'Enter' || k === ' ') tradeCommit();
      if (k === 'Escape' || k === 'x') { G.screen = 'map'; G.trade = null; }
      break;
    }
    case 'village': {
      const n = villageRowCount();
      if (k === 'ArrowUp') G.villageRow = (G.villageRow + n - 1) % n;
      if (k === 'ArrowDown') G.villageRow = (G.villageRow + 1) % n;
      if (k === 'Enter' || k === ' ') villageCommit();
      if (k === 'Escape' || k === 'x') { G.screen = 'map'; G.village = null; advance(); }
      break;
    }
    case 'pedia': {
      const n = pediaList().length;
      if (G.pediaMode === 'index') {
        if (k === 'ArrowUp') G.pediaSel = (G.pediaSel + n - 1) % n;
        if (k === 'ArrowDown') G.pediaSel = (G.pediaSel + 1) % n;
        if (k === 'ArrowLeft') G.pediaSel = Math.max(0, G.pediaSel - 22);
        if (k === 'ArrowRight') G.pediaSel = Math.min(n - 1, G.pediaSel + 22);
        if (k === 'Enter' || k === ' ') G.pediaMode = 'entry';
        if (k === 'Escape' || k === 'x') G.screen = 'map';
      } else {
        if (k === 'ArrowLeft' || k === 'ArrowUp') G.pediaSel = (G.pediaSel + n - 1) % n;
        if (k === 'ArrowRight' || k === 'ArrowDown') G.pediaSel = (G.pediaSel + 1) % n;
        if (k === 'Escape' || k === 'x') G.pediaMode = 'index';
      }
      break;
    }
    case 'colony': {
      if (G.colonyPopup) {
        const n = colonyPopupRows().length;
        if (k === 'ArrowUp') G.colonyPopupRow = (G.colonyPopupRow + n - 1) % n;
        if (k === 'ArrowDown') G.colonyPopupRow = (G.colonyPopupRow + 1) % n;
        if (k === 'Enter' || k === ' ') colonyPopupCommit();
        if (k === 'Escape') G.colonyPopup = null;
        break;
      }
      // §26.8 keys: 1/2/3 select the right-panel view, C opens the construction
      // menu, Enter the jobs menu for the selected colonist, ESC/x exits.
      if (k >= '1' && k <= '3') G.colonyView = +k - 1;
      if (k === 'c' || k === 'C') openBuildPicker();
      // B = rush-buy the construction target (@BUYME0/1); E = the Custom
      // House export picker (@CUSTOM); L = clear the selected colonist's
      // specialty (@LOBOTOMIZE).
      if (k === 'b' || k === 'B') rushBuy();
      if (k === 'e' || k === 'E') customHouseMenu();
      if (k === 'l' || k === 'L') {
        const cc = G.colonies[G.colony];
        const who = cc && cc.colonists[G.colonistSel];
        if (who && who.profession)
          askEvent('LOBOTOMIZE', { STRING0: who.profession }, (ch) => {
            if (ch === 0) who.profession = null;
          });
      }
      if (k === 'Enter') { G.colonyPopup = 'jobs'; G.colonyPopupRow = 0; }
      // Colonial authority: R renames, shift-A abandons (@ABANDON defaults to
      // the refusal, so a stray press cannot lose you a colony).
      if (k === 'r' || k === 'R') renameColony();
      if (k === 'A') abandonColony();
      if (k === 'Escape' || k === 'x') G.screen = 'map';
      break;
    }
    case 'europe': {
      if (G.euroMenu) {
        const n = euroMenuRows().length;
        if (k === 'ArrowUp') G.euroMenuRow = (G.euroMenuRow + n - 1) % n;
        if (k === 'ArrowDown') G.euroMenuRow = (G.euroMenuRow + 1) % n;
        if (k === 'Enter' || k === ' ') euroMenuCommit();
        if (k === 'Escape') G.euroMenu = null;
        break;
      }
      // §26.9 keys: arrows move the market cursor, L/= buy full, U/-/_ sell,
      // R/1 recruit, P/2 purchase, T/3 train, S sail, ESC/E/x exit.
      if (k === 'ArrowLeft') G.marketSel = (G.marketSel + 15) % 16;
      if (k === 'ArrowRight') G.marketSel = (G.marketSel + 1) % 16;
      if (k === 'l' || k === 'L' || k === '=') buyToShip(G.marketSel, 100);
      if (k === '+') buyToShip(G.marketSel, 10);
      if (k === 'u' || k === 'U' || k === '-' || k === '_') sellFromShip(G.marketSel);
      if (k === 'r' || k === 'R' || k === '1') openEuroMenu(0);
      if (k === 'p' || k === 'P' || k === '2') openEuroMenu(1);
      if (k === 't' || k === 'T' || k === '3') openEuroMenu(2);
      if (k === 's' || k === 'S') { const e = activeShip(); if (e) confirmSailAway(e); }
      if (k === 'k' || k === 'K') petitionLowerTaxes();
      if (k === 'Escape' || k === 'x' || k === 'e' || k === 'E') G.screen = 'map';
      break;
    }
    case 'map': {
      // An open pulldown owns the keyboard. Navigation walks the VISIBLE
      // rows, stepping over the group separators and never resting on one.
      if (G.openMenu >= 0) {
        const rows = menuVisibleRows(G.openMenu);
        const step = (dir) => {
          let i = G.menuSel;
          for (let n = 0; n < rows.length; n++) {
            i = (i + dir + rows.length) % rows.length;
            if (!rows[i].sep) { G.menuSel = i; return; }
          }
        };
        if (k === 'ArrowUp') step(-1);
        else if (k === 'ArrowDown') step(1);
        else if (k === 'ArrowLeft') openMenu((G.openMenu + DATA.menus.length - 1) % DATA.menus.length);
        else if (k === 'ArrowRight') openMenu((G.openMenu + 1) % DATA.menus.length);
        else if (k === 'Enter' || k === ' ') runMenuRow();
        else if (k === 'Escape') G.openMenu = -1;
        else if (k.length === 1) {
          // Accelerator: the "~" letter parsed from the MENU.TXT row.
          const K = k.toUpperCase();
          const src = DATA.menus[G.openMenu].rows.find(r => r.accel === K);
          const i = src ? rows.findIndex(r => !r.sep && r.label === src.label) : -1;
          if (i >= 0) { G.menuSel = i; runMenuRow(); }
        }
        break;
      }
      // Alt+letter opens that pulldown (§27.1).
      if (e.altKey && k.length === 1) {
        const i = DATA.menus.findIndex(m => m.accel === k.toUpperCase());
        if (i >= 0) { openMenu(i); e.preventDefault(); return; }
      }
      // F1-F10 report ladder, the whole @REPORTS menu: F1 is the Colonizopedia
      // TERRAIN page rather than an adviser (CLAUDE.md hard rule 7), F2-F10 are
      // the nine advisers, each of which reads live game state.
      if (/^F\d+$/.test(k)) {
        if (k === 'F1') { openPedia(2); e.preventDefault(); return; }
        if (k === 'F8' && woiLocked()) { showEvent('FOREIGNNOTAVAIL'); e.preventDefault(); return; }
        if (REPORTS[k]) { G.report = k; G.screen = 'report'; e.preventDefault(); return; }
        return;                              // F11/F12 are not the game's keys
      }
      // 8-way movement: arrows plus the numeric keypad diagonals.
      const DIR = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, -1],
                    ArrowDown: [0, 1], '7': [-1, -1], '9': [1, -1],
                    '1': [-1, 1], '3': [1, 1] };
      if (DIR[k]) { const [dx, dy] = DIR[k]; if (G.viewMode) centerOn(G.view.x + 7 + dx * 3, G.view.y + 6 + dy * 3); else moveSel(dx, dy); }
      switch (k) {
        case ' ': skipUnit(); break;
        case 'Tab': nextUnit(); break;
        case 'a': case 'A': activateUnit(); break;
        case 'w': case 'W': nextUnit(); break;
        case 'f': case 'F': setOrder(5); break;
        case 's': case 'S': setOrder(1); break;
        case 'b': case 'B': buildColony(); break;
        // The P/R keys take the same gated path as the ORDERS menu rows
        // (@ONLYPIO / @NOROAD / @NOPLOW). They used to bypass it through a
        // bare setOrder, which let a SHIP take a plow order and be demoted
        // to a Colonist when the work "finished" (found 2026-09-02 by the
        // input oracle after the war matrix went live).
        case 'p': case 'P': improveOrder(ORDER_CLEAR); break;
        case 'r': case 'R': improveOrder(ORDER_ROAD); break;
        case 'c': case 'C': centreView(); break;
        case 'e': case 'E': returnToEurope(); break;
        case 'l': case 'L': loadCargo(); break;
        case 'u': case 'U': unloadCargo(); break;
        case 'o': case 'O': dumpCargo(); break;
        case 'g': case 'G': beginGoTo(); break;
        case 't': case 'T': openTradeMenu('assign'); break;
        case 'v': case 'V': G.viewMode = true; break;
        case 'm': case 'M': G.viewMode = false; break;
        case 'h': case 'H': COMMANDS['Show Hidden Terrain'](); break;
        case 'z': case 'Z': setZoom(G.zoom - 1); break;
        case 'x': case 'X': setZoom(G.zoom + 1); break;
        case 'D': if (e.shiftKey) disbandUnit(); break;
      }
      break;
    }
  }
  if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', ' ', 'Tab'].includes(k)) e.preventDefault();
}

// ---------------------------------------------------------------- main loop
let ctx, screenCanvas, scale = 1, offX = 0, offY = 0;

function resize() {
  // Integer-scale only: this is pixel art, so a fractional scale would blur it.
  //
  // The debug column IS subtracted. The earlier trade -- keep the game at full
  // size and let the page scroll sideways -- does not survive contact: #stage
  // CENTRES an over-wide child, so the overflow splits both ways and the left
  // half goes behind the viewport edge, where `overflow-x:auto` cannot reach it
  // (it only scrolls right). Measured with the panel open: canvas left edge at
  // -135px at 1440x900, hiding logical x 0..33 -- the whole plaza colonist row,
  // which is exactly the region the colony-screen clicks needed. Port's own
  // choice (UNCITED); no DOS analogue for any of it.
  const availW = window.innerWidth - 60 - (debugOpen ? DEBUG_W : 0),
        availH = window.innerHeight - 90;
  scale = Math.max(1, Math.floor(Math.min(availW / W, availH / H)));
  const cv = document.getElementById('screen');
  cv.width = W * scale; cv.height = H * scale;
  cv.style.width = (W * scale) + 'px'; cv.style.height = (H * scale) + 'px';
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
}

// The engine's map screen has no status line -- the live DOS captures show
// only the unit panel in the sidebar -- so any message raised while the map is
// up is delivered as an ordinary notice popup instead. A message set on some
// other screen is dropped when the screen changes rather than leaking onto the
// map (the old status line showed exactly that leakage).
let _prevScreen = null;
function flushMapMsg() {
  if (G.screen !== _prevScreen) { G.msg = ''; _prevScreen = G.screen; }
  if (G.screen !== 'map' || !G.msg) return;
  notice(G.msg);
  G.msg = '';
}

function frame() {
  // A draw error must not kill the loop: rAF only continues if this callback
  // returns, so an uncaught throw froze the whole game (the F3 report did
  // exactly that). Log it once per distinct message and keep drawing.
  try { frameBody(); } catch (e) {
    if (e && e.message !== _frameErr) { _frameErr = e.message; console.error(e); }
    // A frameBody throw usually happens BEFORE the offscreen canvas reaches
    // the visible one, so the screen would freeze on the last good frame with
    // the error invisible in the console. Paint the message straight onto the
    // VISIBLE canvas so a player sees what broke instead of a dead game.
    try {
      const cv = document.getElementById('screen');
      const c2 = cv.getContext('2d');
      c2.fillStyle = 'rgba(120,0,0,0.92)';
      c2.fillRect(0, 0, cv.width, 34);
      c2.fillStyle = '#fff';
      c2.font = '12px monospace';
      c2.fillText('PORT ERROR (please report): ' + String(_frameErr).slice(0, 110), 6, 14);
      c2.fillText('The game keeps running underneath - press Escape, or reload.', 6, 28);
    } catch (e2) { /* the reporter must never throw */ }
  }
  requestAnimationFrame(frame);
}
// Input errors must not strand the input state (a stuck drag, a held button):
// report like a frame error, then reset the transient pointer state.
function guarded(fn) {
  return function (...args) {
    try { return fn.apply(this, args); } catch (e) {
      if (e && e.message !== _frameErr) { _frameErr = e.message; console.error(e); }
      G.drag = null; G.dragArm = null;
    }
  };
}
let _frameErr = null;
function frameBody() {
  G.blink = (G.tick % 32) < 20;
  G.tick += 1;
  G.wallClock = performance.now();
  flushMapMsg();
  // NO auto-dismiss: the prior "120-tick timeout" reading of func_004A80's
  // 0x78 is OVERTURNED by live evidence -- the census DOSBox popups sit on
  // screen through multi-second capture waits (census_turnevent_*), and 0x78
  // = 120 is the turn-popup TOP row the same frames measure. Every popup
  // waits for a key/click, one at a time (user-confirmed 2026-08-08).
  // A colonist armed on the down-edge lifts once the hold deadline passes, even
  // if the pointer is being held perfectly still -- so poll it here as well as
  // on move, the way the engine's per-frame dispatcher does.
  if (G.dragArm && PTR.down) onPointerMove(PTR.x, PTR.y);
  ctx.clearRect(0, 0, W, H);
  ({ title: drawTitle, difficulty: drawDifficulty, nation: drawNation,
     name: drawName, briefing: drawBriefing, cards: drawCards, hof: drawHof,
     king: drawKing, map: drawMap, woodcut: drawWoodcut,
     colony: drawColony, europe: drawEurope, pedia: drawPedia,
     report: drawReport, village: drawVillage,
     trade: drawTrade, options: drawOptions }[G.screen] || drawMap)(ctx);
  // The Combat Analysis panel and the event popups sit over whatever screen is
  // up when they fire; the panel is read first and dismissed first.
  if (G.combat) drawCombat(ctx);
  // drawMap paints its own dialog layer; every other screen gets it here so a
  // dialog opened off-map (the title screen's Load Game picker) still shows.
  if (G.screen !== 'map' && G.dialog) drawDialog(ctx);
  drawEvent(ctx);
  drawDragGhost(ctx);
  const cv = document.getElementById('screen');
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
  c2.clearRect(0, 0, cv.width, cv.height);
  c2.drawImage(screenCanvas, 0, 0, W * scale, H * scale);
  if (debugOpen && (_dbgTick++ % 10) === 0) dbgRender();
}

async function main() {
  await loadImages();
  for (const [k, m] of Object.entries(DATA.fonts)) {
    FONT[k] = new Font(m, {
      1: IMG[`FONT_${m.file}_L1`], 2: IMG[`FONT_${m.file}_L2`],
      3: IMG[`FONT_${m.file}_L3`],
    });
  }
  screenCanvas = document.createElement('canvas');
  screenCanvas.width = W; screenCanvas.height = H;
  ctx = screenCanvas.getContext('2d');
  ctx.imageSmoothingEnabled = false;
  resize();
  window.addEventListener('resize', resize);
  window.addEventListener('keydown', guarded(onKey));
  const cv = document.getElementById('screen');
  const toLogical = (ev) => {
    const r = cv.getBoundingClientRect();
    const cx = (ev.touches ? ev.touches[0].clientX : ev.clientX) - r.left;
    const cy = (ev.touches ? ev.touches[0].clientY : ev.clientY) - r.top;
    return [Math.floor(cx / scale), Math.floor(cy / scale)];
  };
  // The pointer trio sits ALONGSIDE the click path, not in place of it: every
  // click binding in onClick still works, and a drag is what the click event
  // cannot express. See the drag-and-drop section for the engine model.
  cv.addEventListener('pointerdown', guarded((ev) => {
    const [x, y] = toLogical(ev);
    PTR.down = true; PTR.right = ev.button === 2;
    PTR.x = PTR.downX = x; PTR.y = PTR.downY = y;
    PTR.moved = false;
    try { cv.setPointerCapture(ev.pointerId); } catch (_) { /* not all inputs */ }
    onPointerDown(x, y, PTR.right, ev.shiftKey);
  }));
  cv.addEventListener('pointermove', guarded((ev) => {
    const [x, y] = toLogical(ev);
    if (x === PTR.x && y === PTR.y) return;
    // One pixel counts as moved -- @0xD16F compares the poll-start snapshot
    // against the current position with no threshold at all.
    PTR.x = x; PTR.y = y;
    if (PTR.down) PTR.moved = true;
    onPointerMove(x, y);
  }));
  cv.addEventListener('pointerup', guarded((ev) => {
    const [x, y] = toLogical(ev);
    PTR.x = x; PTR.y = y;
    onPointerUp(x, y, PTR.right);
    PTR.down = false; PTR.right = false;
  }));
  cv.addEventListener('pointercancel', () => { PTR.down = false; cancelDrag(); });
  // A right press cancels a drag, so the browser menu must not eat it.
  cv.addEventListener('contextmenu', (ev) => ev.preventDefault());
  cv.addEventListener('click', guarded((ev) => {
    if (PTR.suppressClick) { PTR.suppressClick = false; return; }
    const [x, y] = toLogical(ev); onClick(x, y);
  }));
  cv.addEventListener('touchstart', (ev) => {
    const [x, y] = toLogical(ev); onClick(x, y); ev.preventDefault();
  }, { passive: false });
  dbgInit();
  dbgRender();
  document.getElementById('loading').style.display = 'none';
  requestAnimationFrame(frame);
}
main();

// ---------------------------------------------------------------- debug panel
// A live read-out of the whole simulation, refreshed ~6 times a second. It is a
// VIEW -- it never writes to G -- so it is safe to leave open while playing.
//
// Laid out as TABS of TABLES. Anything with many instances of the same shape --
// the sixteen market goods, the colonies, the units, the camps -- is a table
// with one row each, because a flat key/value list of that is unreadable. Only
// genuine scalars (the session, the Crown) stay as key/value pairs.
//
// The RAW tab still dumps every own key of every record, so nothing in the state
// can hide behind the tidier views: the tables are a summary layer over it, not
// a replacement for it.
let debugOpen = true, _dbgLast = '', _dbgTick = 0, dbgTab = 0;
const DEBUG_W = 430;   // must match #debug's flex-basis in the page shell

const dbgNum = (v) => (v === undefined || v === null) ? '--' : String(v);
const dbgList = (a) => (!a || !a.length) ? null : a.join(', ');
const dbgGood = (i) => (DATA.cargo[i] && DATA.cargo[i].name) || ('good ' + i);
const dbgOn = (v) => v ? 'yes' : 'no';
const dbgEsc = (s) => String(s).replace(/[&<>]/g,
  c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]));

function dbgVal(v) {
  if (v === null) return 'null';
  if (v === undefined) return '--';
  if (v instanceof Set) return `Set(${v.size})` + (v.size && v.size < 12 ? ' ' + [...v].join(', ') : '');
  if (Array.isArray(v)) {
    if (!v.length) return '[]';
    if (v.every(x => x === null || ['number', 'string', 'boolean'].includes(typeof x)))
      return v.join(', ');
    return `[${v.length}]`;
  }
  if (typeof v === 'object') {
    const s = JSON.stringify(v);
    return s.length > 200 ? s.slice(0, 200) + '…' : s;
  }
  if (typeof v === 'boolean') return dbgOn(v);
  return String(v);
}

// ---- block builders --------------------------------------------------------
const dbgH = (t) => `<div class="sub">${dbgEsc(t)}</div>`;
function dbgKV(rows) {
  return `<div class="kv">` + rows.map(([k, v]) =>
    `<div class="row"><span class="k">${dbgEsc(k)}</span>` +
    `<span class="v">${dbgEsc(v)}</span></div>`).join('') + `</div>`;
}
// `cols` is [{h, num}] and `rows` is an array of cell arrays. Wide tables get
// their own horizontal scroller so they can never widen the panel itself.
function dbgTable(cols, rows) {
  if (!rows.length) return `<div class="none">none</div>`;
  const head = cols.map(c => `<th${c.num ? ' class="n"' : ''}>${dbgEsc(c.h)}</th>`).join('');
  const body = rows.map(r => '<tr>' + r.map((cell, i) => {
    const cls = [cols[i] && cols[i].num ? 'n' : '', cell && cell.cls ? cell.cls : '']
      .filter(Boolean).join(' ');
    const txt = (cell && cell.t !== undefined) ? cell.t : cell;
    return `<td${cls ? ' class="' + cls + '"' : ''}>${dbgEsc(txt === undefined || txt === null ? '' : txt)}</td>`;
  }).join('') + '</tr>').join('');
  return `<div class="tw"><table><thead><tr>${head}</tr></thead><tbody>${body}</tbody></table></div>`;
}
const hot = (t) => ({ t, cls: 'hot' });      // draws attention (at a limit, etc.)
const dim = (t) => ({ t, cls: 'dim' });

// ---- tabs ------------------------------------------------------------------
const DBG_TABS = [];
function dbgAddTab(name, build) { DBG_TABS.push({ name, build }); }

dbgAddTab('Session', () => {
  let h = dbgKV([
    ['screen', G.screen + (G.report ? '  report ' + G.report : '')],
    ['turn', `${G.turn}   ${DATA.seasons[G.season]} ${G.year}`],
    ['difficulty', `${G.difficulty}  ${DATA.difficulty[G.difficulty]}`],
    ['nation', `${G.nation}  ${DATA.nations[G.nation].country}`],
    ['leader', G.leader || '--'],
    ['new land', G.newLand || '--'],
    ['map', typeof MAP !== 'undefined' ? `${MAP.w} × ${MAP.h}` : '--'],
    ['viewport', `(${G.view.x},${G.view.y})  zoom ${G.zoom}`],
    ['mode', G.viewMode ? 'view pieces' : 'move pieces'],
    ['selected unit', dbgNum(G.sel)],
    ['tick / blink', `${G.tick}  ${G.blink ? 'on' : 'off'}`],
    ['map seed', dbgNum(G.mapSeed)],
    ['plot seed base', dbgNum(G.plotSeedBase)],
    ['cycle phase', G.cyclePhase === null ? 'free-running' : String(G.cyclePhase)],
    ['dialog', G.dialog ? dbgVal(G.dialog) : '--'],
    ['message', G.msg || '--'],
  ]);
  h += dbgH('Player');
  h += dbgKV([
    ['gold', `${G.gold}$`],
    ['crosses', `${G.crosses} / ${typeof immigrationThreshold === 'function'
                                  ? immigrationThreshold() : '?'}`],
    ['bells', `${G.bells} / ${typeof fatherCost === 'function' ? fatherCost() : '?'}` +
              `   (+${G.bellsPerTurn}/turn)`],
    ['lifetime bells', dbgNum(G.bellsTotal)],
    ['next father', G.fatherInProgress || '--'],
    ['fathers owned', dbgList(G.fathersOwned) || 'none'],
    ['national SoL', typeof nationalSoL === 'function' ? nationalSoL() + '%' : '--'],
    ['colonies / units', `${G.colonies.length} / ${G.units.length}`],
    ['villages razed', dbgNum(G.razed)],
    ['fountain / cibola', `${dbgOn(G.foundFountain)} / ${dbgOn(G.foundCibola)}`],
    ['rumours', `${(G.rumoursDone || new Set()).size} done, floor ${G.rumourFloor}`],
  ]);
  h += dbgH('Options');
  h += dbgKV([
    ['game', '0x' + G.gameOptions.toString(16).toUpperCase().padStart(4, '0')],
    ['colony', '0x' + G.colonyOptions.toString(16).toUpperCase().padStart(4, '0')],
    ['sound', '0x' + G.soundOptions.toString(16).toUpperCase().padStart(4, '0')],
    ['combat analysis', G.combat ? 'PANEL OPEN' : dbgOn(G.combatAnalysis)],
    ['events queued', String((G.eventQueue || []).length)],
    ['tune', dbgNum(G.tune)],
  ]);
  return h;
});

dbgAddTab('Crown', () => {
  const iv = typeof taxInterval === 'function' ? taxInterval() : null;
  const next = iv ? Math.ceil((G.turn + 1) / iv) * iv : null;
  let h = dbgKV([
    ['tax rate', `${G.tax}%   (cap ${typeof TAX_CAP !== 'undefined' ? TAX_CAP : '?'})`],
    ['demand interval', iv ? `every ${iv} turns` : '--'],
    ['next demand', next ? `turn ${next}  (in ${next - G.turn})` : '--'],
    ['raise if it fires', typeof taxRaise === 'function' ? `+${taxRaise()}%` : '--'],
    ['crown has taken', `${G.kingsFund}$`],
    ['royal fund', `${G.royalFund}$`],
    ['boycotted', dbgList((G.boycotts || []).map(dbgGood)) || 'none'],
    ['declared', G.declared ? `yes, ${G.declaredYear}` : 'no'],
    ['war flags', '0x' + (G.flags || 0).toString(16).toUpperCase()],
    ['lost the war', dbgOn(G.lostWar)],
    ['upkeep unpaid', dbgOn(G.upkeepUnpaid)],
    ['building upkeep', typeof totalUpkeep === 'function' ? `${totalUpkeep()}$/turn` : '--'],
    ['mercenaries seen', dbgOn(G.mercSeen)],
    ['intervention watch', dbgOn(G.interventionWatch)],
    ['artillery bought', dbgNum(G.artilleryBought)],
  ]);
  h += dbgH('Royal Expeditionary Force');
  const ref = Object.entries(G.ref || {});
  h += ref.length ? dbgTable([{ h: 'arm' }, { h: 'count', num: 1 }],
                             ref.map(([k, v]) => [k, String(v)]))
                  : `<div class="none">not raised</div>`;
  h += dbgH(`Landed REF units  (${(G.refUnits || []).length})`);
  h += dbgTable([{ h: '#', num: 1 }, { h: 'type' }, { h: 'pos' }],
    (G.refUnits || []).map((u, i) => [String(i), u.type, `${u.x},${u.y}`]));
  return h;
});

dbgAddTab('Market', () => {
  // Everything that governs European demand for each good. Split across two
  // tables so both fit the panel without a sideways scroll: what a good is
  // worth right now, then what is moving its price.
  const m = DATA.cargo.map((c, i) => {
    const bid = bidPrice(i);
    return {
      c, i, bid,
      ask: typeof askPrice === 'function' ? askPrice(i) : 0,
      acc: (G.accum && G.accum[i]) || 0,
      atFloor: bid <= c.low, atCeil: bid >= c.high,
      boycott: (G.boycotts || []).includes(i),
      held: G.colonies.reduce((n, col) => n + (col.stock[i] || 0), 0),
    };
  });
  const label = (r) => r.boycott ? hot(r.c.name + ' ✗') : r.c.name;

  let h = dbgH('Price');
  h += dbgTable([{ h: 'good' }, { h: 'bid', num: 1 }, { h: 'ask', num: 1 },
                 { h: 'low', num: 1 }, { h: 'high', num: 1 }, { h: 'held', num: 1 }],
    m.map(r => [label(r), String(r.bid), String(r.ask),
                r.atFloor ? hot(r.c.low) : dim(r.c.low),
                r.atCeil ? hot(r.c.high) : dim(r.c.high),
                r.held ? String(r.held) : dim('0')]));

  // "up in" / "dn in" are how much further the traffic accumulator has to move
  // before the price actually steps -- the number that tells you whether a sale
  // will shift the price or just nudge it.
  h += dbgH('Movement');
  h += dbgTable([{ h: 'good' }, { h: 'traffic', num: 1 }, { h: 'up in', num: 1 },
                 { h: 'dn in', num: 1 }, { h: 'step', num: 1 },
                 { h: 'drift', num: 1 }, { h: 'vol', num: 1 }],
    m.map(r => [label(r), String(r.acc),
                r.atCeil ? hot('ceil') : String(-100 * r.c.rise - r.acc),
                r.atFloor ? hot('floor') : String(100 * r.c.fall - r.acc),
                dim(`${100 * r.c.rise}/${100 * r.c.fall}`),
                dim(r.c.attrition), dim('<<' + r.c.volatility)]));
  h += `<div class="note">bid/ask spread is burden+1 · traffic steps the price at ` +
       `−100·rise (up) and +100·fall (down) · drift is added every turn · ` +
       `a trade moves it by qty&lt;&lt;vol</div>`;
  return h;
});

dbgAddTab('Colonies', () => {
  if (!G.colonies.length) return `<div class="none">none founded</div>`;
  const prod = G.colonies.map(c => { try { return colonyProduce(c); } catch (e) { return null; } });
  let h = dbgTable([
    { h: '' }, { h: 'colony' }, { h: 'pos' }, { h: 'pop', num: 1 },
    { h: 'SoL', num: 1 }, { h: 'ham', num: 1 }, { h: 'food', num: 1 },
    { h: 'bell', num: 1 }, { h: 'crs', num: 1 }, { h: 'building' },
  ], G.colonies.map((c, i) => {
    const r = prod[i];
    return [
      i === G.colony ? '▸' : '',
      c.name, `${c.x},${c.y}`, String(c.colonists.length), c.sol + '%',
      String(c.hammers),
      r ? (r.netFood < 0 ? hot(String(r.netFood)) : String(r.netFood)) : '?',
      r ? String(r.tally[BELLS]) : '?',
      r ? String(r.tally[CROSSES]) : '?',
      c.building || dim('--'),
    ];
  }));
  // Then the selected colony in full.
  const c = G.colonies[G.colony], r = prod[G.colony];
  if (c) {
    h += dbgH(`${c.name} — stores`);
    h += dbgTable([{ h: 'good' }, { h: 'held', num: 1 }, { h: 'made', num: 1 },
                   { h: 'used', num: 1 }, { h: 'net', num: 1 }],
      DATA.cargo.map((g, i) => [g.name,
        c.stock[i] ? String(c.stock[i]) : dim('0'),
        r && r.gross[i] ? String(r.gross[i]) : dim('0'),
        r && r.consumed[i] ? String(r.consumed[i]) : dim('0'),
        r ? (r.out[i] < 0 ? hot(String(r.out[i])) : String(r.out[i])) : '?',
      ]));
    h += dbgH(`${c.name} — colonists  (${c.colonists.length})`);
    h += dbgTable([{ h: '#', num: 1 }, { h: 'type' }, { h: 'profession' },
                   { h: 'job' }, { h: 'cell' }],
      c.colonists.map((p, k) => [String(k), p.type, p.profession || dim('--'),
        p.job || dim('idle'), p.cell ? `${p.cell[0]},${p.cell[1]}` : dim('plaza')]));
    h += dbgH(`${c.name} — buildings  (${c.buildings.length})`);
    h += dbgTable([{ h: 'building' }, { h: 'upkeep', num: 1 }],
      c.buildings.map(b => {
        const d = DATA.buildings.find(x => x.name === b);
        return [b, d ? String(d.upkeep) : '?'];
      }));
    if (typeof buildOptions === 'function') {
      h += dbgH('can build');
      h += dbgTable([{ h: 'building' }, { h: 'hammers', num: 1 }, { h: 'tools', num: 1 }],
        buildOptions(c).map(b => [b.name, String(b.cost), String(b.tools_x10 * 10)]));
    }
    if (r) {
      h += dbgH('this turn');
      h += dbgKV([
        ['centre tile', `${r.centre} food`],
        ['food', `+${r.gross[GOOD.FOOD]} − ${r.eaten} eaten = ${r.netFood}`],
        ['hammers', dbgNum(r.tally[HAMMERS])],
        ['bells / crosses', `${r.tally[BELLS]} / ${r.tally[CROSSES]}`],
        ['teaching', dbgNum(r.tally[TEACHING])],
        ['upkeep', typeof colonyUpkeep === 'function' ? colonyUpkeep(c) + '$' : '--'],
      ]);
    }
  }
  return h;
});

dbgAddTab('Rivals', () => {
  if (!G.rivals || !G.rivals.length) return `<div class="none">none</div>`;
  let h = dbgTable([
    { h: 'power' }, { h: 'met' }, { h: 'att', num: 1 }, { h: 'gold', num: 1 },
    { h: 'col', num: 1 }, { h: 'unit', num: 1 }, { h: 'war' }, { h: 'treaty' },
  ], G.rivals.map(r => {
    const n = DATA.nations[r.nation];
    const war = G.warMatrix && G.warMatrix[r.nation];
    return [n.country, r.met ? 'yes' : dim('no'), dbgNum(r.attitude), dbgNum(r.gold),
            String((r.colonies || []).length), String((r.units || []).length),
            war ? hot('WAR') : dim('no'),
            (G.treatyMatrix && G.treatyMatrix[r.nation]) ? 'yes' : dim('no')];
  }));
  for (const r of G.rivals) {
    const n = DATA.nations[r.nation];
    if ((r.colonies || []).length) {
      h += dbgH(`${n.country} — colonies`);
      h += dbgTable([{ h: 'name' }, { h: 'pos' }],
        r.colonies.map(c => [c.name || '?', `${c.x},${c.y}`]));
    }
    if ((r.units || []).length) {
      h += dbgH(`${n.country} — units`);
      h += dbgTable([{ h: '#', num: 1 }, { h: 'type' }, { h: 'pos' }],
        r.units.map((u, k) => [String(k), u.type, `${u.x},${u.y}`]));
    }
  }
  if (G.parley) { h += dbgH('parley'); h += dbgKV(Object.entries(G.parley).map(([k, v]) => [k, dbgVal(v)])); }
  return h;
});

dbgAddTab('Tribes', () => {
  if (!G.tribes || !G.tribes.length) return `<div class="none">none</div>`;
  let h = dbgTable([
    { h: 'tribe' }, { h: 'lvl', num: 1 }, { h: 'tension', num: 1 },
    { h: 'camps', num: 1 }, { h: 'braves', num: 1 },
  ], G.tribes.map((t, ti) => [
    t.name, dbgNum(t.level),
    t.tension >= 50 ? hot(dbgNum(t.tension)) : dbgNum(t.tension),
    String(G.villages.filter(v => v.tribe === ti).length),
    String(G.natives.filter(u => u.tribe === ti).length),
  ]));
  h += dbgH(`Settlements  (${G.villages.length})`);
  h += dbgTable([
    { h: 'tribe' }, { h: 'pos' }, { h: 'cap' }, { h: 'mission' }, { h: 'taught' },
  ], G.villages.map(v => [
    (G.tribes[v.tribe] || {}).name || '?', `${v.x},${v.y}`,
    v.capital ? 'yes' : dim('--'),
    v.mission ? DATA.nations[v.mission.power].abbrev + (v.mission.expert ? '+' : '') : dim('--'),
    v.taught ? 'yes' : dim('--'),
  ]));
  h += dbgH(`Braves on the map  (${(G.natives || []).length})`);
  h += dbgTable([{ h: '#', num: 1 }, { h: 'type' }, { h: 'pos' }, { h: 'tribe' }],
    (G.natives || []).map((u, i) => [String(i), u.type, `${u.x},${u.y}`,
      (G.tribes[u.tribe] || {}).name || '?']));
  return h;
});

dbgAddTab('Units', () => {
  let h = dbgTable([
    { h: '' }, { h: '#', num: 1 }, { h: 'type' }, { h: 'pos' },
    { h: 'moves', num: 1 }, { h: 'orders' }, { h: 'carrying' },
  ], G.units.map((u, i) => [
    i === G.sel ? '▸' : '', String(i), u.type, `${u.x},${u.y}`,
    `${u.movesLeft}/${u.moves}`,
    (DATA.orders[u.orders] && DATA.orders[u.orders].name) || String(u.orders),
    [(u.cargo || []).map(entryName).join('+'),
     (u.hold || []).map(x => dbgGood(x.good) + ' ' + x.qty).join('+'),
     u.tools ? u.tools + ' tools' : ''].filter(Boolean).join('  ') || dim('--'),
  ]));
  return h;
});

dbgAddTab('Europe', () => {
  let h = dbgH(`Ships  (${G.europe.length})`);
  h += dbgTable([
    { h: '' }, { h: '#', num: 1 }, { h: 'type' }, { h: 'state' },
    { h: 'turns', num: 1 }, { h: 'hold' },
  ], G.europe.map((e, k) => [
    k === G.euroShip ? '▸' : '', String(k), e.type, e.state,
    e.turns !== undefined ? String(e.turns) : dim('--'),
    (e.hold || []).map(x => dbgGood(x.good) + ' ' + x.qty).join('+') || dim('empty'),
  ]));
  h += dbgH(`On the dock  (${(G.dockUnits || []).length})`);
  h += dbgTable([{ h: '#', num: 1 }, { h: 'unit' }],
    (G.dockUnits || []).map((n, k) => [String(k),
      entryName(n) + (entryType(n) !== entryName(n) ? ` (${entryType(n)})` : '')]));
  h += dbgH('Recruit slots');
  h += dbgTable([{ h: 'slot', num: 1 }, { h: 'candidate' }, { h: 'passage', num: 1 }],
    (G.dock || []).map((d, k) => [String(k), d ? (d.name || dbgVal(d)) : dim('empty'),
      d && d.band !== undefined && DATA.classes[d.band]
        ? String(DATA.classes[d.band].cost) : dim('--')]));
  if (G.routes && G.routes.length) {
    h += dbgH(`Trade routes  (${G.routes.length})`);
    h += dbgTable([{ h: '#', num: 1 }, { h: 'stops' }],
      G.routes.map((r, k) => [String(k),
        (r.stops || []).map(s => G.colonies[s] && G.colonies[s].name).join(' → ')]));
  }
  return h;
});

// ---- raw: every field of every record, nothing summarised ------------------
function dbgFieldRows(obj, skip) {
  return Object.keys(obj || {})
    .filter(k => !skip || !skip.includes(k))
    .map(k => [k, dbgVal(obj[k])]);
}
dbgAddTab('Raw', () => {
  // Which G keys the tabs above have presented in some form. Everything else
  // lands in "unclaimed" so new state cannot slip through unseen.
  const claimed = new Set(['screen', 'report', 'turn', 'season', 'year', 'difficulty',
    'nation', 'leader', 'newLand', 'view', 'zoom', 'viewMode', 'sel', 'tick', 'blink',
    'mapSeed', 'plotSeedBase', 'cyclePhase', 'cycleT0', 'dialog', 'msg', 'gold',
    'crosses', 'bells', 'bellsPerTurn', 'bellsTotal', 'fatherInProgress',
    'fathersOwned', 'colonies', 'units', 'razed', 'foundFountain', 'foundCibola',
    'rumoursDone', 'rumourFloor', 'gameOptions', 'colonyOptions', 'soundOptions',
    'combat', 'combatAnalysis', 'eventQueue', 'tune', 'tax', 'kingsFund',
    'royalFund', 'boycotts', 'declared', 'declaredYear', 'flags', 'lostWar',
    'upkeepUnpaid', 'mercSeen', 'interventionWatch', 'artilleryBought', 'ref',
    'refUnits', 'market', 'accum', 'colony', 'rivals', 'warMatrix', 'treatyMatrix',
    'rivalWars',
    'parley', 'tribes', 'villages', 'natives', 'europe', 'dock', 'dockUnits',
    'euroShip', 'routes', 'marketSel', 'menuRow', 'briefPage', 'card', 'woodcut',
    'landHo', 'colonyView', 'colonyPopup', 'colonyPopupRow', 'colonistSel',
    'colonyShipSel', 'colonyNumbers',
    'pediaCat', 'pediaSel', 'pediaMode', 'euroRow', 'euroMenu', 'euroMenuRow',
    'euroMsg', 'openMenu', 'menuSel', 'showHidden', 'f6View', 'options',
    'metAnyone', 'attitude', 'parleyLock', 'parleyRow', 'trade', 'village',
    'villageVisitor', 'villageRow', 'villageMode', 'raidSeen', 'goTo', 'retired',
    'succession']);
  let h = dbgH('Unclaimed G keys');
  const un = Object.keys(G).filter(k => !claimed.has(k)).map(k => [k, dbgVal(G[k])]);
  h += un.length ? dbgKV(un) : `<div class="none">every key is covered by a tab</div>`;
  h += dbgH('G scalars');
  h += dbgKV(Object.keys(G).filter(k => {
    const v = G[k];
    return v === null || ['number', 'string', 'boolean'].includes(typeof v);
  }).map(k => [k, dbgVal(G[k])]));
  G.colonies.forEach((c, i) => {
    h += dbgH(`colony ${i}: ${c.name}`);
    h += dbgKV(dbgFieldRows(c));
    c.colonists.forEach((p, k) => {
      h += dbgH(`  colonist ${k}`);
      h += dbgKV(dbgFieldRows(p));
    });
  });
  (G.rivals || []).forEach((r, i) => {
    h += dbgH(`rival ${i}: ${DATA.nations[r.nation].country}`);
    h += dbgKV(dbgFieldRows(r));
  });
  (G.tribes || []).forEach((t, i) => {
    h += dbgH(`tribe ${i}: ${t.name}`);
    h += dbgKV(dbgFieldRows(t));
  });
  (G.villages || []).forEach((v, i) => {
    h += dbgH(`village ${i}`);
    h += dbgKV(dbgFieldRows(v));
  });
  G.units.forEach((u, i) => {
    h += dbgH(`unit ${i}: ${u.type}`);
    h += dbgKV(dbgFieldRows(u));
  });
  G.europe.forEach((e, i) => {
    h += dbgH(`europe ${i}: ${e.type}`);
    h += dbgKV(dbgFieldRows(e));
  });
  return h;
});

// ---- render ----------------------------------------------------------------
function dbgRender() {
  const tabs = DBG_TABS.map((t, i) =>
    `<button class="tab${i === dbgTab ? ' on' : ''}" data-t="${i}">${dbgEsc(t.name)}</button>`).join('');
  let body;
  try { body = DBG_TABS[dbgTab].build(); }
  catch (e) { body = `<div class="none">error: ${dbgEsc(e.message || e)}</div>`; }
  const html = `<nav id="dbgtabs">${tabs}</nav><div id="dbgpane">${body}</div>`;
  if (html === _dbgLast) return;
  _dbgLast = html;
  const host = document.getElementById('dbgbody');
  if (!host) return;
  const pane = host.querySelector('#dbgpane');
  const scroll = pane ? pane.scrollTop : 0;
  host.innerHTML = html;
  const np = host.querySelector('#dbgpane');
  if (np) np.scrollTop = scroll;
}

function dbgToggle(on) {
  debugOpen = (on === undefined) ? !debugOpen : on;
  const el = document.getElementById('debug');
  if (el) el.classList.toggle('hidden', !debugOpen);
  resize();
}

function dbgInit() {
  const host = document.getElementById('dbgbody');
  if (host) host.addEventListener('click', (ev) => {
    const t = ev.target.closest('.tab');
    if (t) { dbgTab = Number(t.dataset.t); _dbgLast = ''; dbgRender(); }
  });
  const x = document.getElementById('dbgclose');
  if (x) x.addEventListener('click', () => dbgToggle(false));
}
