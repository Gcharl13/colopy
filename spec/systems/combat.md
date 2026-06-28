# Combat

> **Layer 2 — Specification.** PRIMARY data only (`/METHODOLOGY.md`). Tiers:
> `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED`.

**Overall confidence:** unit stats + land-odds form + **demotion ladder**
`BYTE_VERIFIED`; **terrain defense bonus values now `BYTE_VERIFIED`** (`$TERRAIN`
"Defensive" column: forests 2 / Hills 4 / Mountains 6); **capture-vs-destroy branch `BYTE_VERIFIED`** (`func_05B2C2`: Colonists/Treasure/Wagon seized via owner-reassign).
**Last updated:** 2026-06-19.
**Primary evidence:** `data_extracted/text/NAMES_sections.json` (@UNIT),
stat loader `func @0x74EC3`, land decider `func_05CA7E` (file `0x5CA7E`),
`notes/rulings/RULINGS.md` 2026-05-30 (wave-9/10, byte-traced).

## 1. Purpose & behavior
Resolves attacks between units (land and naval). The attacker either wins
(defender destroyed/demoted/captured) or loses (attacker destroyed/demoted),
decided by a single odds roll modified by terrain/fortification/veterancy.

## 2. State & data layout

| Field | Meaning | Tier | Evidence |
|-------|---------|------|----------|
| `@UNIT` rows (NAMES.TXT) | per-type stat columns (attack, defense, guns, …) | **BYTE_VERIFIED** | `data_extracted/text/NAMES_sections.json` |
| stat loader `@0x74EC3` | maps `@UNIT` col3 ATTACK→`0x5236`, col4 DEFENSE→`0x5235` (LAND, ×8 in accessor); col9 guns→`0x523B`, →`0x523C` (ship) | **BYTE_VERIFIED** | `notes/rulings/RULINGS.md` (wave-10 loader trace) |
| `UnitRecord +0x00` | `unit_type` = @UNIT row — indexes the **demotion** if-ladder | **BYTE_VERIFIED** | `docs/DATA_MODEL.md` |
| `UnitRecord +0x17` | `unit_class` / profession (abs `0x315B`) — the demotion **override** condition (`==24`) | **BYTE_VERIFIED** | `docs/DATA_MODEL.md`; `cmp [bx+0x315B],0x18` `@0x5B60E` (see §3) |

**Two combat functions (role split, RULINGS 2026-05-30):**
- `func_05CA7E` (file `0x5CA7E`, in `src/ai/unit_ai_leaf.c`) — the **LAND decider**: computes win/loss via `ATK/(ATK+DEF)` on *derived* strengths (stat pair `0x5235`/`0x5236`), applying the terrain/fort/veteran modifiers.
- `func_05B2C2` (file `0x5B2C2..0x5BE2C`, ENTER `0x3A`) — the **consequence applier**: demote/destroy/capture/spoils, plus the **ship** odds roll on *raw* stats `0x523B`/`0x523C` (gated to ship attacker types `0x0D..0x12`). The "+50% on the odds-roll inputs" was refuted **for the ship roll only** (raw stats); land modifiers live in `func_05CA7E`.

## 3. Formulas & rules

**Land-combat decider — `func_05CA7E` (file `0x5CA7E`, ENTER 0xDE). BYTE_VERIFIED
(wave-9 decode, `notes/rulings/RULINGS.md` 2026-05-30):**
```
odds = ATK / (ATK + DEF)        // same form as naval combat
```
- ATK/DEF are **derived strengths** from columns `0x5236` (atk) / `0x5235` (def),
  read via accessor functions (LAND uses `0x5235/0x5236`, **not** the ship pair
  `0x523B/0x523C`).
