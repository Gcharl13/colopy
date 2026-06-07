# UI Dialogs — Catalog

Every dialog box in VICEROY.EXE, with trigger function, visual
composition, and example renders.

The dialog framework is `func_06F0F4` (BYTE_VERIFIED via strings
CHECKBOX, DEFAULT, OPTIONS, PROMPT, SMALLFONT, TEXT, WIDTH).

---

## Dialog composition (universal)

Every dialog is built from these layers:

1. **Background tile**: WOODPANL.PIK or WOODPAN2.PIK tiled across the
   dialog rectangle.
2. **Frame**: WOODFRAM.SS sprites at the four corners + four edges.
3. **Title strip**: NAMEPLAT.SS at the top of the rectangle.
4. **Body content**: assembled from glyphs (FONTSMAL.FF / FONTTINY.FF)
   plus optional sprite previews (CC-NN.SS for FF dialogs, ICONS.SS
   for unit dialogs).
5. **Buttons**: text rendered in FONT-NP.FF (disabled) or FONTSMAL.FF
   (enabled).

The framework function (`func_06F0F4`) takes a dialog descriptor
(width, height, options list) and lays everything out automatically.
Per-dialog handlers fill the body content and route button clicks.

---

## Dialog catalog

Each entry: dialog name, trigger function, visual notes.

### Game-event dialogs

| Dialog | Trigger function | Visual content |
|--------|------------------|----------------|
| **King tax demand (raise)** | `func_034AE0` | KING1.SS or KING2.SS portrait + "the king demands +N% tax" message |
| **King tax demand (lower)** | `func_034AE0` (KINGLOWER branch) | Same portrait + "the king lowers tax" message |
| **King event (general)** | `func_02F052` (KINGTAX/REFIT) | KING.SS + situational text |
| **King event 2** | `func_0349F4` (KINGTAX2) | Variant |
| **Native village raze (CHIEFKILL)** | `func_04A7CA` | IND<tribe>A0.SS portrait + "you destroyed the village; gained X gold" |
| **Native gift / tribute** | `func_0572E6` | INDIANCITY/INDIANGIVEFOOD/INDIANGIVESTUFF/INDIANSCONVERT messages |
| **Diplomatic SMITE** | `func_057F4E` | Tribe portrait + SMITEINDIANS dialog with Y/N |
| **Native warpath** | `func_04B036` | INDIANWARFARE / INDIANWARPATH2 |
| **Tribe attitude** | `func_04B308` | HAPPY/MEDIUM/SAVAGE/MADATSHIPS message + portrait |
| **Native trade haggling** | `func_049600` | BUY0/BUYWHICH + 4-way BADHAGGLE0..3 outcomes |
| **Native learning** | `func_04A426` | LEARN/LEARNSTAY/MASTER/SLOW + colonist sprite |
| **Native extortion** | `func_04AC00` | EXTORTLAUGH/EXTORTNO/EXTORTPOOR/EXTORTSTUFF |
| **Scout interactions** | `func_05A20E` | SCOUTCOLONY/LOSTOURSCOUTS/LOSTTHEIRSCOUTS |
| **Native raid (6 outcomes)** | `func_05BE84` | Per-outcome message + sound (one of WREAK/STORES/BURN/SHIP/GOLD/NOTHING) |
| **Colony burn / capture** | `func_05CA7E` | BURNED/BURNED2/BURNED3 + portrait, EUROPEWIN/EUROPELOSE |
| **Treasure transport (King's Galleon)** | `func_05C878` | KING1.SS + CASHTREASURE/KINGGALLEON/LOOTCASH |
| **Combat resolution** | `func_05B2C2` | DEMOTE/COLONISTCAPTURE/CARGOCAPTURE/SHIPDAMAGE/ARTILLERY/VETERAN |
| **Ship combat** | `func_03FDDE` | LANDFALL/LANDFALL2/LANDFIRST/SAILHOME/SHIPCOMBAT/SHIPLAKE |
| **REBELUP / REBELDOWN** (SoL change) | `func_03E844` | "your colony has 50% rebel sentiment" |
| **Independence declaration** | `func_03DE46` + `func_03E984` (guard) | DECLARAT.PIK + DEC-LOW*/UPP* letters spelling "Declaration..." |
| **Intervention (French aid)** | `func_03D948` | INTERVENTION message |
| **Diplomatic actions menu** | `func_03ECF0` | CANCELPEACE/DECLAREWAR/HAVETREATY/WHACKINDIANS options |

### Screen-level dialogs (full-screen)

| Screen | Background | Trigger |
|--------|-----------|---------|
| Title screen | OPENING.PIK | OPENING.EXE startup |
| Main menu | OPENMENU.PIK | After title |
| Customize | CUSTOMIZ.PIK | New game options |
| Difficulty select | DIFFICUL.PIK | New game flow |
| Nation select | NATIONS.PIK | New game flow |
| Colony screen | COLONY.PIK | Click on colony tile |
| Europe screen | EUROPE.PIK | Sail ship to Europe |
| Continental Congress | CCBKGD.PIK + CC-NN.SS portraits | FF acquired event |
| Declaration of Independence | DECLARAT.PIK + DEC-LOW*/UPP*.SS letters | Independence flow |
| Reports (9 variants) | REPORT1..9.PIK | Reports menu |
| Scenario select | LEVN0001..0010.PIK thumbnails | Custom scenario load |
| Endgame king-loses | KINGLSS1.PIK / KINGLSS2.PIK | Independence won |
| Score screen | SCORE01..24.SS plates | Game end |
| Closing cinematic | CLOS-BKG.PIK + CLOS-*.SS | CLOSING.EXE |

---

## Dialog framework deep-dive

The framework function `func_06F0F4` accepts a dialog descriptor with:
- `WIDTH`, `LENGTH` (TEXT) — geometry
- `PROMPT` text + button options
- `DEFAULT` button selection
- `CHECKBOX` items (multi-select)
- `SMALLFONT` flag (use FONTTINY vs FONTSMAL)

Returns selected option index. Per-dialog handlers wrap this with
context-specific data (king portrait, settlement info, etc.).

---

## Verification

Pixel-verifying that the rendered dialogs match DOSBox screenshots is
Phase G work (the playable-rebuild smoke test). The expected
visual_diff threshold is < 5 pixels of disagreement per dialog.

---

## Open work

- Annotate the framework function `func_06F0F4` line-by-line (Phase D).
- For each catalog row, identify the BYTE_VERIFIED .asm line that
  triggers the dialog.
- Capture DOSBox reference screenshots into
  `verification/dosbox_screenshots/`.
- Build `tools/visual_diff.py` (Phase B-extension) that compares
  rendered output to the reference.
