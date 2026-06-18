# Colony & Production

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED` / `TBD`.

**Overall confidence:** record stride + several fields `BYTE_VERIFIED`;
production formula `TBD`. **Last updated:** 2026-06-18.
**Primary evidence:** `docs/DATA_MODEL.md` (ColonyRecord, runtime-verified),
`data_extracted/text/NAMES_sections.json` (@BUILDING/@JOB/@UNFORESTED/@FORESTED).

## 1. Purpose & behavior
A colony houses colonists working tiles or buildings to produce food and goods,
constructs buildings, and accumulates liberty bells (Sons of Liberty %). Output
is a function of the worked tile's terrain, the colonist's profession/expertise,
and the relevant building's bonus.

## 2. State & data layout

ColonyRecord **stride `0xCA` = 202 bytes** (BYTE_VERIFIED, `docs/DATA_MODEL.md`;
30+ `[reg+0xCA]` stride refs + direct memory inspection). `docs/DATA_MODEL.md` is
the canonical full field map; the offsets confirmed there include:

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `+0x1A` | `owner_power_idx` (0..3) | **BYTE_VERIFIED** | colony-burn trace |
| `+0x1B` | foreign-colony status (0 = player-owned) | **BYTE_VERIFIED** | cross-colony inspection |
| `+0x1C` | constant `0x40` across colonies (likely warehouse base/config) | **ANCHOR_VERIFIED** | inspection |
| `+0x1F` | size / population factor (used in colony-burn loot) | **BYTE_VERIFIED** | trace @ file `0x05DE1E` |

> For fields not listed here (stockpiles, colonist-job slots, SoL
> dividend/divisor), defer to `docs/DATA_MODEL.md` and confirm the offset at its
> cited read site before tagging `BYTE_VERIFIED` — do not assume.

Production inputs are primary game data:
- **`@BUILDING`** (buildings + production modifiers), **`@JOB`** (professions),
  **`@UNFORESTED`/`@FORESTED`** (terrain yields) — all in
  `data_extracted/text/NAMES_sections.json`. **BYTE_VERIFIED** (data exists).

## 3. Formulas & rules
**Production = f(terrain yield, profession/expertise, building bonus):**
`RECONSTRUCTED` shape only — the exact arithmetic (base yield lookup, the ×2
expert multiplier, building add/multiply order) is **not byte-traced**. Do not
hardcode it. → `spec/BACKLOG.md`.

**Sons of Liberty %:** computed from a dividend/divisor pair in ColonyRecord
(offsets `TBD` here — confirm in `docs/DATA_MODEL.md` at the read site). Crossing
50% / 100% sets political flags (independence gate) — see `king.md` revenue note
and the independence system (future `spec/systems/revolution.md`).

**Warehouse capacity / spoilage:** base capacity likely tied to `+0x1C`;
thresholds and wastage `TBD`.

## 4. UI layout
The **Colony screen** (`docs/COLONY_RENDER_CHAIN.md`) shows the building grid,
production grid, SoL bars, and the 16-commodity warehouse. Per-colony summary on
the **Colony Adviser (F6)** (`docs/ADVISOR_REPORTS_AUDIT.md`).

## 5. Evidence
- `docs/DATA_MODEL.md` — ColonyRecord stride `0xCA`; `+0x1A/+0x1B/+0x1C/+0x1F`. **B/A**
- `data_extracted/text/NAMES_sections.json` — `@BUILDING/@JOB/@UNFORESTED/@FORESTED`. **B**
- `docs/COLONY_RENDER_CHAIN.md` — colony-screen composition. **B/R**

## 6. Confidence summary
- **B:** record stride; owner/status/size fields; the production-input data sets.
- **TBD:** production formula; SoL dividend/divisor offsets + formula; warehouse
  thresholds; building prerequisite/cost application.

## 7. Open questions (TBD) → `spec/BACKLOG.md`
1. Byte-trace the **production formula** (terrain × profession × building).
2. Confirm **SoL** dividend/divisor offsets and the % computation at the read site.
3. Confirm stockpile (`[16]`) and colonist-job slot offsets against their read sites.
