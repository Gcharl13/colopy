# `colonize_sdl/` — Module Layout & Split Plan

**Status:** plan written 2026-05-02; execution pending.

This document is the standing reference for how `colonize_sdl/main.py` will be
split into focused modules. Read it before editing the game code so future
changes go to the right module, and so PRs that touch many files at once can
be reviewed against an explicit map of responsibilities.

---

## Why split

`main.py` is currently 4,711 lines. A single `ColonizationApp` class holds
109 methods. This causes three concrete problems:

1. **Edit-tool truncation.** Past sessions have lost trailing methods when
   the `Edit` tool truncated mid-write. Rebuilding the tail by appending via
   bash heredoc has happened several times. Smaller files are reliably
   editable.
2. **Lost orientation.** Finding which method handles a given UI screen or
   gameplay action means scrolling through a 4,700-line file. Module-level
   names give immediate orientation.
3. **Implicit coupling.** Every method shares all `self.*` state implicitly.
   Splitting forces us to acknowledge what each unit of code actually
   touches, which surfaces accidental coupling.

## What we are *not* solving here

- Headless-vs-rendered split. The headless engine already lives in
  `colonize_sdl/engine/`. The split below is purely for the pygame-driven
  app shell.
- A rewrite. Every method moves wholesale; behaviour stays identical. The
  visual-regression suite and no-fabrication CI guard will both run after
  the split.
- Renaming public API. `ColonizationApp` stays the entry-point class;
  `colonize_sdl/main.py` stays the entry script.

---

## Composition technique: mixins

`ColonizationApp` will become an assembly:

```python
# colonize_sdl/app/__init__.py
from .init_world      import InitWorldMixin
from .loop            import LoopMixin
from .input_handlers  import InputHandlersMixin
from .actions         import ActionsMixin
from .turn            import TurnMixin
from ..render         import RenderMixin

class ColonizationApp(
    InitWorldMixin,
    LoopMixin,
    InputHandlersMixin,
    ActionsMixin,
    TurnMixin,
    RenderMixin,
):
    """The pygame app shell. State lives on this single instance; behaviour
    is provided by the mixins above. See docs/MODULE_LAYOUT.md."""
```

Every method that currently calls `self.gs`, `self.font`, `self.view_x`, etc.
keeps working unchanged — mixins inherit through `self` like any other
method-resolution chain. No find/replace of `self.x` → `app.x` is needed.

**Trade-off accepted:** mixins do not enforce which state each module reads
or writes. The discipline lives in this document and in PR review.

**Why not `app: ColonizationApp` arguments?** It would require editing every
method body. The diff would be enormous, regressions would be more likely,
and the readability gain is marginal because `app.foo` is essentially
`self.foo` with a rename.

---

## Target layout

```
colonize_sdl/
├── main.py                     entry point — ~30 LoC, just `if __name__`
├── constants.py                display geometry + asset paths
├── dos_data.py                 extracted DOS text → parsed Python data
├── states.py                   STATE_* enum + menu bar + cheat menu
├── palette.py                  PALETTE bytes loader
├── font.py                     BitmapFont class
├── sprites.py                  load_sprite_sheet + load_background
├── message_log.py              MessageLog (in-game ticker)
├── market.py                   MarketState (Europe trading)
├── unit_sprite_map.py          (EXISTING — leave alone)
├── menu_data.py                (EXISTING — leave alone)
├── cc_sprites.py               (EXISTING — leave alone)
├── cc_unit_map.py              (EXISTING — leave alone)
│
├── app/
│   ├── __init__.py             ColonizationApp class assembled from mixins
│   ├── init_world.py           InitWorldMixin
│   ├── loop.py                 LoopMixin
│   ├── input_handlers.py       InputHandlersMixin
│   ├── actions.py              ActionsMixin
│   └── turn.py                 TurnMixin
│
├── render/
│   ├── __init__.py             RenderMixin assembled from sub-mixins
│   ├── terrain.py              TerrainRenderMixin
│   ├── entities.py             EntitiesRenderMixin
│   ├── hud.py                  HudRenderMixin
│   └── screens.py              ScreensRenderMixin
│
└── engine/                     (EXISTING, headless game logic — unchanged)
```

