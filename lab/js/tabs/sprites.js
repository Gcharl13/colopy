// tabs/sprites.js — Sprite Verification (M0 thin: sheet picker + atlas + frame table).
// All values here are B: they come straight from the bundle the C++ reads.
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B } from '../provenance.js';
import { loadSheetFrames, sheetImageURL } from '../data/loaders.js';

// CLAUDE.md hard rules worth surfacing as a sanity check on the sheet picker.
const HARD_RULES = {
  PHYS0:   'Overlay sheet (forest/mountain/hill/river/road/coast/resource). Rivers = rows 0x01/0x11 [B].',
  TERRAIN: 'Base-ground sheet, loaded at boot+map-enter (CLAUDE.md hard rule 5, amended 2026-06-22) [B].',
  BDARK:   'ORPHAN — never load (CLAUDE.md hard rule 5) [B].',
};
const SKIP_FRAMES = new Set([0, 16, 100]); // placeholder indices per CLAUDE.md hard rule 5.

export async function render(host, ctx) {
  const manifest = await ctx.manifestData();
  const sheets = manifest.sprites.slice().sort();

  const picker = el('select', { class: 'picker' },
    ...sheets.map((s) => el('option', { value: s }, s)));
  const info = el('div', { class: 'sheet-info' });
  const atlasWrap = el('div', { class: 'atlas-wrap' });
  const framesWrap = el('div', { class: 'frames-wrap' });

  picker.value = sheets.includes('PHYS0') ? 'PHYS0' : sheets[0];
  picker.addEventListener('change', () => showSheet(picker.value));

  host.append(
    section('Sprite verification',
      el('p', { class: 'hint' },
        'Loaded directly from the bundle the C++ reads (', el('code', {}, 'viceroy_cpp/build/bundle'),
        ') — these frames are byte-accurate. Pick a sheet to inspect its atlas and per-frame rects.'),
      el('div', { class: 'row' }, el('label', {}, 'Sheet: '), picker, info)),
    section('Atlas', atlasWrap),
    section('Frames', framesWrap),
  );

  async function showSheet(name) {
    info.innerHTML = '';
    atlasWrap.innerHTML = '';
    framesWrap.innerHTML = '';
    const data = await loadSheetFrames(name);

    info.append(
      el('span', {}, 'frames: '), renderVal(B(data.nframes, `${name}.json nframes`)),
      el('span', { class: 'gap' }, '  atlas: '),
      renderVal(B(`${data.atlas.w}×${data.atlas.h}`, `${name}.json atlas`)),
    );
    if (HARD_RULES[name]) info.append(el('div', { class: 'rule-note' }, '⚑ ', HARD_RULES[name]));

    // Atlas image with a frame grid overlay.
    const img = el('img', { class: 'atlas-img', src: sheetImageURL(name), alt: name });
    const overlay = el('div', { class: 'atlas-overlay' });
    const stage = el('div', { class: 'atlas-stage' }, img, overlay);
    atlasWrap.append(stage);
    img.addEventListener('load', () => {
      stage.style.width = img.naturalWidth + 'px';
      stage.style.height = img.naturalHeight + 'px';
      for (const f of data.frames) {
        if (f.w <= 1 && f.h <= 1) continue;
        const box = el('div', { class: 'fbox' + (SKIP_FRAMES.has(f.i) ? ' skip' : '') });
        box.style.cssText += `left:${f.ax}px;top:${f.ay}px;width:${f.w}px;height:${f.h}px`;
        box.title = `#${f.i} ${f.w}×${f.h}` + (SKIP_FRAMES.has(f.i) ? ' (placeholder — skip per hard rule)' : '');
        overlay.append(box);
      }
    });

    // Frame table (first 64 for M0; deepened in M1).
    const rows = data.frames.slice(0, 64);
    const tbl = el('table', { class: 'data' },
      el('thead', {}, el('tr', {}, ...['i', 'x', 'y', 'w', 'h', 'ax', 'ay', 'note'].map((c) => el('th', {}, c)))),
      el('tbody', {}, ...rows.map((f) => el('tr', { class: SKIP_FRAMES.has(f.i) ? 'skip' : '' },
        ...['i', 'x', 'y', 'w', 'h', 'ax', 'ay'].map((c) => el('td', {}, String(f[c]))),
        el('td', {}, SKIP_FRAMES.has(f.i) ? 'placeholder (hard rule)' : '')))));
    framesWrap.append(tbl,
      data.frames.length > 64 ? el('p', { class: 'hint' }, `… ${data.frames.length - 64} more (full table in M1)`) : null);

    fireRendered();
  }

  await showSheet(picker.value);
}
