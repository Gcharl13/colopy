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
  // magenta placeholder (WOODPANL and the LEVN cards leave 0xFC-0xFE unset)
  // from the picker palette, which carries the documented UI ink triplet.
  const out = base.map((c, i) => isPlaceholder(c) ? uiPal[i] : c);
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
  gauge(ctx, frame, count, sub, count, x, y, span, 0, 0);
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

function drawCountRow(ctx, cells, x0, y, span, gap0) {
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
function detailFrame(mx, my, v) {
  if (!G.mapSeed) return -1;                  // word [0x190] == 0 disables @0x60A9
  const forest = forestConnects(v) || isScrub(v) ? 1 : 0;
  const q = (mx & 3) * 4 + (my & 3);
  const h = ((my >> 2) * 3 + (mx >> 2) + (G.mapSeed & 0xF) - forest) & 0xF;
  if (h !== q && (h ^ 0xA) !== q) return -1;
  const d = DTAB[detailClass(v)];
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
  europe: [],             // ships in port / on the high seas
  market: [],             // per-good bid price
  euroRow: 0,             // recruit-menu row
  colonyView: 2,          // right-panel mode: buildings / units / production
  colonyPopup: null,      // 'build' | 'jobs'
  colonyPopupRow: 0,
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
  G.kingsFund = 0; G.euroMenu = null; G.euroShip = 0; G.euroMsg = '';
  G.dockUnits = []; G.artilleryBought = 0; G.crosses = 0;
  G.fathersOwned = []; G.bells = 0; G.bellsPerTurn = 0;
  G.fatherInProgress = null; G.declared = false; G.boycotts = [];
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
function layoutDialog(d) {
  // Every measured line carries the +10 body margin (`add ax,0x0A`
  // @0x06CCE3); @width is a FLOOR under that, and 190 in practice.
  let cw = d.width;
  for (const l of d.body.concat(d.tail))
    cw = Math.max(cw, FONT.tiny.width(l.replace(/[{}]/g, '')) + 10);
  const w = cw + 6;
  const textH = d.body.length * 6;
  const rows = d.opts ? d.opts.length * 8 : 11;   // entry field: label + box
  const h = 6 + textH + 3 + rows + 3;
  // The engine's screen clamps: right past 320 shifts left, bottom past 200
  // shifts up (@0x06D563/@0x06D571); a negative origin floors at 0.
  let x = Math.round(160 - w / 2), y = Math.round(100 - h / 2);
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
function spanText(ctx, line, x, y, base, hi) {
  for (const part of line.split(/(\{[^}]*\})/)) {
    if (!part) continue;
    x = FONT.tiny.draw(ctx, part.replace(/[{}]/g, ''),
                       x, y, lut(part.startsWith('{') ? hi : base));
  }
  return x;
}
function drawDialog(ctx) {
  const d = G.dialog;
  if (!d) return;
  const b = layoutDialog(d);
  const ik = dialogInks();
  if (d.speaker) drawSpeakerSheet(ctx, d.speaker);
  plaque(ctx, b.x, b.y, b.w, b.h, G.screen === 'title' ? 'OPENTILE' : 'WOODTILE');
  d.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * 6, ik.base, ik.hi));
  const seed = b.y + 6 + b.textH + 3;
  if (d.opts) {
    d.opts.forEach((o, k) => {
      const oy = seed + k * 8;
      // Selection is the +0x40 band ONLY -- the hilite ink is gated on the
      // {brace} flag (func_06C346 @0x06C365), never on the row being
      // selected, so every row's text runs through the same span painter.
      if (k === d.sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 4, oy, b.w - 8, 7); }
      spanText(ctx, o, b.x + 9, oy + 1, ik.base, ik.hi);
    });
  } else {
    // Entry popup (@LANDHO): the tail line is the field label, the box follows.
    const label = d.tail[0] || '';
    spanText(ctx, label, b.x + 5, seed + 2, ik.base, ik.hi);
    const fx = b.x + 5 + FONT.tiny.width(label.replace(/[{}]/g, '')) + 4;
    hollowRect(ctx, fx, seed, b.x + b.w - 5 - fx, 11, ik.base);
    const caret = (Math.floor(G.tick / 24) % 2) ? '_' : '';
    FONT.tiny.draw(ctx, d.entry + caret, fx + 3, seed + 3, lut(ik.hi));
  }
}
function openDialog(key, onDone, prefill) {
  const t = DATA.dialogs[key];
  // A numeric @default names the highlighted option row; a text @default
  // prefills an entry field; no @default at all is an entry field with no
  // prefill (GAME.TXT @COLONY carries no directives).
  const numeric = typeof t.default === 'string' && /^\d+$/.test(t.default);
  G.dialog = {
    body: t.body, tail: t.tail, width: t.width, onDone,
    opts: numeric ? t.tail : null,
    // @default names the highlighted row ONE-BASED: @ABANDON's `@default=2`
    // over two rows is "Never! That would be folly." -- the engine highlights
    // the cautious answer. @LANDFALL's `@default=1` is "Stay With Ships" for
    // the same reason. (The port read it as a 0-based index until 2026-08-05.)
    sel: numeric ? Math.max(0, Math.min(t.tail.length - 1, +t.default - 1)) : 0,
    entry: numeric ? undefined : (prefill !== undefined ? prefill : (t.default || '')),
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
    else if (k === 'Backspace') d.entry = d.entry.slice(0, -1);
    else if (k.length === 1 && d.entry.length < 23) d.entry += k;
  }
}
function dialogClick(mx, my) {
  const d = G.dialog, b = layoutDialog(d);
  if (!d.opts) { closeDialog(d.entry); return; }
  const seed = b.y + 6 + b.textH + 3;
  for (let k = 0; k < d.opts.length; k++) {
    if (hit(mx, my, { x: b.x + 4, y: seed + k * 8, w: b.w - 8, h: 8 })) { closeDialog(k); return; }
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
    // offer's mechanical effect is likewise unread: accepting records
    // nothing beyond the flag, and that omission is flagged here.
    const count = G.villages.filter(w => w.tribe === v.tribe).length;
    askEvent('INDIANWELCOME', {
      STRING0: t.name, NUMBER0: count,
      STRING1: `${DATA.levelname[t.level] || 'Camp'}s`,
    }, (choice) => { if (choice === 0) t.treaty = true; });
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
// its fog path (§6.11), and the prime-resource detail band. Not implemented:
// roads as a terrain band (§6.8 — the loader discards the feature plane anyway;
// player-built roads come from drawImprovements instead).

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

function drawTile(ctx, mx, my, px, py) {
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
    const df = detailFrame(mx, my, v);
    if (df >= 0) sheetFrame(ctx, 'PHYS0', df, px, py);
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
// A plowed field has no dedicated frame anywhere in PHYS0, so the port marks it
// with furrow dots in the ploughed-earth tone rather than borrowing a sprite
// that means something else. Flagged in docs/UI_AUDIT_TRACKER.md.
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
    for (let k = 0; k < 4; k++) ctx.fillRect(px + 3 + k * 3, py + 12, 2, 1);
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
    if (G.zoom === 0) FONT.tiny.center(ctx, c.name, px + TILE / 2, py + TILE, lut(0x0F), ink(0));
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
  for (const n of G.natives) {
    const tx = n.x - G.view.x, ty = n.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    if (!isSeen(n.x, n.y)) continue;
    const px = ox + tx * TILE, py = oy + ty * TILE;
    nationPlate(tgt, px, py, ownerColour(n), n.orders);
    const [fw, fh] = frameSize('ICONS', n.icon);
    sheetFrame(tgt, 'ICONS', n.icon, px + TILE - fw, py + TILE - fh);
  }

  // Rival powers: their colonies and units, in their own @COUNTRY colours.
  for (const r of G.rivals) {
    for (const rc of r.colonies) {
      const tx = rc.x - G.view.x, ty = rc.y - G.view.y;
      if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
      if (!isSeen(rc.x, rc.y)) continue;
      drawSettlement(tgt, ox + tx * TILE, oy + ty * TILE, rc.level, rc.nation, 0);
    }
    for (const ru of r.units) {
      const tx = ru.x - G.view.x, ty = ru.y - G.view.y;
      if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
      if (!isSeen(ru.x, ru.y)) continue;
      const px = ox + tx * TILE, py = oy + ty * TILE;
      nationPlate(tgt, px, py, ownerColour(ru), ru.orders);
      const [fw, fh] = frameSize('ICONS', ru.icon);
      sheetFrame(tgt, 'ICONS', ru.icon, px + TILE - fw, py + TILE - fh);
    }
  }

  // The King's Royal Expeditionary Force. It is not one of the four European
  // powers -- the Crown becomes its own power at the war transition -- so it
  // wears its own plate colour rather than a @COUNTRY one.
  for (const ru of G.refUnits) {
    const tx = ru.x - G.view.x, ty = ru.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= cols || ty >= rows) continue;
    const px = ox + tx * TILE, py = oy + ty * TILE;
    nationPlate(tgt, px, py, KING_COLOUR, ru.orders);
    const [fw, fh] = frameSize('ICONS', ru.icon);
    sheetFrame(tgt, 'ICONS', ru.icon, px + TILE - fw, py + TILE - fh);
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
function nationPlate(ctx, x, y, colourIdx, orders) {
  ctx.fillStyle = ink(0); ctx.fillRect(x, y, 8, 9);
  ctx.fillStyle = ink(colourIdx); ctx.fillRect(x + 1, y + 1, 6, 7);
  const key = (DATA.orders[orders] || DATA.orders[0]).key;
  FONT.tiny.center(ctx, key, x + 4, y + 2, [ink(0), ink(0), ink(0)]);
}
function drawUnit(ctx, u, px, py) {
  // The active unit blinks: the engine flashes the unit graphic itself on and
  // off so the tile beneath shows through. There is no selection outline.
  if (G.units[G.sel] === u && !G.blink) return;
  nationPlate(ctx, px, py, ownerColour(u), u.orders);
  const [fw, fh] = frameSize('ICONS', u.icon);
  sheetFrame(ctx, 'ICONS', u.icon, px + TILE - fw, py + TILE - fh);
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
// The pulldown itself: rows from MENU.TXT, the "~" accelerator letter picked
// out in gold, greyed rows dimmed. Width fits the longest label.
function pulldownBox(mi) {
  const m = DATA.menus[mi];
  let w = 0;
  for (const r of m.rows) w = Math.max(w, FONT.tiny.width(r.label));
  w += 16;
  const x = Math.min(BAR_TITLES[mi][1] - 2, W - w - 2);
  return { x, y: 8, w, h: m.rows.length * 8 + 4 };
}
function drawPulldown(ctx) {
  const m = DATA.menus[G.openMenu], b = pulldownBox(G.openMenu);
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  m.rows.forEach((r, k) => {
    const y = b.y + 2 + k * 8;
    const sel = k === G.menuSel;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 2, y, b.w - 4, 8); }
    const dim = r.disabled || !COMMANDS[r.label];
    const base = dim ? 0x2F : (sel ? 0xFC : 0xFE);
    // Draw the accelerator letter in gold where the row is live.
    const ai = r.accel ? r.label.toUpperCase().indexOf(r.accel) : -1;
    let x = b.x + 6;
    if (ai < 0 || dim) FONT.tiny.draw(ctx, r.label, x, y + 1, lut(base));
    else {
      x = FONT.tiny.draw(ctx, r.label.slice(0, ai), x, y + 1, lut(base));
      x = FONT.tiny.draw(ctx, r.label[ai], x, y + 1, lut(0x0E));
      FONT.tiny.draw(ctx, r.label.slice(ai + 1), x, y + 1, lut(base));
    }
  });
}
function openMenu(mi) { G.openMenu = mi; G.menuSel = 0; }
function runMenuRow() {
  const m = DATA.menus[G.openMenu];
  const r = m && m.rows[G.menuSel];
  G.openMenu = -1;
  if (!r) return;
  // Every MENU.TXT row across the six pulldowns is bound (test_flow asserts
  // it), so the guard is only here to keep an edited MENU.TXT from throwing.
  const fn = COMMANDS[r.label];
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

function drawSidebar(ctx) {
  // Minimap: 1px per tile in a 56x39 black well inside a 1px orange frame.
  // Frame (251,8)-(308,48) and interior origin (252,9) are pixel-measured from
  // docs/screens/06_ingame_map.png; the byte-verified panel rect is (241,8,79,41).
  const mm = { x: 252, y: 9, w: 56, h: 39 };
  ctx.fillStyle = ink(0); ctx.fillRect(mm.x - 1, mm.y - 1, mm.w + 2, mm.h + 2);
  hollowRect(ctx, mm.x - 1, mm.y - 1, mm.w + 2, mm.h + 2, 6);
  const sx = Math.max(0, Math.min(MAP.w - mm.w, G.view.x - 20));
  const sy = Math.max(0, Math.min(MAP.h - mm.h, G.view.y - 13));
  for (let y = 0; y < mm.h; y++) for (let x = 0; x < mm.w; x++) {
    // The minimap reads the same sticky visibility layer as the main view:
    // unexplored ground is simply not there.
    if (!isSeen(sx + x, sy + y)) continue;
    const v = at(sx + x, sy + y), t = tileTerrain(v);
    let c = 0x38;                                  // ocean blue-ish
    if (t === TERR.SEALANE) c = 0x36;
    else if (t === TERR.ARCTIC) c = 0x0F;
    else if (t !== TERR.OCEAN) c = tileMountains(v) ? 0x6B : (isForested(t) ? 0x47 : 0x43);
    ctx.fillStyle = ink(c);
    ctx.fillRect(mm.x + x, mm.y + y, 1, 1);
  }
  // Owner dots: colonies in their @COUNTRY colour, settlements in the tribe's.
  for (const v of G.villages) {
    const dx = v.x - sx, dy = v.y - sy;
    if (dx < 0 || dy < 0 || dx >= mm.w || dy >= mm.h) continue;
    if (!isSeen(v.x, v.y)) continue;
    ctx.fillStyle = ink((G.tribes[v.tribe] || {}).color || 8);
    ctx.fillRect(mm.x + dx, mm.y + dy, 1, 1);
  }
  for (const c of G.colonies) {
    const dx = c.x - sx, dy = c.y - sy;
    if (dx < 0 || dy < 0 || dx >= mm.w || dy >= mm.h) continue;
    ctx.fillStyle = ink(DATA.nations[c.nation].color);
    ctx.fillRect(mm.x + dx, mm.y + dy, 1, 1);
  }
  hollowRect(ctx, mm.x + (G.view.x - sx), mm.y + (G.view.y - sy),
             VIEW_COLS(), VIEW_ROWS(), 0x0F);

  // Sidebar B (240,72,80,64): season/year, gold, tax. All HUD text is the
  // green ink 68, pixel-measured from docs/screens/06_ingame_map.png.
  const season = DATA.seasons[G.season];
  FONT.tiny.draw(ctx, `${season} ${G.year}`, 244, 51, lut(HUD_INK));
  FONT.tiny.draw(ctx, `Gold: ${G.gold}`, 244, 59, lut(HUD_INK));
  FONT.tiny.draw(ctx, `Tax: ${G.tax}%`, 290, 59, lut(HUD_INK));

  // Sidebar C (240,136,80,64): selected-unit panel.
  const u = G.units[G.sel];
  if (u) {
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(ctx, 'ICONS', u.icon, 244 + (24 - fw) / 2, 72 + (20 - fh) / 2);
    nationPlate(ctx, 244, 72, ownerColour(u), u.orders);
    // The budget is in thirds; the HUD shows whole moves, with the odd third
    // spelled out so a road march reads correctly.
    const whole = Math.floor(u.movesLeft / MOVE_UNIT), frac = u.movesLeft % MOVE_UNIT;
    FONT.tiny.draw(ctx, `Moves: ${whole}${frac ? ` ${frac}/3` : ''}`, 270, 74, lut(HUD_INK));
    FONT.tiny.draw(ctx, `Locat: (${u.x}, ${u.y})`, 270, 84, lut(HUD_INK));
    // The HUD uses NAMES @NATIONABBREV ("Eng.", "Fr.", ...), not the adjective.
    FONT.tiny.draw(ctx, `${DATA.nations[G.nation].abbrev} ${u.type}`, 244, 96, lut(HUD_INK));
    FONT.tiny.draw(ctx, DATA.orders[u.orders].name, 244, 104, lut(HUD_INK));
    FONT.tiny.draw(ctx, `(${terrainName(at(u.x, u.y))})`, 244, 112, lut(HUD_INK));
    let cy = 128;
    for (const c of u.cargo) {
      const cu = unit(entryType(c));
      if (cu) sheetFrame(ctx, 'ICONS', cu.icon, 244, cy - 4);
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
    here.colonists.push({ type: u.type, profession: u.profession || null,
                          job: null, cell: null });
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
  askScans(0, () => nameAndFound());
  function nameAndFound() {
  openDialog('COLONY', (name) => {
    const nm = (name || '').trim() || suggested;
    G.colonies.push({
      name: nm, x: u.x, y: u.y, nation: G.nation,
      // A new colony starts with its founder in the plaza and an empty
      // warehouse; the fixed starting buildings are the three no-cost rows.
      // Colonists carry a job and, if they work a field, the cell they work
      // (signed -2..+2 from the colony centre). The founder starts in the
      // plaza with no job -- which is why a new colony makes no hammers.
      colonists: [{ type: u.type, job: null, cell: null }],
      stock: DATA.cargo.map(() => 0),
      buildings: STARTING_BUILDINGS.slice(),
      hammers: 0,          // construction points banked
      building: null,      // @BUILDING row being constructed
      sol: 0,
    });
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
  askEvent('ABANDON', { STRING0: c.name }, (choice) => {
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
  G.goTo = u;
  G.msg = 'Click the tile to travel to.';
}
function setGoTo(u, x, y) {
  u.goal = [x, y];
  u.orders = 3;
  G.goTo = null;
  advance();
}
function advanceGoTo() {
  for (const u of G.units) {
    if (u.orders !== 3 || !u.goal) continue;
    const [gx, gy] = u.goal;
    if (u.x === gx && u.y === gy) { u.orders = 0; u.goal = null; continue; }
    // One step a turn toward the goal, respecting the unit's element.
    const dx = Math.sign(gx - u.x), dy = Math.sign(gy - u.y);
    const tries = [[dx, dy], [dx, 0], [0, dy]];
    let moved = false;
    for (const [mx, my] of tries) {
      if (!mx && !my) continue;
      const nx = u.x + mx, ny = u.y + my;
      if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) continue;
      const water = tileWater(at(nx, ny));
      if (u.ship !== water && !(colonyAt(nx, ny) && !u.ship)) continue;
      if (G.natives.some(n => n.x === nx && n.y === ny)) continue;
      u.x = nx; u.y = ny;
      reveal(nx, ny, sightRadius(u));
      moved = true;
      break;
    }
    if (!moved) { u.orders = 0; u.goal = null; G.msg = `${u.type} can go no further.`; }
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
      // Clear: the tile id drops by 8 to its unforested base, and the lumber
      // the forest was worth goes to the nearest colony. The grant's column
      // carries a CONFLICT -- the spec cites +0x2F80, which by this table's own
      // column arithmetic is y_ore, while the grant is plainly lumber. The port
      // reads the LUMBERJACK column as the coherent one and scales it x10 to
      // land in the original's familiar range; both choices are flagged in
      // docs/UI_AUDIT_TRACKER.md.
      const LUMBER_COL = 5, CLEAR_SCALE = 10;
      const lumber = tileYield(at(u.x, u.y), LUMBER_COL) * CLEAR_SCALE;
      // `sub es:[bx],8` is applied to the FOLDED id. Raw ids 16..23 fold to
      // 8..15 first (CLAUDE.md hard rule 3), so a straight -8 on the raw byte
      // would leave a 16..23 tile still forested; folding first lands both
      // halves of the band on their 0..7 unforested base. The non-terrain bits
      // (hills, river) ride through untouched.
      let t = tileTerrain(MAP.tiles[i]);
      if (t >= 16 && t <= 23) t = (t & 7) | 8;
      MAP.tiles[i] = (MAP.tiles[i] & ~0x1F) | (t - 8);
      const c = G.colonies.slice().sort((a, b) =>
        (Math.abs(a.x - u.x) + Math.abs(a.y - u.y)) - (Math.abs(b.x - u.x) + Math.abs(b.y - u.y)))[0];
      if (c && lumber > 0) {
        c.stock[GOOD.LUMBER] += lumber;
        showEvent('CLEARCUT', { STRING0: c.name, NUMBER0: lumber });
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
function tileYield(v, job) {
  let t = v & 0x1F;
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  const y = DATA.yields;
  const row = t <= 7 ? y.unforested[t]
            : t <= 15 ? y.forested[t - 8]
            : y.other[t - 24];
  return row ? (row[job] || 0) : 0;
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
// BUILDING UPKEEP. @BUILDING's last column is a per-turn gold charge, and
// @UPKEEP says what happens when you cannot pay it: "colonists in the buildings
// will produce at half efficiency" until you do. The base tier (upkeep 0) is
// free, which is why a new colony costs nothing to run.
function colonyUpkeep(c) {
  return c.buildings.reduce((n, b) => {
    const row = DATA.buildings.find(d => d.name === b);
    return n + (row ? row.upkeep : 0);
  }, 0);
}
function totalUpkeep() { return G.colonies.reduce((n, c) => n + colonyUpkeep(c), 0); }
function payUpkeep() {
  const due = totalUpkeep();
  if (!due) { G.upkeepUnpaid = false; return; }
  if (G.gold >= due) { G.gold -= due; G.upkeepUnpaid = false; return; }
  G.upkeepUnpaid = true;
  showEvent('UPKEEP', { NUMBER0: due });
}
// The base an indoor worker converts per turn. NOT in the evidence: no
// production-rate column exists in @BUILDING (its `size` column is the colony
// screen's category slot, 0..4), and no rate is quoted in PEDIA. The port uses
// the original game's familiar 3 at the base tier and 6 once the second link is
// built; the FACTORY behaviour on top of that IS byte-verified -- the third
// link makes the same output cost only 2/3 of the raw (@0x8EB1).
const INDOOR_BASE = 3;
function indoorRate(c, job) {
  const n = chainCount(c, job);
  return n >= 2 ? INDOOR_BASE * 2 : INDOOR_BASE;
}
// The Sons-of-Liberty / Tory production penalty, byte-verified at
// @0x9D14..0x9D98: every `10 - difficulty` Tories costs one unit of every
// worker's output, and the rebel-majority / rebel-unanimous latches give one
// back each.
function toryPenalty(c) {
  const pop = c.colonists.length;
  const tories = Math.round(pop * (100 - c.sol) / 100);
  let d = -Math.floor(tories / (10 - G.difficulty));
  if (c.sol >= 50) d += 1;
  if (c.sol >= 100) d += 1;
  return d;
}
// Does this colonist master the job they are doing? @JOB's expert column is the
// title; a colonist carries it as their profession.
function isExpert(p, job) {
  const i = jobIndex(job);
  return i >= 0 && p.profession === DATA.jobexpert[i];
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
// compute_terrain_yield for one field worker.
function fieldYield(c, p) {
  const job = p.job, g = JOB_GOOD[jobIndex(job)];
  if (g === undefined || g < 0) return 0;
  const v = at(c.x + p.cell[0], c.y + p.cell[1]);
  // The Fisherman column (8) is the water column; everyone else reads the
  // column that matches the good.
  const col = tileWater(v) ? 8 : g;
  let y = tileYield(v, col);
  if (y <= 0) return 0;
  y += improvementBonus(c.x + p.cell[0], c.y + p.cell[1], g);
  y += toryPenalty(c);
  // The expert match: the "era" goods Food and Horses take a flat +2, every
  // other good DOUBLES (@0x9DAD..0x9DD2).
  if (isExpert(p, job)) {
    if (g === GOOD.FOOD || g === GOOD.HORSES) y += 2; else y *= 2;
  }
  return Math.max(0, y);
}
// The list a native village will teach from (§19.4). Whether Scout (row 22)
// belongs here is UNCITED -- JOB_GOOD has no entry for it and fieldYield returns
// 0, so it is inert as a field job, and spec/systems/natives.md has no entry
// either way. TBD.
const OUTDOOR_JOBS = [0, 1, 2, 3, 4, 7, 8, 22];
// The NINE FIELD jobs are the nine terrain yield columns, one for one: Farmer,
// Planter (sugar / tobacco / cotton), Fur Trapper, Lumberjack, Ore Miner,
// Silver Miner, Fisherman -- NAMES.TXT:17-19 is the yield-column legend and
// @JOB rows 224+ are the jobs, with Lumberjack row 5 and Ore Miner row 6.
// Corroborated by the engine's job->building table at DS:0x2F4 (func_008D9C,
// file 0x1DC94, 19 signed bytes), where jobs 0..8 are all -1 = outdoor, no
// workplace building.
//
// This is DELIBERATELY a separate array from OUTDOOR_JOBS above, which omits
// rows 5 and 6: villageSkill() indexes OUTDOOR_JOBS *modulo its length*, so
// growing that array in place would silently reshuffle every native village's
// taught skill. The omission was a real bug on the field side -- a forest cell
// yields lumber 3 against furs 2, so bestFieldJob could never return Lumberjack
// and every forest worker came out a Fur Trapper.
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
// One colonist inside a building. Returns what they COULD make; the raw check
// happens in the chain step.
function indoorYield(c, p) {
  const job = p.job, g = JOB_GOOD[jobIndex(job)];
  if (g === undefined) return 0;
  let y = indoorRate(c, job) + toryPenalty(c);
  if (isExpert(p, job)) y *= 2;
  // @UPKEEP: with the bill unpaid, colonists in the buildings work at half.
  if (G.upkeepUnpaid) y = Math.floor(y / 2);
  return Math.max(0, y);
}
// The whole colony's output for one turn, before anything is banked. The order
// is colony_turn_update's: zero the accumulator, run the tiles, then apply the
// raw->finished chains.
function colonyProduce(c) {
  const out = DATA.cargo.map(() => 0);
  const tally = { [HAMMERS]: 0, [BELLS]: 0, [CROSSES]: 0, [TEACHING]: 0 };
  // The CENTRE TILE produces with no worker. The engine derives its food from a
  // terrain BAND CLASS 0..3 whose mapping is not in the evidence here, so the
  // farmer column of the terrain's own row stands in for it; the modifiers that
  // ARE cited are applied (+2 at difficulty 0, +1 at difficulty 1, +1 river).
  const cv = at(c.x, c.y);
  let centre = tileYield(cv, JOB_FARMER);
  if (G.difficulty === 0) centre += 2; else if (G.difficulty === 1) centre += 1;
  if (tileRiver(cv)) centre += 1;
  centre += improvementBonus(c.x, c.y, GOOD.FOOD);
  out[GOOD.FOOD] += centre;
  const indoor = [];
  for (const p of c.colonists) {
    if (!p.job) continue;
    if (p.cell) { const g = JOB_GOOD[jobIndex(p.job)]; if (g >= 0) out[g] += fieldYield(c, p); }
    else indoor.push(p);
  }
  // The chains. Each indoor worker's output is capped by the raw on hand plus
  // whatever the fields brought in this turn; the factory tier (3rd link) buys
  // the same output for 2/3 of the raw.
  const consumed = DATA.cargo.map(() => 0);
  const outages = new Set();
  for (const p of indoor) {
    const job = p.job, g = JOB_GOOD[jobIndex(job)];
    if (g === undefined) continue;
    let want = indoorYield(c, p);
    const raw = RAW_FOR[g];
    if (raw !== undefined) {
      const factory = chainCount(c, job) > 2;
      const avail = c.stock[raw] + out[raw] - consumed[raw];
      const cost = (n) => factory ? Math.floor(n * 2 / 3) : n;
      // A manned converter starved to a standstill is a per-good outage --
      // colonyTurn latches it into the @CANESUGAR/.../@TOOLS notice.
      const potential = want;
      while (want > 0 && cost(want) > avail) want -= 1;
      if (potential > 0 && want === 0) outages.add(raw);
      consumed[raw] += cost(want);
    }
    if (g >= 0) out[g] += want; else tally[g] += want;
  }
  // The colony panels want the two halves separately, not just the net: the
  // engine keeps a produced table (`[0x8DC8]`) and a consumed table (`[0x8E32]`)
  // and draws BOTH -- the consumed run is the part that gets the red overlay
  // (spec/ui/colony_screen.md §3.6). Snapshot `gross` before netting.
  const gross = out.slice();
  for (let i = 0; i < consumed.length; i++) out[i] -= consumed[i];
  const eaten = 2 * c.colonists.length;                   // BYTE_VERIFIED @0xA5F2
  return { out, gross, consumed, tally, centre, eaten, outages,
           netFood: out[GOOD.FOOD] - eaten };
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
function runSchool(c) {
  const level = schoolLevel(c);
  if (!level) return;
  // Teachers: mastered professions only, capped at the building's faculty.
  const faculty = c.colonists.filter(p => p.job === 'Teacher' && p.profession &&
                                          professionClass(p.profession) <= level)
                             .slice(0, level);
  if (!faculty.length) return;
  for (const teacher of faculty) {
    const need = TEACH_TURNS[professionClass(teacher.profession)];
    if (!need) continue;
    const student = c.colonists.find(p => p !== teacher && p.job !== 'Teacher' &&
      (!p.profession || STUDENT_TIERS.includes(p.profession)));
    if (!student) { showEvent('TRAINFAIL', {}); continue; }
    student.taught = (student.taught || 0) + 1;
    if (student.taught < need) continue;
    student.taught = 0;
    // A student below expert climbs one tier; a Free Colonist takes the
    // teacher's own expertise.
    // Graduation ladder (byte-verified @0x02DF00/@0x02DF35/@0x02DF70): a
    // student below expert climbs one tier, a Free Colonist takes the
    // teacher's own expertise -- each rung with its own message.
    const rung = STUDENT_TIERS.indexOf(student.profession);
    if (rung === 0) {
      student.profession = STUDENT_TIERS[1];
      showEvent('TRAINCRIMINAL', { STRING0: c.name });
    } else if (rung === 1) {
      student.profession = STUDENT_TIERS[2];
      showEvent('TRAININDENTURED', { STRING0: c.name });
    } else {
      student.profession = teacher.profession;
      // @TRAINPROFESSION: STRING0 is the COLONY, STRING1 the profession.
      showEvent('TRAINPROFESSION', { STRING0: c.name, STRING1: student.profession });
    }
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
  if (G.fathersOwned.includes('Jan de Witt')) sol += 20;
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
// The over-100 disposal step, byte-verified at func_02D658 @0x2D6F7: for each
// tradeable good with stock >= 100 the stock is cut to 50 and the EXCESS IS
// SOLD, net of tax, to the treasury (@0x2D785) -- unless independence has been
// declared ([0x5382]&1 @0x2D728), in which case it is wasted instead.
// OPEN: whether a Custom-House gate sits in the caller. None is recorded, so
// none is applied. Flagged in docs/UI_AUDIT_TRACKER.md.
function autoExport(c) {
  const spoiled = [];
  for (let i = 0; i < c.stock.length; i++) {
    if (i === GOOD.FOOD || c.stock[i] < 100) continue;
    // @CARGOREADY1/2 -- "A new cargo of Y is ready at X ... reached its
    // storage capacity" -- announced as the good tops the 100-ton overflow
    // threshold, variant 1 while a larger warehouse could still be built.
    // The engine's trigger site and its per-good latch are unread; announcing
    // here, latched until the stock falls back, is the port's reading.
    // (@CARGOREADY0, the below-capacity variant, needs the per-good capacity
    // model func_008D00 -- unwired until that is byte-read.)
    c.cargoReady = c.cargoReady || {};
    if (!c.cargoReady[i]) {
      c.cargoReady[i] = true;
      showEvent(warehouseLevel(c) < 2 ? 'CARGOREADY1' : 'CARGOREADY2',
                { STRING0: c.name, STRING1: DATA.cargo[i].name, NUMBER0: 100 });
    }
    const excess = c.stock[i] - 50;
    c.stock[i] = 50;
    // Custom Houses allow trade after independence (market.md); without one the
    // excess is wasted rather than sold once you have declared. Peter
    // Stuyvesant is what makes the building available at all.
    const hasCustom = c.buildings.includes('Custom House');
    if (isBoycotted(i) || (G.declared && !hasCustom) ||
        (hasCustom && (c.customOff || {})[i])) {
      spoiled.push({ good: i, qty: excess });
      continue;
    }
    const gross = excess * G.market[i];
    const tax = Math.floor(gross * G.tax / 100);
    G.gold += gross - tax;
    G.kingsFund += tax;
  }
  for (const i of Object.keys(c.cargoReady || {}))
    if (c.stock[i] < 100) delete c.cargoReady[i];
  // @SPOIL1-4: goods actually thrown away (the sale paths above never spoil).
  // Variant pick -- qty+name when one good spoiled (1/3), the generic body for
  // several (2/4); the "a larger warehouse could hold another 100 tons" tail
  // only while one can still be built. The engine's variant selector is
  // unread; this reading is flagged.
  if (spoiled.length) {
    const hint = warehouseLevel(c) < 2;
    if (spoiled.length === 1)
      showEvent(hint ? 'SPOIL1' : 'SPOIL3',
                { STRING0: c.name, STRING1: DATA.cargo[spoiled[0].good].name,
                  NUMBER0: spoiled[0].qty });
    else
      showEvent(hint ? 'SPOIL2' : 'SPOIL4', { STRING0: c.name });
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
  return u && { name, cost: u.cost * UNIT_HAMMER_SCALE, tools_x10: u.tools,
                isUnit: true };
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
function colonyTurn(c) {
  const r = colonyProduce(c);
  // Input-outage latches: a manned converter starved of its raw announces
  // once, and re-arms when the chain runs again. The engine's latch site is
  // unread; the once-per-outage cadence is the port's reading, flagged.
  c.outageLatch = c.outageLatch || {};
  for (const raw of r.outages) {
    if (!OUTAGE_KEY[raw] || c.outageLatch[raw]) continue;
    c.outageLatch[raw] = true;
    showEvent(OUTAGE_KEY[raw], { STRING0: c.name });
  }
  for (const k of Object.keys(c.outageLatch))
    if (!r.outages.has(Number(k))) delete c.outageLatch[k];
  for (let i = 0; i < r.out.length; i++)
    c.stock[i] = Math.max(0, c.stock[i] + r.out[i]);      // banked with a floor at 0
  // Food: eat first, then the surplus feeds the growth store. The engine posts
  // real popups here (func_02D658), not status-bar lines: a low-food WARNING
  // (@FOODLOW, once, while stores are thin), then STARVATION (@STARVE1) when a
  // colonist is lost, and a BIRTH (@NEWCOLONIST) on growth.
  c.stock[GOOD.FOOD] = Math.max(0, c.stock[GOOD.FOOD] - r.eaten);
  // The winter split: from the 1600 time-scale change the FALL turn is the
  // "winter is coming soon" variant of each food message (@FOOD2/@STARVE2 vs
  // @FOOD1/@STARVE1). Which turn the engine treats as pre-winter is unread --
  // fall-after-1600 is the port's reading of the seasons, flagged.
  const preWinter = G.year >= 1600 && G.season === 1;
  if (r.netFood < 0 && c.stock[GOOD.FOOD] === 0) {
    if (!c.foodDepleted) {
      // The turn stores hit bottom: @FOOD1/@FOOD2 ("we MAY starve"), latched.
      // Death starts the NEXT hungry turn -- the depletion warning first,
      // then starvation, is the port's reading of the two keys' tenses.
      c.foodDepleted = true;
      showEvent(preWinter ? 'FOOD2' : 'FOOD1', { STRING0: c.name });
    } else if (c.colonists.length > 1) {
      c.colonists.pop();
      showEvent(preWinter ? 'STARVE2' : 'STARVE1', { STRING0: c.name });
      c.foodWarned = false;
    } else {
      // @VANISH: the LAST colonist starves and the colony is gone. Flagged
      // for removal after the colony loop (endTurn), not mid-iteration.
      c.vanished = true;
      showEvent('VANISH', { STRING0: c.name });
    }
  } else if (r.netFood < 0 && c.stock[GOOD.FOOD] < FOOD_FOR_COLONIST && !c.foodWarned) {
    c.foodWarned = true;
    showEvent('FOODLOW', { STRING0: c.name, NUMBER0: c.stock[GOOD.FOOD] });
  } else if (r.netFood >= 0) {
    c.foodWarned = false;
    c.foodDepleted = false;
  }
  if (c.stock[GOOD.FOOD] >= FOOD_FOR_COLONIST) {
    c.stock[GOOD.FOOD] -= FOOD_FOR_COLONIST;
    c.colonists.push({ type: 'Colonists', profession: null, job: null, cell: null });
    showEvent('NEWCOLONIST', { STRING0: c.name });
  }
  // Horses breed in a colony that holds them: the per-turn growth threshold is
  // 25 with a Stable (building 0x11) and 50 without -- byte-verified at
  // func_00A3E1 @0xA5BB/@0xA5C0/@0xA5CD.
  const herd = c.stock[GOOD.HORSES];
  if (herd >= (c.buildings.includes('Stable') ? 25 : 50))
    c.stock[GOOD.HORSES] = herd + Math.max(1, Math.floor(herd / 10));
  c.crossesTurn = r.tally[CROSSES];
  // Printing Press adds 50% to the colony's bells and a Newspaper doubles them
  // (per-colony building bits 0x13 / 0x14, founding_fathers.md §3).
  let bells = r.tally[BELLS];
  if (c.buildings.includes('Newspaper')) bells *= 2;
  else if (c.buildings.includes('Printing Press')) bells = Math.floor(bells * 3 / 2);
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
    showEvent('INEFFICIENT', { STRING0: c.name, NUMBER0: 10 - G.difficulty });
  } else if (pen >= 0 && c.ineffLatch) {
    c.ineffLatch = false;
    showEvent('EFFICIENT', { STRING0: c.name });
  }
  advanceConstruction(c, r.tally[HAMMERS]);
  runSchool(c);
  autoExport(c);
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
  if (c.hammers < b.cost) { c.toolWarned = false; return; }
  // Completion-time guards. @NOMOREWAGONS: wagons are capped at the colony
  // count (the PEDIA/manual rule) -- the build stalls, announced once.
  if (b.isUnit && b.name === 'Wagon Train') {
    const wagons = G.units.filter(u => u.type === 'Wagon Train').length;
    if (wagons >= G.colonies.length) {
      if (!c.capWarned) {
        c.capWarned = true;
        showEvent('NOMOREWAGONS', { STRING0: c.name, NUMBER0: G.colonies.length });
      }
      return;
    }
  }
  c.capWarned = false;
  // @ALREADYHAVE / @NOMOREWAREHOUSE: the target already stands (reachable
  // when circumstances changed after the pick); the target is cleared.
  if (!b.isUnit && c.buildings.includes(b.name)) {
    showEvent(b.name === 'Warehouse Expansion' ? 'NOMOREWAREHOUSE' : 'ALREADYHAVE',
              { STRING0: c.name, STRING1: b.name });
    c.building = null;
    return;
  }
  // Hammers are ready but the tools are short: the engine posts @NEEDTOOLS /
  // @NEEDTOOLS0 (STRING0=colony, STRING1=building, NUMBER0=needed, NUMBER1=on
  // hand) and the building waits. Once per stall, not every turn.
  if (c.stock[GOOD.TOOLS] < needTools) {
    if (!c.toolWarned) {
      c.toolWarned = true;
      const have = c.stock[GOOD.TOOLS];
      showEvent(have > 0 ? 'NEEDTOOLS' : 'NEEDTOOLS0',
                { STRING0: c.name, STRING1: b.name, NUMBER0: needTools, NUMBER1: have });
    }
    return;
  }
  c.toolWarned = false;
  c.hammers -= b.cost;
  c.stock[GOOD.TOOLS] -= needTools;
  if (b.isUnit) {
    // A finished unit steps onto the colony square (ships sit in port there,
    // the same tile colonyShip reads).
    G.units.push(mkUnit(b.name, c.x, c.y));
  } else {
    c.buildings.push(b.name);
  }
  c.building = null;
  // @BUILT: "%STRING0 colony produces {%STRING1}." (STRING0=colony, STRING1=the
  // building) -- a popup, not a status line.
  showEvent('BUILT', { STRING0: c.name, STRING1: b.name });
}

// The rush-buy (@BUYME0 info / @BUYME1 confirm, width 160, live frame
// 81_colony_build_prompt: "Cost to complete Docks: 1552$. Treasury: 1000$."):
// pay gold to finish the construction target now. The engine's AMOUNT
// formula is unread -- the flagged stand-in prices remaining hammers at 30$
// and remaining tools at the market ask (the capture's 1552$ vs this
// formula's 1560$ for a fresh Docks is the open calibration, Phase 4).
// @CUSTOM "Which cargos shall our {Custom House} export?" -- the per-good
// export toggle. The engine's picker format (runtime rows) is unread; the
// port re-opens the single-pick popup per toggle, '*' marking exported
// goods, flagged. autoExport consults the toggles when the house stands.
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
  const cost = 30 * remH + askPrice(GOOD.TOOLS) * remT;
  const S = { STRING0: b.name, NUMBER0: cost, NUMBER1: G.gold };
  if (cost > G.gold) { showEvent('BUYME0', S); return; }
  askEvent('BUYME1', S, (choice) => {
    if (choice !== 1) return;                    // row 2 = "Complete it."
    G.gold -= cost;
    c.hammers = Math.max(c.hammers, b.cost);
    c.stock[GOOD.TOOLS] = Math.max(c.stock[GOOD.TOOLS], b.tools_x10 * 10);
    advanceConstruction(c, 0);
  });
}

// A ship entering the sea lane leaves the map for the home port. Ships carry a
// hold of {good, qty} slots plus passenger units; the crossing takes three
// turns, which is what the sail-state 1/2/3 bands in §26.9 count down.
const SAIL_TURNS = 3;
function sailForEurope(ship) {
  G.europe.push({ type: ship.type, icon: ship.icon, hold: ship.hold || [],
                  passengers: ship.cargo || [], state: 'toEurope', turns: SAIL_TURNS,
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
    if (e.state === 'port') continue;
    if (--e.turns > 0) continue;
    // Docking in Europe brings up the harbour, the way arriving does in game.
    // The units aboard DISEMBARK TO THE DOCK (@TUTORIAL15's "fence" model on
    // the Europe side): that is where the @ARMOPTIONS dock-unit menu lives,
    // and boarding/sailing takes them back aboard.
    if (e.state === 'toEurope') {
      e.state = 'port';
      // @REFIT covers the home port too: damage clears on docking (the
      // engine's repair timer is unread; same flagged stand-in as colonies).
      if (e.damaged) {
        e.damaged = false;
        showEvent('REFIT', { STRING0: e.type,
                             STRING1: DATA.nations[G.nation].homeport });
      }
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
const VIEW_BUILDINGS = 0, VIEW_UNITS = 1, VIEW_PRODUCTION = 2;

function drawColony(ctx) {
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
      drawTile(sg, wx, wy, tx * 16, ty * 16);
      // The scene is the same composited map the main view shows, so the
      // settlements land on their tiles too -- above all, THE COLONY ITSELF on
      // the centre tile, which the panel used to leave as bare terrain.
      const oc = G.colonies.find(q => q.x === wx && q.y === wy);
      if (oc) drawSettlement(sg, tx * 16, ty * 16, colonyLevel(oc), oc.nation, 0);
      const ov = G.villages.find(q => q.x === wx && q.y === wy);
      if (ov) drawSettlement(sg, tx * 16, ty * 16, ov.level, -1,
                             (G.tribes[ov.tribe] || {}).color || 8, ov.mission);
    }
  // The x1.5 upscale is func_00531C's 2->3 duplication, whose phases the
  // live frame pins: COLUMNS pair at dst%3==0 (src = floor(2d/3)) and ROWS
  // at dst%3==1 (src = floor((2r+1)/3)) -- a plain drawImage stretch had the
  // row phase off by one. The 4x4 positional ramp dither func_005296 that
  // the engine passes every written pixel through is NOT reproduced yet
  // (ramps 0x10..0x87; flagged TBD) -- the capture shows only ~25% exact
  // pixel pairing where the undithered stretch gives ~75%.
  const up = document.createElement('canvas');
  up.width = 120; up.height = 120;
  const ug = up.getContext('2d');
  const sd = sg.getImageData(0, 0, 80, 80).data;
  const od = ug.createImageData(120, 120);
  for (let r = 0; r < 120; r++) {
    const sy = Math.floor((2 * r + 1) / 3);
    for (let d = 0; d < 120; d++) {
      const si = (sy * 80 + Math.floor(2 * d / 3)) * 4, oi = (r * 120 + d) * 4;
      od.data[oi] = sd[si]; od.data[oi + 1] = sd[si + 1];
      od.data[oi + 2] = sd[si + 2]; od.data[oi + 3] = 255;
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
  if (G.colonyPopup) drawColonyPopup(ctx);

  // Black separator rules, measured: a full-width row at y=7 under the title,
  // a full-width row at y=128 above the town strip, and the column at x=199
  // between the building field and the wood panel, spanning those two rows.
  ctx.fillStyle = ink(0);
  ctx.fillRect(0, 7, W, 1);
  ctx.fillRect(0, 128, W, 1);
  ctx.fillRect(199, 7, 1, 122);
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
        proportionalStrip(ctx, 22 + GOOD.FOOD, centre.food, 0, x, y, 24);
        if (centre.good >= 0)
          proportionalStrip(ctx, 22 + centre.good, centre.amount, 0, x, y + 13, 24);
        continue;
      }
      const wx = c.x + dx, wy = c.y + dy;
      // Flag bit 6, the blocked-cell mark: a 24x24 outline in pure red 0x0C
      // (@0x026584). [0x8DF0] is runtime state; "another settlement holds the
      // tile" is the port's reading of when the bit is set, flagged.
      if (G.villages.some(q => q.x === wx && q.y === wy) ||
          G.colonies.some(q => q !== c && q.x === wx && q.y === wy) ||
          G.rivals.some(rv => rv.colonies.some(q => q.x === wx && q.y === wy)))
        hollowRect(ctx, x, y, 24, 24, 0x0C);
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
      // Map units STANDING on the surrounding tile -- the post-upscale scene
      // pass func_026374 @0x02646A-92: PHYS0 frame 0x5A + unit-type row at
      // (cell*24+252, cell*24+60) = (x+4, y+4). Live Curacao carries PHYS0
      // 99 and 101 at exactly those anchors.
      const stander = G.natives.find(q => q.x === wx && q.y === wy) ||
                      G.units.find(q => q.x === wx && q.y === wy) ||
                      G.refUnits.find(q => q.x === wx && q.y === wy);
      if (stander) {
        const ti = DATA.units.findIndex(r => r.name === stander.type);
        if (ti >= 0 && DATA.sheets.PHYS0.frames[0x5A + ti])
          sheetFrame(ctx, 'PHYS0', 0x5A + ti, x + 4, y + 4);
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
        const u = unit(p.type) || unit('Colonists');
        if (u) sheetFrame(ctx, 'ICONS', u.icon, x + 14, y + 6);
      }
      if (p && p === sel) hollowRect(ctx, x, y, 24, 24, 0x0A);
    }
  }
}

// What the colony's own tile makes with nobody on it: food, plus one other
// good. Both are live-read for Curacao (`[0xA891]`=4 food, `[0xA893]`=4 furs
// with `[0xA894]`=3), and its `[0x8DC8]` shows those 3 furs entering the
// colony's output -- so the centre tile really does produce a second good, not
// just food. WHICH good is not cited anywhere: the best-yielding non-food
// column is used, which fits the live frame but is inferred, not derived.
function centreYield(c) {
  const v = at(c.x, c.y);
  let food = tileYield(v, JOB_FARMER);
  if (G.difficulty === 0) food += 2; else if (G.difficulty === 1) food += 1;
  if (tileRiver(v)) food += 1;
  food += improvementBonus(c.x, c.y, GOOD.FOOD);
  let good = -1, amount = 0;
  for (let col = 1; col <= 7; col++) {
    const y = tileYield(v, col);
    if (y > amount) { amount = y; good = JOB_GOOD[col]; }
  }
  return { food, good, amount };
}

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
  const people = c.colonists.map(p => (unit(p.type) || unit('Colonists')).icon);
  const garrison = G.units.filter(u => u.x === c.x && u.y === c.y).map(u => u.icon);
  const icons = people.concat(garrison);
  if (!icons.length) return [];
  const totalW = icons.reduce((a, i) => a + frameSize('ICONS', i)[0], 0);
  const extra = garrison.length ? PLAZA_GARRISON_GAP : 0;
  let gap = 2;
  while (gap * (icons.length - 1) + extra + totalW >= PLAZA_ROW_BUDGET) gap -= 1;
  const out = [];
  let x = PLAZA_ROW_X;
  icons.forEach((icon, i) => {
    const [w, h] = frameSize('ICONS', icon);
    out.push({ icon, x, w, h, colonist: i < people.length ? i : -1 });
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
  const r = colonyProduce(c);
  const food = r.gross[GOOD.FOOD];
  // The engine's food cell is (count = produced, sub = produced - [0xA895])
  // with bit 14 (@0x027378-0x027388), so the first [0xA895] icons draw as the
  // alternate sprite. On the live frame that alternate run is exactly 4 long --
  // and the scene panel's centre cell in the SAME frame reads 4, the food the
  // centre tile makes with nobody on it. So [0xA895] is read as the centre-tile
  // yield here; it is the only reading the frame supports, and it is one frame.
  drawCountRow(ctx, [
    { frame: 22 + GOOD.FOOD, count: food, sub: Math.max(0, food - r.centre), flags: 0x4000 },
    { frame: 22 + GOOD.FOOD, count: Math.max(0, r.eaten - food), sub: 0, flags: 0x8000 },
    { frame: 56, count: r.tally[CROSSES], sub: 0, flags: 0 },   // EXE 0x39
    { frame: 62, count: r.tally[BELLS], sub: 0, flags: 0 },     // EXE 0x3F
  ], PLAZA_FOOD_X, PLAZA_FOOD_Y, PLAZA_FOOD_SPAN, 4);

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
    return [{ label: none, note: '', stop: true }].concat(
      buildOptions(c).map(b => ({
        label: b.name,
        note: `(${b.cost} Hammers)` +
              (b.tools_x10 ? ` (${b.tools_x10 * 10} Tools)` : ''),
      })));
    // NOTE: the real list also offers BUILDABLE UNITS (Artillery, Wagon Train,
    // and ships with a Drydock/Shipyard) below the buildings; their per-colony
    // hammer/tool costs are not in a byte-verified table here, so they are
    // omitted rather than invented. Flagged (open item).
  }
  if (G.colonyPopup === 'occupation') {
    const p = c.colonists[G.colonistSel];
    return p && p.cell ? occupationRows(c, p) : [];
  }
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
function colonyPopupBox() {
  const rows = colonyPopupRows();
  let cw = 0x50;
  for (const r of rows) cw = Math.max(cw, FONT.tiny.width(r.label) + FONT.tiny.width(r.note) + 20);
  const w = cw + 6, h = 6 + 6 + 3 + rows.length * 8 + 3;
  return { x: Math.round(160 - w / 2), y: Math.max(2, Math.round(100 - h / 2)), w, h, rows };
}
function drawColonyPopup(ctx) {
  const c = G.colonies[G.colony], b = colonyPopupBox();
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  // Titles are the engine's own: LABELS @CTITLE 4 "Select An Item To Build",
  // @CTITLE 8 "Select a Profession for" + the colonist's name.
  const who = c.colonists[G.colonistSel];
  const title = G.colonyPopup === 'build'
    ? `${(DATA.text.ctitle || [])[4] || 'Select An Item To Build'}  (${c.hammers} Hammers, ${c.stock[GOOD.TOOLS]} Tools)`
    : `${(DATA.text.ctitle || [])[8] || 'Select a Profession for'} ${who ? (who.profession || who.type) : ''}`;
  FONT.tiny.draw(ctx, title, b.x + 5, b.y + 6, lut(0xFC));
  const seed = b.y + 6 + 6 + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * 8, sel = k === G.colonyPopupRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, 8); }
    const on = G.colonyPopup === 'build' && r.label === c.building;
    FONT.tiny.draw(ctx, (on ? '* ' : '') + r.label, b.x + 9, y + 1, lut(sel ? 0xFC : 0xFE));
    if (r.note) FONT.tiny.draw(ctx, r.note, b.x + b.w - 8 - FONT.tiny.width(r.note), y + 1,
                               lut(sel ? 0xFC : 0x5D));
  });
}
function colonyPopupCommit() {
  const c = G.colonies[G.colony], rows = colonyPopupRows(), r = rows[G.colonyPopupRow];
  if (!r) { G.colonyPopup = null; return; }
  if (G.colonyPopup === 'build') {
    // The construction panel itself shows the new target; the engine raises no
    // message here.
    c.building = r.stop ? null : r.label;
  } else if (G.colonyPopup === 'occupation') {
    const p = c.colonists[G.colonistSel];
    if (p) {
      if (r.job === null) { p.cell = null; p.job = null; }
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
  return G.units.filter(u => u.ship && u.x === c.x && u.y === c.y);
}
function colonyShip(c) {
  const ships = colonyShips(c);
  if (!ships.length) return null;
  if (G.colonyShipSel >= ships.length) G.colonyShipSel = 0;
  return ships[G.colonyShipSel];
}
function drawColonyDock(ctx, c) {
  const ships = colonyShips(c);
  if (!ships.length) {
    FONT.tiny.center(ctx, 'No Ships In Port', 160, 130, lut(PANEL_INK));
    for (let k = 0; k < 6; k++) sheetFrame(ctx, 'ICONS', 122, 127 + 12 * k, 165);
    return;
  }
  FONT.tiny.center(ctx, `Loading: ${colonyShip(c).type}`, 160, 130, lut(PANEL_INK));
  ships.slice(0, 4).forEach((u, k) => {
    const x = COLONY_DOCK.shipX + k * COLONY_DOCK.shipPitch;
    const y = COLONY_DOCK.shipY - 1 - (k > 0 ? 1 : 0);
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(ctx, 'ICONS', u.icon, x + ((16 - fw) >> 1), y + 16 - fh);
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
      if (cu) sheetFrame(ctx, 'ICONS', cu.icon, x, 168);
      continue;
    }
    const slot = hold[k - taken];
    if (slot) {
      const f = (slot.qty >= 100 ? 0x16 : 0x26) + slot.good;
      const [fw, fh] = frameSize('ICONS', f);
      sheetFrame(ctx, 'ICONS', f, x + ((10 - fw) >> 1), 165 + ((22 - fh) >> 1));
    }
  }
}

// Right panel (207,130,95,48) plus the three view buttons beside it.
function drawColonyPanel(ctx, c) {
  const px = 209, py = 132;
  if (G.colonyView === VIEW_BUILDINGS) {
    FONT.tiny.draw(ctx, 'Buildings', px, py, lut(PANEL_INK));
    c.buildings.slice(0, 5).forEach((b, i) =>
      FONT.tiny.draw(ctx, b, px, py + 8 + i * 7, lut(SOL_INK)));
    if (c.buildings.length > 5)
      FONT.tiny.draw(ctx, `+${c.buildings.length - 5} more`, px, py + 8 + 5 * 7, lut(PANEL_INK));
  } else if (G.colonyView === VIEW_UNITS) {
    FONT.tiny.draw(ctx, 'Garrison', px, py, lut(PANEL_INK));
    const inside = G.units.filter(u => u.x === c.x && u.y === c.y);
    if (!inside.length) FONT.tiny.draw(ctx, 'None', px, py + 9, lut(SOL_INK));
    inside.slice(0, 6).forEach((u, i) => {
      const [fw, fh] = frameSize('ICONS', u.icon);
      sheetFrame(ctx, 'ICONS', u.icon, px + i * 15, py + 22 - fh);
      nationPlate(ctx, px + i * 15, py + 10, ownerColour(u), u.orders);
    });
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
  const rows = productionRows(colonyProduce(c));
  drawCountRow(ctx, rows[0], PROD_X0, PROD_Y0, PROD_SPAN, 2);
  drawCountRow(ctx, rows[1], PROD_X0, PROD_Y0 + PROD_PITCH, PROD_SPAN, 2);
  drawCountRow(ctx, rows[2], PROD_X0, PROD_Y0 + 2 * PROD_PITCH, PROD_SPAN, 4);
}

// The three rows' cells, split out from the painter so the byte-read rules can
// be replayed against the live production tables in the tests.
function productionRows(r) {
  const cell = (i, count, sub, flags) =>
    ({ frame: PROD_GOOD_ICON + i, count, sub, flags: flags || 0 });
  // Row 0: raw goods. count = produced + consumed, sub = consumed, so the
  // consumed tail is what takes the red mark (`dx = [0x8DC8+i] + [0x8E32+i]`,
  // `bx = [0x8E32+i]`, @0x027604-0x027612). A good with NOTHING produced is
  // skipped outright even if it was consumed (`cmp word[bx-0x7238],0 / je`
  // @0x0275F1) -- live Curacao eats 6 cotton and shows no cotton entry at all.
  const raw = [];
  for (let i = 1; i <= 7; i++) {
    if (i === 5 || r.gross[i] === 0) continue;          // lumber has its own row
    raw.push(cell(i, r.gross[i] + r.consumed[i], r.consumed[i]));
  }
  // Row 1: manufactures. Each good i names a source good in `byte[0x2A2+i]` and
  // reads an amount from `word[0x8E5A + src*2]`; count = max(made, that), sub =
  // that (@0x027646-0x027688). The source table is RAM-read below and matches
  // the port's own chain map -- except slot 8, where Horses source THEMSELVES.
  //
  // `[0x8E5A]` RESOLVED 2026-08-06 by a second live colony. It is the part of a
  // raw's consumption met from THIS TURN'S output, not the total consumed:
  //   Curacao   lumber produced 0, consumed 6 -> reads 0
  //   Vlissingen lumber produced 8, consumed 4 -> reads 4
  //   Curacao   cotton produced 0, consumed 6 -> reads 0 (cloth draws unmarked)
  // i.e. min(consumed, produced), which fits all three.
  //
  // The Horses slot -- the one good that sources itself -- does NOT fit that
  // rule: it reads 4 against produced 4 in Curacao but 3 against produced 4 in
  // Vlissingen, so its filler is still unknown and this rule under-marks that
  // one entry rather than inventing a second rule for it.
  const SRC = { 8: 8, 9: GOOD.SUGAR, 10: GOOD.TOBACCO, 11: GOOD.COTTON,
                12: GOOD.FURS, 14: GOOD.ORE, 15: GOOD.TOOLS };
  const made = [];
  for (let i = 8; i < r.gross.length; i++) {
    const src = SRC[i];
    const amt = src === undefined ? 0
              : Math.min(r.consumed[src] || 0, r.gross[src] || 0);
    made.push(cell(i, Math.max(r.gross[i], amt), amt));
  }
  // Row 2: lumber then hammers. Bit 15 marks every icon of a consumed run and
  // reddens its badge (`ax=0x801c` @0x0276F1, `ax=0x8037` @0x02771F).
  //
  // `[0x8E14]` RESOLVED 2026-08-06: it is HAMMERS PRODUCED -- it reads 6 against
  // 6 hammers in Curacao and 12 against 12 in Vlissingen. The branch at
  // @0x0276AF compares it with lumber produced and, in the common case where
  // hammers >= lumber, enqueues the lumber PRODUCED figure whole. So the plain
  // run is lumber produced, not produced-minus-consumed as the port had it:
  // Vlissingen shows 8 plain lumber and 4 marked, having produced 8 and eaten 4.
  const lumberUsed = r.consumed[GOOD.LUMBER];
  const hammers = r.tally[HAMMERS];
  const work = [
    cell(GOOD.LUMBER, r.gross[GOOD.LUMBER], 0),
    cell(GOOD.LUMBER, lumberUsed, 0, 0x8000),
    // Hammers split the same way against `[0x8E64]`, which read 0 in Curacao and
    // 4 in Vlissingen -- hammers spent on construction this turn. The port banks
    // hammers rather than spending them per turn and has no equivalent, so the
    // whole run draws plain and the marked part is left out rather than faked.
    { frame: PROD_HAMMER_ICON, count: hammers, sub: 0, flags: 0 },
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
  G.accum = DATA.cargo.map(() => 0);
  // The whole-game PowerRecord trade counters the F5 report reads: net units
  // (+0xBC) and net value (+0x7C), zeroed at game start (func @0x366E7).
  G.tradeTons = DATA.cargo.map(() => 0);
  G.tradeGold = DATA.cargo.map(() => 0);
}
const askPrice = (i) => G.market[i] + DATA.cargo[i].burden + 1;
function stepPrice(i) {
  const c = DATA.cargo[i];
  const before = G.market[i];
  while (G.accum[i] <= -100 * c.rise && G.market[i] < c.high) {
    G.market[i] += 1; G.accum[i] += 100 * c.rise;
  }
  while (G.accum[i] >= 100 * c.fall && G.market[i] > c.low) {
    G.market[i] -= 1; G.accum[i] -= 100 * c.fall;
  }
  // @PRICEUP/@PRICEDOWN fire from the drift fn itself (func_0305A8, RULINGS
  // 2026-06-19), so BOTH movement paths announce: the end-of-turn recompute
  // (func_036574 @0x367FC) and the single-good re-drift after a buy/sell
  // (@0x32902/@0x32D99). Live frames wear MSS2 with the good + number
  // hilited (SESSION_UI_CATALOG frames 1310280609..). FLAGGED reading: the
  // announced number is the port's bid (sell) price -- whether the engine
  // prints bid or ask is unread.
  if (G.market[i] !== before && G.eventQueue)
    showEvent(G.market[i] > before ? 'PRICEUP' : 'PRICEDOWN',
              { STRING0: c.name, STRING1: DATA.nations[G.nation].homeport,
                NUMBER0: G.market[i] });
}
function driftMarket() {
  DATA.cargo.forEach((c, i) => { G.accum[i] += c.attrition; stepPrice(i); });
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
  const gross = G.market[i] * qty;
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
  G.accum[i] += qty << DATA.cargo[i].volatility;
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
  G.accum[i] -= qty << DATA.cargo[i].volatility;
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
const EURO_DOCK = { x: 232, y: 137, pitch: 14 };
const EURO_SHIP = { x: 145, y: 145, pitch: 12 };
function drawEurope(ctx) {
  usePalette('EUROPE');
  ctx.drawImage(IMG.EUROPE, 0, 0);
  const [tw2] = frameSize('WOODTILE', 0);
  ctx.save(); ctx.beginPath(); ctx.rect(0, 0, W, 8); ctx.clip();
  for (let x = 0; x < W; x += tw2) sheetFrame(ctx, 'WOODTILE', 0, x, 0);
  ctx.restore();
  const n = DATA.nations[G.nation];
  const band = `${n.homeport}, ${n.country}. ${DATA.seasons[G.season]}, ${G.year}.` +
               `  Tax:${G.tax}%  Gold: ${G.gold}$`;
  FONT.tiny.center(ctx, band, 160, 1, lut(HUD_INK));

  // Market bar: icons centred on 9+19i at y=181, bid/ask at y=194.
  DATA.cargo.forEach((g, i) => {
    const [fw] = frameSize('ICONS', 0x16 + i);
    sheetFrame(ctx, 'ICONS', 0x16 + i, 9 + 19 * i - (fw >> 1), 181);
    FONT.tiny.center(ctx, `${G.market[i]}/${askPrice(i)}`, 9 + 19 * i, 194, lut(0x2F));
    if (i === G.marketSel) hollowRect(ctx, 19 * i, 179, 19, 21, 0x0E);
  });

  // Panels. "Expected Soon" lists crossings inbound to Europe, "Bound For" the
  // ones outbound, "Loading" the ship at the dock and its hold.
  //
  // A crossing draws as the same 18x18 hollow green cell the piers use, the
  // ship's ICON inside at +(3,1), with the engine's sail-progress bar under it
  // -- func_031366's bar is `0x64 >> state` px wide (@0x0313A4), state = turns
  // still to sail (3..1), so the bar grows as the ship closes in. The band
  // y=146/137/132 by state is byte-read (func_031298 @0x031298); the port
  // keeps the entries stacked inside its own panel columns instead, flagged.
  const crossingCell = (e, x, y) => {
    hollowRect(ctx, x, y, 18, 18, 0x0A);
    sheetFrame(ctx, 'ICONS', e.icon, x + 3, y + 1);
    const s = Math.max(1, Math.min(3, e.turns || 1));
    ctx.fillStyle = lut(0x0A);
    ctx.fillRect(x, y + 19, Math.min(48, 0x64 >> s), 2);
  };
  FONT.tiny.draw(ctx, 'Expected Soon', 16, 120, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toEurope').slice(0, 2).forEach((e, k) =>
    crossingCell(e, 16 + k * 24, 128));
  // While a ship is being dragged, the Bound For panel lights up as the drop
  // target (engine region 2, rect @0x32094; the highlight itself is port UI).
  if (G.drag && G.drag.kind === 'ship' &&
      hit(PTR.x, PTR.y, { x: 72, y: 118, w: 70, h: 51 }))
    hollowRect(ctx, 72, 118, 70, 51, 0x0F);
  FONT.tiny.draw(ctx, 'Bound For', 87, 120, lut(HUD_INK));
  FONT.tiny.draw(ctx, DATA.regionname[G.nation], 87, 127, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toNewWorld').slice(0, 2).forEach((e, k) =>
    crossingCell(e, 87 + k * 24, 135));

  const ship = activeShip();
  FONT.tiny.draw(ctx, ship ? 'Loading:' : 'No Ships In Port', 150, 120, lut(HUD_INK));
  if (ship) FONT.tiny.draw(ctx, ship.type, 186, 120, lut(HUD_INK));

  // Dock units and ships in port, REBUILT 2026-08-06 from the live frame
  // (docs/screens/live_2026-08-05/30_europe.png). Both are drawn the same way:
  // an 18x18 hollow rect in GREEN 0x0A with the unit's own sprite inside.
  // Measured there:
  //   dock slot 0   box (232,137)-(249,154), ICONS frame 102 at (235,138)
  //   ship slot 0   box (145,145)-(162,162), ICONS frame   5 at (149,146)
  // so the sprite sits at box + (3, 1), the extra pixel on the ship being its
  // own 13px width against the unit's 8. The port had been drawing a nation
  // plate for dock units and a fixed crate sprite for ships, and no box at all.
  //
  // The frame has ONE ship and ONE dock unit, so the SLOT PITCH is unmeasured;
  // the port keeps its previous 14 (units) and 12 (ships) rather than inventing
  // new numbers, and a capture with several of each would settle it.
  G.dockUnits.slice(0, 6).forEach((e, k) => {
    const u = unit(entryType(e)) || unit('Colonists');
    const x = EURO_DOCK.x + k * EURO_DOCK.pitch;
    sheetFrame(ctx, 'ICONS', u.icon, x + 3, EURO_DOCK.y + 1);
    hollowRect(ctx, x, EURO_DOCK.y, 18, 18, 0x0A);
  });
  shipsInPort().forEach((e, k) => {
    if (k >= 6) return;
    const x = EURO_SHIP.x + k * EURO_SHIP.pitch;
    sheetFrame(ctx, 'ICONS', e.icon, x + 3, EURO_SHIP.y + 1);
    // Every harbour ship wears the green cell; the SELECTED one flips to
    // yellow -- the same 0x0A/0x0E runtime pair the market cell uses
    // ([0x9E12]-driven; the one-ship captures cannot split the two rules,
    // so the pairing is the port's reading).
    hollowRect(ctx, x, EURO_SHIP.y, 18, 18, k === G.euroShip ? 0x0E : 0x0A);
  });

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
  if (ship) {
    const holds = Number((unit(ship.type) || {}).cargo) || 0;
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
    hollowRect(ctx, 281, y, 37, 9, k === G.euroRow ? 0x0F : 0x7D);
    const w = FONT.tiny.width(r), x0 = 281 + (37 - w) / 2;
    FONT.tiny.draw(ctx, r[0], x0, y + 2, lut(0x0E));
    FONT.tiny.draw(ctx, r.slice(1), x0 + FONT.tiny.width(r[0]), y + 2, lut(0x10));
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

// ---- the Europe dock-unit menu: GAME @EUROPEARM + @ARMOPTIONS -------------
// The 12 @ARMOPTIONS rows are grep-verified GAME.TXT (spec/ui/context_dialogs.md
// §4); the quantities are the manual's (GAME_MANUAL.md 1962-1971: 50 muskets,
// 50 horses, 50+50 for a dragoon; tools cap 100 = the Pioneer's UnitRecord
// +0x15 start). Which rows the engine SHOWS per unit state is unread, so the
// port offers the applicable ones -- its own gating, flagged as such. Prices
// are the live market: buying charges the ask (buyGoods), selling returns the
// bid less tax (sellGoods), both moving the price like any other trade.
const EQUIP_MUSKETS = 50, EQUIP_HORSES = 50, EQUIP_TOOLS = 100;
// type -> type under each equip/unequip verb.
const ARM_VERBS = [
  { rowFmt: 'Arm with Muskets (costs %N$).', good: GOOD.MUSKETS, qty: EQUIP_MUSKETS,
    buy: true, map: { Colonists: 'Soldiers', Scouts: 'Dragoons' } },
  { rowFmt: 'Sell Muskets (save %N$).', good: GOOD.MUSKETS, qty: EQUIP_MUSKETS,
    buy: false, map: { Soldiers: 'Colonists', Dragoons: 'Scouts' } },
  { rowFmt: 'Equip with Tools (costs %N$).', good: GOOD.TOOLS, qty: EQUIP_TOOLS,
    buy: true, map: { Colonists: 'Pioneers' } },
  { rowFmt: 'Sell Tools (save %N$).', good: GOOD.TOOLS, qty: EQUIP_TOOLS,
    buy: false, map: { Pioneers: 'Colonists' } },
  { rowFmt: 'Equip with Horses (costs %N$).', good: GOOD.HORSES, qty: EQUIP_HORSES,
    buy: true, map: { Colonists: 'Scouts', Soldiers: 'Dragoons' } },
  { rowFmt: 'Sell Horses (save %N$).', good: GOOD.HORSES, qty: EQUIP_HORSES,
    buy: false, map: { Scouts: 'Colonists', Dragoons: 'Soldiers' } },
];
function dockUnitRows() {
  const e = G.dockUnits[G.euroDockSel];
  if (e === undefined) return [];
  const t = entryType(e);
  const rows = [];
  // @ARMOPTIONS row 0/1: the auto-board flag. A dock unit boards the next
  // ship that sails UNLESS it is held back; both rows always show so you can
  // set either state (the engine offers the pair -- func_04B308 family).
  if (e && e.noBoard) rows.push({ label: 'Board next ship.', act: 'board' });
  else rows.push({ label: "Don't get on next ship.", act: 'noboard' });
  rows.push({ label: 'Move to front of dock.', act: 'front' });
  for (const v of ARM_VERBS) {
    const to = v.map[t];
    if (!to) continue;
    const price = v.buy ? askPrice(v.good) * v.qty
                : Math.floor(G.market[v.good] * v.qty * (100 - G.tax) / 100);
    rows.push({ label: v.rowFmt.replace('%N', String(price)),
                act: 'arm', verb: v, to,
                dim: v.buy && (price > G.gold || isBoycotted(v.good)) });
  }
  if (t === 'Colonists') rows.push({ label: 'Bless as Missionaries.', act: 'bless' });
  if (t === 'Missionaries') rows.push({ label: 'Cancel Missionary Status.', act: 'unbless' });
  rows.push({ label: 'No changes.', act: 'close' });
  return rows;
}
// The Europe harbour ship menu: GAME @EUROPESHIPCLICK + @EUROPESHIPOPTIONS
// ("Move to front. / Set sail for the New World. / Unload all cargo. / No
// changes.") -- both grep-verified (spec/ui/context_dialogs.md §4). "Unload"
// in Europe means selling: the market is the only place cargo can go.
function euroShipRows() {
  return [
    { label: 'Move to front.', act: 'shipfront' },
    { label: 'Set sail for the New World.', act: 'sail' },
    { label: 'Unload all cargo.', act: 'sellall' },
    { label: 'No changes.', act: 'close' },
  ];
}

// The three sub-menus. Each is a plaque list: rows of "<label> <price>" with
// the affordable ones lit and the rest dimmed.
function euroMenuRows() {
  if (G.euroMenu === 'recruit')
    return G.dock.map(c => ({ label: c.name, cost: DATA.classes[c.band].cost }));
  // TRAIN lists every @JOB row with a real europe_value -- all 17 of them -- in
  // price order, cheapest first.
  if (G.euroMenu === 'train')
    return DATA.jobtrain.map(j => ({ label: j.expert, cost: j.cost }))
                        .sort((a, b) => a.cost - b.cost);
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
  for (const l of body) cw = Math.max(cw, FONT.tiny.width(l));
  for (const r of rows)
    cw = Math.max(cw, FONT.tiny.width(r.label) +
                      (r.cost === undefined ? 0 : FONT.tiny.width(`${r.cost}$`)) + 20);
  const w = cw + 6;
  const textH = body.length * 6;
  const h = 6 + textH + 3 + rows.length * 8 + 3;
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
  b.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * 6, 0xFE, 0xFC));
  const seed = b.y + 6 + b.textH + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * 8;
    const sel = k === G.euroMenuRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, 8); }
    // Unaffordable rows are DIMMED, not blacked out -- they still have to be
    // readable so you can see what you are saving up for. Action rows (the
    // harbour context menus) carry their price inside the label and dim on
    // their own `dim` flag instead.
    const afford = r.cost === undefined ? !r.dim : r.cost <= G.gold;
    const inkIdx = !afford ? 0x5D : (sel ? 0xFC : 0xFE);
    FONT.tiny.draw(ctx, r.label, b.x + 9, y + 1, lut(inkIdx));
    if (r.cost !== undefined) {
      const c = `${r.cost}$`;
      FONT.tiny.draw(ctx, c, b.x + b.w - 8 - FONT.tiny.width(c), y + 1, lut(inkIdx));
    }
  });
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
function sellFromShip(i) {
  if (i < 0) return;
  const ship = activeShip();
  if (!ship) { G.euroMsg = 'No ships in port.'; return; }
  if (isBoycotted(i)) {
    // Interactive sell of a boycotted good = the @KISSUP back-tax dialog
    // (byte-verified: sell handler @0x415A6 -> lift dialog @0x415B5; amount
    // = sell_price x 500 @0x333AF; pay -> treasury-, king's fund+, bit
    // cleared @0x3340C..0x33423; can't afford -> not lifted @0x333DD, the
    // @KISSSORRY shortfall). Row 2 pays.
    const tax = G.market[i] * 500;
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
  const qty = holdQty(ship, i);
  if (!qty) { G.euroMsg = `No ${DATA.cargo[i].name} aboard.`; return; }
  const net = sellGoods(i, qty);
  holdAdd(ship, i, -qty);
  G.euroMsg = `Sold ${qty} ${DATA.cargo[i].name} for ${net}$` +
              (G.tax ? ` (${G.tax}% tax)` : '');
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
      for (const h of (ship.hold || []).slice()) sellFromShip(h.good);
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
  if (G.euroMenu === 'dockunit' || G.euroMenu === 'ship') { euroContextCommit(r); return; }
  if (r.cost > G.gold) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
  G.gold -= r.cost;
  if (G.euroMenu === 'recruit') {
    // Recruits and trainees wait ON THE DOCK until a ship carries them over.
    G.dockUnits.push(r.label);
    G.dock[G.euroMenuRow] = rollImmigrant();
    G.euroMsg = `${r.label} recruited.`;
  } else if (G.euroMenu === 'train') {
    G.dockUnits.push(r.label);
    G.euroMsg = `${r.label} trained.`;
  } else {
    const buy = PURCHASE_CATALOG[G.euroMenuRow];
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
function adjustTension(tribe, delta) {
  const t = G.tribes[tribe];
  if (!t) return;
  // France, and Pocahontas, halve anger.
  if (delta > 0 && (G.nation === 1 || G.fathersOwned.includes('Pocahontas')))
    delta = Math.floor(delta / 2);
  t.tension = Math.max(0, Math.min(TENSION_WAR, t.tension + delta));
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
    sites.forEach(([sx, sy], k) => {
      const x = sx + TRIBE_SITE_DX, y = sy + TRIBE_SITE_DY;
      if (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) return;
      // mission: null, or {power, expert} -- the engine's settlement +0x05
      // byte, low nibble = owning power, bit 0x10 = expert (Jean de Brebeuf).
      // The CAPITAL is @LEVELS row 4 and carries the bigger growth cap; which
      // site is the capital is not in TRIBE.TXT, so the port takes the tribe's
      // first listed site. Flagged.
      // Starting population is likewise not in the evidence -- villages open at
      // their target size (func_046DE0: 2*level+3, capital 3*level+4), which is
      // where a long-settled village would already sit.
      const v = { x, y, tribe: ti, name: t.name, level: t.level,
                  alarm: t.tension, mission: null, tributePaid: false,
                  capital: k === 0, growth: 0, taught: false, chiefSeen: false,
                  braveOwed: false, pop: 1 };
      v.pop = settlementCap(v);
      G.villages.push(v);
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
// The sell offer, §19.5:
//   mood = random(1..5)
//   base = 6 raw / 7 manufactured, plus per-good colour
//   seed = 2*(base - difficulty - want + mood + 4)
//   offer = max(1, (max(0, seed*demand) + 5*mood) * qty/100 / 2)
// want is the village's interest rank in the good, halved once its stock
// reaches 20 and forced to 0 for muskets and horses.
function villageOffer(v, good, qty) {
  const t = G.tribes[v.tribe];
  const demand = villageDemand(v)[good] || 0;
  const mood = 1 + Math.floor(Math.random() * 5);
  let base = MANUFACTURES.includes(good) || good >= 13 ? 7 : 6;
  if (good === 4) base -= Math.floor(Math.random() * 8);              // Furs
  if (good === 15) base += 12 - (t.musketsKnown || 0);                // Muskets
  if (good === 8) base += 10 - (t.horsesKnown || 0);                  // Horses
  if (good === 13) base += 1;                                        // Trade Goods
  const stock = (v.stock && v.stock[good]) || 0;
  let want = Math.min(8, Math.floor(demand / 4));
  if (stock >= 20) want = Math.floor(want / 2);
  if (good === 15 || good === 8) want = 0;
  const seed = 2 * (base - G.difficulty - want + mood + 4);
  return Math.max(1, Math.floor((Math.max(0, seed * demand) + 5 * mood) * qty / 100 / 2));
}
// Selling cools the village directly -- alarm drops by the quantity and a full
// 100-load zeroes it -- and muskets or horses ARM the tribe: +1 lore at 25
// units, +2 at 50, with horses also adding a quarter of the load to the herd.
// A -4 tension credit rides along.
function villageSell(v, good, qty, price) {
  const t = G.tribes[v.tribe];
  // The haggle loop passes the negotiated price; a bare call takes the quote.
  const paid = price !== undefined ? price : villageOffer(v, good, qty);
  G.gold += paid;
  v.stock = v.stock || DATA.cargo.map(() => 0);
  v.stock[good] += qty;
  // TWO separate credits, and they land on the two separate meters:
  //   * the TRIBE's tension meter takes the flat -4 goodwill credit (@0x5C41E);
  //   * the VILLAGE's alarm word drops by the QUANTITY sold, and a full 100-load
  //     zeroes it outright (RULINGS.md 2026-08-01 native-economy pass, item 8).
  v.alarm = qty >= 100 ? 0 : Math.max(0, (v.alarm || 0) - qty);
  adjustTension(v.tribe, -4);
  if (good === 15) t.musketsKnown = (t.musketsKnown || 0) + (qty >= 50 ? 2 : qty >= 25 ? 1 : 0);
  if (good === 8) {
    t.horsesKnown = (t.horsesKnown || 0) + (qty >= 50 ? 2 : qty >= 25 ? 1 : 0);
    t.herd = (t.herd || 0) + Math.floor(qty / 4);
  }
  return paid;
}
// §19.5 buying -- the village prices its own goods the other way up:
//   ask = 200, or (8 - tribe.level)*50 for horses and manufactures
//   for silver and better: + market price * (2*difficulty + 15)
//   price = max(50, qty*ask/100 + (difficulty + random(0..2))*10)
//           + random(0..ask) - 4*(village surplus) + 4*(tribe tension)
function villageAsk(v, good, qty) {
  const t = G.tribes[v.tribe];
  let ask = (good === 8 || MANUFACTURES.includes(good)) ? (8 - t.level) * 50 : 200;
  if (good >= 7) ask += G.market[good] * (2 * G.difficulty + 15);
  let price = Math.max(50, Math.floor(qty * ask / 100) +
                          (G.difficulty + Math.floor(Math.random() * 3)) * 10);
  price += Math.floor(Math.random() * (ask + 1));
  price -= 4 * ((v.stock && v.stock[good]) || 0);
  price += 4 * t.tension;
  return Math.max(50, price);
}
// What the village will part with: the goods its land yields a surplus of.
function villageSurplus(v) {
  const d = villageDemand(v);
  return d.map((n, i) => ({ good: i, qty: Math.min(100, n * 5) }))
          .filter(r => r.qty >= 25 && RAW_GOODS.includes(r.good))
          .slice(0, 3);
}
function villageBuy(v, good, qty, price) {
  if (price === undefined) price = villageAsk(v, good, qty);
  if (price > G.gold) return 0;
  G.gold -= price;
  v.stock = v.stock || DATA.cargo.map(() => 0);
  v.stock[good] = Math.max(0, (v.stock[good] || 0) - qty);
  // (No tension credit here: the byte-cited -4 trade credit @0x5C41E is the
  // SELL side's; the -2 this used to apply was the port's invention.)
  return price;
}

// A gift cools anger faster than a sale (manual-attested; the exact credit is
// untraced, so the port uses twice the sale credit and says so).
function villageGift(v, good, qty) {
  v.stock = v.stock || DATA.cargo.map(() => 0);
  v.stock[good] += qty;
  adjustTension(v.tribe, -8);
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
const CONVERT_FAITH = 8;                 // turns before loss of faith
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
    if (Math.floor(Math.random() * 16) >= conversionThreshold(v)) continue;
    // "created at the colony" -- the handler is passed a ColonyRecord's map_x /
    // map_y / owner, so the convert appears on a colony tile. The port picks the
    // colony nearest the village.
    const c = G.colonies.slice().sort((a, b) =>
      (Math.abs(a.x - v.x) + Math.abs(a.y - v.y)) - (Math.abs(b.x - v.x) + Math.abs(b.y - v.y)))[0];
    const u = mkUnit('Colonists', c.x, c.y);
    u.profession = CONVERT_CLASS;
    u.faith = CONVERT_FAITH;
    G.units.push(u);
    showEvent('INDIANSCONVERT', { STRING0: c.name });
  }
}
// "Converts who do not join colonies within eight turns of their conversion are
// eliminated for loss of faith" (@DEADCONVERTS). Joining a colony is what
// clears the timer -- a convert standing on the map keeps counting down.
function ageConverts() {
  let lost = 0;
  for (let i = G.units.length - 1; i >= 0; i--) {
    const u = G.units[i];
    if (u.profession !== CONVERT_CLASS || u.faith === undefined) continue;
    u.faith -= 1;
    if (u.faith > 0) continue;
    G.units.splice(i, 1);
    lost += 1;
  }
  if (lost) {
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
    showEvent('DEADCONVERTS', {});
  }
}

// --------------------------------------------- what the natives demand of you
// §19.8. War-footing tribes press claims, and the land/road objections carry a
// BUY-OFF row: pay the named compensation and the tribe withdraws it. Peter
// Minuit in Congress zeroes every land payment.
//   @INDIANGOLD   reparations in gold        (trigger and amount untraced)
//   @INDIANWAGONS the contents of a wagon train passing through their land
//   @INDIANCITY   goods from a colony's stores
//   @INDIANROAD   an objection to a road, with its compensation row
// The triggers and amounts are NOT traced -- the manual names the claims and
// their texts, not their numbers -- so the port fires them off the tribe's own
// tension and prices them off the demand it is making. Flagged.
function nativeDemands() {
  if (!G.colonies.length) return;
  for (const t of G.tribes) {
    if (!t || t.dead) continue;
    G.eventTribe = G.tribes.indexOf(t);
    if ((t.tension || 0) < TENSION_HOSTILE) continue;
    if (Math.floor(Math.random() * 24) !== 0) continue;   // rare, per tribe, per turn
    const ti = G.tribes.indexOf(t);
    // A wagon train in their country is the easiest claim to press.
    const wagon = G.units.find(u => u.type === 'Wagon Train' && (u.hold || []).length &&
      G.villages.some(v => v.tribe === ti && Math.abs(v.x - u.x) <= 3 && Math.abs(v.y - u.y) <= 3));
    if (wagon) {
      const h = wagon.hold[0];
      askEvent('INDIANWAGONS', { STRING0: DATA.nations[G.nation].adjective,
                                 STRING1: t.name, STRING2: DATA.cargo[h.good].name,
                                 NUMBER0: h.qty }, (choice) => {
        // Row 0 hands them over, row 1 circles the wagons.
        if (choice === 0) { holdAdd(wagon, h.good, -h.qty); adjustTension(ti, -10); }
        else adjustTension(ti, 15);
      });
      return;
    }
    // Otherwise: goods from a colony's stores, or gold in reparations.
    const c = G.colonies[Math.floor(Math.random() * G.colonies.length)];
    const stocked = c.stock.map((n, i) => [n, i]).filter(r => r[0] >= 20)
                     .sort((a, b) => b[0] - a[0])[0];
    if (stocked) {
      const qty = Math.min(stocked[0], 20 + 10 * G.difficulty);
      askEvent('INDIANCITY', { STRING0: DATA.nations[G.nation].adjective,
                               STRING1: t.name, STRING2: DATA.cargo[stocked[1]].name,
                               STRING3: c.name, NUMBER0: qty }, (choice) => {
        // Row 0 mans the stockade, row 1 hands them over.
        if (choice === 1) { c.stock[stocked[1]] -= qty; adjustTension(ti, -10); }
        else adjustTension(ti, 15);
      });
      return;
    }
    const gold = demandValue(200);
    askEvent('INDIANGOLD', { STRING0: t.name, NUMBER0: gold }, (choice) => {
      // Row 0 refuses, row 1 pays.
      if (choice === 1 && G.gold >= gold) { G.gold -= gold; adjustTension(ti, -10); }
      else adjustTension(ti, 15);
    });
    return;
  }
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
    adjustTension(near.tribe, 10);
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
  {
    const t = G.tribes[v.tribe];
    const S = { STRING0: t ? t.name : '', STRING1: c.name,
                STRING3: DATA.nations[G.nation].adjective };
    switch (raidOutcome()) {
      case 1: {                                    // @RAIDSTORES
        const g = c.stock.map((n, i) => [n, i]).sort((a, b) => b[0] - a[0])[0];
        if (!g || !g[0]) { showEvent('RAIDNOTHING', S); break; }
        c.stock[g[1]] = 0;
        // "the village banks the haul" -- settlement raid-budget +0x08 and
        // wealth +0x0A += 0x19 (@0x5C3E1 / @0x5C3E4).
        v.stock = v.stock || DATA.cargo.map(() => 0);
        v.stock[g[1]] += g[0];
        v.wealth = (v.wealth || 0) + 0x19;
        showEvent('RAIDSTORES', { ...S, STRING2: DATA.cargo[g[1]].name });
        break;
      }
      case 2:                                      // @RAIDWREAK -- payload TBD
        showEvent('RAIDWREAK', S);
        break;
      case 3: {                                    // @RAIDGOLD -- amount TBD
        const take = Math.min(G.gold, Math.floor(G.gold / 4));
        G.gold -= take;
        showEvent('RAIDGOLD', { ...S, NUMBER0: take });
        break;
      }
      case 4: {                                    // @RAIDBURN / @RAIDSHIP
        const ship = G.units.find(u => u.ship && u.x === c.x && u.y === c.y);
        if (ship) { ship.damaged = true; showEvent('RAIDSHIP', { ...S, STRING2: ship.type }); break; }
        const burnable = c.buildings.filter(b => !STARTING_BUILDINGS.includes(b));
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
      if (d > 2) s -= 3 * d;
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
// Teaches OUTDOOR skills only: Expert Farmer, Fisherman, Fur Trapper, Silver
// Miner, the three Master Planters, Seasoned Scout -- @JOB rows 0..4, 7, 8, 22.
// Petty Criminals are refused, a colonist who already masters a profession is
// refused, and each village teaches exactly once. The roll is byte-cited:
//   learn succeeds when random_int(1,1000) >= 200*difficulty + 100
// = 90/70/50/30/10 % from Discoverer to Viceroy.
// WHICH skill a village offers is stored nowhere that has been mapped, so the
// port derives it from the site's coordinates -- deterministic, and flagged.
function villageSkill(v) {
  return OUTDOOR_JOBS[(v.x * 7 + v.y * 13) % OUTDOOR_JOBS.length];
}
function liveAmong(v, u) {
  const t = G.tribes[v.tribe];
  const job = villageSkill(v);
  const S = { STRING0: t.name, STRING1: DATA.jobs[job] };
  if (u.profession === 'Petty Criminals') { showEvent('LEARNCRIMINAL', S); return; }
  // @TEACHCONVERT: "Indian converts already know the Indian ways." -- the
  // convert refusal is its own key (training.md §Native learning), not the
  // generic @LEARNMASTER a convert would otherwise fall into.
  if (u.profession === CONVERT_CLASS) { showEvent('TEACHCONVERT', S); return; }
  if (u.profession && u.profession !== 'Free Colonists' &&
      u.profession !== 'Indentured Servants') {
    showEvent('LEARNMASTER', S); return;
  }
  if (v.taught) { showEvent('LEARNALREADY', S); return; }
  askEvent('LEARNSTAY', S, (choice) => {
    if (choice !== 0) { showEvent('LEARNLATER', S); return; }
    if (1 + Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100) {
      showEvent('LEARNSLOW', S);                    // unskilled -- may retry
      return;
    }
    v.taught = true;
    u.profession = DATA.jobexpert[job];
    showEvent('LEARNDONE', S);
  });
}

// --- r5 Ask to Speak With Chief ------------------------------------------
// Six documented arms. WHICH one fires is steered by a sub-mode argument whose
// selector is untraced (TBD), and the beads amount, the reveal radius and the
// taboo odds are all untraced too. The port rolls uniformly over the arms the
// village can actually offer and says so; a second audience at the same village
// gets the polite nothing.
function speakToChief(v, u) {
  const t = G.tribes[v.tribe];
  const S = { STRING0: t.name, STRING1: DATA.nations[G.nation].adjective };
  if (v.chiefSeen) { showEvent('CHIEFBORED', S); return; }
  v.chiefSeen = true;
  const arms = ['CHIEFHOWDY', 'CHIEFGUIDES', 'CHIEFAREA', 'CHIEFGIFT', 'CHIEFBORED'];
  // A tribe already on a war footing can execute the scout instead.
  if ((v.alarm || 0) >= ALARM_RAID) arms.push('CHIEFKILL', 'CHIEFKILL');
  const arm = arms[Math.floor(Math.random() * arms.length)];
  if (arm === 'CHIEFHOWDY') {
    // The briefing is built by sorting the village's live demand.
    const d = villageDemand(v);
    const top = d.map((n, i) => [n, i]).sort((a, b) => b[0] - a[0]).map(r => r[1]);
    showEvent('CHIEFHOWDY', { STRING0: t.treasure || DATA.cargo[top[0]].name,
                              STRING1: DATA.cargo[top[0]].name,
                              STRING2: DATA.cargo[top[1]].name,
                              STRING3: DATA.cargo[top[2]].name });
  } else if (arm === 'CHIEFGUIDES') {
    // "Guides to aid your passage" -- the scout gets its moves back.
    u.movesLeft = u.moves;
    showEvent('CHIEFGUIDES', { ...S, STRING1: DATA.levelname[v.level].toLowerCase() });
  } else if (arm === 'CHIEFAREA') {
    // The map-area reveal has nothing to reveal yet: this build draws the whole
    // map, with no fog model. The line still plays.
    showEvent('CHIEFAREA', S);
  } else if (arm === 'CHIEFGIFT') {
    // Beads amount untraced -- the port rolls a modest purse and flags it.
    const gold = 50 + Math.floor(Math.random() * 150);
    G.gold += gold;
    showEvent('CHIEFGIFT', { ...S, NUMBER0: gold });
  } else if (arm === 'CHIEFKILL') {
    const i = G.units.indexOf(u);
    if (i >= 0) { G.units.splice(i, 1); G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1)); }
    showEvent('CHIEFKILL', S);
  } else showEvent('CHIEFBORED', S);
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
  const target = G.rivals.find(r => r.met);
  if (!target) { notice('We have met no other power to incite them against.'); return; }
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
    adjustTension(v.tribe, 100);                    // an attack is an act of war
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
    G.msg = `The ${t.name} ${DATA.levelname[v.level].toLowerCase()} is destroyed. ${gold}$ in plunder.`;
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
  return line.replace(/%COUNTRY/g, DATA.nations[G.nation].country)
             .replace(/%(STRING|NUMBER)(\d)\$?/g, (m, kind, n) => {
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
const SPEAKER_NATIVE = /^(RAID|INDIAN|CHIEF|LEARN|EXTORT|VILLAGE|MISSION|HERESY|BURIAL|WHACK|EXTINCT|MADAT|DEADCONVERTS|BUY0|BUY1|BUYWHICH|TRADE0|TRADE1|TRADEWHICH|BADHAGGLE|BADCARGO|TRADENOCARGO|TRADENOWANT)/;
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
const SPEAKER_COLONY = /^(BUILT|NEWCOLONIST|CLEARCUT|USEDUPTOOLS|FOODLOW|FOOD\d|STARVE|SPOIL|NEEDTOOLS|WAREHOUSEFULL|CARGOREADY)/;
function eventSpeaker(key) {
  if (SPEAKER_MILITARY.test(key)) return 'MSS5';
  if (SPEAKER_KING.test(key)) return 'KING1';
  if (SPEAKER_NATIVE.test(key))
    return G.eventTribe >= 0 ? `IND${G.eventTribe % 8}A0` : null;
  if (SPEAKER_TRADE.test(key)) return 'MSS2';
  if (SPEAKER_SITE.test(key)) return 'MSS3';
  if (SPEAKER_DIPLO.test(key)) return 'MSS1';
  if (SPEAKER_COLONY.test(key)) return 'MSS0';
  return null;
}
// The speaker sits at the screen's bottom-right UNDER the plaque -- the same
// placement the village screen already uses for its chief portrait; the
// engine's own landing pixel is runtime cel state (§2.7.1), not a literal.
function drawSpeakerSheet(ctx, sheet) {
  if (!sheet) return;
  const [pw, ph] = frameSize(sheet, 0);
  if (pw) sheetFrame(ctx, sheet, 0, W - pw, H - ph);
}
function showEvent(key, subs, speaker) {
  const t = DATA.events[key];
  if (!t) return;
  G.eventQueue.push({ lines: t.body.map(l => fillTemplate(l, subs || {})),
                      width: t.width,
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
  const lines = wrapText(FONT.tiny, s, 180);
  const tail = G.eventQueue[G.eventQueue.length - 1];
  if (tail && !tail.speaker && tail.lines.join('\n') === lines.join('\n')) return;
  G.eventQueue.push({ lines, width: 190, speaker: null });
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
  // Continue anywhere in the EXE -- dismissal is any key/click or the modal
  // loop's 120-tick timeout (func_004A80 @0x4ADD), which blits nothing.
  let cw = e.width;
  for (const l of e.lines)
    cw = Math.max(cw, FONT.tiny.width(l.replace(/[{}]/g, '')) + 10);
  const w = cw + 6, h = 6 + e.lines.length * 6 + 3;
  const x = Math.round(160 - w / 2), y = Math.round(100 - h / 2);
  const ik = dialogInks();
  drawSpeakerSheet(ctx, e.speaker);
  plaque(ctx, x, y, w, h, 'WOODTILE');
  e.lines.forEach((l, i) => spanText(ctx, l, x + 5, y + 6 + i * 6, ik.base, ik.hi));
}

// Walking into a village opens the ten-row @ACTIONS menu (spec/ui/
// context_dialogs.md §6 -- func_04B308 is that table's only consumer).
function enterVillage(v, visitor) {
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
  const rows = [];
  rows.push({ id: hostile ? 1 : 0 });                       // r0 / r1, exclusive
  if (u && u.type === 'Missionaries' && !v.mission) rows.push({ id: 2 });
  if (v.mission && !mine) rows.push({ id: 3 });
  if (!hostile && u && u.type !== 'Scouts') rows.push({ id: 4 });
  if (u && u.type === 'Scouts') rows.push({ id: 5 });
  rows.push({ id: 6 });
  if (u && !u.ship) rows.push({ id: 7 });
  rows.push({ id: 8 });
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
  const cargo = ((u && u.hold) || []).filter(h => h.qty > 0);
  if (!cargo.length) { showEvent('TRADENOCARGO', {}, tradeSpeaker(v)); return; }
  tradeSellPick(v, u);
}
function tradeSellPick(v, u) {
  const cargo = ((u && u.hold) || []).filter(h => h.qty > 0);
  if (!cargo.length) { tradeBuyPhase(v, u); return; }
  if (cargo.length === 1) { tradeSellOffer(v, u, cargo[0]); return; }
  // @TRADEWHICH heads a picker built from the hold, like @PICKACARGO; its
  // engine trigger is unestablished (audit L83), so >1 cargo is the binding.
  askEvent('TRADEWHICH', {}, (k) => {
    if (k >= 0 && k < cargo.length) tradeSellOffer(v, u, cargo[k]);
    else tradeBuyPhase(v, u);
  }, cargo.map(h => `${h.qty} ${DATA.cargo[h.good].name}.`).concat(['Never mind.']),
     tradeSpeaker(v));
}
function tradeSellOffer(v, u, h) {
  const good = h.good, qty = h.qty, name = DATA.cargo[good].name;
  v.haggleSell = v.haggleSell || {};
  if (v.haggleSell[good]) {
    showEvent('BADHAGGLE1', { STRING0: name }, tradeSpeaker(v));
    tradeBuyPhase(v, u); return;
  }
  const demand = villageDemand(v)[good] || 0;
  // "A village never buys the same good twice in a row -- muskets excepted"
  // (settlement +0x08 last_bought); the steering trio is the sorted demand
  // top-3 (§10.4's reading of @BADCARGO's list, not byte-traced).
  if (v.lastBought === good && good !== 15) {
    const wantList = villageDemand(v).map((d, i) => [d, i])
      .filter(x => x[1] !== good).sort((a, b) => b[0] - a[0])
      .slice(0, 3).map(x => DATA.cargo[x[1]].name);
    showEvent('BADCARGO', { STRING0: name, STRING1: wantList[0] || '',
                            STRING2: wantList[1] || '', STRING3: wantList[2] || '' },
              tradeSpeaker(v));
    tradeBuyPhase(v, u); return;
  }
  if (demand <= 1) {
    showEvent('TRADENOWANT', { NUMBER0: qty, STRING0: name }, tradeSpeaker(v));
    tradeBuyPhase(v, u); return;
  }
  const want = Math.min(8, Math.floor(demand / 4));   // the port's want stand-in
  const rounds = Math.max(1, Math.min(3, Math.floor((demand - want + 4) / 10)));
  tradeSellRound(v, u, h, {
    offer: villageOffer(v, good, qty), round: 0,
    budget: 1 + Math.floor(Math.random() * rounds) + (qty >> 2),
  });
}
function tradeSellRound(v, u, h, st) {
  const good = h.good, qty = h.qty, name = DATA.cargo[good].name;
  const counter = st.offer + Math.max(1, st.offer >> 1);        // TBD stand-in
  // @TRADE0 rows: accept / fairer price / gift / never mind; @TRADE1 drops
  // the gift row. %STRING0 (the "some %STRING0 {goods}" modifier) has no
  // decoded source -- passed empty, flagged.
  askEvent(st.round === 0 ? 'TRADE0' : 'TRADE1',
           { STRING0: '', STRING1: name, NUMBER0: st.offer, NUMBER1: counter },
           (k) => {
    const giftRow = st.round === 0 ? 2 : -1;
    if (k === 0) {
      villageSell(v, good, qty, st.offer);
      holdAdd(u, good, -qty);
      v.lastBought = good;
      v.haggleBuy = false;
      tradeBuyPhase(v, u); return;
    }
    if (k === 1) {
      st.budget -= 10;                                          // TBD spend
      if (st.budget <= 0) {
        v.haggleSell[good] = true;
        showEvent('BADHAGGLE0', { STRING1: name }, tradeSpeaker(v));
        tradeBuyPhase(v, u); return;
      }
      st.offer += Math.max(1, (counter - st.offer) >> 1);       // TBD raise
      st.round += 1;
      tradeSellRound(v, u, h, st); return;
    }
    if (k === giftRow) {
      villageGift(v, good, qty);
      holdAdd(u, good, -qty);
      v.haggleBuy = false;
      tradeBuyPhase(v, u); return;
    }
    tradeBuyPhase(v, u);                                        // never mind
  }, undefined, tradeSpeaker(v));
}
function tradeBuyPhase(v, u) {
  if (v.haggleBuy) { showEvent('BADHAGGLE3', {}, tradeSpeaker(v)); return; }
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
  const qty = Math.min(r.qty, space);
  if (qty <= 0) return;
  const demand = villageDemand(v)[r.good] || 0;
  const want = Math.min(8, Math.floor(demand / 4));
  const rounds = Math.max(1, Math.min(3, Math.floor((demand - want + 4) / 10)));
  tradeBuyRound(v, u, r.good, qty, {
    quote: villageAsk(v, r.good, qty), round: 0,
    budget: 1 + Math.floor(Math.random() * rounds) + (qty >> 2),
  });
}
function tradeBuyRound(v, u, good, qty, st) {
  const counter = Math.max(1, Math.floor(st.quote * 3 / 4));    // TBD stand-in
  askEvent(st.round === 0 ? 'BUY0' : 'BUY1',
           { STRING0: DATA.cargo[good].name, STRING1: u.type, NUMBER0: st.quote,
             NUMBER1: counter, NUMBER2: qty, NUMBER3: G.gold },
           (k) => {
    if (k === 0) {
      if (st.quote > G.gold) { showEvent('NOTENOUGH', { NUMBER0: G.gold }, tradeSpeaker(v)); return; }
      villageBuy(v, good, qty, st.quote);
      u.hold = u.hold || [];
      holdAdd(u, good, qty);
      return;
    }
    if (k === 1) {
      st.budget -= 10;                                          // TBD spend
      if (st.budget <= 0) {
        v.haggleBuy = true;
        showEvent('BADHAGGLE2', {}, tradeSpeaker(v));
        return;
      }
      st.quote -= Math.max(1, (st.quote - counter) >> 1);       // TBD drop
      st.round += 1;
      tradeBuyRound(v, u, good, qty, st); return;
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
  for (const l of body) cw = Math.max(cw, FONT.tiny.width(l));
  for (const r of rows)
    cw = Math.max(cw, FONT.tiny.width(r.label) + FONT.tiny.width(r.note || '') + 20);
  const w = cw + 6, textH = body.length * 6;
  const h = 6 + textH + 3 + rows.length * 8 + 3;
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
  b.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * 6, 0xFE, 0xFC));
  const seed = b.y + 6 + b.textH + 3;
  b.rows.forEach((r, k) => {
    const y = seed + k * 8, sel = k === G.villageRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 3, y, b.w - 6, 8); }
    FONT.tiny.draw(ctx, r.label, b.x + 9, y + 1, lut(sel ? 0xFC : 0xFE));
    if (r.note) FONT.tiny.draw(ctx, r.note, b.x + b.w - 9 - FONT.tiny.width(r.note),
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
// Step 8 of §14.3 -- "a further doubling gated on game.difficulty, exact
// condition an open item" -- is NOT implemented: the condition is unknown, so
// applying it would be a guess.
function terrainDefence(v) {
  let t = v & 0x1F;
  if (t >= 16 && t <= 23) t = (t & 7) | 8;
  const d = DATA.defensive;
  const row = t <= 7 ? d.unforested[t] : t <= 15 ? d.forested[t - 8] : d.other[t - 24];
  return row || 0;
}
function defenceBonus(u) {
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
  // A hold going down is seized rather than simply lost.
  if ((loser.hold || []).length && loser.damaged) {
    const h = loser.hold[0];
    showEvent('CARGOCAPTURE', { STRING0: ownerAdjective(loser),
                                NUMBER0: h.qty, STRING1: DATA.cargo[h.good].name,
                                STRING2: ownerAdjective(winner), STRING3: winner.type });
    holdAdd(winner, h.good, h.qty);
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
    const key = (capKey === 'COLONISTCAPTURE' && veteranLost) ? 'COLONISTCAPTURE2' : capKey;
    showEvent(key, { STRING0: S.STRING0, STRING1: ownerAdjective(winner),
                     NUMBER0: (loser.treasure || 0) * 100 });
    return;
  }
  // THE DEMOTION LADDER.
  const down = DEMOTES_TO[loser.type];
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
    G.combat = { att: { type: att.type, icon: att.icon, ...AA },
                 def: { type: def.type, icon: def.icon, ...DD },
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
function rivalTurn() {
  for (const r of G.rivals) {
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
        G.colonies.splice(G.colonies.indexOf(target), 1);
        showEvent('BURNED', { STRING0: DATA.nations[r.nation].adjective,
                              STRING1: target.name });
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
    // The pick dialog cannot be cancelled; with no UI turn yet the port takes
    // the first candidate, which is the Trade category when one exists.
    G.fatherInProgress = cands[0].name;
  }
  const cost = fatherCost();
  if (G.bells < cost) return;
  G.bells -= cost;
  G.fathersOwned.push(G.fatherInProgress);
  G.msg = `${G.fatherInProgress} has joined the Continental Congress!`;
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
      if (u.profession === CONVERT_CLASS) { u.profession = 'Free Colonists'; delete u.faith; }
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
  const r = { name: name || routeName(stops), sea, stops: stops.slice(0, MAX_STOPS), cursor: 0 };
  G.routes.push(r);
  return r;
}
// One turn of automation for a unit running a route: sail or drive toward the
// current stop, and on arrival unload, load, and advance the cursor.
function runTradeRoute(u) {
  const r = G.routes[u.route];
  if (!r) { u.orders = 0; return; }
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
    // The engine gives every stop its own load list and unload list. This build
    // uses the simplest default that does not chase its own tail: the FIRST
    // stop loads, every other stop unloads. Loading at every stop would have a
    // wagon pick straight back up what it had just set down.
    u.hold = u.hold || [];
    const isOrigin = (u.stopIndex % r.stops.length) === 0;
    if (isOrigin) {
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
  if (t.mode === 'delete') {
    const r = G.routes.splice(row.id, 1)[0];
    for (const u of G.units) if (u.route === row.id) { u.route = undefined; u.orders = 0; }
    G.screen = 'map'; G.trade = null;
    G.msg = `Trade route "${r.name}" deleted.`;
    return;
  }
  // 'assign' -- put the selected unit on this route.
  const u = G.units[G.sel];
  G.screen = 'map'; G.trade = null;
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
  const head = t.mode === 'create'
    ? [fillTemplate(DATA.events.TRADESTART.body[0], { NUMBER0: t.stops.length + 1 }),
       t.stops.length ? `So far: ${t.stops.map(routeStopName).join(' - ')}` : '']
    : t.mode === 'delete' ? [DATA.events.TRADEDELETE.body[0]]
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
  const o = G.options;
  let cw = 190;
  for (const r of o.rows) cw = Math.max(cw, FONT.tiny.width(r) + 24);
  const w = cw + 6, h = 6 + 6 + 3 + o.rows.length * 8 + 3;
  const x = Math.round(160 - w / 2), y = Math.max(10, Math.round(100 - h / 2));
  plaque(ctx, x, y, w, h, 'WOODTILE');
  FONT.tiny.draw(ctx, o.title, x + 5, y + 6, lut(0xFC));
  const seed = y + 6 + 6 + 3;
  o.rows.forEach((label, k) => {
    const ry = seed + k * 8, sel = k === o.row;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(x + 3, ry, w - 6, 8); }
    // The checkbox itself: a 5x5 well with a tick when the option is on.
    hollowRect(ctx, x + 6, ry + 1, 6, 6, 0xFE);
    if (optionChecked(o.which, k)) {
      ctx.fillStyle = ink(0x0E);
      ctx.fillRect(x + 8, ry + 3, 2, 2);
    }
    spanText(ctx, label, x + 16, ry + 1, sel ? 0xFC : 0xFE, 0x0E);
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

// GAME "Retire": @RETIRE carries `@default=2`, so "No" is highlighted.
function retire() {
  askEvent('RETIRE', {}, (choice) => {
    if (choice !== 0) return;
    G.report = 'F10';
    G.screen = 'report';
    G.retired = true;
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
// FLAGGED READINGS (no byte cite exists): the MEEK/MANLY tone predicate
// (attitude >= 8 reused), PEACE-vs-OLDPEACE = standing treaty, the
// per-meeting topic priority, the withdraw/threat sub-branch selection, and
// the smite price (demandValue(1000) stand-in).
const meetingTone = (r) => (r.attitude === undefined ? 8 : r.attitude) >= 8;
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
  // B's gold extortion (@TRIBUTE -- and note ACCEPT IS ROW 2 in the text).
  if (!inGrace && !atWar(G.nation, r.nation) && gate()) {
    const want = demandValue(500);
    askEvent('TRIBUTE', { STRING0: DATA.diplotext.GREATLEADER[r.nation],
                          STRING1: DATA.nations[G.nation].adjective,
                          STRING2: DATA.regionname[r.nation], NUMBER0: want }, (k) => {
      if (k === 1) {
        if (G.gold < want) { showEvent('NOTENOUGH', { NUMBER0: G.gold }, myr); }
        else { G.gold -= want; r.gold = (r.gold || 0) + want; }
        meetingPeaceHub(r);
      } else if (gate()) {
        // The refusal-escalation ladder's exact rule is TBD; the action gate
        // decides whether the provocation turns to war.
        showEvent('PROVOKE', {}, myr);
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
  const key = haveTreaty(G.nation, r.nation)
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
  const base = G.year >= 1750 ? 9 : G.year >= 1700 ? 12 : G.year >= 1600 ? 15 : 18;
  return Math.max(2, base - (G.difficulty - 2));
}
// RAISE (func_034AE0, read instruction by instruction):
//   delta       = ((difficulty & 0xFE) << 1) + 4
//   turn_factor = (turn / 400) + 1
//   candidate   = delta * turn_factor
//   no demand if candidate + 5 >= tax; below candidate it also needs a
//   random_int(1, difficulty + 1) roll to come up non-1.
// The raise is applied to tax_pct and hard-clamped at 75 (func_034318 @0x03434F).
const TAX_CAP = 75;
function taxRaise() {
  const delta = ((G.difficulty & 0xFE) << 1) + 4;
  const turnFactor = Math.floor(G.turn / 400) + 1;
  return delta * turnFactor;
}
// PRETEXT (func_036138 @0x361CC..0x36221): a severity score picks which excuse
// the Crown gives, and it escalates with unrest, tax and treasure.
//   sev = random_int(1,1000) + (2*rebel_sentiment - tax)*5 + gold/100 + turn/30
// wedding < 0x28A, war < 0x3B6, Navigation Acts < 0x44C, else the Stamp Act.
function taxPretext() {
  const sev = 1 + Math.floor(Math.random() * 1000)
    + (2 * nationalSoL() - G.tax) * 5
    + Math.floor(G.gold / 100)
    + Math.floor(G.turn / 30);
  if (sev < 0x28A) return 'KINGWIFE';
  if (sev < 0x3B6) return 'KINGWAR';
  if (sev < 0x44C) return 'KINGNAVACT';
  return 'KINGSTAMPACT';
}
// The Crown addresses you by your difficulty rank -- [0x8394] is a 5-entry table
// of salutation strings, one per difficulty (RESOLVED 2026-06-20). @DIFFICULTY
// carries exactly those five names.
const kingSalutation = () => DATA.difficulty[G.difficulty];
function kingTaxDemand() {
  if (G.flags & WOI_DECLARED) return;              // no King to obey any more
  if (G.turn < 30 || G.tax > 85) return;
  if (G.turn % taxInterval() !== 0) return;
  const candidate = taxRaise();
  if (candidate + 5 >= G.tax) { /* the gate below still applies */ }
  if (G.tax <= candidate && 1 + Math.floor(Math.random() * (G.difficulty + 1)) === 1) return;
  const raise = Math.max(1, Math.min(TAX_CAP - G.tax, candidate));
  if (raise <= 0) return;
  // The good the Sons of Liberty would throw into the sea: the one your colonies
  // hold most of, which is what a Party costs you.
  const stock = DATA.cargo.map((_, i) =>
    G.colonies.reduce((n, c) => n + c.stock[i], 0));
  let good = 0;
  for (let i = 1; i < 16; i++) if (stock[i] > stock[good]) good = i;
  const party = DATA.cargo[good].name;
  const subs = { STRING0: kingSalutation(), STRING1: G.leader || DATA.nations[G.nation].leader,
                 STRING2: DATA.nations[G.nation].adjective, STRING3: party,
                 NUMBER0: raise, NUMBER1: G.tax + raise };
  askEvent(taxPretext(), subs, (choice) => {
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
// NOT REPRODUCED: the func_005DF0 gate. The port carries no owner/feature plane
// (the .MP loader discards it), and the plane's own identity is unresolved --
// spec/systems/events.md:187-192 calls it the tile feature nibble,
// tools/hillsrivers_render.py:195 calls it the continent-plane owner nibble.
// Consequence: rumours appear on some tiles the DOS game suppresses. TBD.
function rumourAt(x, y) {
  if (!G.mapSeed) return false;             // [0x190] == 0 disables them @0x6191
  const t = tileTerrain(at(x, y));
  // The engine gates on the classify thunk 0x3E4:0x3A, not on the raw id; the
  // two agree on every id the .MP loader can produce.
  if (t >= 0x18) return false;                     // Arctic, Ocean, Sea Lane
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
  }
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
    // There is no Declaration woodcut: @WOODCUT's 17 captions have none, and
    // 11/12 are COLONY BURNING / COLONY DESTROYED. So the declaration is the
    // popup alone.
    showEvent('INDEPENDENCE', { STRING0: G.leader || DATA.nations[G.nation].leader });
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
  let promoted = 0;
  for (const c of G.colonies) {
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
      budget -= 1; promoted += 1;
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
  }
  // Defeat: the King holds every colony. @KINGWIN is the Crown's own gloat --
  // @KINGVICTORY belongs to the European-war tax cut, not to this.
  if (!G.colonies.length && !(G.flags & WOI_WON) && !G.lostWar) {
    G.lostWar = true;
    showEvent('KINGWIN', { STRING0: DATA.nations[G.nation].country });
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
  else if (band > c.solBand) { showEvent('SONSUP', { STRING0: c.name, NUMBER0: c.sol }); c.solBand = band; }
  else if (band < c.solBand) { showEvent('SONSDOWN', { STRING0: c.name, NUMBER0: c.sol }); c.solBand = band; }
  if (c.sol >= 50 && !(c.latch & 0x04)) {
    c.latch |= 0x04; showEvent('REBELMAJORITY', { STRING0: c.name });
  }
  if (c.sol >= 100 && !(c.latch & 0x02)) {
    c.latch |= 0x02; showEvent('REBELUNANIMOUS', { STRING0: c.name });
  }
  if (c.sol < 95 && (c.latch & 0x02)) {
    c.latch &= ~0x02; showEvent('TORYMINORITY', { STRING0: c.name });
  }
  if (c.sol < 50 && (c.latch & 0x04)) {
    c.latch &= ~0x04; showEvent('TORYMAJORITY', { STRING0: c.name });
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
      l[l.length - 1] += `  ${g.name} ${G.market[i]}/${askPrice(i)}`;
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
// Column split is 8 / 9 / 10, which is @JOB's own grouping: 0..7 the field
// jobs (the eight that have yield columns), 8..16 the indoor trades, then the
// classes. TBD: the live frame shows 27 filled rows where @JOB has 28 entries
// plus a "Free Colonists" row -- the exact tail of the list is unresolved, so
// the grid simply stops when it runs out of entries rather than inventing any.
const F4_COLS = [2, 107, 212];
const F4_SPLIT = [8, 9, 10];
const F4_ICON_BASE = 81;
const F4_ROW0 = 26, F4_PITCH = 18;

function drawLaborReport(ctx) {
  const experts = DATA.jobexpert || [];
  let job = 0;
  for (let c = 0; c < F4_COLS.length; c++) {
    const base = F4_COLS[c];
    for (let row = 0; row < F4_SPLIT[c]; row++, job++) {
      const name = experts[job];
      if (!name) return;
      const y = F4_ROW0 + row * F4_PITCH;
      sheetFrame(ctx, 'ICONS', F4_ICON_BASE + job, base + 2, y - 2);
      FONT.tiny.draw(ctx, name, base + 12, y, lut(REPORT_NAME_INK));
      FONT.tiny.center(ctx, String(countProfession(job)), base + 39, y + 8,
                       lut(REPORT_VALUE_INK));
    }
  }
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
  gauge(ctx, 0x39 - 1, G.crosses, 0, immigrationThreshold(), 0x0A, 0x19, 0x12C, 1, 0, 0);
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
// The subtitle names a VIEW: @MISC 91 '(Building Upkeep)' / 92 'TOTAL UPKEEP'
// belong to a second page of this report that the capture did not reach, so
// only the European Trade view is drawn. TBD: how the view is switched.
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
  DATA.cargo.forEach((g, i) => {
    const y = F5_RULE0 + 2 + i * F5_PITCH;
    FONT.tiny.draw(ctx, g.name, 2, y, lut(REPORT_NAME_INK));
    const cells = [
      [String(europeTons(i)), REPORT_GREEN_INK],
      [`${f5Gold(europeGold(i))}$`, REPORT_GREEN_INK],
      [`${G.market[i]}$`, REPORT_VALUE_INK],
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
// The live frame prints 13K$/16K$/20K$ but 6071$ in full, so large values
// abbreviate; the exact threshold is unobserved between 6072 and 12999 --
// 10000 is the port's reading.
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
  const ships = G.units.filter(u => u.ship)
    .map(u => ({ u, loc: `(${u.x}, ${u.y})`, dest: '' }))
    .concat(G.europe.map(e => ({
      u: e,
      loc: DATA.nations[G.nation].homeport,
      dest: e.state === 'port' ? '' : (DATA.text.misc[10] || 'Bound For'),
    })));
  ships.slice(0, F7_PER_PAGE).forEach((s, i) => {
    const y = F7_ROW0 + i * F7_PITCH;
    const cu = unit(s.u.type);
    // Ship cell: the nation plate at the row's own x,y and the hull sprite
    // right-aligned in a 16-wide box, exactly as drawUnit places them on the
    // map. Measured on the 1653 frame: plate (2,42) 8x9, Merchantman (ICONS 6,
    // 13 wide) at x=5 and Galleon (ICONS 7, 14 wide) at x=4 -- i.e. 2+16-w.
    // The Frigate (ICONS 15, also 13 wide) sits at x=4 there, one pixel left of
    // what that rule predicts; unexplained, and left as the rule.
    nationPlate(ctx, 2, y, DATA.nations[G.nation].color, s.u.orders || 0);
    if (cu) {
      const [fw] = frameSize('ICONS', cu.icon);
      sheetFrame(ctx, 'ICONS', cu.icon, 2 + 16 - fw, y);
    }
    FONT.tiny.draw(ctx, s.u.type, 26, y + 6, lut(REPORT_VALUE_INK));
    // Cargo: one goods sprite per laden hold, ICONS frame 22 + commodity,
    // first at x=88 and pitch 12, y = row + 3 (template-matched at score 0 on
    // the Merchantman's two bales of furs).
    let cx = F7_CARGO_X;
    (s.u.cargo || []).forEach((c) => {
      const g = (c && c.good !== undefined) ? c.good : c;
      sheetFrame(ctx, 'ICONS', F7_CARGO_ICON + (typeof g === 'number' ? g : 0),
                 cx, y + 3);
      cx += F7_CARGO_PITCH;
    });
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
const F9_MUSKET_X = 152, F9_HORSE_X = 209;
// Seven blocks fill the plate (25 + 7*21 = 172, and the OK box starts at 184),
// which is why the 1653 frame stops at seven. The spec calls F9 "multi-page via
// paginator func_039E98"; that paginator is NOT wired up here, so an eighth
// contacted tribe would simply not be shown. TBD.
const F9_ICON_Y = 25, F9_ROW0 = 28, F9_PITCH = 21, F9_PER_PAGE = 7;
// ICONS 113..117 are five near-identical native portraits. The 1653 frame uses
// 116 for five of its seven rows, 115 for the Apache and 113 for the Sioux --
// no rule derivable from tribe index, tech level or settlement count, which is
// what an animation counter looks like. UNRESOLVED; 116 is the modal frame.
const F9_PORTRAIT = 116;
function drawIndianReport(ctx) {
  const black = [ink(0), ink(0), ink(0)];
  // Only tribes the player has actually run into appear. On the 1653 frame the
  // Dutch list seven of the eight -- Incas, Aztecs and Tupi are there marked
  // "Extinct", but the Iroquois are absent entirely, i.e. wiped-out-after-
  // contact is listed and never-contacted is not. The port has no contact
  // flag, so "has explored a tile holding one of that tribe's settlements"
  // stands in for it; that is the port's own rule and is flagged here.
  const listed = G.tribes
    .map((t, i) => [t, i])
    .filter(([, i]) => G.villages.some(v => v.tribe === i && isSeen(v.x, v.y)));
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
    const tk = lut(t.color);
    if (!n) {
      FONT.tiny.draw(ctx, `${t.name}: ${DATA.text.misc[130]}`, F9_NAME_X, y, tk);
      return;
    }
    FONT.tiny.draw(ctx, t.name + ':', F9_NAME_X, y, tk);
    FONT.tiny.right(ctx, lv.name, F9_LEVEL_RX, y, tk);
    FONT.tiny.draw(ctx, `${n} ${n === 1 ? lv.one : lv.many}`, F9_COUNT_X, y + 8, black);
    const muskets = tribeStock(i, 15), horses = tribeStock(i, 8);
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
  G.villages.reduce((n, v) => n + (v.tribe === ti && v.stock ? (v.stock[good] || 0) : 0), 0);
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
function immigrationThreshold() {
  let accum = G.colonies.reduce((n, c) => n + c.colonists.length, 0) + G.units.length;
  if (accum < 4000) accum *= 2;
  accum += 8;
  accum = Math.min(4000, accum);
  accum = Math.floor(accum * (8 - G.difficulty) / 8);
  if (G.nation === 0) accum = Math.floor(accum * 2 / 3);      // England
  return accum;
}
// Crosses now come from the production pass -- a Preacher in a Church makes
// them, exactly like any other indoor job -- plus the flat one per colony the
// engine grants regardless. The per-building cross rate is still not in the
// evidence, so the flat 1 stays a flagged placeholder.
function crossesPerTurn() {
  return G.colonies.reduce((n, c) => n + 1 + (c.crossesTurn || 0), 0);
}
function checkImmigration() {
  G.crosses += crossesPerTurn();
  const thr = immigrationThreshold();
  if (G.crosses < thr) return;
  G.crosses -= thr;
  // The arrival takes one of the three dock slots at random and that slot
  // refills from the generator.
  const slot = Math.floor(Math.random() * 3);
  G.dockUnits.push(G.dock[slot].name);
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
  // A restored mid-game has seen its first-time plates: mark the whole
  // shown-bitmask and every tribe as contacted. (The engine's own [0x540A]
  // word is in the save but its block index is unread -- TBD.)
  G.wcSeen = 0x3FFF;
  G.tribes.forEach(t => { t.met = true; });

  // Map planes: terrain verbatim; improvements masked to the road/plow bits
  // the port models; fog verbatim -- SEEN already uses the engine's own
  // 1<<(power+4) bit convention, so the plane drops straight in.
  const terr = d.subarray(planeBase, planeBase + plane);
  MAP.tiles.set ? MAP.tiles.set(terr) : MAP.tiles.splice(0, MAP.tiles.length, ...terr);
  for (let i = 0; i < plane; i++) IMPROVE[i] = d[planeBase + plane + i] & 0x48;
  // Plane 3's LOW NIBBLE is the region id (func_005D9C reads [0x164]) --
  // carried verbatim, replacing the flood-fill approximation.
  for (let i = 0; i < plane; i++) REGION[i] = d[planeBase + 2 * plane + i] & 0x0F;
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
  for (let i = 0; i < 16; i++) G.market.push(Math.max(1, d[pb + 0x4C + i]));
  // The whole-game net-trade counters the F5 report reads: +0xBC units,
  // +0x7C value (s32[16] each).
  G.tradeTons = []; G.tradeGold = [];
  for (let i = 0; i < 16; i++) {
    G.tradeTons.push(i32(pb + 0xBC + i * 4));
    G.tradeGold.push(i32(pb + 0x7C + i * 4));
  }

  // Tribes: level from the record's +0x02 byte ([0x5AD8], stride 0x4E) and
  // tension toward the player from the +0x46 per-power word (the 0x5B1C
  // table, RULINGS 2026-08-01).
  G.tribes.forEach((t, i) => {
    const tb = tribeBase + i * 0x4E;
    t.level = d[tb + 2];
    t.tension = Math.max(0, Math.min(100, u16(tb + 0x46 + nation * 2)));
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
      mission: m === 0xFF ? null : { power: m & 0x0F, expert: !!(m & 0x10) },
      alarm: d[b + 0x0A + nation * 2],
      tributePaid: false, taught: false, braveOwed: false,
    });
  }

  // Colonies -- ours in full, everyone else's as rival colonies.
  G.colonies = [];
  G.rivals = [];
  for (let n = 0; n < 4; n++) {
    if (n === nation) continue;
    G.rivals.push({ nation: n, met: true, attitude: 8,
                    gold: i32(powBase + n * 0x13C + 0x2A),
                    colonies: [], nextColony: 0, units: [] });
  }
  const rivalOf = (n) => G.rivals.find(r => r.nation === n);
  const CELL_OF_WORKER = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]];
  for (let i = 0; i < ncol; i++) {
    const b = colBase + i * 0xCA;
    const owner = d[b + 0x1A] & 3, pop = d[b + 0x1F];
    const name = str(b + 2, 24);
    const buildings = [];
    for (let k = 0; k < (DATA.buildings || []).length; k++)
      if (d[b + 0x60 + (k >> 3)] & (1 << (k & 7))) buildings.push(DATA.buildings[k].name);
    if (owner !== nation) {
      const r = rivalOf(owner);
      if (r) r.colonies.push({
        x: d[b], y: d[b + 1], nation: owner, name, pop, grow: 0,
        level: ['Fortress', 'Fort', 'Stockade'].findIndex(f => buildings.includes(f)) >= 0
          ? 3 - ['Fortress', 'Fort', 'Stockade'].findIndex(f => buildings.includes(f)) : 0,
      });
      continue;
    }
    const colonists = [];
    for (let k = 0; k < pop; k++) {
      const occ = d[b + 0x20 + k];
      colonists.push({ type: 'Colonists',
                       profession: SAV_PROFESSION(d[b + 0x40 + k]),
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
    const c = { name, x: d[b], y: d[b + 1], nation, colonists,
                stock: [], buildings, hammers: 0, building: null,
                sol: divisor > 0 ? Math.max(0, Math.min(100,
                     Math.round(100 * dividend / divisor))) : 0 };
    for (let k = 0; k < 16; k++) c.stock.push(u16(b + 0x9A + k * 2));
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
        const prof = SAV_PROFESSION(d[b + 0x17]);
        const entry = prof ? { name: prof, type: type.name } : type.name;
        const ship = G.units.find(s => s.ship && s.x === x && s.y === y);
        if (ship) ship.cargo.push(entry);
        else if (offMap) G.dockUnits.push(entry);
        continue;
      }
      const u = mkUnit(type.name, x, y);
      const prof = SAV_PROFESSION(d[b + 0x17]);
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
  // Ships parked at the off-map sentinel dock in Europe; their riders
  // disembark to the dock, the way an arriving crossing unloads.
  for (let i = G.units.length - 1; i >= 0; i--) {
    const u = G.units[i];
    if (u.x < MAP.w && u.y < MAP.h) continue;
    G.units.splice(i, 1);
    if (u.ship) {
      for (const p of (u.cargo || [])) G.dockUnits.push(p);
      G.europe.push({ type: u.type, icon: u.icon, hold: u.hold || [],
                      passengers: [], state: 'port' });
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
    G.openMenu = -1; G.dialog = null; G.colonyPopup = null; G.euroMenu = null;
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
  for (const u of G.units) u.movesLeft = u.moves;
  revealAll();
  payUpkeep();
  for (const c of G.colonies) colonyTurn(c);
  // @VANISH removals, deferred out of the loop above.
  if (G.colonies.some(c => c.vanished)) {
    G.colonies = G.colonies.filter(c => !c.vanished);
    G.colony = Math.max(0, Math.min(G.colony, G.colonies.length - 1));
  }
  // @REFIT: a damaged ship spending the turn in a port with repair
  // facilities is fixed. The manual: a Drydock/Shipyard "enables your colony
  // to repair any damaged ships" (the mother country always can). The
  // engine's repair TIMER is unread -- one full turn is the port's flagged
  // stand-in (u.damaged was previously never cleared at all).
  for (const u of G.units) {
    const home = u.ship && u.damaged && colonyAt(u.x, u.y);
    if (home && ['Drydock', 'Shipyard'].some(b => home.buildings.includes(b))) {
      u.damaged = false;
      showEvent('REFIT', { STRING0: u.type, STRING1: home.name });
    }
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
  rivalTurn();
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
      if (foe.tribe !== undefined) adjustTension(foe.tribe, 100);   // an act of war
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
        showEvent('CAPTURED', { STRING0: DATA.nations[G.nation].adjective,
                                STRING2: rc.name, NUMBER0: loot });
        u.movesLeft = 0; advance(); return;
      }
      G.msg = `The ${DATA.nations[rival.nation].adjective} colony holds.`;
      u.movesLeft = 0; advance(); return;
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
  for (let i = 1; i <= G.units.length; i++) {
    const k = (G.sel + i) % G.units.length;
    if (G.units[k].movesLeft > 0) { G.sel = k; centerOn(G.units[k].x, G.units[k].y); return true; }
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
  // A road cut near a settlement draws the tribe's objection, with its buy-off.
  if (n === ORDER_ROAD) roadObjection(u);
  advance();
}
// ORDERS "Return to Europe" (E) sends the selected ship home; VIEW "European
// Status" (also E, one level down) opens the harbour. E does both here: the
// ship is ordered home AND the harbour comes up, so the crossing is visible in
// the Bound For panel straight away.
function returnToEurope() {
  const u = G.units[G.sel];
  if (u && u.ship) {
    sailForEurope(u);
    G.euroMsg = `${u.type} sails for ${DATA.nations[G.nation].homeport}.`;
  }
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
  // Load a colony's stockpile into a ship sharing its tile.
  const u = G.units[G.sel];
  if (!u || !u.ship) { G.msg = 'Only a ship can load cargo.'; return; }
  const c = colonyAt(u.x, u.y);
  if (!c) { G.msg = 'No colony here.'; return; }
  u.hold = u.hold || [];
  let moved = 0;
  c.stock.forEach((q, i) => {
    if (q <= 0) return;
    const slot = u.hold.find(h => h.good === i);
    if (slot) slot.qty += q; else u.hold.push({ good: i, qty: q });
    moved += q; c.stock[i] = 0;
  });
  G.msg = moved ? `Loaded ${moved} goods.` : 'Nothing to load.';
}
function unloadCargo() {
  const u = G.units[G.sel];
  if (!u || !u.ship) { G.msg = 'Only a ship can unload cargo.'; return; }
  const c = colonyAt(u.x, u.y);
  if (!c) { G.msg = 'No colony here.'; return; }
  const doUnload = () => {
    let moved = 0;
    for (const h of (u.hold || [])) { c.stock[h.good] += h.qty; moved += h.qty; }
    u.hold = [];
    G.msg = moved ? `Unloaded ${moved} goods.` : 'Nothing to unload.';
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
  u.hold = [];
  G.msg = 'Cargo dumped overboard.';
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
  G.msg = `${u.type} disbanded.`;
  G.units.splice(G.sel, 1);
  G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
}
function findColony() {
  if (!G.colonies.length) { G.msg = 'No colonies yet.'; return; }
  G.colonyFind = ((G.colonyFind || 0) + 1) % G.colonies.length;
  const c = G.colonies[G.colonyFind];
  centerOn(c.x, c.y);
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
  'European Status': () => { G.screen = 'europe'; },
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
  'Edit Trade Route': () => openTradeMenu('assign'),
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
  'F8 Foreign Affairs Advisor': () => { G.report = 'F8'; G.screen = 'report'; },
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
}

function colonyPointerDown(mx, my, shift) {
  const c = G.colonies[G.colony];
  if (!c || G.colonyPopup) return;
  const region = colonyRegionAt(mx, my);
  // A colonist is HELD before it lifts: press, wait, then drag. Arm it now and
  // let onPointerMove/frame promote it once the deadline passes -- a quick
  // press and release stays a click, which is what selects him.
  if (region === 0) {
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
  if (G.dragArm && PTR.down && G.wallClock - G.dragArm.at >= DRAG_HOLD_MS) {
    const c = G.colonies[G.colony];
    const p = c && c.colonists[G.dragArm.colonist];
    if (p) {
      const u = unit(p.type) || unit('Colonists');
      beginDrag({ screen: 'colony', mode: 6, kind: 'unit', colonist: G.dragArm.colonist,
                  from: G.dragArm.from, srcRegion: G.dragArm.from === 'plaza' ? 0 : 1,
                  frame: dragGhostFrame('unit', 0, 0, u.icon) });
    } else G.dragArm = null;
  }
  // An open pulldown tracks the cursor while the button is held: the engine
  // re-hit-tests only when the moved flag is set (@0x6E5B1) and walks the row
  // rects (@0x6E5BB-0x6E667).
  if (G.screen === 'map' && G.openMenu >= 0 && PTR.down) {
    const row = menuRowAt(mx, my);
    if (row >= 0) G.menuSel = row;
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
  // the button is held (@0x6ECCF).
  if (G.screen === 'map' && G.openMenu >= 0 && PTR.moved) {
    const row = menuRowAt(mx, my);
    if (row >= 0) { G.menuSel = row; runMenuRow(); }
    else G.openMenu = -1;
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
      p.cell = null; p.job = null;
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
      const qty = Math.min(d.amount, c.stock[d.good], space);
      if (!qty) return;
      c.stock[d.good] -= qty;
      ship.hold = ship.hold || [];
      holdAdd(ship, d.good, qty);
      return;
    }
    if (target === 5 && d.srcKind === 0) {
      // Ship -> warehouse.
      if (!ship) return;
      const have = holdQty(ship, d.good);
      const qty = Math.min(d.amount, have);
      if (!qty) return;
      holdAdd(ship, d.good, -qty);
      c.stock[d.good] += qty;
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
      buyToShip(d.good, d.amount);
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
        if (hit(mx, my, { x: b.x + 3, y: seed + r * 8, w: b.w - 6, h: 8 })) {
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
        const b = colonyPopupBox(), seed = b.y + 6 + 6 + 3;
        for (let k = 0; k < b.rows.length; k++)
          if (hit(mx, my, { x: b.x + 3, y: seed + k * 8, w: b.w - 6, h: 8 })) {
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
            who.cell = [cx, cy];
            who.job = bestFieldJob(c, who);
          }
        }
        return;
      }
      // Plaza: click a colonist to select, click again for the jobs menu.
      if (c && hit(mx, my, { x: 0, y: 130, w: 120, h: 48 })) {
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
      // Dock: click a ship box to make it the one the hold row shows. Boxes
      // are the byte-cited 16x16 cells at x = 130 + 18k, y = 147 (see
      // drawColonyDock's citations).
      if (c) {
        const ships = colonyShips(c);
        for (let k = 0; k < Math.min(ships.length, 4); k++) {
          if (hit(mx, my, { x: COLONY_DOCK.shipX + k * COLONY_DOCK.shipPitch,
                            y: COLONY_DOCK.shipY, w: 16, h: 16 })) {
            G.colonyShipSel = k; return;
          }
        }
      }
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: VIEW_BTN.x, y: VIEW_BTN.y + k * VIEW_BTN.pitch,
                          w: VIEW_BTN.w, h: VIEW_BTN.h })) { G.colonyView = k; return; }
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
        for (let k = 0; k < b.rows.length; k++) {
          if (hit(mx, my, { x: b.x + 3, y: seed + k * 8, w: b.w - 6, h: 8 })) {
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
      // actually PAINTS (EURO_SHIP, 18x18 at pitch 12) -- the rect here used to
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
        // Clicking your own colony opens its screen; clicking a stack cycles
        // through the units standing on that tile.
        const ci = G.colonies.findIndex(c => c.x === tx && c.y === ty);
        const on = G.units.map((u, i) => i).filter(i => G.units[i].x === tx && G.units[i].y === ty);
        if (ci >= 0 && !on.length) { G.colony = ci; G.screen = 'colony'; }
        else if (on.length) G.sel = on[(on.indexOf(G.sel) + 1) % on.length];
        else centerOn(tx, ty);
      }
      break;
    }
  }
}

function commitMenu() {
  // Real dispatch ladder @0x075C6D: rows 0-2 all enter the new-game setup path;
  // 3 = LOAD Game (browser save / the shipped 1653 save / a .SAV off disk);
  // 4 = View Hall of Fame (not implemented).
  if (G.menuRow <= 2) G.screen = 'difficulty';
  else if (G.menuRow === 3) openLoadMenu();
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
      if (k === 'c' || k === 'C') { G.colonyPopup = 'build'; G.colonyPopupRow = 0; }
      // B = rush-buy the construction target (@BUYME0/1); E = the Custom
      // House export picker (@CUSTOM).
      if (k === 'b' || k === 'B') rushBuy();
      if (k === 'e' || k === 'E') customHouseMenu();
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
      if (k === 'Escape' || k === 'x' || k === 'e' || k === 'E') G.screen = 'map';
      break;
    }
    case 'map': {
      // An open pulldown owns the keyboard.
      if (G.openMenu >= 0) {
        const rows = DATA.menus[G.openMenu].rows;
        if (k === 'ArrowUp') G.menuSel = (G.menuSel + rows.length - 1) % rows.length;
        else if (k === 'ArrowDown') G.menuSel = (G.menuSel + 1) % rows.length;
        else if (k === 'ArrowLeft') openMenu((G.openMenu + DATA.menus.length - 1) % DATA.menus.length);
        else if (k === 'ArrowRight') openMenu((G.openMenu + 1) % DATA.menus.length);
        else if (k === 'Enter' || k === ' ') runMenuRow();
        else if (k === 'Escape') G.openMenu = -1;
        else if (k.length === 1) {
          // Accelerator: the "~" letter parsed from the MENU.TXT row.
          const K = k.toUpperCase();
          const i = rows.findIndex(r => r.accel === K);
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
        case 'p': case 'P': setOrder(8); break;
        case 'r': case 'R': setOrder(9); break;
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
  }
  requestAnimationFrame(frame);
}
let _frameErr = null;
function frameBody() {
  G.blink = (G.tick % 32) < 20;
  G.tick += 1;
  G.wallClock = performance.now();
  flushMapMsg();
  // A colonist armed on the down-edge lifts once the hold deadline passes, even
  // if the pointer is being held perfectly still -- so poll it here as well as
  // on move, the way the engine's per-frame dispatcher does.
  if (G.dragArm && PTR.down) onPointerMove(PTR.x, PTR.y);
  ctx.clearRect(0, 0, W, H);
  ({ title: drawTitle, difficulty: drawDifficulty, nation: drawNation,
     name: drawName, briefing: drawBriefing, cards: drawCards,
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
  window.addEventListener('keydown', onKey);
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
  cv.addEventListener('pointerdown', (ev) => {
    const [x, y] = toLogical(ev);
    PTR.down = true; PTR.right = ev.button === 2;
    PTR.x = PTR.downX = x; PTR.y = PTR.downY = y;
    PTR.moved = false;
    try { cv.setPointerCapture(ev.pointerId); } catch (_) { /* not all inputs */ }
    onPointerDown(x, y, PTR.right, ev.shiftKey);
  });
  cv.addEventListener('pointermove', (ev) => {
    const [x, y] = toLogical(ev);
    if (x === PTR.x && y === PTR.y) return;
    // One pixel counts as moved -- @0xD16F compares the poll-start snapshot
    // against the current position with no threshold at all.
    PTR.x = x; PTR.y = y;
    if (PTR.down) PTR.moved = true;
    onPointerMove(x, y);
  });
  cv.addEventListener('pointerup', (ev) => {
    const [x, y] = toLogical(ev);
    PTR.x = x; PTR.y = y;
    onPointerUp(x, y, PTR.right);
    PTR.down = false; PTR.right = false;
  });
  cv.addEventListener('pointercancel', () => { PTR.down = false; cancelDrag(); });
  // A right press cancels a drag, so the browser menu must not eat it.
  cv.addEventListener('contextmenu', (ev) => ev.preventDefault());
  cv.addEventListener('click', (ev) => {
    if (PTR.suppressClick) { PTR.suppressClick = false; return; }
    const [x, y] = toLogical(ev); onClick(x, y);
  });
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
    const bid = G.market[i];
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
    'parley', 'tribes', 'villages', 'natives', 'europe', 'dock', 'dockUnits',
    'euroShip', 'routes', 'marketSel', 'menuRow', 'briefPage', 'card', 'woodcut',
    'landHo', 'colonyView', 'colonyPopup', 'colonyPopupRow', 'colonistSel',
    'colonyShipSel',
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