Total: **14 new files**, 4 existing.

---

## Module specifications

### `main.py` — entry point

**Goal.** Be the script users invoke (`python colonize_sdl/main.py`). Set up
SDL, instantiate the app, run the main loop. That's all.

**Contents.**
```python
from colonize_sdl.app import ColonizationApp

def main():
    app = ColonizationApp()
    app.run()

if __name__ == "__main__":
    main()
```

**Edit policy.** Don't add logic here. If you find yourself wanting to, the
logic belongs in `app/loop.py` or one of the action modules.

### `constants.py` — display geometry + asset paths

**Goal.** Single home for every layout/screen/path constant.

**Contents.**
- `NATIVE_W=320`, `NATIVE_H=200`, `SCALE=3`, `WINDOW_W/H`, `FPS=30`,
  `TILE_W=16`, `TILE_H=16`.
- Panel rectangles: `MENU_BAR_*`, `MAIN_AREA_*`, `MAP_VP_*`, `RPANEL_*`,
  `STATUS_BAR_*`, `VIEW_TILES_X/Y`.
- Path roots: `BASE_DIR`, `ASSET_DIR`, `SPRITE_DIR`, `BG_DIR`, `FONT_DIR`,
  `PALETTE_FILE`, `TEXT_DIR`, `COLONIZE_DIR`.

**Edit policy.** Adding a panel? Add its `*_X/Y/W/H` here. Adding a new
asset directory? Add it here. **Never edit `TILE_W`, `TILE_H`, `SCALE`** —
hard rule from `CLAUDE.md`.

### `dos_data.py` — extracted DOS text + parsed names

**Goal.** Parse `extracted/text/*.json` once at import time, expose ready-
to-use Python data.

**Contents.**
- Loaders: `_load_text_section`, `_parse_newline_list`, `_parse_first_col`,
  `_early_load_names_section`.
- `_NAMES_DATA`, `_GAME_DATA`, `_COLONY_DATA`, `_MENU_DATA`, `_LABEL_DATA`.
- `GOOD_NAMES`, `GOOD_COLORS`, `NATION_COLORS`, `BUILDING_NAMES`,
  `_BUILDING_NAMES_LIST`.
- `COLONY_NAMES_BY_NATION`, `COLONY_NAMES_POOL`,
  `DOS_DIFFICULTY_NAMES`, `DOS_LEADER_NAMES`, `DOS_HOME_PORTS`,
  `DOS_NATION_NAMES`, `DOS_NATIONALITY`, `DOS_NATION_ABBREV`,
  `DOS_GREAT_KINGS`, `DOS_GREAT_DEEDS`, `DOS_GREAT_LEADER`, `DOS_MY_LEADER`,
  `DOS_TERRAIN_NAMES`, `DOS_SEASONS`, `DOS_ORDER_HINTS`.
- `TERRAIN_PAL_INDEX`, `TERRAIN_COLORS` (palette-derived terrain colors).

**Edit policy.** Adding a DOS-derived name list? Parse it here. **Never
hardcode UI strings**: pull them from `extracted/text/*` and parse them in
this module so the no-fabrication CI guard stays green.

### `states.py` — STATE_* enum + menu data

**Goal.** Top-level UI state machine constants.

**Contents.** `STATE_MAP`, `STATE_COLONY`, `STATE_EUROPE`, `STATE_TITLE`,
`STATE_MAIN_MENU`, `STATE_NATION_SELECT`, `STATE_DIFFICULTY`,
`STATE_ENTER_NAME`, `STATE_KING_AUDIENCE`, `STATE_HALL_OF_FAME`,
`STATE_LOAD_GAME`, `STATE_INTRO_LOGO`, `STATE_REPORT_BASE`. Plus
`MENU_ITEMS`, `MENU_DROPDOWNS`, `CHEAT_MENU_ITEMS` (built from
`menu_data.get_menu_data()`).

