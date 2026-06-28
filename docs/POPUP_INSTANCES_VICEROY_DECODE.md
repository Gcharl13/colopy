# POPUP INSTANCES — VICEROY.EXE byte-decode (the ~30 GAME.TXT event dialogs)

> **Deliverable B.** Per-instance decode of every GAME.TXT event popup that runs the
> **single shared centred-dialog FRAME engine**. For EACH instance: its `@KEY`(s)
> (grep-confirmed in `GAME_sections.json` this pass), its **speaker channel**
> (king / advisor / missionary / none, via `func_06BE92`/`BF12`/`BF3C`), its
> **special-sprite name** (built by NAME, not index), and any per-section
> `@x`/`@y`/`@width` directive (flagged **B-via-EXE / TBD-via-JSON** — see §1).
>
> **The shared geometry is NOT re-derived here** — the centred formula, FONTTINY
> body, white `0x0F`, frame blit `0x181F:0x510`, the 10 `@`-directives, and the 4
> speaker channels are byte-cited in `spec/ui/popups.md §2` and re-confirmed in
> `docs/MENUS_VICEROY_DECODE.md §8`. This doc focuses on **per-popup specifics**.
>
> **Tiers per `CLAUDE.md`:** **B** byte-verified (re-confirmed vs `raw/COLONIZE/VICEROY.EXE`
> this pass), **A** anchor-verified, **R** reconstructed, **TBD** + blocker.
> **Infra:** DGROUP base 0x1D9A0; speaker channels `[0x1F5C]` (king/tribe), `[0x1F5E]`
> (advisor), `[0x1F60]` (missionary); reset @0x06EE6B. **Last updated:** 2026-06-24.

---

## 1. Shared backbone (cited) + the per-popup `@x/@y/@width` flag

**There is no per-event painter.** Each of the ~30 popup-bearing GAME.TXT templates pushes
its `@KEY` and runs the shared engine (`popups.md §2`): construct `func_06C520`, line-build
`func_06C850`, finalize `func_06D316`, parse `@`-directives `func_06F0F4`, frame-blit
WOODFRAM `0x181F:0x510` @0x0263D6, body via `0x181F:0x998`, modal wait `0x181F:0x3C0`. Speaker
sprite dispatched by `func_06E3D0` @0x06E3D0 over the 4 channels (§2 below). All re-confirmed
this pass (see `MENUS_VICEROY_DECODE.md §8` for the finalize math spot-checks — all PASS).

**Per-section geometry directives (`@width`/`@x`/`@y`):** parsed by `func_06F0F4` (key check
`cmp byte [bx],0x40` @0x06F192 — re-confirmed; `WIDTH` handler @0x6F2B0, `X` @0x6F266, `Y`
@0x6F21E). The directive keyword table @file **0x1F967** was re-read this pass:
`OPTIONS·PROMPT·TEXT·SMALLFONT·Y·X·WIDTH·LENGTH·CHECKBOX·DEFAULT·…·TEXTC[OLR]` (11 strings, 10
live; `TEXTCOLR` vestigial — never compared). `@width` is a content-width **floor**; `@x/@y`
are literal origins (else `-1` → centred). **These literals are B via the EXE/raw GAME.TXT,
but the section extractor strips valueless `@`-directive lines, so they are NOT re-confirmable
from `*_sections.json`.** Every per-popup geometry note below is therefore tagged
**B-via-EXE / TBD-via-JSON**; only `@KINGTAX @width=190` is independently quoted
(`POPUP_TEMPLATE_AUDIT.md` raw read). **B (engine + KINGTAX) / TBD-via-JSON (per-section).**

---

## 2. The 4 speaker channels (cited, re-confirmed this pass) — **B**

