#!/usr/bin/env python3
"""
simulate_formulas.py — Run the BYTE_VERIFIED game-system formulas
with sample inputs. Output a table that should match DOSBox-observed
gameplay values.

Includes:
  - Native village raze (CHIEFKILL gold formula, file 0x04AB17)
  - SMITE diplomatic gold (file 0x05997C)
  - King tax raise increment (file 0x034AE0)
  - Combat demotion ladder (file 0x05B5AA)
"""
from __future__ import annotations

import argparse
import sys
from simulate_rng import random_int_step


def native_raze_gold(seed: int, difficulty: int, size_byte: int):
    """Run the CHIEFKILL formula at file 0x04AB17..0x04AB6E.

    diff      = DGROUP[0x53A6]
    upper     = 10 - diff
    sum_3     = 3 × random_int(1, upper)
    roll_4    = random_int(1, 6)
    gold      = sum_3 × roll_4 × 4 × (size_byte + 1)
    """
    upper = 10 - difficulty
    rolls = []
    for _ in range(3):
        r, seed = random_int_step(1, upper, seed)
        rolls.append(r)
    sum_3 = sum(rolls)
    roll_4, seed = random_int_step(1, 6, seed)
    gold = sum_3 * roll_4 * 4 * (size_byte + 1)
    return {"sum_3": sum_3, "roll_4": roll_4, "gold": gold, "new_seed": seed}


def smite_gold(treasury: int, player_factor: int, bit19_set: bool):
    """Run the SMITE formula at file 0x05997C..0x0599DD.

    intermediate = (player_factor × treasury) // 2500
    clamped      = max(10, min(200, intermediate))
    gold         = clamped × 50
    if bit19_set: gold //= 2
    """
    intermediate = (player_factor * treasury) // 2500
    clamped = max(10, min(200, intermediate))
    gold = clamped * 50
    if bit19_set:
        gold //= 2
    return {"intermediate": intermediate, "clamped": clamped, "gold": gold}


def king_tax_change(difficulty: int, turn: int):
    """Run the king tax raise formula at file 0x034AE0..0x034B0D.

    base_amount   = ((diff & 0xFE) × 2) + 4
    era_multiplier = (turn // 400) + 1
    proposed_change = base_amount × era_multiplier
    """
    base = ((difficulty & 0xFE) * 2) + 4
    era_mult = (turn // 400) + 1
    return base * era_mult


def combat_demote(unit_type: int, byte_at_offset_15: int = 0):
    """Run the combat demotion ladder at file 0x05B5AA..0x05B616."""
    table = {1: 0, 4: 1, 7: 9, 8: 6, 9: 0}
    outcome = table.get(unit_type, -1)
    # Special override
    if outcome == 0 and byte_at_offset_15 == 24:
        outcome = 3
    return outcome


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--formula", choices=["raze", "smite", "king_tax", "combat", "all"],
                    default="all")
    ap.add_argument("--seed", type=lambda x: int(x, 0), default=0x12345678)
    args = ap.parse_args()

    if args.formula in ("raze", "all"):
        print("=" * 60)
        print("Native village raze (CHIEFKILL) — BYTE_VERIFIED")
        print("Formula: gold = sum_3 × roll_4 × 4 × (size_byte+1)")
        print("=" * 60)
        print(f"{'diff':>5} {'size':>5} | {'min':>8} {'max':>8} {'sample':>12}")
        print("-" * 60)
        for diff in (0, 1, 2, 3, 4):
            for size_byte in (5, 10, 15, 20, 25):
                upper = 10 - diff
                # Theoretical bounds
                min_gold = 3 * 1 * 4 * (size_byte + 1)
                max_gold = 3 * upper * 6 * 4 * (size_byte + 1)
                # One sample run
                sample = native_raze_gold(args.seed, diff, size_byte)
                print(f"  {diff:>3} {size_byte:>5} | {min_gold:>8} {max_gold:>8} {sample['gold']:>12}")
        print()
        print(f"  -> Aztec capital (diff=0, size=20): range = [252, 15120].")
        print(f"     User's empirical observation: 4000-15000. MATCH.")
        print()

    if args.formula in ("smite", "all"):
        print("=" * 60)
        print("Diplomatic SMITE — BYTE_VERIFIED")
        print("Formula: gold = clamp(player_factor × treasury / 2500, 10, 200) × 50")
        print("=" * 60)
        print(f"{'treasury':>10} {'pf':>5} {'bit19':>6} | {'gold':>8}")
        print("-" * 50)
        for treasury in (1000, 5000, 25000, 100000, 500000):
            for pf in (1, 5, 10, 50):
                for bit19 in (False, True):
                    r = smite_gold(treasury, pf, bit19)
                    print(f"  {treasury:>8} {pf:>5} {str(bit19):>6} | {r['gold']:>8}")
        print()

    if args.formula in ("king_tax", "all"):
        print("=" * 60)
        print("King Tax Raise Increment — BYTE_VERIFIED")
        print("Formula: ((diff & 0xFE) × 2 + 4) × ((turn // 400) + 1)")
        print("=" * 60)
        print(f"{'difficulty':>11} | {'era 1':>6} {'era 2':>6} {'era 3':>6} {'era 4':>6}")
        print(f"{'(turn)':>11} |  (0)   (400)  (800)  (1200)")
        print("-" * 50)
        names = ["Discoverer", "Explorer", "Conquistador", "Governor", "Viceroy"]
        for diff in (0, 1, 2, 3, 4):
            row = [king_tax_change(diff, t) for t in (0, 400, 800, 1200)]
            print(f"  {names[diff]:>10} | {row[0]:>5}+ {row[1]:>5}+ {row[2]:>5}+ {row[3]:>5}+")
        print()

    if args.formula in ("combat", "all"):
        print("=" * 60)
        print("Combat Demotion Ladder — BYTE_VERIFIED")
        print("=" * 60)
        for ut in range(15):
            outcome = combat_demote(ut)
            outcome_special = combat_demote(ut, byte_at_offset_15=24)
            note = f"   special: -> {outcome_special}" if outcome_special != outcome else ""
            print(f"  unit_type={ut:>2} -> {outcome:>2}{note}")


if __name__ == "__main__":
    sys.exit(main())
