// ui.js — tiny DOM helpers (no framework).
export function el(tag, attrs = {}, ...children) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'class') e.className = v;
    else if (k === 'html') e.innerHTML = v;
    else if (k.startsWith('on') && typeof v === 'function') e.addEventListener(k.slice(2), v);
    else if (v != null) e.setAttribute(k, v);
  }
  for (const c of children.flat()) if (c != null) e.append(c.nodeType ? c : document.createTextNode(c));
  return e;
}
export const h = (tag) => (attrs, ...kids) => el(tag, attrs, ...kids);

// Build a <table> from columns + rows-of-objects; `cell(col,row)` may return a node.
export function dataTable(columns, rows, cell) {
  const thead = el('tr', {}, ...columns.map((c) => el('th', {}, c)));
  const body = rows.map((row, i) => el('tr', {}, ...columns.map((c) => {
    const node = cell ? cell(c, row, i) : null;
    return el('td', {}, node != null ? node : String(row[c] ?? ''));
  })));
  return el('table', { class: 'data' }, el('thead', {}, thead), el('tbody', {}, ...body));
}

export function section(title, ...kids) {
  return el('section', { class: 'panel' }, el('h2', {}, title), ...kids);
}

export function fireRendered() { window.dispatchEvent(new CustomEvent('lab:rendered')); }
