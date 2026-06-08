# Function Inventory — VICEROY.EXE Game Systems

Complete inventory of game-system entry-point functions, identified
via string analysis. Each entry maps a major Colonization mechanic to
its canonical entry-point function in VICEROY.EXE.

This is the master reference for "where does X happen in the code".

---

## Game-state initialization

### `func_0749E0` — **Scenario loader / NAMES.TXT reader**
**File**: 0x0749E0..(extends past detected 601-byte boundary, ~3,500 bytes)
**Role**: Reads all data sections from NAMES.TXT into in-memory tables.

The function PUSHes 56 distinct string constants — the canonical list
of NAMES.TXT sections:

| Category | Sections |
|----------|----------|
| Terrain | UNFORESTED, FORESTED, OTHER, OTHER_NAMES, RESOURCE |
| Political | COUNTRY, NATIONALITY, NATIONABBREV, HOMEPORT, COLONYNAME, LEADERNAME, MISSION, DIFFICULTY |
| Unit/cargo | CLASS, BUILDING, CARGO, UNIT, ORDERS, ACTIONS |
| AI | VALUES, ATTITUDE, ATTITUDINAL, LEVELS |
| Tribes | TRIBES |
| FFs | FOUNDING, FATHERS |
| UI | COLORS, INFO, LABELS, MISC, ROUTE, CMISC, CTITLE, CMESSAGE, EUROLABEL, MISCELLANEOUS, PEDIA |
| Time | SEASONS |
| Asset refs | KINGLSS, ENGLND, FRANCE, SPAIN, DUTCH, KING1, KINGLOSE, KINGWIN, VICEROY, AMER2.MP, OPENMENU, MAPTOLOAD, WOODPANL, GAME |

**Implication**: NAMES.TXT is the authoritative source of all
ID-to-name mappings. The function reads each section by name and
stores the parsed records into DGROUP tables that are used by every
game-system function.

---

## Colony management

### `func_02D658` — **Colony SoL/Tory% + training + food turn handler** (BYTE_VERIFIED, wave-12)
**File**: 0x02D658..0x02EABB (**5220 bytes** verified, RETF @0x2EAB8; "1061" was
auto-segmenter truncation). **Reach**: thunk 0x191F:0x688 (page 0x03 base 0x2CFD0).
**Strings**: REBELMAJORITY/REBELUNANIMOUS/TORYMINORITY/TORYMAJORITY/SONSUP/SONSDOWN,
TRAINPROFESSION(+FAIL/CRIMINAL/INDENTURED)/NEWCOLONIST, FOOD1..FOODLOW, LUMBER..TOOLS.

The per-colony end-of-turn handler (COMPLEMENT to turn_update.c). Updates the SoL
bell accumulators (ColonyRecord +0xC2 bells / +0xC6 threshold, EMA decay /64
@0x2DA3C/0x2DA9C) that sol_membership_pct(0x8524) reads; Tory% = 100−rebel%, tory
divisor 10−difficulty (@0x2DCBC); fires rebel/tory band messages (REBELMAJORITY
rebel%≥50 @0x2DB29); runs School/College/Univ graduation; settles food/starvation;
emits per-commodity reports; per-power bells tally PowerRecord+0x2E (@0x2E6C0,
distinct from +0x0C/0x0E FF-progress bells). Ported: [src/colony/sol_tory.c](src/colony/sol_tory.c).

### `func_053B7E` — **Colony AI auto-manage (work re-alloc + build planner)** (BYTE_VERIFIED spine, wave-12)
**File**: 0x053B7E..0x05628C (**9999 bytes**, ENTER 0x1C0, single RETF; reseg 10025
over-counts 26 trampoline bytes). Reach: thunk 0x1A1F:0x35E (page 0x0E).
**NOT a king/tax function** — the NEXT_TARGETS "KINGTAX" tag was a false attribution
(pushes no king message handle; 110× colony-struct refs). Selects a colony via
0x181F:0x9E6, surveys surrounding units/tiles, computes colony status flags
*(0x8542)+0x1B/+0x1C/+0x1D, plans the next build (king-treasury debits
king[+0x2A]/[+0x2C]/[+0x49], result flag [0x35E]), and tears down + greedily rebuilds
colonist→job/tile assignments biased by the Europe market bands. Shares
colony_turn_update's 0x8Dxx/0x8Exx globals + 0x2F7B yield table. Ported:
[src/colony/auto_manage.c](src/colony/auto_manage.c). Per-good/per-power weight tables [RUNTIME_ONLY (data-resident)].

