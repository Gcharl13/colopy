// tabs/screens.js — Screens: render a game screen (Colony / Europe / Reports) on
// its real vendored backdrop, then SELECT, DRAG, re-sprite, or feed test values to
// each overlay element — the screen updates live. Element POSITIONS carry tiers:
// byte-cited (B, e.g. the colony plots) vs modeled (R/TBD, drag to measure). Export
// captures the layout you place, so this doubles as a UI-coordinate measuring tool.
import { el, section, fireRendered } from '../ui.js';
import { badge } from '../provenance.js';
import { loadSheetFrames, sheetImageURL, backgroundImageURL } from '../data/loaders.js';
import { SCREENS, ALL_BACKGROUNDS } from '../sim/screens.js';
import { loadSheet } from '../sim/sheet.js';
import { compositeRegion } from '../sim/compose.js';
import { isWater } from '../sim/mapview.js';

// FONTTINY bitmap font (ASCII-indexed) — crisp small text drawn onto the backdrop canvas,
// instead of blurry CSS <div> text. Tinted to any colour via source-in compositing.
let _fonttiny = null;
async function fonttiny() {
  if (_fonttiny) return _fonttiny;
  const [img, meta] = await Promise.all([
    new Promise((r) => { const i = new Image(); i.onload = () => r(i); i.src = './assets/fonts/FONTTINY.png'; }),
    fetch('./assets/fonts/FONTTINY.json').then((r) => r.json()),
  ]);
  return (_fonttiny = { img, frames: meta.frames });
}
function drawBitmapText(g, font, str, x, y, color) {
  const tmp = document.createElement('canvas'); const tg = tmp.getContext('2d');
  let cx = x;
  for (const ch of String(str)) {
    const f = font.frames[ch.charCodeAt(0)];
    if (!f || f.w <= 0) { cx += 3; continue; }
    tmp.width = f.w; tmp.height = f.h; tg.imageSmoothingEnabled = false;
    tg.clearRect(0, 0, f.w, f.h);
    tg.globalCompositeOperation = 'source-over';
    tg.drawImage(font.img, f.ax, f.ay, f.w, f.h, 0, 0, f.w, f.h);
    tg.globalCompositeOperation = 'source-in';
    tg.fillStyle = color; tg.fillRect(0, 0, f.w, f.h);
    g.drawImage(tmp, cx, y);
    cx += f.w;
  }
}

// Pick a coastal cols×rows window (land + water) from the map, for the colony minimap demo.
function coastalWindow(map, cols, rows) {
  for (let y = 0; y + rows < map.height; y += 2)
    for (let x = 0; x + cols < map.width; x += 2) {
      let land = 0, water = 0;
      for (let r = 0; r < rows; r++)
        for (let c = 0; c < cols; c++)
          (isWater(map.tiles[(y + r) * map.width + (x + c)] & 0x1F) ? water++ : land++);
      if (land >= rows * cols * 0.3 && water >= rows * cols * 0.3) return { x, y };
    }
  return { x: 0, y: 0 };
}

const TIER_CLS = { B: 'tier-b', A: 'tier-a', R: 'tier-r', TBD: 'tier-tbd' };