**Edit policy.** Adding a new top-level screen? Allocate the next state
constant here. Don't put state-specific logic in this module.

### `palette.py` — PALETTE loader

**Goal.** One way to load the 256-color VGA palette.

**Contents.** `_load_module_palette()`, exported `PALETTE`, helper
`load_palette()`.

### `font.py` — BitmapFont

**Goal.** The bitmap-font renderer. Loads from
`extracted/fonts/<name>.png`, supports `.render`, `.render_centered`,
`.text_width`, `_recolor`, `_render_builtin`.

**Edit policy.** Adding font support (new face, kerning, etc.)? Edit here.
Don't reach into pixel arrays from outside this module.

### `sprites.py` — sprite-sheet + background loaders

**Goal.** Two free functions: `load_sprite_sheet(name)` and
`load_background(name)`. Both read from `extracted/assets/...`.

### `message_log.py` — MessageLog

**Goal.** The in-game message ticker (turn events). Methods: `add`, `tick`,
`recent`.

### `market.py` — MarketState

**Goal.** Europe market state — bid/ask, sell, buy, end-of-turn drift.

### `app/__init__.py` — class assembly

**Goal.** Compose `ColonizationApp` from mixins. No logic. Re-exports
`ColonizationApp`.

### `app/init_world.py` — `InitWorldMixin`

**Goal.** Construction + world setup.

**Methods.** `__init__`, `init_game`, `_load_amer2_map`,
`_generate_random_map`, `_create_starting_units`,
`_create_ai_starting_units`, `_is_water_tile`, `_is_land_tile`,
`_find_coastal_water`, `_sel_unit`, `_player_units`, `_player_nation_state`.

**Edit policy.** Adding new world-init logic (more nations, scenario maps)
goes here. Adding gameplay reactions to user input does NOT.

### `app/loop.py` — `LoopMixin`

**Goal.** Main loop + dispatch. Owns the per-frame tick.

**Methods.** `run`, `update`, `handle_input`, `_update_cursor_tile`,
`_mouse_edge_scroll`, `_scroll_map`, `render`, `_handle_key`,
`_handle_click`, `_handle_mouse_move`, `_terrain_name`.

**Edit policy.** This is the dispatcher. New input types or new top-level
state branches in `update`/`render`/`_handle_*` go here. Per-screen
behaviour goes in `input_handlers.py` or `render/screens.py`.

### `app/input_handlers.py` — `InputHandlersMixin`

**Goal.** Per-state keyboard and mouse handlers.

**Methods.** All `_key_*` (`_key_title`, `_key_main_menu`,
`_key_hall_of_fame`, `_key_intro_logo`, `_key_load_game`, `_key_report`,
`_key_difficulty`, `_key_enter_name`, `_key_king_audience`,
`_key_nation_select`, `_key_map`, `_key_colony`, `_key_europe`),
plus all `_click_*` (`_click_main_menu`, `_click_nation_select`,
`_click_difficulty`, `_click_map`, `_click_dropdown`, `_click_right_panel`,
`_click_colony`, `_click_europe`).

**Edit policy.** Adding a new key binding for an existing screen → add to
that screen's `_key_*`. Adding a new screen → add a new `_key_*` and a new
`_click_*`, then dispatch from `loop.py`'s `_handle_key`/`_handle_click`.

### `app/actions.py` — `ActionsMixin`

**Goal.** Gameplay actions triggered by input. The "verbs" of the game.