| channel | global | builder | name built | template literal (re-read) |
|---------|--------|---------|-----------|----------------------------|
| king / tribe | `[0x1F5C]` | `func_06BE92` @0x06BE92 | `≤7` → `IND<n>A<pose>.SS`; `>7` → `KING<n>.SS` | `>7` pushes `[0x1F72]`="KING" (file 0x1F912); else `[0x1F77]`="IND0A0" (file 0x1F917) |
| advisor | `[0x1F5E]` | `func_06BF12` @0x06BF12 | `0..5` → `MSS0..MSS5.SS` | pushes `[0x1F7E]`="MSS0" (file 0x1F91E) |
| missionary | `[0x1F60]` | `func_06BF3C` @0x06BF3C | `0..3` → `MYR0..MYR3.SS` | pushes `[0x1F83]`="MYR0" (file 0x1F923) |
| (blitter) | — | `func_06BF66` @0x06BF66 | positions+blits the loaded sheet above the popup | — |

Re-confirmed: `func_06BE92` mode split `cmp [0x1f5c],7 / jle` @0x06BE96; name byte injected via
`add [bp-0x11],al` @0x06BEF5 (`al=[0x1f5c]`). `func_06BF12` reads `[0x1f5e]` @0x06BF25;
`func_06BF3C` reads `[0x1f60]` @0x06BF4F. Channel `<0` (0xFFFF) = no sprite. **All three
channels reset** at file **0x06EE6B** (`mov [0x1f5c],ax; mov [0x1f5e],ax; mov [0x1f60],ax`,
ax=0xFFFF after close — re-confirmed). Tribe order = NAMES `@TRIBES` (0=Inca…7=Tupi). **B.**

> **`KING2.SS` is byte-refuted** (zero GAME.TXT sections, zero string occurrences; only
> `"KING1"` @file 0x1FCB4). So king popups (`>7` branch) all resolve to **KING1.SS**. **B
> (negative).**

---

## 3. Per-instance table

> Speaker key: **K**=king `[0x1F5C]=8`→KING1.SS · **T**=tribe `[0x1F5C]=idx`→IND\<idx\>.SS ·
> **A**=advisor `[0x1F5E]`→MSS\<n\>.SS · **M**=missionary `[0x1F60]`→MYR\<n\>.SS · **—**=none.
> All `@KEY`s grep-confirmed present in `GAME_sections.json` this pass (159/159 checked;
> only `KING1`/`KING2` are sprite sheets, not sections). Geometry = centred unless noted;
> all per-section `@x/@y/@width` = **B-via-EXE / TBD-via-JSON** per §1.

### 3.1 King tax demand — **B**
- **Keys:** body `@KINGTAX` (*"…raise your tax rate by {%NUMBER0%%}…"* — confirmed); options
  `@TAXOPTIONS` (*"Kiss pinky ring." / "Hold '{%STRING3 Party}.'"*), `@TEAPARTY`; variants
  `@KINGRAISE`, `@KINGLOWER`, `@KINGNOTHING`, `@MERCANTILISM`, `@PURCHASETAX`; pretexts
  `@KINGNAVACT`, `@KINGSTAMPACT`, `@KINGWAR`, `@KINGWIFE`.
- **Speaker:** **K** — `[0x1F5C]=8` → KING1.SS via wrapper `func_06F5DA` (`mov [0x1f5c],8`
  @0x06F5DD — re-confirmed bytes `c7 06 5c 1f 08 00`). Multi-section: body `@KINGTAX` +
  option-list `@TAXOPTIONS` (recursive `func_06F0F4`).
- **Geometry:** `@KINGTAX @width=190` (quoted from raw GAME.TXT, `POPUP_TEMPLATE_AUDIT.md`);
  centred (no `@x/@y`). **B-via-EXE / TBD-via-JSON.**
- **Cross-ref:** tax math `func_034AE0`, threshold-60 `func_0349F4` (`spec/systems/king.md`).

### 3.2 Native village raze — **B keys / A trigger**
- **Keys:** `@CHIEFKILL` (taboo execution), `@INDIANGOLD` (raze reward), `@INDIANBURN`.
- **Speaker:** **T** — `IND<tribe>A<pose>.SS`, `[0x1F5C]=tribe_idx`. Razed woodcut `WDCUT12`.
- **Trigger:** raze handler `func_04A7CA` (CHIEFKILL, `docs/UI_DIALOGS.md`, **A**).

