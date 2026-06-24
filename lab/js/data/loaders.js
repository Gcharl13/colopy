// loaders.js — fetch the committed, byte-verified data the lab reads.
//
// Paths are relative to /lab/index.html, served by `python3 -m http.server` at
// the repo root. So `../data_extracted/...` resolves to the committed JSON, and
// `../viceroy_cpp/build/bundle/...` to the regenerable sprite bundle (the SAME
// bytes the C++ reads — pure B for sprite verification).

const DATA = '../data_extracted';
const BUNDLE = '../viceroy_cpp/build/bundle';

async function getJSON(url) {
  const r = await fetch(url);
  if (!r.ok) throw new Error(`fetch ${url} -> ${r.status} ${r.statusText}`);
  return r.json();
}

// 256-entry palette: [{index,r,g,b,hex}, ...]  (data_extracted/palette.json) [B]
export async function loadPalette() {
  const arr = await getJSON(`${DATA}/palette.json`);
  const rgb = new Uint8Array(256 * 3);
  for (const c of arr) { rgb[c.index * 3] = c.r; rgb[c.index * 3 + 1] = c.g; rgb[c.index * 3 + 2] = c.b; }
  return { entries: arr, rgb };
}

// NAMES.TXT typed tables (@CARGO/@UNFORESTED/@FORESTED/@BUILDING/@JOB/...) [B]
export async function loadTables() {
  return getJSON(`${DATA}/tables/names_tables.json`);
}

// Sprite bundle manifest (list of sheet names) + per-sheet frames loader.
export async function loadManifest() {
  return getJSON(`${BUNDLE}/manifest.json`);
}
export async function loadSheetFrames(name) {
  return getJSON(`${BUNDLE}/sprites/${name}.json`);   // {sheet,nframes,atlas,frames:[{i,x,y,w,h,ax,ay}]}
}
export function sheetImageURL(name) {
  return `${BUNDLE}/sprites/${name}.png`;             // paletted PNG atlas
}

// AMER2 map tile grid (committed via tools/extract_mp.py) [B].
// Returns {width,height,tiles:Uint8Array} — tiles are raw map bytes.
export async function loadMap(name = 'AMER2_tiles') {
  const d = await getJSON(`${DATA}/map/${name}.json`);
  return { width: d.width, height: d.height, tiles: Uint8Array.from(d.tiles), source: d.source_file };
}

// Helper: turn a {kind:'csv',columns,rows} table into rows keyed by column name.
export function rowsOf(table) {
  return Array.isArray(table?.rows) ? table.rows : [];
}
