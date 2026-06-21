# Gameplay Popups

> **Layer 2 — UI Specification (population stub).** Primary-only per
> `/METHODOLOGY.md`. Tiers: B (`BYTE_VERIFIED`) / A (`ANCHOR_VERIFIED`) /
> R (`RECONSTRUCTED`) / `TBD`. Details TBD — breadth pass.

**Overall confidence:** framework dispatch, 11 directives, 4 speaker channels, reset address,
Lost-City variant map, raid-count, `@KINGNEWWAR` sprite, and per-section `@width` all **B**
(raw-verified 2026-06-21); message-key existence **B**; final per-popup pixel rect + highlight
RGB **A/R** (runtime).
**Canonical primary:** `data_extracted/text/GAME_sections.json`,
`docs/POPUP_TEMPLATE_AUDIT.md`, `docs/UI_DIALOGS.md`, `docs/DIALOG_GEOMETRY.md`.
**Last updated:** 2026-06-18.

## Overview — the shared popup framework

All gameplay popups are drawn by the **single dialog framework `func_06F0F4`** (enter 0x168
@0x6F0F4; `@`-key check `cmp byte [bx],0x40` @0x6F193). The directive table is **11** keywords
(re-verified at file `0x1F967`): `OPTIONS / PROMPT / TEXT / SMALLFONT / Y / X / WIDTH / LENGTH
/ CHECKBOX / DEFAULT / TEXTCOLR` — the prior "9 directives" omitted the single-char `Y`/`X`
and `TEXTCOLR`. Handlers byte-located: `TEXT`→body ptr to struct +0x80/+0x82 (0x6F207);
`X`→+0xc (0x6F266); `Y`→+0xe (0x6F21E); `WIDTH`→atoi `func_06F812` (0x6F2AE); `LENGTH`→`[0xA5B6]`
(0x6F300); `CHECKBOX`→`or es:[bx+0xa],5` (0x6F34E); `DEFAULT`→highlight row (0x6F374). **B.**
*(Infra note: the DGROUP→file delta is `0x1D9A0` — DGROUP off + 0x1D9A0 = the literal's file
offset; this is why earlier audits that treated DGROUP offsets as file offsets saw "garbage".)*
A per-event handler:

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
4. **Geometry**: each GAME.TXT section carries a literal **`@width=NN` pixel width** (present
   in 475/499 sections; default 190 — e.g. KINGTAX/KINGNEWWAR/LOSTCITY1/2/RAIDWREAK=190,
   SMITEINDIANS=220, WANTSTUFF=260, VICEROY=78). The framework parses it via the WIDTH/atoi
   directive (→ struct +0xc). **Correction:** `[0x1EA4]/[0x1EA5]` are **not** the `@width`
   parser output — they are written by the layout loop at file `0x0684BC` (`mov [0x1ea4],al`
   @0x684CC / `mov [0x1ea5],al` @0x684D7, both `shl al,2`) iterating 4 sub-elements via
   `func_067DC8`. So `@width` is **B** (literal source); the final pixel rect still depends on
   the runtime cursor + that layout loop → **A/R**.
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
- **Raid outcomes = exactly 6 (B, raw-verified).** The EXE raid-key block at file
  `0x1F52A` is six contiguous keys: `RAIDWREAK, RAIDSTORES, RAIDBURN, RAIDSHIP, RAIDGOLD,
  RAIDNOTHING`. Handler `func_05BE84` (enter 0x24 @0x5BE84; uses the `[0x8542]` colony anchor).
  **Note on `@RAIDSCALP`:** it exists as a section in `GAME.TXT` but is **not** referenced by
  this 6-key raid block (absent from the EXE) — it is an orphan / separate-path (warpath/scalp)
  key, **not** a 7th raid-popup outcome. Warpath `@INDIANWARPATH/2/WARFARE/WAR/GRUDGE/SURPRISE`
  handled by `func_04B036` (sets `[0x1f5c]=tribe_owner`); war-dance woodcut `WDCUT13`. **B.**
