## 15. Powers and relations

Four European powers (0 = English, 1 = French, 2 = Spanish, 3 = Dutch) share the New
World with eight native tribes (power ids 4–11) and, late in the game, the King's
Royal Expeditionary Force. Per-power state is split across two parallel record
arrays — a small 52-byte "personality" record holding names and control flags, and a
large 316-byte record holding the economy, diplomacy and Congress state — plus a
handful of per-power scalar tables. Everything in this section is the substrate the
diplomacy, Congress and revolution machinery of sections 16–18 reads and writes.

### 15.1 The 52-byte personality record (base 0x540E, stride 0x34, count 4)

```c
typedef struct {                    // DGROUP:0x540E + power*0x34 (runtime BSS; loaded from NAMES.TXT / save)
    char leader_name[24];           // +0x00 NUL-terminated ("Walter Raleigh"); default for the @LEADERNAME entry box
    char country_name[24];          // +0x18 region name ("New England"); %STRING source for diplomacy popups
    uint8_t event_flags;            // +0x30 one-time-event bitfield; bit 0x40 test-and-set at 0x61870/0x61877 (burial-ground anger)
    uint8_t controller;             // +0x31 (abs 0x543F+p*0x34): 0 = human, 1 = AI, 2 = eliminated (set at 0x3C91A)
    uint16_t colony_name_seq;       // +0x32 default-colony naming counter (INC at 0x4056E, zeroed at 0x75930)
} AIPersonality;
```

The controller byte at `[0x543F + power*0x34]` is the single most-tested per-power
flag in the binary (~218 references): the turn loop skips inactive powers on it
(0x57C5/0x58AA), the parley dispatcher's human-only gate reads it (0x57F8C), the
Founding-Father cost formula branches on it (0x3C29C), and hot-seat multiplayer
writes it from the `@MULTI` checkbox dialog (section 18.6).

### 15.2 The 316-byte power record (base 0x8808, stride 0x13C, count 4)

Active record far pointer: `[0x84FC]`. The whole 4×0x13C block is serialized
verbatim as save block #8 (section 20.3).

```c
typedef struct {                    // DGROUP:0x8808 + power*0x13C
    uint8_t  tax_pct;               // +0x01 royal tax rate 0..75 (clamp at 0x3434F)
    uint8_t  rebel_sentiment_pct;   // +0x02 Sons-of-Liberty % (F3 display)
    uint32_t acquired_ff_bitmask;   // +0x07 bit f = Founding Father f owned (byte base 0x880F; reader func_00BC10 @0xBC10)
    uint16_t bells_toward_next_ff;  // +0x0C liberty-bell pool; resets on each acquisition
    uint16_t bells_per_turn;        // +0x0E bells produced last turn (zeroed at 0x2F23F each production phase)
    uint16_t crosses_per_turn;      // +0x10 immigration points per turn
    int16_t  ff_in_progress;        // +0x12 father id being worked toward; 0xFFFF = none (cleared at 0x3BD37)
    uint16_t founding_father_count; // +0x14 owned-father count (cost-curve input)
    uint16_t artillery_bought;      // +0x1E Europe artillery escalation counter (read*100 at 0x35124)
    uint16_t boycott_bitmask;       // +0x20 bit g = good g boycotted after a Tea Party (set 0x34717, cleared 0x33423 / 0x3BD45)
    int32_t  royal_money;           // +0x22 the King's REF fund; +=(8*diff+10) per turn, era-doubled; buys a REF unit at 1800
    int32_t  eu_sales_tally;        // +0x26 cumulative net European sales (0x32A9C)
    uint32_t gold;                  // +0x2A treasury, clamp 0..999999 (add helper 0x181F:0xABA)
    uint8_t  home_x, home_y;        // +0x32/+0x33 sea-lane spawn/arrival coordinates (read 0x58D72; writers 0x418D0/0x65CCB/0x74D74)
    uint8_t  relations[4];          // +0x34 relation-bit row vs powers 0..3 (matrix base 0x883C; see 15.3)
    uint8_t  treaty_respect[4];     // +0x40 treaty-respect counters (base 0x8848; see 15.4)
    uint8_t  boycott_count[16];     // +0x4C per-good back-tax accumulator (INC 0x32271 / DEC 0x32288); also market sensitivity load
    int16_t  market_pool[16];       // +0x5C European supply/demand imbalance
    int32_t  market_traded[16];     // +0x7C cumulative traded volume
    int32_t  market_eu_supply[16];  // +0xBC European stock
    int32_t  market_base[16];       // +0xFC drift accumulator (buy += at 0x323BC, sell -= at 0x32324)
    // +0x03..+0x06, +0x16..+0x1D, +0x38..+0x3F, +0x44..+0x4B unmapped (interleaved gaps)
} PowerRecord;
```

### 15.3 The relations matrix (PowerRecord +0x34, base 0x883C)

Relations between every pair of European powers are one byte at
`0x883C + subject*0x13C + target` (the code addresses it as `[bx+si-0x77C4]`,
the wrapped-displacement form of 0x883C — read at 0x58A72). Accessors:
`func_007F34` get, `func_007F96` symmetric set, `func_008000` symmetric clear
(error strings "Treaty on/off error").

| bit  | meaning | evidence |
|------|---------|----------|
| 0x01 | resolved/normalised relationship | set 0x5318F |
| 0x02 | at war | set 0x58A7B / 0x59A61 / 0x3F0E8; cleared 0x5DE98 |
| 0x08 | grievance pending | set 0x3F0D7 / 0x59AE9; per-turn transition to bit 0x01 when the +0x40 timer expires and `random_int(0,3)==0` (0x53165) |
| 0x10 | parley cooldown (16 turns; stamp word `[0x53C8+power*2] = turn+0x10` at 0x58075 / 0x5914C) | |
| 0x20 | met / contacted | |
| 0x40 | peace treaty in force | set both ways 0x59139 |
| 0x80 | privateer hidden attribution — a privateer (unit type 0x10) attack sets this instead of the war bit (guard 0x3F092, set 0x3F0A1); cleared/revealed 0x58BE1 | |

### 15.4 The treaty-respect counter (PowerRecord +0x40, base 0x8848)

A plain byte counter, **not** a second bit matrix. On signing a treaty it is
seeded `2*(6 - difficulty)`, halved if the power has Benjamin Franklin
(0x59B00–0x59B31); the AI↔AI treaty handler `func_057DC0` writes it 1/0
(0x57EC5 / 0x57F2D). While nonzero, an AI aborts planned attacks on its treaty
partner (`func_03ECF0` @0x3F163). The decrement site is unmapped (runtime).

### 15.5 Per-power scalar tables

