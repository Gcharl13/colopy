# Byte-verified game formulas — re-implementation reference

Every formula here is traced to VICEROY.EXE bytes and locked in `tools/audit.py`
(96/96 green). Citations are file offsets. Values from external `.TXT` data files
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
from NAMES.TXT @CARGO). Bid/ask spread for buy/sell is overlay-resident `[TBD]`.

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

## Endgame score rank — `func_03A9C0`
```
mult   = difficulty + 4 (+1 if diff>=3, +1 if diff>=4)   # 4,5,6,8,10
scaled = mult * raw_score / 100                          # raw_score from overlay 0x191F:0x3AA [TBD]
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

## Subsystems confirmed ABSENT (byte-verified by absence)
No disease/plague and no weather/storm subsystem exist in VICEROY.EXE (zero matching
strings). Colony population changes only via starvation (food deficit) and combat/raze.
