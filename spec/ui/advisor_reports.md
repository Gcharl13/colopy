# Advisor Reports (F1–F10)

> **Layer 2 — UI Specification.** Per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.
> Substantive: the dispatch ladder, the 9 real body offsets, the title-N→PIK/@MISC
> mapping, the F8 gate polarity, the F9 dispatch gate, the F10 score-band selector,
> the shared draw primitives, and every report's static x-columns + y-start are now
> **B** (raw-EXE-verified, byte-cited per step). The residual soft spots — the
> per-row y *flow* (a FONTTINY line-height accumulator, not a literal gap), the live
> counts/gold/prices, the runtime DGROUP icon-id cells, and the exact @MISC index per
> `[DS:0x2Dxx]` label slot — are honestly **R/TBD**, each called out with its source.

**Overall confidence:** dispatcher + body offsets + draw chain **B** (byte-cited);
per-report static layout immediates **B**; per-row flow y + live values **R**; a few
label-slot→@MISC bindings **TBD**. · **Canonical primary:**
`raw/COLONIZE/VICEROY.EXE`, `viceroy_source/docs/drawlist/REPORTS.md` (the complete
byte-cited draw list, RTLink-resolver-validated 2026-05-31), `viceroy_source/docs/SCREEN_LAYOUTS.md` §4.

> **Correction (2026-06-21, RULING):** the paint-function offsets formerly cited
> from `docs/ADVISOR_REPORTS_AUDIT.md` (`0x025F18`/`0x025A0A`/`0x0269D8`/`0x027010`/
> `0x0277D8`/`0x027B0C`/`0x027E48`/`0x025FD0`) are **broken-thunk artifacts** —
> `0x025F18` is mid-instruction garbage. The **real** report bodies live at
> `0x37xxx–0x3Axxx` (RTLink-resolved, `REPORTS.md` §1). The PIK→report table was also
> a visual guess; the true art is `REPORT<N>.PIK` with `N` = the report's title
> number. See `notes/rulings/RULINGS.md` 2026-06-21.

