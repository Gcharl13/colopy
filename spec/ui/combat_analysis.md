# Combat Analysis dialog

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Decoded 2026-07-30. This resolves the Phase-1 mystery renderer: the dialog IS
> `func_05E9B0` (page 0x11) — see `docs/UI_PHASE1_ATTRIBUTION.md` §1 for the
> layout record; this sheet adds the identity, inputs, and row semantics.
> Load-bearing cites re-verified (gate, caller, thunk 0x1a1f:0x704 → stub
> 0x1CCF4 → 0x05E9B0, LABELS `@MISC` loader, section strings).

## 1. When it appears (B)
Inside land-combat resolution `func_05CA7E` (page 0x10), **after the combat
roll is computed but before resolution renders**. Gate @0x05D221:
`test [0x5383],2` (= Game Options bit 0x0200 "Combat Analysis",
`spec/ui/options_dialogs.md` §6) AND (attacker human OR defender human OR
full-view `[0x53A2]≠0`). Sole call site @0x05D291 with 13 args:
(att_unit, def_unit, att_x, att_y, tgt_x, tgt_y, att_owner, def_owner,
`[0x1B06]`, `[0x1B04]`, att_strength, def_strength, roll).

## 2. Layout (B — from the Phase-1 decode, identity now bound)
Two-pass measure/draw; frame `0x1A1F:0x710`; **x=53, w=214, h=rows·20+6,
vertically centered**; title "COMBAT ANALYSIS" (LABELS `@MISC` line 75 via
`[0x2E50]`); columns: **attacker x=56, defender x=160**; labels color
`[0x830]`, values right-aligned at col_x+0x50 color `[0x831]`; row pitch
20px; per-column unit sprite + info panel; modal-wait terminator.

Strings: all labels are LABELS.TXT `@MISC` lines via the pointer table at
DG 0x2DBA (loaded @0x075214–0x07523C): 75 COMBAT ANALYSIS, 76 Fatigue,
77 Attack Bonus, 78 Ambush, 79 Terrain, 80 Colony, 81 Fortified, 82 Spain
Bonus, 84 Artillery In Open, 90 Drake, 104 Bombard, 129 Artillery Vs.
Raid, 132 Tory Unrest, 133 Rebel Unrest, 65 Veteran, 62 Cargo.

## 3. Inputs (B)
Per column (0=attacker, 1=defender): modifier-flag word `F=[col*2+0x8D00]`,
secondary `S=[col*2+0xA156]`, base strength `[col*2+0x8D06]` (written by
the root strength calc `func_007C2A` @0x007CA5: base = unit table
`[type*14+0x5235]`, carriers `+0x5236`, damaged ship −2).

## 4. Row table (B)

| flag | row | value |
|---|---|---|
| F&0x200 | unit name shown as veteran-profession name | base strength |
| F&0x400 | Muskets (goods 15 name + icon 0x26) | "+1" (semantic TBD) |
| F&2 | Veteran (types 1/4, prof 0x15) | +50% |
| F&4 | Cargo | −12.5% per used hold (cargo·100/8) |
| F&0x100 / S&8 | Fatigue | −33% / −66% |
| F&1 | Attack Bonus | +50% |
| F&0x8000 | Bombard | +50% |
| S&2 / S&4 | Tory / Rebel Unrest | −(100−SoL%) / +SoL% (`0x181f:0xC86`) |
| F&0x80 | Ambush (attacker) / Terrain (defender) — draws the target tile | +terrain_def·25% (skipped if 0) |
| F&0x40 | Colony | +(fortlevel+1)·50% (`0x181f:0x9D2`) |
| F&8 (+0x10/+0x20) | colony-structure row (building name, table 0x9634) | +n·50%, n=1/2, doubled by F&0x20 |
| F&0x800 (S-side) | Artillery In Open | −75% |
| S&1 | Artillery Vs. Raid | +100% |
| F&0x2000 | Fortified | +50% |
| F&0x1000 | Spain Bonus | +50% |
| F&0x4000 | Drake (privateers, FF #13 owned — `func_007C2A` @0x007CF0) | +50% |
| **`[0x5383]&0x20`** (cheat mode, Alt-W-I-N) | extra rows: final strengths (args 11/12) + the raw roll vs att+def total | — |

Flag producers (combat engine): cleared @0x05CB3A; e.g. Fatigue−33
`[0x8D01]|=1` @0x05CB9B (with the GAME.TXT `@HALF` prompt @0x05CB83),
Veteran @0x007CD6, Drake @0x007D09, Bombard `[0x8D01]|=0x80` @0x05CF7D.
Related naval prompt: `@EVASIVE` @0x05D469.

## 5. Open items (exact trace sites)
1. "Muskets +1" value semantics @0x05EBDA.
2. Building-name table DG 0x9634 (stride 6) entries + `[0x964C]` special.
3. Remaining producers for F bits 1/4/0x10/0x1000/0x2000 — scan
   `func_05CA7E` @0x05CBAC–0x05CFF0 + root calc @0x007D0E ff.
4. `[0x53A6]` role in the strength doubling @0x05D0D9 (difficulty?).
5. Title verb `0x100` anchor semantics (x-params 0x38/0xD0).