**Methods.** Movement: `_move_unit`, `_process_goto`, `_center_view_on`,
`_open_colony_at`, `_open_europe`, `_explore_lost_city`, `_next_colony_name`,
`_auto_next_unit`, `_any_units_with_moves`. Unit commands: `_cmd_space`,
`_cmd_wait`, `_cmd_next_unit`, `_cmd_found_colony`, `_cmd_fortify`,
`_cmd_sentry`, `_cmd_enter_colony`, `_cmd_center_on_unit`. Menu execution:
`_execute_menu_item`. Save/load: `_save_game`, `_load_game`,
`_list_save_files`, `_load_save_file`. Europe trade: `_europe_sell`,
`_europe_buy`, `_europe_recruit`. Pre-game widget loaders:
`_load_widget_options`, `_load_widget_full`, `_load_opening_narration`.

**Edit policy.** Adding a new keyboard shortcut → add the `_cmd_*` method
here, then bind it from the appropriate `_key_*` in `input_handlers.py`.

### `app/turn.py` — `TurnMixin`

**Goal.** End-turn cycle.

**Methods.** `_end_turn`, `_process_colony_production`,
`_check_sentry_wake`.

**Edit policy.** Anything that runs once per game turn goes here — colony
production, market drift, AI moves, sentry checks, victory/defeat checks.

### `render/__init__.py` — `RenderMixin` assembly

**Goal.** Compose `RenderMixin` from `Terrain` + `Entities` + `Hud` +
`Screens` mixins.

### `render/terrain.py` — `TerrainRenderMixin`

**Goal.** Per-tile terrain pipeline: ocean, land, forests, hills, mountains,
rivers, coast halos, native settlements.

**Methods.** `_render_terrain` (the 684-line monster), `_render_native_settlements`,
plus the helpers: `_row_base_for_terrain` (staticmethod), `_draw_coast`,
`_blit_phys0`, `_edge_mask`, `_edge_mask_terrain`, `_edge_mask_forest`,
`_edge_mask_feature`, `_edge_mask_forest_all`.

**Edit policy.** Every change here must cite a PHYS0/TERRAIN sprite index,
a VICEROY.EXE offset, or a `docs/RULINGS.md` entry. Run
`tests/run_regression.py` after every change.

### `render/entities.py` — `EntitiesRenderMixin`

**Goal.** Sprites that sit ON TOP of the terrain — units, colonies.

**Methods.** `_render_units`, `_render_colonies`.

**Edit policy.** Unit/colony sprite indices are in `unit_sprite_map.py`;
import from there, never hardcode an ICONS.SS index in this file.

### `render/hud.py` — `HudRenderMixin`

**Goal.** The fixed UI furniture overlaid on every map view.

**Methods.** `_render_right_panel`, `_render_messages`, `_render_minimap`,
`_render_menu_bar`, `_render_dropdown`, `_render_selection`,
`_render_map_screen` (the composer that calls terrain + entities + hud
in order), `_render_cargo_strip`.

**Edit policy.** Everything inside the 320×200 frame that isn't a tile or
an entity — menu bar, status bar, sidebar, minimap, dropdowns — lives here.

### `render/screens.py` — `ScreensRenderMixin`

**Goal.** Full-screen, non-map states. Pre-game flow + auxiliary screens.

**Methods.** `_render_title`, `_render_main_menu`, `_render_intro_logo`,
`_render_nation_select`, `_render_difficulty`, `_render_enter_name`,
`_render_king_audience`, `_render_pedia_entry`, `_render_hall_of_fame`,
`_render_founding_father`, `_render_load_game`, `_render_report`,
`_render_colony_screen`, `_render_europe_screen`.

**Edit policy.** Each screen is its own method, ~50-100 LoC. Touching one
screen should not touch another. If a screen grows past ~150 LoC, factor a
helper out into the same module — don't sprinkle helpers across multiple
files.

---

## Estimated sizes after split

Approximate, rounded:

