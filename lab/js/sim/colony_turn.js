// sim/colony_turn.js — single-colony per-turn mechanics, ported from
// spec/systems/colony.md §3 (compute_terrain_yield @0x9B9C, sol_membership_pct
// @0x8524, the per-turn EMA @0x2DA1C, growth @0x2E098). Functions return plain
// numbers plus a tiered `steps` breakdown ({label,value,tier,cite}) so the tab can
// show exactly which part of each result is byte-true vs modeled.

// Per-tile production yield for one worker producing good `g`.
// opts: { base, good, pop, sol, difficulty, expertMatch, hasMfgBuilding, factory }
//   base          — terrain yield-table value [B data, @UNFORESTED/@FORESTED]
//   expertMatch   — colonist's skill == g (expert on this good)
//   hasMfgBuilding— the g>=8 manufacturing building is present
//   factory       — the 3rd chain link present (factory tier)
export function tileYield(opts) {
  const { base, good, pop, sol, difficulty, expertMatch, hasMfgBuilding, factory } = opts;
  const steps = [];
  let y = base;
  steps.push({ label: 'terrain base yield', value: y, tier: 'B', cite: '@UNFORESTED/@FORESTED table (NAMES.TXT), @0x9C1E' });
  if (y <= 0) return { yield: 0, steps };

  // Sons-of-Liberty / Tory production penalty (@0x9D14..0x9D98).
  const toryCnt = Math.round((pop * (100 - sol)) / 100);
  const divisor = (10 - difficulty);                      // owner<4 & active (@0x9D49)
  const penalty = Math.floor(toryCnt / Math.max(1, divisor));
  if (penalty !== 0) {
    y -= penalty;
    steps.push({ label: `Tory penalty −floor(${toryCnt}/${divisor})`, value: -penalty, tier: 'B', cite: '@0x9D14..0x9D98; divisor = 10−difficulty (@0x9D49)' });
  }

  // Profession (expert) match (@0x9DAD..0x9DD2).
  if (expertMatch) {
    if (good === 0 || good === 8) {                       // Food / Horses: flat +2
      y += 2;
      steps.push({ label: 'expert (era good) +2', value: 2, tier: 'B', cite: '@0x9DAD — Food/Horses flat +2' });
    } else {                                              // else DOUBLE
      const before = y; y *= 2;
      steps.push({ label: 'expert ×2', value: y - before, tier: 'B', cite: '@0x9DD2 SHL — expert doubles manufactured' });
    }
  }

  // Building gate (@0x9F4F): manufactured goods need the building, else 0.
  if (good >= 8 && !hasMfgBuilding) {
    steps.push({ label: 'no manufacturing building ⇒ 0', value: -y, tier: 'B', cite: '@0x9F4F building gate (bit 6)' });
    return { yield: 0, steps };
  }
  // Factory tier ×2 (count_building_chain_present > 2 ⇒ factory; @0x864E/@0x8EA9).
  if (good >= 8 && factory) {
    const before = y; y *= 2;
    steps.push({ label: 'factory tier ×2', value: y - before, tier: 'A', cite: 'count_building_chain_present>2 ⇒ factory (@0x8EA9); ×2 application inferred' });
  }

  y = Math.max(0, y);
  return { yield: y, steps };
}

// Sons-of-Liberty % — sol_membership_pct (@0x8557): sol = (A*100)/B, clamp ≤100.
export function solPct(A, B) {
  if (B <= 0) return 0;
  return Math.min(100, Math.floor((A * 100) / B));
}

// One turn of the SoL EMA — func_02D658 @0x2DA1C (BYTE_VERIFIED, decay 1/64).
//   B -= B>>6; B = max(B,1); B += 2·pop
//   A += bells − (A>>6); A = max(A,0); A = min(A,B)
// (Omits the WoI halving and the small <pop downward pressure — those are noted TBD
//  in the tab, not silently folded in.)
export function solStep(A, B, bells, pop) {
  B = B - (B >> 6);
  if (B < 1) B = 1;
  B += 2 * pop;
  A = A + bells - (A >> 6);
  if (A < 0) A = 0;
  if (A > B) A = B;
  return { A, B, sol: solPct(A, B) };
}

// Run the EMA to (near) steady state; returns the curve + the analytic limit.
//   steady state: B→128·pop, A→min(64·bells,B) ⇒ sol → min(100, 50·bells/pop).
export function solCurve(bells, pop, turns = 80) {
  let A = 0, B = 1; const curve = [];
  for (let t = 0; t < turns; t++) { ({ A, B } = solStep(A, B, bells, pop)); curve.push(solPct(A, B)); }
  const steady = pop > 0 ? Math.min(100, Math.round((50 * bells) / pop)) : 0;
  return { curve, steady, final: curve[curve.length - 1] };
}

// Food growth store — a colonist is born at +200 stored food (func_02D658 @0x2E098),
// while population < 32 (@0x009432 grow gate, pop++ @0x009464). Returns turns to grow
// given a steady net-food surplus (≤0 ⇒ never).
export const GROWTH_STORE = 200;     // func_02D658 @0x2E098 (+200) [B]
export const MAX_POP = 32;           // population < 0x20 (@0x009432) [B]
export function turnsToGrow(netFoodPerTurn, startStore = 0) {
  if (netFoodPerTurn <= 0) return Infinity;
  return Math.ceil((GROWTH_STORE - startStore) / netFoodPerTurn);
}
