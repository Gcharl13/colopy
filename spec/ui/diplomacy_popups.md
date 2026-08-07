# European (power-to-power) diplomacy popups

> **Layer 2 — UI Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R.
> The 48-section GAME.TXT diplomacy family (42 `{width:220}` conversations + 6
> `{width:190}` announcements/guards + 5 support list-sections). Decoded
> 2026-07-30; key-fragment strings, treaty-bit sites, emit sites, and the
> missing-section negatives re-verified against raw bytes. Companion:
> `spec/systems/diplomacy.md` (mechanics; §2 correction → RULINGS.md
> 2026-07-30).

## 1. Architecture (B)
- **One dispatcher owns the family: `func_057F4E`** (page 0x0F, 7151 B,
  `enter 0xd6` @0x057F4E). Args: (human power A, power B 0–3, initiating
  unit, neighbor-table ptr, force flag). **Section names are built at
  runtime** by strcpy/strcat from a DGROUP fragment pool (file 0x1F250+:
  "MEEK" 0x1F250, "MANLY" 0x1F255, "HELLO" 0x1F267, "AHOY" 0x1F26D,
  "FIRST" 0x1F272, "USA", …) — which is why full names are absent from
  strings.json.
- Entry chain: contact evaluator `func_059B90` (sole caller @0x05A2CE) ←
  `func_03ECF0` (unit-vs-tile resolver) @0x03F82B and `func_046FFA`
  (movement processor, unit flag `[0x3148]&8`) @0x0481CB. If side A is AI,
  the dispatcher silently delegates to the AI↔AI ticker `func_057DC0`
  @0x057FA4 — popups only run for the human.
- **Emit wrappers**: conversations via `0x1a1f:0x688` = `func_06F61C`
  (sets speaker channel 3 `[0x1F60]` = power B → portrait sheet
  **MYR0..MYR3.SS**; returns 1-based row), e.g. @0x058939; announcements
  via `0x181f:0x652` = `func_06F5F2` (advisor channel `[0x1F5E]` →
  MSS1/MSS2 portraits).
- **Relation state = the 4×4 matrix at PowerRecord+0x34** (DG 0x883C, row
  stride 0x13C) via `func_007F34` get / `func_007F96` symmetric set /
  `func_008000` symmetric clear. Bits: 0x02 war · 0x08 grievance-pending ·
  0x10 parley cooldown (16 turns, stamp `[0x53C8+p*2]`) · 0x20 met ·
  0x40 peace treaty · 0x80 privateer hidden attribution.
- **PowerRecord+0x40 = treaty-respect counter** (plain byte, NOT a bit
  matrix — see RULINGS.md 2026-07-30): seeded `2·(6−difficulty)` (halved
  with Franklin) @0x059B00–0x059B31; while nonzero an AI aborts attacks on
  its treaty partner (`func_03ECF0` @0x03F163). Decrement site TBD.
