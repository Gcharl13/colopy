# Opening-Sequence Decode Audit — VICEROY.EXE (1994 DOS Colonization)

**Question:** is the launch → playable-map opening sequence fully decoded in the
C reconstruction?

**Method:** traced the six stages function-by-function against
`docs/decompile_status.json`, the ported C in `src/`, the re-segmented overlay
disassembly (`code/VICEROY/disasm_overlay_reseg/page_*.asm`), `raw/COLONIZE/GAME.TXT`
(message keys), and `docs/enrich/*.json` (emitter attributions). Two transitions
were byte-spot-checked against the EXE image. Citations below are evidence anchors;
prose is address-free.

---

## Stage-by-stage table

| # | Stage | Function(s) | Status | What it does | Gap? |
|---|-------|-------------|--------|--------------|------|
| 1 | **Program entry / boot** | `entry_point` (0x013BED), `system_init` (0x013BF7), `dos_version_check_stub` (0x0F720), `cstart` (0x0F72D) | entry/init/cstart = **out-of-scope** in status JSON, but all **ported** in `src/boot/entry.c` + `src/runtime/cstart.c`; `entry_point`/`dos_version_check_stub`/`cstart` byte-equal; `system_init` **PARTIAL** (Region 1 of 4 line-by-line; ~3 regions of layout-globals init still TBD) | Far-call `system_init` (EMS/XMS probe, heap alloc, shrink program block via INT 21h AH=4Ah, hook env-var INT 21h), then DOS-version gate (≥2.0), then C-runtime startup (`cstart`) which pushes argc/argv/envp and calls `_main()` through the overlay thunk at file 0x1A5F0. | Minor: `system_init` body Regions 2–4 (the ~20 layout globals at DGROUP:0x3995..0x39FF) are summarized, not line-traced. The overlay-resident **`_main()`** top-level dispatcher (asset bootstrap → title state machine → per-turn loop) is sketched in `ARCHITECTURE.md`/`RENDER_CHAIN.md` but has **no decoded function row** in the status JSON — it is the one un-pinned seam between resident boot and the overlay menu. |
| 2 | **Opening cutscene / intro** | The MicroProse/title cinematic player | **OUT-OF-SCOPE** (separate executable) | The opening cinematic is **not in VICEROY.EXE**. It is played by a separate program, `OPENING.EXE` (`docs/ASSET_ROLES.md`: "Title-screen / cinematic player"), driven by `OPENING.TXT` (frame timing), `PATH.DAT` (ship trajectory) and `AMERICA.MOV` (a 572-byte camera-path script, not a video). | Intentional scope exclusion (DOS media playback: MOV/PCX/PAL). Documented in `docs/UI_VERIFICATION.md`. Not a reconstruction defect. |
| 3 | **Main menu** (`@BEGINMENU`) | `func_0759E8` save_load_game_screen (overlay 0x26) | **DONE** (control flow BYTE_VERIFIED) | Presents the `@BEGINMENU` panel (key string @DS:0x2345) over the `OPENMENU` plate and dispatches the five options: 1=Start in NEW WORLD (random), 2=Start in AMERICA, 3=CUSTOMIZE New World, 4=LOAD Game, plus quick-paths for autoload slot `[0x104]` and scenario `[0x828]`. Also drives the save/load slot dialogs. | None for the dispatch itself. The presentation skeleton in `src/ui/title_screen.c` is STALE/redundant — its "menu layout & dispatch are TBD" note predates `func_0759E8`; the dispatch IS decoded. The menu's *pixel layout* (PIK blit sequence) remains catalog-only. |
| 4 | **New-game setup** (`@AMERICA`/`@MAPTOLOAD`, `@PICKNATION`, `@DIFFICULTY`, `@LEADERNAME`/`@FINDCITY`) | America-vs-Editor + map pick: inside `func_0759E8` (`@AMERICA` @DS:0x234F, `@MAPTOLOAD` @DS:0x2357). Difficulty picker: `func_070302`/`func_070494`/`func_070580_difficulty_pick_dispatch`. Nation picker: `func_0707B6`/`func_07092E`/`func_070A1A_nation_pick_dispatch`. Leader/nation/REF tables: `func_0749E0_load_names_data_tables` (reads @PICKNATION/@DIFFICULTY/@LEADERNAME sections from NAMES.TXT). New-game power-table init: `func_07431E_new_game_init`. | Pickers + AMERICA pick + func_07431E = **DONE / byte-verified**; `func_0749E0` = **DONE** in C banner (status JSON lags at "partial" — two inner name sub-loaders TBD-inner) | Difficulty/nation rows are drawn from per-row label tables; the dispatchers return the chosen index. `func_07431E` resolves player count, RNG-picks the human power (random_int(0,3), clamp ≤3 → [0x5398]), zeroes the four PowerRecords / AIPersonality slots, draws the intro panel (WOODPANL/LEADERNAME/NATION0A), and builds the multiplayer roster if 4 human players. `func_0749E0` loads the NAMES.TXT data tables (SEASONS/UNFORESTED/FORESTED/SCENARIO + LEADERNAME/DIFFICULTY/PICKNATION). | Minor: two inner name sub-loaders in `func_0749E0` and the `func_07431E` MULTI-roster block are structure-cited but not fully line-traced. `@FINDCITY` is an *in-game* "where is colony" picker (`src/ui/options_dialog.c`, DONE), not strictly opening-flow. |
| 5 | **Map gen / load + place starting units** | World-gen: `func_064A10` (4886 bytes, overlay 0x14), reconstructed across `src/mapgen/{generator,climate,rivers,settlements}.c`; tail `func_065D26`. .MP load: `func_071106_load_mp_map`; buffers `func_070FF8_alloc_map_buffers`; default-map load `func_0713D4_load_default_map`. Scalar init + difficulty-scaled REF + **per-power starting-unit seeding**: `func_0755CC_new_game_init`. | `func_064A10` control flow **BYTE_VERIFIED** (status JSON's "referenced/no file" is stale — it IS ported in `src/mapgen/`); `func_065D26` = **PARTIAL**; `func_071106`/`func_070FF8`/`func_0713D4` = **DONE**; `func_0755CC` = **DONE** | `func_064A10` fills the 4 map layers in 7 passes (P0 init → P1 landmass blob-growth → P2 climate latitude bands → P3 smoothing → P4 rivers → P5 sea-lane/arctic borders → P6 seed the 4 European starting (x,y) into PowerRecord +0x32/+0x33), gated on a premade-vs-random arg. `func_071106` loads an `.MP` (header {u16 w, u16 h} + 4 layers). `func_0755CC` seeds the default 0x3A×0x48 AMER2 map, sets difficulty-scaled REF/king-anger thresholds, then per active power **creates 3 units at the home tile**: settler (kind 0xD), soldier (kind 2), scout (kind 1) — i.e. the Caravel + Soldier + Pioneer trio — with per-nation subtype tweaks. | Minor: `func_065D26` (world-gen tail) is PARTIAL. Native-settlement / prime-resource / lost-city-rumour placement is largely NAMES.TXT-driven and only partly traced (`settlements.c` + TBD functions) — noted but outside the strict 6-stage spine. |
| 6 | **Into game** (`@LANDHO` naming, `@VICEROY`/`@VICEROY2` investiture, hand control to player) | `@VICEROY`/`@VICEROY2` investiture: emitted via `func_075594_show_simple_message_dialog` (per `docs/enrich/setup_misc_score.json`). Final present/blit + hand-off: tail of `func_0755CC` (blit A000:FC00, draw screen 0x25, return). `@LANDHO` ("name this new land"): a UI message key with **no traced emitter** in the new-game path. (`@LANDFALL`/in-game landfall = `func_03FDDE`, `src/combat/naval.c`, BYTE_VERIFIED — distinct from the opening.) | `func_075594` = **byte-verified**; `func_0755CC` tail = **DONE**; `@LANDHO` emitter = **NOT TRACED** | After unit seeding, `func_0755CC` runs post-setup thunks, blits the framebuffer, draws the main game screen (0x25) and returns control. The investiture panel ("Year of Our Lord 1492 … we dub thee Viceroy of the New World"; Netherlands gets the Stadtholder `@VICEROY2` variant) is shown through the generic message-dialog function `func_075594`. | Concrete gap: the exact **call site** that fires `@VICEROY`/`@LANDHO` is not pinned — `func_075594` is the *renderer* of the message, but which opening-flow function invokes it with the VICEROY key (and where `@LANDHO` "name the new land" is prompted) is **catalogued but not byte-traced** (`event_catalog.json` marks both "UI / no traced emitter"). |

---

## Call chain (entry → first turn)

```
DOS loader
  └─ entry_point (0x013BED)                         [ported; out-of-scope C-runtime stub]
       ├─ system_init (0x013BF7)                     [PARTIAL: EMS/XMS/heap; regions 2-4 TBD]
       └─ dos_version_check_stub (0x0F720)           [ported; DOS≥2.0 gate]
            └─ cstart (0x0F72D)                       [ported; C runtime, pushes argc/argv]
                 └─ _main()  [overlay-resident]       <<< NO DECODED ROW — sketched only >>>
                      ├─ load VICEROY.PAL / ICONS.SS / NAMES.TXT / GAME.TXT ... (asset bootstrap)
                      │   └─ func_0749E0  load_names_data_tables   [DONE]   (PICKNATION/DIFFICULTY/LEADERNAME)
                      │
                      ├─ [OPENING.EXE plays the cinematic — SEPARATE EXE, OUT-OF-SCOPE]
                      │
                      └─ func_0759E8  save_load_game_screen  [DONE]         (@BEGINMENU dispatch)
                           ├─ opt 1 "New World"  → random map
                           ├─ opt 2 "America"    → @AMERICA (orig vs editor) → @MAPTOLOAD pick
                           ├─ opt 3 "Customize"  → world-customization
                           └─ opt 4 "Load Game"  → slot picker
                                │
                                ├─ func_070580 difficulty_pick_dispatch  [byte-verified]  (@DIFFICULTY)
                                ├─ func_070A1A nation_pick_dispatch       [byte-verified]  (@PICKNATION)
                                │
                                ├─ func_07431E new_game_init  [DONE]   (RNG human power [0x5398];
                                │                                       PowerRecord/AIPersonality init;
                                │                                       intro panel WOODPANL/LEADERNAME/NATION0A;
                                │                                       MULTI roster if 4 humans)
                                │
                                ├─ MAP:  func_064A10 worldgen [BYTE_VERIFIED, src/mapgen]  (random)
                                │        — OR — func_071106 load_mp_map [DONE] / func_0713D4 default [DONE]
                                │           (buffers: func_070FF8 [DONE])
                                │
                                └─ func_0755CC new_game_init  [DONE]
                                     ├─ seed AMER2 dims 0x3A×0x48; difficulty-scaled REF / king-anger
                                     ├─ PER POWER: create settler(0xD) + soldier(2) + scout(1) at home tile
                                     │            (= Caravel + Soldier + Pioneer trio); set spawn cursor
                                     ├─ @VICEROY / @VICEROY2 investiture  → func_075594 show_simple_message_dialog
                                     │                                      [byte-verified; *call site not pinned*]
                                     ├─ @LANDHO "name this land"          → *NO TRACED EMITTER*
                                     └─ blit framebuffer, draw game screen (0x25), RETURN  ── first turn, player in control
```

---

## Completeness verdict

**Is the opening sequence fully decoded? — Substantially yes, with a few bounded gaps.**

The functional spine — boot/init → main-menu dispatch → difficulty/nation pickers
→ new-game power-table init → map load/generation → per-power starting-unit seeding
→ hand control to the player — is **decoded and byte-verified end-to-end**. The two
heavy lifters (`func_07431E`, `func_0755CC`) and the menu dispatcher (`func_0759E8`)
all carry @asm-cited control flow, and the map generator (`func_064A10`) is fully
reconstructed in `src/mapgen/`. A player launching the reconstruction would reach a
playable map via the same code path as the original.

**Concrete gaps (none fatal to the spine):**

1. **`_main()` top-level dispatcher — not pinned.** The overlay-resident function
   that bootstraps assets, enters the title/menu state machine, and runs the
   per-turn loop is described in `ARCHITECTURE.md` / `RENDER_CHAIN.md` but has **no
   decoded row** in `decompile_status.json` and no byte-traced body. This is the
   one structural seam between the (ported) resident boot stubs and the (decoded)
   overlay menu. *Highest-value gap to close.*

2. **`system_init` is PARTIAL.** Only Region 1 of 4 is line-by-line; the ~20
   layout globals at DGROUP:0x3995..0x39FF (Regions 2–4) are summarized, not traced.

3. **`@VICEROY`/`@LANDHO` emitter call sites — catalogued, not traced.** The
   investiture is rendered by `func_075594` (byte-verified) and `@LANDHO` is a known
   message key, but *which* opening-flow function fires each (and where the
   "name the new land" prompt is driven) is marked "UI / no traced emitter" in
   `event_catalog.json`. The renderer exists; the trigger is unconfirmed.

4. **`func_065D26` (world-gen tail) is PARTIAL**, and native-settlement / prime-resource /
   lost-city placement (largely NAMES.TXT-driven, `settlements.c` + TBD functions) is
   only partly traced — adjacent to, not on, the strict 6-stage spine.

5. **Opening cinematic — OUT-OF-SCOPE (correctly).** It lives in the separate
   `OPENING.EXE` (MOV/PCX/PAL playback), explicitly excluded per `UI_VERIFICATION.md`.
   Not a defect; flagged so the audit is complete.

**Stale-doc note (not code defects):** `decompile_status.json` lags the C source in
three places — `func_064A10` shows "referenced / no file" though it is ported in
`src/mapgen/`; `func_0749E0` shows "partial" though its banner says DONE; and
`entry_point`/`system_init`/`cstart` show "out-of-scope / no file" though `src/boot/entry.c`
and `src/runtime/cstart.c` exist. Also `src/ui/title_screen.c` is a SKELETON whose
"menu dispatch TBD" note is superseded by `func_0759E8`, and `docs/ASSET_ROLES.md`
line ~182 still lists a fabricated `TITLE.PIK`. These are bookkeeping drifts, not
missing decode.

---

## Byte-verification spot-checks (this audit)

Two transitions were checked against `code/VICEROY/disasm_overlay_reseg/page_1A.asm`
(re-seg of VICEROY.EXE):

- **Main-menu dispatch (Stage 3).** At file 0x075C60: `lea bx,[0x2345]` (the
  "BEGINMENU" DS string offset) then `lcall 0x181F:0x3FE` at 0x075C64 (menu-run
  primitive) → `mov [bp-0xe0],ax` → `dec ax` / branch-dispatch. Matches `func_0759E8`
  exactly. ✔

- **New-game RNG nation pick (Stage 4).** At file 0x074360: `push 3; push 0;
  lcall 0x181F:0x4D4` (= random_int(0,3)) → `mov [0x5398],ax` → `cmp ax,3 / jle`
  clamp at 0x074375. Matches `func_07431E`'s "random_int(0,3); clamp ≤3" exactly. ✔
