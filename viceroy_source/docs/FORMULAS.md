# Byte-verified game formulas — re-implementation reference

Every formula here is traced to VICEROY.EXE bytes and locked in `tools/audit.py`
(159/159 green). Citations are file offsets. Values from external `.TXT` data files
are marked `[ext]`. This is the portable spec a re-target consumes; the chronological
proof is in `VERIFICATION_LEDGER.md`.

Shared structures: PowerRecord[p] base DS:0x8808, stride 0x13C. Active power ptr
DS:0x84FC. ColonyRecord stride 0xCA (persistent base 0x5D46). difficulty byte
DS:0x53A6 (0..4); year word DS:0x538A; turn word DS:0x538E.
`random_int(lo,hi)` = func_00C322 via `LCALL 0x181F:0x04D4` (push hi; push lo).

## Market price drift — `func_0305A8`
Per turn, for each of 16 commodities × 4 powers (commodity record stride 9 `[ext]`):
```
vol_accum[i] (PowerRecord+0x5C) += demand_term
rise:  if vol_accum[i] <= -100 * rise_factor[i]:  price_level[i] += 1 ; vol_accum -= threshold   # PRICEUP
fall:  if vol_accum[i] >= +100 * fall_factor[i]:  price_level[i] -= 1 ; vol_accum -= threshold   # PRICEDOWN
price_level[i] (PowerRecord+0x4C) clamped to [min_i, max_i]   # record +0/+1  [ext]
supply_target -= (sum_euro_supply >> 8)            # euro-supply PowerRecord+0xFC, /256
```
Step is always **±1**. rise_factor=rec+3, fall_factor=rec+4, demand=rec+5 (all `[ext]`
from NAMES.TXT @CARGO).

**Bid/ask transaction prices** (RESOLVED — resident, not overlay; the prior
"overlay-resident [TBD]" note was a misattribution — see VERIFICATION_LEDGER):
```
sell_price(good) = price_level[good] + cargo_burden[good]   # func_030566, player receives  [V]
buy_price(good)  = price_level[good] - 1                    # func_030590, player pays       [V]
```
both clamped >=0. `cargo_burden` = CARGO_FIELD(good,4) `[ext]` (NAMES.TXT @CARGO);
the buy/sell gap is the classic ±-around-price_level spread. Ported in
`src/overlay/overlay_02F3A2_031E4C.c` (market_sell_price / market_buy_price).

## Sons of Liberty / Tory — `func_02D658`, `func_008524`
```
bell_EMA   (ColonyRecord+0xC2, i32) += bells_this_turn - (bell_EMA >> 6)      # /64 decay
threshold  (ColonyRecord+0xC6, i32) -= threshold >> 6 ; threshold += 2*colonists
membership% = bell_EMA * 100 / threshold              # +20 if Jan de Witt FF ; clamp 100
rebel% drives messages:  REBELMAJORITY >=50 , REBELUNANIMOUS ==100 ,
                         TORYMINORITY <95 , TORYMAJORITY <50 , SONSUP/DOWN on 10-pt bands
tory_count = (100 - rebel%) * colonists / 100
if tory_count >= (10 - difficulty):  colony -> INEFFICIENT (overload)
```
Latch bits ColonyRecord+0x1C: 0x02 unanimous, 0x04 majority, 0x08 overload.

## Colony surrounding-tile production potential — `func_048F34`
Scans the 5×5 tiles around a colony (centre worked free), skipping tiles already
claimed by another colony's units, and tallies terrain-type buckets, then folds
them into two contiguous 16-slot output arrays: `cap[16]` @DS:0x9E58 and
`yield[16]` @DS:0x9E78 (one 32-word block, cleared each call).
```
base  = colony_level + 1 ;  tiles = base*base ;  mkt = MarketRecord[+2]
# per non-claimed tile, terrain id t (from overlay 0x181F:0x078C):
#   t==0x1B forest++ ; t==0x1C mineral++ ; t==0x18 grain+=4
#   t in 8..0x17  -> food++ , sub=t&7 ; sub<3: special++/grain+=2
#                                       sub>=3: ore++/fish++ (+cotton/sugar/tobacco)
#   t in 0..7     -> per-id cotton/sugar/tobacco/fur/fish/grain buckets
#   t==0x19/0x1A  -> hills: accum+=mkt+1, every 3 -> food+=2
# finalize:
yield[0] (food)  += (mkt+base)*food / (7-mkt)        ; cap[0] = (tiles*4) >> (mkt>1)
yield[7] (lumber) = market[+0xc]/max(1,saw) + forest*(mkt>2?8:4)   # saw = power byte [cur-0x69D6]
yield[4] (silver) += (special*2 + ore/2) / (mkt+1)
cap[11] (grain)   = (mkt+base)*base + fish/2 + grain
# + ~15 more per-slot writes (cotton/sugar/tobacco/fur/fish), each a fixed
#   market-and-base polynomial; full table in src/overlay/overlay_046D70_04C2E1.c
per-slot: cap[i] = normalize(cap[i],0,50) ; demand=market[i*2+0xe] shifts cap/yield
if colony fort flag *(0x8D4A)[+3]&4:  cap[0..7]*=2 ; cap[13..15]*=1.5 ; yield[7..15]*=2
decay each turn: yield -= cap/2 (floor 1) ; cap -= prevyield/2 (floor 1)
```
Terrain-id → bucket weights are code-resident (byte-verified); the market record
fields [+2/+7/+8/+0xa/+0xc] and per-power saw level `[cur-0x69D6]` are runtime state.

