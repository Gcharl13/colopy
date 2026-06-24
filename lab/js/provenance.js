// provenance.js — THE SPINE of the lab.
//
// Every value the tool shows or computes is wrapped in a `Val` carrying a TIER
// (B / A / R / TBD per METHODOLOGY.md) and a citation. The UI styles each value
// by tier so byte-accurate (B) numbers are visually distinct from modeled (R) or
// unknown (TBD) ones — and R/TBD values are EDITABLE so the user can override an
// assumption and watch the flow. Exports record the tier, citation, and any
// override of every value, so a wrong number is always attributable:
//   B wrong  -> a real bug to report.
//   R wrong  -> a modeled placeholder behaving as designed (tune the assumption).
//
// This module has no dependencies and no framework.

export const TIER = Object.freeze({
  B:   'B',    // byte-verified: traced to an EXE offset / NAMES-GAME.TXT field
  A:   'A',    // inferred from framework, high confidence
  R:   'R',    // reconstructed / modeled assumption — NOT byte-truth
  TBD: 'TBD',  // unknown — placeholder, must not masquerade as fact
});

export const TIER_META = Object.freeze({
  B:   { label: 'byte-verified', cls: 'tier-b',   editable: false, blurb: 'Traced to an EXE offset or NAMES/GAME.TXT field. Trust it.' },
  A:   { label: 'inferred',      cls: 'tier-a',   editable: false, blurb: 'Inferred from the framework, high confidence.' },
  R:   { label: 'modeled',       cls: 'tier-r',   editable: true,  blurb: 'Reconstructed assumption — NOT byte-truth. Editable.' },
  TBD: { label: 'unknown',       cls: 'tier-tbd', editable: true,  blurb: 'Not yet decompiled. Placeholder — editable, never trust as fact.' },
});

// A wrapped value. `id` (optional) makes it overridable & ledger-tracked.
export class Val {
  constructor(value, tier, cite, { id = null, unit = '' } = {}) {
    this.value = value;
    this.tier = tier;
    this.cite = cite || (tier === TIER.B ? '(uncited B — fix)' : 'MODELED: unspecified');
    this.id = id;
    this.unit = unit;
  }
}

// Convenience constructors.
export const V    = (value, tier, cite, opts) => new Val(value, tier, cite, opts);
export const B    = (value, cite, opts) => new Val(value, TIER.B,   cite, opts);
export const A    = (value, cite, opts) => new Val(value, TIER.A,   cite, opts);
export const R    = (value, cite, opts) => new Val(value, TIER.R,   cite, opts);
export const TBD_ = (value, cite, opts) => new Val(value, TIER.TBD, cite || 'MODELED: TBD', opts);

// ---- Override registry: user edits to R/TBD values live here. --------------
class OverrideRegistry {
  constructor() { this.map = new Map(); }    // id -> { value, original, cite }
  set(id, value, original, cite) { this.map.set(id, { value, original, cite }); this._notify(); }
  clear(id) { this.map.delete(id); this._notify(); }
  clearAll() { this.map.clear(); this._notify(); }
  has(id) { return this.map.has(id); }
  get(id) { return this.map.get(id); }
  all() { return Object.fromEntries(this.map); }
  _notify() { window.dispatchEvent(new CustomEvent('lab:override')); }
}
export const overrides = new OverrideRegistry();

// Effective value of a Val: the override if one exists, else the original.
export function effective(val) {
  if (val == null) return val;
  if (val.id && overrides.has(val.id)) {
    const o = overrides.get(val.id);
    return coerce(o.value, val.value);
  }
  return val.value;
}

// Coerce an edited string back to the original value's type.
function coerce(raw, like) {
  if (typeof like === 'number') { const n = Number(raw); return Number.isFinite(n) ? n : like; }
  if (typeof like === 'boolean') return raw === true || raw === 'true';
  return raw;
}

// ---- Ledger: records every Val rendered, for the Settings ledger view + export.
class ProvenanceLedger {
  constructor() { this.entries = new Map(); }   // id|cite -> {tier, cite, value}
  record(val) {
    if (val == null) return;
    const key = val.id || `${val.tier}:${val.cite}`;
    this.entries.set(key, { tier: val.tier, cite: val.cite, id: val.id, value: val.value });
  }
  summary() {
    const s = { B: 0, A: 0, R: 0, TBD: 0 };
    for (const e of this.entries.values()) s[e.tier] = (s[e.tier] || 0) + 1;
    return s;
  }
  modeled() {  // every R/TBD entry, with current override (for the ledger view)
    const out = [];
    for (const [key, e] of this.entries) {
      if (e.tier === TIER.R || e.tier === TIER.TBD) {
        const ov = e.id && overrides.has(e.id) ? overrides.get(e.id) : null;
        out.push({ key, ...e, override: ov ? ov.value : null });
      }
    }
    return out;
  }
  reset() { this.entries.clear(); }
}
export const ledger = new ProvenanceLedger();

// ---- Rendering ------------------------------------------------------------
// renderVal(val) -> HTMLElement. B/A render as a tagged span (cite on hover).
// R/TBD render with an inline editable input that writes to the override registry.
export function renderVal(val, { format = String } = {}) {
  ledger.record(val);
  const meta = TIER_META[val.tier];
  const wrap = document.createElement('span');
  wrap.className = `val ${meta.cls}`;
  wrap.title = `${val.tier} — ${meta.label}\n${val.cite}`;

  if (!meta.editable) {
    const txt = document.createElement('span');
    txt.className = 'val-text';
    txt.textContent = format(val.value) + (val.unit ? ` ${val.unit}` : '');
    wrap.append(txt, badge(val.tier));
    return wrap;
  }

  // Editable (R / TBD)
  const input = document.createElement('input');
  input.className = 'val-input';
  input.value = (val.id && overrides.has(val.id))
    ? overrides.get(val.id).value
    : (val.value == null ? '' : val.value);
  input.size = Math.max(3, String(input.value).length + 1);
  const commit = () => {
    if (!val.id) return;
    if (input.value === '' || input.value === String(val.value)) overrides.clear(val.id);
    else overrides.set(val.id, input.value, val.value, val.cite);
  };
  input.addEventListener('change', commit);
  input.addEventListener('input', () => { input.size = Math.max(3, input.value.length + 1); });
  wrap.append(input, badge(val.tier));
  if (val.unit) { const u = document.createElement('span'); u.className = 'val-unit'; u.textContent = ` ${val.unit}`; wrap.append(u); }
  return wrap;
}

export function badge(tier) {
  const b = document.createElement('sup');
  b.className = `badge ${TIER_META[tier].cls}`;
  b.textContent = tier;
  return b;
}

// A small legend element explaining the tiers (used in the header).
export function tierLegend() {
  const el = document.createElement('div');
  el.className = 'tier-legend';
  for (const t of Object.values(TIER)) {
    const m = TIER_META[t];
    const chip = document.createElement('span');
    chip.className = `legend-chip ${m.cls}`;
    chip.title = m.blurb;
    chip.textContent = `${t} ${m.label}`;
    el.append(chip);
  }
  return el;
}