> **Citation note:** the previously-cited `docs/RENDERER_GEOMETRY.md` ("Naval Adviser
> Report v3") is **deleted** and is NOT cited here (per the project's deleted-doc rule).
> The Naval geometry it carried is now byte-verified independently in `REPORTS.md` §6
> (func_3954C), so the Naval table below upgrades **A→B**.

## 1. Purpose
The F-key advisor screens: ten full-screen reports reached from the **REPORTS** pulldown
or the F1–F10 hotkeys, each a single 320×200 (mode 13h) page composited over a
`REPORT<N>.PIK` background. Each report shows a title bar, a per-report body
(stack/row/column layout — **not** a generic grid), a footer rule, and an OK button.
They are read-only status screens (Religious, Continental Congress, Labor, Economic,
Colony, Naval, Foreign Affairs, Indian, plus the Terrain encyclopedia F1 and the
Colonization Score F10). **B** (`REPORTS.md` §1; `MENU_sections.json @REPORTS`).

## 2. Layout — "what is drawn where"

Native 320×200 (mode 13h). Every report opens with the **shared frame** (§2.1 of
`REPORTS.md`) then draws its own body. The shared regions are constant across all reports;
the body region varies per report (§4).

| Region | Pixel rect | Font | Color | Notes / cite |
|--------|-----------|------|-------|--------------|
| Background plate | (0, 0, 320, 200) | — | PIK palette | `REPORT<N>.PIK`, loaded by `func_037340` (§2.1). **B** |
| Title bar — fill | (0, 0, 320, 5) | — | `0x90`→(255,255,190) + per-report attr | `fill_rect` `0x181F:0x22` (`func_002462`); `push 0x90` @0x37970 (F2). **B** |
| Title bar — text | centered, y≈0 | FONTTINY | composited (PIK) | title template `0x11A2` + report-N → `@MISC` string, drawn by `0x191F:0xF4A` (`func_037340` @0x37340). **B** |
| Body | (0, ~10, 320, ~188) | FONTTINY | per-report (§4) | per-report row/column stack; bodies at `0x37xxx–0x3Axxx`. **B (layout) / R (flow y, live values)** |
| Footer rule | (0, 200, 320, 1) | — | full-width rule | `0x181F:0xE2` (`func_00DB3A`), `push 0xC8` (y=200). **B** |
| OK button | bottom (widget) | (widget) | (widget) | `0x181F:0x3C0` (`func_004A80`), label `@MISC 46` "OK". **B** |

**Tier note on body row pitch:** within a body the **per-row y advance is a FONTTINY
line-height flow accumulator** (`les bx,[DS:0x89E]; mov al,es:[bx]; add y,al(+2)`), a
font-derived value, **not** a literal gap (**R**). What **is** static (and byte-cited →
**B**) is each report's **x-columns + y-start** (§4). Live counts/gold/prices stay
game-state. (`REPORTS.md` §2.3; per-report §4.)

### 2.1 Shared draw chain (every report opens with this) — **B**

| Step | primitive | effect | cite |
|------|-----------|--------|------|
| set active player record | `0x181F:0x582` (`func_030550`) | arg→`[DS:0x9E12]`; `arg·0x13C+0x8808`→`[DS:0x84FC]` = ptr to active PowerRecord (stride 0x13C=316). NOT a draw. | @0x030550 |
| title-bar background | `push N; call 0x39E53`→`0x191F:0xF4A` (`func_037340`) | loads title template `0x11A2`, appends report-number `N` (`0x181F:0x182`), substitutes nation quartet `[DS:0x2DA8/2DAA/2DAC/2DAE]` (`0x181F:0x44E`), draws (`0x181F:0x484`). **Only** REPORT-PIK load site. | @0x037340 |
| title fill-rect | `push <color>; push <h>; push 0x140; push 0; push [DS:<attr>]; 0x181F:0x22` | `fill_rect(x=0,w=0x140,h,color)`; color `0x90`; `[DS:<attr>]` = per-report title attr | @0x002462 |
| footer rule | `push 0; push 0x140; push 0xC8; 0x181F:0xE2` (`func_00DB3A`) | full-width horizontal rule, w=0x140, y=0xC8 (200) | @0x00DB3A |
| OK button | `0x181F:0x3C0` (`func_004A80`) | OK widget (`@MISC 46` "OK") | @0x004A80 |

**Report-number N → title (`@MISC` field, all confirmed present in `LABELS_sections.json @MISC`):**
N=1→`@MISC 79` 'Terrain' (F1 header); N=2→`@MISC 30` 'RELIGIOUS ADVISER REPORT';
N=3→`@MISC 37` 'CONTINENTAL CONGRESS ACTIVITIES'; N=4→`@MISC 49` 'LABOR ADVISER REPORT';
N=5→`@MISC 50` 'ECONOMIC ADVISER REPORT'; N=7→`@MISC 51` 'COLONY ADVISER REPORT';
F7→`@MISC 52` 'NAVAL ADVISER REPORT' (via 0x39E3F→`0x191F:0xF12`); N=8→`@MISC 93`
'FOREIGN AFFAIRS REPORT'; F9→`@MISC 29` 'INDIAN ADVISER REPORT'; F10→`@MISC 114`
'COLONIZATION SCORE'. (N byte-verified: F1=1@0x37450, F2=2@0x37967, F3=3@0x37A20,
F4=4@0x38429, F5=5@0x38A60, F6=7@0x39403, F8=8@0x398AF.) **B.**

### 2.2 Shared draw / text-composition primitives (`0x181F:` library) — **B**

The bodies build text into a stack buffer then draw it via these resident primitives.
Roles byte-verified from usage + prologue (`REPORTS.md` §2.2):

| `0x181F:` | resident @file | role |
|-----------|----------------|------|
| 0x16E | 0x02992 | strcat (append string to buffer) |
| 0x182 | 0x029DE | append number (base 10) |
| 0x114 | 0x02AC6 | measure/justify (F1 right-align) |
| 0x13C | 0x02B38 | **draw text at explicit (x,y) color** (`push color;y;x;ss;&buf`) — LEFT-aligned |
| 0x100 | 0x02BC8 | **draw text in box** (CENTERED) / blit composed band |
| 0x22  | 0x02462 | fill_rect |
| 0xE2  | 0x0DB3A | horizontal rule, full width |
| 0x222 | 0x033F2 | **ENQUEUE** sprite (ax=sprite idx, dx=value/count, bx=color) at row counter `[0x2CE0]++` — no draw, builds a row accumulator |
| 0x22C | 0x03104 | **FLUSH the row** — lay out `value` copies of each enqueued sprite left-to-right + blit (a ROW OF SPRITES, not a fill bar). Stack: push 4; ax=X-col, dx=Y-row, bx=span (=0x12C) |
| 0x236 | 0x02EE4 | **segment-sprite gauge** (`func_002EE4`): tiles a FILLED sprite (ax) across span, then EMPTY sprite **0x38** (hardcoded @0x02FA5) past the value threshold; CENTERED. Stack: `[bp+0x10]`=X-start (advances), `[bp+0xe]`=Y-baseline, `[bp+0xc]`=span. **Not a filled bar, not a color.** |
| 0x2BC | 0x03E40 | ship/colony status **SPRITE** (`func_003E40`) — condition icon from a table record |
| 0x254 | 0x0E76A | **blit one sprite** (`func_00E76A`) — sheet `[0x840]/[0x83E]`, ax=sprite idx |
| 0x484 | 0x0DCD4 | draw composited title string |
| 0x44E | 0x76B9E | string-substitution/format engine (nation %s) |
| 0x3C0 | 0x04A80 | OK button widget |
| 0x652 | 0x6F5F2 | "report not available" message (`[DS:0x87C]`) — F8 gate |
| 0x7B4 | 0x0BC10 | has-Founding-Father(idx)→0/1 (F3, F8) |

- **`0x191F:0x8BC`** (thunk @0x1BEAC) = `func_00DFCC`, a **horizontal color-run /
  line-fill** (`MOV es:[di],al; INC di; LOOPNE` over cx bytes with `al`=fill color;
  `RETF 0xa`) — **NOT** a bordered cell and **NOT** a box. F4/F5/F8 use it for
  header/separator **lines**: F4 sep @0x3887D x-start `ax=2`, **x-end `dx=0x137`=311**,
  y `bx=row·8+0x2A`, **color `push 0x77`** @0x3886F; F8 sep @0x39908 x-start `ax=0`,
  **x-end `dx=0x13F`=319**, color `push 0x77`. **`0x77`→(134,0,0) dark-red** (resolved
  via REPORT4/REPORT8.PIK `#860000`) — a solid dark-red horizontal rule. (RULING
  2026-06-21; the earlier "16-bit color-run, TBD" guess was wrong.) **B.**
- F6's `0x8BC` @0x39372 is a **different** thunk (→0x0427:0x0D38, a production-quantity
  helper), NOT the line-fill. **B.**

