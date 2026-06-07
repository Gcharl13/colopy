# UI Fidelity Conformance — every screen / popup / menu vs the original

Tracks DOS-faithful conformance of the pygame port (`colonize_sdl/`) to the
original VICEROY.EXE, screen by screen. Built 2026-05-31 after the Europe-screen
correction taught the lesson: **byte-verified geometry alone is NOT faithful —
the chrome (wood headers, beveled panels, button style, fonts, colors) must be
sampled from the DOS captures in `reference/dos/`.**

## Method (per screen)
1. Open the DOS reference capture (`reference/dos/<screen>.png`, 4× = 1280×800).
2. Sample exact colors at the chrome elements (header, panels, buttons, text).
3. Lay elements at the byte-verified coords (`SCREEN_LAYOUTS.md` / `UI_FIDELITY.md`).
4. Match fonts (`UI_FIDELITY.md` Fonts), sprite indices (`UI_FIDELITY.md` Sprites).
5. Re-render via `tools/render_all_screens.py`; diff vs the DOS capture.
6. Cite every new color/sprite/string; keep the no-fabrication guard green.

## Status legend
✅ done · 🔶 partial (geometry only, chrome not DOS-matched) · ⬜ not started ·
📷 BLOCKED on a DOS capture (needs DOSBox per `reference/dos/CAPTURE_PLAN.md`)

---

## Full-screen states (`colonize_sdl/states.py`)

| Screen | state | DOS reference | status |
|---|---|---|---|
| Map / gameplay HUD | STATE_MAP | MAP_gameplay_dos_reference.png ✓ | 🔶 (geometry byte-verified; chrome vs ref TBD) |
| Colony | STATE_COLONY | COLONY_plymouth/baltimore_dos_reference.png ✓ | 🔶 |
| **Europe / harbor** | STATE_EUROPE | EUROPE_harbor_dos_reference.png ✓ | ✅ **done 2026-05-31** |
| Title / opening narration | STATE_TITLE | — (cinematic) | ⬜ |
| Main menu | STATE_MAIN_MENU | TITLE_screen_dos_reference.png ✓ (partial) | 🔶 |
| Nation select | STATE_NATION_SELECT | 📷 needs capture | 🔶 |
| Difficulty select | STATE_DIFFICULTY | 📷 needs capture | 🔶 |
| Enter name | STATE_ENTER_NAME | 📷 needs capture | ⬜ |
| King audience | STATE_KING_AUDIENCE | 📷 needs capture | 🔶 |
| Hall of Fame | STATE_HALL_OF_FAME | 📷 needs capture | 🔶 |
| Load game | STATE_LOAD_GAME | 📷 needs capture | ⬜ |
| Intro logo (MicroProse) | STATE_INTRO_LOGO | — (cinematic, OOS) | ⬜ |

## Reports (F1–F9, STATE_REPORT_BASE+n)

| F-key | report | DOS reference | status |
|---|---|---|---|
| F1 | Terrain Information | 📷 needs capture | 🔶 (grid geometry only) |
| F2 | Religious Adviser | 📷 needs capture | 🔶 |
| F3 | Continental Congress | CC_continental_dos_reference.png ✓ | ✅ **conformed 2026-05-31** (func_037A10 via 0x191F + REPORT3.PIK scribe backdrop; 0.8%→**88%**) |
| F4 | Labor Adviser | 📷 needs capture | 🔶 |
| F5 | Economic Adviser | 📷 needs capture | 🔶 |
| F6 | Colony Adviser | 📷 needs capture | 🔶 |
| F7 | Naval Adviser | NAVAL_adviser_dos_reference.png ✓ | ✅ **conformed 2026-05-31** (func_3954C 4-col table via 0x191F + REPORT7.PIK ship backdrop; 0.7%→**92%**) |
| F8 | Foreign Affairs Adviser | 📷 needs capture | 🔶 |
| F9 | Indian Adviser | 📷 needs capture | 🔶 |

