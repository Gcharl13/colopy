# Walkthrough roadmap

What's left in `colonize_sdl/main.py` that needs the user's DOS-side
input or a focused disassembly trace. Drives the next session.

## Fabrication baseline progression

| When                              | Baselined violations |
|-----------------------------------|----------------------|
| Before this work began            | 416                  |
| After menu/font/status/palette/title fixes | 205          |
| After GOOD_NAMES + BUILDING_NAMES wiring   | **150**      |

Every remaining baselined item carries an inline
`# noqa: fabrication-check (tracked: task #N)` marker.

## Hot-spots remaining (top 10)

| Function               | Count | What it is                              | Fix target task |
|------------------------|------:|------------------------------------------|----------------|
| `_render_king_audience`|    14 | King's-audience screen layout            | new task — walkthrough |
| `__init__`             |    13 | Color constants in `GameApp` setup       | task #74       |
| `_execute_menu_item`   |    13 | Menu-action label strings                | walkthrough    |
| `<top-level>`          |    12 | Module-level color/string constants      | task #74       |
| `_early_load_names_section` | 10 | Cached fallback strings (intentional)  | not real fabrication — tag whitelist |
| `_explore_lost_city`   |     7 | Lost-city event labels                   | walkthrough    |
| `_cmd_found_colony`    |     6 | Found-colony confirmation strings        | walkthrough    |
| `_render_dropdown`     |     6 | Menu-bar dropdown layout / colors        | task #62       |
| `_render_terrain`      |     6 | Coast/beach color literals               | task #70       |
| `_render_right_panel`  |     5 | Sidebar text colors / coordinates        | task #62       |

## Walkthrough order (recommended)

1. **DOSBox screenshots first** (task #63) — without them, none of #62/#70
   can be pixel-verified.
2. **Right info panel** (#62) — biggest visible win for the in-game UI.
   Trace `func_O514 → func_O513 → func_O512` chain.
3. **Unit sprites** (#66) — replace the geometric placeholders with CC-NN
   sprite blits. Single biggest visual upgrade.
4. **Coast/beach** (#70) — once the DOSBox reference shows the real
   intended look.
5. **Color trace** (#74) — sweeps a lot of `# noqa` markers in one pass.
6. **Status hint selector** (#75) — small but visible polish.
7. **Hit-test extraction** (#18) — needed for a clickable Europe screen
   etc.; deferred until the RT_DIALOG parser is built.

## Helpers already in place

- `colonize_sdl/menu_data.py` — parses MENU_sections.json
- `colonize_sdl/cc_sprites.py` — loader for the 25 CC-NN sheets
- `colonize_sdl/main.py:_load_widget_options(id)` / `_load_widget_full(id)`
  — pulls a coltext0 widget by ID
- `colonize_sdl/main.py:_load_opening_narration()` — caches narration ids
- `colonize_sdl/main.py:_early_load_names_section(key)` — pulls first-column
  values from a NAMES_sections @KEY block
- `colonize_sdl/main.py:_parse_orders_table(text)` — converts @ORDERS into
  (label, key) tuples
- `tests/check_no_fabrication.py` — CI guard, exempt anything with a
  citation marker
- `docs/COLTEXT0_INDEX.md` — auto-generated 717-string roadmap by role

## Tasks closed without DOS-side input

- **#16** — N/A (no FLC files exist in this game; deleted)
- **#65** — done (AMERICA.MOV identified as not-a-video, route data only)
- **#69** — main menu, nation select, difficulty, title screen all wired
  to coltext0 widgets. Name-entry remains as walkthrough work because
  the input dialog isn't a coltext0 widget (it's a Win16 RT_DIALOG).

## Tasks deferred for walkthrough

- **#62** right info panel (needs func_O514 chain trace)
- **#63** DOSBox screenshots (you run DOSBox)
- **#66** unit sprite mapping (CC-NN → unit-type)
- **#70** coast/beach (needs #63 first)
- **#74** color palette indices (sweeps many noqa markers)
- **#75** status hint selector (per-unit-type filter)
- **#18** hit-test region extraction (RT_DIALOG parser)
