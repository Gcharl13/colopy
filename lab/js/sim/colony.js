// sim/colony.js — single-colony mechanics (spec-faithful). M0 = the production
// kernel + the one modeled input (food consumption). Deepened to a full per-turn
// loop (SoL EMA, growth, warehouse, Tory penalty) in M2.
//
// Every returned value is a provenance-tagged Val so the UI can show accurate-vs-modeled.
import { B, R, TBD_ } from '../provenance.js';

// Farmer food production for one worked tile + a 1-farmer net-food preview.
// terrain: a row from @UNFORESTED/@FORESTED (string fields).
export function colonyPreview(terrain, pop) {
  const foodYield = B(num(terrain.y_farmer), `@UNFORESTED ${terrain.name} y_farmer (NAMES.TXT) [B]`);

  // Food consumption = pop × 2. Confirmed by the user but NOT byte-located in the
  // EXE yet (spec/systems/colony.md §1, location TBD) -> tier R, editable.
  const perCapita = R(2, 'MODELED: food per colonist/turn = 2 (user-confirmed; byte-loc TBD, spec/systems/colony.md §1)',
    { id: 'food.per_capita', unit: 'food/colonist' });

  const pc = perCapita.value;   // M0: use base; M2 will use effective() under the per-turn loop
  const consumption = R(pop * pc, 'MODELED: pop × per-capita', { id: 'food.consumption.preview' });
  const net = R(foodYield.value - pop * pc, 'MODELED: 1-farmer yield − pop×per-capita (illustrative)',
    { id: 'food.net.preview' });

  return {
    foodYield,
    pop: B(pop, 'user input (population)'),
    perCapita,
    consumption,
    net,
    growthThreshold: B(200, 'func_02D658 @0x2E098 — +200 growth store [B]'),
    starvation: TBD_(null, 'MODELED: TBD — starvation rule not decompiled'),
  };
}

function num(s) { const n = Number(s); return Number.isFinite(n) ? n : 0; }