| Module                       | Lines |
|------------------------------|-------|
| `main.py`                    | 30    |
| `constants.py`               | 80    |
| `dos_data.py`                | 250   |
| `states.py`                  | 50    |
| `palette.py`                 | 30    |
| `font.py`                    | 110   |
| `sprites.py`                 | 40    |
| `message_log.py`             | 30    |
| `market.py`                  | 60    |
| `app/__init__.py`            | 50    |
| `app/init_world.py`          | 320   |
| `app/loop.py`                | 250   |
| `app/input_handlers.py`      | 450   |
| `app/actions.py`             | 600   |
| `app/turn.py`                | 110   |
| `render/__init__.py`         | 20    |
| `render/terrain.py`          | 800   |
| `render/entities.py`         | 160   |
| `render/hud.py`              | 700   |
| `render/screens.py`          | 1100  |
| **Total**                    | **5240** |

(Slightly more than the current 4,711 because of import + class-shell
overhead per module.)

The biggest module post-split (`render/screens.py` at ~1100 LoC) is still
under 25% of the current monolith and contains 14 well-named methods, each
self-contained.

---

## How to use this layout for future edits

When you need to make a change, find the right home:

| If you are changing…                          | Edit…                       |
|-----------------------------------------------|-----------------------------|
| Display geometry (panel size, viewport)       | `constants.py`              |
| A DOS-extracted name / list                   | `dos_data.py`               |
| The state machine (new screen)                | `states.py` + new `_key_*` + new `_render_*` |
| Bitmap font behaviour                         | `font.py`                   |
| Sprite-sheet loading                          | `sprites.py`                |
| In-game ticker                                | `message_log.py`            |
| Europe trading economy                        | `market.py`                 |
| First-frame setup / map load                  | `app/init_world.py`         |
| Frame loop / state dispatch                   | `app/loop.py`               |
| A keyboard or mouse binding                   | `app/input_handlers.py`     |
| A unit command / Europe action / save-load    | `app/actions.py`            |
| Per-turn processing                           | `app/turn.py`               |
| How a tile is drawn                           | `render/terrain.py`         |
| How a unit or colony glyph is drawn           | `render/entities.py`        |
| Sidebar / menu bar / minimap / dropdown / cargo strip | `render/hud.py`     |
| A pre-game or auxiliary full-screen UI        | `render/screens.py`         |

**Cross-cutting changes** (e.g. "rename a state, add a new screen") will
touch `states.py`, `loop.py`, `input_handlers.py`, and `render/screens.py`.
That's expected — those are the four files that compose the state machine.

---

## Migration steps

1. **Snapshot the current state.** Run regression to capture baseline:
   `python tests/run_regression.py`. Record the baseline-violation count
   from `tests/check_no_fabrication.py`.
2. **Repair the existing truncation in `_render_europe_screen`.** The file
   currently ends mid-statement (`            ta`) — line 4712 is an
   incomplete name. This is harmless to Python's parser (`ta` is a valid
   bare-name expression) but means the Europe screen partially crashes when
   actually rendered. Fix this BEFORE moving the method.
3. **Extract leaf modules first** (no inter-mixin dependencies):
   `constants.py`, `palette.py`, `font.py`, `sprites.py`, `message_log.py`,
   `market.py`, `dos_data.py`, `states.py`. After each, smoke-test imports.
4. **Build the `app/` package** (mixins): `init_world.py`, `loop.py`,
   `input_handlers.py`, `actions.py`, `turn.py`, then `app/__init__.py`.
   Smoke-test `ColonizationApp().init_game()` after each mixin lands.
5. **Build the `render/` package**: `terrain.py`, `entities.py`, `hud.py`,
   `screens.py`, then `render/__init__.py`. Smoke-test all six render
   paths (`_render_terrain`, `_render_units`, `_render_colonies`,
   `_render_minimap`, `_render_messages`, `_render_right_panel`) after
   each.
6. **Reduce `main.py`** to its 30-line entry-point form.
7. **Run the regression suite.** `tests/run_regression.py` should pass with
   no diffs against goldens.
8. **Run the no-fabrication CI guard.** New violations should be zero (the
   pre-existing baseline of 133 still stands; this split touches structure
   only).
9. **Update `STATE.md`** to reflect the new layout.

Each step gates the next: don't move on until smoke + regression are clean.