> NOTE: report bodies are now DECODED (drawlist/REPORTS.md, all 9 via the 0x191F
> unblock). F3 (Continental Congress) and F7 (Naval) have real conformed bodies
> in the port; F1/F2/F4/F5/F6/F8/F9 bodies are decoded + ready to conform (no
> longer "blocked"). The remaining pixel gap on conformed bodies is the shared
> report PIK backdrop (CCBKGD / REPORT7), an asset-decode item.

## Popups / dialogs

The ~30+ GAME.TXT popup templates (see `viceroy_source/docs/
EVENT_DISPATCH.md` + `event_catalog.html`) share ONE dialog frame + sizing engine
(`UI_FIDELITY.md` Popups: centered, max(80,line+10,@width), border 3/inset 2,
WOODFRAM frame, FONTTINY body). Conform the shared chrome once, then verify a
representative set (advisor, king, native, war, independence dialogs).

| Group | examples | DOS reference | status |
|---|---|---|---|
| Shared dialog frame + sizing | (all) | (derive from popups/ captures) | 🔶 (geometry byte-verified) |
| Event/advisor popups | CASHTREASURE, USEDUPTOOLS, ... | 📷 needs capture | ⬜ |
| King/diplomacy popups | tax, war, succession | 📷 needs capture | ⬜ |
| Native popups | mission, raid, trade | 📷 needs capture | ⬜ |

## Menus

| Element | DOS reference | status |
|---|---|---|
| Menu bar strip (8px, GAME/VIEW/ORDERS/REPORTS/TRADE/CHEAT) | MAP_gameplay ✓ (top strip) | 🔶 |
| Dropdown menus (shared dialog sizing engine) | 📷 needs capture | 🔶 |

---

## Capture backlog (user action — DOSBox per reference/dos/CAPTURE_PLAN.md)
Screens/popups marked 📷 have no DOS ground-truth capture. Faithful chrome for
those is blocked until captured at 320×200. Priority captures: Nation select,
Difficulty, King audience, Hall of Fame, the 7 un-captured reports, and a
representative set of event popups.

## Done
- **Europe / harbor** (2026-05-31): 8px wood header + green title, light-blue
  beveled info box + RECRUIT/PURCHASE/TRAIN buttons, mid-band labels, red Exit,
  in-port ship + dock colonist, no dark filler rects. Colors sampled from
  EUROPE_harbor_dos_reference.png.

---

## Feedback-loop results + status (2026-05-31, autonomous run)

**Feedback loop:** `python tools/ui_pixel_loop.py [SCREEN]` renders all screens
headless + pixel-diffs each vs its DOS reference (3-up images in
build/ui_pixel_loop/). This is the pixel-verify step; byte-verify (coords from
VICEROY.EXE) comes first.

**Baseline perceptual(60) match vs DOS reference:**
| screen | match | notes |
|---|---|---|
| TITLE | 99% | already close |
| EUROPE | ~90% | conformed (byte-verified); see below |
| MAIN_MENU | 76% | |
| MAP | 37% | terrain renderer is correct; DOS ref differs in style/dither |
| COLONY | 17% → (in progress) | byte-verified coords (SCREEN_LAYOUTS §3) being applied |
| REPORT3 (CC) | ~0% | report bodies are STUBS ("Report not yet available") |
| REPORT7 (Naval) | ~0% | stub |

**EUROPE — done, byte-verified (commit 188):** market price near-black
(palette 0x2F) at y=194; ship at verified base x=146; market bar / dock box /
buttons / bg all at byte-verified coords. **KEY LIMITATION:** the 3-column
mid-band layout ("Expected Soon/Bound For/Loading" are per-ship status strings,
not headers), the per-ship-slot Y, and the info-line Y are computed in the
**blocked overlay 0x191f** -- NOT byte-verifiable from page_04. Those are
rendered approximately / omitted (no guessing) and flagged in code.

**Method confirmed (the hard lesson):** byte-verify coords from the disassembly
FIRST (do not eyeball the screenshot); pixel-verify vs the DOS capture SECOND.
Where a coordinate lives only in overlay 0x191f (blocked), it cannot be
byte-verified -- mark it, don't guess.

