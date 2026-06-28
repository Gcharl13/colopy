# Context Menus & Action Dialogs

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers:
> **B** (`BYTE_VERIFIED` — func@offset / GAME-NAMES-LABELS-MENU.TXT key / recorded ruling),
> **A** (`ANCHOR_VERIFIED` — overlay/pixel-measured geometry), **R** (`RECONSTRUCTED` —
> single-frame / low-trust approximate), **TBD** (unknown — no evidence). Never invented.
>
> Substantive: every action dialog here is a **menu-LIST** rendered by the shared
> centered-dialog FRAME engine (`func_06C520`/`func_06D316`/`func_06C850`, §2) and run by the
> shared menu/dropdown engine (`func_06E3D0`, §3) over an `@`-directive section parsed by
> `func_06F0F4` (§3); the hovered/selected row is highlighted by the **1-px hollow outline**
> `0x181F:0xCE` — all **B** (`CHROME_AND_DISPATCH_INDEX.md` §B8/§B10, `UI_PRIMITIVES.md`). The
> per-dialog item text (`@`-keys), the native-action row gating (`func_04B308`), the build
> availability gate (`func_0B900`) and the `@BUILDING` CSV-column→record-field mapping (loader
> `func_0749E0`) are all **B**. Residual soft spots: the per-row pixel **y-pitch** inside a list
> (= **font byte0 + 3**: `les bx,[0x89E]; mov al,es:[bx]; add ax,3` @file 0x3AB3–0x3ABF, so
> FONTTINY H=6 ⇒ **9 px**, FONTINTR H=9 ⇒ **12 px**) and the OK/Cancel affordance, which is **not a
> sprite** — it is the inline FONTTINY text-row option list painted by the FRAME builder (the
> dialog/menu engine `func_06C520`/`func_06E3D0`/`func_06F0F4` issue **zero** button-sprite blits,
> per their resolved call lists); both shared with `menus.md`/`popups.md`. **B.**