export async function render(host, ctx) {
  // screen picker: the seeded screens + any raw background as a blank canvas
  const keys = Object.keys(SCREENS);
  const picker = el('select', { class: 'picker' },
    el('optgroup', { label: 'seeded screens' }, ...keys.map((k) => el('option', { value: k }, SCREENS[k].name))),
    el('optgroup', { label: 'blank backdrops (measure)', ...{} },
      ...ALL_BACKGROUNDS.map((b) => el('option', { value: `bg:${b}` }, `${b}.PIK`))));

  const stageWrap = el('div', { class: 'screen-stagewrap' });
  const tableWrap = el('div', { class: 'screen-table' });
  const noteEl = el('p', { class: 'hint' });
  const exportOut = el('pre', { class: 'export-out', style: 'display:none' });

  // per-sheet atlas <img> + frames cache (for sprite elements)
  const atlasCache = new Map();
  async function atlas(sheet) {
    if (atlasCache.has(sheet)) return atlasCache.get(sheet);
    const p = (async () => {
      const frames = await loadSheetFrames(sheet);
      const img = new Image(); img.src = sheetImageURL(sheet);
      await img.decode().catch(() => {});
      return { frames, img };
    })();
    atlasCache.set(sheet, p);
    return p;
  }

  let scr = null, els = [], scale = 2, selected = null;

  function loadScreen(val) {
    if (val.startsWith('bg:')) {
      const bg = val.slice(3);
      scr = { name: `${bg}.PIK`, bg, w: 320, h: 200, scale: 2, note: 'Blank measuring canvas — add elements and drag them to read off coordinates.', elements: [] };
    } else {
      scr = SCREENS[val];
    }
    scale = scr.scale || 2;
    els = scr.elements.map((e) => ({ ...e }));   // working clone (edits don't mutate defs)
    selected = null;
    noteEl.textContent = scr.note || '';
    buildStage();
    buildTable();
  }

  // --- the stage: background (image or composited canvas) + element overlays ---
  let stage, bgImg;
  function buildStage() {
    stageWrap.innerHTML = '';
    stage = el('div', { class: 'screen-stage' });
    stage.style.width = scr.w * scale + 'px';
    stage.style.height = scr.h * scale + 'px';
    if (scr.backdrop) {
      // composited backdrop (e.g. colony: wood + parch inset + PIK band)
      const cv = el('canvas', { class: 'screen-bg', width: scr.w, height: scr.h });
      cv.style.width = scr.w * scale + 'px'; cv.style.height = scr.h * scale + 'px';
      stage.append(cv);
      buildBackdrop(cv);
    } else {
      bgImg = el('img', { class: 'screen-bg', src: backgroundImageURL(scr.bg), alt: scr.bg });
      bgImg.style.width = scr.w * scale + 'px';
      bgImg.style.top = (scr.bgY || 0) * scale + 'px';
      stage.append(bgImg);
    }
    for (const e of els) stage.append(makeElDiv(e));
    stageWrap.append(stage);
  }

  // Execute a backdrop recipe onto a 320×200 canvas via drawImage (the browser
  // resolves each indexed PNG's palette + transparency for us).
  async function buildBackdrop(cv) {
    const g = cv.getContext('2d'); g.imageSmoothingEnabled = false;
    for (const step of scr.backdrop) {
      if (step.op === 'image') {
        const img = await loadImg(backgroundImageURL(step.bg));
        g.drawImage(img, step.x, step.y);
      } else if (step.op === 'tile') {
        const { frames, img } = await atlas(step.sheet);
        const f = frames.frames[0];
        if (!f || f.w <= 0) continue;
        for (let y = step.y; y < step.y + step.h; y += f.h)
          for (let x = step.x; x < step.x + step.w; x += f.w) {
            const dw = Math.min(f.w, step.x + step.w - x), dh = Math.min(f.h, step.y + step.h - y);
            g.drawImage(img, f.ax, f.ay, dw, dh, x, y, dw, dh);
          }
      } else if (step.op === 'rect') {            // solid fill (e.g. black area separators)
        g.fillStyle = step.color || '#000';
        g.fillRect(step.x, step.y, step.w, step.h);
      } else if (step.op === 'sprite') {          // a single sheet frame drawn onto the backdrop
        const { frames, img } = await atlas(step.sheet);
        const f = frames.frames.find((x) => x.i === step.frame);
        if (f && f.w > 0 && img.naturalWidth) g.drawImage(img, f.ax, f.ay, f.w, f.h, step.x, step.y, f.w, f.h);
      } else if (step.op === 'text') {            // crisp FONTTINY bitmap text (tinted)
        const font = await fonttiny();
        drawBitmapText(g, font, step.value, step.x, step.y, step.color || '#18293f');
      } else if (step.op === 'minimap') {         // surrounding-terrain via the shared mapview.js
        try {
          const map = await ctx.mapData();
          const [terr, phys] = await Promise.all([loadSheet('TERRAIN'), loadSheet('PHYS0')]);
          const cols = step.cols || 5, rows = step.rows || 5;
          const win = coastalWindow(map, cols, rows);
          const region = compositeRegion(map, terr, phys, win.x, win.y, cols, rows);
          g.drawImage(region, 0, 0, region.width, region.height, step.x, step.y, step.w, step.h);
        } catch (e) { /* map/sheets unavailable: leave the panel woodgrain */ }
      }
    }
  }
  function loadImg(src) {
    return new Promise((res) => { const i = new Image(); i.onload = () => res(i); i.src = src; i.decode?.().then(() => res(i)).catch(() => {}); });
  }

  function makeElDiv(e) {
    const d = el('div', { class: 'screen-el ' + e.type, 'data-id': e.id });
    d.style.left = e.x * scale + 'px';
    d.style.top = e.y * scale + 'px';
    if (e.type === 'text') {
      d.style.color = e.color === 'white' ? '#fff' : e.color;
      d.style.fontSize = (6 * scale) + 'px';
      d.textContent = e.value;
    } else if (e.type === 'sprite') {
      const cv = el('canvas', { class: 'screen-sprite' });
      d.append(cv);
      paintSprite(cv, e);
    } else if (e.type === 'box') {            // selection-box outline (e.g. the colonist marker)
      d.style.width = (e.w * scale) + 'px';
      d.style.height = (e.h * scale) + 'px';
      d.style.border = `${scale}px solid ${e.color || '#55ff55'}`;
      d.style.boxSizing = 'border-box';
      d.style.pointerEvents = 'none';
    }
    d._el = e;
    if (e.id === selected) d.classList.add('sel');
    d.addEventListener('mousedown', (ev) => startDrag(ev, e, d));
    return d;
  }

  async function paintSprite(cv, e) {
    const { frames, img } = await atlas(e.sheet);
    const f = frames.frames.find((x) => x.i === Number(e.frame)) || frames.frames[0];
    if (!f) return;
    cv.width = Math.max(1, f.w) * scale; cv.height = Math.max(1, f.h) * scale;
    const g = cv.getContext('2d'); g.imageSmoothingEnabled = false;
    if (img.naturalWidth) g.drawImage(img, f.ax, f.ay, f.w, f.h, 0, 0, f.w * scale, f.h * scale);
  }

  // --- dragging --------------------------------------------------------------
  function startDrag(ev, e, d) {
    ev.preventDefault();
    selectEl(e.id);
    const sx = ev.clientX, sy = ev.clientY, ex = e.x, ey = e.y;
    const move = (m) => {
      e.x = clamp(Math.round(ex + (m.clientX - sx) / scale), 0, scr.w - 1);
      e.y = clamp(Math.round(ey + (m.clientY - sy) / scale), 0, scr.h - 1);
      d.style.left = e.x * scale + 'px'; d.style.top = e.y * scale + 'px';
      syncRow(e);
    };
    const up = () => { document.removeEventListener('mousemove', move); document.removeEventListener('mouseup', up); };
    document.addEventListener('mousemove', move);
    document.addEventListener('mouseup', up);
  }

  function selectEl(id) {
    selected = id;
    for (const d of stage.querySelectorAll('.screen-el')) d.classList.toggle('sel', d._el.id === id);
    for (const tr of tableWrap.querySelectorAll('tr[data-id]')) tr.classList.toggle('sel', tr.dataset.id === id);
  }

  // --- the test-value / position table (two-way bound to the stage) ----------
  function buildTable() {
    tableWrap.innerHTML = '';
    const head = el('thead', {}, el('tr', {},
      ...['element', 'type', 'x', 'y', 'value / frame', 'pos tier'].map((c) => el('th', {}, c))));
    const body = el('tbody', {}, ...els.map((e) => rowFor(e)));
    tableWrap.append(el('table', { class: 'data' }, head, body));
  }

  function rowFor(e) {
    const xIn = numInput(e.x, (v) => { e.x = v; positionDiv(e); });
    const yIn = numInput(e.y, (v) => { e.y = v; positionDiv(e); });
    let valCell;
    if (e.type === 'box') {
      valCell = el('span', { class: 'val' }, `${e.w}×${e.h}`);
    } else if (e.type === 'text') {
      valCell = el('input', { class: 'val-input txt', value: e.value });
      valCell.addEventListener('input', () => { e.value = valCell.value; const d = divFor(e); if (d) d.textContent = e.value; });
    } else {
      valCell = el('input', { type: 'number', class: 'num', value: String(e.frame), min: 0 });
      valCell.addEventListener('input', () => { e.frame = Number(valCell.value) || 0; const d = divFor(e); if (d) paintSprite(d.querySelector('canvas'), e); });
    }
    const tr = el('tr', { 'data-id': e.id, class: e.id === selected ? 'sel' : '' },
      el('td', {}, e.label + (e.type === 'sprite' ? ` (${e.sheet})` : '')),
      el('td', {}, e.type),
      el('td', {}, xIn), el('td', {}, yIn),
      el('td', {}, valCell),
      el('td', {}, posTier(e)));
    tr.addEventListener('click', (ev) => { if (ev.target.tagName !== 'INPUT') selectEl(e.id); });
    e._row = { xIn, yIn };
    return tr;
  }

  function posTier(e) {
    const span = el('span', { class: `val ${TIER_CLS[e.tier] || 'tier-tbd'}`, title: e.cite },
      el('span', { class: 'val-text' }, e.tier === 'B' ? 'byte-cited' : 'modeled'));
    span.append(badge(e.tier));
    return span;
  }

  // keep stage ⇄ table in sync
  const divFor = (e) => stage.querySelector(`.screen-el[data-id="${e.id}"]`);
  function positionDiv(e) { const d = divFor(e); if (d) { d.style.left = e.x * scale + 'px'; d.style.top = e.y * scale + 'px'; } }
  function syncRow(e) { if (e._row) { e._row.xIn.value = e.x; e._row.yIn.value = e.y; } }

  function numInput(v, onChange) {
    const i = el('input', { type: 'number', class: 'num', value: String(v) });
    i.addEventListener('input', () => onChange(Number(i.value) || 0));
    return i;
  }

  // --- export ----------------------------------------------------------------
  const exportBtn = el('button', { class: 'btn' }, 'Export layout (JSON)');
  exportBtn.addEventListener('click', () => {
    const out = {
      screen: scr.name, background: scr.bg, size: `${scr.w}×${scr.h}`,
      elements: els.map((e) => ({
        id: e.id, label: e.label, type: e.type, x: e.x, y: e.y,
        ...(e.type === 'text' ? { value: e.value } : { sheet: e.sheet, frame: e.frame }),
        positionTier: e.tier, cite: e.cite,
      })),
    };
    exportOut.style.display = 'block';
    exportOut.textContent = JSON.stringify(out, null, 2);
  });

  picker.addEventListener('change', () => loadScreen(picker.value));

  host.append(
    section('Screens — composite, select, drag, and feed test values',
      el('p', { class: 'hint' },
        'Render a screen on its real backdrop, then ', el('b', {}, 'click an element to select'), ', drag it to ',
        'reposition (the x,y update live — a coordinate-measuring tool), change a sprite’s frame, or type test ',
        'values. Position ', el('b', {}, 'tier'), ' marks byte-cited (B) vs modeled (drag to measure).'),
      el('div', { class: 'row' }, el('label', {}, 'screen '), picker,
        el('span', { class: 'gap' }), exportBtn),
      noteEl,
      el('div', { class: 'screen-layout' },
        el('div', { class: 'map-scroll' }, stageWrap),
        el('div', {}, el('h3', {}, 'elements — test values & positions'), tableWrap)),
      exportOut),
  );

  loadScreen(picker.value);
  fireRendered();
}

function clamp(v, lo, hi) { return v < lo ? lo : v > hi ? hi : v; }
