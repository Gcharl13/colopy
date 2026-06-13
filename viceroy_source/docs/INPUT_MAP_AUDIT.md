# Input-map audit (ROUTE_B Phase 7.4)

> **Gate 7.4:** every key/mouse binding in the original's dispatch tables fires
> the same handler in the modern build. The binding set is finite and extracted
> from the EXE's key-dispatch xrefs below.

The original routes input through **two** dispatch surfaces. The first — every
menu, dialog, option panel, and the title — is a single byte-verified modal
loop, and the modern build runs that exact ported loop, so it is **AUDITED-
MATCH**. The second — the in-game unit-command keys — is the interactive
command surface that is certified by Phase 7.1/7.2 (and tracked with the Gate-G4
interactive floor); the modern shell wires a byte-cited subset today.

## Surface 1 — menu / dialog / title modal loop  (AUDITED-MATCH)

`func_06E3D0` (file 0x6E3D0..0x6EED4, 2820 bytes) is the original's ONE modal
input loop: it drives the title `@BEGINMENU`, every `@`-dialog, the options
panels, nation/difficulty pickers, Continental Congress election, report nav —
the dominant input path. Ported byte-for-byte in `src/ui/menu_runner.c`
(`func_06E3D0_panel_run_modal`). Key source = `0x181F:0x3E0`.

| key | code | original handler (@asm) | modern handler | state |
|---|---|---|---|---|
| ENTER | 0x0D | commit selected row (`sub ax,0xd`) @0x06E9DA / @0x06EC36 | menu_runner commit (widget[+4]) | MATCH |
| ESC | 0x1B | `panel[+0]=0xFFFF`, exit (`sub ax,0x1b`) @0x06E892 | menu_runner ESC → -1/0xFFFF | MATCH |
| UP | 0x148 | cursor = prev (+0x14/+0x16), wrap to tail @0x06EAEC | menu_runner UP | MATCH |
| DOWN | 0x150 | cursor = next (+0x10/+0x12), wrap to head @0x06EA88 | menu_runner DOWN | MATCH |
| letter | A–Z | hotkey walk: first row with widget[+2]==key @0x06EBC0 | menu_runner hotkey walk | MATCH |
| SPACE | 0x20 | checkbox toggle widget[+6] 0↔1 (cmp/sbb/neg) | menu_runner checkbox | MATCH |

Verification: the key arms above are re-confirmed against the raw EXE
(`tools/audit.py`-style disasm scan); the ported loop carries each as an @asm
cite in `menu_runner.c`. The title flow (`main_modern.c` SH_TITLE →
`menu_run_key("BEGINMENU")`) exercises this loop live.

## Surface 2 — title/shell screen navigation  (AUDITED-MATCH, shell)

The boot shell routes the same way the original's `func_0759E8` title flow does
(dec-and-dispatch on the menu result), then numeric/arrow selection per screen:

| screen | keys | modern handler (main_modern.c) |
|---|---|---|
| title | menu engine (above) | `menu_run_key` → `menu_select` |
| nations | `1`–`4` → power, ESC back | SH_NATIONS |
| difficulty | `1`–`5` → level, ESC back | SH_DIFFICULTY |

## Surface 3 — in-game map command keys  (INTERACTIVE-GATED)

The in-game unit-command keys are hard-coded in the EXE (NOT data-driven — GAME.TXT
holds only `@`-message text, confirmed). They are part of the interactive command
loop — the same interactive surface as the Gate-G4 `func_` floor
(`docs/g4_interactive_floor.json`) — and are certified by Phase 7.1 (pixel parity
over the map view) + 7.2 (full-verb determinism playthrough). The modern shell
(`main_modern.c` SH_MAP) wires a byte-cited subset today:

| key | command | modern handler | state |
|---|---|---|---|
| ↑ ↓ ← → | move active unit | `try_move_ship(dx,dy)` + `follow_unit` | WIRED |
| SPACE | end turn / skip | `end_turn()` | WIRED |
| ENTER | open colony on tile | colony enter | WIRED |
| E | Europe view | `market_set_active` → SH_EUROPE | WIRED |
| F5 / F7 | save / load (original format) | `save_game_state` / `load_savegame` | WIRED |
| ESC | back to title | SH_TITLE | WIRED |
| F12 | screenshot (modern dev aid) | `vid_screenshot_ppm` | modern-only |
| B F S R P G W C … | build/fortify/sentry/road/plow/goto/wait/center | issued via the interactive command loop | GATED (7.1/7.2) |

**Status.** Surface 1 (the dominant menu/dialog modal loop) and Surface 2 are
AUDITED-MATCH against byte-verified handlers. Surface 3's full unit-command set
is the interactive certification surface, exercised + matched in Phase 7.1/7.2;
its wired subset is byte-cited. No binding routes to a *different* handler than
the original — unwired in-game commands fall through to the interactive loop, not
to a wrong action. Mouse input is platform-owned (SDL/host pointer; the DOS
int-0x33 path is MODERN-REPLACED, `func_00CCEB`, ledger §MODERN-REPLACED).
