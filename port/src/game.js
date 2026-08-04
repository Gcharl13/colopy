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
const usePalette = (bg) => {
  if (_merged.has(bg)) { PAL = _merged.get(bg); return; }
  const base = DATA.palettes[bg] || DATA.palette;
  const uiPal = DATA.palettes.OPENMENU || DATA.palette;
  // Keep the backdrop's own scene colours, but patch any entry still holding a
  // magenta placeholder (WOODPANL and the LEVN cards leave 0xFC-0xFE unset)
  // from the picker palette, which carries the documented UI ink triplet.
  const out = base.map((c, i) => isPlaceholder(c) ? uiPal[i] : c);
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
  center(ctx, s, cx, y, lut, shadow) {
    this.draw(ctx, s, Math.round(cx - this.width(s) / 2), y, lut, shadow);
  }
}
// Ink helper: build the level LUT from a single palette index.
const lut = (i) => [ink(i), ink(i - 1), ink(0)];

const FONT = {};

// ---------------------------------------------------------------- sprites
function sheetFrame(ctx, sheet, idx, x, y) {
  const sh = DATA.sheets[sheet];
  if (!sh) return;
  const f = sh.frames[idx];
  if (!f) return;
  ctx.drawImage(IMG['SS_' + sheet], f.x, f.y, f.w, f.h, Math.round(x), Math.round(y), f.w, f.h);
}
function frameSize(sheet, idx) {
  const f = DATA.sheets[sheet] && DATA.sheets[sheet].frames[idx];
  return f ? [f.w, f.h] : [0, 0];
}

// ---------------------------------------------------------------- terrain decode
// Tile byte: bits 0-4 terrain id; high bits (v & 0xE0):
//   0x20 hills · 0xA0 mountains · 0x40 minor river · 0xC0 major river  (formats/MP_FORMAT.md)
const TERR = { ARCTIC: 24, OCEAN: 25, SEALANE: 26 };
function tileTerrain(v) { return v & 0x1F; }
function tileHills(v) { return (v & 0xE0) === 0x20; }
function tileMountains(v) { return (v & 0xE0) === 0xA0; }
function tileRiver(v) { const h = v & 0xE0; return h === 0x40 ? 1 : (h === 0xC0 ? 2 : 0); }

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
// PHYS0 overlay bands (Appendix B.2): forest 64-79, mountains 32-47, hills 48-63;
// rivers are frames 1 (minor) and 17 (major) — CLAUDE.md rule 4.
const PHYS = { FOREST: 64, MOUNTAIN: 32, HILL: 48, RIVER_MINOR: 1, RIVER_MAJOR: 17 };

function terrainName(v) {
  const t = tileTerrain(v);
  if (tileMountains(v)) return 'Mountains';
  if (tileHills(v)) return 'Hills';
  if (t <= 7) return DATA.terrain.unforested[t];
  if (t >= 8 && t <= 23) return DATA.terrain.forested[((t >= 16 ? (t & 7) | 8 : t) - 8) & 7];
  return DATA.terrain.other[t - 24] || '?';
}

// ---------------------------------------------------------------- map
const MAP = { w: DATA.map.w, h: DATA.map.h, tiles: DATA.map.tiles };
const at = (x, y) => (x < 0 || y < 0 || x >= MAP.w || y >= MAP.h) ? 25 : MAP.tiles[y * MAP.w + x];

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
};

// Starting conditions, §18.11: gold 1000 (d=0) / 300 (d=1) / 0 (d>=2), human only.
const START_GOLD = [1000, 300, 0, 0, 0];

function beginGame() {
  G.gold = START_GOLD[G.difficulty];
  G.tax = 0; G.year = 1492; G.season = 0; G.turn = 0;
  // Starting force (§18.11 / new_game_setup): a Caravel carrying Pioneers +
  // Soldiers, at the nation's start tile from NAMES @SCENARIO. The Dutch ship
  // is upgraded to a Merchantman. At difficulty <= 1 the placement runs twice.
  const dutch = G.nation === 3;
  const [sx, sy] = DATA.starts[G.nation];
  const mk = () => ({
    type: dutch ? 'Merchantman' : 'Caravel', icon: dutch ? 6 : 5,
    x: sx, y: sy, moves: dutch ? 5 : 4, movesLeft: dutch ? 5 : 4,
    cargo: ['Pioneers', 'Soldiers'],
  });
  G.units = (G.difficulty <= 1) ? [mk(), mk()] : [mk()];
  G.sel = 0;
  centerOn(sx, sy);
  G.msg = `${DATA.nations[G.nation].homeport}, ${DATA.nations[G.nation].country}.`;
}

