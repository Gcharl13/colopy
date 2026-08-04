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
// The salt word [0x190] is rolled per game (0 disables the band). The engine
// value for a given save is runtime state we do not have, so the port fixes one
// -- the layout is stable for a session, which is all the hash guarantees.
const DETAIL_SALT = 1;
function detailClass(v) {
  if (tileMountains(v)) return 27;
  if (tileHills(v)) return 28;
  return v & 0x1F;
}
function detailFrame(mx, my, v) {
  if (!DETAIL_SALT) return -1;
  const forest = forestConnects(v) || isScrub(v) ? 1 : 0;
  const q = (mx & 3) * 4 + (my & 3);
  const h = ((my >> 2) * 3 + (mx >> 2) + DETAIL_SALT - forest) & 0xF;
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
  // The engine blinks the active unit's selection ring; ~2 Hz at 60 fps.
  blink: true,
  tick: 0,
  dialog: null,           // active modal popup, see openDialog()
  landHo: false,          // @LANDHO fires once per game
  newLand: '',            // what the player named the New World
  woodcut: 1,             // @WOODCUT index on the woodcut screen
};

// NAMES @UNIT drives every unit stat. The "Icon" column is an ENGINE sprite
// number; the ICONS.SS index on disk is one lower (Colonist 101 -> frame 100).
const UNITS = {};
for (const r of DATA.units) {
  UNITS[r.name] = { name: r.name, icon: r.icon - 1, movement: r.movement,
                    attack: r.attack, combat: r.combat, cargo: r.cargo,
                    hull: r.hull };
}
const unit = (n) => UNITS[n];

// Starting conditions, §18.11: gold 1000 (d=0) / 300 (d=1) / 0 (d>=2), human only.
const START_GOLD = [1000, 300, 0, 0, 0];

// @UNIT hull is the ship predicate: every vessel has hull > 0, and it is the
// only column that separates them from the Wagon Train (which carries cargo but
// sails nowhere).
function mkUnit(name, x, y, cargo) {
  const t = unit(name);
  return { type: t.name, icon: t.icon, x, y,
           moves: t.movement, movesLeft: t.movement,
           ship: t.hull > 0, nation: G.nation, orders: 0, cargo: cargo || [] };
}

