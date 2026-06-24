// sim/market.js — the European market model, ported from spec/systems/market.md
// (all formulas BYTE_VERIFIED at the cited func_0305A8 / page-13 offsets). The
// FORMULAS are B; the live STATE they run on (price seed, per-player trade
// accumulators, the King's tax rate, transaction qty) is runtime data — modeled
// here as R/editable inputs so you can watch the byte-true math move.

// Runtime-verified goods order, index 0..15 (market.md §2, colonization-memory-map).
export const GOODS = [
  'Food', 'Sugar', 'Tobacco', 'Cotton', 'Furs', 'Lumber', 'Ore', 'Silver',
  'Horses', 'Rum', 'Cigars', 'Cloth', 'Coats', 'Trade Goods', 'Tools', 'Muskets',
];
export const FINISHED = [9, 10, 11, 12];     // Rum, Cigars, Cloth, Coats
export const RAW_INPUT = [1, 2, 3, 4];       // Sugar, Tobacco, Cotton, Furs (→ the finished four)

// Per-turn price drift — func_0305A8 @0x30618 (BYTE_VERIFIED).
//   base[g] -= (base[g] + Σ_players max(trade_accum[p][g], 0)) >> 8
// Returns { next, decay, totalTrade } for one good.
export function driftStep(base, playerAccums) {
  let total = base;
  for (const v of playerAccums) total += Math.max(0, v | 0);   // clamp ≥0 (@0x305E0)
  const decay = total >> 8;                                    // /256 (@0x30618 sar ×8)
  return { next: base - decay, decay, totalTrade: total - base };
}

// Supply per good — @0x0305AE: supply[g] = seed[g] + Σ_players max(accum[g], 0).
export function supplyOf(seed, playerAccums) {
  let s = seed;
  for (const v of playerAccums) s += Math.max(0, v | 0);
  return s;
}

// Luxury shared-pool target price — @0x030649 / @0x030745 (BYTE_VERIFIED).
//   S_pair = Σ supply[9..12], clamp ≥1;  target[i] = (S_pair*3) / supply[i]
// `supply` is a 16-length array of per-good supplies. Raw inputs {1..4} use the
// same pool (Furs(4) supply halved). Returns a map good→target.
export function luxuryTargets(supply, year = 1600) {
  let sPair = supply[9] + supply[10] + supply[11] + supply[12];
  if (sPair < 1) sPair = 1;
  const out = {};
  for (const i of FINISHED) out[i] = Math.floor((sPair * 3) / Math.max(1, supply[i]));
  for (const i of RAW_INPUT) {
    let v = supply[i];
    if (i === 4) {                       // Furs: halved, +1 if year<1700, +1 if year<1600 (@0x0307C9)
      v = v >> 1;
      if (year < 1700) v += 1;
      if (year < 1600) v += 1;
    }
    out[i] = Math.floor((sPair * 3) / Math.max(1, v));
  }
  return { sPair, targets: out };
}

// SELL transaction — func @0x32914 (BYTE_VERIFIED).
//   gross = price·qty;  tax = gross·king% / 100;  net = gross − tax
//   gold += net (clamped [0, 999999]);  REF fund += tax;  sales tally += net
export function sell(price, qty, kingPct, gold = 0) {
  const gross = price * qty;
  const tax = Math.floor((gross * kingPct) / 100);
  const net = gross - tax;
  const newGold = Math.min(999999, Math.max(0, gold + net));
  return { gross, tax, net, goldDelta: newGold - gold, newGold, refDelta: tax, tallyDelta: net };
}

// BUY transaction — page-13 sites (BYTE_VERIFIED): inline gold debit, UNTAXED.
export function buy(price, qty, gold = 0) {
  const cost = price * qty;
  const newGold = Math.min(999999, Math.max(0, gold - cost));
  return { cost, goldDelta: newGold - gold, newGold, affordable: gold >= cost };
}

// --- Boycotts (spec/systems/boycotts.md, all BYTE_VERIFIED) ---------------
// Per-good boycott bits live in PowerRecord +0x20 (u16, one bit per good).
//   test  func_030B38:  (1<<good) & mask
//   set   @0x34717:     mask |= (1<<good)
//   clear @0x33423:     mask &= ~(1<<good)
//   Jakob Fugger (FF 1) @0x3BD45: mask := 0  (clears all)
export function isBoycotted(mask, good) { return ((mask >> good) & 1) === 1; }
export function setBoycott(mask, good) { return (mask | (1 << good)) & 0xFFFF; }
export function clearBoycott(mask, good) { return mask & ~(1 << good) & 0xFFFF; }
export const JAKOB_FUGGER_CLEAR = 0;     // mask := 0 (@0x3BD45)

// Back-tax owed to lift a boycott — func_03334E @0x333AF: price · 500.
// Paid from treasury +0x2A, credited to the King's REF fund +0x22 (@0x3340C);
// only lifts if affordable (@0x333DD).
export function backTaxToLift(price, gold) {
  const owed = price * 500;
  return { owed, affordable: gold >= owed, refDelta: owed };
}