- Terrain / fortification / veterancy bonuses enter as **`·3/2` (+50%) multipliers**
  in the land strength-modifier chain inside `func_05CA7E`. The **bonus filler
  `func_007D3E` is now BYTE_VERIFIED** (2026-06-19; see §7.1): colony `+2`, fort
  (build-level ≥2) `+4`, `×2` condition, river/road `+(n+1)·2`, open-terrain `+`
  the `@TERRAIN` defensive byte — written to `[0x8D04]` and applied at
  `func_05CA7E @0x05CE05`. Exact per-terrain *values* are the `@TERRAIN` defense
  column (NAMES data; column-legend pending). Per the game
  manual (`docs/GAME_MANUAL.md`; RULINGS 2026-05-30) the +50% bonuses are: attacker
  surprise (+50% ATK), **fortified** (+50% DEF), **veteran** (+50%), and **European
  bombardment** of a colony (+50%). Tier **R** (manual) for the set; mechanism
  located **A**; the specific **+50% / strength-modifier sites in `func_05CA7E` are now BYTE_VERIFIED** (file 0x5CA7E spans 0x5CA7E..0x5D044+, the disasm header's "429 bytes" is truncated). Attacker strength `[bp-0x90]` is built then modified by, in order: (1) the **terrain/fort defense bonus** `[0x8D04]` applied as `strength·(bonus+4)/4 ·3/2` at `func_05CA7E @0x05CE05` (`mov ax,[0x8d04]; add ax,4; imul [bp-0x90]; sar ax,2`, then the `·3/2` chain `cx=ax; ax<<1; ax+=cx; ax>>1` @0x05CE16); (2) a generic terrain multiplier `·[bp-0x96]/3` @0x05CE69; (3) **colony-present +50%** — when a colony/occupant exists on the defending tile (`[bp-0xd4]≥0`, from `0x181F:0x6BE → func_005FD4` occupant-at-tile @0x05CBC3): `[bp-0x90] += [bp-0x90]>>1`, sets flag `[0x8d01]|0x10` (`func_05CA7E @0x05CF43`); (4) **REF/War-of-Independence bombardment +50%** — gated on `[0x5382]&1` (endgame flag) and defender owner `[bp-0x86]==[0x53d2]` (self/REF power): `[bp-0x90] += [bp-0x90]>>1`, flag `[0x8d01]|0x80` (`func_05CA7E @0x05CF7D`); (5) **Sons-of-Liberty / rebel-sentiment %** scaling `strength·pct/100` where pct = `func_008524` (`0x181F:0xC86 @0x05CF98`, role 'SoL%/rebel-sentiment compute'); (6) **difficulty scaling** `strength·diff/20` (`al=[0x53a6]; imul [bp-0x90]; cx=0x14; idiv` @0x05CFFC). Final land odds = `(ATK·8)/(DEF+1)` (`shl ax,3; cx=[bp-0xa6]+1; idiv` @0x05D032) in evaluate mode, or the act-mode roll `random_int(1, ATK+DEF) ≤ ATK ⇒ attacker wins` (`0x181F:0x4D4 → func_00C322 @0x05D188`, `cmp roll,[bp-0x90]; jg ⇒ loss`). The mechanism/conditions are **B**. The live *strength inputs and SoL%* are **resolved as per-engagement state**: attacker strength is built in `[bp-0x90]` and defender in `[bp-0xa6]` from the per-type stat columns `0x5236`(atk)/`0x5235`(def) (loaded by `func @0x74EC3`), then modified by the byte-cited chain above; the SoL/rebel-sentiment percentage is the return of `func_008524` (`0x181F:0xC86 @0x05CF98`, role 'SoL%/rebel-sentiment compute', confirmed in `thunk_resolve.json`), applied as `strength·pct/100`. Source globals + compute sites + apply sites are all byte-cited; the numeric values are per-engagement game state (live unit stats + colony SoL%), not static constants — nothing further to decode. **B (source); STATE (values).**
- `func_05CA7E` has an **evaluate vs act** mode (`[bp+0xE]`): mode 0 = AI ranking
  (returns the score), else = apply the result.
- **Difficulty combat handicap — BYTE_VERIFIED (2026-06-20):** before the odds roll,
  a **human-controlled** combatant gets `strength += (4 − difficulty)` on **both**
  sides — attacker `[bp-0x90] += (4−diff)` (`@0x5CE35`) and defender `[bp-0x86]`/
  `[bp-0xa6] += (4−diff)` (`@0x5CE54`) — gated on `AIPersonality.controller==0`.
  So the human's units carry +4 strength at Discoverer down to +0 at Viceroy
  (`diff=[0x53A6]`); the AI branch gets no such bonus. A generic strength base
  `[bp-0x34] = diff + 5` is also formed at `@0x3F005` (tile-combat terrain eval).
  See `spec/systems/difficulty.md` §3. **B.**

**Demotion ladder — BYTE_VERIFIED** (consequence applier `func_05B2C2`, if-ladder
at file `0x5B5AA..0x5B61F`; `viceroy_source/src/combat/combat_demotion_ladder.c`).
A defeated unit's *type* (`UnitRecord +0x00`) is looked up to its demoted type;
no match ⇒ the unit is **destroyed**:

| Source type (@UNIT) | → Demoted type (@UNIT) | site |
|---------------------|------------------------|------|
| 1 Soldiers | 0 Colonists | `0x5B5C3` |
| 4 Dragoons | 1 Soldiers | `0x5B5B3` |
| 7 Cont. Cav. | 9 Cont. Army | `0x5B5DF` |
| 8 Cavalry | 6 Regulars | `0x5B5EF` |
| 9 Cont. Army | 0 Colonists | `0x5B5CF` |
| any other | *destroyed* (outcome −1) | — |

Override (`0x5B60B..0x5B616`) — **RESOLVED 2026-06-20**: if the outcome is `0`
(Colonists) **and** the profession byte `UnitRecord +0x17 == 0x18` (`@0x5B60E`
`cmp [bx+0x315B],0x18`), the outcome becomes type `3` instead. **Class `0x18` =
Missionary** (`@JOB` 24); **type `3` = Missionaries** (`@UNIT` 3). So an armed unit
whose colonist profession is **Missionary**, when it would demote to a plain
Colonist, instead reverts to a **Missionaries** unit. **B** (both ids confirmed vs
NAMES).

**Capture vs destroy — BYTE_VERIFIED** (`func_05B2C2`). Before the demotion ladder,
a **capture-eligible flag `[bp-0x16]`** is set (`@0x5B31D..0x5B33D`): it is **1 iff the
defeated unit's type ∈ {`0` Colonists, `0xA` Treasure, `0xC` Wagon Train}**, else 0.
It is **downgraded to 0 (→ destroy)** if the winner is a **ship** (`type 0xD..0x12`)
without transport room (`[bp-0x28]==0`, `@0x5B410..0x5B428`) or the zero-attack guard
at `@0x5B404` fails. Then at `@0x5B49E`:
- **flag set AND loser owner European (`<4`, `[bp-0x30]`)** ⇒ **capture**: the unit's
  owner nibble is reassigned to the winner via `set_unit_owner` (`0x181F:0x894` →
  `@0x00738E`: `unit[+0x3147] ^= (owner_xor & 0xF)`), and the seizure posts
  `@COLONISTCAPTURE` / `@LOOTCAPTURE` (treasure) / `@WAGONCAPTURE`. The unit changes
  hands intact (not demoted, not destroyed).
- **flag clear** ⇒ fall through to the demote/destroy ladder above (`@0x5B58C`).

So Colonists / Treasure / Wagon Trains are **seized** by a land victor; combat units
(Soldiers/Dragoons/…) demote or are destroyed; and a **ship** victor that can't carry
the prize destroys it instead.

## 4. UI layout
Combat-result popups (win/lose/demote/capture) use the shared dialog framework
(`docs/UI_DIALOGS.md`, `docs/POPUP_TEMPLATE_AUDIT.md`). **Message keys now
BYTE_VERIFIED** — `func_05B2C2` pushes the GAME.TXT section name as the single
argument to the message routine `lcall 0x181f:0x652` (= thunk `0x0000:0x37A2`,
the same routine that emits `"HALF"` in `func_05CA7E @0x05CB83`). The DGROUP
file base is `0x1D9A0` (verified: `"HALF"` @file `0x1F5A6` = `push 0x1C06`;
`"Bad defense"` @file `0x1F681` = `push 0x1CE1`). The keys, with the exact push
site in `func_05B2C2` and the loser-type / branch that selects each, all
confirmed present in `data_extracted/text/GAME_sections.json`:

| GAME.TXT key | push site | branch / selecting condition |
|--------------|-----------|------------------------------|
| `@LOOTCAPTURE` | `@0x05B544` (`push 0x1B13`) | loser type `== 0xA` Treasure (`sub al,0xA; jne`, `@0x05B53E`) |
| `@WAGONCAPTURE` | `@0x05B566` (`push 0x1B1F`) | loser type `== 0xC` Wagon Train (`cmp ax,0xC; je`, `@0x05B533`) |
| `@COLONISTCAPTURE2` | `@0x05B57E` (`push 0x1B2C`) | loser type `== 0` Colonists **and** prof byte `[bx+0x315B]==0x15` (`@0x05B570`; rewritten to `0x1C`) |
| `@COLONISTCAPTURE` | `@0x05B586` (`push 0x1B3D`) | loser type `== 0` Colonists, else branch |
| `@DEMOTE` | `@0x05B679` (`push 0x1B4D`) | demotion-ladder outcome |
| `@ARTILLERY` | `@0x05B6E7` (`push 0x1B54`) | sets `[bx+0x3148] |= 0x80` (`@0x05B6F6`) |
| `@ARTILLERY2` | `@0x05B740` (`push 0x1B5E`) | ship-type guard (`cmp [bx+0x3146],0xD`, `@0x05B74B`) |
| `@CARGOCAPTURE` | `@0x05B98C` (`push 0x1B69`) | cargo seizure |
| `@SHIPDAMAGE` | `@0x05BC79` (`push 0x1B76`) | ship roll (raw `0x523B/0x523C`, `@0x05B819`) |
| `@SHIPSUNK` | `@0x05BD0F` (`push 0x1B81`) | ship roll, tests `[bx+0x3148]&0x40` (`@0x05BD1E`). **Flag provenance RESOLVED:** the only set site is `func_02F052 @0x02F37A` (overlay page 03) `or byte ptr [si+0x3148],0x40` (enc `80 8c 48 31 40`, **si-mode** — the earlier bx-pattern `80 8f 48 31 40` search missed it); it is the unique writer (no clear site; grep of `483140`/`4831bf` over all disasm). `func_02F052` is a per-player ship-iteration routine that computes a cargo accumulator into `[si+0x315a]` (via `0x191F:0xAEE → func_041832`) and sets bit 0x40 to mark the ship as **carrying cargo**; the @SHIPSUNK reader scatters/loses that cargo (the `[bp-0x2e]` 0..6 cargo-slot loop at `@0x05BD28`). |

## 5. Evidence
- `data_extracted/text/NAMES_sections.json` — `@UNIT` stat columns (demotion target names). **B**
- `notes/rulings/RULINGS.md` 2026-05-30 — `func_05CA7E` land-odds decode; the land vs ship role split; `@0x74EC3` stat-offset mapping; +50% modifier reconciliation. **B**
- `viceroy_source/src/combat/combat_demotion_ladder.c` — demotion if-ladder at `func_05B2C2` `0x5B5AA..0x5B61F`. **B**
- `viceroy_source/src/combat/combat_modifiers.c` — ship odds roll uses raw `0x523B/0x523C` (no scaling), 3 byte-proofs. **B**
- `docs/DATA_MODEL.md` — UnitRecord `+0x00`, `+0x15`. **B**
- `docs/GAME_MANUAL.md` — the four +50% bonuses (attack/fortify/veteran/bombardment). **R**

## 6. Confidence summary
- **B:** unit stat columns; stat-offset mapping; land odds = ATK/(ATK+DEF);
  the +50% modifier mechanism's location; the **demotion ladder** (index table +
  offsets) and its `+0x15==24` override; the **terrain defense bonus** filler
  (`func_007D3E`) and its **per-terrain `$TERRAIN` "Defensive" values** (forests 2 /
  Hills 4 / Mountains 6 / Marsh-Swamp 1 / open 0).