### 2.3 Fonts & colors — **B** (resolved 2026-06-21)

- **Font:** every report **body (F1–F9) uses FONTTINY** — each reads the `[DS:0x89E]`
  (FONTTINY) descriptor for char-height / row pitch, with no second-font switch. **F10
  score** also reads `[DS:0x268A]` (`@0x3B054`/`0x3B0E6`) for the big-figure glyph
  metrics — and **`[0x268A]` is FONTINTR.FF, not FONTKING**: loaded from string
  `fontintr`@0x2389 at 0x760CB (byte-verified). So F10 = FONTTINY labels + FONTINTR
  figures; **no report uses FONTKING** (the `FONTKING` string loads only in the
  king-defeats screen). **B.**
- **Colors** resolve via the shared **REPORT\*.PIK palette** (identical across
  REPORT2/3/4/5/7/8/9 for every cited index) → exact RGB (B): `0x0F`→(255,255,255)
  white; **title fill `0x90`**→(255,255,190); `0x91`→(255,255,142); `0x92`→(255,243,93);
  `0x61`→(247,243,199) cream; `0x77`→(134,0,0) dark-red. Byte-cited pushes: title
  `push 0x90 @0x37970`, F2 `push 0x0F @0x379D9`, F3 FF-grid `push 0x61 @0x37FF7`, F6
  name `push 0x92 @0x39335`, F8 `push 0x91 @0x39973`.
- **Sprite indices, NOT colors (RULING 2026-06-21):** `0x39/0x38/0x3F/0x7C/0x7D` are
  **ICONS.SS sprite indices** — discrete filled/empty indicator sprites (crosses/bells,
  one per count) and the rebel/tory tiled-strip sprites, **not** text colors and **not**
  a continuous fill bar (the game has no fill bars). F2 crosses filled **0x39** / empty
  **0x38**; F3 bells filled **0x3F** / empty **0x38**; rebel **0x7C** / tory **0x7D**.
  (Port mapping: VICEROY runtime idx − 1 = ICONS png idx; `REPORTS.md` §A/B.)

> **Shared UI widgets used by the reports (recognise once — `viceroy_source/docs/UI_PRIMITIVES.md`
> §0a).** The report bodies do **not** invent per-report bars/rows; they call the engine's
> shared widget verbs:
> - **`0x181F:0x236`** = the **proportional filled/empty icon strip** → **F2** crosses
>   (`@0x0379B4`, filled `0x39`) and **F3** bells (`@0x037BF5`, filled `0x3F`). Same verb as
>   the colony field-production yields — pitch `(span−w)/(count−1)` clamped `[1,w+1]`, *not* a
>   fill bar.
> - **`0x181F:0x2BC`** = the **per-unit info panel** → **F6** Colony (`@0x039297`) and **F7**
>   Naval (`@0x039586`); same verb as Europe ship rows and colony panels.
> - **`0x181F:0x22C`** = the **centred icon+value+colour row flush** → **F3** rebel/tory + REF +
>   FF-list rows (`@0x037D68/0x037E6D/0x037F4F`); same verb as the colony bottom panels.
>
> So a report "count strip", "unit panel", or "centred row" is the shared verb — cite it, do
> not re-derive. (The recurring `0x39`/`0x3F`/`0x7C`/`0x7D`/etc are the **filled-segment sprite
> ids** handed to `0x236`/`0x22C`; only empty `0x38` is constant.)

