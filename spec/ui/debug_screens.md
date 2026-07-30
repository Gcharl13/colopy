# Debug / cheat screens (DEBUG.TXT family)

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> Covers the 20 DEBUG.TXT dialog sections and the debug overlays they gate.
> Sections marked *(pending)* are being decoded 2026-07-30; the `@OPTIONS`
> cluster below is already byte-verified (Phase 1, `docs/UI_PHASE1_ATTRIBUTION.md`
> §2/§4, cites re-resolved).

## 1. The debug-options bitfield `[0x894]` — B

Builder **`func_02356C` @0x02356C**: shows the checkbox dialog from file
"DEBUG" section "OPTIONS" (strings DS:0xABB "OPTIONS" / DS:0xAC3 "DEBUG",
file 0x1E45B), loops exactly **7 bits** (`cmp [bp-2],7` @0x023593; state
in/out via `shl dx,cl; and dx,[0x894]` @0x023585–0x023587, rebuild
`or [0x894],ax` @0x0235C6). DEBUG.TXT `@OPTIONS` = "Select Debug Information
Options" + 7 `~` checkbox rows:

| bit | mask | row | gated feature | status |
|---|---|---|---|---|
| 0 | 0x01 | (row 1) | TBD — tester unattributed | *(pending)* |
| 1 | 0x02 | (row 2) | TBD | *(pending)* |
| 2 | 0x04 | Supply and Demand (Indians) | `func_048F34` economic-model dump: per-good `"%Fs %d %d"` lines at x=1, y=8·(g+1), color 0x0F, blocking getch (@0x0494DA gate) | **B** |
| 3 | 0x08 | (row 4) | TBD | *(pending)* |
| 4 | 0x10 | Close Moves | `func_061F02` short-range pathfinder overlay: per-tile costs, red summary at (5,190), Z/X zoom keys (@0x061F14 gate) | **B** |
| 5 | 0x20 | Far Moves | `func_06295E` (fmt "Far: %d(%d,%d)…" @0x062CDA; gate @0x062975) | **B** (overlay layout TBD) |
| 6 | 0x40 | All Movement | `func_062D84` sets latch `[0x1DF2]` honored by the Close-Moves renderer (@0x062D94 gate, latch write @0x062D75) | **B** |

## 2. Per-section dialog map — *(pending decode)*

DEBUG.TXT sections: `@MOTD @MOTD2 @MEMORY @CREATE @CREATE2 @CSHIP @FOREIGN
@FOREIGN2 @SETVIEW @SETHUMAN @SETAUTO @SETREPORT @SETEUROPE @DANGER @END
@BADGUYS @SOUND @OPTIONS @FORCED @TEST`.

## 3. Cheat-menu gating — *(pending decode)*

Known: the in-game cheat menu is MENU.TXT `@CUP`, built by `func_072090`,
commands executed by `func_0235D6` (switch @0x0235E2ff; dispatch table for
ids 0x1B..0x77 at file 0x023DE8).

## 4. Open items
- Bits 0x01/0x02/0x08 testers.
- MAPEDIT's dead `_memory_check` references DEBUG.TXT `@MEMORY` too
  (`spec/ui/map_editor.md` §5) — same section, different program.
