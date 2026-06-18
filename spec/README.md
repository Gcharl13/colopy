# Specification — the game, described (Layer 2)

This is the **single source of truth** for *what Colonization does* and **the
entry point** for anyone implementing a port. It is built from Layer-1 evidence
(`code/`, `viceroy_source/`, `data_extracted/`, `docs/`, `notes/`) and consumed
by the Layer-3 implementation. See [`/METHODOLOGY.md`](../METHODOLOGY.md).

Each row names the **canonical** doc for a topic and its confidence tier. Where
two older docs covered the same topic, the non-canonical copy now carries a
`SUPERSEDED` redirect banner. New full specs are authored under `systems/`,
`ui/`, `data/` using [`_TEMPLATE.md`](_TEMPLATE.md); until authored, the
canonical existing doc *is* the spec for that topic.

Tiers: `BYTE_VERIFIED` (B) · `ANCHOR_VERIFIED` (A) · `RECONSTRUCTED` (R) · `TBD`.

## How to use this index
- **Implementing a feature?** Find its row, read the canonical doc, treat any
  `R`/`TBD` as "do not hardcode — confirm or stub."
- **Closing a gap?** See [`BACKLOG.md`](BACKLOG.md) for the prioritized Layer-1
  work queue and the disasm entry points.

## Systems (game behavior)

| Subsystem | Canonical spec / doc | Tier | Notes |
|-----------|----------------------|------|-------|
| King & taxation | **[`systems/king.md`](systems/king.md)** ✍ authored | B/R | Pilot spec (worked example). |
| Colony production / SoL | `viceroy_source/docs/COLONY_SYSTEM.md` | R | Formulas partly reconstructed. |
| Combat | `viceroy_source/docs/COMBAT.md` + `COMBAT_STATS.md` | B/R | Unit stats B; outcome roll TBD → BACKLOG. |
| Market / prices | `viceroy_source/docs/` (market) | R/TBD | Drift formula TBD → BACKLOG. |
| Diplomacy (European) | `viceroy_source/docs/EUROPEAN_DIPLOMACY.md` | R | Outcomes TBD → BACKLOG. |
| Natives | `viceroy_source/docs/NATIVE_RELATIONS.md` | R | Raze (CHIEFKILL) B; conversion TBD. |
| Immigration / crosses | `docs/IMMIGRATION_RECRUIT_FINDINGS.md` | A/R | Rate TBD → BACKLOG. |
| Founding Fathers | `viceroy_source/docs/FOUNDING_FATHERS.md` | R | Acquisition formula TBD → BACKLOG. |
| Scoring | `viceroy_source/docs/SCORING.md` | R | Weights TBD → BACKLOG. |
| Random events | `viceroy_source/docs/RANDOM_EVENTS.md` | R | Triggers/timing TBD → BACKLOG. |
| Map system / movement | `viceroy_source/docs/MAP_SYSTEM.md` | R | Pathfinding TBD. |
| Map generation | `viceroy_source/docs/MAP_GENERATION.md` | R/TBD | Algorithm not decoded → BACKLOG. |
| Units & orders | `viceroy_source/docs/` (unit) + `data/` | A/R | Stride 28 B. |
| Save / load | `docs/SAVE_FORMAT_CROSSREF.md` | R/TBD | Codec TBD → BACKLOG. |
| Turn loop / boot | **canonical:** `docs/ARCHITECTURE.md` | B | Dispatcher byte-verified. |

## UI (every screen & dialog — "what is drawn where")

| Screen | Canonical doc | Tier |
|--------|---------------|------|
| Map / gameplay view | `docs/SESSION_UI_CATALOG.md` + `docs/RENDERER_GEOMETRY.md` | B |
| Colony screen | `docs/COLONY_RENDER_CHAIN.md` | B/R |
| Europe screen | `docs/SESSION_UI_CATALOG.md` | B/R |
| Continental Congress | `docs/SESSION_UI_CATALOG.md` | B |
| Advisor reports (F2–F10) | `docs/ADVISOR_REPORTS_AUDIT.md` | B |
| King message / tax dialog | **[`systems/king.md`](systems/king.md)** §4 + `docs/KING_AND_CINEMATIC_AUDIT.md` | B |
| Popup dialogs | `docs/UI_DIALOGS.md` + `docs/POPUP_TEMPLATE_AUDIT.md` + `docs/DIALOG_GEOMETRY.md` | B |
| Fonts / palette | `docs/UI_FONT_REFERENCE.md` + `docs/PALETTE_AND_CYCLING.md` | B |
| Map editor (MAPEDIT) | `formats/MP_FORMAT.md` + `mapedit_source/REWRITE_PLAN.md` | B/R |

## Data & formats

| Topic | Canonical doc | Tier |
|-------|---------------|------|
| Memory records (Power/Colony/Unit/Native) | **canonical:** `docs/DATA_MODEL.md` | B |
| Index tables (sprite/text indices) | `docs/GAME_INDEX_TABLES.md` | B |
| Text resources (GAME/LABELS/PEDIA/NAMES) | `docs/GAME_TXT_CATALOG.md`, `docs/LABELS_TXT_CATALOG.md`, `docs/PEDIA_TXT_CATALOG.md` | B |
| File formats (.MP/.SS/.PAL/.FF/…) | `formats/` | B |

## Canonical-source rulings (de-duplication)

These topics had two copies; the canonical one is authoritative, the other is
banner-redirected:

| Topic | Canonical | Superseded (banner) |
|-------|-----------|---------------------|
| Memory records | `docs/DATA_MODEL.md` (B, runtime-verified) | `viceroy_source/docs/DATA_MODEL.md` (stale C) |
| Architecture | `docs/ARCHITECTURE.md` | `viceroy_source/docs/ARCHITECTURE.md` |
| Render chain | `docs/RENDER_CHAIN.md` + `docs/COLONY_RENDER_CHAIN.md` | `viceroy_source/docs/RENDER_CHAIN.md` |