### `func_02883E` — **Colony-services menu-item dispatcher** (ANCHOR_VERIFIED)
**File**: 0x02883E..0x028D8B (**1357 bytes** verified, RETF; "138" was first-RET truncation).
**Strings**: 21 unique. ABANDON, ASSEMBLY, COLLEGE2, DROPOUT, FULL,
GRADUATE, INDIANBRIBE, KEEPSTOCKADE, MEETINGHALL, TOWNHALL.
22-entry CS jump-table @0x028AF0 (`JMP cs:[bx+0x31f0]`; CS base 0x025900) fully
decoded with per-arm string xrefs. Ported: [src/ui/menu.c](src/ui/menu.c).

### `func_028D8C` — **Colony build/dialog interaction engine** (ANCHOR_VERIFIED)
**File**: 0x028D8C..0x0298A4 (**~2841 bytes** verified, RETF; "185" was first-RET truncation).
Reads active colony via [0x8542]; cursor [0x8D7C]; win_create 0x191F:0x23C;
modal query/highlight/dispose loop; result via [0x034E]. Per-row blit + production
maths leaves overlay-not yet decoded. Ported: [src/ui/dialog.c](src/ui/dialog.c).

Town hall + assembly hall + college services. Handles colonist training
(LEARN, GRADUATE, DROPOUT) and Liberty Bell production (TOWNHALL,
MEETINGHALL).

### `func_022542` — **Colony founding validity check**
**File**: 0x022542..0x022584 (66 bytes detected; larger)
**Strings**: NOCOLONIESEITHER, NOPORT, SEACOLONY, TOOMOUNTAIN, TOONEAR,
TOONEARBUILD, TUTNOLUMBER, TUTNOSPACES.

Validates "can a colony be founded on this tile?" — checks distance
from existing colonies, terrain (no mountains, sea-only), tutorial
state, etc.

---

## Combat

### `func_05B2C2` — **Combat resolver** (with demotion-ladder sub-table) (BYTE_VERIFIED)
**File**: 0x05B2C2..0x05BE30 (**2926 bytes** verified extent; the "35 bytes detected"
was a first-RET truncation artifact — MANIFEST.md still shows 35, see its caveat).
**Strings**: ARTILLERY, ARTILLERY2, CARGOCAPTURE, COLONISTCAPTURE,
COLONISTCAPTURE2, DEMOTE, LOOTCAPTURE, SHIPDAMAGE.

Core resolver: single roll `roll = random_int(1, ATK+DEF); attacker wins if
roll <= ATK` @0x5B819..0x5B856 — see [src/combat/combat.c](src/combat/combat.c)
The demotion ladder is a sub-table (dispatch 0x5B5AA..0x5B61F) — see
[src/combat/combat_demotion_ladder.c](src/combat/combat_demotion_ladder.c).
**MODIFIERS RESOLVED 2026-05-30** (see [src/combat/combat_modifiers.c](src/combat/combat_modifiers.c)):
the odds roll @0x5B819 uses RAW 0x523b/0x523c with NO fortify/SoL/colony multiplier
("+50% fortified" REFUTED); the roll is **ship-attacker-only** (gate @0x5B7B6 type in
0x0D..0x12; land attackers jmp 0x5BAA3 — so LAND combat resolves in the 0x5BAA3 region,
not via this simple roll). The 0x5B433 "fort block" is a capture-eligibility threshold
(0x5237/0x5238), not a scaler; the real modifier layer is a post-roll per-power strength
compare @0x5B85B..0x5BA2D (difficulty MUL [0x5325]); per-power array semantics not yet decoded.

