# Random Events / Lost City Rumors

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Details TBD — breadth pass.

**Overall confidence:** event strings `BYTE_VERIFIED`; **Lost-City rumor: trigger
(features `0xB0`, RUNTIME-VERIFIED) + handler + `random_int(1,9)`→`@LOSTCITY<n>` +
full per-index meanings + FoY=8 immigrants + reward credit to `+0x2A` + scout bonus
`BYTE_VERIFIED`** (`func_061454`); per-index reward *magnitude* formulas `TBD`. (`func_05BE84` is the native **raid** handler — see `natives.md`.)
**Canonical primary:** `data_extracted/text/GAME_sections.json` (@LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE), `docs/GAME_MANUAL.md` (Rumors of Lost Cities, Corrupting Burial Grounds).

## 1. Purpose & behavior
A unit entering a "Lost City Rumor" map square triggers a random exploration
event. The manual states the outcome is a gamble: "there may be something of
value... or there may be nothing; it may be very dangerous... or benign; there
may be a Fountain of Youth, or an abandoned burial ground" (`docs/GAME_MANUAL.md`).
RECONSTRUCTED outcome set (manual, function only): treasure, Fountain of Youth
(burst of immigrants), nothing, danger, burial-ground desecration (native anger).

## 2. State & data
**Rumor outcome roll → `@LOSTCITY<n>` — BYTE_VERIFIED.** The base outcome is
`random_int(1, 9)` (inclusive, thunk `0x181F:0x4D4`) used **directly** as the
decimal suffix of the key via the itoa-append `@0x618D1` (no weight table). The
per-index meaning is the GAME.TXT body of `@LOSTCITY<n>` (all bodies present in
`data_extracted/text/GAME_sections.json`, **B**):

| n | `@LOSTCITY<n>` | Outcome |
|---|----------------|---------|
| 1 | Fountain of Youth | immigrant burst on the Europe docks (**8** free immigrants) |
| 2 | Seven Cities of Cibola | treasure unit worth `%NUMBER1` (ferry home by Galleon) |
| 3 | ruins of a lost civilization | immediate gold `%NUMBER0` |
| 4 | burial mounds | → `@BURIAL1/2/3` sub-dispatch (+`@SCREWED` if desecrated) |
| 5 | expedition **vanished** without a trace | triggering unit destroyed |
| 6 | nothing but rumors | fizzle |
| 7 | small friendly tribe | chief's gift of gold |
| 8 | trespassing near holy shrines | `%STRING0` tribe displeased |
| 9 | desperate survivors of a former colony | colonist(s) join your nation |

