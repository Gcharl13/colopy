# Gameplay Popups

> **Layer 2 — UI Specification (population stub).** Primary-only per
> `/METHODOLOGY.md`. Tiers: B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) /
> R (`RECONSTRUCTED`) / `TBD`. Details TBD — breadth pass.

**Overall confidence:** message-key existence **B** (every key below grepped in
`data_extracted/text/GAME_sections.json`); framework dispatch **A**; per-popup
geometry / option text / sprite-channel value mostly **TBD**.
**Canonical primary:** `data_extracted/text/GAME_sections.json`,
`docs/POPUP_TEMPLATE_AUDIT.md`, `docs/UI_DIALOGS.md`, `docs/DIALOG_GEOMETRY.md`.
**Last updated:** 2026-06-18.

## Overview — the shared popup framework

All gameplay popups are drawn by the **single dialog framework
`func_06F0F4`** (the 9 in-section directives `OPTIONS / PROMPT / TEXT /
SMALLFONT / WIDTH / LENGTH / CHECKBOX / DEFAULT / TEXTCOLR` are byte-cited at
file `0x1F967..0x1F9B3`). A per-event handler:

1. selects the **GAME.TXT message key** (the `@`-named section, body text);
2. sets one of the **4 speaker-sprite channels** (`docs/POPUP_TEMPLATE_AUDIT.md`),
   each a signed DGROUP word, `< 0` = "no sprite this popup":
   - `[0x1f5c]` — KING/IND: value `0..7` → `IND<n>A<pose>.SS` (tribe portrait);
     value `8` → `KING1.SS` (the `CMP 7 / JLE` split at `func_06BE92` 06BE96);
   - `[0x1f5e]` — advisor `0..5` → `MSS0..MSS5` (`func_06BF12`);
   - `[0x1f60]` — missionary `0..3` → `MYR0..MYR3` (`func_06BF3C`);
   - slot 4 — fixed `MSS3` colonist (`func_06BF66`);
3. calls the body-render thunk; the dispatcher `func_06E3D0` fires whichever
   channels are `≥ 0`. After close, all three channels are reset (usually to
   `0xFFFF`) at file `0x06EE6B`. **B** for the channel mechanism.
4. **Geometry**: popup rect `[0x839E..0x83A4]` is computed, never hard-set
   (`docs/DIALOG_GEOMETRY.md`); `func_067DC8` formula is byte-cited but its
   inputs (`@width=NN`, cursor) are runtime. So per-popup pixel rects are
   **TBD** unless a hand-derived value is cited.
5. **Background/frame**: tiled `WOODPANL.PIK` (some `WOODPAN2.PIK`) + `WOODFRAM.SS`
   border + `NAMEPLAT.SS` title strip; **A** (asset roles, not per-popup dispatch).
6. **Font**: body defaults to `FONTTINY`; `SMALLFONT` directive → `FONTSMAL`
   (user-curated ruling, `docs/POPUP_TEMPLATE_AUDIT.md`). **A**.
7. **Multi-section popups** (`@KINGTAX` + `@TAXOPTIONS`) concatenate a body
   section with an option-list section; mechanism **INFERRED** (`func_06F0F4`
   recursion), key existence **B**.

> Each section below lists the **verified message key(s)**, the sprite channel /
> PIK asset, options, and tier. Geometry is **TBD** unless noted.

## King tax demand
- **Purpose:** Crown raises (or adjusts) the European-sales tax rate.
- **Keys (B, in GAME_sections.json):** body `@KINGTAX`; punitive raise
  `@KINGRAISE`; lower `@KINGLOWER`; no-change `@KINGNOTHING`; manufactory-tax
  `@MERCANTILISM`; Crown-resource tax `@PURCHASETAX`; pretexts `@KINGNAVACT`,
  `@KINGSTAMPACT`, `@KINGWAR`, `@KINGWIFE`. Options `@TAXOPTIONS`
  ("Kiss pinky ring." / "Hold '{%STRING3 Party}.'" — text present, **B**) and
  `@TEAPARTY` (B).
- **Sprite:** `[0x1f5c]=8` → `KING1.SS` (`func_06F5DA`, "open King audience"). **B**.
- **Cross-ref:** full formula + state layout in `spec/systems/king.md` (tax-raise
  `func_034AE0`, threshold 60 `func_0349F4`). **Tier: B (keys) / see king.md.**