- **R:** the set of +50% bonuses (manual-sourced).
- **B (added):** capture-vs-destroy branch (`func_05B2C2`: seize Colonists/Treasure/
  Wagon Train via owner-reassign `0x181F:0x894`; ship-victor-without-room destroys).
- **B (added 2026-06-20):** the `+0x17==0x18` override = **Missionary (class 0x18) →
  Missionaries unit (type 3)** (§3, ids confirmed vs NAMES). **Veteran win-promotion**
  (`@0x5C764`): a winning non-veteran is promoted iff `random_int(1, S) ≤
  winner_strength` where `S = atk_str + def_str ± difficulty` (human `+diff`/AI
  `−diff`) minus a class penalty (Criminal `0x1A` −10, Indentured `0x19` −5); the
  **Washington** gate `@0x5C74A` (`has_father(11)`) **skips the roll → automatic**.
  Soldiers(1)→Cont.Army(9) on promotion. **B** (form; numeric P is strength-data-dependent).
- **B (added 2026-06-25):** combat-result **message keys** — `func_05B2C2` emits
  `@LOOTCAPTURE` / `@WAGONCAPTURE` / `@COLONISTCAPTURE` / `@COLONISTCAPTURE2` /
  `@DEMOTE` / `@ARTILLERY` / `@ARTILLERY2` / `@CARGOCAPTURE` / `@SHIPDAMAGE` /
  `@SHIPSUNK` via the message routine `lcall 0x181f:0x652` (push sites `@0x05B544`..
  `@0x05BD0F`; full table + branch conditions in §4). All keys present in
  `GAME_sections.json`.
