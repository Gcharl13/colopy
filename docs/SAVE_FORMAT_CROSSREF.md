# Save format cross-reference: pavelbel/smcol_saves_utility ↔ runtime DGROUP

Cross-referenced 2026-05-07 against
https://github.com/pavelbel/smcol_saves_utility — an independent
reverse-engineering effort that documents the **SAV file format**
(the on-disk save game).

The save file is largely a serialization of the runtime DGROUP
state, so the field names match closely. This doc reconciles
his findings with mine and notes where they confirm, contradict,
or extend each other.

---

## What pavelbel decoded that I didn't

### 1. NativeSettlement (his "TRIBE" section)

His TRIBE record has 18 bytes — matches my stride exactly.
Field-by-field comparison:

| Offset | His name | His type | My name | Status |
|------:|----------|----------|---------|--------|
| +0x00, +0x01 | x, y | byte+byte | map_x, map_y | ✓ verified |
| +0x02 | nation_id | byte | owner_power_idx | ✓ verified |
| +0x03 | BLCS | bitfield | flags | **CORRECTED** |
| +0x04 | population | byte | population | ✓ verified |
| +0x05 | mission | byte (4-bit nation + 1-bit expert) | mission byte | ✓ verified — my "0x10 bit = mission active" is the **expert** flag |
| +0x06 | growth_counter | byte | "secondary flags" | **CORRECTED** — actually growth counter |
| +0x07 | unknown28a | always 0xff | occupant slot 1 | **CORRECTED** — sentinel, not occupant |
| +0x08 | last_bought | byte | occupant slot 2 | **CORRECTED** |
| +0x09 | last_sold | byte | occupant slot 3 | **CORRECTED** |
| +0x0A..+0x11 | alarm[4] × 2 bytes (friction + attacks) | per-nation | "trailing region" | **NEW** — per-nation alarm/friction matrix |

**BLCS bits** (correcting my earlier capital/visited interpretation):
- bit 0 = brave_missing (brave is on the map, not in dwelling)
- bit 1 = learned (chief revealed taught skill)
- bit 2 = capital (= 0x04 in byte)
- bit 3 = scouted (= 0x08 in byte) — what I called "visited" / "spoke with chief"
- bits 4-7 = unused

**growth_counter** (per `supplemental-info.md`):
> When a native dwelling is missing its brave on the map or its
> population is less than the max, this counter increases each
> turn by an amount equal to the current population. When it
> hits 20, a new brave spawns or population grows by 1. Signed
> int — can be negative.

Earlier I observed Arawak (45,35) had +0x06 = 0x0E = 14 — that's
near the 20 threshold meaning a brave was about to spawn. Inca
(38,54) capital had +0x06 = 0 (population at max).

**alarm[4]** is per-nation (4 × 2 bytes = 8 bytes at +0x0A..+0x11):
- friction byte (per nation): how aggressive that nation feels
- attacks byte: braves' retaliation queue

My observation "Arawak (45,35) had +0x0E=0x26, +0x0F=0x03" is
alarm[Spanish] friction=38, attacks=3.

### 2. NATION (my PowerRecord)

His schema names the fields explicitly:

| His name | Type | My name | Status |
|----------|------|---------|--------|
| tax_rate | byte | tax_pct | ✓ at +0x01 |
| recruit | 3 × profession | (unverified) | **NEW** — 3 immigrant slots waiting |
| recruit_count | byte | (unverified) | **NEW** |
| founding_fathers | bitfield (25 bits) | acquired_ff_bitmask | ✓ at +0x07 |
| liberty_bells_total | u16 | bells_toward_next_ff | **CONFIRMED** — current FF accumulator |
| liberty_bells_last_turn | u16 | bells_per_turn | ✓ at +0x0E |
| next_founding_father | s16 | (FF-being-acquired idx) | **NEW** — explicit "next FF" pointer (-1 if none) |
| founding_father_count | u16 | founding_father_count | ✓ at +0x14 |
| villages_burned | byte | (unverified) | **NEW** — score component |
| rebel_sentiment | byte | rebel_sentiment_pct | ✓ at +0x02 |
| artillery_bought_count | u16 | (unverified) | **NEW** |
| boycott_bitmap | 16 bits | boycott_bitfield | ✓ at +0x20 |
| **royal_money** | s32 | (unverified) | **HUGE NEW** — "King's budget for REF expansion" |
| gold | s32 | gold | ✓ at +0x2A |
| current_crosses | u16 | (unverified) | **NEW** — Crosses accumulator |
| needed_crosses | u16 | (unverified) | **NEW** — next-immigrant Crosses threshold |
| relation_by_nations | 4 × packed | (unverified) | **NEW** — per-foreign-nation attitude |
| relation_by_indian | 8 × packed | (unverified) | **NEW** — per-tribe attitude |
| trade.euro_price | 16 × byte | market_price | ✓ at +0x4C |
| trade.intrinsic_volume | 16 × s16 | market_pool | ✓ at +0x5C |
| trade.gold | 16 × s32 | market_traded_volume | ✓ at +0x7C |
| trade.tons_traded | 16 × s32 | market_eu_supply | ✓ at +0xBC |
| trade.tons_traded2 | 16 × s32 | market_base_values | ✓ at +0xFC |