function beginGame() {
  G.gold = START_GOLD[G.difficulty];
  G.tax = 0; G.year = 1492; G.season = 0; G.turn = 0;
  // Starting force (§18.11 / new_game_setup): a Caravel carrying Pioneers +
  // Soldiers, at the nation's start tile from NAMES @SCENARIO. The Dutch ship
  // is upgraded to a Merchantman. At difficulty <= 1 the placement runs twice.
  const dutch = G.nation === 3;
  const [sx, sy] = DATA.starts[G.nation];
  const mk = () => {
    const u = unit(dutch ? 'Merchantman' : 'Caravel');
    return mkUnit(u.name, sx, sy, ['Pioneers', 'Soldiers']);
  };
  G.units = (G.difficulty <= 1) ? [mk(), mk()] : [mk()];
  G.sel = 0;
  G.landHo = false; G.newLand = '';
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
  let cw = d.width;
  for (const l of d.body.concat(d.tail)) cw = Math.max(cw, FONT.tiny.width(l));
  const w = cw + 6;
  const textH = d.body.length * 6;
  const rows = d.opts ? d.opts.length * 8 : 11;   // entry field: label + box
  const h = 6 + textH + 3 + rows + 3;
  return { x: Math.round(160 - w / 2), y: Math.round(100 - h / 2), w, h, textH };
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
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  d.body.forEach((l, i) => spanText(ctx, l, b.x + 5, b.y + 6 + i * 6, 0xFE, 0xFC));
  const seed = b.y + 6 + b.textH + 3;
  if (d.opts) {
    d.opts.forEach((o, k) => {
      const oy = seed + k * 8;
      if (k === d.sel) { ctx.fillStyle = ink(0x37); ctx.fillRect(b.x + 4, oy, b.w - 8, 7); }
      FONT.tiny.draw(ctx, o, b.x + 9, oy + 1, lut(k === d.sel ? 0xFC : 0xFE));
    });
  } else {
    // Entry popup (@LANDHO): the tail line is the field label, the box follows.
    const label = d.tail[0] || '';
    FONT.tiny.draw(ctx, label, b.x + 5, seed + 2, lut(0xFE));
    const fx = b.x + 5 + FONT.tiny.width(label) + 4;
    hollowRect(ctx, fx, seed, b.x + b.w - 5 - fx, 11, 0xFE);
    const caret = (Math.floor(G.tick / 24) % 2) ? '_' : '';
    FONT.tiny.draw(ctx, d.entry + caret, fx + 3, seed + 3, lut(0xFC));
  }
}
// A numeric @default is the highlighted option row; a text @default pre-fills
// an entry field (GAME.TXT @LANDHO carries "America").
function openDialog(key, onDone) {
  const t = DATA.dialogs[key];
  const numeric = /^\d+$/.test(t.default);
  G.dialog = {
    body: t.body, tail: t.tail, width: t.width, onDone,
    opts: numeric ? t.tail : null,
    sel: numeric ? +t.default : 0,
    entry: numeric ? undefined : t.default,
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

// ------------------------------------------------------------ tile compositor
// The O514 -> O513 -> O512 chain of §6.3-6.11. Implemented here: ground fold,
// the adjacency-masked forest / relief / river bands, river mouths, the coastal
// beach halo (clean edges + quadrant fallback) and the prime-resource detail
// band. Not implemented yet: the O512 biome-edge dither (§6.11) and roads
// (§6.8 — the loader discards the feature plane anyway).

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
  const v = at(mx, my);
  const water = tileWater(v);
  const ocean = groundFrame(tileTerrain(v));

  if (!water) {
    sheetFrame(ctx, 'TERRAIN', ocean, px, py);
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
      drawTile(ctx, mx, my, px, py);
    }
  }
  // Units, selected one last so a stack draws it on top.
  const order = G.units.map((u, i) => i).sort((a, b) => (a === G.sel) - (b === G.sel));
  for (const i of order) {
    const u = G.units[i];
    const tx = u.x - G.view.x, ty = u.y - G.view.y;
    if (tx < 0 || ty < 0 || tx >= VIEW_TILES_X || ty >= VIEW_TILES_Y) continue;
    drawUnit(ctx, u, VP.x + tx * TILE, VP.y + ty * TILE);
  }
  drawMenuBar(ctx);
  drawSidebar(ctx);
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
function nationPlate(ctx, x, y, nation, orders) {
  ctx.fillStyle = ink(0); ctx.fillRect(x, y, 8, 9);
  ctx.fillStyle = ink(DATA.nations[nation].color); ctx.fillRect(x + 1, y + 1, 6, 7);
  const key = (DATA.orders[orders] || DATA.orders[0]).key;
  FONT.tiny.center(ctx, key, x + 4, y + 2, [ink(0), ink(0), ink(0)]);
}
function drawUnit(ctx, u, px, py) {
  nationPlate(ctx, px, py, u.nation, u.orders);
  const [fw, fh] = frameSize('ICONS', u.icon);
  sheetFrame(ctx, 'ICONS', u.icon, px + TILE - fw, py + TILE - fh);
  if (G.units[G.sel] === u && G.blink) {
    hollowRect(ctx, px, py, TILE, TILE, DATA.nations[u.nation].color);
  }
}

const BAR_TITLES = [['GAME', 17], ['VIEW', 49], ['ORDERS', 81],
                    ['REPORTS', 119], ['TRADE', 161], ['COLONIZOPEDIA', 259]];
function drawMenuBar(ctx) {
  ctx.fillStyle = ink(0); ctx.fillRect(0, 7, W, 1);
  for (const [t, x] of BAR_TITLES) FONT.tiny.draw(ctx, t, x, 1, lut(HUD_INK));
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
    const v = at(sx + x, sy + y), t = tileTerrain(v);
    let c = 0x38;                                  // ocean blue-ish
    if (t === TERR.SEALANE) c = 0x36;
    else if (t === TERR.ARCTIC) c = 0x0F;
    else if (t !== TERR.OCEAN) c = tileMountains(v) ? 0x6B : (isForested(t) ? 0x47 : 0x43);
    ctx.fillStyle = ink(c);
    ctx.fillRect(mm.x + x, mm.y + y, 1, 1);
  }
  hollowRect(ctx, mm.x + (G.view.x - sx), mm.y + (G.view.y - sy),
             VIEW_TILES_X, VIEW_TILES_Y, 0x0F);

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
    nationPlate(ctx, 244, 72, u.nation, u.orders);
    FONT.tiny.draw(ctx, `Moves: ${u.movesLeft}`, 270, 74, lut(HUD_INK));
    FONT.tiny.draw(ctx, `Locat: (${u.x}, ${u.y})`, 270, 84, lut(HUD_INK));
    // The HUD uses NAMES @NATIONABBREV ("Eng.", "Fr.", ...), not the adjective.
    FONT.tiny.draw(ctx, `${DATA.nations[G.nation].abbrev} ${u.type}`, 244, 96, lut(HUD_INK));
    FONT.tiny.draw(ctx, DATA.orders[u.orders].name, 244, 104, lut(HUD_INK));
    FONT.tiny.draw(ctx, `(${terrainName(at(u.x, u.y))})`, 244, 112, lut(HUD_INK));
    let cy = 128;
    for (const c of u.cargo) {
      const cu = unit(c);
      if (cu) sheetFrame(ctx, 'ICONS', cu.icon, 244, cy - 4);
      nationPlate(ctx, 244, cy - 4, G.nation, 1);
      FONT.tiny.draw(ctx, c, 268, cy, lut(HUD_INK));
      FONT.tiny.draw(ctx, 'Sentry', 268, cy + 8, lut(HUD_INK));
      cy += 20;
    }
  }
  if (G.msg) FONT.tiny.draw(ctx, G.msg, 244, 182, lut(HUD_INK));
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

