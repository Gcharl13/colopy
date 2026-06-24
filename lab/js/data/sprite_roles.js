// sprite_roles.js — byte-cited semantic roles for individual sprite frames.
//
// This is the lab's honest answer to "what IS frame #N of sheet X?". Every
// entry carries a TIER + citation so the Sprites tab can render the role with
// the same provenance discipline as every other value:
//   B  — fixed by a CLAUDE.md hard rule (which itself cites an EXE offset).
//   A  — pixel-verified cross-reference (docs/GHIDRA_REFERENCE.c / SPRITE_CATALOG),
//        high confidence but not a hard rule, so not pure byte-truth here.
// Anything NOT covered returns null — the tab shows "—", never a guess.
//
// Sources, verbatim where they survive:
//   CLAUDE.md hard rule 4 — PHYS0 rows 0x01/0x11 are RIVERS (not coast); true
//     coasts use sprites 150–153.
//   CLAUDE.md hard rule 5 — placeholder indices 0,16,100 are skipped.
//   CLAUDE.md hard rule 6 — renderer indices: ships 5–7 / 14–15 / 127;
//     foot units 100–105 + 109.
//   docs/UI_FIDELITY.md — ICONS 109 = colony unit-on-tile marker, byte-cited
//     `mov ax,0x6D @0x0265BF`.
//   docs/GHIDRA_REFERENCE.c — ICONS commodities 22–37, cursors 0–7, boycott 43;
//     PHYS0 hills 0x31, mountains 0x21 (pixel-verified = A here).

import { TIER } from '../provenance.js';

// Placeholder indices. CLAUDE.md hard rule 5's "skip 0, 16, 100" is PHYS0-SCOPED:
// those three PHYS0 frames are 1×1 transparent extraction artifacts (verified —
// SPRITE_CATALOG "Known extraction artifacts"; RULINGS A3 / 2026-06-24). They are
// NOT a universal skip set: ICONS is contiguous 0–130 with no gaps (STATE.md), and
// ICONS #100 is a real 6×16 foot-unit sprite. The earlier M1 reading that applied
// {0,16,100} to every sheet was a bug; it wrongly flagged ICONS #100.
export const PHYS0_PLACEHOLDER_INDICES = new Set([0, 16, 100]);

// A rule = a predicate over the frame index + the role it confers.
// Stored per-sheet, first match wins.
const inRange = (lo, hi) => (i) => i >= lo && i <= hi;
const isOne = (n) => (i) => i === n;

const ROLES = {
  ICONS: [
    { test: isOne(109), role: 'foot unit — colony unit-on-tile marker', tier: TIER.B,
      cite: 'mov ax,0x6D @0x0265BF (docs/UI_FIDELITY.md)' },
    // ICONS #100 is a real 6×16 foot-unit sprite, NOT a placeholder — the rule-5
    // skip set is PHYS0-scoped (resolved 2026-06-24, RULINGS).
    { test: inRange(100, 105), role: 'foot unit', tier: TIER.B, cite: 'CLAUDE.md hard rule 6 (#100 = ICONS foot unit, RULINGS 2026-06-24)' },
    { test: isOne(127), role: 'ship', tier: TIER.B, cite: 'CLAUDE.md hard rule 6' },
    { test: inRange(5, 7), role: 'ship', tier: TIER.B, cite: 'CLAUDE.md hard rule 6' },
    { test: inRange(14, 15), role: 'ship', tier: TIER.B, cite: 'CLAUDE.md hard rule 6' },
    { test: inRange(22, 37), role: 'commodity icon', tier: TIER.A, cite: 'docs/GHIDRA_REFERENCE.c (pixel-verified)' },
    { test: isOne(43), role: 'boycott red-X', tier: TIER.A, cite: 'docs/GHIDRA_REFERENCE.c (pixel-verified)' },
    { test: inRange(1, 7), role: 'cursor', tier: TIER.A, cite: 'docs/GHIDRA_REFERENCE.c (cursors 0–7)' },
  ],
  PHYS0: [
    { test: isOne(1),  role: 'river (row 0x01)', tier: TIER.B, cite: 'CLAUDE.md hard rule 4' },
    { test: isOne(17), role: 'river (row 0x11)', tier: TIER.B, cite: 'CLAUDE.md hard rule 4' },
    { test: inRange(150, 153), role: 'true coast', tier: TIER.B, cite: 'CLAUDE.md hard rule 4' },
    { test: isOne(33), role: 'mountain (0x21)', tier: TIER.A, cite: 'docs/GHIDRA_REFERENCE.c (pixel-verified)' },
    { test: isOne(49), role: 'hill (0x31)', tier: TIER.A, cite: 'docs/GHIDRA_REFERENCE.c (pixel-verified)' },
  ],
  TERRAIN: [
    { test: () => true, role: 'per-terrain textured ground', tier: TIER.B,
      cite: 'CLAUDE.md hard rule 5 (base-ground sheet)' },
  ],
  BUILDING: [
    { test: () => true, role: 'colony building (@BUILDING upgrade chains)', tier: TIER.A,
      cite: 'docs/GHIDRA_REFERENCE.c (pixel-verified)' },
  ],
};

// roleFor(sheet, index) -> { role, tier, cite } | null
export function roleFor(sheet, index) {
  const rules = ROLES[sheet];
  if (!rules) return null;
  for (const r of rules) if (r.test(index)) return { role: r.role, tier: r.tier, cite: r.cite };
  return null;
}

// A frame is a "placeholder" if it's a 1×1 transparent stub (the bundle emits 1×1
// frames for unused/corrupt slots — universal), or specifically a PHYS0 0/16/100
// extraction artifact (hard rule 5; those happen to be 1×1 too, so the geometric
// test already covers them — the sheet check just documents the rule).
export function isPlaceholder(frame, sheet) {
  if (frame.w <= 1 && frame.h <= 1) return true;
  if (sheet === 'PHYS0' && PHYS0_PLACEHOLDER_INDICES.has(frame.i)) return true;
  return false;
}
