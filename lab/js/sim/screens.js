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
// Position is B (DS:0x266). The FRAME is seeded from the live Jamestown capture
// (colony_live_1505.bin, RULINGS 2026-06-27): occupied plot frame = building def_id
// (byte[0x8E82+i], def_id 0→16); empty plot draws BUILDING terrain frame = DS:0x260[cat]−1
// (cat = byte[0x8D62+i]). All MSE-0 verified vs the capture. Editable (per-colony RNG).
//                 x    y   frame  (negative def_id ⇒ empty plot → terrain frame)
const COLONY_PLOTS = [
  [56, 5, 44], [145, 7, 44], [173, 10, 32], [8, 33, 27], [37, 37, 39],
  [67, 46, 24], [96, 45, 21], [6, 6, 43], [128, 45, 43], [10, 68, 43],
  [15, 94, 35], [87, 3, 42], [66, 79, 9], [123, 98, 16], [123, 47, 45],
].map(([x, y, frame], i) => ({
  id: `plot${i}`, label: `building plot ${i}`, type: 'sprite', sheet: 'BUILDING',
  frame, x, y: y + 8,
  tier: 'B', cite: `DS:0x266 plot[${i}], y=table_y+8 (func_02701C); frame=BUILDING ${frame} — Jamestown live capture, MSE-0 (RULINGS 2026-06-27); editable (per-colony RNG)`,
}));

// Stockpile bar — BYTE-VERIFIED (colony_screen.cpp §6): 16 cells, pitch 19, x0=1,
// icon row y=181; icon = good + 0x16 ⇒ ICONS frame 22 (Food) … 37 (Muskets).
const STOCKPILE_GOODS = ['Food', 'Sugar', 'Tobacco', 'Cotton', 'Furs', 'Lumber', 'Ore', 'Silver',
  'Horses', 'Rum', 'Cigars', 'Cloth', 'Coats', 'Trade Goods', 'Tools', 'Muskets'];
// Icon x = each icon CENTERED in its 19px cell (cell left = 2+i·19). These exact left
// edges were MSE-0 matched against the live capture (RULINGS 2026-06-27) — the icons have
// varying widths, so a flat 2+i·19 left-aligns them; these center them.
const STOCKPILE_X = [7, 25, 44, 62, 82, 100, 119, 138, 156, 178, 196, 215, 234, 253, 272, 292];
const STOCKPILE_BAR = STOCKPILE_GOODS.map((g, i) => ({
  id: `stock${i}`, label: `stockpile: ${g}`, type: 'sprite', sheet: 'ICONS',
  frame: 0x16 + i, x: STOCKPILE_X[i], y: 181,
  tier: 'B', cite: `colony_screen.cpp §6: icon y=181, centered in cell 2+${i}·19; icon=good+0x16 (ICONS ${0x16 + i}); MSE-0 vs live capture (RULINGS 2026-06-27)`,
}));
// stockpile quantity numbers + band text are drawn as CRISP FONTTINY bitmap text on the
// backdrop canvas (op:'text'), NOT blurry CSS <div>s. Colours measured from the live capture:
// qty digits are dark navy (24,41,64), not white.
const COLONY_TEXT_OPS = [
  ...STOCKPILE_GOODS.map((g, i) => ({ op: 'text', value: '0', x: 8 + i * 19, y: 192, color: '#18293f' })),
  { op: 'text', value: '100% (I)', x: 64, y: 132, color: '#ffffff' },
  { op: 'text', value: 'No Ships In Port', x: 130, y: 132, color: '#5a7ab0' },
];
// COLONY.PIK band overlays — ICONS frames MSE-0 matched to the live Jamestown capture
// (RULINGS 2026-06-27). colonists/production/SoL are state-specific (this colony); editable.
const BAND_OVERLAYS = [
  [81, 2, 142], [102, 16, 142],            // colonist figures (SoL panel)
  [22, 2, 163], [56, 40, 163], [62, 52, 163], // production: Food + cross + bell
  [124, 104, 132],                          // SoL crown
  [23, 213, 134], [55, 213, 162],           // production-arrows panel
  [67, 304, 133], [68, 303, 147], [69, 303, 162], [54, 306, 162], // right tool buttons / Exit
].map(([frame, x, y], i) => ({
  id: `band${i}`, label: `band overlay ${i} (ICONS ${frame})`, type: 'sprite', sheet: 'ICONS',
  frame, x, y, tier: 'B', cite: `COLONY.PIK band overlay, ICONS ${frame} — MSE-0 vs live capture (RULINGS 2026-06-27); state-specific`,
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
    // Composited backdrop. Parchment scene rect + black separators MEASURED from the
    // matched live capture (docs/screens/colony_live_1505.png, RULINGS 2026-06-27):
    // parchment = x0..198 y8..127; black separators at x=199 (scene|minimap), y=7
    // (title|scene), y=128 (scene|band). (Was PARCH 4,8,204,120 with no separators.)
    backdrop: [
      { op: 'tile', sheet: 'WOODTILE', x: 0, y: 0, w: 320, h: 200 },
      { op: 'tile', sheet: 'PARCH', x: 0, y: 8, w: 199, h: 120 },
      { op: 'image', bg: 'COLONY', x: 0, y: 128 },
      { op: 'rect', color: '#000', x: 199, y: 7, w: 1, h: 122 },   // scene | minimap panel
      { op: 'rect', color: '#000', x: 0, y: 7, w: 320, h: 1 },     // title | scene
      { op: 'rect', color: '#000', x: 0, y: 128, w: 320, h: 1 },   // scene | COLONY.PIK band
      // surrounding-tile minimap — rendered by the shared lab/js/sim/mapview.js compositor
      // (NOT a parallel renderer). Box x223..296 y31..104 MEASURED from the live capture
      // (vertically centered in the y8..127 panel). A coastal sample window stands in for the
      // colony's own surroundings (inspector demo).
      { op: 'rect', color: '#000', x: 222, y: 30, w: 75, h: 76 },  // black box frame
      { op: 'minimap', x: 223, y: 31, w: 73, h: 73, cols: 5, rows: 5 },
      ...COLONY_TEXT_OPS,                                          // crisp FONTTINY text (qty + band)
    ],
    note: 'Composited like the real screen: wood chrome (WOODTILE) + parchment scene inset (PARCH x0..198 y8..127, measured) + COLONY.PIK band at y=128 + black area separators (x199 / y7 / y128, measured). BYTE-CITED (B): the 15 building plots (DS:0x266, func_02701C; a plot FRAME = building def_id byte[0x8E82+i], def_id 0→frame 16 — RULINGS 2026-06-27) and the 16-cell stockpile bar (x=2+i·19, icon y=181, ICONS 22+good — colony_screen.cpp §6). WHICH building fills each plot is RNG-driven (func_025D34) so per-plot def_id is editable. The surrounding-tile minimap reuses lab/js/sim/mapview.js (terrainCompose); its window/scale + work-tile/marker overlays are TBD (func_026374). Panel text not seeded.',
    elements: [...COLONY_PLOTS, ...BAND_OVERLAYS, ...STOCKPILE_BAR],
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
