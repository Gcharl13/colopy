// sim/screens.js — definitions for the Screens tab: each game screen = a vendored
// background + a set of overlay ELEMENTS (sprites / text fields) you can select,
// drag, re-sprite, and (for reports) feed test values that render live.
//
// Provenance applies to POSITIONS too: a coordinate is B only where the C++/EXE
// pins it (e.g. the colony building plots, DS:0x266, colony_screen.cpp). Most
// report-field positions are NOT byte-decoded yet → they start as TBD/R and you
// drag them onto the real backdrop to find them. Export captures what you place,
// so the lab doubles as a UI-position measuring tool (the UI documentation mandate).

// Building TYPE → BUILDING.SS frame defaults (first 15, colony_screen.cpp BUILD_FRAME).
const COLONY_PLOTS = [
  [56, 5], [145, 7], [173, 10], [8, 33], [37, 37], [67, 46], [96, 45], [6, 6],
  [128, 45], [10, 68], [15, 94], [87, 3], [66, 79], [123, 98], [123, 47],
].map(([x, y], i) => ({
  id: `plot${i}`, label: `building plot ${i}`, type: 'sprite', sheet: 'BUILDING',
  frame: i, x, y: y + 8,                       // render y = table_y + 8 (colony_screen.cpp)
  tier: 'B', cite: `DS:0x266 plot[${i}] (colony_screen.cpp) — render y=table_y+8`,
}));

// A report data field = a label + an editable test VALUE, rendered as text. Position
// modeled (R/TBD) until measured — drag it onto the backdrop.
const field = (id, label, value, x, y, opts = {}) => ({
  id, label, type: 'text', value: String(value), x, y,
  color: opts.color || 'white', tier: opts.tier || 'TBD',
  cite: opts.cite || 'MODELED: report field position not byte-decoded — drag to measure',
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
    name: 'Colony screen — building plots', bg: 'COLONY', w: 320, h: 72, scale: 2,
    note: 'COLONY.PIK field backdrop with the 15 building plots at their byte-cited (B) DS:0x266 positions. Select a plot to drag it or change its BUILDING.SS frame (the “change sprites” path). Plot coords are byte-true; the sprite frame per plot is editable.',
    elements: COLONY_PLOTS,
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
