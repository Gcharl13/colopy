// tabs/settings.js — Settings & Export (M0: provenance ledger view + export center).
import { el, section, fireRendered } from '../ui.js';
import { ledger, overrides, TIER_META } from '../provenance.js';
import { buildSnapshot, downloadJSON } from '../export.js';

export async function render(host, ctx) {
  // Touch the other tabs' data so the ledger reflects a full session if the user
  // lands here first. (Cheap: cached in ctx.)
  await Promise.all([ctx.tablesData(), ctx.manifestData(), ctx.mapData()]).catch(() => {});

  const summaryEl = el('div', { class: 'big-summary' });
  const modeledEl = el('div', { class: 'modeled-list' });
  const renderLedger = () => {
    summaryEl.innerHTML = ''; modeledEl.innerHTML = '';
    const s = ledger.summary();
    for (const [t, n] of Object.entries(s)) {
      summaryEl.append(el('span', { class: `sum-chip big tier-${t.toLowerCase()}`, title: TIER_META[t].blurb }, `${t}: ${n}`));
    }
    const modeled = ledger.modeled();
    if (!modeled.length) { modeledEl.append(el('p', { class: 'hint' }, 'No modeled (R/TBD) values recorded yet — visit the other tabs first.')); return; }
    modeledEl.append(el('table', { class: 'data' },
      el('thead', {}, el('tr', {}, ...['tier', 'citation', 'default', 'override'].map((c) => el('th', {}, c)))),
      el('tbody', {}, ...modeled.map((m) => el('tr', { class: m.tier === 'TBD' ? 'tier-tbd' : 'tier-r' },
        el('td', {}, m.tier),
        el('td', { class: 'cite' }, m.cite),
        el('td', {}, String(m.value ?? '—')),
        el('td', {}, m.override != null ? String(m.override) : '—'))))));
  };

  const exportBtn = el('button', { class: 'btn primary',
    onclick: () => downloadJSON(buildSnapshot({ note: 'M0 snapshot — per-tab payloads added in later milestones' })) },
    'Export snapshot (JSON)');
  const clearBtn = el('button', { class: 'btn',
    onclick: () => { overrides.clearAll(); renderLedger(); } }, 'Clear all overrides');

  window.addEventListener('lab:override', renderLedger);
  window.addEventListener('lab:rendered', renderLedger);

  host.append(
    section('Provenance ledger',
      el('p', { class: 'hint' }, 'Tally of every value shown this session, by tier. The point of the tool: ',
        el('b', {}, 'B'), ' wrong = a real bug; ', el('b', {}, 'R/TBD'), ' wrong = a modeled placeholder (tune the assumption).'),
      summaryEl,
      el('h3', {}, 'Modeled (R / TBD) values & overrides'),
      modeledEl),
    section('Export center',
      el('p', { class: 'hint' }, 'Snapshot carries a provenance manifest (tier counts + every modeled value + your overrides) so the exported data is self-describing. CSV time-series export arrives with the per-turn sim (M2).'),
      el('div', { class: 'row' }, exportBtn, clearBtn)),
    section('Global settings (M5)',
      el('p', { class: 'hint' }, 'Difficulty, palette choice (viceroy ↔ PHYS0), scale — wired in M5.')),
  );
  renderLedger();
  fireRendered();
}