## Native village raze
- **Purpose:** player destroys a native settlement; gold reward + razed message.
- **Keys (B):** `@CHIEFKILL` (chief executes the player — taboo), `@INDIANGOLD`
  (raze gold reward), `@INDIANBURN`. Per `docs/UI_DIALOGS.md` raze handler is
  `func_04A7CA` (CHIEFKILL); razed scene woodcut `WDCUT12` (burning village).
- **Sprite:** `IND<tribe>A<pose>.SS` via `[0x1f5c]=tribe_idx`. **A.**
- **Tier:** keys **B**; trigger fn **A**; geometry **TBD**.

## Native attitude
- **Purpose:** report a tribe's stance toward the player.
- **Keys (B):** `@VILLAGEHAPPY`, `@VILLAGEMEDIUM`, `@VILLAGESAVAGE`,
  `@VILLAGEBAD`, `@VILLAGEWAR`; ships-anger `@MADATSHIPS`, `@MADATWAGONS`;
  `@DONTKNOWSHIPS`. Attitude word-list is `NAMES @ATTITUDE`
  (Content/Uneasy/Restless/Angry/War, **B**). Handler `func_04B308`
  (`docs/UI_DIALOGS.md`, **A**).
- **Sprite:** tribe `IND<n>`. **A.** **Tier:** keys **B**.

## Native gift / haggle
- **Purpose:** trade-overture outcomes and gifts from a village.
- **Keys (B):** haggle outcomes `@BADHAGGLE0`, `@BADHAGGLE1`, `@BADHAGGLE2`,
  `@BADHAGGLE3`; trade prompts `@BUY0`, `@BUY1`, `@BUYWHICH`, `@TRADE0`,
  `@TRADE1`, `@BADCARGO`, `@NOTENOUGH`; gifts `@INDIANGIVEFOOD`,
  `@INDIANGIVESTUFF`, `@INDIANSCONVERT`, `@CHIEFGIFT`, `@CHIEFGUIDES`,
  `@CHIEFAREA`, `@CHIEFHOWDY`, `@CHIEFBORED`. Handler `func_049600` (haggling),
  `func_0572E6` (gift/tribute) per `docs/UI_DIALOGS.md`. **A.**
- **Sprite:** tribe `IND<n>`. **Tier:** keys **B**.

## Native raid / warpath
- **Purpose:** native attack on a player colony/unit; warpath declaration.
- **Keys (B):** raid outcomes (6+) `@RAIDNOTHING`, `@RAIDWREAK`, `@RAIDSTORES`,
  `@RAIDBURN`, `@RAIDSCALP`, `@RAIDSHIP`, `@RAIDGOLD`; warpath `@INDIANWARPATH`,
  `@INDIANWARPATH2`, `@INDIANWARFARE`, `@INDIANWAR`, `@INDIANGRUDGE`,
  `@INDIANSURPRISE`. Handlers `func_05BE84` (raid, 6 outcomes), `func_04B036`
  (warpath; sets `[0x1f5c]=tribe_owner`) per `docs/UI_DIALOGS.md` /
  `docs/POPUP_TEMPLATE_AUDIT.md`. **A.** War-dance woodcut `WDCUT13`.
- **Tier:** keys **B**; raid count/outcome map **TBD**.

## Lost City (10 variants)
- **Purpose:** result of a unit entering a Lost City Rumor tile.
- **Keys (B), the 10 `@LOSTCITY0..@LOSTCITY9`** are all present in
  GAME_sections.json, plus adjacent outcome keys `@BURIAL1`, `@BURIAL2`,
  `@BURIAL3` (burial-grounds anger), `@SCREWED`, `@VANISH` (expedition
  vanished). Label "Lost City Rumor" is `LABELS @MISC` (**B**).
- **Variant→outcome mapping is `TBD`.** The brief's named outcomes (Fountain of
  Youth, Cibola/treasure, Burial Grounds, Ruins, Expedition Vanished, Rumors,
  Tribe Meeting, Sacred Shrine, Survivor Rescue, Recruit Choice) describe the
  *function* (manual-level) but **no `@FOUNTAIN`/`@CIBOLA` key exists** — the
  outcomes are selected among `@LOSTCITY0..9` + `@BURIAL*` + `@VANISH`. Which
  index = which outcome is **not byte-traced**; do not guess. Treasure-ransom
  woodcut is `WDCUT04`/`WDCUT05` (Aztec/Inca, **A**). Recruit-choice likely
  reuses `@RECRUITCHOOSE` (**B** key, attribution **TBD**).
