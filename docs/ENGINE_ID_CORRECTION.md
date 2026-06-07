# Engine ID Correction (2026-05-24)

## What I had wrong

Previous docs (UI_RENDERER_SPEC.md v2, POPUP_TEMPLATE_AUDIT.md) said
Colonization uses the **Dynamix DGDS** engine. This was based on
MODULES.DB containing module names that matched Dynamix adventure
games (Rise of the Dragon, Heart of China).

## What's actually true

Colonization uses **MADS** (MicroProse Adventure Development System) —
a separate MicroProse-internal engine. Despite the similar module
naming convention with DGDS, MADS is its own codebase.

### Hard evidence (from viceroy_session_summary.md)

- Binary signature: `MADSPACK 2.0` archive format throughout
- Microsoft C 6.0, medium memory model with overlays (not Watcom/HM
  which Dynamix used)
- CRT signatures: R6000-R6009 error codes, `$RTL_TERMINATE`,
  `$C_FILE_INFO`, "Smart vectoring" string
- MZ header: Initial CS:IP = `110D:071D`, overlay region at file
  offset `0x20665`, length `0x586D9` (362,201 bytes)

### Why module names overlap

Both MADS (MicroProse) and DGDS (Dynamix) were adventure-game engines
from the same era (early 90s) and converged on similar module
abstractions (`Popup`, `PopupDialog`, `Hotspot`, `Vocab`, `Quote`,
`Conv`, etc.). Different codebases, same design vocabulary.

### What MADS implies for our renderer

ScummVM has a MADS engine but only supports **Rex Nebular and the
Cosmic Gender Bender** (MicroProse 1992) — not Colonization. So we
CANNOT directly use ScummVM's MADS source as a popup-rendering
reference the way we tried with DGDS dialog.cpp.

The dialog/popup rendering patterns may still be similar at the
architectural level (the 9-slice corner sprites + body fill + text
draw decomposition), but the specific offsets and constants come
from VICEROY.EXE itself.

## Practical implications

### What stays valid from our DGDS-based work
- WOODFRAM 9-slice geometry (measured directly from the asset, no
  engine-assumption required)
- WOODPANL body fill (asset-driven)
- FONTTINY/FONTSMAL/FONTINTR/FONTKING usage rules (user-curated, asset-
  driven)
- Three sprite channels `[0x1F5C]`/`[0x1F5E]`/`[0x1F60]` (byte-verified)
- @KEY popup directives (parsed from GAME.TXT — engine-agnostic)

### What needs re-verification
- `kDlgFrameBorder` / `RequestData::drawCorners()` pattern (was from
  ScummVM's DGDS source — Colonization may use a different mechanism)
- Per-event sprite-position math (`func_06BF66`) — was decoded
  through DGDS lens; should be re-traced against MADS conventions

## The right strategy going forward

Per viceroy_session_summary.md:

1. **Use `openFile()` at FUN_15eb_31c6 as the master xref point**.
   Every file the engine loads goes through this single function.
   Walking its xrefs enumerates every per-file loader.

2. **Find the schema parser dispatcher at `9000:43be`** (in overlay).
   The parser table `{keyword, parser_fn}[]` defines runtime struct
   layouts — once we have those, we know exactly which fields each
   painter reads and from where.

3. **Use the labeled-string anchors**: UNFORESTED / FORESTED /
   RESOURCE / COUNTRY / LEADERNAME / HOMEPORT / SEASONS / CLASS /
   BUILDING / SCENARIO / JOB / CARGO / UNIT / ORDERS / ACTION /
   ATTITUDE / LEVELS / TRIBES / FATHERS / FOUNDING. Each one xrefs
   to the parser function for its data type.

4. **Hardware bookmark cluster**: VGA palette ports `0x3C8` / `0x3C9`
   (32 instructions) → palette setter. VGA segment `A000` near
   `rep movsw` clusters → framebuffer blit. INT 33h (2 instructions)
   → mouse driver. Mode 13h set (4 instructions) → screen init.

5. **DGROUP = segment `0x2b5a`** (NOT 0x6BF70 as I had documented
   from recol — that was for the recol re-link; the original VICEROY
   uses 0x2b5a).

## Open questions this correction raises

- Is the agent-claimed "title painter LCALL 0x4509:0x10F" still valid?
  Search returned 0 hits with that byte pattern. May need to find the
  actual title painter via openFile→LABELS.TXT loader xref chain.
- Are the agent-claimed advisor-report paint function offsets
  (0x025F18 etc.) overlay-relative? Need to translate using overlay
  base = file 0x20665.