const VIEW_TILES_X = 15, VIEW_TILES_Y = 12, TILE = 16;   // §26.7 zoom 0
function centerOn(tx, ty) {
  G.view.x = Math.max(0, Math.min(MAP.w - VIEW_TILES_X, tx - (VIEW_TILES_X >> 1)));
  G.view.y = Math.max(0, Math.min(MAP.h - VIEW_TILES_Y, ty - (VIEW_TILES_Y >> 1)));
}

// ---------------------------------------------------------------- chrome
// Dialog box chrome, §26.1: black outline (idx 0), ring 0x2E,
// bevel light 0xFD top/right, dark 0x37 left/bottom; tiled fill.
function plaque(ctx, x, y, w, h, tileSheet) {
  const [tw, th] = frameSize(tileSheet, 0);
  if (tw) {
    ctx.save();
    ctx.beginPath(); ctx.rect(x, y, w, h); ctx.clip();
    for (let yy = y; yy < y + h; yy += th)
      for (let xx = x; xx < x + w; xx += tw) sheetFrame(ctx, tileSheet, 0, xx, yy);
    ctx.restore();
  } else { ctx.fillStyle = ink(0x37); ctx.fillRect(x, y, w, h); }
  ctx.fillStyle = ink(0xFD);
  ctx.fillRect(x, y, w, 1); ctx.fillRect(x + w - 1, y, 1, h);
  ctx.fillStyle = ink(0x37);
  ctx.fillRect(x, y, 1, h); ctx.fillRect(x, y + h - 1, w, 1);
  ctx.strokeStyle = ink(0);
  ctx.strokeRect(x - 0.5, y - 0.5, w + 1, h + 1);
}
function hollowRect(ctx, x, y, w, h, colorIdx) {
  ctx.fillStyle = ink(colorIdx);
  ctx.fillRect(x, y, w, 1); ctx.fillRect(x, y + h - 1, w, 1);
  ctx.fillRect(x, y, 1, h); ctx.fillRect(x + w - 1, y, 1, h);
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
    if (k === G.menuRow) { ctx.fillStyle = ink(0x37); ctx.fillRect(b.x + 4, oy - 1, 158, 7); }
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
  // Level name uppercased + ':' at the cell top, rank word at the bottom —
  // both drawn for the selected row only, with a black shadow.
  FONT.tiny.center(ctx, DATA.difficulty[G.difficulty].toUpperCase() + ':',
                   c.x + c.w / 2, c.y + 2, lut(254), ink(0));
  FONT.tiny.center(ctx, DATA.text.misc[165 + G.difficulty],
                   c.x + c.w / 2, c.y + c.h - 9, lut(0xFC), ink(0));
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
  FONT.tiny.center(ctx, n.country.toUpperCase() + ':', c.x + c.w / 2, c.y + 2, lut(254), ink(0));
  FONT.tiny.center(ctx, DATA.text.misc[173 + G.nation], c.x + c.w / 2, c.y + c.h - 9,
                   lut(n.color), ink(0));
  FONT.tiny.center(ctx, n.leader, 56, 70, lut(0xFC), ink(0));
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

// The King's audience: @VICEROY (@VICEROY2 for the Netherlands), @width=78
// @x=232 @y=21 — the scroll column on the right of the KING.SS throne scene.
function drawKing(ctx) {
  usePalette('WOODPANL');
  ctx.drawImage(IMG.WOODPANL, 0, 0);
  const [kw, kh] = frameSize('KING', 0);
  if (kw) sheetFrame(ctx, 'KING', 0, 0, 200 - kh);
  const n = DATA.nations[G.nation];
  const body = (DATA.viceroy[G.nation === 3 ? 1 : 0] || '')
    .split('\n').map(s => s.replace(/\^\^/g, '').replace(/\^/g, '').trim())
    .map(s => s.replace('%COUNTRY', n.country));
  let y = 21;
  for (const l of body) {
    if (!l) { y += 4; continue; }
    for (const seg of wrapText(FONT.king, l, 78)) {
      FONT.king.center(ctx, seg, 232 + 39, y, lut(0xFE), ink(0));
      y += 8;
    }
  }
  FONT.tiny.center(ctx, '(click to begin)', 232 + 39, 190, lut(0xFC), ink(0));
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

// §26.7 — viewport (0,8,240,192) 15x12 @16px; sidebar right; menu bar on top.
const VP = { x: 0, y: 8, w: 240, h: 192 };
function drawMap(ctx) {
  usePalette('WOODPANL');
  ctx.drawImage(IMG.WOODPANL, 0, 0);
  ctx.fillStyle = ink(0);
  ctx.fillRect(VP.x, VP.y, VP.w, VP.h);
  for (let ty = 0; ty < VIEW_TILES_Y; ty++) {
    for (let tx = 0; tx < VIEW_TILES_X; tx++) {
      const mx = G.view.x + tx, my = G.view.y + ty;
      const px = VP.x + tx * TILE, py = VP.y + ty * TILE;
      const v = at(mx, my);
      const gf = groundFrame(tileTerrain(v));
      if (gf !== undefined) sheetFrame(ctx, 'TERRAIN', gf, px, py);
      if (isForested(tileTerrain(v))) sheetFrame(ctx, 'PHYS0', PHYS.FOREST, px, py);
      if (tileMountains(v)) sheetFrame(ctx, 'PHYS0', PHYS.MOUNTAIN, px, py);
      else if (tileHills(v)) sheetFrame(ctx, 'PHYS0', PHYS.HILL, px, py);
      const r = tileRiver(v);
      if (r) sheetFrame(ctx, 'PHYS0', r === 2 ? PHYS.RIVER_MAJOR : PHYS.RIVER_MINOR, px, py);
    }
  }
  // units
  for (const u of G.units) {
    const tx = u.x - G.view.x, ty = u.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= VIEW_TILES_X || ty >= VIEW_TILES_Y) continue;
    const px = VP.x + tx * TILE, py = VP.y + ty * TILE;
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(ctx, 'ICONS', u.icon, px + (TILE - fw) / 2, py + (TILE - fh) / 2);
    if (G.units[G.sel] === u) hollowRect(ctx, px, py, TILE, TILE, DATA.nations[G.nation].color);
  }
  drawMenuBar(ctx);
  drawSidebar(ctx);
}

const BAR_TITLES = ['GAME', 'VIEW', 'ORDERS', 'REPORTS', 'TRADE', 'PEDIA'];
function drawMenuBar(ctx) {
  ctx.fillStyle = ink(0x37); ctx.fillRect(0, 0, W, 8);
  ctx.fillStyle = ink(0); ctx.fillRect(0, 7, W, 1);
  let x = 12;
  for (const t of BAR_TITLES) { FONT.tiny.draw(ctx, t, x, 1, lut(0xFE)); x += FONT.tiny.width(t) + 12; }
}

function drawSidebar(ctx) {
  // minimap panel (241,8,79,41): 1px per tile
  const mm = { x: 241, y: 8, w: 79, h: 41 };
  ctx.fillStyle = ink(0); ctx.fillRect(mm.x, mm.y, mm.w, mm.h);
  const sx = Math.max(0, Math.min(MAP.w - 56, G.view.x - 20));
  const sy = Math.max(0, Math.min(MAP.h - 39, G.view.y - 13));
  for (let y = 0; y < 39; y++) for (let x = 0; x < 56; x++) {
    const v = at(sx + x, sy + y), t = tileTerrain(v);
    let c = 0x38;                                  // ocean blue-ish
    if (t === TERR.SEALANE) c = 0x36;
    else if (t === TERR.ARCTIC) c = 0x0F;
    else if (t !== TERR.OCEAN) c = tileMountains(v) ? 0x6B : (isForested(t) ? 0x47 : 0x43);
    ctx.fillStyle = ink(c);
    ctx.fillRect(mm.x + x + 11, mm.y + y + 1, 1, 1);
  }
  hollowRect(ctx, mm.x + 11 + (G.view.x - sx), mm.y + 1 + (G.view.y - sy),
             VIEW_TILES_X, VIEW_TILES_Y, 0x0F);

  // Sidebar B (240,72,80,64): season/year, gold, tax — per-line stack from §26.7.
  const season = DATA.seasons[G.season];
  FONT.tiny.draw(ctx, `${season}, ${G.year}`, 244, 58, lut(0x0F));
  FONT.tiny.draw(ctx, `Gold: ${G.gold}`, 244, 66, lut(0x0F));
  const taxs = `Tax:${G.tax}%`;
  FONT.tiny.draw(ctx, taxs, 314 - FONT.tiny.width(taxs), 66, lut(0x0F));

  // Sidebar C (240,136,80,64): selected-unit panel.
  const u = G.units[G.sel];
  if (u) {
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(ctx, 'ICONS', u.icon, 244 + (24 - fw) / 2, 80 + (20 - fh) / 2);
    FONT.tiny.draw(ctx, 'Moves:', 270, 82, lut(0x0F));
    FONT.tiny.draw(ctx, String(u.movesLeft), 270 + FONT.tiny.width('Moves: '), 82, lut(0xFC));
    FONT.tiny.draw(ctx, 'Locat:', 270, 92, lut(0x0F));
    FONT.tiny.draw(ctx, `${u.x},${u.y}`, 270 + FONT.tiny.width('Locat: '), 92, lut(0xFC));
    FONT.tiny.draw(ctx, u.type, 244, 104, lut(0xFE));
    if (u.cargo.length) FONT.tiny.draw(ctx, u.cargo.join(', '), 244, 112, lut(0xFC));
    FONT.tiny.draw(ctx, terrainName(at(u.x, u.y)), 244, 128, lut(0x0F));
  }
  if (G.msg) FONT.tiny.draw(ctx, G.msg, 244, 150, lut(0xFC));
  FONT.tiny.draw(ctx, 'Arrows: move', 244, 168, lut(0xFE));
  FONT.tiny.draw(ctx, 'SPACE: end turn', 244, 176, lut(0xFE));
}

// ---------------------------------------------------------------- turn
function endTurn() {
  G.turn += 1;
  // Year cadence (§20.1): 1 turn = 1 year before 1600; from 1600 seasons toggle
  // and the year steps every second turn.
  if (G.year < 1600) G.year += 1;
  else { G.season = (G.season + 1) % 2; if (G.season === 0) G.year += 1; }
  for (const u of G.units) u.movesLeft = u.moves;
  G.msg = '';
}

function moveSel(dx, dy) {
  const u = G.units[G.sel];
  if (!u) return;
  if (u.movesLeft <= 0) { G.msg = 'No moves left.'; return; }
  const nx = u.x + dx, ny = u.y + dy;
  if (nx < 0 || ny < 0 || nx >= MAP.w || ny >= MAP.h) return;
  const t = tileTerrain(at(nx, ny));
  const water = (t === TERR.OCEAN || t === TERR.SEALANE);
  if (!water) { G.msg = 'Land ho! (landfall next milestone)'; return; }
  u.x = nx; u.y = ny; u.movesLeft -= 1;
  G.msg = '';
  if (nx - G.view.x < 3 || nx - G.view.x > VIEW_TILES_X - 4 ||
      ny - G.view.y < 3 || ny - G.view.y > VIEW_TILES_Y - 4) centerOn(nx, ny);
}

// ---------------------------------------------------------------- input
function hit(mx, my, r) { return mx >= r.x && my >= r.y && mx < r.x + r.w && my < r.y + r.h; }

function onClick(mx, my) {
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
    case 'briefing':
      if (G.briefPage === 0) G.briefPage = 1;
      else { G.card = 0; G.screen = 'cards'; }
      break;
    case 'cards':
      if (G.card < 9) G.card++;
      else G.screen = 'king';
      break;
    case 'king': beginGame(); G.screen = 'map'; break;
    case 'map': {
      if (hit(mx, my, VP)) {
        const tx = G.view.x + Math.floor((mx - VP.x) / TILE);
        const ty = G.view.y + Math.floor((my - VP.y) / TILE);
        const u = G.units.findIndex(u => u.x === tx && u.y === ty);
        if (u >= 0) G.sel = u; else centerOn(tx, ty);
      }
      break;
    }
  }
}