### 3.3 Native attitude — **B**
- **Keys:** `@VILLAGEHAPPY`, `@VILLAGEMEDIUM`, `@VILLAGESAVAGE`, `@VILLAGEBAD`, `@VILLAGEWAR`;
  ship/wagon anger `@MADATSHIPS`, `@MADATWAGONS`, `@DONTKNOWSHIPS`. Attitude word-list = NAMES
  `@ATTITUDE` (Content/Uneasy/Restless/Angry/War).
- **Speaker:** **T** — `IND<n>`. **Trigger:** `func_04B308` (**A**).

### 3.4 Native gift / haggle / trade — **B**
- **Keys:** `@BADHAGGLE0..3`; trade `@BUY0/@BUY1/@BUYWHICH`, `@TRADE0/@TRADE1`, `@BADCARGO`,
  `@NOTENOUGH`; gifts `@INDIANGIVEFOOD`, `@INDIANGIVESTUFF`, `@INDIANSCONVERT`, `@CHIEFGIFT`,
  `@CHIEFGUIDES`, `@CHIEFAREA`, `@CHIEFHOWDY`, `@CHIEFBORED`.
- **Speaker:** **T** — `IND<n>`; trade popups also set **A** channel `[0x1F5E]` (MSS2/3/4 via
  `func_034DD4` @0x034E5E/74/98). **Trigger:** `func_049600` (haggle), `func_0572E6` (gift).

### 3.5 Native raid / warpath — **B (raid count = 6, raw-verified)**
- **Raid block = exactly 6 contiguous keys** @file **0x1F52A** (re-read this pass:
  `RAIDWREAK·RAIDSTORES·RAIDBURN·RAIDSHIP·RAIDGOLD·RAIDNOTHING·` then `CONTINENTAL` — confirms
  no 7th): `@RAIDWREAK` (*"{%STRING0} raiding party wreaks havoc…"* — confirmed), `@RAIDSTORES`,
  `@RAIDBURN`, `@RAIDSHIP`, `@RAIDGOLD`, `@RAIDNOTHING`. Handler `func_05BE84` (enter 0x24
  @0x5BE84; uses `[0x8542]` colony anchor). **B.**
- **`@RAIDSCALP`** exists as a GAME.TXT section but is **NOT** in the 6-key block — an orphan /
  separate key, **not** a 7th raid outcome. **B (negative).**
- **Warpath:** `@INDIANWARPATH`, `@INDIANWARPATH2`, `@INDIANWARFARE`, `@INDIANWAR`,
  `@INDIANGRUDGE`, `@INDIANSURPRISE` (all carry the `@INDIAN` prefix — grep-confirmed). Handler
  `func_04B036` (sets `[0x1F5C]=tribe_owner`); war-dance woodcut `WDCUT13`.
- **Speaker:** **T** — `IND<n>`.

### 3.6 Lost City (10 variants) — **B (variant map resolved)**
- **Keys:** `@LOSTCITY0..@LOSTCITY9` (all present; `@LOSTCITY1` *"…{Fountain of Youth}!…"* —
  confirmed) + `@BURIAL1/2/3`, `@SCREWED`, `@VANISH`. Label "Lost City Rumor" = LABELS `@MISC`.
- **Speaker:** **—** (none) for most; FoY/survivors reuse `@LOSTCITY0` recruit prompt.
- **Handler:** `func_061454` (enter 0x3c @0x61454) builds `@LOSTCITY<n>` by appending outcome
  index `[bp-6]` (1–9) to template `[0x1DAE]`="LOSTCITY" (re-confirmed `push 0x1dae` @0x618C2)
  and shows via `0x181F:0x182` @0x618D9. Per-index side effects (re-confirmed sound 0x37 @0x618ED
  for FoY): **1** FoY (sound 0x37; →2 if `[0x5382]&1`); **2** Cibola (sound 0x3c); **3** ruins
  gold (`10·3d8` @0x61770); **4** burial anger (`or [bx+0x543e],0x40` @0x61877 → `@BURIAL1/2/3`
  + `@SCREWED`); **5** vanished (`@VANISH`, →6); **6** nothing; **7** larger treasure (`2·4d10`
  @0x617C0); **8** trespass; **9** survivors (spawn `0x191f:0xac8` @0x61809). **B.**