| address | shape | meaning |
|---------|-------|---------|
| 0x940C + p | byte | AI **attitude** toward action (parley willingness input; `(attitude>>2)` vs demand at 0x58C24; target eligibility needs ≥ 8 at 0x57B1A) |
| 0x941C + p*2 | word | per-power **grievance/finance** word (grievance-score read `[bx-0x6BE4]` in the war-bit path; census writer 0x42245; REF-intervention and succession strength term) |
| 0x942C + p | byte | per-power **strength/coastal-cargo** census total (succession ranking and SMITE-factor input) |
| 0x53C8 + p*2 | word | parley-cooldown timestamp (turn + 16) |
| 0x53DA/0x53DC/0x53DE/0x53E0 | words | REF Regulars / Cavalry / Man-O-War / Artillery counts |
| 0x53D2 | word | the King/REF (or withdrawn) power id; negative = none (tested 0x23930) |
| 0x5394 / 0x5396 / 0x5398 | words | current power / render power / human (rebel) power |

Power ids 0–3 are the Europeans; ids 4–11 are the tribes in `@TRIBES` order
(4 = Inca, 5 = Aztec, 6 = Arawak, 7 = Iroquois, 8 = Cherokee, 9 = Apache,
10 = Sioux, 11 = Tupi — section 19.1). The King's power is not a fifth record: it
reuses an eliminated European slot, its id held in `[0x53D2]`.


## 16. European diplomacy

All power-to-power diplomacy runs through a single 7-kilobyte dispatcher,
`func_057F4E` (file 0x057F4E, `enter 0xD6`), driving a 48-section GAME.TXT family:
42 conversation popups (width 220, rival-leader portrait), 6 announcements/guards
(width 190, advisor portrait) and 5 support list-sections. Section names are built
at runtime by strcpy/strcat from a fragment pool at file 0x1F250+ ("MEEK" 0x1F250,
"MANLY" 0x1F255, "HELLO" 0x1F267, "AHOY" 0x1F26D, "FIRST" 0x1F272, "USA", …),
which is why the full names never appear as string literals. Conversations are
emitted through `func_06F61C` (0x1A1F:0x688), which sets speaker channel 3
(`[0x1F60]` = power B → portrait sheet MYR0..MYR3.SS); announcements go through
`func_06F5F2` (0x181F:0x652, advisor channel `[0x1F5E]` → MSS1/MSS2 portraits).

### 16.1 Entry chain

```text
unit moves onto a foreign unit/colony tile
  func_03ECF0 (unit-vs-tile confrontation resolver)  @0x3F82B ──┐
  func_046FFA (movement processor, unit flag [0x3148]&8) @0x481CB ─┤
                                                                  ▼
  func_059B90 (contact evaluator; sole dispatcher call @0x5A2CE)
                                                                  ▼
  func_057F4E(humanA, powerB 0..3, unit, neighbor table, force)
    human-only gate @0x57F8C (cmp [bp+6],4; controller [0x543F+p*0x34]==0)
    if side A is AI → silently delegates to the AI↔AI ticker func_057DC0 @0x57FA4
```

