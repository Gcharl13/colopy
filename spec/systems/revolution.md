# Independence / Revolution

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Status: revolution/REF/declare/end-game subsystems are BYTE_VERIFIED or RESOLVED (§2-§3, §6); the `@NOWARSDURINGREV` enforcement site is now byte-located at `func_05A862 @0x5A912` (§3, 2026-06-27). Sole remaining reconstruction: the Tory population fraction (§2, RECONSTRUCTED — manual-derived, no byte anchor yet).

**Overall confidence:** REF globals `USER-VERIFIED`; **SoL ≥ 50% declare threshold + declaration handler `func_03E984`→`func_03DE46` `BYTE_VERIFIED`** (2026-06-20); Tory mechanics `RECONSTRUCTED`. **Canonical primary:** `docs/DATA_MODEL.md` (REF globals); `data_extracted/text/GAME_sections.json` independence/Tory keys; `tools/rtlink/event_emitters.json` (handle map); `docs/GAME_MANUAL.md`; `spec/systems/king.md`. ⚠ The `func_03C638` annexation handler (and the `[0x53D0]≥75` ceiling gate) are the **War of Spanish Succession**, which shares the `[0x53D0]` SoL meter but is a *separate* event — see `spec/systems/spanish_succession.md` and `notes/rulings/RULINGS.md` (2026-06-20).

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
| `DGROUP:0x53D0` | i16 | **national SoL meter** (0..100, the "Bolívar meter") | **BYTE_VERIFIED** | declare gate `@0x3E99E`; +20 Bolívar `@0x3BE64`; init `=0` `@0x75620` |
| `DGROUP:0x5398` | u16 | **revolting (rebel) power index** — set to the current player on declaration | **BYTE_VERIFIED** | `@0x3E9D8` `[0x5398]=[0x5394]` |

> REF = exactly these 4 unit types (Regulars, Cavalry, Man-O-War, Artillery) — the @UNIT "Cont. Army/Cont. Cav." are the player's revolutionary upgrades, distinct from REF. The Man-O-War "does not appear in American waters until the War of Independence" (manual) — consistent with REF naval slot.

**SoL ≥ 50% declare threshold — BYTE_VERIFIED (2026-06-20).** The "Declare
Independence" command handler is **`func_03E984`** (file `0x3E984`, `enter 2`). It
gates in three steps:
1. **Already revolting** — `test [0x5382],1; je` → if WoI bit set, emit
   **`@ALREADYREVOLUTION`** (handle `0x1374`) and return (`@0x3E988`).