## 3. Dispatch ladder (F1–F10 → body) — **B**

The in-game key handler is a `switch ([bp+6])` (keypress code); the F-key report ladder
lives at **@0x023843..0x02390B**. Each F-key compares `[bp+6]` against a report-key code
and dispatches `lcall 0x191F:0x3xx` into overlay page 5 (code base file 0x37340).
RTLink-resolved (`REPORTS.md` §1):

| F-key | report | key code | dispatch site | thunk `0x191F:` | **BODY @file** | prologue |
|-------|--------|----------|---------------|-----------------|----------------|----------|
| F1 | Terrain Information | 0x48 | @0x023849 | 0x41A | **0x3744A** | `enter 0x6E` |
| F2 | Religious Adviser | 0x41 | @0x02385A | 0x40C | **0x37958** | `enter 0x2C` |
| F3 | Continental Congress | 0x42 | @0x02386E | 0x3FE | **0x37A10** | `enter 0x6E` |
| F4 | Labor Adviser | 0x43 | @0x02387F | 0x3F0 | **0x38418** | `enter 0x120` |
| F5 | Economic Adviser | 0x44 | @0x023890 | 0x3E2 | **0x38A50** | `enter 0x8C` |
| F6 | Colony Adviser | 0x45 | @0x0238A1 | 0x3D4 | **0x39218** | `enter 0x68` |
| F7 | Naval Adviser | 0x46 | @0x0238B2 | 0x3C6 | **0x3954C** | `enter 0x6A` |
| F8 | Foreign Affairs | 0x47 | @0x0238C3 | 0x3B8 | **0x39888** | `enter 0x72` |
| F9 | Indian Adviser | 0x49 | @0x0238E2 | 0x3AA | **0x39EE2** | `enter 0x7E` |
| F10 | Colonization Score | — | (score selector) | — | `func_03A9C0` **0x3A9C0** | — |

- All 9 advisor bodies land on clean ENTER prologues. **F9 is gated**:
  `test [DS:0x5383],0x20; je` @0x0238D1 — bit clear (natives discovered) → body draws
  (`push 1; lcall 0x191F:0x3AA`); bit set → a broken-thunk landing (do not draw). F9's
  thunk is the one nonzero-seg case (`ljmp_seg=0x2B1`). **B.**
- **F10** is not in the F-key ladder; it routes through the score path
  `func_03A9C0` @0x3A9C0 (§4, F10). The REPORTS menu lists it as `~F~1~0 Colonization
  Score` (`MENU_sections.json @REPORTS`). **B.**

## 4. Report-specific bodies (static layout byte-cited; flow y + live values R)

> All per-report **x-columns + y-start** below are re-disassembled against VICEROY.EXE
> (**B**). The **per-row y is a FONTTINY line-height flow accumulator** (`add y,[0x89E].h`)
> — computed, not a literal gap (**R**). Live counts/gold/prices/icon-ids stay game-state.

- **F1 Terrain Information** (`func_3744A`, retf @0x37957, N=1). Terrain encyclopedia:
  per terrain type — name (left) + this-nation unit/colony counts (right-justified
  `x=0x136−textW` via `0x181F:0x114`) + a terrain icon. Row loop start **y=0xA, x=0x19**
  (`[bp-0x5A]/[bp-0x5C]` @0x37479); row advance `y += 0x1E` then `+= font+2`
  (@0x37613). Terrain icon via `0x254`, **sprite = `[bp-0x54]+0x72`** (terrain-derived,
  **not** a literal), x+=3/y+=0x14 per (@0x378FA). Inputs: terrain record `[DS:0x8D4E]`,
  name table `[DS:0x962E]` stride 6, ColonyRecord `[DS:0x54EE]` stride 0x12.
  **B (layout) / R (counts live).**