First European-to-European contact also fires woodcut 10 ("MEETING FELLOW
EUROPEANS") at 0x57FDF, and every WAR*/`@MERCENARY` emission is preceded by the war
fanfare `func_005108(4)`; first-contact fanfare id is 0x8020+power. String helper
`func_057A3A` fills `%STRINGn` from `@GREATKINGS`/`@GREATDEEDS`/`@GREATLEADER`/
`@GREATLEADER2`[power]; `func_057AA2` picks `@MEEKNESS` row 1 "request" / row 2
"demand". Leader name comes from `0x540E+p*0x34`, region name from `0x5426+p*0x34`,
and the player's title from the difficulty-rank pointer `[0x8394+diff*2]`.
Benjamin Franklin (Founding Father 19) — tested via `func_00BC10(p,0x13)` — halves
demands and prices and cancels AI hostility at 6 sites in this dispatcher
(e.g. 0x5834E).

### 16.2 Greetings (`@HELLO*`)

Key = `"HELLO"` + (not-met ? (ship ? `"AHOY"` : `"FIRST"`) : tone `"MEEK"`/`"MANLY"`);
an independent (post-revolution) counterpart selects `"HELLOUSA"`. Key pushes at
0x588CD–0x58923, emit 0x58939. Representative body (`@HELLOFIRST`):

> "Greetings, %STRING0, and welcome to {%STRING1}. We have justly claimed all of
> this land in the name of {%STRING2}, and we are here to %STRING3. Please do not
> interfere with this God-given mission."

### 16.3 Subfamily outcome tables

Row numbering is the 1-based dialog return. "Row 2" is always the second option
line of the section text quoted.

**Third-party demands — `@APOSTATES` (attack a European treaty partner) /
`@HEATHEN` (attack a tribe), key push 0x58989 / 0x589C0, emit 0x58A30:**

| option | state writes |
|--------|--------------|
| row 1 "Never! …" | none (relations with B unchanged; B's attitude worsens via the demand bookkeeping) |
| row 2 "Yes! We shall crush …" | European target: treaty bit 0x40 cleared + war bit 0x02 set vs the third party (0x58A6A/0x58A7B). Tribe target: tension hit `func_045DF2(tribe, A, +100, 0)` at 0x58A91 |

**Protests — `@PIRACY`(`USA`), push 0x58B0D, emit 0x58B45:**

| option | state writes |
|--------|--------------|
| row 1 "What pirates? We have NEVER condoned piracy!" | hidden-attribution bit 0x80 stays set |
| row 2 "Very well, we shall withdraw our privateers to Europe." | every privateer recalled to Europe and bit 0x80 cleared (0x58B7D–0x58BE1) |

**Protests — `@SIEGES`(`USA`), push 0x58C99, handler 0x58CD8:** row 2 withdraws
all units adjacent to B's colonies. **Latent bug 1:** `@SIEGESUSA`'s two option
lines are textually swapped (withdraw is row 1 in the text) but the handler acts
on row 2 for both sections — so answering "Our forces … shall stay" to an
independent power actually executes the withdrawal.

**Extortion — `@TRIBUTE`(`USA`) / `@WANTSTUFFUSA` / `@PROVOKE` / `@WARMANLY` /
`@RID`(`USA`):** the AI accumulates a demand from forces-near-colonies, scaled by
difficulty (16.5). Paying transfers gold at 0x58ED0; a goods demand moves colony
stock rows at 0x58FB4; refusal escalates to `@PROVOKE`/`@WAR*` ("Prepare for
WAR!") and the war bit. **Latent bug 2:** for a non-independent extorter the code
builds the key `"WANTSTUFF"` at 0x58F56, but GAME.TXT contains no `@WANTSTUFF`
section — only `@WANTSTUFFUSA` exists; the lookup misses.

**Treaty and standing-peace menu — `@WORTHY` (demarcation-treaty proposal,
0x5911D→0x59120), `@GIVECASH` (0x591D5), `@PEACE*`/`@OLDPEACE*`/`@PEACEUSA`
(0x59150/0x59283/0x59356 → emit 0x59395):** the peace menu carries four fixed
rows:

| option (`@PEACEMEEK` text) | outcome |
|----------------------------|---------|
| "Go in peace, {%STRING1} brothers." | end parley; treaty set both ways (bit 0x40, verb 0x181F:0xA06 @0x59139) + siege stand-down `func_057CE0` + 16-turn cooldown |
| "First you must withdraw your forces from our colonies!" | withdraw branch → `@WITHDRAW` / `@NOTWITHDRAW` / `@NOTHINGWITHDRAW` / `@MAYBEWITHDRAW` (0x593B7–0x5949B). Withdrawal price = `25*(difficulty+2)*forces`, minimum 100, doubled at war, −50 per unit, halved by Franklin |
| "How much do you value your worthless lives, heathen swine?" | threat branch → `@GIFTS` ("a gift of {%NUMBER0$} in exchange for your continued forbearance", 0x59700) or `@THREATS` ("We laugh at your feeble threats", 0x59755), possibly `@PROVOKE` war (0x5974C) |
| "We suggest an alliance." | `@MILITARY` dynamic-row menu (rows built at 0x5976D over lea 0x19FA, shown via `func_06E3D0` @0x59848) → per-target `@NOCONTACT` / `@ALREADYSMITE` / `@SMITEINDIANS` / `@SMITEEUROPE` / `@UNFORTUNATE` (0x5989D–0x59A0F). Purchase: B declares war on target T (bits at 0x59A49–0x59A71), player pays B (0x59AC7), `@MERCENARY` announcement "The {%STRING0} declare war on the {%STRING1}." (0x59AB3). `@UNFORTUNATE` fires when the treasury (+0x2A/+0x2C, 32-bit compare 0x58E1F/0x58E29) cannot cover the promise |

### 16.4 The AI↔AI ticker (`func_057DC0`)

Runs every 3rd turn per met pair when the human dispatcher delegates. Peace
resolution emits `@SIGNTREATY` ("The {%STRING0} and {%STRING1} have signed a
peace treaty.", 0x57E86, MSS2 advisor), sets bit 0x40 both ways symmetrically
(0x57EC5/0x57ED0) and seeds treaty-respect = 1; war emits `@DECLAREWAR`
(0x57F18). Willingness gates: turn ≥ 0x28 (40) at 0x57B10 and at least one of
the pair's attitude bytes `[0x940C+p] ≥ 8` (0x57B1A/0x57B24). **Latent bug 3:**
the had-a-treaty branch pushes the key `"CANCELTREATY"` at 0x57F10, which has no
GAME.TXT section (only `@CANCELPEACE` exists) — the announcement is silently lost.

### 16.5 Demand accumulation and difficulty scaling (inside `func_057F4E`)

```text
grace period   : no AI war/refusal before turn 10*(10-diff)          (0x58374)
demand value   : value * 10*(diff+8) / 100        (×0.8…×1.2)        (0x583A0)
flat surcharge : += 500*(diff+1)                                     (0x5842B)
roll term      : (diff+1)*value >> 3 feeds a 0..400 roll             (0x58409)
attitude term  : += (diff-2)*meeting_value                           (0x58580)
action gate    : random_int(1,1000) < 200*diff + 100  (10%…90%)      (0x58315)
no-action gate : decline when (attitude>>2) > demand AND
                 (demand <= 12 OR random_int(0,4) != 0)              (0x58C24)
afford gate    : demand vs 32-bit gold +0x2A/+0x2C                   (0x58E1F)
```

### 16.6 Attacking a treaty partner, movement guards, succession

- Human attacker on a treaty partner (`func_03ECF0`): `@HAVETREATY` ("We have
  signed a peace treaty… / Cancel Action. / Break Treaty.") at 0x3F130 — row 2
  sets the war bit (0x3F298), clears the treaty (0x3F2A5) and continues, then the
  `@CANCELPEACE` announcement (0x3F22F). AI attacker → `@DECLAREWAR` (0x3F262);
  human victim → `@SNEAK` "Sneak attack by the treacherous {%STRING0}!"
  (0x3F1B4). A second `@HAVETREATY` site exists in the order-issuing flow
  `func_021FF2` @0x220CE (UI trigger unmapped).
- Movement guards: `@NOWARSDURINGREV` ("Foreign colonies cannot be attacked
  during the {War of Independence}.") emitted at 0x5A912 inside the
  foreign-colony attack handler `func_05A862`, reached only under the
  war-declared gate `test [0x5382],1` @0x5A8C8; `@TRADEATWAR` at 0x5A458 and the
  Jan-de-Witt gate `@TRADEMERCANTILISM` (Founding Father 4) at 0x5A469 in the
  foreign-colony trade entry `func_05A40E`.
- `@SUCCESSION` (War of the Spanish Succession, `func_03C638` @0x3C76A, MSS2
  advisor): the whole-map power merge of section 18.7. Skipped in multiplayer
  (gate 0x3C63D).


## 17. Congress, bells, and Founding Fathers

Liberty bells produced by colonies accumulate per power toward the next session
of the Continental Congress, which appoints one of 25 Founding Fathers. Fathers
are permanent: nine apply a one-time effect on acquisition; the rest are
continuous gates tested at each affected mechanic via the owned-bit reader
`func_00BC10`. The F3 advisor report ("CONTINENTAL CONGRESS ACTIVITIES") shows
the running totals.

### 17.1 Bell accrual

The per-power production phase `func_02F052` first zeroes `bells_per_turn`
(PowerRecord +0x0E := 0 at 0x2F23F), then loops all colonies owned by the power
and runs the colony-turn processor `func_02D658` on each. Its sole Congress call
site, 0x2D6A7, invokes the driver `func_03C322(nation, bells)`: bells accrue
into `[0x84FC]+0x0C` (pool) and +0x0E (per-turn display). If no candidate is
selected (`+0x12 < 0`) the pick dialog runs; when the pool reaches the cost the
acquisition runs.

### 17.2 The bell-cost formula (`func_03C282`, file 0x03C282..0x03C322)

```text
diff = [0x53A6]; year = [0x538A]; ff = PowerRecord[power]+0x14

if power < 4 and controller [0x543F+power*0x34] == 0:   # human European
    cost = (diff + 3) * 16                              # 0x3C29C
else:                                                   # AI
    cost = (14 - diff) * 8                              # 0x3C2A9
for gate in (1600, 1650, 1700, 1750):                   # 0x640/0x672/0x6A4/0x6D6
    if year >= gate: cost += cost >> 1                  # each gate compounds x1.5
cost = (ff + 1) * cost + 1                              # 0x3C302
if ff == 0: cost >>= 1                                  # first father half price (0x3C30B)
if [0x5382] & 1:                                        # after declaring independence
    cost = diff * 1500 + 2000                           # 0x3C30D (diff*0x5DC + 0x7D0)
```

Cross-check: a human at difficulty 1 holding one father, pre-1600, gives
`(1+1)*((1+3)*16)+1 = 129` — the observed "Brewster next = 129". The F3 subtitle
"(NN in MM)" is `NN = cost - pool`, `MM = cost` (F3 body call at 0x37B08); there
is no graphical progress bar anywhere in the game.

### 17.3 The pick dialog (`@WHICHFREEDOM`)

Candidate build `func_03BFD2`: the father table is the runtime array 0x9652,
stride 6, loaded from NAMES.TXT `@FATHERS` (25 rows: +0 name id, +2 category,
+3/+4/+5 era-weight bytes). The era band is year <1600 / 1600–1699 / ≥1700
(`func_03B95A`, year gates at 0x3B963). For each of the 5 categories
(Trade/Exploration/Military/Political/Religious, names from NAMES `@FOUNDING`)
one candidate is drawn by weighted random over the un-owned fathers with nonzero
current-era weight — `budget = random_int(1, Σweights)`, subtract-walk until
≤ 0 (0x3BFFC–0x3C046). An empty category produces no row.

The dialog (width 190) lists up to five rows "FATHERNAME (Category Adviser)";
row id = category+1. It **cannot be cancelled** — a result ≤ 0 re-shows the
dialog (0x3C231). Right-click/help (`[0x1F68]`) opens the Colonizopedia FATHER
page for the candidate (0x3C24E), then re-shows. The choice is stored to
`PowerRecord +0x12` (0x3C269). The AI picks its category via `func_03BA5A`
(internals unmapped).

### 17.4 Acquisition flow (`func_03BC42`)

On reaching the cost: the owned bit — bit `(f & 7)` of
`[0x880F + nation*0x13C + (f>>3)]` — is set, and the first-owner byte
`[0x53A9 + f]` records which power got the father first. Player flow: the
`@FREEDOM` popup ("%STRING1 Founding Fathers announce that {%STRING0} has joined
the Continental Congress!") → the congress splash `func_03BB4A`: full-screen
CCBKGD.PIK (asset id 0x1253 pushed at 0x3BB6A, no frame/title/OK chrome),
portraits drawn **without** the new father, present, then the bit is set and the
screen redrawn — the new portrait "lights up" — with sound 8 and a wait-key
(0x3BC14); then the pedia FATHER page (0x3BD26). Bookkeeping: `+0x14`++,
`+0x12 := 0xFFFF`. Portraits are the 25 sheets CC-00..CC-24.SS (1:1 with
`@FATHERS` order); each owned portrait is blitted at the coordinates baked into
its own sheet frame-0 descriptor (`es:[bx+0x46/0x48]`) — positions live in the
art, not the code.

Per-father **instant** effects applied by the acquisition dispatcher:

| id | Father | one-time effect (site) |
|----|--------|------------------------|
| 1 | Jakob Fugger | clear all boycotts: PowerRecord +0x20 := 0 (0x3BD45) |
| 6 | Francisco Coronado | reveal every colony on the map (0x3BF54) |
| 9 | Sieur de La Salle | free Stockade for own colonies of size ≥ 3 (0x3BD4A) |
| 14 | John Paul Jones | spawn a free Frigate, unit type 0x11 (0x3BD8B) |
| 16 | Pocahontas | reset all native attitudes to content (0x3BDDD) |
| 18 | Simón Bolívar | revolution meter [0x53D0] += 20, cap 100 (0x3BE64) |
| 20 | William Brewster | dock pool: Petty Criminals/Indentured Servants → Free Colonists (0x3BF85) |
| 22 | Jean de Brébeuf | all own missions become expert: settlement +0x05 \|= 0x10 (0x3BE77) |
| 24 | Bartolomé de las Casas | all own Indian Converts (class 0x1B) → Free Colonists 0x1C (0x3BEB2) |

All other fathers are continuous gates tested at their own mechanic (e.g.
Washington auto-promotion 0x5C758, Franklin's six diplomacy sites, Penn crosses
×1.5 at 0xA16B, Jefferson bells +50% via owned-bit 0x0F).

### 17.5 The F3 Continental Congress screen

Reached from REPORTS → F3 (menu letter 'B') and as the post-acquisition report.
Body `func_037A20` (file 0x37A10..0x3807D); overlay on CCBKGD.PIK.

```python
regions = [
    (0,   0, 320, 10, "Title: CONTINENTAL CONGRESS ACTIVITIES", "text", "fill (0,0,320,5) c=0x90; centered"),
    (0,  10, 320, 20, "Next Session subtitle: (<FF>) (NN in MM)", "text", "text-only progress"),
    (0,  36, 320,  8, "Rebel/Tory Sentiment strip",              "text", "PowerRecord +0x02"),
    (0,  44, 320, 32, "Bell row (bells/turn)",                   "art",  "sprite 0x3F filled / 0x38 empty, span 300"),
    (0,  76, 320, 40, "REF rows (2 x 4-column count badges)",    "art",  "counts 0x53DA..0x53E8; icons runtime BSS [0x52xx]"),
    (0, 116, 320, 60, "Founding Fathers list (plain text)",      "text", "owned-father names, marker sprite 0x61"),
    (290,184, 26, 14, "OK",                                      "hit",  "dismiss"),
]  # 320x200 Mode 13h; band rects (measured; not byte-cited), text params byte-cited
```

Fonts and inks: whole body FONTTINY; title color 0x90 (pale yellow), body 0x92
(bright yellow) against the CCBKGD palette; left margin x=4, y seed 25
(0x37A4E/0x37A49), line pitch = glyph height 6 + 2 = 8 px (0x37BD1–0x37BDB).
The bell row uses the shared proportional count-strip verb 0x181F:0x236
(`func_002EE4`): `stride = (300 - sprite_w)/(count-1)` clamped to
`[1, sprite_w+1]` — many bells overlap toward 1 px pitch; fullness is filled-vs-
empty sprites, never a gauge. REF land badges at 0x37E1C (counts
[0x53DA]/[0x53DC]/[0x53E0]/[0x53DE] — the screen draws Artillery before
Man-O-War), war-stage naval badges at 0x37EFE (counts [0x53E2]..[0x53E8]); each
row is a 4-column proportional badge layout (open 0x181F:0x218, flush 0x22C,
span 300). No US-flag sprite is drawn anywhere in the F3 body or the reveal
popup (byte-verified negative).


## 18. Revolution, the King, and multiplayer

The endgame pivots on one meter, one flag word and one power id: the national
Sons-of-Liberty meter `[0x53D0]` (0..100), the game-state bits `[0x5382]`, and
the King/REF power `[0x53D2]`. Declaring independence flips `[0x5382]` bit 0,
turns the Crown's standing Expeditionary Force into an on-map power, and is won
by attrition, not by timer.

### 18.1 The revolution meter `[0x53D0]`

Initialized 0 at new game (0x75620); Bolívar adds +20 capped at 100 (0x3BE64);
the king's tax-severity score reads it (0x361F9). The endgame dispatcher at
0x2391C clamps it to 75 (0x2392A) and routes: below 75 with `[0x53D2] < 0` → the
Spanish-Succession arm; at/above 75 → the revolution handlers. In hot-seat
multiplayer (`[0x5381]&0x80`) the pre-war state is held at this 75 cap and the
auto-revolution arms are suppressed.

### 18.2 Declaring independence

| event_id | string_key | trigger | condition | options | outcomes | arms |
|---|---|---|---|---|---|---|
| declare-1 | `@ALREADYREVOLUTION` | Declare-Independence command → `func_03E984` | `[0x5382]&1` already set (0x3E988) | — | none (return) | — |
| declare-2 | `@TOOTORY` | same | `[0x53D0] < 50` (cmp 0x32 at 0x3E99E) | — | shows "Only {%NUMBER0%%} of the colonists support the independence movement… We cannot start a rebellion against the King until the {majority} is behind us."; return | — |
| declare-3 | `@MULTIREV` | same, hot-seat only | `[0x5381]&0x80` (0x3E9C5) | "Declare independence" / "Never Mind" | on confirm: `and [0x5381],0x7F` (0x3E9D3) — the game demotes to single-player exactly as the text warns | falls through to declare-4 |
| declare-4 | `@DECLARE` | same | SoL ≥ 50 | "Never! That would be treasonous! God save the King!" / "Yes! Give me liberty or give me death!" | rebel power `[0x5398] := [0x5394]` (0x3E9D8); on row 2 → `func_03DE46` (0x3EA06) | declaration |
| declare-5 | `@INDEPENDENCE` | `func_03DE46` | — | — | `[0x5382] \|= 1` (0x3E031); declaration year to `[0x53A7]/[0x53A8]` (0x3DE65); initial REF dispatch | war |

### 18.3 Game-state bits `[0x5382]` (word; save block #3)

| bit | meaning |
|-----|---------|
| 0x0001 | War of Independence declared (stage 1) |
| 0x0002 | foreign intervention active (stage 2; set by `func_03D948` @0x3DA22) |
| 0x0008 | independence WON (set 0x2F55A; gates the score bonus) |
| 0x0010 | REF-arrival phase flag (set 0x2FAE0); also gates the Congress driver off |
| 0x0020 | forced/end-stage flag (set by the dispatcher once SoL≥75+declared+intervention, and by `@FORCED` stage d) |
| 0x0080..0x8000 | the Game Options word (high-byte rows: Tutorial Hints 0x0080, Water Cycling 0x0100 inverted, Combat Analysis 0x0200, Autosave 0x0400, End of Turn 0x0800, Fast Slide 0x1000, cheat master 0x2000, Show Foreign 0x4000, Show Indian 0x8000) |

Victory: the per-turn resolver at 0x2F464 (runs while bit 0 set, bit 3 clear)
counts surviving King-owned units of types {6, 8, 0xB}; when the count falls
below the threshold (1 normally, 8 when bit 0x40 is set; 0x2F4D2–0x2F4E5) and
the intervention tally clears, `or [0x5382],8` (0x2F55A) — the rebels win, the
message built from the rebel record `[0x5398]*0x34+0x540E` (0x2F510). If
independence is won and was declared before 1780, the score gains
`(1780 - declaration_year) * 2` (0x3A609).

### 18.4 The King's power and the `@FORCED` staged advancer

The REF exists pre-war only as the four count globals (0x53DA..0x53E0), seeded
at new game by `func_0755CC` (`8d+15 / 5d+5 / 3d+2 / 6d+2` for difficulty d) and
grown by `func_03E162` (royal fund +0x22 accrues `(8*diff+10)*2^era` per turn;
at ≥ 1800 buy one unit, subtract 1800, slot by ratio). At the war transition the
Crown becomes a real on-map power whose id lands in `[0x53D2]`.

Cheat id 0x68 "Advance Revolution Status" (handler 0x2391C, DEBUG.TXT `@FORCED`)
advances one stage per invocation and documents the staging exactly:

| stage | condition | action |
|-------|-----------|--------|
| a | `[0x53D0] < 75` | set meter to 75 + create the REF power if none (0x191F:0x364 → `func_03C638`) |
| b | — | declare independence (0x191F:0x356 → `func_03DE46`, `[0x5382]|=1`) |
| c | — | next war stage (0x191F:0x348 → `func_03D948`, `|=2`) |
| d | — | `[0x5382] |= 0x20` + show the `@FORCED` text |

Stages b–d are blocked while `[0x5381]&0x80` (multiplayer).

### 18.5 The King audience screen

One renderer, `func_075352` (file 0x075352), paints the audience/tax-demand, the
loss and the win screens. Assets: backdrop **KINGLSS1.PIK** (throne room, empty
chair, blank scroll); outcome-selected foreground sheet **KING1.SS** (audience) /
KINGLOSE / KINGWIN — the king-and-dog figure, 189×187 — plus the nation banner
sheet (nation stem + digit, e.g. ENGLND1.SS, the throne-canopy banner). Variant
select at 0x75430 from the two stack args; nation prefix from `[0x5398]`
(switch 0x753BB: ENGLND/FRANCE/SPAIN/DUTCH). Callers: audience sequencer
`func_075594` (pushes 1,1 → KING1), and the King-event orchestrator `func_02F3A2`
(loss at 0x2F552, win at 0x2F6A8).

```python
regions = [
    (0,   0, 320, 200, "KINGLSS1.PIK throne room",       "art",  "full-screen backdrop"),
    (0,  12, 189, 187, "KING1/KINGLOSE/KINGWIN.SS king",  "art",  "bottom-anchored to row 199 (frame-descriptor anchor)"),
    (32,  0,  -1,  -1, "ENGLND<d>.SS canopy banner",      "art",  "nation-selected; size from sheet"),
    (232, 29,  80,  40, "speech header, 4 lines",         "text", "per-line centered on x=271.5, tops y=29..61 (measured; not byte-cited)"),
    (232, 69,  86,  72, "speech body, 9 lines",           "text", "left x=232, pitch 8 = FONTKING H+1 (measured; not byte-cited)"),
]  # 320x200 Mode 13h
```

FONTKING is loaded at 0x754F6; the pen stores (242,47) at 0x75526/0x7552C are
engine register values, not the on-screen origin — the glyph runner re-lays the
text under mode flags `[0x1F56]|=0x18` (0x75538). Body text is runtime-built by
`func_02F3A2` from the GAME.TXT tax family; the pen/ink is restored to the
FONTINTR color on exit (0x75576). Fade-in via the palette verb at 0x75553.

Tax-event branch keys (GAME.TXT, `@width=190`, speaker channel `[0x1F5C]=8` →
KING1.SS): `@KINGTAX` ("…we have graciously decided to raise your tax rate by
{%NUMBER0%%}. The tax rate is now {%NUMBER1%%}. If you wish, you may kiss our
royal pinky ring."), `@KINGRAISE` (punitive raise for demanding lower taxes),
`@KINGLOWER`, `@KINGNOTHING` ("…You may, however, kiss our royal pinky ring."),
`@MERCANTILISM`, `@PURCHASETAX`, pretexts `@KINGWIFE`/`@KINGWAR`/`@KINGNAVACT`/
`@KINGSTAMPACT` (severity-selected, section on taxation), options `@TAXOPTIONS`
("Kiss pinky ring." / "Hold '{%STRING3 Party}.'") and `@TEAPARTY`.

### 18.6 Hot-seat multiplayer

- **Unlock:** environment `SET COLONIZE=MULTI` (`getenv` pair at DGROUP
  0x2064/0x206D) → `[0x201E]=1` (0x70EDD–0x70EFB; also a CLI switch 0x70D0E),
  adding a 5th game-start menu entry (mode 4, 0x70B9F).
- **`@MULTI`** (new-game setup `func_07431E` @0x74531): "Select powers to be
  controlled by human players." — a checkbox dialog; each checked power gets
  controller `[0x543F+p*0x34] = 0` (read from the checkbox bitmask `[0x1F54]`);
  more than one human sets the hot-seat flag `[0x5381] |= 0x80` (0x745D5); none
  checked defaults to England.
- **`@MULTINEXT`** (turn loop @0x597C): between human turns the screen blanks
  and shows "^^{%STRING0} Player Turn … Press any key for {%STRING0} player's
  turn." (advisor 2), then the view power switches and re-centers.
- Consumers of `[0x5381]&0x80`: rebel sentiment clamped to 75 with
  auto-revolution suppressed (0x2391C region); `@FORCED` stages b–d blocked; the
  Spanish-Succession merge skipped (0x3C63D); `@MULTIREV` demotes the game to
  single-player on a confirmed declaration (18.2).

### 18.7 The War of the Spanish Succession merge

Handler `func_03C638` (event id 0x68 in the master event dispatcher; gate:
`[0x53D0] < 75` clamped, `[0x53D2] < 0`, single-player only). It ranks the four
powers by `3*[0x9418+p] + 2*[0x9298+p] + [0x9410+p]` (0x3C655–0x3C66B, sort
0x3C68E), picks the weakest eligible AI as ceding and the strongest as
beneficiary, emits `@SUCCESSION` ("War of the Spanish Succession ends in Europe!
{%STRING0}, ravaged by war, agrees to cede %STRING1 to the {%STRING2}. Treaty of
Utrecht specifies that all {%STRING3} possessions in the New World now fall
under {%STRING2} rule.", 0x3C76A), then rewrites every map-tile owner nibble
(0x3C7AF–0x3C80C), every unit owner (0x3C81D), every colony owner (+0x1A,
0x3C8A0), and a third owner-nibble table (0x3C8CA–0x3C8FE). Aftermath: the
ceding power's controller := 2 "eliminated" (0x3C91A) and its id stored to
`[0x53D2]` (0x3C922); the power thereafter renders as "(Withdrawn from New
World)" (LABELS `@MISC`).


## 19. Natives

Eight tribes populate the map with individually tracked villages. The engine
keeps three layers of native state: an 78-byte per-tribe record, an 18-byte
per-village record, and two per-power anger signals (a per-village alarm word
and a 0..100 tension meter). Village interaction — trade, missions, training,
tribute, war — flows through a 10-entry action menu and the GAME.TXT
`@CHIEF*`/`@VILLAGE*`/`@INDIAN*` families.

### 19.1 Tribe records and ids

TribeData: base 0x5AD6, stride 0x4E (78), 8 entries, populated at game init from
NAMES.TXT `@TRIBES`. Field +2 is the settlement-size/level factor (CHIEFKILL
byte-trace at 0x4AB24); the byte at +3 carries the **tribe-dead bit 0x80** — the
cheat-menu tribe list tests `[0x5AD9 + i*0x4E] & 0x80` to grey out dead tribes.
Village owner ids 4..11 follow `@TRIBES` order:

| id | tribe | gift good | level | sprite |
|----|-------|-----------|-------|--------|
| 4 | Incas | Jewelled Relics | 3 | 97 |
| 5 | Aztecs | Gold Bars | 2 | 149 |
| 6 | Arawaks | Bone Jewelry | 1 | 54 |
| 7 | Iroquois | Wood Carvings | 1 | 87 |
| 8 | Cherokee | Turquoise | 1 | 67 |
| 9 | Apache | Beads | 0 | 111 |
| 10 | Sioux | Beads | 0 | 118 |
| 11 | Tupi | Gems | 0 | 71 |

(Reserve name-only tribes — Maya, Toltecs, Kiowa, … — follow in `@TRIBES` but
never instantiate.) Tribe indices 0/1 = Inca/Aztec select the special first-
contact woodcuts below.

### 19.2 The village array (base 0x54EC, stride 0x12)

```c
typedef struct {                    // DGROUP:0x54EC + v*0x12
    uint8_t map_x, map_y;           // +0x00/+0x01
    uint8_t owner;                  // +0x02 tribe/power id 4..11 (scans at 0x37638/0x45D11/0x46078)
    uint8_t flags;                  // +0x03 bit 0x04 capital (set 0x66225, doubles value 0x7DCA);
                                    //        bit 0x02 "already taught" (set 0x4A78A); bit 0x01 write-only
    uint8_t population;             // +0x04 size (CHIEFKILL input)
    uint8_t mission;                // +0x05 0xFF none; low nibble = owning power; bit 0x10 expert-mission
                                    //        doubler (Brébeuf; set 0x48C81, tested 0x57300)
    uint8_t growth_counter;         // +0x06 (runtime cross-ref; no static reader)
    uint8_t trespass;               // +0x07 escalation counter (0xFE on trespass 0x4A337; bumped on trade 0x5C3F2)
    uint8_t last_bought;            // +0x08 cargo id of last good bought
    uint8_t last_sold;              // +0x09 write-only in the static image (init 0xFF at 0x46EB6)
    uint16_t alarm[4];              // +0x0A per-European-power anger words (indexed settlement*9+power @0x4734E)
} NativeSettlement;
```

The per-power **anger words** at `+0x0A + power*2` drive the war state at
alarm ≥ 128 (raid scan 0x4734E; placement gates 0x4CAD7, 0x53D4E). A parallel
0..100 **tension table** at 0x5B1C (stride 39 words per village row, only
columns 0..3 used) is written solely by the applier `func_045DF2`:
`tension += delta`, clamped [0,100], with positive deltas halved for the French
power (0x45E21) and for Pocahontas owners (0x45E30); thresholds 75 = hostile,
100 = war (0x45E9E/0x45EB2). Notable deltas: ±1 per-turn drift, +1/+2/+3
trespass, −4 successful trade (0x5C41E), +100 incite/burial-ground desecration
(0x486F8/0x61B84), mission established negative (clamped so tension ≤ 70).

### 19.3 First contact

First contact with a tribe (handler `func_056C3E` @0x56DA6) shows woodcut 3
"MEETING THE NATIVES" — or woodcut 4 "THE AZTEC EMPIRE" (tribe 1) / woodcut 5
"THE INCA NATION" (tribe 0), with tune cues 0x33/0x35/0x36 — then the
`@INDIANWELCOME` treaty offer:

> "The {%STRING0} tribe welcomes you. We are a glorious nation of
> {%NUMBER0 %STRING1}. To celebrate our friendship, we generously offer you the
> land you now occupy as a gift. Will you accept our treaty and live with us in
> peace as brothers?"  — Yes / No

### 19.4 Village visits

Entering a village (woodcut 7 on the first) offers the NAMES `@ACTIONS` menu:
Trade With Village · Enter Hostile Village · Establish Mission · Denounce Heresy
of %Fs Mission · Live Among The Natives · Ask to Speak With Chief · Incite
Indians · Demand Tribute · Attack Village · Cancel Action.

- **Supply/demand**: the trade pricing, the "especially interested in …" line
  and the `@INDIANBEGFOOD`/`@INDIANGIVEFOOD` food events are all driven by the
  village supply/demand routine `func_048F34` — section 10 documents it in
  full (phases, capital ×2 boost, consumers).
- **Training** ("Live Among The Natives"): only outdoors skills are learnable;
  Petty Criminals are refused (`@LEARNCRIMINAL`); masters are refused
  (`@LEARNMASTER`); each village teaches once — the grant at 0x4A782 writes the
  profession into the unit's expertise byte and stamps the village flag +0x03
  bit 0x02 (`@LEARNALREADY`). Unskilled colonists succeed on
  `random_int(1,1000) ≥ 200*difficulty + 100` (0x4A72C), i.e. 90/70/50/30/10 %.
- **Chief audience** (`@CHIEFHOWDY`/`@CHIEFGIFT`/`@CHIEFAREA`/`@CHIEFGUIDES`):
  gift beads scaled by tribe, map-area reveal for scouts; `@CHIEFKILL` is the
  taboo execution outcome of razing.

### 19.5 Missions

`Establish Mission` places a mission: village byte +0x05 = owning power, with
bit 0x10 (expert) set when the founding power has Jean de Brébeuf
(`has_father(0x16)` gate at 0x48C71 → `or [bx+5],0x10` at 0x48C81); acquiring
Brébeuf retroactively upgrades all own missions (0x3BE77). Conversion
(`func_0572E6`, "INDIANSCONVERT"): each eligible turn rolls `random_int(0,15)`
against `threshold = TribeData[+2] + 2`, doubled by the expert bit — success
spawns an Indian Convert (class 0x1B) at the colony (0x57374). A destroyed
mission or expelled missionary applies a computed positive tension delta
(0x57267).

### 19.6 Attitude and anger displays

The village attitude phrase is built from a colonial-presence score banded at
cutoffs −5 / 0 / 10 into Content / Uneasy / Restless / Angry (builder
0x48B62–0x48B90); War is the separate alarm ≥ 128 state. The per-power
European attitude byte `[0x940C+p]` is a distinct diplomacy signal (section 15.5).
Pocahontas resets all village attitudes to content on acquisition and halves
subsequent tension rises. Debug bit 0x01 of `[0x894]` ("Anger & Friction
Levels") overlays the live anger word — white number
`[v*0x12 + 0x54F6 + 2*viewpower]` at village pixel (+2,+9) (0x4241) and appends
eight per-tribe rows to the map info panel (0x44303).

### 19.7 Village destruction (and the Kill-Indians cheat)

Razing (`func_04A7CA`) rolls a village-escape check `random_int(0, 40*scout+100)`
(scout = Seasoned-Scout attacker bonus) with re-rolls biased by size; on a raze
the treasure is `(Σ 3×random_int(0,10-diff)) * random_int(0,6) * 4 * (tier+1)`,
credited straight to the attacker's gold (+0x2A add/adc at 0x4AB66). The
cheat-menu item 0x67 "Kill Indians" (0x23BDC) exposes the same internals: it
builds the live tribe list from TribeData (stride 0x4E, dead bit 0x80 at +3) and
calls `func_046FC2`, which destroys every village whose owner equals tribe+4 —
confirming the owner-id convention and the destroy path used by combat.


## 20. Turn flow and persistence

A turn is one pass of the resident loop `func_005760` (file 0x5760): for each of
the four European powers in strict index order it runs King → Orders →
Production → Diplomacy → Periodic, then a once-per-turn year-advance and
autosave tail. Natives are not a separate top-level pass — their AI runs inside
the per-power processing. Saves are verbatim memory dumps: 43 raw DGROUP blocks
behind a "COLONIZE" magic, no compression, no reordering.

### 20.1 The per-power phase chain

| phase | function | contents |
|-------|----------|----------|
| 1 King/mercenary | `func_03E664` (call 0x58E2; gated `[0x5382]&1==0`) | peacetime mercenary roll (0x3E707) and King events |
| 2 Orders/movement | `func_024A48` (0x58E7) | per-unit orders pump; REF fund accrual `func_03E162` rides here (via 0x24B42); AI unit moves `func_04E2D6` with the contact evaluator `func_059B90` firing diplomacy on unit-vs-tile encounters (section 16.1) |
| 3 Production | `func_02F052` (0x59EA) | zeroes bells/turn (+0x0E at 0x2F23F); per-colony turn processor `func_02D658` — yields, food/starvation/spoilage report popups, school teaching, bell accrual into the Congress driver `func_03C322` (0x2D6A7) |
| 4 Diplomacy | `func_052F7E` (0x5A37) | king-action dispatch `func_034C24` (tax raises are event-driven here, not periodic); AI diplomacy |
| 5 Periodic/congress | `func_02F3A2` (0x5AE5) | colony stats `func_042138`, Founding-Father congress `func_03B2F8` (gated `[0x5382]&0x10==0`), King defeat/victory screens (0x2F552/0x2F6A8) |

The **market drift** is an end-of-turn phase of its own: the end-of-turn
processor `func_0755CC` calls the drift driver `func_036574` at 0x757B0, which
clears the per-power 16-good accumulators and runs the four-power loop into the
drift function `func_0305A8` (price base relaxes by `(base + Σ clamped trade)/256`
per good). Immigration crosses (`func_035D9A`) run immediately after the price
recompute (0x363E2), followed by the religious-unrest arrival chain (`@UNREST`).

Year cadence (loop tail 0x5A9D–0x5ACC): `inc [0x538E]` every turn; before 1600
one turn = one year; from 1600 the season word `[0x538C]` toggles Spring/Autumn
and the year steps every second turn; start 1492, forced-end check at 1725
(0x5BB5 sets `[0x82B]=1`).

### 20.2 Autosave

Gated by Game-Options bit 0x0400 (row 5 "Autosave") and suppressed while the
autoplay/suppressor flag `[0x826]` is nonzero (gate 0x5AD7). Turn-loop consumers
0x58D7/0x5A29 call the helper at 0x5642: a **rolling autosave to slot 9 every
turn**, plus a **decade autosave to slot 8** when the year is divisible by 10 —
matching the manual's "most recent save in the last slot, previous decade save
beside it". A further end-game save fires near the forced 1725 end (0x5BDB,
gated `[0x82B]`). Manual slots are chosen in the `@SAVEGAME` dialog; filenames
are `COLONY<slot>.SAV` (stem at file 0x1FA82, extension at 0x1FA89).

### 20.3 The save file (serializer `func_0734F8`, loader `func_073BB0`)

Header: the 8 bytes `"COLONIZE"` + 0x1A, mode "wb". Body: **43 raw DGROUP
blocks**, each a single `fwrite(base,1,size)` — on-disk offset = sum of the
preceding block sizes; within a block, layout = the runtime struct. The loader
is a 1:1 mirror (43 `fread`s), proving no compression or field reordering.
Principal blocks:

| # | base | size | content |
|---|------|------|---------|
| 1 | `[0x081A]` | 2 | save format/version word |
| 2 | 0x853A | 4 | map width + height |
| 3 | 0x5380 | 0x8E | **game-globals block**: `[0x5382]` game flags + Game Options word, `[0x5384]` colony-report options, `[0x5386]` sound mirror, season/year/turn 0x538A–0x538E, counts 0x539A–0x539E, difficulty 0x53A6, revolution meter 0x53D0, REF power 0x53D2, REF counts 0x53DA–0x53E0 |
| 4 | 0x540E | 0xD0 | 4× AIPersonality (stride 0x34) |
| 6 | 0x5D46 | n·0xCA | ColonyRecords |
| 7 | 0x3144 | n·0x1C | UnitRecords |
| 8 | 0x8808 | 0x4F0 | 4× PowerRecord (stride 0x13C) |
| 9 | 0x54EC | n·0x12 | NativeSettlements |
| 10 | 0x5AD6 | 0x270 | TribeData |
| 13 | 0x9298 | 4 | per-power colony count |
| 15–23 | 0x940C … 0x942C | 4–8 each | per-power attitude / AI / economy word tables (incl. 0x940C, 0x941C, 0x942C) |
| 39–43 | 0x8540 / 0x853E / view words | 2 each | current colony, map cursor, viewport/scroll |

Because block 3 carries all three option words, every options dialog survives
save/load; the sound toggles `[0xA0]/[0xA2]/[0xA4]` are re-expanded from
`[0x5386]` on load (0x74249). The debug bitfield `[0x894]` is in **no** block —
debug options are session-only. No configuration file exists.

### 20.4 The music scheduler

The background rotation pump `func_004EE6` runs from the input-idle loops each
turn-idle: it skips unless background music `[0xA2]` (or a one-shot `[0x9E]`) is
on, polls the driver ("playing?" id 8), honors a forced-next tune `[0x94]`, then
seeds the RNG from the tick clock `[0x83A8]` and rolls a tune index inside a
state window — **peace** (`[0x5382]&1` clear): folk tunes 1–12 with a 1-in-9
excursion into 13–23; **War of Independence**: independence/military tunes 13–18
with a 1-in-5 excursion back to folk. Event classes requested by game code
(war fanfare, native themes 0x33/0x35/0x36, etc.) preempt via `[0x9A]`. The
index→id map is `func_004DF8`; a re-roll avoids repeating the current tune
`[0x96]`.


## 21. Random numbers

Every roll in the game comes from one Microsoft C 6.0 linear congruential
generator in the resident image, wrapped by a range-scaling helper that the
overlays reach through a single thunk. With the seed and the call sequence, all
game randomness is exactly reproducible — the colony-screen building layout is
replayed from its seed on every screen open.

### 21.1 The generator

```text
srand(seed)      @0x103C2 : stores only the LOW 16 BITS of the argument —
                            mov [0x28EE],ax ; mov word [0x28F0],0
                            (effective seed space is 16-bit)
rand()           @0x103D4 : seed32 = seed32 * 0x343FD + 0x269EC3    ; MSC 6.0 constants
                            return (seed32 >> 16) & 0x7FFF          ; AND AH,0x7F
                            seed dword at DGROUP:0x28EE/0x28F0
random_int(lo,hi)@0x0C322 : r = rand()                              ; 15-bit
                            return lo + ((r * (hi - lo + 1)) >> 15) ; inclusive range
                            reached via overlay thunk 0x181F:0x4D4
```

The multiplier 0x343FD (= 214013) occurs exactly once in the binary (byte pair
`FD 43` at 0x103D5); the `>>15` is implemented as a byte swap plus seven
SAR/RCR pairs.

### 21.2 Known seeded subsystems

| subsystem | seeding / roll | site |
|-----------|----------------|------|
| Colony building placement | per-colony deterministic seed `srand((colony_y<<8) + colony_x + dword[0x8D80])` (seed helper `func_009726`, 0x181F:0xD62, sole caller 0x25D3A); then per-plot `random_int(0, count[cat]-1)` shuffle with occupied-retry — a colony always lays out identically; `[0x8D80]` is a per-session boot value (runtime) | 0x9736 / 0x25DBF |
| Combat resolution | single inclusive roll `random_int(1, ATK+DEF)`; attacker wins if roll ≤ ATK; separate 50% ambush coin `random_int(0,1)` | 0x5B849 / 0x5D188 |
| Music shuffle | pump re-seeds from the tick clock `[0x83A8]`, rolls the tune-index window, re-rolls on repeat | `func_004EE6` |
| Founding-Father pick | weighted walk `budget = random_int(1, Σ era-weights)`, subtract until ≤ 0 | 0x3C0DB / 0x3C035 |
| Trade-route default name | new route's default name = colony name + a random `@TRADENAMES` word (collision appends " A") | `func_0610B0` |
| King tax attempt | difficulty roll `random_int(1, diff+1)` gate on the raise | 0x34B25 |
| Native raid outcome | gate `random_int(1,12)` + base outcome `random_int(1,4)` | 0x5BEFD / 0x5BF35 |
| Tory uprising | fires when `random_int(0, diff+1) != 0` — probability `(diff+1)/(diff+2)` | 0x3CADD |
| Mission conversion | `random_int(0,15)` vs `tier+2` (doubled by the expert bit) | 0x5730A |
| Lost City Rumor gold | ruins `10*3d8` (0x61770); big treasure `2*4d10` (0x617C0) | `func_061454` |
