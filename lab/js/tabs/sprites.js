// tabs/sprites.js — Sprite Verification (M1: full table + per-frame inspector).
//
// Everything mechanical here is B: frame rects come straight from the bundle the
// C++ reads (viceroy_cpp/build/bundle). The only non-B values are the SEMANTIC
// frame ROLES, which carry their own tier+citation via sprite_roles.js — a role
// is shown with a badge, or "—" when nothing is cited (never a guess).
import { el, section, fireRendered } from '../ui.js';
import { renderVal, B, V, TBD_, badge, TIER } from '../provenance.js';
import { loadSheetFrames, sheetImageURL } from '../data/loaders.js';
import { roleFor, isPlaceholder, PHYS0_PLACEHOLDER_INDICES } from '../data/sprite_roles.js';

// Honest label for a placeholder frame: PHYS0's named 0/16/100 cite hard rule 5;
// any other 1×1 frame is just an empty/corrupt slot, not a hard-rule skip.
function placeholderLabel(f, sheet) {
  if (sheet === 'PHYS0' && PHYS0_PLACEHOLDER_INDICES.has(f.i)) return 'placeholder [hard rule 5]';
  return '1×1 stub';
}

// CLAUDE.md hard rules worth surfacing as a sanity check on the sheet picker.
const HARD_RULES = {
  PHYS0:   'Overlay sheet (forest/mountain/hill/river/road/coast/resource). Rivers = rows 0x01/0x11; true coasts 150–153 [hard rule 4].',
  TERRAIN: 'Base-ground sheet, loaded at boot+map-enter [hard rule 5, amended 2026-06-22].',
  ICONS:   'Units 100–105/109, ships 5–7/14–15/127, commodities 22–37 [hard rule 6].',
  BDARK:   'ORPHAN — never load [hard rule 5]. (Not in the bundle — see skipped[].)',
};