- Helpers: `func_057A3A` fills `%STRINGn` from `@GREAT<KINGS|DEEDS|LEADER|
  LEADER2>[power]`; `func_057AA2` picks `@MEEKNESS` row 1 "request" / 2
  "demand". Leader name = DG `0x540E+p*0x34`; region name = `0x5426+
  p*0x34`; player title = difficulty-rank ptr `[0x8394+diff*2]`.
  **Franklin (FF #19)** via `func_00BC10(p,0x13)` halves demands/prices
  and cancels AI hostility at 6 cited sites. War fanfare `func_005108(4)`
  before every WAR*/MERCENARY emit; first-contact fanfare id 0x8020+power.
- First European contact also fires **woodcut 10** @0x57FDF
  (`spec/ui/woodcuts_and_intro.md`).

## 2. Subfamilies (all B — full cites in the section table §3)
- **Greetings `@HELLO*`**: key = "HELLO" + (not-met ? ship?"AHOY":"FIRST"
  : tone "MEEK"/"MANLY"); independent power → "HELLOUSA". %STRINGs =
  rank+leader, region, @GREATKINGS, @GREATDEEDS.
  **Tone predicate READ 2026-08-07z14** (func_057F4E @0x5881F): B speaks
  **MEEK** when B's per-power strength word `[0x941C + power·2]` is BELOW the
  player's, **MANLY** when `>=` (`cmp; jae` → MANLY). It is a
  military-strength comparison, not attitude — the same suffix drives
  `@PEACE*`/`@WAR*`/`@OLDPEACE*`. The port compares a force proxy (Σ unit
  combat + 3·colonies) as a stand-in for `[0x941C]`.
- **Third-party demands `@APOSTATES/@HEATHEN` (+USA)**: AI asks the player
  to attack a treaty partner (European) or a tribe. Row 2 accepts →
  treaty cleared + war bit set (European @0x058A6A/@0x058A7B) or tribe
  attitude hit `func_045DF2(t,A,100,0)` @0x058A91.
- **Protests**: `@PIRACY(USA)` (privateer attribution bit 0x80; row 2
  recalls all privateers to Europe and clears the bit @0x058B7D–0x058BE1);
  `@SIEGES(USA)` (units besieging B's colonies; row 2 withdraws them —
  **latent bug: @SIEGESUSA's rows are textually swapped but the handler
  acts on row 2 for both**, so answering "our forces shall stay" to an
  independent power executes the withdrawal @0x058CD8ff).
- **Extortion `@TRIBUTE(USA)/@WANTSTUFFUSA/@PROVOKE/@WARMANLY/@RID(USA)`**:
  demand accumulates from forces-near-colonies (difficulty-scaled per
  diplomacy.md §3). Pay → gold transfer @0x058ED0; goods demand → colony
  stock rows moved @0x058FB4. **Latent bug: the non-USA "WANTSTUFF" key
  has no GAME.TXT section** (key built @0x058F56; only @WANTSTUFFUSA
  exists).
- **Treaty & standing-peace menu `@WORTHY/@GIVECASH/@PEACE*/@OLDPEACE*/
  @PEACEUSA`** with outcome popups `@WITHDRAW/@NOTWITHDRAW/
  @NOTHINGWITHDRAW/@MAYBEWITHDRAW/@GIFTS/@THREATS/@PROVOKE` and the
  alliance branch `@MILITARY` (dynamic rows) → `@NOCONTACT/@ALREADYSMITE/
  @SMITEINDIANS/@SMITEEUROPE/@UNFORTUNATE/@MERCENARY`. Treaty set both
  ways @0x059139 (`0x181f:0xa06`) + siege stand-down `func_057CE0`;
  withdraw price = `25·(diff+2)·forces` (min 100, ×2 at war, −50/unit,
  Franklin ÷2); alliance purchase = B declares war on target T (bits
  @0x059A49–0x059A71) + player pays B @0x059AC7.
- **AI↔AI ticker `func_057DC0`**: every 3rd turn per met pair; peace →
  `@SIGNTREATY` (MSS2) + bit 0x40 both ways + respect=1; war → `@DECLAREWAR`
  — **latent bug: the had-treaty branch pushes key "CANCELTREATY"
  @0x057F10 which has no GAME.TXT section** (only @CANCELPEACE exists).
- **Attacking a treaty partner** (`func_03ECF0`): human attacker →
  `@HAVETREATY` (row 2 breaks treaty and continues) → `@CANCELPEACE`
  announcement; AI attacker → `@DECLAREWAR`; human victim → `@SNEAK`.
  War bit @0x03F298, treaty cleared @0x03F2A5. Second `@HAVETREATY` site
  in `func_021FF2` @0x0220CE (order-issuing flow; UI trigger TBD).
- **Movement guards**: `@NOWARSDURINGREV` @0x05A916 (revolution active,
  entering foreign human colony); `@TRADEATWAR` @0x05A458 + the
  `@TRADEMERCANTILISM` Jan-de-Witt gate (FF #4) @0x05A469 in the
  foreign-colony trade entry `func_05A40E`.
- **`@SUCCESSION`** (`func_03C638` @0x03C76A, MSS2): War-of-the-Spanish-
  Succession power merge — whole-map owner-bit rewrite @0x03C799–0x03C7D1.
  Skipped in multiplayer (@0x03C63D).

## 3. Section → invoker table (B)
See `docs/`-grade cites: all 48 sections mapped to their key-push and emit
sites in the 2026-07-30 decode. Highlights: @HELLO* keys @0x0588CD–
0x058923 → emit @0x058939; @APOSTATES @0x058989/@HEATHEN @0x0589C0 → emit
@0x058A30; @PIRACY @0x058B0D → @0x058B45; @SIEGES @0x058C99 → @0x058CD8;
@TRIBUTE @0x058E7D → @0x058EB8; @WANTSTUFFUSA @0x058F56 → @0x058F95;
@PROVOKE @0x058FEE/@0x05974C; @RID @0x059077 → @0x0590A3; @WORTHY
@0x05911D → @0x059120; @GIVECASH @0x0591D5; @WAR* @0x059222/@0x059516 →
@0x059274/@0x05957E; @PEACE*/@OLDPEACE*/@PEACEUSA @0x059150/@0x059283/
@0x059356 → @0x059395; withdraw family @0x0593B7–@0x05949B; @GIFTS
@0x059700; @THREATS @0x059755; @MILITARY (lea 0x19FA @0x05976D, shown via
`func_06E3D0` @0x059848); smite family @0x05989D–@0x059A0F; @MERCENARY
@0x059AB3; @SIGNTREATY @0x057E86; @DECLAREWAR @0x057F18/@0x03F262;
@HAVETREATY @0x03F130/@0x0220CE; @SNEAK @0x03F1B4; @CANCELPEACE @0x03F22F;
@NOWARSDURINGREV @0x05A912; @TRADEATWAR @0x05A454; @SUCCESSION @0x03C76A.

## 4. Open items (exact trace sites)
1. Respect-counter (+0x40) decrement — watch `DG 0x8848+a*0x13C+b`
   per turn live.
2. Missing-section lookup behavior ("CANCELTREATY"/"WANTSTUFF") — trace
   `func_06F8FA` miss path.
3. `[0x925C+p*0x13]` PIRACY-gate table writers.
4. `func_021FF2` callers (second @HAVETREATY) + unit order `[0x314C]=5`.
5. `func_03C638` scheduler (@SUCCESSION) + its %STRING0 setter @0x03C721.