### 🔥 royal_money — the REF growth driver

Per his schema, **royal_money** is a 4-byte signed integer that
acts as the King's budget for adding new REF units. His comment:

> Increased, then when it reaches a threshold, a new unit is added.

This is the answer to my open question "when will REF grow". It's
not directly tied to king_anger (DGROUP:0x53A7) but rather to
an accumulator that builds up over turns. King anger likely
modifies the rate at which royal_money grows.

**Action item**: locate `royal_money` in the runtime DGROUP layout
(probably ~+0x24..+0x29 of PowerRecord, in the region between
my known boycott bitfield (+0x20) and gold (+0x2A)).

### 3. ColonyRecord (his "COLONY" section)

His schema breaks down the building bitmask I found at +0x60..+0x65:

```
buildings (4 bytes total):
  fortification (3 bits): tier 0..3 → none/Stockade/Fort/Fortress
  armory (3 bits)        → none/Armory/Magazine/Arsenal
  docks (3 bits)         → none/Docks/Drydock/Shipyard
  town_hall (3 bits)     → none/TownHall/Assembly/Capitol
  schoolhouse (3 bits)   → none/Schoolhouse/College/University
  warehouse (1 bit)
  unused05a (1 bit)
  stables (1 bit)
  custom_house (1 bit)
  printing_press (2 bits) → none/Press/Newspaper
  weavers_house (3 bits)
  tobacconists_house (3 bits)
  rum_distillers_house (3 bits)
  capitol (2 bits, unused)
  fur_traders_house (3 bits)
  carpenters_shop (2 bits)
  church (2 bits)
  blacksmiths_house (3 bits)
  unused05b (6 bits)
```

**This explains my "19 bits set" finding** for Plymouth! It's not
19 separate buildings; it's tier values for each building chain
packed into bit groups.

For Plymouth bytes `fc ff 2f 00`, the BIT INTERPRETATION as 3-bit
tiers (depending on bit-order convention) determines which tier
each upgrade chain is at.

**New ColonyRecord fields he documented**:

| His name | Type | Status |
|----------|------|--------|
| colony_flags | byte (SoL bonuses, blinking) | NEW — at end of nation_id area |
| occupation | per-colonist (max 32) | NEW — what each colonist does |
| profession | per-colonist (max 32) | NEW — colonist's specialty |
| duration | per-colonist (4-bit pairs) | NEW — turns at current job |
| custom_house_flags | 16-bit (per good toggle) | NEW |
| hammers | u16 | NEW — building progress accumulator |
| building_in_production | byte | NEW — which @BUILDING idx is being built |
| warehouse_level | byte | NEW |
| depletion_counter | byte | NEW — depletes mineral resources at 50 |
| hammers_purchased | u16 | NEW — rushed-construction tally |
| population_on_map[4] | per-foreign-nation | NEW — fog-of-war population display |
| fortification_on_map[4] | per-foreign-nation | NEW — fog-of-war fortification display |
| rebel_dividend / rebel_divisor | s32 each | NEW — SoL fraction (102/902 finally explained!) |

**The "102 (0)" / "902 (5)" Plymouth display I couldn't decode
earlier** is `rebel_dividend / rebel_divisor`! The format is:
- 102 (numerator) over 902 (denominator) = 11.3% Sons of Liberty
- The (0) / (5) numbers are something else — maybe per-turn delta.

### 4. UNIT (my UnitRecord)

His UNIT schema = 28 bytes — matches my stride.

| Offset | His name | Status |
|--------|----------|--------|
| +0x00, +0x01 | x, y | ✓ at +0x07/+0x08 in my doc — **MY OFFSETS WERE WRONG** |
| +0x02 | type | ✓ this matches my +0x00 |
| +0x03 | nation_info (4-bit nation_id + 4-bit visibility) | ✓ this matches my +0x01 |

**WAIT** — his offsets and mine differ! His record starts with
x, y at +0x00, +0x01, then type at +0x02, nation at +0x03. But
my findings put type at +0x00 and x,y at +0x07/+0x08.

This could mean:
- His SAV format is a re-serialization with different field order
- Or one of us has the offsets wrong