### 3.7 Combat result — **B**
- **Keys:** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`, `@CARGOCAPTURE`,
  `@WAGONCAPTURE`, `@SHIPDAMAGE`, `@ARTILLERY`, `@ARTILLERY2`, `@VETERAN`, `@VALOR`,
  `@WELLSEASONED`. Handler `func_05B2C2` (thunk 0x1CCD0; **A**). Battle woodcut `WDCUT10`.
- **Speaker:** **—** (combat outcomes are unattributed body popups).

### 3.8 Ship combat / landfall — **B**
- **Keys:** `@SHIPCOMBAT` (*"Only {Privateers} and {Frigates} can attack enemy ships."* —
  confirmed), `@SHIPLAKE`, `@SHIPDAMAGE`, `@SHIPSUNK`, `@LANDFALL` (*"Shall we make landfall…
  Stay With Ships / Make Landfall"* — confirmed, **inline options**), `@LANDFALL2`,
  `@LANDFIRST`, `@SAILHOME`, `@SHIPRUN`, `@SHIPSLOW`, `@FORTFIRE`, `@OVERBOARD`, `@EVASIVE`.
- **Speaker:** **—**. **Handler:** `func_03FDDE` (**A**). `@LANDFALL` stacks inline option rows.

### 3.9 Heresy denunciation — **B**
- **Keys:** `@HERESY0`, `@HERESY1`; mission keys `@MISSION0..@MISSION3`. Action label
  "Denounce Heresy of %Fs Mission" = NAMES `@ACTIONS`.
- **Speaker:** **M** — `[0x1F60]` → `MYR<n>.SS` (`func_06BF3C`), or Jesuit **A** `MSS4`.

### 3.10 Rebel sentiment (Sons of Liberty) — **B**
- **Keys:** `@REBELUP`, `@REBELUP50`, `@REBELDOWN`; `@SONSUP`, `@SONSDOWN`; `@REBELMAJORITY`,
  `@REBELUNANIMOUS`, `@TORYMINORITY`, `@TORYMAJORITY`, `@TORYUPRISING`.
- **Speaker:** **—**. **Handler:** `func_03E844` (REBELUP/DOWN, **A**); `@TORYUPRISING` event
  `func_03CAC6` (shared engine). Rebel/Tory % shown in F3 Continental Congress.

### 3.11 Food shortage / starvation — **B keys / TBD trigger**
- **Keys:** `@FOODLOW`, `@STARVE1`, `@STARVE2`, `@FOOD1`, `@FOOD2`; spoilage `@SPOIL1..@SPOIL4`;
  `@WAREHOUSEFULL`, `@NOMOREWAREHOUSE`.
- **Speaker:** **—**. **Trigger fn: TBD** (blocker: the colony-update fn that fires these is
  not yet pinned).

### 3.12 Colony burn / capture — **B**
- **Keys:** `@BURNED`, `@BURNED2`, `@BURNED3`; `@CAPTURED`, `@CAPTURED2`, `@CAPTURED3`;
  `@INDIANBURNCOLONY`, `@INDIANBURNCOLONY2`, `@INDIANWINCOLONY`, `@INDIANWINCOLONY2`; war
  outcomes `@EUROPEWIN`, `@EUROPELOSE`. Handler `func_05CA7E` (**A**). Woodcut `WDCUT11`.
- **Speaker:** **T** (native burn) or **—** (rival capture).

### 3.13 Intervention — **B**
- **Keys:** `@INTERVENTION`, `@INTERVENE`, `@CONSIDER`; ally names `@FRIEND` (*"British General
  Cornwallis / French General Lafayette / Spanish Generals / Dutch Admiral de Ruyter"* —
  confirmed). Event `@INTERVENE` = `func_03D510` (shared engine); announce `func_03D948` (**A**).
  "Intervention Force" label = LABELS `@MISC`.
- **Speaker:** **—**.

### 3.14 Treasure delivery — **B**
- **Keys:** `@CASHTREASURE`, `@KINGGALLEON2`, `@KINGGALLEON3`, `@LOOTCASH`, `@LOOT`, `@LOOT2`,
  `@LOOTFOREIGN`, `@LOOTCAPTURE`, `@NOLOOT`. Handler `func_05C878` (King's Galleon, **A**).
- **Speaker:** **K** — `[0x1F5C]=8` → KING1.SS. Treasure woodcut `WDCUT04`.

### 3.15 Unit capture / demotion — **B**
- **Keys:** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`, `@CARGOCAPTURE`, `@WAGONCAPTURE`,
  `@CAPTURED`, `@CONFISCATE`, `@LOBOTOMIZE`. (Overlaps combat handler `func_05B2C2`.)