## Lost City Rumor — `func_061454`
```
outcome = max(1, random_int(1,9))      # then remapped by ~10 gates (below)
```
Gates: Scout (unit type 5) → payout bonus 1; Seasoned Scout (role 0x16) → 2 (shifts
gold/treasure rolls). Per-rumor option [0x5382]&1, tile-value thresholds 0x18/0x1b/0x1c,
roll thresholds 0xA/0x19/0x32/0x41, repeat counters [0x1DC6]/[0x1DC7] (FoY needs <7).
Outcomes: 1 trinkets, 2 burial/treasure, 3/7 gold (Σ random_int rolls ×6), 5 Fountain
of Youth (8 immigrants queued), 6 nothing, 8 vanish, 9 Cibola (treasure-train unit).
Gold credited to PowerRecord+0x2A. AI rumors resolve silently.

## Endgame score — `func_039EE2` (raw) + `func_03A9C0` (rank)

**Raw score components** (func_039EE2 @ 0x039EE2, BYTE_VERIFIED structure 2026-06-08):

```
# --- input variables ---
year     = [0x53A8] + 100*[0x53A7]          # current game year (e.g. 1620)
n_other  = count(EU powers with flag bit 2, excluding self)   # 0..3

# --- per-colonist class score (loop over all owned colonies + units) ---
score_founding = Σ per_unit:
    class == 0x1C  → +2       # expert/master-class colonist
    class ∈ {0x19,0x1A,0x1B} → +1   # skilled colonist
    else           → +4       # standard colonist

# --- founding fathers ---
score_ff_pts = 5 × count(FFs recognized by ff_recognized_7B4)   # loop i=0..24

# --- treasury ---
score_gold = PowerRecord.gold / 1000     (0 if gold < 1000)

# --- REF penalty [PowerRecord+0x18 semantics TBD] ---
score_ref = PowerRecord[+0x18] × -(difficulty + 1)    # NEGATIVE; field init=0

# --- Bolivar/SoL meter [DGROUP:0x53D0] ---
score_sol = g_bolivar_meter      # 0..100

# --- liberty pressure (when [0x5382]&8 = revolution/war active AND year < 1780) ---
score_liberty = (1780 - year) × 2     (0 if year >= 1780 or not in war)

# --- congress progress (when [0x5382]&2 and congress_progress >= 100) ---
score_congress = min(PowerRecord.congress_progress / 100, 100)

# --- total ---
raw = score_founding + score_ff_pts + score_gold + score_ref
    + score_sol + score_liberty + score_congress

# --- diplomatic isolation multiplier (when [0x5382]&8) ---
vet_mult = 100 >> n_other     # 100/1/12/25/50 for 0/1/2/3 other powers
raw = raw × (8 + (8 >> n_other)) / 8
```

**0x5382 gate bits:** &1=independence declared; &2=congress-progress active;
&8=revolution/war underway; &0x10=independence won (triggers alternate display branch).

**Rank ladder** (func_03A9C0 @ 0x03A9C0, BYTE_VERIFIED):
```
mult   = difficulty + 4 (+1 if diff>=3, +1 if diff>=4)   # 4,5,6,8,10
scaled = mult × raw / 100
rank   = largest i-1 (i in 1..24) with i*i/3 < scaled    # 24 tiers, capped at 23
display_score = scaled / 2
```
Rank-title text is `[ext]` (external message file). HOF record = func_03B2F8;
HALLFAME.DAT sorted by score field +0x26.