export async function render(host, ctx) {
  const manifest = await ctx.manifestData();
  const sheets = manifest.sprites.slice().sort();
  const skipped = manifest.skipped || [];

  // --- controls -----------------------------------------------------------
  const picker = el('select', { class: 'picker' },
    ...sheets.map((s) => el('option', { value: s }, s)));
  picker.value = sheets.includes('PHYS0') ? 'PHYS0' : sheets[0];

  const hidePh = el('input', { type: 'checkbox', id: 'hide-ph' });
  hidePh.checked = true;
  const filter = el('input', { class: 'num', placeholder: 'idx or WxH…', size: 10 });

  const info = el('div', { class: 'sheet-info' });
  const stats = el('div', { class: 'sheet-info' });
  const atlasWrap = el('div', { class: 'atlas-wrap' });
  const inspector = el('div', { class: 'inspector frame-inspector' },
    el('div', { class: 'hint' }, 'Click a frame box or table row to inspect it.'));
  const framesWrap = el('div', { class: 'frames-wrap' });

  picker.addEventListener('change', () => showSheet(picker.value));
  hidePh.addEventListener('change', () => repaint());
  filter.addEventListener('input', () => repaint());

  host.append(
    section('Sprite verification',
      el('p', { class: 'hint' },
        'Loaded from the vendored sprite atlases (', el('code', {}, 'lab/assets'),
        ', a committed copy of the bundle the C++ reads) — frame rects are byte-accurate. ',
        el('b', {}, 'Role'), ' = what a frame depicts (ship / foot unit / river / commodity icon…). ',
        'Cited roles show B/A; uncited frames give a red editable box — type what it is and it’s saved as a ',
        'candidate catalog entry (exported from Settings, feeds ', el('code', {}, 'notes/SPRITE_CATALOG.md'), ').'),
      el('div', { class: 'row' },
        el('label', {}, 'Sheet: '), picker,
        el('label', { class: 'gap' }, el('span', {}, hidePh), ' hide placeholders'),
        el('label', { class: 'gap' }, 'filter '), filter),
      info, stats,
      skipped.length ? el('p', { class: 'hint' }, '⛔ skipped (orphans, never loaded): ', el('code', {}, skipped.join(', '))) : null),
    section('Atlas + inspector',
      el('div', { class: 'sprite-layout' },
        el('div', { class: 'atlas-col' }, atlasWrap),
        inspector)),
    section('Frames', framesWrap),
  );

  // --- per-sheet state ----------------------------------------------------
  let data = null;          // {sheet,nframes,atlas,frames}
  let atlasImg = null;      // loaded HTMLImageElement (for canvas crops)
  let selected = null;      // selected frame index
  const overlay = el('div', { class: 'atlas-overlay' });

  async function showSheet(name) {
    data = await loadSheetFrames(name);
    selected = null;
    info.innerHTML = '';
    stats.innerHTML = '';
    atlasWrap.innerHTML = '';
    framesWrap.innerHTML = '';
    overlay.innerHTML = '';

    info.append(
      el('span', {}, 'frames: '), renderVal(B(data.nframes, `${name}.json nframes`)),
      el('span', { class: 'gap' }, 'atlas: '),
      renderVal(B(`${data.atlas.w}×${data.atlas.h}`, `${name}.json atlas`)));
    if (HARD_RULES[name]) info.append(el('div', { class: 'rule-note' }, '⚑ ', HARD_RULES[name]));

    // Derived B stats — all computed from the byte-true frame list.
    const real = data.frames.filter((f) => !isPlaceholder(f, name));
    const sizes = new Set(real.map((f) => `${f.w}×${f.h}`));
    stats.append(
      el('span', {}, 'real frames: '), renderVal(B(real.length, `${name}: non-placeholder count`)),
      el('span', { class: 'gap' }, 'placeholders: '),
      renderVal(B(data.frames.length - real.length, `${name}: 1×1 stubs` + (name === 'PHYS0' ? ' incl. 0/16/100 [hard rule 5]' : ''))),
      el('span', { class: 'gap' }, 'distinct sizes: '),
      renderVal(B([...sizes].sort().join(', ') || '—', `${name}: distinct real-frame dimensions`)));

    // Atlas image + clickable frame-box overlay.
    const img = el('img', { class: 'atlas-img', src: sheetImageURL(name), alt: name });
    const stage = el('div', { class: 'atlas-stage' }, img, overlay);
    atlasWrap.append(stage);
    atlasImg = img;
    img.addEventListener('load', () => {
      stage.style.width = img.naturalWidth + 'px';
      stage.style.height = img.naturalHeight + 'px';
      repaint();
    });
    if (img.complete && img.naturalWidth) {
      stage.style.width = img.naturalWidth + 'px';
      stage.style.height = img.naturalHeight + 'px';
      repaint();
    }
  }

  // Does a frame pass the current hide/filter controls?
  function visible(f) {
    if (hidePh.checked && isPlaceholder(f, data.sheet)) return false;
    const q = filter.value.trim().toLowerCase();
    if (!q) return true;
    if (q.includes('x')) return `${f.w}x${f.h}` === q;        // size match "16x16"
    return String(f.i) === q || `0x${f.i.toString(16)}` === q; // index match (dec or hex)
  }

  function repaint() {
    if (!data) return;
    const frames = data.frames.filter(visible);
    drawOverlay(frames);
    drawTable(frames);
    drawInspector();
    fireRendered();
  }

  function drawOverlay(frames) {
    overlay.innerHTML = '';
    for (const f of frames) {
      if (f.w <= 1 && f.h <= 1) continue;                      // un-clickable stubs
      const box = el('div', { class: 'fbox' + (isPlaceholder(f, data.sheet) ? ' skip' : '') + (f.i === selected ? ' sel' : '') });
      box.style.cssText += `left:${f.ax}px;top:${f.ay}px;width:${f.w}px;height:${f.h}px`;
      const r = roleFor(data.sheet, f.i);
      box.title = `#${f.i} ${f.w}×${f.h}` + (r ? ` — ${r.role}` : '') + (isPlaceholder(f, data.sheet) ? ' (placeholder)' : '');
      box.addEventListener('click', () => select(f.i));
      overlay.append(box);
    }
  }

  function drawTable(frames) {
    framesWrap.innerHTML = '';
    const head = el('thead', {}, el('tr', {},
      ...['#', 'src x,y', 'atlas x,y', 'w×h', 'role'].map((c) => el('th', {}, c))));
    const body = el('tbody', {}, ...frames.map((f) => {
      const r = roleFor(data.sheet, f.i);
      const tr = el('tr', {
        class: (isPlaceholder(f, data.sheet) ? 'skip' : '') + (f.i === selected ? ' sel' : ''),
      },
        el('td', {}, String(f.i)),
        el('td', {}, `${f.x},${f.y}`),
        el('td', {}, `${f.ax},${f.ay}`),
        el('td', {}, `${f.w}×${f.h}`),
        el('td', {}, r ? roleCell(r) : (isPlaceholder(f, data.sheet) ? placeholderLabel(f, data.sheet) : editableRole(data.sheet, f.i))));
      tr.addEventListener('click', () => select(f.i));
      return tr;
    }));
    framesWrap.append(el('table', { class: 'data' }, head, body),
      el('p', { class: 'hint' }, `showing ${frames.length} of ${data.frames.length} frames`));
  }

  function roleCell(r) {
    const span = el('span', { class: `val tier-${r.tier.toLowerCase()}`, title: `${r.tier}\n${r.cite}` },
      el('span', { class: 'val-text' }, r.role));
    span.append(badge(r.tier));
    return span;
  }

  // Uncited frame → an editable TBD role the user can populate. The label is stored
  // in the override registry (id role.<sheet>.<i>) and travels into the export, so
  // labelling a frame here contributes a candidate sprite-catalog entry.
  function editableRole(sheet, i) {
    return renderVal(TBD_('', `role: user-labelled (candidate for notes/SPRITE_CATALOG.md) — ${sheet} #${i}`,
      { id: `role.${sheet}.${i}` }));
  }

  function select(i) {
    selected = (selected === i) ? null : i;
    repaint();
  }

  function drawInspector() {
    inspector.innerHTML = '';
    if (selected == null) {
      inspector.append(el('div', { class: 'hint' }, 'Click a frame box or table row to inspect it.'));
      return;
    }
    const f = data.frames.find((x) => x.i === selected);
    if (!f) { inspector.append(el('div', { class: 'hint' }, 'frame not found')); return; }

    // Zoomed canvas crop straight from the atlas (8× nearest-neighbour).
    const scale = Math.max(1, Math.min(12, Math.floor(160 / Math.max(f.w, f.h, 1))));
    const cv = el('canvas', { class: 'frame-canvas', width: f.w * scale, height: f.h * scale });
    if (atlasImg && atlasImg.naturalWidth && f.w > 1 && f.h > 1) {
      const g = cv.getContext('2d');
      g.imageSmoothingEnabled = false;
      g.drawImage(atlasImg, f.ax, f.ay, f.w, f.h, 0, 0, f.w * scale, f.h * scale);
    }
    const r = roleFor(data.sheet, f.i);

    inspector.append(
      el('h3', {}, `Frame #${f.i}`),
      cv,
      kv('source .SS rect', B(`${f.x},${f.y}`, `${data.sheet}.json frame ${f.i} (x,y)`)),
      kv('atlas rect', B(`${f.ax},${f.ay}`, `${data.sheet}.json frame ${f.i} (ax,ay)`)),
      kv('size', B(`${f.w}×${f.h}`, `${data.sheet}.json frame ${f.i} (w,h)`)),
      kv('index (hex)', B(`0x${f.i.toString(16)}`, `${data.sheet}.json frame ${f.i}`)),
      el('div', { class: 'kv' }, el('span', { class: 'k' }, 'role'),
        r ? renderVal(V(r.role, r.tier, r.cite))
          : (isPlaceholder(f, data.sheet) ? el('span', {}, placeholderLabel(f, data.sheet)) : editableRole(data.sheet, f.i))),
    );
  }

  function kv(label, val) {
    return el('div', { class: 'kv' }, el('span', { class: 'k' }, label), renderVal(val));
  }

  await showSheet(picker.value);
}
