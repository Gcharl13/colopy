#!/usr/bin/env python3
"""
simulate_rng.py — Simulate the BYTE_VERIFIED MSC 6.0 LCG.

If the implementation is correct, this matches what VICEROY.EXE
generates given the same seed. To verify, capture a sequence from
DOSBox by running the game with a fixed seed (set via debugger) and
compare.

Constants are byte-verified at file 0x0103D4 in VICEROY.EXE:
    seed = seed × 0x000343FD + 0x00269EC3
    return (seed >> 16) & 0x7FFF
"""
from __future__ import annotations

import argparse
import sys


def rand_step(seed: int) -> tuple[int, int]:
    """One step of the LCG. Returns (rand_value, new_seed)."""
    seed = (seed * 0x000343FD + 0x00269EC3) & 0xFFFFFFFF
    rand_value = (seed >> 16) & 0x7FFF
    return rand_value, seed


def random_int_step(lo: int, hi: int, seed: int) -> tuple[int, int]:
    """Simulates random_int(lo, hi)."""
    r, seed = rand_step(seed)
    range_ = hi - lo + 1
    scaled = (r * range_) >> 15
    return scaled + lo, seed


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--seed", type=lambda x: int(x, 0), default=0x12345678,
                    help="Starting seed (default 0x12345678)")
    ap.add_argument("--count", type=int, default=20, help="How many values to generate")
    ap.add_argument("--lo", type=int, help="If set, run random_int(lo, hi) instead of rand()")
    ap.add_argument("--hi", type=int)
    args = ap.parse_args()

    seed = args.seed
    print(f"Seed: 0x{seed:08x}")
    print()

    if args.lo is not None and args.hi is not None:
        print(f"Generating {args.count} × random_int({args.lo}, {args.hi}):")
        for i in range(args.count):
            value, seed = random_int_step(args.lo, args.hi, seed)
            print(f"  [{i:2}] = {value:5}  (new_seed=0x{seed:08x})")
    else:
        print(f"Generating {args.count} × rand() (LCG values, 0..32767):")
        for i in range(args.count):
            value, seed = rand_step(seed)
            print(f"  [{i:2}] = {value:5}  (new_seed=0x{seed:08x})")

    print()
    print("To verify: capture an equivalent sequence from VICEROY.EXE running")
    print("in DOSBox with the same starting seed (set DGROUP:0x28EE/0x28F0 via")
    print("debugger), compare. Match = LCG implementation BYTE_VERIFIED.")


if __name__ == "__main__":
    sys.exit(main())