- **F2 Religious** (`func_37958`, retf @0x37A0F, N=2 → `@MISC 30`). One **crosses gauge**
  (`0x236` sprite-strip): **X=0xA** (`[bp+0x10]` @0x37996), **Y=0x19** (`[bp+0xe]`
  @0x3799D), span **0x12C**, **FILLED sprite 0x39** (@0x379B1), EMPTY 0x38; value
  dx:bx = PowerRecord `+0x30`(hi)/`+0x2E`(lo). Optional "next immigrant" text (gated
  `[DS:0x5383]&0x20`): template `0x11A9`, drawn `0x13C` at x=0xA y=0x19 **color 0xF**
  (@0x379D9). **B (layout) / R (gauge value live).**
- **F3 Continental Congress** (`func_037A10`, retf @0x3807D, N=3 → `@MISC 37`) —
  validation-reference body, fully traced. Session line `@MISC 112` + bells-to-go.
  **Bell gauge** (`0x236`): X=`[bp-0x56]`=**4**, Y=running row, span **0x12C**, FILLED
  sprite **0x3F** (@0x37BEC), EMPTY 0x38 (@0x37BCE–0x37BF5). **Rebel/tory strip** (row of
  sprites, `0x222`×2→`0x22C`): rebel sprite **0x7C** ×rebel-count, tory **0x7D**
  ×tory-count, span 0x12C at x=4 (@0x37D43–0x37D68). **REF row** + **2nd-force row**
  (`0x222`×4→`0x22C`): icon=runtime DGROUP cells `[DS:0x5286/52A2/52CC/532E]` + counts
  `[DS:0x53DA/DC/E0/DE]`, label `@MISC 85` (@0x37E1C–0x37E6D). **FF grid**: idx 0..0x18,
  has-FF (`0x181F:0x7B4`) → name `[DS:0x9632+idx·6]` via `0x13C` **color 0x61** (push
  0x61 @0x37FF7) at cols **{4,82,160,238}** (start 4 @0x37A49, **step 0x4E** @0x3800C),
  4/row, Y-step font+2. **B (layout) / R (counts) / TBD (REF icon-id cells).**
- **F4 Labor** (`func_38418`, retf @0x38777, N=4 → `@MISC 49`). Occupation matrix —
  per occupation 0..0x1C: NAME via `0x13C` **color 0x92** at name x=**2** (`[bp-0x11c]+1`,
  @0x3889F), y-base **0x2A=42** (@0x388A4), row pitch **8** (@0x389C2); COUNT via `0x182`
  then `0x13C` **color 0x61** at x=label_x+0x27 (@0x38675). Profession column x =
  `di+0xC`/`di+0x27` (@0x3862F/@0x3866E, di computed → state). Header **horizontal line**
  via `0x191F:0x8BC` line-fill (x-end `0x137`=311, **color 0x77** dark-red) @0x3887D.
  Tally by NAMES `@JOB`. **B (grid) / R (counts).**
- **F5 Economic** (`func_38A50`, retf @0x38ED2, N=5 → `@MISC 50`). Treasury gold
  (PowerRecord `+0x2A`), tax (`+0x01`), per-commodity price_level (`+0x4C`)/vol_accum
  (`+0x5C`), "(Building Upkeep)"/"TOTAL UPKEEP". Header x = **76/170/220** at y=25
  (`push 0x4C @0x38AF6`, `mov ax,0xAA @0x38B63`, `mov ax,0xDC @0x38B90`); commodity table
  x=2 stride **0x11=17** (@0x38F3C/@0x3903F); value column x=250/150 stride 12
  (@0x38FEF/@0x3916C); y-start 25/33, pitch 8 (@0x38AEB/@0x38BE2/@0x38E33);
  right-aligned numerics = `anchor − strwidth` (`0x181F:0x204`, live). Column-separator
  **horizontal lines** via `0x191F:0x8BC`. **B (columns) / R (values).**
- **F6 Colony** (`func_39218`, retf @0x393F2, N=7 → `@MISC 51`). Per-colony rows (9/page):
  condition **sprite** (`0x2BC` @0x39297), colony icon (`0x2A8` @0x39330), colony NAME
  via `0x13C` **color 0x92** at x=`[bp-0x5a]+0x17`, y=`[bp-0x5e]+7` (@0x3934D),
  production-rate sprite-strip (`0x35C`→`0x2BC`). Base x=2 (@0x39227), base y=0x14=20,
  row pitch **+0x11=17** (@0x392A4), 9 rows/page (@0x392AB). 4 centered captions color
  `0x92` y=27 `(x,box)` = **(2,80)/(82,80)/(162,80)/(242,76)** (@0x3945C/@0x39480/
  @0x394AA/@0x394CE). ColonyRecord stride 0xCA @ base 0x5D60. **NOT bordered cells.**
  **B (layout) / R (field values).**