function step(u, nx, ny) {
  u.x = nx; u.y = ny; u.movesLeft -= 1;
  G.msg = '';
  if (nx - G.view.x < 3 || nx - G.view.x > VIEW_TILES_X - 4 ||
      ny - G.view.y < 3 || ny - G.view.y > VIEW_TILES_Y - 4) centerOn(nx, ny);
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
  openDialog('LANDFALL', (choice) => {
    if (choice !== 1) return;
    const first = G.units.length;
    for (const name of ship.cargo) G.units.push(mkUnit(name, nx, ny));
    ship.cargo = [];
    ship.movesLeft = 0;
    G.sel = first;
    // First landfall fires woodcut 1, DISCOVERY OF THE NEW WORLD
    // (spec/ui/woodcuts_and_intro.md trigger table, func_020EFE @0x020F00),
    // and it is shown once per game.
    if (!G.landHo) {
      G.landHo = true;
      G.woodcut = 1;
      G.screen = 'woodcut';
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
    if (u.cargo.length) landfall(u, nx, ny);
    return;
  }
  if (!u.ship && water) return;   // land units cannot walk onto water
  step(u, nx, ny);
}

// Cycle to the next unit that still has moves -- the engine's Tab/next-unit.
function nextUnit() {
  for (let i = 1; i <= G.units.length; i++) {
    const k = (G.sel + i) % G.units.length;
    if (G.units[k].movesLeft > 0) { G.sel = k; centerOn(G.units[k].x, G.units[k].y); return; }
  }
}

// ---------------------------------------------------------------- input
function hit(mx, my, r) { return mx >= r.x && my >= r.y && mx < r.x + r.w && my < r.y + r.h; }

function onClick(mx, my) {
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
    case 'briefing':
      if (G.briefPage === 0) G.briefPage = 1;
      else { G.card = 0; G.screen = 'cards'; }
      break;
    case 'cards':
      if (G.card < 9) G.card++;
      else G.screen = 'king';
      break;
    case 'king': beginGame(); G.screen = 'map'; break;
    case 'woodcut': G.screen = 'map'; askLandName(); break;
    case 'map': {
      if (hit(mx, my, VP)) {
        const tx = G.view.x + Math.floor((mx - VP.x) / TILE);
        const ty = G.view.y + Math.floor((my - VP.y) / TILE);
        // Clicking a stack cycles through the units standing on that tile.
        const on = G.units.map((u, i) => i).filter(i => G.units[i].x === tx && G.units[i].y === ty);
        if (on.length) G.sel = on[(on.indexOf(G.sel) + 1) % on.length];
        else centerOn(tx, ty);
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
      if (k === 'Escape' && G.screen === 'cards') G.screen = 'king';
      break;
    case 'map':
      if (k === 'ArrowLeft') moveSel(-1, 0);
      if (k === 'ArrowRight') moveSel(1, 0);
      if (k === 'ArrowUp') moveSel(0, -1);
      if (k === 'ArrowDown') moveSel(0, 1);
      if (k === ' ') endTurn();
      if (k === 'Tab') nextUnit();
      break;
  }
  if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', ' ', 'Tab'].includes(k)) e.preventDefault();
}

// ---------------------------------------------------------------- main loop
let ctx, screenCanvas, scale = 1, offX = 0, offY = 0;

function resize() {
  // Integer-scale only: this is pixel art, so a fractional scale would blur it.
  const availW = window.innerWidth - 60, availH = window.innerHeight - 90;
  scale = Math.max(1, Math.floor(Math.min(availW / W, availH / H)));
  const cv = document.getElementById('screen');
  cv.width = W * scale; cv.height = H * scale;
  cv.style.width = (W * scale) + 'px'; cv.style.height = (H * scale) + 'px';
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
}

function frame() {
  G.tick += 1;
  G.blink = (G.tick % 32) < 20;
  ctx.clearRect(0, 0, W, H);
  ({ title: drawTitle, difficulty: drawDifficulty, nation: drawNation,
     name: drawName, briefing: drawBriefing, cards: drawCards,
     king: drawKing, map: drawMap, woodcut: drawWoodcut }[G.screen])(ctx);
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
