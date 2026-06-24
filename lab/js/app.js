// app.js — shell bootstrap: tab nav, shared data load, provenance summary.
import { tierLegend, ledger } from './provenance.js';
import { loadPalette, loadTables, loadManifest, loadMap } from './data/loaders.js';

import * as sprites from './tabs/sprites.js';
import * as mechanics from './tabs/mechanics.js';
import * as market from './tabs/market.js';
import * as mapTab from './tabs/map.js';
import * as worldgen from './tabs/worldgen.js';
import * as screens from './tabs/screens.js';
import * as settings from './tabs/settings.js';

const TABS = { sprites, mechanics, market, map: mapTab, worldgen, screens, settings };

// Shared context handed to every tab. Data loaded once, lazily, and cached.
export const ctx = {
  palette: null, tables: null, manifest: null, map: null,
  async paletteData() { return this.palette ??= await loadPalette(); },
  async tablesData()  { return this.tables  ??= await loadTables(); },
  async manifestData(){ return this.manifest??= await loadManifest(); },
  async mapData()     { return this.map     ??= await loadMap(); },
};

const host = document.getElementById('tabhost');
const statusEl = document.getElementById('status');
let current = null;

export function setStatus(msg, kind = '') {
  statusEl.textContent = msg || '';
  statusEl.className = `status ${kind}`;
}

function refreshSummary() {
  const s = ledger.summary();
  const el = document.getElementById('prov-summary');
  el.innerHTML = '';
  for (const [t, n] of Object.entries(s)) {
    const chip = document.createElement('span');
    chip.className = `sum-chip tier-${t.toLowerCase()}`;
    chip.textContent = `${t}:${n}`;
    el.append(chip);
  }
}

async function activate(name) {
  if (current === name) return;
  current = name;
  for (const b of document.querySelectorAll('.tab-btn')) b.classList.toggle('active', b.dataset.tab === name);
  host.innerHTML = '';
  ledger.reset();                         // tally per active tab view
  setStatus(`loading ${name}…`);
  try {
    await TABS[name].render(host, ctx);
    setStatus('');
  } catch (e) {
    setStatus(`error in ${name}: ${e.message}`, 'err');
    host.innerHTML = `<div class="errbox"><h3>Failed to load “${name}”</h3><pre>${e.stack || e.message}</pre>
      <p>If this is a fetch error, make sure you launched the tool with a static server from the repo root:
      <code>python3 -m http.server</code> then open <code>http://localhost:8000/lab/</code>.</p></div>`;
  }
  refreshSummary();
}

function init() {
  document.getElementById('legend-slot').append(tierLegend());
  for (const b of document.querySelectorAll('.tab-btn')) b.addEventListener('click', () => location.hash = b.dataset.tab);
  window.addEventListener('hashchange', () => activate((location.hash.slice(1)) || 'sprites'));
  window.addEventListener('lab:override', refreshSummary);
  // re-tally after a tab re-renders values
  window.addEventListener('lab:rendered', refreshSummary);
  activate((location.hash.slice(1)) || 'sprites');
}

init();
