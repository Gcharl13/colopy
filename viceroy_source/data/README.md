# Initialised Data Tables

> **⚠️ Reconstructed — the authoritative basis is `data_extracted/tables/`.** The
> byte-exact gameplay tables live in `data_extracted/tables/*.json` (generated
> from the real `NAMES.TXT`/`TRIBE.TXT` by `tools/build_tables.py`) and are now
> rendered **in full** in `spec/data/tables.md`. The `.c` files here are
> *reconstructions* rebuilt 2026-05-30 from the same source; spot-checked **equal**
> to the basis (e.g. `building_costs.c` rows match `@BUILDING` exactly). The basis
> still wins — treat any value that disagrees with `data_extracted/tables/` as
> `TBD`, not fact. Note the DGROUP record *values* are runtime (loaded at init /
> memory-dump verified), **not** static EXE bytes; the offsets below describe the
> linker layout, and the byte-verified layout catalog is `spec/data/tables.md` §C
> (from `docs/DATA_MODEL.md`).

This directory holds the **constant tables** that VICEROY.EXE keeps in
DGROUP — terrain yields, unit type stats, building costs, founding-father
effects, king demand schedules, scenario starting positions.

These are reconstructed from byte analysis of the DGROUP segment plus
cross-validation against the disassembly + `data_extracted/text/NAMES_sections.json`. Each file
is C source that, when compiled, would produce the same DGROUP bytes the
linker emitted in 1995.

| File                  | DGROUP offset | Size      | Purpose               |
|-----------------------|---------------|-----------|------------------------|
| `terrain_yield.c`     | 0x05000       | 672 bytes | 21 terrain × 16 occupations |
| `unit_classes.c`      | 0x06530       | 360 bytes | 45 unit types × 8 bytes |
| `building_costs.c`    | 0x01DB32      | 624 bytes | 39 buildings × 16 bytes |
| `ff_effects.c`        | 0x0B400       | 300 bytes | 25 fathers × 12 bytes |
| `kings_demands.c`     | 0x07D00       | 112 bytes | 7-stage demand table |
| `scenario_starts.c`   | 0x08400       | 64 bytes  | Stock-map starting positions |
| `commodity_prices.c`  | 0x07A00       | 256 bytes | 16 commodities × pricing data |
| `tribe_data.c`        | 0x09800       | 192 bytes | 8 tribes × 24-byte records |

All offsets are within the linker-emitted DGROUP after relocation.