- `@LOSTCITY0` is **not** a rumor outcome — it is the recruit-menu prompt ("Which
  of the following individuals shall we recruit?") reused by the Fountain-of-Youth
  passage. **B.**
- **Burial sub-dispatch (n=4):** `@BURIAL1` cold/empty (nothing); `@BURIAL2`
  trinkets `%NUMBER0` (small gold); `@BURIAL3` incredible treasure `%NUMBER1`
  (treasure unit, needs a Galleon). `@SCREWED` is appended when a **human** player
  desecrates grounds owned by a **hostile** tribe (the tribe is then smited). **B.**
- `@VANISH` / `@CASHTREASURE` and `@FINDCITY`/`@NOCITY`/`@LOSTOURSCOUTS`/
  `@LOSTTHEIRSCOUTS` — related rumor/scout strings. **B (present).**

> Corroborated by the independent full decode of `func_061454` in
> `viceroy_source/src/random_events/lcr.c` (other branch), which agrees
> instruction-by-instruction with the above and with this branch's
> itoa-append/reward findings. The **per-index meanings here are sourced from
> this branch's own `GAME_sections.json`** (primary), not the reconstruction.

## 3. Formulas & rules

### Native **raid**-on-colony outcomes — `func_05BE84` (see `natives.md` §3)
> **Correction (2026-06-19):** `func_05BE84` is the **native-RAID** outcome
> dispatcher (message keys `RAIDWREAK/RAIDSTORES/RAIDBURN/RAIDSHIP/RAIDGOLD/
> RAIDNOTHING`), **not** the Lost-City rumor selector. The roll/dispatch mechanics
> are byte-verified — moved to **`spec/systems/natives.md` §3**.

### Lost-City rumor outcome selection — **BYTE_VERIFIED handler** (`func_061454`, file `0x61454`)
- Builds the outcome key as **`"LOSTCITY" + digit`** dynamically (bare `LOSTCITY`
  string `@0x618C2`), so `@LOSTCITY0..9` are selected by a computed index.
- **Scout bonus is byte-confirmed:** it tests the triggering unit's
  `unit_type == 5` (Scout, `@0x614A6`) and class byte `UnitRecord +0x15 == 0x16`
  (Seasoned Scout, `@0x614BB`) — the manual's "Seasoned Scout better at exploring
  rumors".
- **Outcome index → message (BYTE_VERIFIED):** the base index `n = random_int(1,9)`
  (`@0x614F6`), mutated by anti-streak / Scout / Founding-Father "no bad luck" /
  terrain gates, is used **directly** as the suffix of `@LOSTCITY<n>` — bare
  `"LOSTCITY"` `@0x618C2` + itoa-append `n` `@0x618D1`. The full n→meaning table is
  in §2 above. The message substitutes the **reward** `[bp-0x10]` (gold) /
  `[bp-0x32]` (treasure value), both computed **inline** `@0x618A1..0x618BF`; the
  treasury credit adds `[bp-0x10]` to `PowerRecord +0x2A` (gold) `@0x61C4C`. **B.**
- **One-time special (`n=4`):** gated by a per-power flag — now identified as
  **`AIPersonality[power] +0x30` (`[0x543E]`, base `0x540E` stride `0x34`)** bit
  `0x40` (`@0x6186B`: set on first occurrence, so the burial outcome's special path
  fires once per power). **B.**
- **Fountain-of-Youth count = 8 immigrants** — the FoY path calls the recruit-queue
  helper 8 times (`queue_immigrant(1,0)`). **B** (cross-confirmed by `lcr.c`).
- Remaining **TBD:** the exact per-index reward *magnitude* formulas (`[bp-0x10]` /
  `[bp-0x32]` inline rolls) and the `[0x5382]&2` debug-force-Cibola path.
- **Treasure value & transport** — `func_05C878` (file `0x5C878`; strings `CASHTREASURE`/`KINGGALLEON`/`LOOTCASH`). **BYTE_VERIFIED:** treasure gold = **`100 × UnitRecord[+0x15]`** (a Treasure unit stores value/100 in its class byte) `@0x5C882`. **Post-independence** (`[0x5382]&1`) it is cashed directly (no cut) `@0x5C88B`; **pre-independence** the King offers to transport it for a **per-difficulty fee** read from the word table at `DGROUP:0x8394` (indexed by `difficulty×2`) `@0x5C8C2`, substituted into the `@KINGGALLEON` message. Fee *values* are in the data segment (TBD). **Note (2026-06-19):** `DGROUP:0x8394`
is confirmed **BSS** (past the initialized DGROUP window `[0..0x2CC5)`, per
`viceroy_source/src/platform/dgroup_image.c`); it is a **per-difficulty table indexed
by `[0x53A6]`** with **no static writer** found in the disasm (cross-confirmed:
other-branch `king_events.c` verified the *address* only, "layout not yet decoded").
So the fee values are runtime-filled and need a live **data-segment dump** — they are
not EXE constants. (The DGROUP string base `0x1D9A0` is validated; the *initialized*
window is only `0..0x2CC5`, so `0x53EA`/`0x8394`/`0x2F7B` are all BSS.)
- Burial-ground → native alarm increase: **TBD**.

## 4. UI
Outcome surfaced via the dialog/text-template framework (`func_06EEEC` text
template parser, `func_06F0F4` dialog framework — `docs/ARCHITECTURE.md`,
BYTE_VERIFIED entry points). Concrete layout `TBD`.

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — @LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE. **B** (strings).
- `func_061454` (file `0x61454`) — Lost-City rumor handler: builds `LOSTCITY`+digit; checks unit_type 5 (Scout) + class 0x16 (Seasoned Scout). **B**
- `docs/GAME_MANUAL.md` — Rumors of Lost Cities; Corrupting Burial Grounds; Seasoned Scout. **R** (function).
- `docs/ARCHITECTURE.md` — `func_05A20E` scout interactions; `func_05C878` treasure transport. **B** (entry points).
- `func_05BE84` — native **raid** outcome dispatch (RAID* keys) — see `natives.md` §3. **B**

## 6. Open questions (TBD)
1. ~~Trigger condition: which map feature flags a tile as a rumor square.~~ **RUNTIME-VERIFIED 2026-06-19** — the **features map-layer byte `0xB0` (176)** marks a Lost-City/Rumor tile; stepping a unit onto it fires the event and **clears the tile to `0x00`** (`colonization-memory-map (1).md`, plant/remove **write-verified**). Map is 56×72 row-major (`tile = y·56 + x`). See `spec/systems/map_system.md`.
2. Outcome **base roll = `random_int(1,9)`** (B); the *bias* cascade (anti-streak rising-floor, Scout/Seasoned-Scout boost, Founding-Father "no bad luck" flag, terrain, per-session counters `[0x1DC6/7]`) still needs per-gate byte-verification for exact probabilities.
3. ~~Numeric effects: which `@LOSTCITY` index = treasure/FoY/burial.~~ **Done 2026-06-19** — full n→meaning table byte-verified (§2): 1 FoY(8 immigrants)/2 Cibola/3 ruins-gold/4 burial/5 vanish/6 nothing/7 gift/8 trespass/9 survivors. Remaining: the per-index reward *magnitude* roll formulas (`[bp-0x10]`/`[bp-0x32]`).
4. ~~Entry function that consumes @LOSTCITY*/@BURIAL*.~~ **Found 2026-06-19** — `func_061454` (builds `LOSTCITY`+digit; Scout/Seasoned-Scout check **B**). Remaining: the index→`@LOSTCITYn` mapping + Fountain-of-Youth/burial numerics.