- **Speaker:** **—**.

### 3.16 Revolutionary-war messages — **B**
- **Keys:** `@DECLARE`, `@INDEPENDENCE`, `@MOBILIZE`, `@MOBILIZE2`, `@CANTMOBILIZE`,
  `@KINGMOBILIZE`, `@UPKEEP`; king-war `@KINGFRIGATE`, `@KINGNEWWAR`, `@KINGVICTORY`, `@KINGWAR`,
  `@KINGMERCY`, `@KINGBUY`, `@REFIT`; guards `@NOWARSDURINGREV`, `@NOCOLONIESEITHER`,
  `@NOMAYORSDURINGREV`, `@EUROPENOTAVAIL`, `@FOREIGNNOTAVAIL`, `@ALREADYREVOLUTION`; siege
  `@INVASION`, `@SEIZURE`, `@SEIZURESEA`, `@SEIZURELAND`, `@TOOTORY`, `@LOSENOCOLONIES`.
  Independence handler `func_03DE46` + guard `func_03E984`; `@SEIZURE` `func_03C5A8`,
  `@INVASION` `func_03CDA2` (shared engine). (`@DECLARAT` screen → `spec/ui/cinematics.md`.)
- **Speaker:** king-war keys = **K** (KING1.SS — KING2.SS byte-refuted, §2); others **—**.
- **`@KINGNEWWAR` sprite = KING1.SS** (resolved B-negative — KING2.SS absent). **B.**

### 3.17 Other king-audience / misc popups — **B keys**
- **Keys (spot-confirmed bodies):** `@SMITEINDIANS` (inline options), `@WANTSTUFF`, `@VICEROY`,
  `@KINGLOSE`, `@KINGWIN`. King-audience body uses the same engine (`popups.md §2`); king
  channel **K** (KING1.SS).
- **Speaker:** **K**.

---

## 4. Interactions (cited)

- **Dismiss:** every popup ends with the modal wait loop `0x181F:0x3C0` (`func_004A80`) —
  polls kbhit/getch + mouse, ~120-tick timeout; **draws nothing** (OK box/label painted by the
  builder first). **B.**
- **Option select:** `@OPTIONS`/`@TAXOPTIONS`/`@LANDFALL`-inline rows stack below the body,
  left-aligned to the 10-px body margin; `@DEFAULT=N` = highlighted **row index** (handler
  @0x6F374), **not** a color. Selection read via show-and-wait `0x191F:0x16A`. **B.**
- **Speaker portrait:** drawn above the popup by `func_06BF66` from the active channel sheet;
  reset to 0xFFFF @0x06EE6B. **B.** Exact sprite_x/y = popup.x/y − sprite_w/h math is **TBD**
  (blocker: only the first ~30 bytes of `func_06BF66`, the KING/IND flag split @0x6BF7C, are
  decoded).

## 5. Assets & text (cited)