## Native mission convert — `func_0572E6`
```
rate = active_tribe[+2] + 2            # x2 if mission-bonus flag (CL bit 0x10)
convert if random_int(0,15) < rate     # P = min(rate,16)/16
```
tribe +2 byte is `[ext]` (TRIBE.TXT). Las Casas FF upgrades convert 0x1B→Free Colonist 0x1C.

## King tax demand — `func_034AE0`
```
target = ((difficulty & 0xFE) * 2 + 4) * (turn/400 + 1)
RAISE (when target+5 >= tax):  tax += random_int(1, difficulty) * 2
LOWER (when tax >> target):    1-in-(difficulty+1) chance; tax -= random_int(1, 5-difficulty)
tax capped at 75 (func_034318)
```
KINGTAX fund/rebate (func_0349F4): gold = max(1, 6-(cnt+1)/2 - taxfactor) * 100 → King+0x2A.

## Royal Expeditionary Force growth — `func_03E162`
```
if not war_declared ([0x5382]&1):                       # REF only grows pre-war
  budget (King record +0x22) += (difficulty*8 + 10) * 2^(eras passed)   # eras: 1600,1700,1750
  while budget >= 1800:  add 1 unit to weakest of 4 arms (inc word[arm*2 + 0x53DA]); budget -= 1800
```
Budget is the King's **tariff income** (goods_sold × tax_rate / 100, func_2D6C0), NOT
player bells. 4 arms at DS:0x53DA..0x53E0 (+ "arrived" tally 0x53E2). Landing decrements
(func_03CDA2). Arm→unit-type names `[ext]`.

## Founding-father bell economy — `func_03C322` / `func_03C282` / `func_03BFD2`
```
bells:  PowerRecord+0x0C += bells (reset on election) ; +0x0E += bells (lifetime)
cost_factor = base * 8 * prod(1.5 per era>=1600/1650/1700/1750)
              base = (difficulty+3)*2  [human]   |  (14 - difficulty)  [AI]
threshold   = (ff_count + 1) * cost_factor + 1          # halved for the first FF
elect when PowerRecord+0x0C >= threshold
select:  per category, weighted random_int(1, sum_weights) over not-yet-owned FFs
         -> pending slot PowerRecord+0x12 ; human powers get a choice dialog
```
ff_count = PowerRecord+0x14. FF category/era-weight tables DS:0x9654/0x9655 are `[ext]`
(NAMES.TXT @FATHERS). Per-FF effects = func_03BC42 (separately byte-verified).

## Combat — `func_07C2A`/`func_07D3E` (strength), `func_05CA7E` (land), `func_05B2C2` (outcome)
```
ATK = column DS:0x5236[type] * 8 (* per-type mods)        # 0x5235=DEFENSE, 0x5236=ATTACK  [ext]
DEF = ((fort_terrain_factor + 4) * base_def) / 4          # factor 0->x1, 2->x1.5, 4->x2
land modifiers (applied to ATK/DEF before roll):
  player terrain bonus +(4-difficulty) each side ; amphibious ATK*(k/3) ;
  weak-attacker DEF/2 ; artillery-vs-fort DEF/4 ; settlement DEF*2 ;
  scout ambush ATK*3/2 ; cross-terrain ATK*3/2
roll = random_int(1, ATK+DEF) ;  attacker wins iff roll <= ATK   # on MODIFIED strengths
difficulty<=1 AI shortcut: odds = ATK*8 / (DEF+1)
outcome: loser captured (convert table) or destroyed (flag [+0x3148]|=0x80);
         ships demote down hull-damage ladder; winner promotes if veteran flag 0x40 set
```
Strength columns and terrain-defense table DS:0x2F77 are `[ext]` (NAMES.TXT @UNIT/@TERRAIN).

## Native raid — `func_05BE84`
```
outcome = random_int(1,4)  -> forced to a feasible target (STORES/BURN/WREAK/GOLD/SHIP)
GOLD  = random_int(50, min(0x7FFF, colony[+0x1F] * PowerGold / (tribeByte[0x9410+t]+1) + 10))
        subtracted from victim PowerRecord+0x2A
STORES = random_int(0, min(10, colonyGoods/2)) of one commodity (floor 1), from colony+0x9A
trigger: tribe raids when alarm DS:0x54F6[(power*9+tribe)*2] >= 0x80 (zeroed after a raid;
         normal accumulation clamped to [0x20,0x60])
```
WREAK/SHIP unit removal is overlay-resident `[TBD]`. Native settlement growth: no static
growth write exists — `[TBD]` / overlay.

## Subsystems confirmed ABSENT (byte-verified by absence)
No disease/plague and no weather/storm subsystem exist in VICEROY.EXE (zero matching
strings). Colony population changes only via starvation (food deficit) and combat/raze.