To resolve: check a UnitRecord at runtime. Plymouth's caravel was
at (55, 49) per my earlier dump. The bytes were
`0d 00 00 00 00 45 00 37 31 03 02 91...`. Type byte 0x0D (Caravel)
is at offset 0. x=0x37=55 at offset 7, y=0x31=49 at offset 8.

So MY runtime offsets are correct (type at +0x00, x at +0x07).
His save format must reorder the fields when serializing.

**New UNIT fields he documented**:

| His name | Type | Status |
|----------|------|--------|
| nation_info: nation_id (4 bits) + 4 visibility bits | byte | NEW |
| damaged | bit_bool | NEW — ship damage flag |
| moves | byte | NEW — moves used this turn |
| origin_settlement | byte | NEW — colony or tribe of origin |
| ai_plan_mode | byte (ASCII char) | NEW — foreign AI planning mode |
| orders | byte (orders_type) | NEW — sentry, goto, fortify, etc. |
| goto_x, goto_y | byte each | NEW — destination tile |
| holds_occupied | byte | NEW — ship cargo count |
| cargo_items | 6 × 4-bit cargo_type | NEW — ship cargo manifest |
| cargo_hold | 6 × byte | NEW — quantities (last byte = pioneer tools) |
| turns_worked | byte | NEW — high-seas counter |
| profession_or_treasure_amount | byte (×100 for treasure) | NEW — **FOUND IT** |
| transport_chain.next_unit_idx | s16 | NEW — linked unit (for boarding) |
| transport_chain.prev_unit_idx | s16 | NEW |

The mystery of where the **Treasure Train value** is stored is
now answered: `profession_or_treasure_amount` byte × 100. So
0x32 = 50 = 5000 gold. For the Aztec capital popup we saw, the
treasure unit's value byte should be 0x64 = 100 = 10,000 gold.

### 5. STUFF section — score components

His STUFF section has these per-nation arrays:
- all_unit_counts (4 bytes — total units per nation)
- foreign_affairs_report.populations[4]
- foreign_affairs_report.merchant_marine[4]
- foreign_affairs_report.ship_counts[4]
- unit_counts[4] — per-unit-type detailed breakdown:
  colonist_count, soldier_count, pioneer_count, missionary_count,
  dragoon_count, scout_count, tory_regular_count, cont_cavalry_count,
  tory_cavalry_count, cont_army_count, treasure_count, artillery_count,
  wagon_train_count, caravel_count, ...

These are precomputed score components used by the Foreign Affairs
adviser screen (REPORT8.PIK).

---

## What I've found that he hasn't (or differs)

- **DGROUP runtime locations** (not save file): I have specific
  DGROUP offsets that drive in-game rendering. His schema is
  about save file structure, not runtime memory addresses.
- **ICONS sprite index ↔ unit type mapping** (NAMES.TXT @UNIT col 1)
- **Per-screen UI geometry** (RENDERER_GEOMETRY.md)
- **Sprite catalog** (SESSION_UI_CATALOG.md) — visual identification
  of every sprite asset

---

## Updates to my docs based on this cross-reference

1. ✏️ ColonyRecord +0x60..+0x65 buildings field: **NOT a flat
   bitmask** — it's a packed bit-struct with 3-bit tier values per
   building chain.
2. ✏️ ColonyRecord +0x40..+0x4? = **profession** (not just
   "job-skills"). Per-colonist profession byte.
3. ✏️ ColonyRecord has additional fields: hammers (current build
   progress), building_in_production (idx), warehouse_level,
   custom_house_flags (16-bit per good toggle).
4. ✏️ ColonyRecord rebel_dividend / rebel_divisor explains the
   "102 (0)" / "902 (5)" Plymouth display.
5. ✏️ NativeSettlement +0x06 = growth_counter (not "secondary
   flags").
6. ✏️ NativeSettlement +0x0A..+0x11 = alarm[4] (per-nation
   friction + retaliation count).
7. ✏️ PowerRecord has royal_money field driving REF growth — find
   in DGROUP runtime.
8. ✏️ PowerRecord has next_founding_father (s16) explicit pointer.
9. ✏️ UnitRecord per-field offsets need re-mapping (his SAV order
   vs my runtime order may differ).
10. ✏️ Treasure Train value = unit's profession byte × 100.

---

## Action items

- [x] Cross-reference his findings against my docs
- [ ] Find royal_money offset in DGROUP runtime PowerRecord
- [ ] Verify rebel_dividend/divisor against Plymouth's "102/902" display
- [ ] Confirm UNIT field offset order (save vs runtime)
- [ ] Decode buildings 4-byte bit-struct properly (3-bit tiers)
- [ ] Explore the 8-byte alarm[4] in NativeSettlement (4 friction + 4 attacks)
- [ ] Update DATA_MODEL.md with all confirmed fields
- [ ] Update load_game_state.py to extract these fields properly