function commitMenu() {
  // Real dispatch ladder @0x075C6D: rows 0-2 all enter the new-game setup path;
  // 3 = LOAD Game, 4 = View Hall of Fame (neither implemented yet).
  if (G.menuRow <= 2) G.screen = 'difficulty';
}

function onKey(e) {
  const k = e.key;
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
      if (k === 'Enter' || k === ' ') onClick(-1, -1);
      if (k === 'Escape' && G.screen === 'cards') G.screen = 'king';
      break;
    case 'map':
      if (k === 'ArrowLeft') moveSel(-1, 0);
      if (k === 'ArrowRight') moveSel(1, 0);
      if (k === 'ArrowUp') moveSel(0, -1);
      if (k === 'ArrowDown') moveSel(0, 1);
      if (k === ' ') endTurn();
      break;
  }
  if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', ' '].includes(k)) e.preventDefault();
}

// ---------------------------------------------------------------- main loop
let ctx, screenCanvas, scale = 1, offX = 0, offY = 0;

function resize() {
  const host = document.getElementById('host');
  const r = host.getBoundingClientRect();
  scale = Math.max(1, Math.floor(Math.min(r.width / W, r.height / H)));
  const cv = document.getElementById('screen');
  cv.width = W * scale; cv.height = H * scale;
  cv.style.width = (W * scale) + 'px'; cv.style.height = (H * scale) + 'px';
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
}

function frame() {
  ctx.clearRect(0, 0, W, H);
  ({ title: drawTitle, difficulty: drawDifficulty, nation: drawNation,
     name: drawName, briefing: drawBriefing, cards: drawCards,
     king: drawKing, map: drawMap }[G.screen])(ctx);
  const cv = document.getElementById('screen');
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
  c2.clearRect(0, 0, cv.width, cv.height);
  c2.drawImage(screenCanvas, 0, 0, W * scale, H * scale);
  requestAnimationFrame(frame);
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
  cv.addEventListener('click', (ev) => { const [x, y] = toLogical(ev); onClick(x, y); });
  cv.addEventListener('touchstart', (ev) => {
    const [x, y] = toLogical(ev); onClick(x, y); ev.preventDefault();
  }, { passive: false });
  document.getElementById('loading').style.display = 'none';
  requestAnimationFrame(frame);
}
main();