- **Frame/background:** WOODPANL.PIK (some WOODPAN2.PIK — per-popup choice **TBD**, no per-call
  dispatch byte-cited) tiled body + WOODFRAM.SS frame (`0x181F:0x510` @0x0263D6) + NAMEPLAT.SS
  title strip. **A** (asset roles).
- **Speaker sheets:** KING1.SS, IND0A0..IND7A0.SS, MSS0..MSS5.SS, MYR0..MYR3.SS — built **by
  NAME** by `func_06BE92`/`BF12`/`BF3C` (templates re-read §2). **B.**
- **Body font:** FONTTINY (`[0x89E]/[0x8A0]` engine default); `SMALLFONT` does **not** load
  FONTSMAL (handler @0x6F207 copies the latched FONTTINY descriptor — RULING). **B.**
- **Message keys:** `GAME_sections.json` — every `@KEY` in §3 grep-confirmed present
  (159/159 checked 2026-06-24). **B.**
- **Woodcuts:** WDCUT04 (treasure), WDCUT10 (battle), WDCUT11 (burning colony), WDCUT12
  (burning village), WDCUT13 (war dance) per `docs/UI_DIALOGS.md`. **A.**

## 6. Evidence (re-confirmed this pass)

- `raw/COLONIZE/VICEROY.EXE` — engine `func_06C520`/`06D316`/`06C850`; `@`-parser `func_06F0F4`
  (`cmp byte [bx],0x40` @0x06F192); directive table @file 0x1F967 (re-read =
  `OPTIONS…DEFAULT…TEXTC`); raid block @file 0x1F52A (re-read = 6 keys `RAIDWREAK…RAIDNOTHING`);
  speaker builders `func_06BE92` (split @0x06BE96, inject @0x06BEF5), `func_06BF12` (`[0x1f5e]`
  @0x06BF25), `func_06BF3C` (`[0x1f60]` @0x06BF4F); reset @0x06EE6B; king-tax wrapper
  `mov [0x1f5c],8` @0x06F5DD; Lost-City `func_061454` (`push 0x1dae` @0x618C2, show @0x618D9,
  sound 0x37 @0x618ED). Template literals re-read: KING@0x1F912, IND0A0@0x1F917, MSS0@0x1F91E,
  MYR0@0x1F923, LOSTCITY@0x1F74E. **B.**
- `data_extracted/text/GAME_sections.json` — all §3 `@KEY`s present (grep, 2026-06-24). **B.**
- `data_extracted/text/{NAMES,LABELS}_sections.json` — `@ATTITUDE`, `@ACTIONS`, `@TRIBES`;
  "Lost City Rumor"/"Intervention Force" in LABELS `@MISC`. **B.**
- `spec/ui/popups.md §2–§22` (shared engine, channels, geometry — cited not re-derived);
  `docs/POPUP_TEMPLATE_AUDIT.md` (directive table, channels, `@KINGTAX @width=190` raw read);
  `docs/UI_DIALOGS.md` (per-popup trigger fns, **A**). **B/A.**

## 7. Open items / blockers

1. **Per-section `@width`/`@x`/`@y`** — **B via EXE/raw GAME.TXT**, stripped from
   `*_sections.json` (§1). Only `@KINGTAX @width=190` independently quoted. **Blocker:** read
   raw GAME.TXT to re-confirm any other section's literal. **B-via-EXE / TBD-via-JSON.**
2. **WOODPANL vs WOODPAN2 per popup** — no per-call frame-index dispatch byte-cited; INFERRED
   WOODPAN2 = king-audience + a few darker popups. **TBD.**
3. **`func_06BF66` sprite-blit position math** — only KING/IND flag split @0x6BF7C decoded;
   exact `sprite_x/y = popup.x/y − sprite_w/h` is **TBD**.
4. **Food-shortage trigger fn** (§3.11) — keys present; firing fn not pinned. **TBD.**
5. **OK/Cancel button SS art index** — wait loop `0x3C0` draws nothing; `@DEFAULT` is a row
   index not a color; highlight resolves via PIK palette. Button SS index = carried **TBD**.
