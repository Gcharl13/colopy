# UI AUDIT TRACKER — byte-verified documentation of the ENTIRE VICEROY UI

> Mandate: `CLAUDE.md` "UI DOCUMENTATION MANDATE". Goal = 100% byte-verified docs of every
> screen + every element's exact placement/font/string/color, enough to rebuild. No
> fabrication: every cell cites a `func@offset` or is **TBD** with the blocker named.
> Status: **DONE** (every element byte-cited or TBD-with-blocker) / **PARTIAL** / **TBD**.
> Last updated: 2026-06-24 (autonomous scrub).

## Screens & subsystems

| # | Screen / subsystem | entry / composer | decode doc | status |
|---|--------------------|------------------|-----------|--------|
| 1 | Map view (HUD/sidebar/menubar/minimap/viewport) | enter_screen_view 0xD @0x076871 | spec/ui/map_view.md | PARTIAL (sidebar per-line x/y TBD; menu-bar) |
| 2 | Colony screen | composer func_028592; screen 0x2C @0x025EE5 | docs/COLONY_SCREEN_VICEROY_DECODE.md | PARTIAL (RNG placement func_025D34 §12, frame table — being ported) |
| 3 | Europe screen | composer func_031E4C; screen 0x2B @0x030DEB | docs/EUROPE_SCREEN_VICEROY_DECODE.md | PARTIAL (heap-string contents, menu gold blit) |
| 4 | Advisor reports F1–F10 | dispatch @0x023843; bodies 0x37xxx–0x3Axxx | spec/ui/advisor_reports.md | PARTIAL (per-report exact rows) |
| 5 | Continental Congress (F3 + Activities) | func_037A20 / congress_screen_render | spec/ui/continental_congress.md | PARTIAL |
| 6 | Popups / dialogs engine | func_06C520/06D316/06C850 | spec/ui/popups.md | PARTIAL (geometry engine DONE; per-popup) |
| 7 | In-game menu bar + dropdowns | func_072090 build; @0x060890 line | spec/ui/menus.md | PARTIAL |
| 8 | Main/boot menu (OPENMENU/BEGINMENU) | func_075xxx; screen 0x2A @0x07661F | spec/ui/menus.md | PARTIAL |
| 9 | Opening / intro (OPENING.PIK) | screen 0x18 @0x077401 region | — | TBD |
| 10 | Nation select (NATIONS.PIK) | screen 0x18 region | — | TBD |
| 11 | Difficulty select (DIFFICUL.PIK) | — | — | TBD |
| 12 | Customize (CUSTOMIZ.PIK) | — | — | TBD |
| 13 | King audience / loss / win (KING*) | king-defeats func_075352 | spec/ui/fonts_and_colors.md (font) | TBD (layout) |
| 14 | Native diplomacy / raids (IND*) | popup channels func_06BE92 | spec/ui/popups.md §2.7 | PARTIAL |
| 15 | Score screen (SCORE01–24) / F10 | func_03A9C0 @0x03A9C0 | spec/ui/advisor_reports.md §F10 | PARTIAL |
| 16 | Declaration of Independence (DECLARAT) | screen 0x28 @0x0450AE? | — | TBD |
| 17 | Closing / end (CLOS-BKG) | — | — | TBD |
| 18 | Fonts (FONTTINY/INTR/KING/NP) | 4 loads | spec/ui/fonts_and_colors.md | PARTIAL (glyph widths) |
| 19 | Screen-view runner / event loop | enter_screen_view 0x181F:0x772 | — | TBD (the framework all screens share) |
| 20 | Colony RNG placement PORT | func_025D34/009726/00C322 + 0x7238 frame | docs/COLONY_SCREEN_VICEROY_DECODE.md §12 | IN PROGRESS (this session) |

## Screen-id map (enter_screen_view `bx`)
- 0x2D @0x005E63 · 0x2C @0x025EE5 (colony) · 0x2B @0x030DEB (europe) · 0x28 @0x0450AE
  · 0x29 @0x06D5AA · 0x2A @0x07661F (boot menu) · 0xD @0x076871 (map) · 0x18 @0x077401/
  0x0774E4/0x0775A7 (intro/nation/difficulty) · more @0x078B8B/0x078C7C.

## Method (every agent/pass follows)
- Disasm tool: `scratchpad/disv.py 0xADDR N`; thunks: `tools/follow_thunk.py SEG OFF`.
- Cite every coordinate to the push/mov site. Runtime/RNG/BSS → TBD + the exact site.
- Output: a code-anchored decode section/doc; update this tracker honestly.
