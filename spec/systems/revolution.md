# Independence / Revolution

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** REF globals `USER-VERIFIED`; SoL gate + Tory mechanics `RECONSTRUCTED`; thresholds `TBD`. **Canonical primary:** `docs/DATA_MODEL.md` (REF globals); `data_extracted/text/GAME_sections.json` independence/Tory keys; `docs/GAME_MANUAL.md`; `spec/systems/king.md`. ⚠ The `[0x53D0]`/`[0x53D2]` meter + `func_03C638` annexation handler (initially mis-filed here) are the **War of Spanish Succession**, not the revolution — see `spec/systems/spanish_succession.md` and `notes/rulings/RULINGS.md` (2026-06-20).

## 1. Purpose & behavior
When rebel sentiment (Sons of Liberty %) is high enough, the player may declare independence. The Crown then deploys its Royal Expeditionary Force (REF) against the colonies; the player must defeat it (with help from a possible foreign intervention force) to win. Loyalist (Tory) colonists resist; an uprising can occur. Declaring earlier yields a larger score bonus. **RECONSTRUCTED** (manual §"Independence").

## 2. State & data
REF counts are **separate globals** (not PowerRecord fields), per `spec/systems/king.md`:

| Address | Type | Meaning | Tier | Evidence |
|---------|------|---------|------|----------|
| `DGROUP:0x53DA` | u16 | REF Regulars | **USER-VERIFIED** | `docs/DATA_MODEL.md` (23 in-game) |
| `DGROUP:0x53DC` | u16 | REF Cavalry | **USER-VERIFIED** | `docs/DATA_MODEL.md` (10) |
| `DGROUP:0x53DE` | u16 | REF Man-O-War | **USER-VERIFIED** | `docs/DATA_MODEL.md` (5) |
| `DGROUP:0x53E0` | u16 | REF Artillery | **USER-VERIFIED** | `docs/DATA_MODEL.md` (8) |
| `PowerRecord +0x02` | u8 | `rebel_sentiment_pct` (SoL %) | **USER-VERIFIED** (runtime) | `docs/DATA_MODEL.md` |

> REF = exactly these 4 unit types (Regulars, Cavalry, Man-O-War, Artillery) — the @UNIT "Cont. Army/Cont. Cav." are the player's revolutionary upgrades, distinct from REF. The Man-O-War "does not appear in American waters until the War of Independence" (manual) — consistent with REF naval slot.

SoL ≥ 50% declare gate, Tory population fraction: **RECONSTRUCTED** (manual/common knowledge); **byte threshold TBD**. (Note: the `[0x53D0] ≥ 50/75` gates found 2026-06-20 are the **Spanish-succession** trigger meter, *not* the SoL declare threshold — see `spanish_succession.md`; the SoL% declare threshold remains genuinely TBD.)

## 3. Formulas & rules
- REF growth over the game: spend rule (driven by `PowerRecord +0x22`, +18/turn, per `spec/systems/king.md`) → REF globals: **TBD** (trace the writer of `0x53DA..0x53E0`).
- Declare eligibility (SoL% threshold), intervention-force trigger, Tory uprising odds: **TBD**.
- "No wars during revolution" rule: present as `@NOWARSDURINGREV` key. **BYTE_VERIFIED present** (logic TBD).

## 4. UI
Declaration flow uses `@PICKINDEPENDENCE`, `@INDEPENDENCE`, `@ALREADYREVOLUTION`; Tory outcomes `@TORYUPRISING @TORYMAJORITY @TORYMINORITY @TOOTORY`; victory `@KINGVICTORY`. **All BYTE_VERIFIED present** (GAME.TXT). See `docs/SESSION_UI_CATALOG.md`, `spec/systems/king.md` §UI.

## 5. Evidence
- `docs/DATA_MODEL.md` — REF globals `0x53DA/0x53DC/0x53DE/0x53E0` (USER-VERIFIED); `PowerRecord +0x02` rebel sentiment. **B/runtime**
- `data_extracted/text/GAME_sections.json` — `@INDEPENDENCE @PICKINDEPENDENCE @ALREADYREVOLUTION @TORYUPRISING @TORYMAJORITY @TORYMINORITY @TOOTORY @NOWARSDURINGREV @KINGVICTORY`. **B (present)**
- `docs/GAME_MANUAL.md` §"Independence", revolution score bonus (1x/0.5x/0.25x; pre-1780 bonus). **R**
- `spec/systems/king.md` — REF = 4 globals; `+0x22` budget. **B**

## 6. Open questions (TBD)
1. Byte-trace the SoL% declare threshold (is it 50%?). *(2026-06-20: the `[0x53D0]≥50/75`
   gates initially suspected here were disproved — they drive the **Spanish-succession**
   annexation `func_03C638`/`@SUCCESSION`, not the revolution; the true SoL declare
   threshold is still unlocated. See `notes/rulings/RULINGS.md`.)*
2. Trace the REF-growth writer (what spends `+0x22` to add REF units).
3. **War-of-Independence end-game flow — PARTIALLY BYTE_VERIFIED (2026-06-20):** the
   per-turn end-game dispatcher `@0x2391C` gates on the **Bolívar SoL meter `[0x53D0]`
   ≥ 75** (`cmp [0x53D0],0x4B`); game-phase flags `[0x5382]` **bit 0 = WoI declared**,
   **bit 1 = foreign intervention active**. One-time handlers: **`func_03DE46`** = WoI
   declaration + initial REF dispatch (`[0x5382]|=1` `@0x3E031`); **`func_03D948`** =
   foreign-intervention declaration (no roll — picks the strongest eligible foreign
   ally `[colony+0x5D62]&0x40` / max `[colony+0x1F]`, emits `@INTERVENTION`, sets
   `[0x5382]|=2` `@0x3DA22`). **B.** **Per-turn rolls LOCATED 2026-06-20** (via
   `tools/rtlink/event_emitters.json` handle map): the per-turn **Tory uprising**
   `@TORYUPRISING` is `func_03CAC6` (`@0x3CD94`; gate `random_int(0,diff+1)≠0`
   `@0x3CADD` → prob `(diff+1)/(diff+2)`) and the **intervention-arrival** `@INTERVENE`
   is `func_03D510` (`@0x3D7BB`; weighted colony pick `random_int(1,Σ +0x1F)` `@0x3D57E`)
   — both detailed in `tory_uprising.md` §3. (The earlier mis-attribution to
   `func_03E442`/`func_03E664` — actually the mercenary-offer functions per
   `mercenary.md` — is superseded.)
4. Verify the revolution score bonus multipliers (see `spec/systems/scoring.md`).
