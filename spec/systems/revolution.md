# Independence / Revolution

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** REF globals `USER-VERIFIED`; **SoL declare threshold (50%) + meter/latch globals + WoI/intervention dispatcher `BYTE_VERIFIED`**; Tory-uprising odds + score multipliers `TBD`. **Canonical primary:** `docs/DATA_MODEL.md` (REF globals); `data_extracted/text/GAME_sections.json` independence/Tory keys; `docs/GAME_MANUAL.md`; `spec/systems/king.md`.

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
| `DGROUP:0x53D0` | i16 | **national SoL meter** (0..100), aka the "Bolívar meter" | **BYTE_VERIFIED** | recompute writer `@0x3E8BA`; clamp `@0x3BE69`; init `=0` `@0x75620` |
| `DGROUP:0x53D2` | i16 | **revolting-power index** (`-1` = none yet; else the power that declared) | **BYTE_VERIFIED** | init `=0xFFFF` `@0x75606`; later used as PowerRecord/AIPersonality index (`imul …,0x13c` `@0x3E14E`, `…,0x34` `@0x3E0B6`) |
| `DGROUP:0x53D8` | i16 | last-announced SoL **decile** (10% milestone tracker) | **BYTE_VERIFIED** | written `@0x3E97E`; init `=0` `@0x75623` |

> REF = exactly these 4 unit types (Regulars, Cavalry, Man-O-War, Artillery) — the @UNIT "Cont. Army/Cont. Cav." are the player's revolutionary upgrades, distinct from REF. The Man-O-War "does not appear in American waters until the War of Independence" (manual) — consistent with REF naval slot.

**SoL ≥ 50% declare gate — BYTE_VERIFIED (2026-06-20).** The national SoL meter
`[0x53D0]` is recomputed each turn (`mov [0x53D0],ax` `@0x3E8BA`). Immediately after,
`@0x3E8BD` `cmp ax,0x32` (**50**) `jl` skips the trigger; if SoL **≥ 50** *and* the
revolting-power latch `[0x53D2] < 0` (no one has declared yet, `cmp [0x53D2],0; jge`
`@0x3E8C2`), it fires the one-time revolution-trigger handler `func_03C638`
(`push cs; call 0x3EA0B` → trampoline `0x191F:0x364`). So **50% is the declaration-
availability threshold** (raw bytes `@0x3E8BD = 3D 32 00 7C 0B`). The *same* meter is
re-gated at **≥ 75 (0x4B)** in the per-turn end-game dispatcher (`cmp [0x53D0],0x4B`
`@0x2391C`, bytes `83 3E D0 53 4B`), which clamps the meter to 75 and routes to the
**same** handler `0x191F:0x364` (`@0x2393A`) — i.e. 75 is the forced/auto ceiling,
50 is the player-available floor, both feeding `func_03C638`. The Bolívar Founding
Father adds **+20** to the meter (`add [0x53D0],0x14`, cap 100, human-power-gated
`@0x3BE64`), so Bolívar can lift a colony over the 50/75 lines. Tory population
fraction: still **RECONSTRUCTED** (manual/common knowledge).

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
- SoL recompute/threshold function (file `0x3E8…`): meter write `@0x3E8BA`, 50% gate `@0x3E8BD`, latch test `@0x3E8C2`, decile-milestone popups (`@0x3E913`/`@0x3E99E` `cmp,0x32`; strings `0x1358`/`0x1362`/`0x136A`; `[0x53D8]` decile store `@0x3E97E`). **B**
- End-game dispatcher `@0x2391C` — `cmp [0x53D0],0x4B` (75) ceiling; shared handler `0x191F:0x364`→`func_03C638` `@0x2393A`. **B**
- New-game init `@0x755F0..0x75623` — `[0x53D2]=0xFFFF`, `[0x53D0]=0`, `[0x53D8]=0`. **B**

## 6. Open questions (TBD)
1. ~~Byte-trace the SoL% declare threshold (is it 50%?).~~ **Resolved 2026-06-20 —
   yes, 50%.** National SoL meter `[0x53D0]` recomputed `@0x3E8BA`; declaration-
   availability gate `@0x3E8BD` `cmp,0x32` (50) with rebel-power latch `[0x53D2] < 0`;
   forced/auto ceiling `@0x2391C` `cmp [0x53D0],0x4B` (75); both route to handler
   `func_03C638` (`0x191F:0x364`). Bolívar FF `+20` to the meter `@0x3BE64`. **B** (§2).
2. Trace the REF-growth writer (what spends `+0x22` to add REF units).
3. **War-of-Independence end-game flow — PARTIALLY BYTE_VERIFIED (2026-06-20):** the
   per-turn end-game dispatcher `@0x2391C` gates on the **Bolívar SoL meter `[0x53D0]`
   ≥ 75** (`cmp [0x53D0],0x4B`); game-phase flags `[0x5382]` **bit 0 = WoI declared**,
   **bit 1 = foreign intervention active**. One-time handlers: **`func_03DE46`** = WoI
   declaration + initial REF dispatch (`[0x5382]|=1` `@0x3E031`); **`func_03D948`** =
   foreign-intervention declaration (no roll — picks the strongest eligible foreign
   ally `[colony+0x5D62]&0x40` / max `[colony+0x1F]`, emits `@INTERVENTION`, sets
   `[0x5382]|=2` `@0x3DA22`). **B.** ⚠ **Residual:** the per-turn **Tory uprising** and
   **intervention-arrival** *probability rolls* remain **TBD** — a trace initially
   put them in `func_03E442`/`func_03E664`, but re-verifying the entry gate
   (`@0x3E66A je 0x3E674` fires when WoI is *clear*) shows those are the **wartime/
   peacetime mercenary-offer** functions (`mercenary.md`), not tory/intervention.
4. Verify the revolution score bonus multipliers (see `spec/systems/scoring.md`).