- **Naval combat roll — RESOLVED 2026-06-27 (B).** The general resolver `func_05B2C2`
  (`@0x05B2C2`, `ENTER 0x3a`; args `[bp+6]`=attacker, `[bp+8]`=defender unit idx) handles land
  **and** naval. For ships (type `0x0D..0x12`): the two strengths come from **UnitTypeStats** fields
  `0x523B`/`0x523C` = the **`+0x0B`/`+0x0C` bytes of the 14-byte record at `DS:0x5230`** (i.e. a per-
  type attack/defense stat, loaded once `func_074ED5`; *not* per-engagement accumulators). Roll
  (`@0x05B844`): `A = stat[atk_type·14+0x523B]`, `D = stat[def_type·14+0x523C]`, **`roll =
  random_int(1, A+D)`** (`func_00C322` via `0x181F:0x4D4`); the attacker-win flag `[bp-0x3A]` is kept
  when `roll ≤ D`-threshold (`cmp ax,[bp-0x1c]`), with independence-war special cases clearing it
  (`test [0x5382],1 @0x05B87D/@0x05BA2D`, REF/intervention comparisons `[0x53d2]`/`[0x5398]`). Loser
  fate branches at `@0x05BAA3` to the capture/cargo/sink path. A **separate land roll** uses
  `random_int(3,6)` + terrain at `@0x05BA0B` (`0x181F:0x35C`). **B.**
