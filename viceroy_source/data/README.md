# Initialised Data Tables

> **⚠️ Reconstructed — the authoritative basis is `data_extracted/tables/`.** The
> byte-exact gameplay tables live in `data_extracted/tables/*.json` (generated
> from the real `NAMES.TXT`/`TRIBE.TXT` by `tools/build_tables.py`) and are now
> rendered **in full** in `spec/data/tables.md`. The `.c` files here are
> *reconstructions* rebuilt 2026-05-30 from the same source; spot-checked **equal**
> to the basis (e.g. `building_costs.c` rows match `@BUILDING` exactly). The basis
> still wins — treat any value that disagrees with `data_extracted/tables/` as
> `TBD`, not fact. These values are **runtime-loaded from `NAMES.TXT`** (not static
> EXE bytes); the in-memory DGROUP record *layout* (where the loader writes them)
> is catalogued separately in `spec/data/tables.md` §C (from `docs/DATA_MODEL.md`).

This directory holds the **gameplay data tables** — terrain yields, unit-type
stats, building costs, commodity pricing, scenario starts, native-tribe data.

**These are NOT static EXE tables.** The game reads them from `NAMES.TXT` at
startup (loader `func_0749E0`) into DGROUP/BSS; the EXE image stores zeros there.
Each `.c` file is the *value content* that loader writes, reconstructed from the
real `NAMES.TXT`/`TRIBE.TXT` (so the earlier "DGROUP offset / linker-emitted
bytes" framing was wrong — there is no static offset to cite; the authority is
the NAMES section). All six present files were **spot-checked byte-identical** to
the extracted basis on 2026-06-18 (per-file row comparison vs
`data_extracted/tables/`).

| File                  | C array(s)                     | NAMES source            | Rows | Status |
|-----------------------|--------------------------------|-------------------------|-----:|--------|
| `terrain_yield.c`     | `TERRAIN_YIELD[21][16]` + move/defense/resource | `@UNFORESTED`/`@FORESTED`/`@OTHER`/`@RESOURCE` | 21 | ✓ identical to basis |
| `unit_classes.c`      | `UNIT_TYPE_TABLE[23]`          | `@UNIT`                 | 23 | ✓ identical to basis |
| `building_costs.c`    | `BUILDING_COST_TABLE[42]`      | `@BUILDING`             | 42 | ✓ identical to basis |
| `commodity_prices.c`  | `CARGO_TABLE[16]`              | `@CARGO` (16 economic goods) | 16 | ✓ identical to basis |
| `scenario_starts.c`   | `SCENARIO_STARTS[2][4]`        | `@SCENARIO`             | 2 | ✓ identical to basis |
| `tribe_data.c`        | `TRIBE_INFO[8]` + `LEVEL_INFO[5]` | `@TRIBES`/`@LEVELS`  | 8/5 | ✓ identical to basis |

**Not reconstructed (no `.c` file — do not cite as existing):**

| Would-be file    | Why it's not here |
|------------------|-------------------|
| `ff_effects.c`   | Founding-Father gameplay *effects* are **hardcoded in EXE logic**, not in `NAMES.TXT` (only the `@FATHERS` acquisition weights exist — see `spec/data/tables.md`). A byte-RE task, not a data extraction. |
| `kings_demands.c`| The King's tax/demand schedule is a **runtime** computation (see `spec/systems/king.md`), not a static data table. |

Authoritative basis: `data_extracted/tables/*.json` (rendered in full in
`spec/data/tables.md`). The basis wins — treat any `.c` value that disagrees as
`TBD`, not fact.