- **Tier:** key existence **B**; per-variant semantics **TBD**.

## Combat result
- **Purpose:** land/colony combat resolution outcome.
- **Keys (B):** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`,
  `@CARGOCAPTURE`, `@WAGONCAPTURE`, `@SHIPDAMAGE`, `@ARTILLERY`, `@ARTILLERY2`,
  `@VETERAN`, `@VALOR`, `@WELLSEASONED`. Handler `func_05B2C2`
  (`docs/UI_DIALOGS.md`, **A**). Battle woodcut `WDCUT10`.
- **Tier:** keys **B**.

## Ship combat / landfall
- **Purpose:** naval combat and shore-arrival events.
- **Keys (B):** `@SHIPCOMBAT`, `@SHIPLAKE`, `@SHIPDAMAGE`, `@SHIPSUNK`,
  `@LANDFALL`, `@LANDFALL2`, `@LANDFIRST`, `@SAILHOME`, `@SHIPRUN`, `@SHIPSLOW`,
  `@FORTFIRE`, `@OVERBOARD`, `@EVASIVE`. Handler `func_03FDDE`
  (`docs/UI_DIALOGS.md`, **A**). Note: many of these `@`-keys have **empty
  bodies** in the extracted JSON (body text not captured in this dump) — key
  *presence* is **B**, body text **TBD**.
- **Tier:** keys **B**.

## Heresy denunciation
- **Purpose:** missionary denounces a rival nation's mission.
- **Keys (B):** `@HERESY0`, `@HERESY1`; mission keys `@MISSION0..@MISSION3`.
  Action label "Denounce Heresy of %Fs Mission" is `NAMES @ACTIONS` (**B**).
- **Sprite:** missionary `MYR<n>` (`[0x1f60]`) or Jesuit `MSS4`. **A.**
- **Tier:** keys **B**.

## Rebel-sentiment change (Sons of Liberty)
- **Purpose:** announce a colony crossing a SoL/Tory threshold.
- **Keys (B):** `@REBELUP`, `@REBELUP50`, `@REBELDOWN`; `@SONSUP`, `@SONSDOWN`;
  `@REBELMAJORITY`, `@REBELUNANIMOUS`, `@TORYMINORITY`, `@TORYMAJORITY`,
  `@TORYUPRISING`. Handler `func_03E844` (REBELUP/REBELDOWN) per
  `docs/UI_DIALOGS.md` (**A**). Rebel/Tory % shown in Continental Congress
  screen (PowerRecord+0x02, `docs/SESSION_UI_CATALOG.md` §3).
- **Tier:** keys **B**.

## Food shortage / starvation
- **Purpose:** warn of low food / a colonist starving.
- **Keys (B):** `@FOODLOW`, `@STARVE1`, `@STARVE2`, `@FOOD1`, `@FOOD2`;
  spoilage `@SPOIL1..@SPOIL4`; `@WAREHOUSEFULL`, `@NOMOREWAREHOUSE`.
- **Tier:** keys **B**; trigger fn **TBD**.

## Colony burn / capture
- **Purpose:** a colony is razed or captured (by natives or a rival power).
- **Keys (B):** `@BURNED`, `@BURNED2`, `@BURNED3`; `@CAPTURED`, `@CAPTURED2`,
  `@CAPTURED3`; `@INDIANBURNCOLONY`, `@INDIANBURNCOLONY2`, `@INDIANWINCOLONY`,
  `@INDIANWINCOLONY2`; war outcome `@EUROPEWIN`, `@EUROPELOSE`. Handler
  `func_05CA7E` (`docs/UI_DIALOGS.md`, **A**). Burning-colony woodcut `WDCUT11`.
- **Tier:** keys **B**.

## Intervention
- **Purpose:** a foreign power's Intervention Force joins the Revolution.
- **Keys (B):** `@INTERVENTION`, `@INTERVENE`, `@CONSIDER`; ally names `@FRIEND`
  (Cornwallis/Lafayette/etc., body present, **B**). Handler `func_03D948`
  (`docs/UI_DIALOGS.md`, **A**). "Intervention Force" label in `LABELS @MISC`.
- **Tier:** keys **B**.

## Treasure delivery
- **Purpose:** a treasure train is shipped to Europe (King's Galleon) and cashed.
- **Keys (B):** `@CASHTREASURE`, `@KINGGALLEON2`, `@KINGGALLEON3`, `@LOOTCASH`,
  `@LOOT`, `@LOOT2`, `@LOOTFOREIGN`, `@LOOTCAPTURE`, `@NOLOOT`. Handler
  `func_05C878` (King's Galleon) per `docs/UI_DIALOGS.md`. Sprite `KING1.SS`.
  Treasure woodcut `WDCUT04`. **A.**
- **Tier:** keys **B**.

## Unit capture / demotion
- **Purpose:** a unit is captured or demoted after combat.
- **Keys (B):** `@DEMOTE`, `@COLONISTCAPTURE`, `@COLONISTCAPTURE2`,
  `@CARGOCAPTURE`, `@WAGONCAPTURE`, `@CAPTURED`, `@CONFISCATE`, `@LOBOTOMIZE`.
- **Tier:** keys **B** (overlaps Combat result handler `func_05B2C2`).

## Revolutionary-war messages
- **Purpose:** declaration, mobilization, REF, and end-of-war events.
- **Keys (B):** `@DECLARE`, `@INDEPENDENCE`, `@DECLARAT`-screen (see
  `spec/ui/cinematics.md`), `@MOBILIZE`, `@MOBILIZE2`, `@CANTMOBILIZE`,
  `@KINGMOBILIZE`, `@UPKEEP`; king war keys `@KINGFRIGATE`, `@KINGNEWWAR`,
  `@KINGVICTORY`, `@KINGWAR`, `@KINGMERCY`, `@KINGBUY`, `@REFIT`; guards
  `@NOWARSDURINGREV`, `@NOCOLONIESEITHER`, `@NOMAYORSDURINGREV`,
  `@EUROPENOTAVAIL`, `@FOREIGNNOTAVAIL`, `@ALREADYREVOLUTION`; siege/invasion
  `@INVASION`, `@SEIZURE`, `@SEIZURESEA`, `@SEIZURELAND`, `@TOOTORY`,
  `@LOSENOCOLONIES`. Independence handler `func_03DE46` + guard `func_03E984`
  (`docs/UI_DIALOGS.md`, **A**). `@KINGNEWWAR` may use the `KING2.SS`
  arm-raise animation — **TBD** (`docs/KING_AND_CINEMATIC_AUDIT.md` §7).
- **Tier:** keys **B**; per-message sprite/geometry **TBD**.

## Evidence
- `data_extracted/text/GAME_sections.json` — every `@`-key above grepped
  present. **B** (key existence). Bodies for `@TAXOPTIONS`, `@FRIEND`,
  `@ARMOPTIONS`, `@WANTSTUFF` etc. are captured; many event keys have empty
  bodies in this dump.
- `docs/POPUP_TEMPLATE_AUDIT.md` — framework `func_06F0F4`, 9 directives at
  `0x1F967`, 4 sprite channels `[0x1f5c/5e/60]`, builders `func_06BE92/BF12/BF3C`,
  reset `0x06EE6B`. **B** (mechanism) / **A** (per-event attribution).
- `docs/UI_DIALOGS.md` — per-popup trigger functions (`func_05BE84` raid,
  `func_05B2C2` combat, `func_05CA7E` burn, `func_03E844` rebel, etc.). **A**.
- `docs/DIALOG_GEOMETRY.md` — rect `[0x839E..0x83A4]` compute path. **A/TBD**.
- `data_extracted/text/NAMES_sections.json` — `@ATTITUDE`, `@ACTIONS`. **B**.
- `data_extracted/text/LABELS_sections.json` — "Lost City Rumor",
  "Intervention Force". **B**.

## Open questions (TBD)
1. **Lost City variant map** — which of `@LOSTCITY0..9` / `@BURIAL*` / `@VANISH`
   corresponds to Fountain of Youth, Cibola, Ruins, Tribe Meeting, Sacred Shrine,
   Survivor Rescue, Recruit Choice. Byte-trace the LostCity outcome selector.
2. **Per-popup geometry** — resolve `@width=NN` per section + the
   `[0x1EA4]/[0x1EA5]` writer to make rects static.
3. **Raid outcome count** — confirm the 6-vs-7 outcome set for `func_05BE84`.
4. **Empty-body keys** — re-extract GAME.TXT bodies for the many `@`-keys that
   are empty strings in this JSON dump.
5. **`@KINGNEWWAR` sprite** — confirm `KING2.SS` animation vs static `KING`.