- **`func_05CA7E` (combat.md residual) — RESOLVED: it is a PRE-COMBAT / combat-UI setup** routine
  (reads the unit array `+0x3146/+0x3147/+0x3149/+0x314a`, sets the ship-range flag for types
  `0x0D..0x12`), **not** the roll. **B (negative).**
- **Shore-bombardment (fort/stockade/fortress fire on adjacent ships) — RESOLVED 2026-06-27 (B).** Site = `func_02D3C6` (overlay page 03, file `0x02D3C6`, ENTER 0x1A), located via @FORTFIRE's DGROUP key blob: the key string `FORTFIRE\0` lives at DGROUP off `0x0D7F` (file `0x1D9A0+0x0D7F = 0x1E71F`), pushed as `push 0xd7f` (`68 7f 0d`) at `@0x02D5D9`, sole occurrence. Mechanics: the colony at `*(0x8542)` accumulates a fire **strength** `[bp-0xe] = artillery_count · fort_level · 4` — `[bp-0x10]` starts 1 and is +1 per **Artillery** unit (type `0xB`, `@UNIT` 11) in the colony (`@0x02D432`); `[bp-0xa]` is the fortification-building level (0 none / +1 stockade `0x181F:0x9FC(1)` / +1 fort `0x181F:0x9FC(2)`, `@0x02D3D6`/`@0x02D3EE`). If strength `== 0` (no fort building) the routine **returns without firing** (`@0x02D44D` `jne` else `jmp 0xb02 retf`) — so only stockade/fort/fortress colonies fire, matching the manual. It scans the 8 neighbor tiles (dx/dy arrays `[bx+0xbe]`/`[bx+0xb4]`, `[bp-0xc]` 0..7) for an enemy ship (type `0xD..0x12`), at war (`0x181F:0xA38 → func_007F34`, `test al,0x40` `@0x02D4E3`), different owner (`@0x02D4D2`), with a Privateer (`0x10`) special-case (`@0x02D4EB`), selecting the target into `[bp-0x18]`. **There is NO random roll** — fire is deterministic given a fort building + an eligible adjacent enemy ship (grep of the function for `0x181F:0x4D4`/`0x35C`/`0x4C0` random thunks: none). Damage-vs-sink is the **owner-bit test** `[si+0x3147] & (0x10<<[0x5396])` `@0x02D530..02D541` → `[bp-6]` (1=sink,0=damage). It spawns the cannon-effect unit via `0x191F:0xA20 → func_04002C` (a new type-0x17 unit at `[0x539c]++`, `@0x04002C`) and emits **@FORTFIRE** at `@0x02D5D9`. **B.** (Note: the @SHIPSUNK in `func_05B2C2` is the *unit-vs-unit* naval-loss path; this shore-fire path is separate, as suspected.) The only residual is cosmetic — which message (`@SHIPDAMAGE` vs `@SHIPSUNK`) the `[bp-6]` owner-bit result prints; the hit *mechanism* (`[bp-6]`: 1=sink / 0=damage) is **B**. (The fort/stockade/fortress *defense bonus* for land attack is the hardcoded `func_007D3E` colony `+2` / fortified-building `+4` / `×2` chain, §7.1.)