- **F7 Naval** (`func_3954C`, retf @0x39886, N=52 via 0x39E3F → `@MISC 52`) — fully
  decoded 4-column ruled table. Headers `@MISC 61–64` Ship/Cargo/Location/Destination
  (centered, title path). **Row grid (byte-verified):** first row **y=0x2A=42**
  (@0x39560), pitch **0x14=20** (@0x39796), **7 ships/page** (@0x3979D), base x=2 (@0x3955B).
  Columns: **Ship name** LEFT via `0x13C` color **0x61** at x=base+0x18=**26** (ship
  class 0xD–0x12; else +0x56→112) @0x39636; **Cargo** = sprite row (`0x254` cargo-good
  blits id=`0xC68` count=`0xBE6` + `0x2BC` condition sprite; empty=sprite 0x17, full-stack
  0x27) @0x39574; **Location** CENTERED via `0x100` box x=base+0xA0=**162** w=0x50=80
  color 0x61 @0x396AC; **Destination** CENTERED via `0x100` box x=base+0xF0=**242**
  w=0x4C=76 color 0x61 @0x3977F. Ship status icon via `0x191F:0xF82` (unit's own sprite).
  **Exactly ONE rule per page = footer y=0xC8** (no header/row/column rules). UnitRecord
  base 0x3144 stride 0x1C, class 0xD..0x12 filter; two passes (on-map, then at-sea/Europe).
  **B (full geometry + alignment) / R (rows live).**
- **F8 Foreign Affairs** (`func_39888`, retf inside @0x39E98 region, N=8 → `@MISC 93`).
  **Gate (byte-verified polarity):** `test [DS:0x5382],1; je 0x398A4` @0x39892 — bit0
  **CLEAR → JE taken → body draws** at 0x398A4; bit0 **SET → "FOREIGNNOTAVAIL"**
  (`push 1; push 0x11B6; lcall 0x181F:0x652`) + return. (Earlier "==0 → not available"
  was inverted.) 4-power diplomacy/strength table. Strength labels `@MISC` 95 Colonies
  / 96 Population / 97 Average Colony / 98 Military Power / 99 Naval Power / 100 Merchant
  Marine via `0x13C` **color 0x91** at label x=`[bp-0x5a]`=2; per-power values via `0x13C`
  color 0x91 LEFT at x=`[bp-0x5e]`=**0xD=13** / **0x50=80** / **0xA0=160** / 0xF0
  (@0x399C7/@0x39A13/@0x39B13). War/peace `@MISC 101/102`; recognition `[DS:0x2F38/2F36]`.
  Per-power column **horizontal lines** via `0x191F:0x8BC` (x-end `0x13F`=319, color 0x77).
  One cell color state-driven (`cmp [bp-0x70],1; …; +0xF` @0x39BE9). **B (gate + columns)
  / R (values) / TBD (the "View Whose Report?" picker — §6.1).**
- **F9 Indian** (`func_39EE2`, multi-page via paginator `func_039E98`, N=29 → `@MISC 29`).
  Per-tribe rows from NativeSettlement table **`[DS:0x54EC]` stride 18** (+0x02 owner,
  +0x04 pop, +0x05 mission flag); tribe names NAMES `@TRIBES`. Status/mission column
  x=**0x10=16** (@0x3A28A), then +0x48=72 (@0x3A307), +0x14=20 (@0x3A4A0); y-start
  **0x18=24** (@0x3A09A), 2nd block 0x96=150 (@0x3A3B0). Paginator: `[DS:0x2D0E]`
  x+=8 wrap 0x124, `[DS:0x2D10]` y. **Cell text color = the runtime global `[DS:0x830]`**
  (`mov al,[0x830]; push ax` @0x3A271) — i.e. the NAMES `@COLORS` "basic" slot (index 68 →
  (85,150,52) green via VICEROY.PAL; title uses `[0x831]` "hilite" 149 → (199,162,32)
  gold). This cross-confirms the minimap `@COLORS` decode in `map_view.md` §6.1.
  **B (layout + color) / R (per-tribe data).**
- **F10 Colonization Score** (`func_03A9C0` @0x3A9C0, title `@MISC 114`). Computes
  `scaled = value·(diff+4(+1≥3)(+1≥4))/100 >>1`, loops `i=1..24` choosing
  `panel = i-1` for the largest `i` with `i·i/3 ≥ scaled` (clamped 0..23), loads
  **`SCORE(panel+1).SS`** (one band plate, not a per-line map) over background
  **WOODPAN2** (string @0x11D7). Font = **FONTTINY** labels (`[0x89E]` @0x3ABF4) +
  **FONTINTR** big figures (`[0x268A]` @0x3B054) — **not** FONTKING. Body lines from
  `@MISC`: 115 Citizens / 116 Independence / 117 Villages Burned / 120 Foreign
  Recognition / 121 Total Score (+ FF list + Rebel Sentiment). **B (selector + assets)
  / R (live score figures).**

## 5. Assets & text
- **Backgrounds:** each report composites over **`REPORT<N>.PIK`** (N = the report's
  title number), loaded only by `func_037340` (@0x37340). F3 adds CCBKGD; F10 uses
  **WOODPAN2.PIK** + **`SCORE<panel+1>.SS`** band plate. The shared palette for color
  indices is the REPORT\*.PIK palette (identical across REPORT2/3/4/5/7/8/9). **B.**
- **Indicator sprites:** **ICONS.SS** — crosses filled 0x39/empty 0x38 (F2), bells
  filled 0x3F/empty 0x38 (F3), rebel 0x7C/tory 0x7D (F3); ship/cargo/condition sprites
  (F7); colony condition/production sprites (F6). Port png index = runtime idx − 1
  (`REPORTS.md` §A/B). **B.**
- **Titles** (all verified present in `LABELS_sections.json @MISC`): 29 'INDIAN ADVISER
  REPORT', 30 'RELIGIOUS ADVISER REPORT', 37 'CONTINENTAL CONGRESS ACTIVITIES', 49
  'LABOR ADVISER REPORT', 50 'ECONOMIC ADVISER REPORT', 51 'COLONY ADVISER REPORT', 52
  'NAVAL ADVISER REPORT', 93 'FOREIGN AFFAIRS REPORT', 114 'COLONIZATION SCORE', 79
  'Terrain'. **B.**
- **Body labels** (verified present in `LABELS_sections.json @MISC`): 46 'OK', 85
  'Expeditionary Force', 89 'Founding Fathers', 95 'Colonies', 96 'Population', 97
  'Average Colony', 98 'Military Power', 99 'Naval Power', 100 'Merchant Marine', 101
  'War', 102 'Peace', 105 '+ More +', 112 'Next Continental Congress Session', 115
  'Citizens', 116 'Independence', 117 'Villages Burned', 120 'Foreign Recognition', 121
  'Total Score', 186 'Move Cost'. **B.**
- **NAMES tables** (verified present in `NAMES_sections.json`): F4 occupations `@JOB`;
  F9 tribes `@TRIBES`; F9/title text-color slots `@COLORS` (`68, 149, 8, …` — same nine
  bytes as the minimap decode, `map_view.md` §6.1). **B.**
- **Note:** the per-slot binding of the runtime label pointers `[DS:0x2DE0..0x2F5C]` to
  exact `@MISC` indices is **TBD** for some F4/F5/F6/F8 section labels — the report-label
  loader is not yet identified (`REPORTS.md` §13.1). Titles + F3/F7 column/REF labels are
  unambiguous. **TBD (some section-label slots).**

## 6. Interactions
- **Hotkeys / REPORTS pulldown** (verified `MENU_sections.json @REPORTS`): F1 Terrain
  Information, F2 Religious Adviser, F3 Continental Congress, F4 Labor Adviser, F5
  Economic Adviser, F6 Colony Adviser, F7 Naval Adviser, F8 Foreign Affairs Advisor,
  F9 Indian Adviser, F10 Colonization Score. Each menu item routes through the dispatch
  ladder §3 (key codes 0x41–0x49 for F1–F9). **B.**
- **OK button** (`0x181F:0x3C0`, `@MISC 46`) and **ESC** dismiss the report → back to
  the map view. **B.**
- **F8 nested "View Whose Report?" power-picker** — runs in the command/menu dispatcher
  `func_0235D6` block @0x23810 (§6.1), not in the F8 body. **B (picker located) / R
  (the exact per-key copy handler).**
- **F7 / F9 paging:** multi-page reports show a `@MISC 105` "+ More +" pager
  (F3 @0x38073 via `0x191F:0xF74`; F9 via `func_039E98`). **B.**
- **F4 click-hit-scan** for selectable colony cells (`0x181F:0x3CA` @0x386EE region). **B.**

## 7. Evidence
- `raw/COLONIZE/VICEROY.EXE` (16-bit, RTLink-resolved this pass): dispatcher @0x023843;
  bodies F1 0x3744A / F2 0x37958 / F3 0x37A10 / F4 0x38418 / F5 0x38A50 / F6 0x39218 /
  F7 0x3954C / F8 0x39888 / F9 0x39EE2 / F10 `func_03A9C0` 0x3A9C0; loader `func_037340`
  @0x37340; strings REPORT@0x11A2, SCORE-plate, WOODPAN2@0x11D7. **B.**
- `viceroy_source/docs/drawlist/REPORTS.md` — the complete byte-cited draw list for all
  9 advisor bodies (RTLink `validate` → ALL PASS 2026-05-31); supersedes the disproven
  `docs/ADVISOR_REPORTS_AUDIT.md` offsets. **B.**
- `viceroy_source/docs/SCREEN_LAYOUTS.md` §4 — dispatcher `func_0235D6`, the [V]-cited
  report-frame note (the 12-cell grid `func_06FF94` is the **selectable grid screen, NOT**
  the F-key advisor bodies). **B.**
- `data_extracted/text/{LABELS,MENU,NAMES}_sections.json` — `@MISC` titles/body labels,
  `@REPORTS` hotkeys, `@JOB`/`@TRIBES`/`@COLORS` (all keys grep-verified present). **B.**
- *(NOT cited: deleted `docs/RENDERER_GEOMETRY.md` / `docs/RENDER_CHAIN.md`. The Naval
  geometry they carried is now independently byte-cited in `REPORTS.md` §6.)*

## 8. Open questions
1. ✅ **F8 "View Whose Report?" nested power-picker — RESOLVED 2026-06-21 (B).** The
   picker is in the command/menu dispatcher `func_0235D6`, block @0x23810: it seeds the
   default from the viewed-power global `[DS:0x5396]`, runs the generic TXT-menu builder
   (`lcall 0x181F:0x998`, section "SETREPORT" / file "DEBUG"), and `dec ax` maps the
   1-based result to power 0..3 (English/French/Spanish/Dutch); the SETVIEW handler
   @0x23D52 commits to `[DS:0x5398]/0x5394/0x5396`. The F8 body reads focus flag
   `[DS:0x53A2]` (0 ⇒ 4-power table, else single-power branch @0x39B27 indexed by
   `[DS:0x53D2]`). **B.** (Only the exact per-key sub-handler copying
   `[0x5396]→[0x53A2]/[0x53D2]` is a minor **R**.)
2. ✅ **Per-report intra-row static (x,y) — RESOLVED 2026-06-21 (B for the static
   immediates).** Every report's **x-columns + y-start** are now byte-cited (§4): F4
   grid (x=2, y=42, pitch 8), F6 (4 centered captions x=2/82/162/242, y=27; rows pitch
   17), F7 (full 4-col table, y=42 pitch 20, 7/page), F2/F5/F8/F9 x-columns + y-starts.
   The **per-row y is a FONTTINY line-height flow accumulator** (`add y,[0x89E].h`) and
   F9's text color is the runtime `[0x830]` `@COLORS` slot — both computed/state, not
   layout gaps (**R**). Font (FONTTINY) + colors resolved (§2.3). **B (static) / R (flow).**
3. **`@MISC` title-label loader — partially open (TBD for some section labels).** Each
   `[DS:0x2Dxx]` slot is filled in bulk at game-text load by a LABELS.TXT section loader
   (NOT `func_0749E0`, which is the NAMES.TXT name-table loader and stops at DS:0x2DB0 —
   `viceroy_source/docs/NAMES_LOADER.md`). Report **titles** are unambiguous (template `0x11A2` index
   N → `@MISC 29/30/37/49/50/51/52/93`, all verified), and F3/F7 column/REF labels are
   pinned; the exact `@MISC` index for some **F4/F5/F6/F8 section-label slots** is
   best-effort until the loader is identified. **TBD** (`REPORTS.md` §13.1).
4. **F3 REF / 2nd-force icon-id cells `[DS:0x5286/52A2/52CC/532E]` (and 2nd-force
   `0x52B0/5294/…`) — runtime, not static.** The rows ARE sprite rows (`0x222`
   enqueue×4 → `0x22C` flush, byte-verified), but the numeric icon **indices** are read
   from these DGROUP cells at runtime (the current REF composition) and are **not**
   statically resolvable. The port's hardcoded 125/126/9/127 are **unverified** — pin via
   the icon-id loader or a runtime dump. **R/TBD** (`REPORTS.md` §13.5). (The static
   gauge/strip tiles ARE pinned: F2 0x39, F3 0x3F, both empty 0x38; rebel 0x7C, tory
   0x7D; F7 empty-cargo 0x17, full-stack 0x27.) **B (static tiles) / TBD (runtime cells).**
5. **Live per-row values** (counts, gold, prices, score figures, per-tribe relations)
   are game-state computed in each body's tally loop — structural, **R**, never a layout
   constant to fabricate.
