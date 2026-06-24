// export.js — export center. Produces a provenance-annotated snapshot so a wrong
// number is always attributable (B = report bug; R/TBD = modeled, see assumption).
import { ledger, overrides } from './provenance.js';

// Build the canonical JSON snapshot: a manifest header (tier counts) + the modeled
// ledger (every R/TBD value + current override) + per-tab payloads supplied by callers.
export function buildSnapshot(payloads = {}) {
  return {
    tool: 'colopy-lab',
    generated_hint: 'open from a turn/scenario you set up in the lab',
    provenance: {
      summary: ledger.summary(),                 // {B,A,R,TBD}
      modeled: ledger.modeled(),                 // R/TBD entries + overrides
      overrides: overrides.all(),                // explicit user edits (original vs value)
      legend: { B: 'byte-verified', A: 'inferred', R: 'modeled', TBD: 'unknown' },
    },
    data: payloads,
  };
}

export function downloadJSON(obj, filename = 'colopy-lab-snapshot.json') {
  download(JSON.stringify(obj, null, 2), filename, 'application/json');
}

// CSV for time-series payloads: rows = array of flat objects.
export function downloadCSV(rows, filename = 'colopy-lab-series.csv') {
  if (!rows || !rows.length) { download('', filename, 'text/csv'); return; }
  const cols = Array.from(rows.reduce((s, r) => { Object.keys(r).forEach((k) => s.add(k)); return s; }, new Set()));
  const esc = (v) => { const s = String(v ?? ''); return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s; };
  const csv = [cols.join(','), ...rows.map((r) => cols.map((c) => esc(r[c])).join(','))].join('\n');
  download(csv, filename, 'text/csv');
}

function download(text, filename, mime) {
  const blob = new Blob([text], { type: mime });
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = filename;
  document.body.append(a); a.click(); a.remove();
  setTimeout(() => URL.revokeObjectURL(a.href), 1000);
}