## 7. Open questions → `spec/BACKLOG.md`
1. Terrain/fortification defense bonus — **mechanism BYTE_VERIFIED (2026-06-19),
   per-terrain *values* in `@TERRAIN` data.** The filler is `func_007D3E`: it zeroes
   `[0x8D04]`/`[0x8D02]`, then accumulates a defense bonus in `[bp-0x18]` with a
   bonus-type flag in `[0x8D02]`:
   - **colony present → `+2`** (`@0x7D8D`);
   - **fortified building** (settlement build-level `≥ 2`) → **`+4`**, flag `0x10`
     (`@0x7DBC`); a further condition **doubles** it (`×2`), flag `0x20` (`@0x7DD1`);
   - **river/road feature** present → **`+(n+1)·2`**, flag `0x40` (`@0x7E12`);
   - **open terrain** → add the **per-terrain `@TERRAIN` "Defensive" value** (column 2
     of the `$TERRAIN` row; legend byte-verified in `map_system.md`), read at
     `[terrain·16 + 0x2F77]` (`@0x7E63`), gated by a post-independence/AI check
     (`[0x5382]&1`, `@0x7E45`).
   **Per-terrain Defensive values (now BYTE_VERIFIED from `$TERRAIN` data):**
   open (Tundra/Desert/Plains/Prairie/Grassland/Savannah) = **0**; Marsh/Swamp = **1**;
   all forests = **2** (Rain = **3**); **Hills = 4**; **Mountains = 6**; Arctic/Ocean/
   Sea-Lane = 0. These are added to `[bp-0x18]` then applied via the `·3/2` chain.
   `func_05CA7E @0x05CE05` reads `[0x8D04]` and applies it via the `·3/2` chain. So
   the **bonus structure is byte-verified**; the per-terrain *numbers* live in the
   `@TERRAIN` attribute table (NAMES-loaded, `terrain·16` stride) — the defense
   column is read at row offset `0x2F77`, value-decode pending the `@TERRAIN` column
   legend (`spec/data/tables.md`).
   > **Correction:** the prior "values flow through thunks `0x181F:0x7E0`/`0x6BE`/
   > `0x7BE`" was **wrong** — per `naval_classify.c`, `0x7E0`=`occupant_at`,
   > `0x6BE`=`owner_at`, `0x768`=`ovl_fortify_accum`; these are **map-query helpers**,
   > not bonus-value tables.
2. ~~Decode the **capture** path.~~ **RESOLVED 2026-06-20** — `func_05B2C2` **does**
   have an in-combat capture branch: capture-eligible flag `[bp-0x16]` set for loser
   types {0 Colonists, 0xA Treasure, 0xC Wagon Train} (`@0x5B31D`); on a land victor
   the unit's owner nibble is reassigned via `set_unit_owner` (`0x181F:0x894 → @0x738E`,
   `@0x5B4C7`); a ship victor without transport room destroys it instead. (The prior
   "no capture branch" note was wrong; the `func_03C638` reassign is the *separate*
   succession transfer.) The `+0x17==0x18`→type-3 demotion override still warrants a
   runtime spot-check.
3. Naval combat & bombardment specifics (ship pair `0x523B/0x523C`, roll in `func_05B2C2`).