- **Tier:** keys **B**; raid count = 6 **B**.

## Lost City (10 variants)
- **Purpose:** result of a unit entering a Lost City Rumor tile.
- **Keys (B), the 10 `@LOSTCITY0..@LOSTCITY9`** are all present in
  GAME_sections.json, plus adjacent outcome keys `@BURIAL1`, `@BURIAL2`,
  `@BURIAL3` (burial-grounds anger), `@SCREWED`, `@VANISH` (expedition
  vanished). Label "Lost City Rumor" is `LABELS @MISC` (**B**).
- **Variant→outcome mapping — RESOLVED (B, 2026-06-21).** Handler `func_061454` (enter 0x3c
  @0x61454, the same fn `events.md` cites) builds `@LOSTCITY<n>` by appending the outcome index
  `[bp-6]` (1–9) to the "LOSTCITY" template (`push 0x1dae @0x618C2`) and shows it (`lcall
  0x181f:0x182 @0x618D9`). Byte-cited per-index side effects (matching `events.md` §2 exactly):
  **1** Fountain of Youth (sound 0x37 @0x618ED; promotes to 2 if `[0x5382]&1`); **2**
  Cibola/treasure (sound 0x3c); **3** ruins gold (`10·3d8` @0x61770); **4** burial-grounds anger
  (`or [bx+0x543e],0x40` @0x61877; sub-dispatches `@BURIAL1/2/3`+`@SCREWED`); **5** expedition
  vanished (`@VANISH`, downgrades to 6); **6** nothing; **7** gift/larger treasure (`2·4d10`
  @0x617C0); **8** trespass near shrines; **9** survivors/recruit (spawn `lcall 0x191f:0xac8`
  @0x61809; `@LOSTCITY0` is the recruit prompt reused by FoY/survivors). **B.**
- **Tier:** key existence + per-variant index map **B**.

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
  (`docs/UI_DIALOGS.md`, **A**). **`@KINGNEWWAR` sprite — RESOLVED (B, negative):** `KING2.SS`
  **does not exist** in the binary (`"KING2"` has zero occurrences; only `"KING1"` @file
  0x1FCB4, built by the `>7` branch of `func_06BE92`), so `@KINGNEWWAR` uses **`KING1.SS`** (or
  a static portrait), not a KING2 arm-raise animation — the KING2 hypothesis is byte-refuted.
- **Tier:** keys **B**; `@KINGNEWWAR` sprite **B** (=KING1); per-message geometry **A/R**.

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
*(Resolved 2026-06-21: Lost City variant map (`func_061454`, index 1–9); raid count = 6
(`@RAIDSCALP` is an orphan GAME.TXT key, not a raid-block outcome); `@KINGNEWWAR` = KING1.SS
(KING2.SS absent); `@width` is a literal per-section pixel width. All struck.)*

1. **Empty-body keys are a JSON-dump defect, not a binary unknown.** Bodies for the "empty"
   keys (LOSTCITY0/3-9, RAIDSTORES/BURN/SHIP/GOLD, SHIPOPTIONS, ARMOPTIONS, etc.) are **present
   and full in `raw/COLONIZE/GAME.TXT`** — `data_extracted/text/GAME_sections.json` is partial.
   Action = re-extract the JSON (mechanical); source is **B**.
2. **Final per-popup pixel rect** — the `@width` and option text are **B**, but the on-screen
   rect is composed at runtime by the layout loop (`0x0684BC`) over the live cursor. Exact
   placement stays **A/R** (runtime); not a static constant.
3. **Per-popup option-highlight RGB** — applied at runtime via `@DEFAULT`/`TEXTCOLR` palette
   index; perceived color needs a capture. **R**. (And WOODPANL-vs-WOODPAN2 per-popup choice —
   **TBD**.)
