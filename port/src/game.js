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
  colonies: [],           // founded colonies
  colony: 0,              // active colony on the colony screen
  europe: [],             // ships in port / on the high seas
  market: [],             // per-good bid price
  euroRow: 0,             // recruit-menu row
  colonyView: 2,          // right-panel mode: buildings / units / production
  accum: [],              // per-good traffic accumulator
  kingsFund: 0,           // the tax the Crown has taken
  dock: [],               // three immigration candidate slots
  euroMenu: null,         // open Europe sub-menu: recruit / purchase / train
  euroMenuRow: 0,
  euroShip: 0,            // selected ship in port
  euroMsg: '',
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
  // Starting force (new_game_setup): ONE ship carrying Pioneers + Soldiers, at
  // the nation's start tile from NAMES @SCENARIO, at every difficulty. The
  // Dutch ship is a Merchantman. (§18.11 claims the force is "doubled at d <= 1
  // by a second placement pass"; that claim carries no function cite anywhere
  // in the tree and play shows one ship at every level -- see RULINGS.md
  // 2026-08-04. Difficulty scales starting gold, not hulls.)
  const [sx, sy] = DATA.starts[G.nation];
  G.units = [mkUnit(G.nation === 3 ? 'Merchantman' : 'Caravel', sx, sy,
                    ['Pioneers', 'Soldiers'])];
  G.sel = 0;
  G.landHo = false; G.newLand = ''; G.zoom = 0; G.openMenu = -1;
  G.colonies = []; G.europe = []; G.builtColony = false;
  G.kingsFund = 0; G.euroMenu = null; G.euroShip = 0; G.euroMsg = '';
  seedMarket();
  // The dock holds three candidate slots; each refills from the @CLASS ladder.
  G.dock = [0, 0, 0].map(() => rollImmigrant());
  centerOn(sx, sy);
  G.msg = `${DATA.nations[G.nation].homeport}, ${DATA.nations[G.nation].country}.`;
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
function openDialog(key, onDone, prefill) {
  const t = DATA.dialogs[key];
  // A numeric @default names the highlighted option row; a text @default
  // prefills an entry field; no @default at all is an entry field with no
  // prefill (GAME.TXT @COLONY carries no directives).
  const numeric = typeof t.default === 'string' && /^\d+$/.test(t.default);
  G.dialog = {
    body: t.body, tail: t.tail, width: t.width, onDone,
    opts: numeric ? t.tail : null,
    sel: numeric ? +t.default : 0,
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
    const [fw, fh] = frameSize('ICONS', c.nation);
    sheetFrame(tgt, 'ICONS', c.nation, px + (TILE - fw) / 2, py + (TILE - fh) / 2);
    if (G.zoom === 0) FONT.tiny.center(ctx, c.name, px + TILE / 2, py + TILE, lut(0x0F), ink(0));
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
  // The active unit blinks: the engine flashes the unit graphic itself on and
  // off so the tile beneath shows through. There is no selection outline.
  if (G.units[G.sel] === u && !G.blink) return;
  nationPlate(ctx, px, py, u.nation, u.orders);
  const [fw, fh] = frameSize('ICONS', u.icon);
  sheetFrame(ctx, 'ICONS', u.icon, px + TILE - fw, py + TILE - fh);
}

const BAR_TITLES = [['GAME', 17], ['VIEW', 49], ['ORDERS', 81],
                    ['REPORTS', 119], ['TRADE', 161], ['COLONIZOPEDIA', 259]];
function drawMenuBar(ctx) {
  ctx.fillStyle = ink(0); ctx.fillRect(0, 7, W, 1);
  BAR_TITLES.forEach(([t, x], i) => {
    if (i === G.openMenu) {
      ctx.fillStyle = ink(0x37);
      ctx.fillRect(x - 2, 0, FONT.tiny.width(t) + 4, 7);
    }
    FONT.tiny.draw(ctx, t, x, 1, lut(HUD_INK));
  });
  if (G.openMenu >= 0) drawPulldown(ctx);
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
    if (sel) { ctx.fillStyle = ink(0x37); ctx.fillRect(b.x + 2, y, b.w - 4, 8); }
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
  const fn = COMMANDS[r.label];
  if (fn) fn();
  else G.msg = `${r.label} - not in this build.`;
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

// ---------------------------------------------------------------- colonies
// Build Colony (@ORDERS row 7, status letter "B"). A land unit standing on a
// land tile with no colony already on it founds one; @COLONY -- "What shall we
// name this colony?" -- carries no @default directive, so the field is prefilled
// from COLONY.TXT's per-nation list in founding order instead.
function buildColony() {
  const u = G.units[G.sel];
  if (!u || u.ship) return;
  if (tileWater(at(u.x, u.y))) return;
  if (colonyAt(u.x, u.y)) { G.msg = 'There is already a colony here.'; return; }
  const names = DATA.colonynames[G.nation];
  const suggested = names[G.colonies.length % names.length];
  openDialog('COLONY', (name) => {
    const nm = (name || '').trim() || suggested;
    G.colonies.push({
      name: nm, x: u.x, y: u.y, nation: G.nation,
      // A new colony starts with its founder in the plaza and an empty
      // warehouse; the fixed starting buildings are the three no-cost rows.
      colonists: [u.type],
      stock: DATA.cargo.map(() => 0),
      buildings: STARTING_BUILDINGS.slice(),
      sol: 0,
    });
    // The founder joins the colony, so it leaves the map.
    G.units.splice(G.sel, 1);
    G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
    G.colony = G.colonies.length - 1;
    // First colony fires woodcut 2, BUILDING A COLONY (human only) --
    // spec/ui/woodcuts_and_intro.md, func_040C1E @0x040E00.
    if (!G.builtColony) { G.builtColony = true; G.woodcut = 2; G.screen = 'woodcut'; }
    else G.screen = 'colony';
  }, suggested);
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
// Food: consumption is byte-verified as `eaten = 2*pop` (spec/systems/colony.md
// §152, @0xA5F2). The centre tile produces with no worker; the engine derives
// its food from a terrain BAND CLASS 0..3 whose mapping is not in the evidence
// here, so the farmer column of the terrain's own row stands in for it. The
// documented modifiers that ARE cited are applied: +2 at difficulty 0, +1 at
// difficulty 1, +1 for a river. The band function is TBD.
function colonyFood(c) {
  const v = at(c.x, c.y);
  let produced = tileYield(v, JOB_FARMER);
  if (G.difficulty === 0) produced += 2; else if (G.difficulty === 1) produced += 1;
  if (tileRiver(v)) produced += 1;
  const eaten = 2 * c.colonists.length;
  return { produced, eaten, net: produced - eaten };
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
function sailForNewWorld(e) {
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
    if (e.state === 'toEurope') {
      e.state = 'port';
      G.euroShip = shipsInPort().indexOf(e);
      G.euroMsg = `${e.type} arrives in ${DATA.nations[G.nation].homeport}.`;
      G.screen = 'europe';
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
// The 15 building plots are the cited DS:0x266 positions. Which buildings a
// BRAND-NEW colony starts with is **TBD** -- it is not byte-cited anywhere in
// the tree (the def table 0x8E82 is a runtime array and its initialiser is not
// traced), so every plot renders as the empty-plot scenery the engine draws
// when 0x8E82[i]==255. Resolving it needs that initialiser traced or a shipped
// COLONY??.SAV parsed. Likewise the per-colony RNG plot shuffle (func_025D34)
// is unresolved, so plots are used in table order.
const PLOTS = [[56,13],[145,15],[173,18],[8,41],[37,45],[67,54],[96,53],[6,14],
               [128,53],[10,76],[15,102],[87,11],[66,87],[123,106],[123,55]];
const PLOT_CATEGORY = [0,0,0,0,0,0,0,1,1,1,1,2,2,3,4];
// Empty-plot scenery per category: BUILDING.SS frames 42/43/44 are tree
// clusters, 45 the wooded shore, 47 the outbuilding -- identified by rendering
// the sheet tail, and matching the scenery in the capture.
const EMPTY_PLOT_FRAME = [42, 43, 44, 45, 47];
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
  PLOTS.forEach(([px, py], i) => {
    const b = c.buildings[i];
    const frame = (b === undefined) ? EMPTY_PLOT_FRAME[PLOT_CATEGORY[i]]
                                    : DATA.buildings.findIndex(d => d.name === b) + 1;
    sheetFrame(ctx, 'BUILDING', frame, px, py + 8);
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
    for (let tx = 0; tx < 5; tx++)
      drawTile(sg, c.x - 2 + tx, c.y - 2 + ty, tx * 16, ty * 16);
  // Colony and unit markers go on the 80x80 BEFORE the upscale, so they are
  // stretched with the terrain rather than drawn crisp over it.
  for (const o of G.colonies) {
    const dx = o.x - c.x + 2, dy = o.y - c.y + 2;
    if (dx < 0 || dy < 0 || dx > 4 || dy > 4) continue;
    const [fw, fh] = frameSize('ICONS', o.nation);
    sheetFrame(sg, 'ICONS', o.nation, dx * 16 + (16 - fw) / 2, dy * 16 + (16 - fh) / 2);
  }
  for (const u of G.units) {
    const dx = u.x - c.x + 2, dy = u.y - c.y + 2;
    if (dx < 0 || dy < 0 || dx > 4 || dy > 4) continue;
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(sg, 'ICONS', u.icon, dx * 16 + 16 - fw, dy * 16 + 16 - fh);
  }
  ctx.imageSmoothingEnabled = false;
  ctx.save();
  ctx.beginPath(); ctx.rect(224, 32, 72, 72); ctx.clip();
  ctx.drawImage(scene, 0, 0, 80, 80, 200, 8, 120, 120);
  ctx.restore();
  hollowRect(ctx, 223, 31, 74, 74, 0);
  // The white rectangle marks the COLONY-CENTRE TILE, not the 3x3 window:
  // measured at x 248..271, y 56..79 in the capture = the cited (248,56,24,24).
  hollowRect(ctx, 248, 56, 24, 24, 0x0F);

  // COLONY.PIK town strip, 320x72 at y=128, then the panel captions over it.
  ctx.drawImage(IMG.COLONY, 0, 128);
  // Plaza (0,130,120,48): the colonists, left-aligned at the panel origin + 2.
  c.colonists.forEach((n, i) => {
    const u = unit(n);
    if (u) sheetFrame(ctx, 'ICONS', u.icon, 2 + i * 14, 150);
  });
  drawColonyPanel(ctx, c);
  // SoL band, with the crown (ICONS disk 124) to its right at the measured
  // (105,131); the count is a digit in parens, not the letter I.
  FONT.tiny.draw(ctx, `${c.sol}% (${c.colonists.length})`, 75, 133, lut(SOL_INK));
  sheetFrame(ctx, 'ICONS', 124, 105, 131);
  FONT.tiny.center(ctx, 'No Ships In Port', 160, 130, lut(PANEL_INK));

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
  ctx.fillStyle = ink(0);
  ctx.fillRect(0, 7, W, 1);
  ctx.fillRect(0, 128, W, 1);
  ctx.fillRect(199, 7, 1, 122);
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
      nationPlate(ctx, px + i * 15, py + 10, u.nation, u.orders);
    });
  } else {
    // Production. Food is the only line with a byte-verified consumption rule
    // (eaten = 2*pop); the rest read the terrain's own job-yield columns.
    const f = colonyFood(c);
    FONT.tiny.draw(ctx, 'Production', px, py, lut(PANEL_INK));
    sheetFrame(ctx, 'ICONS', 0x16, px, py + 9);
    FONT.tiny.draw(ctx, `${f.produced}`, px + 10, py + 12, lut(SOL_INK));
    FONT.tiny.draw(ctx, `-${f.eaten}`, px + 24, py + 12, lut(0x0C));
    FONT.tiny.draw(ctx, `= ${f.net >= 0 ? '+' : ''}${f.net}`, px + 40, py + 12,
                   lut(f.net < 0 ? 0x0C : SOL_INK));
    // Hammers: the Carpenter's Shop turns lumber into construction points, one
    // hammer sprite (ICONS 54) per point -- the documented hammer strip.
    const hammers = c.buildings.includes("Carpenter's Shop") ? 3 : 0;
    for (let i = 0; i < hammers; i++) sheetFrame(ctx, 'ICONS', 54, px + i * 8, py + 26);
    FONT.tiny.draw(ctx, `${hammers} hammers`, px + hammers * 8 + 4, py + 29, lut(SOL_INK));
  }
  // View buttons.
  for (let k = 0; k < 3; k++) {
    const by = VIEW_BTN.y + k * VIEW_BTN.pitch;
    sheetFrame(ctx, 'ICONS', 67 + k, VIEW_BTN.x, by);
    if (k === G.colonyView) hollowRect(ctx, VIEW_BTN.x - 1, by - 1, 16, 15, 0x0F);
  }
}

// The dock's candidate ladder (§17.6): harder difficulty yields more low-tier
// arrivals. The three-tier roll is the cited one; the class list is @CLASS.
function rollImmigrant() {
  const lvl = G.difficulty;
  const thr = (lvl + 3) >> 1;
  if (Math.floor(Math.random() * 15) + 1 <= thr) return 0;      // Petty Criminals
  if (Math.floor(Math.random() * 10) + 1 <= thr) return 1;      // Indentured Servants
  return 2 + Math.floor(Math.random() * (DATA.classes.length - 2));
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
}
const askPrice = (i) => G.market[i] + DATA.cargo[i].burden + 1;
function stepPrice(i) {
  const c = DATA.cargo[i];
  while (G.accum[i] <= -100 * c.rise && G.market[i] < c.high) {
    G.market[i] += 1; G.accum[i] += 100 * c.rise;
  }
  while (G.accum[i] >= 100 * c.fall && G.market[i] > c.low) {
    G.market[i] -= 1; G.accum[i] -= 100 * c.fall;
  }
}
function driftMarket() {
  DATA.cargo.forEach((c, i) => { G.accum[i] += c.attrition; stepPrice(i); });
}
// SELL: gross = price*qty, tax = gross*rate/100, you keep the rest and the
// King's fund gains the tax. Selling floods the market, so the accumulator
// rises and the price falls.
function sellGoods(i, qty) {
  if (qty <= 0) return 0;
  const gross = G.market[i] * qty;
  const tax = Math.floor(gross * G.tax / 100);
  G.gold += gross - tax;
  G.kingsFund += tax;
  G.accum[i] += qty << DATA.cargo[i].volatility;
  stepPrice(i);
  return gross - tax;
}
// BUY is untaxed and pays the ask; buying drains the market, so the price rises.
function buyGoods(i, qty) {
  const cost = askPrice(i) * qty;
  if (cost > G.gold) return 0;
  G.gold -= cost;
  G.accum[i] -= qty << DATA.cargo[i].volatility;
  stepPrice(i);
  return cost;
}

// ------------------------------------------------------------ Europe screen
// §26.9. EUROPE.PIK carries the dock town, market grid and the red "E"; the
// engine draws the title band, the market prices, the dock/panel captions and
// the recruit menu.
const EURO_ROWS = DATA.eurolabel.slice(0, 3);
// PURCHASE's cited content is the goods pages -- Muskets in 50s, Horses, Tools
// in 100s (§9.4 names those three explicitly). Ship and Artillery prices are
// NOT in the shipped tables (Artillery only as "base + artillery_bought*100",
// with no base), so those rows are omitted rather than invented.
const PURCHASE_ROWS = [{ good: 15, qty: 50 }, { good: 8, qty: 100 }, { good: 14, qty: 100 }];

function shipsInPort() { return G.europe.filter(e => e.state === 'port'); }
function activeShip() { return shipsInPort()[G.euroShip] || null; }

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
  FONT.tiny.draw(ctx, 'Expected Soon', 16, 120, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toEurope').slice(0, 3).forEach((e, k) =>
    FONT.tiny.draw(ctx, `${e.type} (${e.turns})`, 16, 128 + k * 7, lut(0x0A)));
  FONT.tiny.draw(ctx, 'Bound For', 87, 120, lut(HUD_INK));
  FONT.tiny.draw(ctx, DATA.regionname[G.nation], 87, 127, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toNewWorld').slice(0, 3).forEach((e, k) =>
    FONT.tiny.draw(ctx, `${e.type} (${e.turns})`, 87, 135 + k * 7, lut(0x0A)));

  const ship = activeShip();
  FONT.tiny.draw(ctx, 'Loading:', 150, 120, lut(HUD_INK));
  FONT.tiny.draw(ctx, ship ? ship.type : DATA.text.misc[339] || 'No Ships In Port',
                 186, 120, lut(0x0A));
  if (ship) {
    ship.hold.slice(0, 6).forEach((h, k) => {
      const [fw] = frameSize('ICONS', 0x16 + h.good);
      sheetFrame(ctx, 'ICONS', 0x16 + h.good, 152 + k * 12 - (fw >> 1) + 5, 128);
      FONT.tiny.center(ctx, String(h.qty), 152 + k * 12 + 5, 142, lut(0x0F));
    });
    ship.passengers.slice(0, 4).forEach((pName, k) => {
      const u = unit(pName);
      if (u) sheetFrame(ctx, 'ICONS', u.icon, 150 + k * 15, 148);
    });
  }
  // Six dock slots hold the ships in port.
  shipsInPort().forEach((e, k) => {
    if (k >= 6) return;
    sheetFrame(ctx, 'ICONS', 122, 147 + 12 * k, 165);
    if (k === G.euroShip) hollowRect(ctx, 146 + 12 * k, 164, 12, 14, 0x0E);
  });

  // Recruit menu rows (281, 89+11r, 37, 9); accelerator letter yellow.
  EURO_ROWS.forEach((r, k) => {
    const y = 89 + 11 * k;
    ctx.fillStyle = ink(k === G.euroRow ? 57 : 48);
    ctx.fillRect(281, y, 37, 9);
    const w = FONT.tiny.width(r), x0 = 281 + (37 - w) / 2;
    FONT.tiny.draw(ctx, r[0], x0, y + 1, lut(0x0E));
    FONT.tiny.draw(ctx, r.slice(1), x0 + FONT.tiny.width(r[0]), y + 1,
                   lut(k === G.euroRow ? 0x0F : 0x00));
  });

  if (G.euroMenu) drawEuroMenu(ctx);
  if (G.euroMsg) FONT.tiny.center(ctx, G.euroMsg, 160, 172, lut(0x0E), ink(0));
  FONT.tiny.draw(ctx, 'Exit', 306, 181, lut(0x0F));
}

// The three sub-menus. Each is a plaque list: rows of "<label> <price>" with
// the affordable ones lit and the rest dimmed.
function euroMenuRows() {
  if (G.euroMenu === 'recruit')
    return G.dock.map(ci => ({ label: DATA.classes[ci].name, cost: DATA.classes[ci].cost }));
  if (G.euroMenu === 'train')
    return DATA.jobtrain.map(j => ({ label: j.expert, cost: j.cost }));
  return PURCHASE_ROWS.map(r => ({
    label: `${DATA.cargo[r.good].name} x${r.qty}`, cost: askPrice(r.good) * r.qty }));
}
function drawEuroMenu(ctx) {
  const rows = euroMenuRows();
  const visible = Math.min(rows.length, 10);
  const b = { x: 60, y: 30, w: 200, h: 14 + visible * 9 };
  plaque(ctx, b.x, b.y, b.w, b.h, 'WOODTILE');
  FONT.tiny.draw(ctx, G.euroMenu.toUpperCase(), b.x + 5, b.y + 4, lut(0xFC));
  const top = Math.max(0, Math.min(G.euroMenuRow - visible + 1, rows.length - visible));
  for (let k = 0; k < visible; k++) {
    const r = rows[top + k], y = b.y + 13 + k * 9;
    const sel = (top + k) === G.euroMenuRow;
    if (sel) { ctx.fillStyle = ink(0x37); ctx.fillRect(b.x + 3, y, b.w - 6, 8); }
    const afford = r.cost <= G.gold;
    FONT.tiny.draw(ctx, r.label, b.x + 6, y + 1, lut(afford ? (sel ? 0xFC : 0xFE) : 0x2F));
    const c = `${r.cost}$`;
    FONT.tiny.draw(ctx, c, b.x + b.w - 8 - FONT.tiny.width(c), y + 1,
                   lut(afford ? (sel ? 0xFC : 0xFE) : 0x2F));
  }
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
  const paid = buyGoods(i, qty);
  if (!paid) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
  holdAdd(ship, i, qty);
  G.euroMsg = `Bought ${qty} ${DATA.cargo[i].name} for ${paid}$`;
}

// Committing a sub-menu row.
function euroMenuCommit() {
  const rows = euroMenuRows();
  const r = rows[G.euroMenuRow];
  if (!r) return;
  if (r.cost > G.gold) { G.euroMsg = 'We cannot afford that, Your Excellency.'; return; }
  G.gold -= r.cost;
  if (G.euroMenu === 'recruit') {
    // The recruit boards a ship in port if there is one, else waits on the dock.
    const ship = activeShip();
    if (ship) ship.passengers.push('Colonists');
    G.dock[G.euroMenuRow] = rollImmigrant();
    G.euroMsg = `${r.label.replace(/s$/, '')} recruited.`;
  } else if (G.euroMenu === 'train') {
    const ship = activeShip();
    if (ship) ship.passengers.push('Colonists');
    G.euroMsg = `${r.label} trained.`;
  } else {
    const buy = PURCHASE_ROWS[G.euroMenuRow];
    const ship = activeShip();
    // The gold was already taken above, so move the goods without re-charging.
    G.accum[buy.good] -= buy.qty << DATA.cargo[buy.good].volatility;
    stepPrice(buy.good);
    if (ship) holdAdd(ship, buy.good, buy.qty);
    G.euroMsg = `${buy.qty} ${DATA.cargo[buy.good].name} purchased.`;
  }
  G.euroMenu = null;
}

// ---------------------------------------------------------------- turn
function endTurn() {
  G.turn += 1;
  // Year cadence (§20.1): 1 turn = 1 year before 1600; from 1600 seasons toggle
  // and the year steps every second turn.
  if (G.year < 1600) G.year += 1;
  else { G.season = (G.season + 1) % 2; if (G.season === 0) G.year += 1; }
  for (const u of G.units) u.movesLeft = u.moves;
  driftMarket();
  advanceCrossings();
  G.msg = '';
  if (G.units[G.sel]) centerOn(G.units[G.sel].x, G.units[G.sel].y);
}

function step(u, nx, ny) {
  u.x = nx; u.y = ny; u.movesLeft -= 1;
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
  openDialog('LANDFALL', (choice) => {
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
  // The right-edge sea-lane column is the route home: a ship that enters it
  // sails for Europe and leaves the map (CLAUDE.md hard rule 2, terrain 26).
  if (u.ship && tileTerrain(at(nx, ny)) === TERR.SEALANE) { sailForEurope(u); return; }
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
  G.msg = DATA.orders[n].name;
  u.movesLeft = 0;
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
  G.msg = 'Activated.';
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
  let moved = 0;
  for (const h of (u.hold || [])) { c.stock[h.good] += h.qty; moved += h.qty; }
  u.hold = [];
  G.msg = moved ? `Unloaded ${moved} goods.` : 'Nothing to unload.';
}
function dumpCargo() {
  const u = G.units[G.sel];
  if (!u || !(u.hold || []).length) { G.msg = 'Nothing to dump.'; return; }
  u.hold = [];
  G.msg = 'Cargo dumped overboard.';
}
function disbandUnit() {
  if (!G.units.length) return;
  G.msg = `${G.units[G.sel].type} disbanded.`;
  G.units.splice(G.sel, 1);
  G.sel = Math.min(G.sel, Math.max(0, G.units.length - 1));
}
function findColony() {
  if (!G.colonies.length) { G.msg = 'No colonies yet.'; return; }
  G.colonyFind = ((G.colonyFind || 0) + 1) % G.colonies.length;
  const c = G.colonies[G.colonyFind];
  centerOn(c.x, c.y);
  G.msg = c.name;
}
// §26.7 zoom: spans 0xF<<z by 0xC<<z tiles at 0x10>>z pixels.
function setZoom(z) {
  G.zoom = Math.max(0, Math.min(3, z));
  const u = G.units[G.sel];
  if (u) centerOn(u.x, u.y); else centerOn(G.view.x + 7, G.view.y + 6);
  G.msg = `Zoom ${VIEW_COLS()} x ${VIEW_ROWS()}`;
}
const COMMANDS = {
  // ORDERS
  'Activate unit': activateUnit,
  'Wait for next unit': () => nextUnit(),
  'Fortify': () => setOrder(5),
  'Sentry': () => setOrder(1),
  'Build Colony': buildColony,
  'Join Colony (B)': buildColony,
  'Clear Forest (P)': () => setOrder(8),
  'Plow Fields  (P)': () => setOrder(8),
  'Build Road': () => setOrder(9),
  'Load Cargo': loadCargo,
  'Unload Cargo': unloadCargo,
  'Go to Port': returnToEurope,
  'Return to Europe': returnToEurope,
  'No Orders (space bar)': skipUnit,
  'Dump Cargo Overboard': dumpCargo,
  'Disband Unit (shift-D)': disbandUnit,
  // VIEW
  'Move Pieces': () => { G.viewMode = false; G.msg = 'Move mode.'; },
  'View Pieces': () => { G.viewMode = true; G.msg = 'View mode.'; },
  'European Status': () => { G.screen = 'europe'; },
  'Find Colony': findColony,
  'Zoom In': () => setZoom(G.zoom - 1),
  'Zoom Out': () => setZoom(G.zoom + 1),
  'Zoom Level 15 x 12': () => setZoom(0),
  'Zoom Level 30 x 24': () => setZoom(1),
  'Zoom Level 60 x 48': () => setZoom(2),
  'Zoom Level 120 x 96': () => setZoom(3),
  'Show Hidden Terrain': () => { G.showHidden = !G.showHidden;
                                 G.msg = `Hidden terrain ${G.showHidden ? 'on' : 'off'}.`; },
  'Center View': centreView,
};

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
    case 'woodcut':
      // Woodcut 1 is the discovery plate and hands over to the naming prompt;
      // woodcut 2 is BUILDING A COLONY and hands over to the new colony.
      if (G.woodcut === 1) { G.screen = 'map'; askLandName(); }
      else G.screen = 'colony';
      break;
    case 'colony':
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: VIEW_BTN.x, y: VIEW_BTN.y + k * VIEW_BTN.pitch,
                          w: VIEW_BTN.w, h: VIEW_BTN.h })) { G.colonyView = k; return; }
      }
      if (hit(mx, my, { x: 306, y: 179, w: 15, h: 21 })) G.screen = 'map';
      break;
    case 'europe': {
      if (G.euroMenu) {
        const rows = euroMenuRows(), visible = Math.min(rows.length, 10);
        const b = { x: 60, y: 30, w: 200, h: 14 + visible * 9 };
        const top = Math.max(0, Math.min(G.euroMenuRow - visible + 1, rows.length - visible));
        for (let k = 0; k < visible; k++) {
          if (hit(mx, my, { x: b.x + 3, y: b.y + 13 + k * 9, w: b.w - 6, h: 9 })) {
            G.euroMenuRow = top + k; euroMenuCommit(); return;
          }
        }
        G.euroMenu = null;                       // click outside closes it
        return;
      }
      if (hit(mx, my, { x: 306, y: 179, w: 15, h: 21 })) { G.screen = 'map'; return; }
      // Menu buttons.
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: 281, y: 89 + 11 * k, w: 37, h: 9 })) {
          G.euroRow = k; openEuroMenu(k); return;
        }
      }
      // Dock slots select the ship being loaded.
      const ships = shipsInPort();
      for (let k = 0; k < Math.min(ships.length, 6); k++) {
        if (hit(mx, my, { x: 146 + 12 * k, y: 164, w: 12, h: 14 })) { G.euroShip = k; return; }
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
      if (k === 'Escape' && G.screen === 'cards') G.screen = 'briefing';
      break;
    case 'colony':
      // Keys 1/2/3 select the right-panel view, matching the three buttons.
      if (k >= '1' && k <= '3') G.colonyView = +k - 1;
      if (k === 'Escape' || k === 'x') G.screen = 'map';
      break;
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
      if (k === 's' || k === 'S') { const e = activeShip(); if (e) sailForNewWorld(e); }
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
      // F1-F10 report ladder. The advisor screens are not built, so each names
      // itself rather than pretending to open.
      if (/^F\d+$/.test(k)) {
        const row = DATA.menus[3].rows[+k.slice(1) - 1];
        if (row) G.msg = `${row.label} - not in this build.`;
        e.preventDefault();
        return;
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
        case 'g': case 'G': G.msg = 'Go to - not in this build.'; break;
        case 't': case 'T': G.msg = 'Trade routes - not in this build.'; break;
        case 'v': case 'V': G.viewMode = true; G.msg = 'View mode.'; break;
        case 'm': case 'M': G.viewMode = false; G.msg = 'Move mode.'; break;
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
  const availW = window.innerWidth - 60, availH = window.innerHeight - 90;
  scale = Math.max(1, Math.floor(Math.min(availW / W, availH / H)));
  const cv = document.getElementById('screen');
  cv.width = W * scale; cv.height = H * scale;
  cv.style.width = (W * scale) + 'px'; cv.style.height = (H * scale) + 'px';
  const c2 = cv.getContext('2d');
  c2.imageSmoothingEnabled = false;
}

function frame() {
  G.blink = (G.tick % 32) < 20;
  G.tick += 1;
  ctx.clearRect(0, 0, W, H);
  ({ title: drawTitle, difficulty: drawDifficulty, nation: drawNation,
     name: drawName, briefing: drawBriefing, cards: drawCards,
     king: drawKing, map: drawMap, woodcut: drawWoodcut,
     colony: drawColony, europe: drawEurope }[G.screen])(ctx);
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
