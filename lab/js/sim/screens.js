// sim/screens.js — definitions for the Screens tab: each game screen = a vendored
// background + a set of overlay ELEMENTS (sprites / text fields) you can select,
// drag, re-sprite, and (for reports) feed test values that render live.
//
// Provenance applies to POSITIONS too: a coordinate is B only where the C++/EXE
// pins it (e.g. the colony building plots, DS:0x266, colony_screen.cpp). Most
// report-field positions are NOT byte-decoded yet → they start as TBD/R and you
// drag them onto the real backdrop to find them. Export captures what you place,
// so the lab doubles as a UI-position measuring tool (the UI documentation mandate).

// Colony building plots — BYTE-VERIFIED positions. The 15 (x, table_y) pairs are the
// DS:0x266 plot table; the painter func_02701C @0x02701C reads [bx+0x266]/[bx+0x268]
// over 15 entries (CMP [bp-8],0xf) and draws at y = table_y + 8 (ADD cx,8 @0x02708F).
// ⚠ Position is B; WHICH building fills each plot is RNG-driven (func_025D34) → the
// sprite FRAME is a placeholder (TBD), so leave frame editable.
const COLONY_PLOTS = [
  [56, 5], [145, 7], [173, 10], [8, 33], [37, 37], [67, 46], [96, 45], [6, 6],
  [128, 45], [10, 68], [15, 94], [87, 3], [66, 79], [123, 98], [123, 47],
].map(([x, y], i) => ({
  id: `plot${i}`, label: `building plot ${i}`, type: 'sprite', sheet: 'BUILDING',
  frame: i, x, y: y + 8,
  tier: 'B', cite: `DS:0x266 plot[${i}], render y=table_y+8 (func_02701C @0x02708F) — POSITION B; building→frame is RNG (func_025D34), so frame=TBD`,
}));

// Stockpile bar — BYTE-VERIFIED (colony_screen.cpp §6): 16 cells, pitch 19, x0=1,
// icon row y=181; icon = good + 0x16 ⇒ ICONS frame 22 (Food) … 37 (Muskets).
const STOCKPILE_GOODS = ['Food', 'Sugar', 'Tobacco', 'Cotton', 'Furs', 'Lumber', 'Ore', 'Silver',
  'Horses', 'Rum', 'Cigars', 'Cloth', 'Coats', 'Trade Goods', 'Tools', 'Muskets'];
const STOCKPILE_BAR = STOCKPILE_GOODS.map((g, i) => ({
  id: `stock${i}`, label: `stockpile: ${g}`, type: 'sprite', sheet: 'ICONS',
  frame: 0x16 + i, x: 1 + i * 19, y: 181,
  tier: 'B', cite: `colony_screen.cpp §6: x=1+${i}·19, icon y=181; icon=good+0x16 (ICONS ${0x16 + i})`,
}));

// A report data field = a label + an editable test VALUE, rendered as text. Position
// modeled (R/TBD) until measured — drag it onto the backdrop.
const field = (id, label, value, x, y, opts = {}) => ({
  id, label, type: 'text', value: String(value), x, y,
  color: opts.color || 'white', tier: opts.tier || 'TBD',
  // BLOCKER (investigated 2026-06-24): the F2–F9 report painters render in overlay
  // 0x191F / the orphan code (orphans_load_image.asm, ~118k lines); field positions
  // are loop/table-driven there and not yet traced. So report-field coords are TBD
  // (drag to measure), NOT fabricated. Only the TITLE index is byte-cited.
  cite: opts.cite || 'TBD: report field rendered in overlay 0x191F (orphans_load_image.asm); position not yet traced — drag to measure',
});

