# Forge engine — the game database schema

The game is a **database** mutated by functions and events. Everything is data:
**reference** tables (rules), **state** tables (dynamic records), **config** scalars.
The runtime interprets this schema; offsets are traceability-only.

- Tables: 54 total — 40 reference, 13 state, 1 config.

## Path grammar (one interface addresses any cell)
- **singleton**: `<table>.<col>            e.g. game.turn, revolution.sol, cfg.max_population`
- **entity**: `<table_singular><N>.<col>  e.g. power0.gold, colony2.population, unit5.type`
- **indexed_col**: `<...>.<col>.<idx>     e.g. colony0.stockpile.3, ff.16, price.9`
- **reference**: `@SECTION[<row index or name:VALUE>].<column>  e.g. @BUILDING[name:Fort].cost`

## State tables

- **game** (singleton, `game`): year, season, turn, difficulty, nation, score
- **powers** (entity, `power<N>`): gold, tax, royal_money, crosses, mil_strength, econ_strength, colonies, units, strength
- **colonies** (entity, `colony<N>`): population, owner, sol, bells, hammers, food, crosses, build_target, build_cost, build_bank, build_remaining, building_name, warehouse, workers, stockpile.<good>, built.<id>
- **units** (entity, `unit<N>`): type, owner, profession, x, y, alive, attack, defense, movement, terrain, terraindef
- **congress** (singleton, `congress`): bells, cost, era_band, count
- **ff** (singleton, `ff`): count, <id>
- **revolution** (singleton, `revolution`): sol, declared, rebel
- **succession** (singleton, `succession`): seceded
- **natives** (singleton, `natives`): tension
- **ref** (singleton, `ref`): regulars, cavalry, manowar, artillery
- **market** (singleton, `market`): price.<good>, boycott.<good>
- **world** (singleton, ``): colonies.count, colonies.population, units.count, terrain.defense.<id>
- **diplomacy** (matrix, `war.<a>.<b>`): war.<a>.<b>

## Config (cfg.<name>) — tunable scalars

warehouse_cap_base, sol_decay_shift, sol_inflow_mult, sol_birth_bonus, food_growth_threshold, max_population, tory_divisor_base, expert_era_bonus, expert_mfg_mult, price_drift_shift, fortify_def_num, fortify_def_den, ff_human_scale, ff_human_offset, ff_ai_scale, ff_ai_offset, ff_post_indep_scale, ff_post_indep_offset, ff_compounding_shift, ff_first_father_shift, ff_gate_years, ref_regulars_scale, ref_regulars_offset, ref_cavalry_scale, ref_cavalry_offset, ref_manowar_scale, ref_manowar_offset, ref_artillery_scale, ref_artillery_offset, ref_accrue_scale, ref_accrue_offset, ref_accrue_gate_years

## Reference tables (@SECTION[row].col)

@SEASONS, @UNFORESTED, @FORESTED, @OTHER, @OTHER_NAMES, @RESOURCE, @COUNTRY, @NATIONALITY, @NATIONABBREV, @HOMEPORT, @COLONYNAME, @INDEPENDENT, @LEADERNAME, @MISSION, @DIFFICULTY, @CLASS, @BUILDING, @SCENARIO, @JOB, @CARGO, @UNIT, @ORDERS, @ACTIONS, @VALUES, @ATTITUDE, @ATTITUDINAL, @LEVELS, @TRIBES, @FOUNDING, @FATHERS, @COLORS, @IROQUOIS, @STOP, @CHEROKEE, @ARAWAK, @INCA, @SIOUX, @APACHE, @AZTEC, @TUPI

## Functions → columns (update rules)
Each function's `writes` and the `reverse_index` (column → writers) live in `functions.json`. Example writers:
- `colony<N>.build_bank` ← build_step, step_turn
- `colony<N>.build_target` ← build_step
- `colony<N>.built.<id>` ← build_step
- `colony<N>.population` ← colony_economic_step (growth), step_turn
- `colony<N>.sol` ← sol_update (divisor B), sol_update (dividend A), colony_economic_step (growth), step_turn
- `game.season` ← step_turn, advance_cadence
- `game.turn` ← step_turn, advance_cadence
- `game.year` ← step_turn, advance_cadence
- `market.price.<good>` ← price_drift, step_turn
- `natives.tension` ← apply_tension
