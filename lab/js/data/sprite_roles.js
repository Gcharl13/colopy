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

// Placeholder indices that every sheet skips (CLAUDE.md hard rule 5).
export const PLACEHOLDER_INDICES = new Set([0, 16, 100]);

// A rule = a predicate over the frame index + the role it confers.
// Stored per-sheet, first match wins.
const inRange = (lo, hi) => (i) => i >= lo && i <= hi;
const isOne = (n) => (i) => i === n;

const ROLES = {
  ICONS: [
    { test: isOne(109), role: 'foot unit — colony unit-on-tile marker', tier: TIER.B,
      cite: 'mov ax,0x6D @0x0265BF (docs/UI_FIDELITY.md)' },
    // Index 100 is claimed by BOTH hard rule 5 (placeholder skip) and hard rule 6
    // (foot units 100–105). Genuine source conflict — surface it, don't pick.
    { test: isOne(100), role: 'CONFLICT: skip-index (rule 5) vs foot-unit start (rule 6)', tier: TIER.TBD,
      cite: 'CLAUDE.md rule 5 lists 100 as skip; rule 6 lists 100–105 as foot units — needs a ruling in notes/rulings/RULINGS.md' },
    { test: inRange(101, 105), role: 'foot unit', tier: TIER.B, cite: 'CLAUDE.md hard rule 6' },
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

// A frame is a "placeholder" if it's a hard-rule skip index OR a 1×1 stub
// (the bundle emits 1×1 frames for unused slots).
export function isPlaceholder(frame) {
  return PLACEHOLDER_INDICES.has(frame.i) || (frame.w <= 1 && frame.h <= 1);
}
