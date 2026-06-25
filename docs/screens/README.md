# Runtime screen gallery — visual ground-truth for the byte-documented UI

Captured 2026-06-25 by driving VICEROY live under headless DOSBox (`tools/drive_game.sh`,
`tools/runtime_snapshot.py`, `docs/RUNTIME_SNAPSHOT.md`). These confirm the **static** UI
decode against the **running** game — the first visual ground-truth in the project. Each shot
is 1024×768 (game letterboxed/centered).

| File | Screen | Confirms (static finding) |
|------|--------|---------------------------|
| `01_mainmenu_BEGINMENU.png` | Main menu | The `BEGINMENU` host menu (`func_0759E8`, Track 2b): exactly the options "Start a Game in NEW WORLD / in AMERICA / CUSTOMIZE New World / LOAD Game / View Hall of Fame". |
| `02_difficulty_select.png` | Choose Difficulty Level | UI_AUDIT_TRACKER row 11 (`func_070580`, `DIFFICUL.PIK`): 5 portraits in a 3-wide grid, "(Click Here When Finished)", `sel=[0x53A6]`. Shown with **Explorer** selected (blue box) — proves live mouse selection. |
| `03_nation_select.png` | Select European Power | UI_AUDIT_TRACKER row 10 (`func_070A1A`, `NATIONS.PIK`): 2×2 flag grid (England/France/Spain/Netherlands), England red-boxed "Immigration". |
| `04_name_entry.png` | Please Enter Your Name | The name-entry dialog with the nation's default leader ("Walter Raleigh" for England). |
| `05_opening_cinematic.png` | Opening cinematic | `spec/ui/cinematics.md`: "In the Year of Our Lord ... 1492" harbor-departure scene. |
| `07_king_audience.png` | Audience with the King | UI_AUDIT_TRACKER row 13 (`func_075352`, `KING.SS`): "we dub thee Viceroy of the New World", scroll text + throne portrait + dog. |
| `06_ingame_map.png` | **In-game map view** | `spec/ui/map_view.md` (was PARTIAL): top menu bar GAME/VIEW/ORDERS/REPORTS/TRADE/COLONIZOPEDIA; minimap top-right; **sidebar HUD confirms the TBD text — "Spring 1498", "Gold: 1000e Tax: 0%"**, active Caravel ("Moves: 4", "Loca: (50,42)", "Eng. Caravel", "No Orders", **"(Sea Lane)"** — CLAUDE.md hard rule 2), cargo "Veteran / 100 Tools". |
| `08_orders_menu.png` | **ORDERS pulldown (active unit)** | The live in-game orders menu: Activate unit / Wait for next unit / Fortify / Sentry / (greyed land orders) / Go to Port / Begin Trade Route / Return to Europe / No Orders (space bar) / Disband Unit (shift-D). Confirms `MENU.TXT @ORDERS` + the `~`-accelerator key-match (`input.md`). |

## How they were produced
Headless DOSBox 0.74 in `Xvfb :99`, driven with `xdotool` and captured with `scrot`. The
input recipe (absolute mouse coords; `mousedown`+hold+`mouseup` not instant click; Space/click
— never Esc — for cinematics) is documented in `tools/drive_game.sh`.

## Status / scope
The setup flow (menu → difficulty → nation → name → intros → cinematic) is visually confirmed.
Reaching the in-game **map** and **active-unit orders menu** (to trace the one remaining
overlay-internal TBD — the accelerator key-match inside `func_06F8FA`) needs further scripted
navigation; in this sandbox the long automation script is killed (exit 144) so it must be driven
one foreground step at a time. The harness itself is proven and reusable.