export const SCREENS = {
  economic: {
    name: 'Economic Adviser (F5)', bg: 'REPORT5', w: 320, h: 200, scale: 2,
    note: 'REPORT5.PIK backdrop (scales/currency/hourglass). Title text is byte-cited (MISC[65]); the per-commodity price rows are MODELED positions — drag them onto the panel and enter test prices; the screen updates live.',
    elements: [
      field('title', 'title', 'ECONOMIC ADVISER REPORT', 70, 6, { tier: 'B', cite: 'MISC[65] (docs/ADVISOR_REPORTS_AUDIT.md)' }),
      field('gold', 'gold', 'Gold: 1000', 20, 30),
      field('tax', 'tax %', 'Tax: 15%', 20, 40),
      field('p_food', 'Food price', 'Food   2', 20, 60),
      field('p_sugar', 'Sugar price', 'Sugar  6', 20, 70),
      field('p_rum', 'Rum price', 'Rum    11', 20, 80),
      field('p_cigars', 'Cigars price', 'Cigars 11', 20, 90),
      field('p_cloth', 'Cloth price', 'Cloth  12', 20, 100),
      field('p_coats', 'Coats price', 'Coats  11', 20, 110),
    ],
  },
  colony: {
    name: 'Colony screen — plots + stockpile', w: 320, h: 200, scale: 2,
    // Composited backdrop (matches colony_screen.cpp): wood-grain chrome (WOODTILE
    // tiled) → parchment scene inset (PARCH tiled, SCENE 4,8,204,120) → COLONY.PIK
    // bottom band at y=128. NOT a single image — that's why the plain-image version
    // looked broken (black void above the band).
    backdrop: [
      { op: 'tile', sheet: 'WOODTILE', x: 0, y: 0, w: 320, h: 200 },
      { op: 'tile', sheet: 'PARCH', x: 4, y: 8, w: 204, h: 120 },
      { op: 'image', bg: 'COLONY', x: 0, y: 128 },
    ],
    note: 'Composited like the real screen: wood chrome (WOODTILE) + parchment scene inset (PARCH, 4,8,204,120) + COLONY.PIK band at y=128. BYTE-CITED (B): the 15 building plots (DS:0x266, func_02701C) and the 16-cell stockpile bar (x=1+i·19, icon y=181, ICONS 22+good — colony_screen.cpp §6). WHICH building fills each plot is RNG-driven (func_025D34) so a plot’s FRAME is TBD (editable). The 3×3 worked-tiles grid + panel text aren’t seeded yet.',
    elements: [...COLONY_PLOTS, ...STOCKPILE_BAR],
  },
  colonyReport: {
    name: 'Colony Adviser (F6)', bg: 'REPORT4', w: 320, h: 200, scale: 2,
    note: 'REPORT4.PIK backdrop (pioneers building a colony). Title byte-cited (MISC[66]); the per-colony rows are MODELED — drag + enter test values.',
    elements: [
      field('title', 'title', 'COLONY ADVISER REPORT', 74, 6, { tier: 'B', cite: 'MISC[66] (docs/ADVISOR_REPORTS_AUDIT.md)' }),
      field('c1', 'colony 1', 'Jamestown   pop 6   SoL 50%', 20, 30),
      field('c2', 'colony 2', 'Plymouth    pop 4   SoL 33%', 20, 42),
      field('c3', 'colony 3', 'Boston      pop 8   SoL 72%', 20, 54),
    ],
  },
  europe: {
    name: 'Europe (high seas / docks)', bg: 'EUROPE', w: 320, h: 200, scale: 2,
    note: 'EUROPE.PIK backdrop. No byte-cited element positions seeded yet — add elements (a unit sprite or a price label), drag them into place, and export the coordinates.',
    elements: [],
  },
};

// All vendored backgrounds, so any screen can be opened as a blank measuring canvas.
export const ALL_BACKGROUNDS = [
  'COLONY', 'EUROPE', 'REPORT1', 'REPORT2', 'REPORT3', 'REPORT4', 'REPORT5',
  'REPORT6', 'REPORT7', 'REPORT8', 'REPORT9', 'CUSTOMIZ', 'DIFFICUL', 'NATIONS',
];
