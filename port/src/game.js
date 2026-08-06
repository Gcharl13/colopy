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
function mkUnit(name, x, y, cargo) {
  const t = unit(name);
  // Movement budgets are stored in THIRDS: the @UNIT loader multiplies the
  // column by 3 (`SHL al,1 / ADD al,cl` @0x074F04, unit.md §3), which is what
  // makes a road step cost 1/3 of a move.
  const u = { type: t.name, icon: t.icon, x, y,
              moves: t.movement * MOVE_UNIT, movesLeft: t.movement * MOVE_UNIT,
              ship: t.hull > 0, nation: G.nation, orders: 0, cargo: cargo || [] };
  // A Pioneer is a colonist carrying tools; UnitRecord +0x15 starts at 100.
  if (name === 'Pioneers') u.tools = PIONEER_TOOLS;
  return u;
}

function beginGame() {
  G.gold = START_GOLD[G.difficulty];
  G.tax = 0; G.year = 1492; G.season = 0; G.turn = 0;
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
  // Both mutable map planes go back to their shipped state.
  MAP.tiles.set ? MAP.tiles.set(DATA.map.tiles) : MAP.tiles.splice(0, MAP.tiles.length, ...DATA.map.tiles);
  IMPROVE.fill(0);
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
  // The map generator's first act is to store random_int(0, 0x7FFF) as the seed
  // the rumour hash reads (@0x64A23).
  G.combat = null;
  G.mapSeed = Math.floor(Math.random() * 0x8000);
  G.rumoursDone = new Set(); G.rumourFloor = 1;
  G.foundFountain = false; G.foundCibola = false;
  G.metAnyone = false;
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
  // 4. interior, tiled inside the rings
  const ix = x + 3, iy = y + 3, iw = w - 6, ih = h - 6;
  const [tw, th] = frameSize(tileSheet, 0);
  if (tw) {
    ctx.save();
    ctx.beginPath(); ctx.rect(ix, iy, iw, ih); ctx.clip();
    for (let yy = iy; yy < iy + ih; yy += th)
      for (let xx = ix; xx < ix + iw; xx += tw) sheetFrame(ctx, tileSheet, 0, xx, yy);
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
      if (k === d.sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(b.x + 4, oy, b.w - 8, 7); }
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
  // A Lost City Rumour square. Its presence is computed, not stored, so the
  // marker is drawn wherever the hash says one stands. ICONS 17 is the gold
  // sunburst that reads as the rumour marker on the DOS map; no catalogue entry
  // names it, so the identification is by eye -- flagged.
  if (rumourAt(mx, my)) sheetFrame(ctx, 'ICONS', RUMOUR_ICON, px, py);
}
const RUMOUR_ICON = 17;
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
    // §19.6: the map shows alarm as exclamation marks over the village,
    // ramping pale green -> blue -> yellow -> brown -> red.
    const alarm = v.alarm || 0;
    if (alarm > 0 && G.zoom === 0) {
      const ramp = [0x44, 0x36, 0x0E, 0x86, 0x0C];
      const step = Math.min(4, Math.floor(alarm / 32));
      FONT.tiny.draw(ctx, '!'.repeat(step + 1), ox + tx * TILE + 1, oy + ty * TILE - 1,
                     lut(ramp[step]), ink(0));
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
function carriedLabel(typeName) {
  if (typeName === 'Pioneers')
    return `${PIONEER_TOOLS} ${DATA.cargo[TOOLS_CARGO].name}`;
  if (typeName === 'Soldiers') return DATA.text.misc[MISC_VETERAN];
  return typeName;
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
      const cu = unit(c);
      if (cu) sheetFrame(ctx, 'ICONS', cu.icon, 244, cy - 4);
      nationPlate(ctx, 244, cy - 4, DATA.nations[G.nation].color, 1);
      FONT.tiny.draw(ctx, carriedLabel(c), 268, cy, lut(HUD_INK));
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

// ------------------------------------------- colonial authority + orders
// spec/ui/context_dialogs.md §7. @ABANDON carries `@default=2`, so the
// highlighted row is "Never! That would be folly." -- the engine defends you
// against a stray keypress, and the port keeps that default.
function abandonColony() {
  const c = G.colonies[G.colony];
  if (!c) return;
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
    G.msg = `${c.name} is abandoned.`;
  });
}
function renameColony() {
  const c = G.colonies[G.colony];
  if (!c) return;
  openDialog('RENAMECOLONY', (name) => {
    const nm = (name || '').trim();
    if (nm) { G.msg = `${c.name} is renamed ${nm}.`; c.name = nm; }
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
  G.msg = `Travelling to (${x}, ${y}).`;
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
// The eight OUTDOOR jobs: @JOB rows 0..4, 7, 8 (the terrain-table columns) plus
// 22, Scout. This is also the list a native village will teach from (§19.4).
const OUTDOOR_JOBS = [0, 1, 2, 3, 4, 7, 8, 22];
// Which of the eight outdoor jobs pays best on the cell this colonist is on.
// A colonist who already masters an outdoor skill keeps it if the tile yields
// anything at all -- that is what makes an Expert Fur Trapper worth moving.
const OUTDOOR_JOB_NAMES = OUTDOOR_JOBS.map(i => DATA.jobs[i]);
function bestFieldJob(c, p) {
  const cell = p.cell;
  let best = 'Farmer', bestY = -1;
  for (const job of OUTDOOR_JOB_NAMES) {
    const probe = { ...p, job };
    const y = fieldYield(c, probe);
    if (y > bestY) { bestY = y; best = job; }
  }
  if (p.profession) {
    const own = OUTDOOR_JOB_NAMES.find(j => isExpert(p, j));
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
  for (const p of indoor) {
    const job = p.job, g = JOB_GOOD[jobIndex(job)];
    if (g === undefined) continue;
    let want = indoorYield(c, p);
    const raw = RAW_FOR[g];
    if (raw !== undefined) {
      const factory = chainCount(c, job) > 2;
      const avail = c.stock[raw] + out[raw] - consumed[raw];
      const cost = (n) => factory ? Math.floor(n * 2 / 3) : n;
      while (want > 0 && cost(want) > avail) want -= 1;
      consumed[raw] += cost(want);
    }
    if (g >= 0) out[g] += want; else tally[g] += want;
  }
  for (let i = 0; i < consumed.length; i++) out[i] -= consumed[i];
  const eaten = 2 * c.colonists.length;                   // BYTE_VERIFIED @0xA5F2
  return { out, tally, centre, eaten, netFood: out[GOOD.FOOD] - eaten };
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
    const rung = STUDENT_TIERS.indexOf(student.profession);
    if (rung >= 0 && rung < STUDENT_TIERS.length - 1)
      student.profession = STUDENT_TIERS[rung + 1];
    else student.profession = teacher.profession;
    showEvent('TRAINPROFESSION', { STRING0: student.profession, STRING1: c.name });
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
  for (let i = 0; i < c.stock.length; i++) {
    if (i === GOOD.FOOD || c.stock[i] < 100) continue;
    const excess = c.stock[i] - 50;
    c.stock[i] = 50;
    // Custom Houses allow trade after independence (market.md); without one the
    // excess is wasted rather than sold once you have declared. Peter
    // Stuyvesant is what makes the building available at all.
    if (isBoycotted(i)) continue;
    if (G.declared && !c.buildings.includes('Custom House')) continue;
    const gross = excess * G.market[i];
    const tax = Math.floor(gross * G.tax / 100);
    G.gold += gross - tax;
    G.kingsFund += tax;
  }
}
// What a colony may build: an @BUILDING row it does not already have, whose
// min_colony gate its population meets. Cost is the hammers column; tools_x10
// is the tools requirement in tens (§26.8 / @BUILDING).
function buildOptions(c) {
  const pop = c.colonists.length;
  return DATA.buildings
    .map((b, i) => ({ i, ...b }))
    .filter(b => !c.buildings.includes(b.name) && b.min_colony <= pop)
    // Peter Stuyvesant enables the Custom House and nothing else does
    // (func_00B900 @0xBA37).
    .filter(b => b.name !== 'Custom House' || G.fathersOwned.includes('Peter Stuyvesant'));
}
// One colony's whole turn: produce, bank, eat, grow, build, then dispose of the
// overflow.
function colonyTurn(c) {
  const r = colonyProduce(c);
  for (let i = 0; i < r.out.length; i++)
    c.stock[i] = Math.max(0, c.stock[i] + r.out[i]);      // banked with a floor at 0
  // Food: eat first, then the surplus feeds the growth store.
  c.stock[GOOD.FOOD] = Math.max(0, c.stock[GOOD.FOOD] - r.eaten);
  if (r.netFood < 0 && c.stock[GOOD.FOOD] === 0 && c.colonists.length > 1) {
    c.colonists.pop();
    G.msg = `${c.name} is starving! A colonist has been lost.`;
  }
  if (c.stock[GOOD.FOOD] >= FOOD_FOR_COLONIST) {
    c.stock[GOOD.FOOD] -= FOOD_FOR_COLONIST;
    c.colonists.push({ type: 'Colonists', profession: null, job: null, cell: null });
    G.msg = `${c.name} has grown to ${c.colonists.length}.`;
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
  advanceConstruction(c, r.tally[HAMMERS]);
  runSchool(c);
  autoExport(c);
}
// One turn of construction: bank this colony's hammers, then finish the target
// if it is paid for. Tools are consumed with the hammers.
function advanceConstruction(c, hammers) {
  c.hammers += hammers === undefined ? colonyHammers(c) : hammers;
  const b = c.building && DATA.buildings.find(d => d.name === c.building);
  if (!b) return;
  const needTools = b.tools_x10 * 10;
  if (c.hammers < b.cost || c.stock[GOOD.TOOLS] < needTools) return;
  c.hammers -= b.cost;
  c.stock[GOOD.TOOLS] -= needTools;
  c.buildings.push(b.name);
  c.building = null;
  G.msg = `${c.name} completes the ${b.name}.`;
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
  while (G.dockUnits.length && e.passengers.length < 6) e.passengers.push(G.dockUnits.shift());
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
  ctx.imageSmoothingEnabled = false;
  ctx.save();
  ctx.beginPath(); ctx.rect(224, 32, 72, 72); ctx.clip();
  ctx.drawImage(scene, 0, 0, 80, 80, 200, 8, 120, 120);
  ctx.restore();
  hollowRect(ctx, 223, 31, 74, 74, 0);
  // Scene workers are drawn AFTER the upscale, at (cell*24+252, cell*24+60)
  // with cell signed -2..+2 (§26.8). Nothing else goes in this panel: the map's
  // units and colony markers do NOT appear here.
  for (const p of c.colonists) {
    if (!p.cell) continue;
    const u = unit(p.type) || unit('Colonists');
    const [fw, fh] = frameSize('ICONS', u.icon);
    sheetFrame(ctx, 'ICONS', u.icon,
               p.cell[0] * 24 + 252 - (fw >> 1), p.cell[1] * 24 + 60 - (fh >> 1));
  }
  // The white rectangle marks the COLONY-CENTRE TILE, not the 3x3 window:
  // measured at x 248..271, y 56..79 in the capture = the cited (248,56,24,24).
  hollowRect(ctx, 248, 56, 24, 24, 0x0F);

  // COLONY.PIK town strip, 320x72 at y=128, then the panel captions over it.
  ctx.drawImage(IMG.COLONY, 0, 128);
  // Plaza (0,130,120,48): the colonists, left-aligned at the panel origin + 2.
  // Plaza: colonists with no field assignment stand here.
  const idlers = c.colonists.map((p, i) => i).filter(i => !c.colonists[i].cell);
  idlers.forEach((ci, i) => {
    const p = c.colonists[ci];
    const u = unit(p.type) || unit('Colonists');
    if (u) sheetFrame(ctx, 'ICONS', u.icon, 2 + i * 14, 150);
    if (ci === G.colonistSel) hollowRect(ctx, 1 + i * 14, 148, 14, 18, 0x0E);
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
  if (G.colonyPopup) drawColonyPopup(ctx);

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

// ---- colony popups: construction (C) and the jobs menu (Enter) ----
// Both use the §3 dialog framework, same as the Europe menus.
function colonyPopupRows() {
  const c = G.colonies[G.colony];
  if (G.colonyPopup === 'build')
    return buildOptions(c).map(b => ({
      label: b.name,
      note: b.tools_x10 ? `${b.cost}h ${b.tools_x10 * 10}t` : `${b.cost}h`,
    }));
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
  const title = G.colonyPopup === 'build'
    ? `Construction  (${c.hammers} hammers, ${c.stock[GOOD.TOOLS]} tools)`
    : 'Assign this colonist';
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
    c.building = r.label;
    G.msg = `${c.name} begins the ${r.label}.`;
  } else {
    const p = c.colonists[G.colonistSel];
    if (p) {
      p.job = G.colonyPopupRow === 0 ? null : jobForBuilding(r.label);
      p.cell = null;                        // a building job means leaving the fields
      G.msg = p.job ? `${p.type}: ${p.job}` : `${p.type}: no job`;
    }
  }
  G.colonyPopup = null;
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
    // Production. Food carries the byte-verified consumption rule (eaten =
    // 2*pop); every other line is one good this colony actually makes this turn,
    // net of what the chains consume.
    const r = colonyProduce(c);
    FONT.tiny.draw(ctx, 'Production', px, py, lut(PANEL_INK));
    // Food, with its consumption, on the first line.
    sheetFrame(ctx, 'ICONS', 0x16, px, py + 8);
    const net = r.netFood;
    FONT.tiny.draw(ctx, `${r.out[GOOD.FOOD]}-${r.eaten}=${net >= 0 ? '+' : ''}${net}`,
                   px + 10, py + 11, lut(net < 0 ? 0x0C : SOL_INK));
    // Then every other good with a nonzero net, two per row. The panel is only
    // 95x48, so these are named rather than iconned -- the 16px warehouse icons
    // (good + 0x17) collide at this pitch.
    let k = 0;
    for (let i = 1; i < r.out.length && k < 6; i++) {
      if (!r.out[i]) continue;
      const gx = px + (k % 2) * 47, gy = py + 17 + Math.floor(k / 2) * 6;
      const n = r.out[i];
      FONT.tiny.draw(ctx, `${DATA.cargo[i].name.slice(0, 6)} ${n > 0 ? '+' : ''}${n}`,
                     gx, gy, lut(n < 0 ? 0x0C : SOL_INK));
      k += 1;
    }
    // Hammers and the build target.
    const hammers = r.tally[HAMMERS];
    const ty = py + 18 + Math.ceil(k / 2) * 6;
    const target = c.building;
    if (target) {
      const b = DATA.buildings.find(d => d.name === target);
      FONT.tiny.draw(ctx, `${target} ${c.hammers}/${b.cost}`, px, ty, lut(PANEL_INK));
      FONT.tiny.draw(ctx, hammers ? `+${hammers} hammers` : 'no hammers', px, ty + 7,
                     lut(hammers ? SOL_INK : 0x0C));
    } else FONT.tiny.draw(ctx, 'Building nothing', px, ty, lut(PANEL_INK));
  }
  // View buttons.
  for (let k = 0; k < 3; k++) {
    const by = VIEW_BTN.y + k * VIEW_BTN.pitch;
    sheetFrame(ctx, 'ICONS', 67 + k, VIEW_BTN.x, by);
    if (k === G.colonyView) hollowRect(ctx, VIEW_BTN.x - 1, by - 1, 16, 15, 0x0F);
  }
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
  // Panel captions. The screen names ships and states in the panel ink -- it
  // does NOT annotate them with turn counters or quantity readouts, so nothing
  // of that sort is drawn here.
  FONT.tiny.draw(ctx, 'Expected Soon', 16, 120, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toEurope').slice(0, 3).forEach((e, k) =>
    FONT.tiny.draw(ctx, e.type, 16, 128 + k * 7, lut(HUD_INK)));
  FONT.tiny.draw(ctx, 'Bound For', 87, 120, lut(HUD_INK));
  FONT.tiny.draw(ctx, DATA.regionname[G.nation], 87, 127, lut(HUD_INK));
  G.europe.filter(e => e.state === 'toNewWorld').slice(0, 3).forEach((e, k) =>
    FONT.tiny.draw(ctx, e.type, 87, 135 + k * 7, lut(HUD_INK)));

  const ship = activeShip();
  FONT.tiny.draw(ctx, ship ? 'Loading:' : 'No Ships In Port', 150, 120, lut(HUD_INK));
  if (ship) FONT.tiny.draw(ctx, ship.type, 186, 120, lut(HUD_INK));

  // Units waiting on the dock: recruits, trainees and purchased land units
  // stand here until a ship carries them across.
  G.dockUnits.slice(0, 6).forEach((name, k) => {
    const u = unit(name) || unit('Colonists');
    const [fw, fh] = frameSize('ICONS', u.icon);
    const x = 232 + k * 14;
    sheetFrame(ctx, 'ICONS', u.icon, x, 152 - fh);
    nationPlate(ctx, x - 2, 142, DATA.nations[G.nation].color, 1);
  });

  // Ships in port occupy the six dock slots; the hold rides with the ship.
  shipsInPort().forEach((e, k) => {
    if (k >= 6) return;
    sheetFrame(ctx, 'ICONS', 122, 147 + 12 * k, 165);
    if (k === G.euroShip) hollowRect(ctx, 146 + 12 * k, 164, 12, 14, 0x0E);
  });

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
  return PURCHASE_CATALOG.map(r => ({ label: r.unit, cost: purchasePrice(r) }));
}
// The sub-menus are dialogs in the §3 framework, not ad-hoc lists: body text
// from the GAME.TXT section, option rows below it, box_w = content + 2*inset,
// centred. The ECONOMIC ADVISER portrait (MSS2 -- the merchant in the plumed
// hat, identified by rendering all six MSS sheets) sits above the box, which is
// where func_06BF66 draws the speaker.
const EURO_MENU_KEY = { recruit: 'RECRUIT', purchase: 'PURCHASE', train: null };
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
  // @RECRUIT quotes the passage in its body ("{%NUMBER0 gold}") -- fill it from
  // the highlighted candidate, which is the one that slot would cost.
  if (key === 'RECRUIT') {
    const rows0 = euroMenuRows();
    const price = rows0[G.euroMenuRow] ? rows0[G.euroMenuRow].cost : 0;
    body = body.map(l => l.replace('%NUMBER0', String(price)));
  }
  let cw = key ? DATA.dialogs[key].width : 0x50;
  for (const l of body) cw = Math.max(cw, FONT.tiny.width(l));
  for (const r of rows) cw = Math.max(cw, FONT.tiny.width(r.label) + FONT.tiny.width(`${r.cost}$`) + 20);
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
    // readable so you can see what you are saving up for.
    const afford = r.cost <= G.gold;
    const inkIdx = !afford ? 0x5D : (sel ? 0xFC : 0xFE);
    FONT.tiny.draw(ctx, r.label, b.x + 9, y + 1, lut(inkIdx));
    const c = `${r.cost}$`;
    FONT.tiny.draw(ctx, c, b.x + b.w - 8 - FONT.tiny.width(c), y + 1, lut(inkIdx));
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
    G.euroMsg = `${DATA.cargo[i].name} is under boycott.`;
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
const COLONY_FRAME = [3, 0, 1, 2];
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
  const [fw, fh] = frameSize('ICONS', frame);
  sheetFrame(ctx, 'ICONS', frame, px + (TILE - fw) / 2, py + (TILE - fh) / 2);
  if (nation >= 0) {
    // European colonies fly the 6x5 nation pennant (disk 118 + power).
    const [pw2] = frameSize('ICONS', PENNANT_BASE + nation);
    sheetFrame(ctx, 'ICONS', PENNANT_BASE + nation, px + TILE - pw2 - 1, py + 1);
  } else {
    // Tribes have no pennant sprite, so they get the same 6x5 patch in their
    // own @TRIBES colour -- ownership reads identically for both.
    ctx.fillStyle = ink(0); ctx.fillRect(px + TILE - 8, py, 8, 7);
    ctx.fillStyle = ink(tribeColour); ctx.fillRect(px + TILE - 7, py + 1, 6, 5);
  }
  // §19.7: a village carrying a mission is marked with a CROSS in the founding
  // power's colour, and the manual notes a BRIGHTER cross for an expert
  // (Brebeuf) mission. The cross is drawn from primitives -- no dedicated
  // sprite for it has been located in ICONS, so its art is the port's own; the
  // colour, the placement rule and the expert distinction are the spec's.
  if (mission) {
    const c = DATA.nations[mission.power] ? DATA.nations[mission.power].color : 0xFE;
    ctx.fillStyle = ink(0);
    ctx.fillRect(px, py, 5, 7);
    ctx.fillStyle = ink(mission.expert ? 0xFD : c);
    ctx.fillRect(px + 2, py + 1, 1, 5);
    ctx.fillRect(px + 1, py + 2, 3, 1);
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
function villageSell(v, good, qty) {
  const t = G.tribes[v.tribe];
  const paid = villageOffer(v, good, qty);
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
function villageBuy(v, good, qty) {
  const price = villageAsk(v, good, qty);
  if (price > G.gold) return 0;
  G.gold -= price;
  v.stock = v.stock || DATA.cargo.map(() => 0);
  v.stock[good] = Math.max(0, (v.stock[good] || 0) - qty);
  adjustTension(v.tribe, -2);
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
//                European owner, tested against threshold 3*K + 1 (@0x5BEE5).
//                K IS UNTRACED -- the manual says so in as many words. The port
//                carries it as RAID_GATE_K below with a placeholder of 0, so the
//                gate is `roll >= 1`, i.e. a 1-in-12 miss. Flagged.
//   outcome    = random_int(1,4), downgraded while turn < 40*(2-difficulty)
//                (the early-game softener), then dispatched 5 ways:
//                1 STORES, 2 WREAK, 3 GOLD, 4 BURN/SHIP, 0 NOTHING.
// The payloads behind wreak / gold / burn / ship are unmapped in the evidence;
// what each one takes is the port's own, and every one of them is flagged.
const RAID_GATE_K = 0;                   // TBD -- threshold is 3*K+1 @0x5BEE5
function raidOutcome() {
  let out = 1 + Math.floor(Math.random() * 4);
  if (G.turn < 40 * (2 - G.difficulty)) out -= 1;
  return Math.max(0, out);
}
function nativeRaids() {
  if (!G.colonies.length) return;
  for (const v of G.villages) {
    if ((v.alarm || 0) < ALARM_RAID) continue;
    const gate = 1 + Math.floor(Math.random() * 12) - 1 + (G.difficulty - 2);
    if (gate < 3 * RAID_GATE_K + 1) continue;
    const c = G.colonies.slice().sort((a, b) =>
      (Math.abs(a.x - v.x) + Math.abs(a.y - v.y)) - (Math.abs(b.x - v.x) + Math.abs(b.y - v.y)))[0];
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
    if (!G.raidSeen) { G.raidSeen = true; G.woodcut = 13; G.screen = 'woodcut'; }
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
  if (!target) { G.msg = 'We have met no other power to incite them against.'; return; }
  const price = incitePrice(v, target.nation);
  askEvent('INDIANWARPATH2', { STRING0: DATA.nations[target.nation].adjective,
                               NUMBER0: price }, (choice) => {
    if (choice !== 0) return;
    if (G.gold < price) { G.msg = 'The treasury cannot bear it, Your Excellency.'; return; }
    G.gold -= price;
    t.warWith = target.nation;
    G.msg = `The ${t.name} take the warpath against the ${DATA.nations[target.nation].adjective}.`;
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
  return line.replace(/%(STRING|NUMBER)(\d)\$?/g, (m, kind, n) => {
    const v = subs[`${kind}${n}`];
    return v === undefined ? '' : String(v);
  });
}
function showEvent(key, subs) {
  const t = DATA.events[key];
  if (!t) return;
  G.eventQueue.push({ lines: t.body.map(l => fillTemplate(l, subs || {})),
                      width: t.width });
}
// A GAME.TXT event that carries a second paragraph carries OPTION ROWS, so it
// runs through the ordinary dialog framework instead of the notice queue.
function askEvent(key, subs, onDone, optsKey) {
  const t = DATA.events[key];
  if (!t) { if (onDone) onDone(-1); return; }
  // Most event popups carry their own rows in a second paragraph; the King's
  // tax demand instead pairs its pretext body with the shared @TAXOPTIONS rows.
  const rowsFrom = optsKey && DATA.events[optsKey] ? DATA.events[optsKey].body : t.tail;
  const rows = rowsFrom.map(l => fillTemplate(l, subs || {}));
  G.dialog = {
    body: t.body.map(l => fillTemplate(l, subs || {})),
    tail: rows, width: t.width, onDone, opts: rows,
    // Same one-based @default as openDialog above.
    sel: t.default && /^\d+$/.test(t.default)
      ? Math.max(0, Math.min(rows.length - 1, +t.default - 1)) : 0,
  };
}
function drawEvent(ctx) {
  const e = G.eventQueue[0];
  if (!e) return;
  let cw = e.width;
  for (const l of e.lines) cw = Math.max(cw, FONT.tiny.width(l));
  const w = cw + 6, h = 6 + e.lines.length * 6 + 3 + 8 + 3;
  const x = Math.round(160 - w / 2), y = Math.round(100 - h / 2);
  plaque(ctx, x, y, w, h, 'WOODTILE');
  e.lines.forEach((l, i) => spanText(ctx, l, x + 5, y + 6 + i * 6, 0xFE, 0xFC));
  FONT.tiny.center(ctx, '(Continue)', 160, y + h - 10, lut(0xFC));
}

// Walking into a village opens the ten-row @ACTIONS menu (spec/ui/
// context_dialogs.md §6 -- func_04B308 is that table's only consumer).
function enterVillage(v, visitor) {
  G.village = v;
  G.villageVisitor = visitor;
  G.villageRow = 0;
  G.villageMode = 'actions';
  G.screen = 'village';
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
  return G.villageMode === 'trade' ? villageRows().length : villageActions().length;
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
    case 0: case 1: G.villageMode = 'trade'; G.villageRow = 0; return;
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

// The village screen: the chief's greeting, what he is "especially interested
// in" (the top of the sorted demand list), and one row per good in the
// visitor's hold with the offer beside it.
function villageRows() {
  const v = G.village, u = G.villageVisitor;
  const rows = [];
  const hold = (u && u.hold) || [];
  for (const h of hold)
    rows.push({ kind: 'sell', good: h.good, qty: h.qty,
                label: `Sell ${h.qty} ${DATA.cargo[h.good].name}`,
                note: `${villageOffer(v, h.good, h.qty)}$` });
  for (const h of hold)
    rows.push({ kind: 'gift', good: h.good, qty: h.qty,
                label: `Give ${h.qty} ${DATA.cargo[h.good].name} as a gift`, note: '' });
  // What the village offers in return.
  for (const r of villageSurplus(v))
    rows.push({ kind: 'buy', good: r.good, qty: r.qty,
                label: `Buy ${r.qty} ${DATA.cargo[r.good].name}`,
                note: `${villageAsk(v, r.good, r.qty)}$` });
  rows.push({ kind: 'leave', label: 'Take our leave', note: '' });
  return rows;
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
  if (G.villageMode === 'trade') {
    const d = villageDemand(v);
    const top = d.map((n, i) => [n, i]).sort((a, b) => b[0] - a[0])[0];
    const lines = [`"The ${t.name} welcome your trade."`];
    if (top && top[0] > 0)
      lines.push(`"We are especially interested in {${DATA.cargo[top[1]].name}}."`);
    return lines;
  }
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
  const rows = G.villageMode === 'trade' ? villageRows() : villageActions();
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
  if (G.villageMode !== 'trade') {
    const a = villageActions()[G.villageRow];
    if (a) runVillageAction(a.id);
    return;
  }
  const r = villageRows()[G.villageRow];
  if (!r || r.kind === 'leave') { G.screen = 'map'; G.village = null; advance(); return; }
  const v = G.village, u = G.villageVisitor;
  if (r.kind === 'sell') {
    const paid = villageSell(v, r.good, r.qty);
    holdAdd(u, r.good, -r.qty);
    G.msg = `Sold ${r.qty} ${DATA.cargo[r.good].name} for ${paid}$`;
  } else if (r.kind === 'buy') {
    const cost = villageBuy(v, r.good, r.qty);
    if (!cost) { G.msg = 'We cannot afford that, Your Excellency.'; return; }
    u.hold = u.hold || [];
    holdAdd(u, r.good, r.qty);
    G.msg = `Bought ${r.qty} ${DATA.cargo[r.good].name} for ${cost}$`;
  } else {
    villageGift(v, r.good, r.qty);
    holdAdd(u, r.good, -r.qty);
    G.msg = `The ${G.tribes[v.tribe].singular} accept your gift.`;
  }
  G.villageRow = 0;
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
    becomeType(winner, to);
    showEvent('VALOR', { STRING0: DATA.nations[G.nation].adjective,
                         STRING1: 'Veteran', STRING2: to });
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
    if (!G.metAnyone) { G.metAnyone = true; G.woodcut = 10; G.screen = 'woodcut'; }
  }
}
// One rival turn: ships work west until they find a coast, then plant.
function runRivals() {
  for (const r of G.rivals) {
    for (const u of r.units) {
      if (!u.ship) continue;
      const landAhead = [[-1, 0], [0, -1], [0, 1]]
        .map(([dx, dy]) => [u.x + dx, u.y + dy])
        .find(([x, y]) => !tileWater(at(x, y)));
      if (landAhead && r.colonies.length < 6 &&
          !G.colonies.some(c => c.x === landAhead[0] && c.y === landAhead[1]) &&
          !r.colonies.some(c => c.x === landAhead[0] && c.y === landAhead[1]) &&
          !G.villages.some(v => v.x === landAhead[0] && v.y === landAhead[1])) {
        const names = DATA.colonynames[r.nation];
        r.colonies.push({ x: landAhead[0], y: landAhead[1], nation: r.nation,
                          name: names[r.nextColony++ % names.length], level: 0 });
        u.x = Math.min(MAP.w - 1, u.x + 3);      // stand off and look for another site
        continue;
      }
      const nx = u.x - 1;
      if (nx >= 0 && tileWater(at(nx, u.y))) u.x = nx;
      else u.y += (u.y % 2) ? 1 : -1;
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
function createRoute(stops, sea) {
  if (G.routes.length >= MAX_ROUTES) {
    showEvent('TRADEMANY', { NUMBER0: MAX_ROUTES });
    return null;
  }
  const r = { name: routeName(stops), sea, stops: stops.slice(0, MAX_STOPS), cursor: 0 };
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
      const sea = t.stops.includes(STOP_EUROPE) ||
                  t.stops.some(i => G.colonies[i] && coastalColonies().includes(G.colonies[i]));
      const r = createRoute(t.stops, sea);
      G.screen = 'map'; G.trade = null;
      if (r) G.msg = `Trade route "${r.name}" created.`;
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
  const head = t.mode === 'create'
    ? [`Select destination number ${t.stops.length + 1} for route`,
       t.stops.length ? `So far: ${t.stops.map(routeStopName).join(' - ')}` : '']
    : t.mode === 'delete' ? ['Which trade route should we {delete}:']
    : ['Select a trade route:'];
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
    G.msg = 'We retire from the New World.';
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
function signTreaty(a, b) {
  setWar(a, b, REL.WAR, false);
  setWar(b, a, REL.WAR, false);
  setTreaty(a, b, REL.TREATY, true);
  G.parleyLock[b] = G.turn + PARLEY_LOCKOUT;
  showEvent('SIGNTREATY', { STRING0: DATA.nations[a].adjective,
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
// The parley itself. Meeting a rival you are not at war with opens the option
// tree rather than an attack.
function openParley(r) {
  G.parley = r;
  G.parleyRow = 0;
  G.screen = 'parley';
}
function parleyRows() {
  const r = G.parley;
  const rows = [];
  if (!atWar(G.nation, r.nation) && !haveTreaty(G.nation, r.nation))
    rows.push({ id: 'treaty', label: 'Propose a demarcation treaty' });
  if (haveTreaty(G.nation, r.nation))
    rows.push({ id: 'cancel', label: 'Renounce our treaty' });
  if (!atWar(G.nation, r.nation)) rows.push({ id: 'war', label: 'Declare war' });
  else rows.push({ id: 'peace', label: 'Sue for peace' });
  rows.push({ id: 'demand', label: `Demand tribute (${demandValue(500)}$)` });
  rows.push({ id: 'leave', label: 'Take our leave' });
  return rows;
}
function parleyCommit() {
  const r = G.parley, row = parleyRows()[G.parleyRow];
  const close = () => { G.screen = 'map'; G.parley = null; advance(); };
  if (!row || row.id === 'leave') { close(); return; }
  const adj = DATA.nations[r.nation].adjective;
  if (row.id === 'treaty') {
    close();
    askEvent('WORTHY', { STRING0: DATA.nations[r.nation].country,
                         STRING1: DATA.nations[G.nation].adjective, STRING2: adj },
      (choice) => { if (choice === 0) signTreaty(G.nation, r.nation); });
    return;
  }
  if (row.id === 'war') { close(); declareWarOn(G.nation, r.nation); return; }
  if (row.id === 'cancel') {
    close();
    setTreaty(G.nation, r.nation, REL.TREATY, false);
    G.msg = `Our treaty with the ${adj} is renounced.`;
    return;
  }
  if (row.id === 'peace') {
    close();
    // The AI acts on the byte-cited probability gate random_int(1000) <
    // 200*difficulty + 100.
    if (Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100) {
      setWar(G.nation, r.nation, REL.WAR, false);
      setWar(r.nation, G.nation, REL.WAR, false);
      showEvent('WITHDRAW', {});
    } else showEvent('THREATS', {});
    return;
  }
  // Demand tribute: the AI pays only what it can afford (the final gate is an
  // affordability compare against its gold).
  close();
  const want = demandValue(500);
  if ((r.gold || 0) >= want && Math.floor(Math.random() * 1000) < 200 * G.difficulty + 100) {
    r.gold -= want;
    G.gold += want;
    showEvent('GIVECASH', { NUMBER0: want });
  } else showEvent('THREATS', {});
}
function drawParley(ctx) {
  drawMap(ctx);
  const r = G.parley, rows = parleyRows();
  const body = [`The ${DATA.nations[r.nation].adjective} envoy attends you.`,
                atWar(G.nation, r.nation) ? 'We are at {war}.'
                : haveTreaty(G.nation, r.nation) ? 'We are bound by {treaty}.'
                : 'We are at {peace}.'];
  let cw = 190;
  for (const l of body) cw = Math.max(cw, FONT.tiny.width(l));
  for (const row of rows) cw = Math.max(cw, FONT.tiny.width(row.label) + 20);
  const w = cw + 6, textH = body.length * 6;
  const h = 6 + textH + 3 + rows.length * 8 + 3;
  const x = Math.round(160 - w / 2), y = Math.max(10, Math.round(100 - h / 2));
  plaque(ctx, x, y, w, h, 'WOODTILE');
  body.forEach((l, i) => spanText(ctx, l, x + 5, y + 6 + i * 6, 0xFE, 0xFC));
  const seed = y + 6 + textH + 3;
  rows.forEach((row, k) => {
    const ry = seed + k * 8, sel = k === G.parleyRow;
    if (sel) { ctx.fillStyle = ink(SELECT_GAME); ctx.fillRect(x + 3, ry, w - 6, 8); }
    FONT.tiny.draw(ctx, row.label, x + 9, ry + 1, lut(sel ? 0xFC : 0xFE));
  });
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
// spec/systems/events.md. Rumour PRESENCE is procedural, not a stored marker:
// func_006188 hashes the coordinates against the map seed [0x190] --
//   ((x>>2)*0x13 + (y>>2)*0x11 + seed + 8) & 0x1F - (y&3)*4 == (x&3)
// gated on the terrain not being Arctic / Ocean / Sea Lane (0x18/0x19/0x1A).
// The engine adds a third gate on the tile's feature high-nibble being 0xF
// ("none"); the port has no feature-nibble plane, so that gate is not
// reproduced -- flagged. The seed is rolled per game, as the map generator does.
function rumourAt(x, y) {
  const t = tileTerrain(at(x, y));
  if (t >= 0x18) return false;                     // Arctic, Ocean, Sea Lane
  const h = ((x >> 2) * 0x13 + (y >> 2) * 0x11 + G.mapSeed + 8) & 0x1F;
  return h - (y & 3) * 4 === (x & 3) && !G.rumoursDone.has(y * MAP.w + x);
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
      for (let k = 0; k < 8; k++) G.dockUnits.push(rollImmigrant().type || 'Colonists');
      showEvent('LOSTCITY1', {});
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
      // @WOODCUT 12, COLONY DESTROYED.
      G.woodcut = 12; G.screen = 'woodcut';
      showEvent('WARN2', { NUMBER1: G.colonies.length,
                           STRING0: DATA.nations[G.nation].adjective });
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
  askEvent('KINGRECRUIT', { NUMBER0: price, STRING0: extra }, (choice) => {
    if (choice !== 0 || G.gold < price) return;
    G.gold -= price;
    const c = G.colonies[0];
    const x = c ? c.x : G.units[0].x, y = c ? c.y : G.units[0].y;
    for (let i = 0; i < count; i++) {
      const u = mkUnit('Cont. Army', x, y);
      u.veteran = true;
      G.units.push(u);
    }
    G.units.push(mkUnit(extra, x, y));
    G.msg = `${count + 1} mercenaries join us for ${price}$.`;
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
// The segments are SPACED across the span, not packed edge to edge. Measured
// on the live F2 gauge (21_report_F2_religious.png): six filled crosses --
// ICONS frame 56, i.e. engine 0x39 -- at x = 10, 43, 76, 110, 143, 177. That
// is x-start 0x0A exactly as the spec says, at a pitch of ~33 = span/slots.
// TBD: what sets the slot count. 300/33.4 gives 9, but one frame cannot
// separate "9 slots" from "pitch derived some other way", so SLOTS is a
// measured constant here rather than a decoded one.
const GAUGE_EMPTY = 0x38 - 1;
const GAUGE_SLOTS = 9;
function gauge(ctx, x, y, span, filledEngineSprite, value, max) {
  const disk = filledEngineSprite - 1;
  const [fw] = frameSize('ICONS', disk);
  if (!fw) return;
  const pitch = Math.max(fw, Math.floor(span / GAUGE_SLOTS));
  const on = max > 0 ? Math.min(GAUGE_SLOTS, Math.round(GAUGE_SLOTS * value / max)) : 0;
  for (let i = 0; i < on; i++) sheetFrame(ctx, 'ICONS', disk, x + i * pitch, y);
}

// `0x222` enqueue + `0x22C` flush: lay `count` copies of each sprite out
// left-to-right within the span, in order.
function spriteStrip(ctx, x, y, span, items) {
  let cx = x;
  for (const [engineSprite, count] of items) {
    const disk = engineSprite - 1;
    const [fw] = frameSize('ICONS', disk);
    if (!fw) continue;
    for (let i = 0; i < count && cx + fw <= x + span; i++, cx += fw)
      sheetFrame(ctx, 'ICONS', disk, cx, y);
  }
}

// ---- F2 Religious: one crosses gauge -------------------------------------
// spec §4: X=0xA, Y=0x19, span 0x12C, FILLED sprite 0x39, EMPTY 0x38.
function drawReligiousReport(ctx) {
  gauge(ctx, 0x0A, 0x19, 0x12C, 0x39, G.crosses, immigrationThreshold());
  FONT.tiny.draw(ctx, `${G.crosses} / ${immigrationThreshold()}`, 0x0A, 0x19 + 20,
                 lut(REPORT_VALUE_INK));
}

// ---- F3 Continental Congress ---------------------------------------------
// spec §4: bell gauge (X=4, span 0x12C, FILLED 0x3F); rebel/tory sprite strip
// (rebel 0x7C x rebel-count, tory 0x7D x tory-count, x=4); FF name grid at
// columns {4,82,160,238}, step 0x4E, 4 per row, colour 0x61.
const F3_FF_COLS = [4, 82, 160, 238];
function drawCongressReport(ctx) {
  const fh = FONT.tiny.height + 2;
  let y = 24;
  FONT.tiny.draw(ctx, DATA.text.misc[112] || 'Next Continental Congress Session:',
                 4, y, lut(REPORT_NAME_INK));
  y += fh;
  gauge(ctx, 4, y, 0x12C, 0x3F, G.bells, fatherCost());
  y += 12;
  // Rebel sentiment = the mean Sons-of-Liberty percentage across colonies.
  const rebel = G.colonies.length
    ? Math.round(G.colonies.reduce((a, c) => a + (c.sol || 0), 0) / G.colonies.length)
    : 0;
  FONT.tiny.draw(ctx, `${DATA.text.misc[70] || 'Rebel'} ${rebel}%   ` +
                      `${DATA.text.misc[71] || 'Tory'} ${100 - rebel}%`,
                 4, y, lut(REPORT_NAME_INK));
  y += fh;
  spriteStrip(ctx, 4, y, 0x12C,
              [[0x7C, Math.round(rebel / 10)], [0x7D, Math.round((100 - rebel) / 10)]]);
  y += 12;
  FONT.tiny.draw(ctx, DATA.text.misc[85] || 'Expeditionary Force:', 4, y,
                 lut(REPORT_NAME_INK));
  y += fh;
  // REF quartet: engine icons 126/127/10/128 (spec §4, oracle DGROUP read).
  spriteStrip(ctx, 4, y, 0x12C,
              [[126, G.ref.Regulars || 0], [127, G.ref.Cavalry || 0],
               [10, G.ref.Artillery || 0], [128, G.ref['Man-O-War'] || 0]]);
  y += 14;
  FONT.tiny.draw(ctx, DATA.text.misc[86] || 'Founding Fathers:', 4, y,
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
      [`${europeGold(i)}$`, REPORT_GREEN_INK],
      [`${G.market[i]}$`, REPORT_VALUE_INK],
      [`${askPrice(i)}$`, REPORT_VALUE_INK],
    ];
    cells.forEach(([s, k], c) =>
      FONT.tiny.right(ctx, s, F5_VAL_X[c], y, lut(k)));
  });
}
// Tons held and gold realised per commodity. The engine keeps these on the
// PowerRecord (vol_accum +0x5C per the spec); this build tracks what it has:
// the tonnage sitting in colony warehouses, and the running sale total.
const europeTons = (g) => G.colonies.reduce((n, c) => n + (c.stock[g] || 0), 0);
const europeGold = (g) => (G.tradeGold && G.tradeGold[g]) || 0;

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
    spriteStrip(ctx, F10_X, y + 8, 0x12C, [[sprite, Math.min(value, 12)]]);
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
  G.msg = `Religious unrest in ${DATA.nations[G.nation].country} brings new colonists.`;
  G.euroMsg = G.msg;
}

// ------------------------------------------------------------ save / load
// The whole of G is the save: it holds the map view, the units, the colonies,
// the market and the Europe state, and nothing is derived from anything outside
// it except the immutable DATA tables.
const SAVE_KEY = 'colonization.save';
function saveGame() {
  try {
    localStorage.setItem(SAVE_KEY, JSON.stringify(G));
    G.msg = 'Game saved.';
  } catch (e) { G.msg = 'Could not save.'; }
}
function loadGame() {
  try {
    const raw = localStorage.getItem(SAVE_KEY);
    if (!raw) { G.msg = 'No saved game.'; return; }
    Object.assign(G, JSON.parse(raw));
    G.openMenu = -1; G.dialog = null; G.colonyPopup = null; G.euroMenu = null;
    G.msg = 'Game loaded.';
  } catch (e) { G.msg = 'Could not load.'; }
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
  else { G.season = (G.season + 1) % 2; if (G.season === 0) G.year += 1; }
  for (const u of G.units) u.movesLeft = u.moves;
  revealAll();
  payUpkeep();
  for (const c of G.colonies) colonyTurn(c);
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
  nativeRaids();
  runRivals();
  kingTaxDemand();
  advanceTradeRoutes();
  advanceGoTo();
  runWar();
  toryUprising();
  shoreBombardment();
  spanishSuccession();
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
  // Moving onto a tile held by a native, a rival or the King's expeditionary
  // force is an attack (§14).
  const foe = G.natives.find(n => n.x === nx && n.y === ny) ||
              G.refUnits.find(n => n.x === nx && n.y === ny);
  if (foe) {
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
      const ru = rival.units.find(x => x.x === nx && x.y === ny);
      // Ship against ship runs the raw guns/hull roll, not the modifier chain.
      if (ru && u.ship && ru.ship) { if (navalAttack(u, ru)) advance(); return; }
      if (ru) { resolveAttack(u, ru); advance(); return; }
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
    openParley(rival);
    return;
  }
  const vil = G.villages.find(v => v.x === nx && v.y === ny);
  if (vil) { u.movesLeft = 0; enterVillage(vil, u); return; }
  // The right-edge sea-lane column is the route home: a ship that enters it
  // sails for Europe and leaves the map (CLAUDE.md hard rule 2, terrain 26).
  if (u.ship && tileTerrain(at(nx, ny)) === TERR.SEALANE) { sailForEurope(u); return; }
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
  G.msg = DATA.orders[n].name;
  u.movesLeft = 0;
  advance();
}
// Clear/Plow and Build Road are only open to a unit carrying tools, and the
// tile has to be worth the work: no road where one already runs, no plow on a
// tile already plowed or still forested (that is a clear), no work at sea.
function improveOrder(n) {
  const u = G.units[G.sel];
  if (!u) return;
  if (!canImprove(u)) {
    G.msg = u && u.ship ? 'Ships cannot work the land.'
                        : 'Only a unit carrying tools can do that.';
    return;
  }
  if (tileWater(at(u.x, u.y))) { G.msg = 'Nothing to improve at sea.'; return; }
  if (n === ORDER_ROAD && hasRoad(u.x, u.y)) { G.msg = 'A road already runs here.'; return; }
  if (n === ORDER_CLEAR && !isForested(tileTerrain(at(u.x, u.y))) && hasPlow(u.x, u.y)) {
    G.msg = 'This field is already plowed.'; return;
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
  'Move Pieces': () => { G.viewMode = false; G.msg = 'Move mode.'; },
  'View Pieces': () => { G.viewMode = true; G.msg = 'View mode.'; },
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
  'Show Hidden Terrain': () => { G.showHidden = !G.showHidden;
                                 G.msg = `Hidden terrain ${G.showHidden ? 'on' : 'off'}.`; },
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
    case 'woodcut':
      // Woodcut 1 is the discovery plate and hands over to the naming prompt;
      // woodcut 2 is BUILDING A COLONY and hands over to the new colony.
      if (G.woodcut === 1) { G.screen = 'map'; askLandName(); }
      else if (G.woodcut === 2) G.screen = 'colony';
      else G.screen = 'map';
      break;
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
        G.colonyPopup = null;
        return;
      }
      const c = G.colonies[G.colony];
      // Scene panel: a click on one of the nine visible cells puts the selected
      // plaza colonist to work that field, or calls a worker back in.
      if (c && hit(mx, my, { x: 224, y: 32, w: 72, h: 72 })) {
        const cx = Math.floor((mx - 224) / 24) - 1, cy = Math.floor((my - 32) / 24) - 1;
        if (cx === 0 && cy === 0) return;                 // the centre works itself
        const on = c.colonists.find(p => p.cell && p.cell[0] === cx && p.cell[1] === cy);
        if (on) { on.cell = null; on.job = null; G.msg = `${on.type} returns to the plaza.`; }
        else {
          const idle = c.colonists.find(p => !p.cell);
          // The engine puts a colonist on the field's BEST job, and a second
          // click on an occupied cell cycles them off. Ties go to the earlier
          // @JOB row, which puts Farmer first.
          if (idle) {
            idle.cell = [cx, cy];
            idle.job = bestFieldJob(c, idle);
            G.msg = `${idle.type}: ${idle.job}`;
          }
        }
        return;
      }
      // Plaza: click a colonist to select, click again for the jobs menu.
      if (c && hit(mx, my, { x: 0, y: 130, w: 120, h: 48 })) {
        const idlers = c.colonists.map((p, i) => i).filter(i => !c.colonists[i].cell);
        const k = Math.floor((mx - 2) / 14);
        if (k >= 0 && k < idlers.length) {
          if (G.colonistSel === idlers[k]) { G.colonyPopup = 'jobs'; G.colonyPopupRow = 0; }
          else G.colonistSel = idlers[k];
        }
        return;
      }
      for (let k = 0; k < 3; k++) {
        if (hit(mx, my, { x: VIEW_BTN.x, y: VIEW_BTN.y + k * VIEW_BTN.pitch,
                          w: VIEW_BTN.w, h: VIEW_BTN.h })) { G.colonyView = k; return; }
      }
      if (hit(mx, my, { x: 306, y: 179, w: 15, h: 21 })) G.screen = 'map';
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
  // 3 = LOAD Game, 4 = View Hall of Fame (neither implemented yet).
  if (G.menuRow <= 2) G.screen = 'difficulty';
}

function onKey(e) {
  const k = e.key;
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
    case 'parley': {
      const n = parleyRows().length;
      if (k === 'ArrowUp') G.parleyRow = (G.parleyRow + n - 1) % n;
      if (k === 'ArrowDown') G.parleyRow = (G.parleyRow + 1) % n;
      if (k === 'Enter' || k === ' ') parleyCommit();
      if (k === 'Escape' || k === 'x') { G.screen = 'map'; G.parley = null; advance(); }
      break;
    }
    case 'village': {
      const n = villageRowCount();
      if (k === 'ArrowUp') G.villageRow = (G.villageRow + n - 1) % n;
      if (k === 'ArrowDown') G.villageRow = (G.villageRow + 1) % n;
      if (k === 'Enter' || k === ' ') villageCommit();
      // Esc backs out of the trade list to the action menu, and out of the
      // action menu to the map.
      if (k === 'Escape' || k === 'x') {
        if (G.villageMode === 'trade') { G.villageMode = 'actions'; G.villageRow = 0; }
        else { G.screen = 'map'; G.village = null; advance(); }
      }
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
     colony: drawColony, europe: drawEurope, pedia: drawPedia,
     report: drawReport, village: drawVillage, parley: drawParley,
     trade: drawTrade, options: drawOptions }[G.screen])(ctx);
  // The Combat Analysis panel and the event popups sit over whatever screen is
  // up when they fire; the panel is read first and dismissed first.
  if (G.combat) drawCombat(ctx);
  drawEvent(ctx);
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
