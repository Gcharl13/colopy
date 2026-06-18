# Text Resources — GAME / LABELS / PEDIA / MENU

> **Layer 2 — Data Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD.

**Canonical primary:** `data_extracted/text/*.json` (extracted sections) + the per-file catalogs `docs/GAME_TXT_CATALOG.md`, `docs/LABELS_TXT_CATALOG.md`, `docs/PEDIA_TXT_CATALOG.md`. This stub indexes counts and the shared `.TXT` format; it does not copy the message templates.

## 1. Summary

Beyond NAMES.TXT (the data taxonomy — see `spec/data/names_sections.md`), the game's text lives in four `.TXT` resources, all using the same `@KEY` section format (`formats/TXT.md`). GAME.TXT holds dynamic message templates with `%`-substitutions; LABELS.TXT holds static UI labels; PEDIA.TXT holds the Colonizopedia encyclopedia; MENU.TXT holds the top-bar menu tree.

## 2. Contents

| Resource | Extracted JSON | Sections | Catalog count | Format / notes | Tier |
|----------|----------------|---------:|---------------|----------------|------|
| **GAME.TXT** | `GAME_sections.json` | 536 top keys | catalog: 510 sections | message templates; `%STRING0..4`, `%NUMBER0..3`, `%YEAR`, `%COUNTRY`; `{...}` = yellow highlight | **B** |
| **LABELS.TXT** | `LABELS_sections.json` | 7 named (`@INFO @MISC @ROUTE @CMISC @CTITLE @CMESSAGE @EUROLABEL`) | catalog: 292 lines / 7 sections | static UI labels (no substitution) | **B** |
| **PEDIA.TXT** | `PEDIA_sections.json` | 204 top keys | catalog: 1,784 lines / 163 indexed entries, 6 categories | encyclopedia; `@FATHERN`, `@CARGON`, etc.; layout dirs (`@width=…`) | **B** |
| **MENU.TXT** | `MENU_sections.json` | 8 (`@GAME @VIEW @ORDERS @REPORTS @TRADE @CUP @PEDIA @END`) | — | top-bar menu tree | **B** |

> The GAME/PEDIA JSON top-key counts (536/204) exceed the catalog "section" counts (510/163) because the JSON also captures layout/config directives (e.g. `@width=160`, `@y=91`, `@smallfont`, comment keys `@; …`) as top keys. Use the catalog for the semantic section count; the JSON for raw content.

**Substitution grammar (GAME.TXT, per `docs/GAME_TXT_CATALOG.md`):** `%STRING0..4` (text, often nation/colony/unit names), `%NUMBER0..3` (numeric), `%YEAR`, `%COUNTRY`. Braces `{…}` render as yellow highlight in popups.

## 3. Evidence

- `data_extracted/text/{GAME,LABELS,PEDIA,MENU}_sections.json` — extracted sections (counts read 2026-06-18). **B**
- `docs/GAME_TXT_CATALOG.md` — 510 sections, substitution vars. **B**
- `docs/LABELS_TXT_CATALOG.md` — 292 lines / 7 sections, static labels. **B**
- `docs/PEDIA_TXT_CATALOG.md` — 1,784 lines / 163 entries / 6 categories. **B**
- `formats/TXT.md` — `.TXT` section-based format. **B**

## 4. Open questions (TBD)

1. No catalog yet for MENU.TXT — only the 8 top-level keys are enumerated; submenu structure TBD.
2. Full enumeration of GAME.TXT `%`-substitution slots per message (which messages use which vars) — partial in `docs/GAME_TXT_CATALOG.md`.
3. PEDIA category → NAMES-section linkage is in `spec/data/index_tables.md` / `docs/GAME_INDEX_TABLES.md`; completeness TBD.