**Per-screen byte-verification availability:**
- Colony: FULLY byte-verified (func_028592, SCREEN_LAYOUTS §3). Applying now.
- Reports grid: byte-verified (func_06FDF0/0702C0). Bodies are unimplemented stubs.
- Dialogs/menus: byte-verified geometry (UI_FIDELITY Popups/Menus).
- Europe: ~80% byte-verified (page_04); rest in blocked 0x191f.
- Map terrain: verified-correct (RULINGS 2026-05-31).
- Capture-gated screens (pickers/King/HoF/7 reports): need DOS captures (#48).

---

## Report screens — byte-trace result (2026-05-31)

**Reconciliation (corrects SCREEN_LAYOUTS §4):** the generic 12-cell grid
(func_06FF94 + func_06FDF0/0702C0, page_19/record-24) is a SELECTABLE/reorderable
grid screen, NOT the F-key advisor reports. The F2-F9 advisor reports dispatch
via `lcall 0x191F:0x3xx` (func_0235D6, e.g. F3 @0x02386E) → Type-A fault-in into
the runtime page directory = **BLOCKED overlay 0x191F**.

**BYTE-VERIFIED (conformable now) — the report FRAME func_06FF94:** title-bar
sprites 0xFD/0xFE w=0x140 y=0 count=4 (tiler 0x181F:0x1C8=resident); title str
[0x2EFA]; header rule y=16 (rect 0x181F:0xE2=resident); subtitle str [0x2EFC];
footer text y=190; footer rule y=183; body font FONTTINY [0x89E] (les bx,[0x89E]
@0x06FEB6). Cell formulas: 4-col col*76+10 / row*60+16; 3-col col*105+23 /
row*96+7. Frame draw primitives are RESIDENT (Type-B), not blocked.

**BLOCKED (overlay 0x191F — PNG-measured only, NOT byte-citable):** the F-key
report BODIES. F3 Continental Congress (bell-progress bar, sentiment line, REF
icon rows, FF list) and F7 Naval (4-col ruled table: Ship/Cargo/Location/Dest,
separators x~9/82/162/242, row rules y=40..180 stride 20, ship sprites) — coords
measured from CC_continental / NAVAL_adviser refs, must be tagged
"NEEDS VERIFICATION (overlay 0x191F not extracted)". Frame chrome is PIK-driven
(CCBKGD/REPORT7 backdrops); dark structural lines ~RGB(143,13,0).

**Plan:** conform the byte-verified report FRAME (title bar/rules/subtitle/font)
to ALL F-key reports; leave the bodies stubbed + tagged blocked (no guessing).
The ADVISOR_REPORTS_AUDIT.md F3=0x025FD0/F7=0x027B0C offsets are broken-thunk
artifacts (land mid-instruction in the colony overlay) — do NOT cite them.

---

## Full UI decompilation program — shift gears (2026-05-31)

The "BLOCKED overlay 0x191F" caveat above is **OBSOLETE.** The overlays are
statically resolvable (`tools/rtlink/rtlink_decode.py
validate` → ALL PASS; RULINGS commit 199). Every report body, the Europe
3-column band, and the colony terrain scene are now reachable. F3 is the proof
(decoded + conformed, 0.8%→53.5%).

Per the user directive ("this ui is pretty simple — this screen, these sprites,
this string, this location ... decompile whatever's needed so there is no
question of if something is missing"), the work shifted to a **complete
byte-cited draw-list decode of every UI surface**, sourced straight from the
now-resolvable original. Outputs (single source of truth for BOTH the C
reconstruction and the port):
- `viceroy_source/docs/drawlist/REPORTS.md` — all 9 F-key bodies
- `viceroy_source/docs/drawlist/EUROPE_COLONY.md` — Europe overlay band + colony terrain scene
- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` — master painter index + Title/menu/pickers/King/HoF/Map-HUD/popup-frame/menus

Each entry = sprite (sheet+index+x,y) / string (source+x,y+font+color) /
rect-line-gauge (coords+color), every value cited to a file offset or named
table; genuinely unresolvable values tagged `NEEDS VERIFICATION` (never
guessed). The port renderers then conform to these specs screen by screen.