**Overall confidence:** option-list item text **B** (`GAME`/`NAMES`/`LABELS`/`MENU` `_sections.json`,
grep-verified §4–§11); engine/dispatch **B** (`CHROME_AND_DISPATCH_INDEX.md` §B8/§B10,
`UI_PRIMITIVES.md`); per-section `@width`/`@x`/`@y`/`@default` **B** (read from `GAME.full.json`
`directives`); per-dialog **trigger function** **B**/**A** (`docs/UI_DIALOGS.md`,
`docs/POPUP_TEMPLATE_AUDIT.md`); per-row vertical pitch **B** (= latched font byte0 + 3, @file
0x3AB7 — FONTTINY 9 px / FONTINTR 12 px). · **Canonical primary:**
`viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` (§B8 dialog FRAME engine, §B10 menu
engine, draw-primitive thunk-semantics table), `viceroy_source/docs/UI_PRIMITIVES.md` (`0x181F:NNN`
draw-verb Rosetta), `data_extracted/text/{GAME,NAMES,LABELS,MENU}_sections.json` +
`GAME.full.json`/`NAMES.full.json` (`directives`), `docs/UI_DIALOGS.md`,
`docs/POPUP_TEMPLATE_AUDIT.md`, `spec/ui/popups.md`, `spec/ui/menus.md`. **Last updated:** 2026-06-23.

> **Corrections (2026-06-23):**
> (a) Made the **shared dialog+menu engine the byte-cited backbone** (§2/§3), modeled on
> `menus.md` §6/§11 — every per-dialog section now cites its item-text `@KEY` + dispatch against
> that engine instead of re-deriving geometry.
> (b) Re-grepped every `@KEY` against the JSON. **`@LIVE` is ABSENT** — the prior
> "`@LIVE`-related" citation is struck (the Live-Among outcome flows through `@LEARN*`/`@CHIEF*`,
> not a `@LIVE` section). The Native-village action-list speaker channel is `[0x1f5c]` per
> `popups.md`/`POPUP_TEMPLATE_AUDIT.md`.
> (c) Per-section `@width`/`@default` are now the **literal `directives` values** read from
> `GAME.full.json` (e.g. SUREDELETE `@width=190`, SMITEINDIANS/SMITEEUROPE `@width=220`,
> WANTSTUFF `@width=260`, ABANDON `@width=190 @default=2`, BUYME1 `@width=160 @default=1`).
> (d) `@CTITLE` body re-quoted verbatim from `LABELS_sections.json` (it carries `Pop:`/`Gold:`/
> `BUY`/`CHANGE`/`Select An Item To Build`/`(No Production)`/`(More)`/`Turns)`/
> `Select a Profession for`/`Tax:` — the build-menu AND the train-menu title strings live here).
> (e) **Zero** live citations to the deleted `docs/RENDERER_GEOMETRY.md` / `docs/RENDER_CHAIN.md` /
> `docs/UI_FONT_REFERENCE.md` (none were present; this file repoints geometry to the drawlist /
> UI_PRIMITIVES sources).

---

## 1. Overview — these dialogs are menu-LISTS over the shared engine

Every surface in this file (unit orders, trade-route setup, native-village actions, colony
build/abandon/rename, diplomacy, recruit/purchase/train, the colony construction menu) is a
**menu-list**: a `@`-named section whose body is a set of newline-separated rows, sized by the
shared centered-dialog FRAME engine (§2), parsed by the `@`-directive BUILD parser `func_06F0F4`
(§3), and **run + hit-tested** by the shared menu/dropdown engine `func_06E3D0` (§3), which
highlights the hovered row with a 1-px hollow rectangle outline (`0x181F:0xCE`).

There are **two textual flavors** of list, both consumed identically by the engine:

1. **Bare option-lists** — a section with **no `@width`/`@options` directive** whose body is just
   the rows (e.g. `GAME @UNITOPTIONS`, `@SHIPOPTIONS`, `@EUROPESHIPOPTIONS`, `@ARMOPTIONS`,
   `@TRADENAMES`). Confirmed: these carry **`directives={}`** in `GAME.full.json` — they flow
   through the engine's OPTIONS path with the default/centered geometry. **B.**
2. **Bodied dialogs with directives** — a section carrying literal `@width=NN` (and sometimes
   `@x`/`@y`/`@default`) plus an inline option list at the tail (e.g. `@ABANDON`, `@SUREDELETE`,
   `@SMITEINDIANS`, `@HAVETREATY`, `@REALLYBUY`, `@BUYME1`). The directive values are read from
   `GAME.full.json`'s per-section `directives` map. **B.**

This is the **same engine family** that draws the in-game pulldown dropdowns (`menus.md` §6/§11)
and the gameplay event popups (`popups.md`). The distinction is only the *content section* and the
*per-dialog handler* that pushes it; the geometry/run/highlight code is shared and byte-cited once
below. The map-screen pulldown bars themselves are the verbatim `MENU_sections.json` tables
(`menus.md` §6.5) and are distinct from these context popups.

---

## 2. Shared dialog FRAME engine — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B8)

Identical to `menus.md` §11 (do not duplicate-edit). Reproduced as the load-bearing constants:

- **Construction — `panel_construct` `func_06C520` @0x06C520 (page 0x17):** border `+0x46`=**3**
  (@0x06C5E9), inner inset `+0x48`=**2** (@0x06C5F5), default/min content width `+0x28`=**0x50 (80)**
  (@0x06C5A6), body-line count `+0x4A` (@0x06C68D), alloc `lcall 0x1A1F:0x356` (@0x06C56E). **B.**
- **Line builder — `func_06C850` + `func_06CCxx`:** per body/option line
  `line_w = text_px + sub_w + 0x0A (10)` (body margin **10px** @0x06CCE3); text width via
  `0x181F:0x204`. **B.**
- **Geometry finalize — `panel_finalize_geometry` `func_06D316` @0x06D316:**
  `content_w = max(80, longest_line_px+10, @width)` (@0x06D392);
  `box_h = line_count·2 + 3 (+ title rows + Σ option rows + 3)` (@0x06D363 / @0x06D606 / @0x06D61D);
  `X = (@x==-1)?(320-box_w)/2:@x` (@0x06D522); `Y = (@y==-1)?(200-box_h)/2:@y` (@0x06D53B);
  clamp-shift if `X+box_w>0x140` / `Y+box_h>0xC8` (@0x06D563 / @0x06D571). `@width` keyword string
  "WIDTH\0" @file 0x1F989 is a **floor**, not a clamp. **B.**
- **Frame blit:** `lcall 0x181F:0x510` (WOODFRAM whole-sprite frame) @site 0x0263D6, consts
  (0x50,0x50,8,0xC8,0,0). **Body font = FONTTINY** (`[0x89E]` engine default) for the action
  dialogs/popups; **FONTINTR** for the in-game dropdown rows (dialog ctx `[0x268A]`). **B.**
- **OK/Cancel / confirm buttons** = FONTTINY **text rows** (the inline option list), NOT sprites;
  the modal "wait for OK / keypress" loop is `0x181F:0x3C0` (`func_004A80`) which **draws nothing**
  (the box + rows are painted by the builder first). The OK button SS art index is **TBD**. **B /
  TBD (art idx)**.

### 2.1 Resident draw-verb library used by these dialogs — **B** (`UI_PRIMITIVES.md`)

| `0x181F:` | func @file | role in these dialogs |
|-----------|-----------|------------------------|
| 0x0CE | `func_00E0A2` @0xE0A2 | min/order-2 clamp → drives the **row-highlight 1-px hollow rectangle outline** (h-span `0xBBC:0xC` + v-span `0xBC3:6`); color = per-row palette byte |
| 0x100 | `func_002BC8` @0x2BC8 | **center-text-in-box** (title/centered rows) |
| 0x114 | `func_002AC6` @0x2AC6 | measure string width |
| 0x13C | `func_002B38` @0x2B38 | draw text at explicit (x,y), left-aligned |
| 0x16E | `func_002992` @0x2992 | strcat into shared buffer (builds composite rows) |
| 0x182 | `func_0029DE` @0x29DE | append number (e.g. costs into a row) |
| 0x510 | (WOODFRAM frame painter) | whole-sprite dialog frame blit (§2 frame blit) |
| 0x3C0 | `func_004A80` @0x4A80 | modal wait-for-OK/keypress loop — **draws nothing** |

> The row highlight `0x181F:0xCE` resolves (CHROME §"Draw-primitive thunk semantics") to
> `func_00E0A2`-clamped → a **1-px hollow rectangle outline** drawn via the h-span/v-span helpers,
> color = the per-row palette byte. There is **no** filled selection bar. **B.**

---

## 3. Shared menu / `@`-directive engine — **B** (`CHROME_AND_DISPATCH_INDEX.md` §B10, `popups.md` §Overview)

- **BUILD / `@`-directive parser — `func_06F0F4` @0x06F0F4 (page 0x17):** reached via
  `0x191F:0x182`; `@`-key check `cmp byte [bx],0x40` @0x6F193. The directive table @file 0x1F967
  holds **11 strings**, of which `func_06F0F4` compares **10 live directives** —
  `OPTIONS / PROMPT / TEXT / SMALLFONT / Y / X / WIDTH / LENGTH / CHECKBOX / DEFAULT` — with
  `TEXTCOLR` a **vestigial 11th** (never compared). Handler offsets: `OPTIONS` marks an option-list
  section; `TEXT`→`[bp-4]=1` (0x6F1D8); `SMALLFONT`→copies the **latched** font `[0x89E]/[0x8A0]`
  (0x6F207, does **not** load FONTSMAL — RULING 2026-06-21); `X`→+0xC (0x6F266); `Y`→+0xE
  (0x6F21E); `WIDTH`→atoi (0x6F2B0); `LENGTH`→`[0xA5B6]` (0x6F302); `CHECKBOX`→`or es:[bx+0xA],5`
  (0x6F350); `DEFAULT`→**highlighted-row index** (0x6F374, NOT a color). **B** (`popups.md`
  §Overview). A section whose body opens with a bare numeric count (e.g. `@TRADENAMES` =
  "5\nRun\nFerry\nCargo\nTransport\nTriangle") is consumed as a 5-item menu list. **B.**
- **RUN + hit-test — `func_06E3D0` @0x06E3D0 (page 0x17):** reached via `0x191F:0x16A`; reads mode
  `[0x1F54]`/`[0x1F5C]`. It opens/runs the list, highlights the hovered row with `0x181F:0xCE`
  (§2.1), and returns the chosen 1-based index. Sized by `func_06D316`/`func_06C520` (§2). **B.**
- **Body color:** rows white `0x0F` over the WOODPANL/WOODFRAM panel; `TEXTCOLR` being vestigial,
  there is **no per-dialog text-color override** (`popups.md` §6). Body text color = **A**
  (glyph-engine mapping; observed light/white).

The per-dialog handlers below each **push their `@KEY` section and run this same engine**; only the
section content and the gameplay predicates (row gating, build availability) differ.

---

## 4. Unit jobs / orders menu — **B (lists)**

- **Purpose:** issue movement/work orders to the selected unit.
- **Option lists (B, grep-verified):**
  - `GAME @UNITOPTIONS` = "Move to front.\nClear orders.\nSentry / Board ship.\nFortify.\nNo
    changes." (`directives={}` — bare list). **B.**
  - `GAME @SHIPOPTIONS` = "Move to front.\nClear orders.\nSentry.\nAnchor in harbor (\"Fortify\").\n
    Unload all cargo.\nNo changes." (`directives={}`). **B.**
  - `GAME @EUROPESHIPOPTIONS` = "Move to front.\nSet sail for the New World.\nUnload all cargo.\nNo
    changes." (`directives={}`). **B.**
  - `GAME @ARMOPTIONS` = "Don't get on next ship.\nBoard next ship.\nMove to front of dock.\nArm
    with {Muskets} (costs {%NUMBER0$}).\nSell {Muskets} …\nEquip with {Tools} …" (Muskets/Tools/
    Horses/Missionary toggles; `directives={}`). **B.**
- **Short-code order table (B):** `NAMES @ORDERS` = "No Orders,-/Sentry,S/Trade Route,T/Go To,G/
  Live In Village,L/Fortify,F/Fortified,F/Build Colony,B/…" (label + hotkey columns). **B.** The
  in-game `~ORDERS` pulldown bar is `MENU @ORDERS` (`menus.md` §6.5). **B.**
- **Trigger:** the unit-orders popup sets the advisor channel `[0x1f5e]` via **`func_021EDE`**
  (`docs/POPUP_TEMPLATE_AUDIT.md` row @0x021EF7). **A.**
- **Render/run:** sized by §2, run by §3 (`func_06E3D0`); hovered row = `0x181F:0xCE` outline. **B.**
- **Tier:** list bodies **B**; trigger **A**; per-row pixel pitch **B** (font byte0 + 3 @file
  0x3AB7 — FONTTINY 9 px; §15.6).

---

## 5. Trade-route setup — **B**

- **Purpose:** create / edit / delete a trade route.
- **Lists & keys (B, grep-verified in `GAME_sections.json`):** `@TRADENAMES`
  ("5\nRun\nFerry\nCargo\nTransport\nTriangle", a 5-item list, `directives={}`); `@TRADESTART`
  ("Select destination number %NUMBER0 for route", `@width=190`); `@TRADETYPE` ("Is this a {sea}
  trade route or a {land} trade route?\n\nSea route\nLand route", `@width=190`); `@TRADENAME`
  ("Enter the name for this trade route.\n\nName:", `@width=190`); `@TRADESELECT` ("Select a trade
  route:", `@width=190`); `@TRADEDELETE` ("Which trade route should we {delete}:", `@width=190`);
  `@SUREDELETE` ("Are you sure you want to delete the {%STRING0}?\n\nYes\nNo", **`@width=190`**);
  `@CARGOLOAD`/`@CARGOUNLOAD` ("Select a cargo to load/unload at {%STRING0}.", **`@width=120`**);
  `@ROUTELOOP` (`@width=190`); `@TRADENONE` ("You have not yet defined any trade routes.",
  `@width=190`); `@TRADEMANY` ("Only {%NUMBER0} trade routes can be defined…", `@width=190`). **B.**
- **Editor labels (B):** `LABELS @ROUTE` = "EDIT TRADE ROUTE\nRoute Name:\nRoute Type:\nSea\nLand\n
  Destination\nUnload Cargo\nLoad Cargo\n(Delete Destination)". **B.**
- **Menu bar (B):** `MENU @TRADE` = "~TRADE / Edit Trade Route / Create Trade Route / Delete Trade
  Route". **B.**
- **Render/run:** §2/§3. **Tier:** **B.**

---

## 6. Native-village interaction (10 actions) — **B (list + per-row gating)**

- **Purpose:** the action menu when a unit enters a native settlement.
- **Action list (B, grep-verified `NAMES @ACTIONS`):** the 10 lines —
  "Trade With Village / Enter Hostile Village / Establish Mission / Denounce Heresy of %Fs Mission /
  Live Among The Natives / Ask to Speak With Chief / Incite Indians / Demand Tribute / Attack
  Village / Cancel Action". **B** (full body verbatim).
- **Outcome keys (B, grep-verified `GAME_sections.json`, all `@width=190` unless noted):**
  `@CHIEFHOWDY`/`@CHIEFGUIDES`/`@CHIEFAREA`/`@CHIEFGIFT`/`@CHIEFBORED`/`@CHIEFKILL` (chief
  responses); learn `@LEARNMASTER`/`@LEARNSTAY`/`@LEARNSLOW`/`@LEARNDONE` (Live-Among outcomes);
  mission `@MISSION0..3`. **B.**
  *(Correction 2026-06-23: there is **no `@LIVE` section** — the Live-Among-The-Natives row resolves
  to the `@LEARN*`/`@CHIEF*` outcome keys, not a `@LIVE` key. The prior "`@LIVE`-related" citation
  is struck.)*
- **Speaker channel & handlers (A):** the action menu's chief speaker uses `IND<tribe>` via channel
  `[0x1f5c]` (`popups.md` §Overview; `docs/POPUP_TEMPLATE_AUDIT.md`); the per-outcome bodies are
  routed by `func_04A7CA` (CHIEFKILL/raze) and the haggle/learn handlers in `docs/UI_DIALOGS.md`
  (`func_049600` haggle, `func_04A426` learning). **A.**
- **Per-row gating — `func_04B308` (`enter 0xba`) — B.** *(Correction: `0x74FC4` is the NAMES
  string-table loader, NOT the menu builder.)* `func_04B308` is the sole consumer of the `@ACTIONS`
  label array (DGROUP `0x932A`, +2/row). Inputs: UnitRecord base `0x3144` stride 0x1C (type@+0x02=`0x3146`; `@UNIT`
  codes 3=Missionary, 5=Scout); current village `[0x8D4A]`; tribe→player **alarm** via
  `func_0082A0`; row-add `lcall 0x191F:0x176` (arg 1/2 = enable). Each row's show/enable predicate
  (all **B**):
  - **r0 Trade / r1 Enter Hostile** (`@0x4B664`) — mutually exclusive on **alarm < 0x4B (75)**
    (`<75`→Trade, else Hostile).
  - **r2 Establish Mission** — unit type==3 AND village mission `[+5] < 0` (none present).
  - **r3 Denounce Heresy** — mission present (`[+5]≥0`) AND foreign owner (`[+5]&0xF ≠ self`).
  - **r4 Live Among** — player-relation ≥0 AND tribe-record `[+0x5236] < 2` AND not Scout.
  - **r5 Speak With Chief** — unit type==5 (Scout).
  - **r6 Incite / r7 Demand Tribute** — tribe-record `[+0x5236] ≠ 0` (tribute also excludes ships
    0xD–0x12).
  - **r8 Attack** — tribe-record `[+0x5236] > 1`. **r9 Cancel** — always.
- **Render/run:** the enabled rows are then sized by §2 and run by §3 (`func_06E3D0`, `0x181F:0xCE`
  highlight). **Tier:** action list **B**; per-row gating **B**; outcome keys **B**; trigger **A**.

---

## 7. Colonial-authority (build / abandon / rename) — **B**

- **Purpose:** found, abandon, or rename a colony.
- **Keys (B, grep-verified `GAME_sections.json`, with `directives`):**
  - build prompt `@COLONY` = "What shall we name this colony?\n\nName:" (`directives={}` — a
    text-entry prompt). **B.**
  - rename `@RENAMECOLONY` = "What shall we rename this colony?\n\nName:" (`directives={}`). **B.**
  - abandon `@ABANDON` = "Shall we indeed {abandon} our %STRING0 colony…\n\nYes, it is God's will.\n
    Never! That would be folly." (**`@width=190 @default=2`** — default-highlighted row 2 =
    "Never!"). `@ABANDON2` is the post-1600 variant (**`@width=190 @default=2`**). **B.**
  - site warnings (all `@width` per JSON): `@TOONEAR` (`190`), `@TOONEARBUILD` (`190`),
    `@TOOMOUNTAIN` (`190`), `@NOPORT` (`190`), `@SEACOLONY` (**`@width=140`**). **B.**
- **Build-order menu bar:** `MENU @ORDERS` "~Build Colony" (`menus.md` §6.5). **B.**
- **Render/run:** §2/§3; `@default=2` stores the highlight index via `func_06F0F4` handler @0x6F374
  (§3). **Tier:** **B.**

---

## 8. Diplomatic choices (war / peace / treaty / SMITE) — **B (keys)**

- **Purpose:** the diplomatic-action menu vs another European power (and the mercenary "SMITE"
  offers).
- **Option keys (B, grep-verified `GAME_sections.json`, with `directives`):**
  - `@CANCELPEACE` ("{%STRING0} cancel peace treaty with {%STRING1}.", `@width=190`); `@SIGNTREATY`
    (`@width=190`); `@DECLAREWAR` (`@width=190`).
  - `@HAVETREATY` = "\"We have signed a peace treaty with the {%STRING0}…\"\n\nCancel Action.\nBreak
    Treaty." (a 2-row inline option list, `@width=190`). **B.**
  - `@WHACKINDIANS` = "Shall we attack the {%STRING0}, Your Excellency?\n\nYes\nNo" (`@width=190`).
  - `@SMITEINDIANS` = "\"We shall ruthlessly smite the heathen {%STRING0}…\"\n\nPay {%NUMBER0$}.\n
    Never mind." (**`@width=220`**); `@SMITEEUROPE` (the heretic-European variant, **`@width=220`**);
    `@ALREADYSMITE` (**`@width=220`**); `@NOCONTACT` (**`@width=220`**).
  - demand/threat bodies: `@WANTSTUFF` (**`@width=260`**, full body present), `@THREATS`/`@GIFTS`/
    `@MILITARY`/`@PROVOKE`/`@WARMEEK`/`@WARMANLY`/`@PEACEMEEK`/`@PEACEMANLY` (all **`@width=220`**).
  - **B** (bodies + widths present in JSON).
- **Handlers (A):** diplomatic-actions menu `func_03ECF0`; SMITE `func_057F4E`
  (`docs/UI_DIALOGS.md`). **A.**
- **Render/run:** §2/§3. **Tier:** keys **B**; handlers **A**.

---

## 9. Recruitment — **B**

- **Purpose:** recruit a waiting immigrant from the docks (Europe).
- **Keys (B, grep-verified `GAME_sections.json`):** `@RECRUIT` ("The following individuals will
  accompany us… Whom shall we recruit?", `@width=190`); `@RECRUIT2` (`@width=190`); `@RECRUITCHOOSE`
  (**`@width=220`**); `@KINGRECRUIT` ("The {Royal University} can provide us with specialists…",
  `@width=190 @smallfont=true`). **B.**
- **Recruit-pool classes (B):** `NAMES @CLASS` = "Petty Criminals,300 / Indentured Servants,400 /
  Peasant Farmers,600 / Skilled Craftsmen,800 / Hardy Pioneers,1450 / Town Merchants,1500 / … /
  Educated Elite,2000" (name + cost columns). **B.**
- **Button label (B):** `LABELS @EUROLABEL` = "RECRUIT\nPURCHASE\nTRAIN\nx" → row 0 "RECRUIT". **B.**
- **Render/run:** §2/§3. **Tier:** keys **B**; pool-cost table **B**.

---

## 10. Purchase-unit — **B**

- **Purpose:** buy a unit/ship from Europe.
- **Keys (B, grep-verified `GAME_sections.json`):** `@PURCHASE` ("The following items are available.
  Which shall we purchase?", `@width=190`); `@REALLYBUY` ("Purchase %STRING0 for %NUMBER0$?\n\nYes\n
  No", **`@width=190`**); `@BUYME0` ("Cost to complete %STRING0: %NUMBER0$.\n^Treasury: %NUMBER1$.",
  **`@width=160`**); `@BUYME1` (same body + "\n\nNever mind.\nComplete it.", **`@width=160
  @default=1`** — default-highlight row 1 = "Complete it."); `@PICKACARGO` ("Which cargo shall we
  capture?", `@width=190`). **B.**
- **Button label (B):** `LABELS @EUROLABEL` row 1 "PURCHASE". **B.**
- **Unit catalog (B):** `NAMES @UNIT` = "Colonists,101,… / Soldiers,103,… / Pioneers,102,… /
  Caravel / Merchantman / Galleon / Artillery / …" (type code + stat columns). **B.**
- **Render/run:** §2/§3. **Tier:** keys **B**; unit table **B**.

---

## 11. Training / school — **B**

- **Purpose:** train a colonist into a specialist (schoolhouse / college / university).
- **Keys (B, grep-verified `GAME_sections.json`, all `@width=190`):** `@SCHOOL1` ("The {Schoolhouse}
  can support a faculty of only {one} teacher…"); `@COLLEGE2`; `@UNIV3`; `@NOTEACHER` ("Only
  colonists who have mastered a profession may teach."); `@NEEDCOLLEGE`; `@NEEDUNIVERSITY`;
  `@TRAINFAIL`; `@TRAINCRIMINAL`; `@TRAININDENTURED`; `@TRAINPROFESSION`; `@TEACHCONVERT` ("Indian
  converts already know the Indian ways."). **B.**
- **Profession list (B):** `NAMES @JOB` = "Farmer,Expert Farmers,1,1100 / Sugar Planter,Master
  Sugar Planters,2,-1 / Tobacco Planter,…,2,-1 / …" (name, master-name, skill tier, cost columns;
  reused by the colony-screen profession picker per CLAUDE.md). **B.**
- **Titles / button (B):** `LABELS @CTITLE` carries "Select a Profession for" (the train-menu title
  row — see §12 for the full `@CTITLE` body); `LABELS @EUROLABEL` row 2 "TRAIN". **B.**
- **Render/run:** §2/§3. **Tier:** keys **B**; profession table **B**.

---

## 12. Construction-choice (colony build menu) — **B (list + availability + record layout)**

- **Purpose:** pick what a colony builds next.
- **Labels (B, grep-verified `LABELS @CTITLE`, verbatim full body):** "Pop:\nGold:\nBUY\nCHANGE\n
  Select An Item To Build\n(No Production)\n(More)\nTurns)\nSelect a Profession for\nTax:". The
  build-menu title is row "Select An Item To Build"; "(No Production)"/"(More)"/"Turns)"/"BUY"/
  "CHANGE" are its in-menu labels (and "Select a Profession for" is the §11 train title — both menus
  share `@CTITLE`). **B.**
- **Building catalog (B):** `NAMES @BUILDING` = "Stockade,64,0,3,3,0 / Fort,120,10,3,3,10 /
  Fortress,320,20,3,8,15 / Armory,52,0,1,1,… / … / Iron Works" (columns
  `name, cost, tools(*10), size, min_colony, upkeep`). **B.**
- **Completion-buy confirm (B):** `GAME @BUYME1` ("Cost to complete %STRING0: %NUMBER0$…",
  `@width=160 @default=1`, §10). **B.**
- **Availability — `func_0B900` — B.** Build-menu fn **`func_02B4D2`** (title = `@CTITLE` "Select An
  Item To Build"), paginated, filters each slot via `func_0BB98` → predicate **`func_0B900`**
  (`[bp-0x12]=1` default-buildable). Gates:
  - **colony-size** (`@0xB940`: `min_colony[entry-0x7076] > colony_pop[+0x1F]` ⇒ not buildable);
  - **prereq-built** (entry+3 must be built; entry+2 built ⇒ superseded) via the built-bitmap;
  - **already-built / single-instance** tail (`@0xBB39`, per-building meta `[+0x3146]`);
  - plus a few index special-cases (terrain adjacency, colony flag `[+0x1C]&0x40`, per-nation
    capability).
  Built-bitmap **`func_0860E`**: `[colony·0xCA + 0x5DCA]` bit `idx&7` — **re-confirms CLAUDE.md
  hard rule #8 (ColonyRecord stride 0xCA)**. **B.**
- **Building-record layout — B.** Record stride **12 bytes** (`bx=idx·12`, three `shl;add;shl`
  chains @0xB93D/0xB953/0xB97A); the gate byte-reads prereq at **`[bx−0x707C]`** (`@0xB97D`) and
  supersede at **`[bx−0x707B]`** (`@0xB956`), each fed to is-built `func_0863E`; min-colony-size at
  **`[bx−0x7076]`** (`@0xB940`, vs `ColonyRecord+0x1F`). The table is in **BSS (DS:0x8F84),
  runtime-loaded from `NAMES @BUILDING`**. **B.**
- **CSV-column→record-field mapping — loader `func_0749E0` (`@file 0x749E0`) — B.** Its
  `for(i=0;i<0x2A;i++)` loop (**0x2A = 42 buildings**, stride `si=i·0xC`) reads the 6 `@BUILDING`
  columns — byte-verified legend **`name, cost, tools(*10), size, min_colony, upkeep`** — via
  `1A1F:0x0B22` (string token → u16) then `1A1F:0x088A` (integer token), into the record
  (base `0x8F82` = `[bx−0x707E]`):

  | CSV column | record field | offset | width | accessor |
  |-----------|--------------|--------|-------|----------|
  | `name` | name/string idx | +0 `[−0x707E]` | u16 | `0B22` |
  | `cost` | hammer cost | +10 `[−0x7074]` | u16 | `088A` |
  | `tools(*10)` | tools | +7 `[−0x7077]` | u8 | `088A` |
  | `size` | upgrade-chain category | +5 `[−0x7079]` | u8 | `088A` |
  | `min_colony` | min colony size | +8 `[−0x7076]` | u8 | `088A` |
  | `upkeep` | upkeep | +9 `[−0x7075]` | u8 | `088A` |

  Read order = CSV column order; read #5 lands at `[−0x7076]`, matching the build-gate's min-size
  field byte-for-byte. The **`size` column is the upgrade-chain id** (constant within a family:
  3=defense Stockade/Fort/Fortress, 1=armory, 4=docks, …). The **prereq `[−0x707C]` / supersede
  `[−0x707B]`** fields are **NOT** CSV columns — they are set separately by `func_07464C` (a
  hardcoded chain init, analogous to the Founding-Father chain
  `func_0746BC_init_founding_fathers_table`), so a building's predecessor/successor is engine-coded,
  not data-driven. **B.**
- **Render/run:** the buildable slots are sized by §2, paginated by `func_02B4D2`, and run by §3
  (`func_06E3D0`, `0x181F:0xCE` row highlight). **Tier:** building table **B**; availability
  predicate **B**; prereq/supersede source **B**; CSV-column→field map **B**.

---

## 13. Interactions

- **Open:** each context dialog is opened by its per-dialog handler (§4–§12), which pushes its
  `@KEY` section and runs the shared menu engine `func_06E3D0` (§3). **B.**
- **Hover/select:** the hovered row is highlighted by the 1-px hollow outline `0x181F:0xCE`
  (§2.1/§3); `@default=N` sections pre-highlight row N (handler @0x6F374). Selecting a row returns
  its 1-based index to the handler, which routes the outcome (e.g. `func_04A7CA` village,
  `func_03ECF0`/`func_057F4E` diplomacy, `func_02B4D2` build). **B (mechanism).**
- **Gating:** native-action rows are pre-filtered by `func_04B308` (§6); build-menu slots by
  `func_0B900` (§12) — disabled rows are not added to the list. **B.**
- **Dismiss:** confirm/OK rows are text rows in the inline option list; the modal wait is
  `0x181F:0x3C0` (`func_004A80`, draws nothing). ESC/Cancel resolves to the list's "No changes."/
  "Cancel Action."/"Never mind." row — itself a FONTTINY text row, **not a sprite** (no button SS
  art exists; the engine blits no button sprite). **B.**

---

## 14. Evidence

- `viceroy_source/docs/drawlist/CHROME_AND_DISPATCH_INDEX.md` — **primary**. §B8 shared dialog
  FRAME engine (`func_06C520`/`func_06D316`/`func_06C850`, WOODFRAM `0x181F:0x510`), §B10 in-game
  menu/dropdown engine (`func_072090` build, `func_06E3D0` run, `func_06F0F4` parse), and the
  Draw-primitive thunk-semantics table (`0x181F:0xCE` = 1-px hollow row-highlight outline). **B.**
- `viceroy_source/docs/UI_PRIMITIVES.md` — resident `0x181F:NNN` draw-verb Rosetta (font latch
  `[0x89E]` FONTTINY; center-text `0x100`, draw-at-xy `0x13C`, measure `0x114`, the `0xCE`
  outline-clamp, the modal wait `0x3C0`). **B.**
- `data_extracted/text/NAMES_sections.json` — `@ORDERS`, `@ACTIONS` (10 village actions), `@CLASS`,
  `@JOB`, `@UNIT`, `@BUILDING`, `@LEVELS`. **B** (all grep-verified present 2026-06-23).
- `data_extracted/text/GAME_sections.json` + `GAME.full.json` (`directives`) — `@UNITOPTIONS`,
  `@SHIPOPTIONS`, `@EUROPESHIPOPTIONS`, `@ARMOPTIONS`, `@TRADENAMES`/`@TRADE*`/`@SUREDELETE`/
  `@CARGOLOAD`/`@CARGOUNLOAD`/`@ROUTELOOP`, `@COLONY`/`@RENAMECOLONY`/`@ABANDON`/`@ABANDON2`/site
  warnings, diplomatic + recruit/purchase/train keys, `@BUYME0`/`@BUYME1`. Widths/defaults read
  from `directives`. **B.**
- `data_extracted/text/LABELS_sections.json` — `@ROUTE` (trade-route editor), `@CTITLE` (build +
  train titles), `@EUROLABEL` (RECRUIT/PURCHASE/TRAIN), `@INFO`. **B** (grep-verified).
- `data_extracted/text/MENU_sections.json` — `@ORDERS`, `@TRADE`, `@VIEW` in-game menu bars
  (`menus.md` §6.5). **B.**
- `docs/UI_DIALOGS.md` — trigger functions `func_03ECF0` (diplomatic menu), `func_057F4E` (SMITE),
  `func_04A7CA` (village), `func_049600` (haggle), `func_04A426` (learning). **A**.
- `docs/POPUP_TEMPLATE_AUDIT.md` — `func_021EDE` unit-orders advisor channel `[0x1f5e]` (@0x021EF7),
  `func_06F0F4` option-list framework. **A**.
- `spec/ui/popups.md` §Overview — `func_06F0F4` 10 live directives + handler offsets, speaker
  channels (`[0x1f5c]` etc.), `0x181F:0xCE` highlight. **B**.
- `spec/ui/menus.md` §6/§11 — the in-game pulldown family + shared dialog engine (cross-ref; same
  `func_06E3D0`/`func_06D316`/`func_06C520`). **B**.
- *(NOT cited — deleted in the 2026-06-22 cleanup: `docs/RENDERER_GEOMETRY.md`,
  `docs/RENDER_CHAIN.md`, `docs/UI_FONT_REFERENCE.md`. Any geometry they once carried is byte-cited
  from the drawlist / UI_PRIMITIVES sources above. Zero live references to those three docs.)*

---

## 15. Open questions (resolved-with-citation, or honest R/TBD)

1. ✅ **Option-list framework + run/highlight — RESOLVED (B).** Shared dialog FRAME engine §2
   (`func_06C520`/`func_06D316`/`func_06C850`), `@`-parser `func_06F0F4` §3, run/hit-test
   `func_06E3D0`, row highlight `0x181F:0xCE` (1-px hollow outline, per-row palette byte). The rect
   is `@width` + `@x`/`@y` (or centered), **static**, not cursor-dependent; the highlight palette
   index resolves to exact RGB via the loaded PIK palette (`fonts_and_colors.md`). No runtime. **B.**
2. ✅ **Per-section `@width`/`@x`/`@y`/`@default` — RESOLVED (B).** Read as the literal `directives`
   values from `GAME.full.json` (§4–§12): bare option-lists carry `directives={}`; bodied dialogs
   carry the cited widths (SUREDELETE 190, SMITEINDIANS/SMITEEUROPE/WANTSTUFF-adjacent 220, WANTSTUFF
   260, CARGOLOAD/UNLOAD 120, BUYME0/1 160, SEACOLONY 140, ABANDON 190) and defaults (ABANDON/
   ABANDON2 = 2, BUYME1 = 1). **B.**
3. ✅ **Native-action per-row gating — RESOLVED (B).** `func_04B308` per-row predicates (§6).
4. ✅ **Build availability + `@BUILDING` record layout + CSV-column→field map — RESOLVED (B).**
   `func_0B900` pop/prereq/already-built gates; 12-byte BSS record (DS:0x8F82) loaded by
   `func_0749E0`; prereq/supersede engine-coded by `func_07464C` (§12).
5. ✅ **`@LIVE` citation — CORRECTED.** No `@LIVE` section exists; Live-Among outcomes use
   `@LEARN*`/`@CHIEF*` (§6). Struck.
6. ✅ **Per-row vertical pitch (the y-step between list rows) — RESOLVED (B).** Byte-verified at
   file **0x3AB3–0x3ABF**: `les bx,[0x89E]; mov al,es:[bx]; sub ah,ah; add ax,3` — the per-row pitch
   is the **latched-font byte0 (glyph height) + 3**. With FONTTINY (`[0x89E]`, on-disk height byte = 6)
   ⇒ **9 px**; FONTINTR (dialog ctx `[0x268A]`, height 9) ⇒ **12 px**. `func_06D316` separately uses
   `line_count·2 + …` only for the box *height* allocation (§2); the per-row line-pitch is this
   font-byte0+3 value, not an unknown. (Same byte site backing `menus.md` §15.4 / `popups.md`.) **B.**
7. **OK/Cancel/confirm button SS art index — TBD.** The buttons are FONTTINY **text rows** (the
   inline option list), not sprites, so there is no button-sprite art; if a future capture shows a
   distinct sprite, its SS index is **TBD** (shared with `menus.md` §11). **B (text rows) / TBD
   (art idx)**.
8. **Per-row outcome command-id binding for the non-report dialogs — A/handler-level.** The chosen
   index routes through each dialog's handler (§4–§12 trigger fns); the exact index→game-action
   binding inside those handlers is documented at the handler level (`docs/UI_DIALOGS.md`) and is
   **A** for the diplomatic/village handlers (not re-byte-pinned per row here). **A.**