### `func_03FDDE` — **Ship move / landfall / ship-vs-ship combat dispatcher** (BYTE_VERIFIED)
**File**: 0x03FDDE..0x40002 (**548 bytes**, overlay page 0x07; functions.json's 82B is a
first-RET truncation, reseg's phantom func_03FF4C is jump-table drift — both overruled).
**Strings**: LANDFALL, LANDFALL2, LANDFIRST, SAILHOME, SHIPCOMBAT, SHIPLAKE, NODOCKS,
EUROPENOTLEAVE. Dispatches a ship arriving at a destination (status from sibling
func_03FA9C @[0x9e4e]) via a 9-entry jump table @0x3FF44. Ported: [src/combat/naval.c](src/combat/naval.c).

Naval combat + landfall events.

---

## Native / tribal interactions

### Native settlement lifecycle (page 0x0C, code_base 0x46600) — BYTE_VERIFIED

The 18-byte `NativeSettlement[]` table at DGROUP:0x54EC (stride 0x12,
live-count 0x539A, max 84) is managed by a tight cluster of small functions
at the top of page 0x0C. The `owner` field (+0x02) holds a POWER INDEX
(tribe_id + 4; natives = powers 4..11) — see VERIFICATION_LEDGER 2026-05-30.

| Func | File | Role | Src |
|------|------|------|-----|
| `func_046DE0` | 0x046DE0..0x046E17 (56 B) | settlement display value = `weight*2+3` (+bonus if +0x03 bit4) | [settlement.c](src/native/settlement.c) `native_settlement_value_for_display` |
| `func_046E18` | 0x046E18..0x046EBE (167 B) | add settlement (alloc slot, set x/y/owner/pop, mission=0xFF, mark tile) | [settlement.c](src/native/settlement.c) `native_settlement_add` |
| `func_046EC0` | 0x046EC0..0x046FC1 (258 B) | remove+compact; per-tribe count--; eliminate (+3\|=0x80) or scale +0x08/+0x0A down by n/(n+1) | [settlement.c](src/native/settlement.c) `native_settlement_remove` + helpers |
| `func_046FC2` | 0x046FC2..0x046FF9 (56 B) | for each settlement owned by tribe, call overlay helper 0x191F:0x0248 (descending walk) | [tribe_query.c](src/native/tribe_query.c) `native_foreach_settlement_of_tribe` |

The alarm/tension word array at 0x54F6 (index `A*9+B`, threshold 0x80) is a
SEPARATE table read by the per-unit native AI (func_046FFA) and cleared by the
raid handler. See [raid.c](src/native/raid.c) + include/native.h.

### `func_057F4E` — **Diplomacy meeting / SMITE** (BYTE_VERIFIED)
**File**: 0x057F4E..0x059B3D (~6,640 bytes)
**Strings**: 35 unique. SMITEINDIANS, SMITEEUROPE, plus 33 dialog
options (PEACE, OLDPEACE, TRIBUTE, GIFTS, THREATS, etc.).

SMITE gold formula BYTE_VERIFIED: see [src/native/diplomacy_smite_gold.c](src/native/diplomacy_smite_gold.c).

### `func_04A7CA` — **Chief interaction / village raze** (BYTE_VERIFIED)
**File**: 0x04A7CA..0x04A9C5 (507 bytes detected; extends to ~0x04ABA0)
**Strings**: CHIEFAREA, CHIEFBORED, CHIEFGIFT, CHIEFGUIDES, CHIEFHOWDY,
CHIEFKILL, WELLSEASONED.

Native village raze formula BYTE_VERIFIED: see [src/native/native_village_raze.c](src/native/native_village_raze.c).

### `func_05BE84` — **Native raid outcome dispatcher** (roll+dispatch BYTE_VERIFIED)
**File**: 0x05BE84..0x05C659 (2006 bytes, page 0x10)
**Strings**: RAIDBURN, RAIDGOLD, RAIDNOTHING, RAIDSHIP, RAIDSTORES,
RAIDWREAK.

6-outcome native raid dispatch with per-outcome sound (4F, 53, 4B/4D,
4E, 5B). Selection roll = `random_int(1,4)` @0x05BF35, then a
difficulty/feasibility remap chain (@0x05BF44..0x05C01E), then a 5-way
dispatch @0x05C023 (0=NOTHING / 1=STORES / 2=WREAK / 3=GOLD / 4=BURN/SHIP).
Loot gold transfer + per-pair 0x54F6 counter clear byte-verified. See
[src/native/raid.c](src/native/raid.c) `native_raid_resolve_outcome`,
`native_raid_loot_gold`, `native_raid_clear_counter`.

### `func_04AC00` — **Native extortion (gold demand)**
**File**: 0x04AC00..0x04AD8D (397 bytes)
**Strings**: EXTORTLAUGH, EXTORTNO, EXTORTPOOR, EXTORTSTUFF.

When player tries to demand gold from natives via threat. Reads
UnitRecord, checks attitude, dispatches to outcome.

### `func_05A20E` — **Scout interactions**
**File**: 0x05A20E..(detected)
**Strings**: LOSTOURSCOUTS, LOSTTHEIRSCOUTS, NOMAYORSDURINGREV,
SCOUTCOLONY.

Scout-specific handlers for entering native settlements.

### `func_04A426` — **Native learning / training**
**File**: 0x04A426..0x04A497 (113 bytes detected)
**Strings**: ALREADY, CRIMINAL, DONE, LATER, LEARN, LEARNSTAY, MASTER,
SLOW.

Colonist trains in native village → becomes Master Sugar Planter etc.
Branch on `[BP+8] < 4 && AIPersonality.byte_31 == 0` (active human/EU
power vs unentered tribe).

### `func_0572E6` — **Native gift / tribute events**
**File**: 0x0572E6..0x05738A (164 bytes detected)
**Strings**: INDIANCITY, INDIANCOMMENT, INDIANGIVEFOOD, INDIANGIVESTUFF,
INDIANSCONVERT, INDIANWAGONS.

Natives give food/stuff to colonies, convert missionaries, send
wagon-trains.

### `func_05A40E` — **Trade with natives**
**File**: 0x05A40E..0x05A463 (85 bytes detected)
**Strings**: LEADER2, TRADEMERCANTILISM, TRADENOCARGO, TRADENOWANT,
TRADEWITH.

### `func_04B036` — **Native war declaration**
**File**: 0x04B036..(detected)
**Strings**: ALREADYSMITE, INDIANWARFARE, INDIANWARPATH2, NOCONTACT,
UNFORTUNATE.

### `func_04B308` — **Tribe attitude display**
**File**: 0x04B308..(detected)
**Strings**: HAPPY, MADATSHIPS, MEDIUM, SAVAGE, VILLAGE.

5 attitude levels: HAPPY > MEDIUM > SAVAGE > MADATSHIPS > (VILLAGE
fallback).

### `func_049600` — **Native trade haggling resolver (BUY/SELL prices)** (BYTE_VERIFIED, wave-13)
**File**: 0x049600..0x04A37A (**3451 bytes**, ENTER 0xD8, RETF @0x4A377). Type-A thunk
file 0x1CA3C (0x1A1F:0x044C). **Strings**: BADCARGO/BADHAGGLE0..3/BRING/BUY0/BUYWHICH/
TRADE0/DEFICIT/NOTENOUGH. Ported: [src/native/haggle.c](src/native/haggle.c).
- SELL (gold IN @0x49B92, PowerRecord+0x2A): price = (base−diff−want2+mood+4)×2 →
  ×stock+mood*5 → ×qty/100 /2; per-good tweaks (Furs/Muskets/Horses/TradeGoods).
- BUY (gold OUT, affordability-guarded @0x4A1C8): ask=0xC8 + tier/display-price +
  rand − relation*4, ×qty/100, +difficulty, floor 0x32.
- 4-way BADHAGGLE0..3 counter-offer escalation loop. Inputs 0x97C0 @CARGO-col0 /
  0x7B44 display price / 0x5B1C tribe relation / 0x8DC4 qty. Dialog thunks [not yet decoded].

---

## King events / Royal Expeditionary Force

### `func_036138` — **King actions dispatcher**
**File**: 0x036138..0x0361B4 (124 bytes detected; larger)
**Strings**: COUNTRIES, KINGNAVACT, KINGSTAMPACT, KINGVICTORY, KINGWAR,
KINGWIFE, ORDINAL.

**Gating** (BYTE_VERIFIED at file 0x036142..0x036155):
```
if [DGROUP:0x9E12].byte_at_+0x9298 == 0: skip   ; per-power active flag
if [DGROUP:0x538E] (turn) < 0x1E (= 30): skip   ; first 30 turns no king
if [DGROUP:0x538A] > 0x640 (= 1600): proceed     ; some other counter
LOCAL_5C = 0x12 = 18                              ; some default
```

So **king events do NOT fire before turn 30**. After that, gating
depends on a counter at 0x538A vs 1600.

### `func_034AE0` — **King tax raise/lower** (BYTE_VERIFIED)
See [src/king/king_tax_raise.c](src/king/king_tax_raise.c). Formula:
`change = ((diff & 0xFE)*2 + 4) × (turn/400 + 1)`.

### `func_034318` — **Tea Party / tax application** (BYTE_VERIFIED tax CAP=75)
See KingTaxRaise.c summary.

### `func_02F052` — **King per-power events: ship REFIT + KINGTAX grant** (BYTE_VERIFIED)
**File**: 0x02F052..0x02F3A0 (**847 bytes**, RETF; per-func dump truncated@117B).
**Strings**: REFIT (0xEEF), KINGTAX flag [0x14C]. Ported: [src/king/king_events.c](src/king/king_events.c).
Walks UnitRecords (0x3144/0x1C), completes Europe ship REFITs, grants a king unit
(spawn type 0x11). **NOT a UI screen** (wave-5 UI agent mislabel, corrected 2026-05-30).

### `func_0349F4` — **King event handler #2**
**File**: 0x0349F4..(detected)
**Strings**: KINGTAX2.

### `func_03D948` — **Intervention (French aid in revolution)**
**File**: 0x03D948..(detected)
**Strings**: INTERVENTION.

### `func_075352` — **End-screen / king-loses display**
**File**: 0x075352..(detected)
**Strings**: DUTCH, ENGLND, FRANCE, KING1, KINGLOSE, KINGLSS, KINGWIN,
SPAIN.

Loads king/nation art for endgame screens.

---

## Revolution / Independence

### `func_03DE46` — **Independence event**
**File**: 0x03DE46..(detected)
**Strings**: INDEPENDENCE.

### `func_03E984` — **Declaration guard (small, 26 bytes)** (BYTE_VERIFIED)
```c
if (g_flags_5382 & 1) {                  // endgame flag
    display_text_key(1, "ALREADYREVOLUTION");
}
return;
```
Just guards against double-declaration.

### `func_03ECF0` — **Diplomatic actions**
**File**: 0x03ECF0..0x03ED46 (86 bytes detected; larger)
**Strings**: CANCELPEACE, DECLAREWAR, HAVETREATY, WHACKINDIANS.

The right-click-unit "diplomatic options" menu.

### `func_03E844` — **Sons of Liberty display** (REBELUP/REBELDOWN)
**File**: 0x03E844..0x03E883 (63 bytes; display only)
Strings: REBELUP, REBELUP50, REBELDOWN.

---

## Win / Lose / Score

### `func_02F3A2` — **War-of-Independence per-turn handler** (BYTE_VERIFIED structure)
**File**: 0x02F3A2..0x02FAE8 (**1869 bytes**, RETF; per-func dump truncated@63B).
**Strings (15, all byte-verified)**: LOSENOCOLONIES, WINNING, KINGLOSE, LOSING0,
KINGWIN, WARN0, INDEPENDENT, NAMES, OTHERGRANTED, OTHERMIGHT, OTHERLESS,
SOONRETIRING, RETIRING, RETIRING2, SCORED.
*(CORRECTED 2026-05-30: prior "Win/lose check" + "YOULOSE/YOUWIN" was WRONG — those
keys are NOT pushed by this body.)* King-MILITARY turn logic: defeat-by-no-colonies
(yr>=1600 @0x2F3FD), king-warning gate, at-war REF-landing matrix (budget
(8-diff)*10), dated messages at 1790/1800/1840/1850. Ported:
[src/king/war_turn.c](src/king/war_turn.c). NOT a win/lose UI screen.

### `func_03A9C0` — **Endgame SCORE + RANK screen** (BYTE_VERIFIED, corrected 2026-05-30)
**File**: 0x03A9C0.. (73 bytes detected = truncation; real body larger)
**Strings**: SCORE, SCORE_msg2.

Computes the 0..23 player RANK via a `(k*k)/3` threshold ladder × difficulty
(byte-visible; decompiled in [src/scoring/compute.c](src/scoring/compute.c)
`score_endgame_rank()`). The **raw per-power score value** it ranks is produced
by an overlay-resident routine reached as `0x191F:0x3AA` (trampoline file
0x03B36A) and is **not yet decoded**. (Prior note — "[DGROUP:0x372] accumulator / 964-byte
frame computes per-category arrays" — was a pre-trace heuristic, now WITHDRAWN.)

### `func_03ADA6` — **Hall-of-Fame save (HALLFAME.DAT writer)**
**File**: 0x03ADA6..(detected, 1,362 bytes)
**Strings**: HALLFAME.DAT.

---

## Market

### `func_02B744` — **Buy commodity (BUYME0)**
**File**: 0x02B744..(detected)

### `func_0305A8` — **Market price drift (PRICEUP/PRICEDOWN)**
**File**: 0x0305A8..0x0305FF (87 bytes detected; larger)

Per-commodity price change. Uses `DGROUP:0x53EA` (per-player base) and
`DGROUP:0x8904` market state table (stride 79*4 = 316 bytes per row).

---

## AI

### `func_046FFA` — **Native (Indian) per-unit AI driver** (RECONSTRUCTED; structure BYTE_VERIFIED)
**File**: 0x046FFA..0x0482DC (4835 bytes, page 0x0C, ENTER 0x00A2,0, terminal RETF;
the 121B per-func dump was a first-RET truncation, overruled).
**Strings**: INDIANSURPRISE (handle 0x14DC -> file 0x1EE7C @0x048186).
The native counterpart to the EU per-unit chain. Scores up to 9 neighbour tiles
(base 200) against tribe ALARM (0x54F6, threshold 0x80 @0x4734E), target wealth/
defence (ColonyRecord 0x5D46), AIPersonality(0x543F)/difficulty(0x53A6); argmax
(+random_int(1,5) jitter); commits MOVE order (0x314c=5/6) + direction (0x314f),
spends settlement strike budget (0x8D4E), raises INDIANSURPRISE on a hostile strike
vs the human. Weight tables 0x2F77/0x5236/0x9410 [RUNTIME_ONLY (data-resident)]. See
[src/ai/native_unit_ai.c](src/ai/native_unit_ai.c).

### `func_04E2D6` — **AI action dispatcher**
**File**: 0x04E2D6..0x04E51E (584 bytes)
**Strings**: AI10, AI11, AI12, AI13, AI14, AI15, AI16, AI17, … (11 strings).

Iterates a unit's UnitRecord, extracts power_idx via byte +1 low nibble,
dispatches to one of 11 AI sub-actions (AI10..AI20). The 11 actions are
likely: move, attack, fortify, build, settle, trade, etc.

---

## UI / framework

### `func_06F0F4` — **Dialog framework**
**File**: 0x06F0F4..(detected)
**Strings**: CHECKBOX, DEFAULT, LENGTH, OPTIONS, PROMPT, SMALLFONT,
TEXT, WIDTH.

The dialog-box layout engine. Used by every menu/dialog in the game.

### `func_06EEEC` — **Text template parser**
**File**: 0x06EEEC..(detected)
**Strings**: COUNTRY, NUMBER, STRING, YEAR.

Parses message-key templates with placeholders ($COUNTRY$, $NUMBER$,
$STRING$, $YEAR$). Used by every formatted message.

### `func_072090` — **Top menu-bar builder** (BYTE_VERIFIED -> src/ui/report_screen.c::build_menubar)
**File**: 0x072090..0x072B9A (**2826 bytes**, ENTER 4; per-func dump's "size=39" was a
first-call truncation). Builds the 7-8 pull-down columns; per-row labels via
txt_lookup from MENU.TXT (NOT literal in EXE -> [not-yet-decoded-from-EXE]).
**Strings**: game, menu, view, orders, reports, trade, cup, pedia (MENU.TXT @-keys).
The Reports column holds the 10 F-key reports (selectors 0x40..0x49); cheat column
gated by `test [0x5383],0x20` @0x72A8B. Does NOT render report bodies (corrects the
wave-5 "func_072090 = report content engine" guess); the actual renderers are the
page-0x05 functions below (DECODED wave-9 via the RTLink tool).

The top-of-screen menu bar with 7 categories.

### Page-0x05 F-key report renderers (BYTE_VERIFIED content, wave-9)
Reached from func_0235D6's F-key CMP/LCALL ladder via Type-A thunks into page 0x05
(code base 0x37340). Each takes the ACTIVE PLAYER INDEX in [bp+6]; the shared
selector **func_030550** (file 0x30550, via 0x181F:0x582) sets [0x9E12]=player and
[0x84FC]=0x8808+player*0x13C (re-confirms PowerRecord base/stride). Titles from
LABELS.TXT @MISC (absent from EXE). All in src/ui/report_screen.c.
- F2 0x41 `func_037958` Religious | F3 0x42 `func_037A10` Continental Congress
- F4 0x43 `func_038418` Labor | F5 0x44 `func_038A50` Economic ($ ledger)
- F6 0x45 `func_039218` Colony | F7 0x46 `func_03954C` Naval
- F8 0x47 `func_039888` Foreign Affairs (FOREIGNNOTAVAIL 0x11B6) | F9 0x48 `func_03744A` Indian
- F10 0x49 `func_038778` Score (ENTER 6; SoL/Score thunk 0x181F:0x574 -> +0x70 mid-insn [not yet decoded])

### `func_062D84` — **Unit auto-move / pathing executor**
**File**: 0x062D84..0x0633D6 (1618 bytes, ENTER 0x46, terminal=page-end; reseg page_13)

CORRECTED 2026-05-30 (was "Number-to-name converter" — a false string-proximity
heuristic; the "Five/Four/Seven/Three" strings belong to another routine). The
body is byte-confirmed unit logic over the UnitRecord table:
- `@asm 0x062DA2  imul bx, ax, 0x1c`            ; UnitRecord stride 0x1C (base 0x3144)
- `@asm 0x062DCA  mov al,[bx+0x3144]` / `+0x3145` / `+0x3146` (type) / `+0x3147` (owner nibble)
- `@asm 0x062DBA  mov al,[bx+0x314d]` / `+0x314e`  ; move/order state fields
- `@asm 0x062E1F  imul bx,[bp-0x48],0x1c`        ; second UnitRecord index (target unit)

Drives one unit's automatic move/goto step. Full body ported (entry +
DGROUP reads verified) in `src/overlay/overlay_0612E6_066EB3.c`.

---

## Tutorial

### `func_020F50` — **Tutorial dispatcher**
**File**: 0x020F50..0x020FD6 (134 bytes)
**Strings**: TUTORIAL1, TUTORIAL3, TUTORIAL10, TUTORIAL11, TUTORIAL13,
TUTORIAL14, TUTORIAL15, TUTORIAL19, …

The tutorial-mode message dispatcher.

---

## Save / Load framework

### COLONY*.SAV serializer (page 0x1A 2nd-seg base 0x73270) — DECODED wave-10
DOS save MAGIC = **"COLONIZE"**+0x1A (file 0x1FB1A); "COL2" is Win16-only. I/O via
resident MSC lib (window 0xD1D). NO checksum. On-disk order: header → globals 0x5380
→ names 0x540E → ColonyRecord ×0xCA → UnitRecord count[0x539C]×0x1C → PowerRecord
4×0x13C → NativeSettlement count[0x539A]×0x12 → … → 4 map layers. All in
src/save/{save_serializer,load_deserializer}.c.
- `func_072F7A` (0x72F7A) SAVE orchestrator (SAVEGAME key) → `func_0734F8` (0x734F8,
  ENTER 6) SAVE driver via 0x1A1F:0xCF6.
- `func_073158` (0x73158) LOAD orchestrator (LOADGAME) → `func_073BB0` (0x73BB0,
  ENTER 0x64) LOAD driver via 0x1A1F:0xD12 (magic/version/map-size gates).
- `func_072C4E` builds the "COLONY"+slot+".SAV" filename.

### `func_0759E8` — **Game load / open menu framework**
**File**: 0x0759E8..(detected)
**Strings**: GAME, MAPTOLOAD, OPENMENU, WOODPANL.

Top-level "load game" / "new game" framework that drives the OPENMENU
display + WOODPANL background + MAPTOLOAD file picker.

---

## Helper tier (BYTE_VERIFIED) — recap

| Helper | File | Role |
|--------|------|------|
| `rand()` | 0x0103D4 | MSC 6.0 LCG (`seed×0x343FD + 0x269EC3`) |
| `random_int(lo, hi)` | 0x00C322 | universal roll (LCALL `0x181F:0x04D4`) |
| `clamp(v, lo, hi)` | 0x0048CC | clamp helper (LCALL `0x181F:0x035C`) |
| `__aFlmul` | 0x010530 | 32×32 truncated multiply |
| `__aFldiv` | 0x010496 | 32-bit signed long divide |
| `strcpy_near` | 0x00FDB4 | MSC strcpy |
| `strcat_near` | 0x00FD74 | MSC strcat |
| `power_attribute_bit(power, bit)` | 0x00BC10 | PowerRecord bitfield reader |
| `set_active_tribe(tribe_idx)` | 0x0081C6 | sets `g_settlement_ptr_8D4E` |
| `output_flush_if_unbuffered` | 0x00513C | LCALL `0x181F:0x04B6` |
| `set_message_context(code)` | 0x0050BC | LCALL `0x181F:0x048E` |
| `get_power_name_word(power)` | 0x008110 | LCALL `0x181F:0x09A4` |
| `get_per_power_byte(power, ofs)` | 0x007F34 | EU vs native universal accessor |
| `unit_destroy` (full: unlink+compact+renumber, NOT just decrement) | 0x006E94 | near `call 0x68AA` (unit_chain_unlink) — corrected 2026-05-30; the prior `LCALL 0x181F:0x0808` note was WRONG (byte @0x6EE2 = e8 c5 f9 = near call→0x68AA). See src/unit/lifecycle.c |
| `terrain_normalize` | 0x006204 | auto-forest mapping |

### Colony production-support helpers (BYTE_VERIFIED 2026-05-30)

Bodies in [src/colony/production_support.c](src/colony/production_support.c);
see VERIFICATION_LEDGER.md "COLONY production-support cluster byte-trace".

| Helper | @asm | Role |
|--------|------|------|
| `test_colony_building_bit(bit,colony)` | 0x860E | bit `bit` of ColonyRecord bit-array (0x5DCA + colony×0xCA) |
| `test_building_or_father_bit(bit)` | 0x863E | same, current colony (idx `g_8DC6`); 9 call sites |
| `count_building_chain_present(start)` | 0x864E | walk stride-12 chain @0x8F86, count set bits (current colony) |
| `count_building_chain_present_colony` | 0x8686 | same, arbitrary colony |
| `building_chain_walk_to_top(start)` | 0x86C0 | walk chain to terminal link |
| `highest_building_chain_bit_set(start)` | 0x86E4 | highest chain link whose bit is set (else −1) |
| `sol_membership_pct()` | 0x8524 | Sons-of-Liberty % = (bells[+0xC2]·100)/threshold[+0xC6], +20 (de Witt), clamp 100 |
| `lookup_signed_2F4(idx)` | 0x8D9C | signed byte 0x2F4[idx] (−1 if ≥0x13) = chain-start building id |
| `commodity_net_minus_chain(idx,*o)` | 0x8DBC | global_amount−band_base−over_high[related] |
| `update_finished_good_from_raw(r,f)` | 0x8E84 | one raw→finished step (×2/3 when chain >2); 5 calls from 0xA3E1 |

---

## Cumulative function count

| Tier | Count |
|------|-------|
| BYTE_VERIFIED helpers (load image) | 25 |
| BYTE_VERIFIED game-system formulas | 6 |
| Game-system entry-point functions identified | 30+ |
| Total functions in VICEROY.EXE | 1,241 |

The 30+ identified entry-point functions cover **almost every player-
visible game mechanic**. The remaining 1,200 functions are mostly:
- C-runtime helpers (math, string, memory, file I/O)
- MicroProse engine helpers (graphics, sound, input)
- RTLink Plus runtime
- Per-system sub-functions (each entry-point calls 5-15 helpers)

To reach 100% per-line annotation, each of the 30 entry points would
need its 5-15 helper functions decompiled. That's ~300 functions of
real game logic plus ~900 of pure plumbing.