2. **SoL threshold** — **`cmp [0x53D0],0x32` (50); `jge`** (`@0x3E99E`): if the
   national SoL meter is **< 50**, format it as `%NUMBER0` and emit **`@TOOTORY`**
   (handle `0x1386`, *"Only %NUMBER0%% of the colonists support the independence
   movement…"*) then return (`@0x3E9A5..0x3E9BA`). So **50% is the hard declare floor.**
3. **Confirm & declare** — at SoL ≥ 50 it (multiplayer branch `[0x5381]&0x80` →
   `@MULTIREV` `0x138E`) sets the **rebel power `[0x5398] := [0x5394]`** (current
   player, `@0x3E9D8`), shows the **`@DECLARE`** confirm dialog (handle `0x1397`,
   `@0x3E9F0`) and, on "yes" (`cmp ax,2; je`), calls **`func_03DE46`** (`0x191F:0x356`,
   `@0x3EA06`) — the WoI declaration that sets `[0x5382]|=1` and emits **`@INDEPENDENCE`**
   (handle `0x130B`). **B.**

The SoL meter `[0x53D0]` is the same 0..100 "Bolívar meter" that the **Bolívar
Founding Father** boosts **+20** (cap 100, `add [0x53D0],0x14` `@0x3BE64`). ⚠ Note the
**War of Spanish Succession** (`func_03C638`/`@SUCCESSION`) is a **separate** event
sharing this meter, with a **different gate** (byte-verified 2026-06-23, disasm of the
end-game dispatcher `func_0235D6 @0x2391C`): it calls the succession handler
(`lcall 0x191F:0x364`→`func_03C638`) when **`[0x53D0] < 75`** (`cmp [0x53D0],0x4B; jl`,
clamped to 75 `@0x2392A`) **AND `[0x53D2] < 0`** (no power has seceded yet, `@0x23930`);
the high-meter (`≥75`) state instead feeds the **revolution** handlers (`@0x23942`,
gated on `[0x5382]`). This corrects the earlier "crosses 50 / `func_03E844`"
mis-attribution — `func_03E844` is `sons_of_liberty_active_check` (the SoL *display*
gate, no `[0x53D0]` read). See `spanish_succession.md`. Tory population fraction: still **RECONSTRUCTED**.

## 3. Formulas & rules
- REF growth over the game — **RESOLVED** (see `ref_growth.md` §3, re-confirmed 2026-06-27): init
  `func_0755CC` (difficulty-scaled starting counts `8d+15 / 5d+5 / 3d+2 / 6d+2` into the 4-type
  array `DGROUP:0x53DA` stride 2); growth `func_03E162` (royal_money `PowerRecord+0x22 +=
  (8·diff+10)·2^era` per turn; at `+0x22 ≥ 1800` buy one unit `inc [0x53DA+slot·2]`, `−= 1800`).
- Declare eligibility (SoL% threshold), intervention-force trigger, Tory uprising odds: **RESOLVED.** (1) Declare eligibility = SoL meter `[0x53D0] ≥ 50` (`cmp [0x53D0],0x32; jge` `@0x3E99E`, §2/§6.1). (2) **Intervention-force arrival** = `func_03D510`: weighted colony pick `random_int(1, Σ weights)` (`lcall 0x181f,0x4d4` `@0x3D57E`), per `tory_uprising.md` §3 / §6.3. (3) **Tory-uprising odds** = `func_03CAC6`: rolls `random_int(0, [0x53a6]+1)` (`@0x3CADD`); uprising fires when result ≠ 0 (`or ax,ax; jne` `@0x3CAE5`), i.e. probability `(diff+1)/(diff+2)` (§6.3). **B.**
- "No wars during revolution" rule (`@NOWARSDURINGREV` = "Foreign colonies cannot be attacked during the {War of Independence}.") — **enforcement site BYTE_VERIFIED (2026-06-27).** The string's handle = `file_off − DGROUP base 0x1D9A0` = `0x1F493 − 0x1D9A0 = 0x1AF3` (formula self-verified against the siblings: `@NOCOLONIESEITHER` `0x1E32A−0x1D9A0=0x98A` ✓, `@NOMAYORSDURINGREV` `0x1F410−0x1D9A0=0x1A70` ✓, per `tools/rtlink/event_map.py` lines 6-7). The emit site is in the foreign-colony **attack handler `func_05A862`** (page `0F`, prologue `ENTER 0x0004,0`) at **`@0x5A912`**: bytes `8D1EF31A 9AFE031F18` = `lea bx,[0x1af3]; lcall 0x181f,0x3fe` (the `func_06F57E` notice-emit thunk — the SAME emit idiom as the page-07 sibling gate `@0x3FEAD`). It is reached only inside the `test [0x5382],1; je` (WoI bit-0 declared) gate at **`@0x5A8C8`**, after a chain of skip-tests that allow the attack unless the target is a rival European power/colony: owner-power load via current-colony struct `[0x8542]+0x1A` (`@0x5A8D5`, CLAUDE.md hard rule #8), King/REF id compare `[0x53D2]` (`@0x5A8ED`), and target UnitRecord (stride `0x1C`) owner nibble `[bx+0x3147]&0xF < 4` with PowerRecord (stride `0x34`) `[bx+0x543F]` active-power check (`@0x5A8F9..0x5A910`). On a match it emits `@NOWARSDURINGREV` and sets the cancel flag `[bp-4]=1`, which skips the attack-execution call `lcall 0x181f,0x934`→`func_007BCE` at `@0x5A92C`. The earlier "absent" finding was a tooling blind-spot: `tools/rtlink/event_map.py` scans only for the `push <handle>` byte pattern (`68 F3 1A`), so it (and the derived `event_emitters.json` / `event_catalog.json` `func:null`) missed the `lea bx,[handle]` (`8D 1E F3 1A`) emit form — which is the ONLY occurrence of handle `0x1AF3` in `VICEROY.EXE`. **B.**

## 4. UI
Declaration flow uses `@PICKINDEPENDENCE`, `@INDEPENDENCE`, `@ALREADYREVOLUTION`; Tory outcomes `@TORYUPRISING @TORYMAJORITY @TORYMINORITY @TOOTORY`; victory `@KINGVICTORY`. **All BYTE_VERIFIED present** (GAME.TXT). See `docs/SESSION_UI_CATALOG.md`, `spec/systems/king.md` §UI.

## 5. Evidence
- `docs/DATA_MODEL.md` — REF globals `0x53DA/0x53DC/0x53DE/0x53E0` (USER-VERIFIED); `PowerRecord +0x02` rebel sentiment. **B/runtime**
- `data_extracted/text/GAME_sections.json` — `@INDEPENDENCE @PICKINDEPENDENCE @ALREADYREVOLUTION @TORYUPRISING @TORYMAJORITY @TORYMINORITY @TOOTORY @NOWARSDURINGREV @KINGVICTORY`. **B (present)**
- `docs/GAME_MANUAL.md` §"Independence", revolution score bonus (1x/0.5x/0.25x; pre-1780 bonus). **R**
- `spec/systems/king.md` — REF = 4 globals; `+0x22` budget. **B**
- `func_03E984` (file `0x3E984`) — Declare-Independence handler: `@ALREADYREVOLUTION` gate `@0x3E988`, **SoL `< 0x32`→`@TOOTORY` `@0x3E99E`**, rebel-power set `[0x5398]=[0x5394]` `@0x3E9D8`, `@DECLARE` confirm `@0x3E9F0`, `→func_03DE46` `@0x3EA06`. **B**
- `func_03DE46` (file `0x3DE46`, `0x191F:0x356`) — WoI declaration: `[0x5382]|=1`, emits `@INDEPENDENCE` (handle `0x130B`, `@0x3E104`). **B**
- `tools/rtlink/event_emitters.json` — handle map: `@TOOTORY=0x1386`, `@ALREADYREVOLUTION=0x1374`, `@DECLARE=0x1397`, `@INDEPENDENCE=0x130B`. **B**
- **Cross-corroboration:** the king tax-demand driver `func_036138` reads `[0x53D0]` as `rebel_sentiment` in its severity score (`spec/systems/king.md` §3, `@0x361F9`) — an independent code path confirming `[0x53D0]` = national SoL meter. **B**

## 6. Open questions (TBD)
1. ~~Byte-trace the SoL% declare threshold (is it 50%?).~~ **Resolved 2026-06-20 — yes,
   50%.** Declare handler `func_03E984` rejects with `@TOOTORY` when `[0x53D0] < 0x32`
   (`@0x3E99E`) and proceeds to the `@DECLARE` confirm → WoI declaration `func_03DE46`
   at SoL ≥ 50 (§2). `[0x53D0]` = national SoL meter; `[0x5398]` = rebel power. **B.**
   *(History: an interim trace mis-routed the `[0x53D0]` gate through the
   Spanish-succession handler `func_03C638`; the `@TOOTORY` evidence settles it — see
   `notes/rulings/RULINGS.md`.)*
2. ~~Trace the REF-growth writer (what spends `+0x22` to add REF units).~~ **Done —
   resolved in `ref_growth.md`/`king.md`:** `func_03E162` accrues `royal_money +=
   (8·diff+10)·2^era`, buys a REF unit at **threshold 1800 (`0x708`)** and spends
   `+0x22 -= 1800` (`@0x3E271`), slot by ratio (3:1 reg:cav / 4:1 reg:art / 10:1
   land:naval). **B.**
3. **War-of-Independence end-game flow — BYTE_VERIFIED (completed 2026-06-21).**
   **Victory condition located:** the per-turn end-game resolver `@0x02F464` runs while WoI
   is **declared** (`[0x5382]&1`) and **not yet won** (`[0x5382]&8` clear). It scans all units
   `0..[0x539C]` (records at `0x3147+i·0x1C`), counts those **owned by the King/REF power**
   (unit owner low-nibble `[+0x3147]&0xF == [0x53D2]`) whose **type `[+0x3146]` ∈ {6, 8, 0xB}**
   (REF land+naval combatants) into `[bp-0x58]`. When that **surviving-REF count falls below
   the threshold** — `1` normally, `8` when `[0x5382]&0x40` is set (`@0x2F4D2..0x2F4E5`,
   `cmp thr,[bp-0x58]; jg`) — and the foreign-intervention force tally
   (`[0x53E0]+[0x53DC]+[0x53DA] ≥ 4`) clears, the rebels **WIN: `or [0x5382],8` `@0x2F55A`**,
   and the victory message is built from the **rebel PowerRecord `[0x5398]·0x34 + 0x540E`**
   (`@0x2F510`). So independence is won by **attriting the REF army below the survival
   threshold**, not by a timer. (The dispatcher `@0x2391C` separately sets `[0x5382]|=0x20`
   once SoL≥75 + declared + intervention-active, and `|=0x10` `@0x2FAE0` flags the REF-arrival
   phase.) This closes the former "partial" residual; tier → **B**. Pre-win machinery (all
   previously verified):
   the
   per-turn end-game dispatcher `@0x2391C` gates on the **Bolívar SoL meter `[0x53D0]`
   ≥ 75** (`cmp [0x53D0],0x4B`); game-phase flags `[0x5382]` **bit 0 = WoI declared**,
   **bit 1 = foreign intervention active**, **bit 3 (`0x8`) = independence WON** (gates
   the score bonus, §6.4 / `scoring.md` §6.3). One-time handlers: **`func_03DE46`** = WoI
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
4. ~~Verify the revolution score bonus multipliers.~~ **RESOLVED 2026-06-20 (`scoring.md`
   §6.3) — it's an ADDITIVE bonus, not a multiplier:** if independence is **won**
   (`[0x5382]&8`) and declared **before 1780**, score `+= (1780 − declaration_year) × 2`
   (`@0x3A609`). Declaration year stored by `func_03DE46` at `[0x53A7]`/`[0x53A8]`
   (`@0x3DE65`). Earlier = bigger bonus. **B.**
