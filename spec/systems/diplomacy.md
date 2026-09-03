# European Diplomacy

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Body fully populated: meeting/parley dispatcher (`func_057F4E`), SIGNTREATY handler (`func_057DC0`), both relation matrices (`+0x34` war / `+0x40` treaty), AI willingness thresholds, cooldown, and privateer attribution are all BYTE_VERIFIED; the numbered open questions in §6 are resolved.

**Overall confidence:** **meeting handler `func_057F4E` + SIGNTREATY handler `func_057DC0` + both relation matrices (`+0x34` war / `+0x40` treaty, bit meanings incl. `0x08`=grievance / `0x80`=privateer) + AI willingness thresholds (attitude table `DGROUP:0x940C`, no-action cutoff `(attitude>>2) > demand` `@0x58C24`) + cooldown `BYTE_VERIFIED`** (2026-06-20). **Canonical primary:** `func_057F4E`/`func_057DC0`; `data_extracted/text/GAME_sections.json` treaty/war keys; `docs/GAME_MANUAL.md`.

## 1. Purpose & behavior
The player coexists with three rival European powers (English/French/Spanish/Dutch set). They can sign treaties, declare war, make peace, and conduct hostile actions (privateering, blockades). Relations are tracked as boolean war/peace state between power pairs, surfaced through diplomatic dialogs. **RECONSTRUCTED** (manual + GAME.TXT keys).

## 2. State & data
- **War bit-matrix** at `DGROUP:0x883C` = a **4×4 per-pair byte matrix embedded as
  `PowerRecord +0x34`** (base `0x8808+0x34`, row-stride `0x13C`). **BYTE_VERIFIED
  layout** (`@0x58A72`): the cell is `PowerRecord[subject] + 0x34 + target` — i.e.
  `imul si, subject, 0x13C; bx = target; [bx+si-0x77C4]` (`-0x77C4 = 0x883C`; that
  displacement form is why a literal-`0x883C` grep found "no xrefs"). **Bit catalogue
  — BYTE_VERIFIED (2026-06-20):** `0x01` = resolved/normalized relationship (set
  `@0x5318F`), **`0x02` = at war** (set `@0x58A7B`/`0x59A61`/`@0x3F0E8`, cleared
  `@0x5DE98`), **`0x08` = pending grievance** (set `@0x3F0D7`/`@0x59AE9` when the
  grievance-score `[bx−0x6BE4]` crosses a threshold; per-turn it transitions to bit
  `0x01` when its timer `+0x40` expires and `random_int(0,3)==0`, `@0x53165`),
  **`0x20` = peace-pending** (gate in SIGNTREATY `@0x57DF0`), **`0x40` = met/contacted**,
  **`0x80` = Privateer hidden-attribution** (set only under attacker-type `==0x10`
  guard `@0x3F0A1`, *instead of* the war bit; cleared/revealed `@0x58BE1`).
- **Treaty/relation-state matrix** — a **second** 4×4 byte matrix at
  `PowerRecord +0x40` (`DGROUP:0x8848`, same `0x13C` row-stride). **BYTE_VERIFIED bit
  meanings** (`func_057DC0`, the SIGNTREATY/treaty-state handler, verified vs EXE):
  bit **`0x02` = at war / hostile** (`test al,2 @0x57E05`), **`0x20` = peace/
  treaty-pending** (`@0x57DF0`), **`0x40` = existing treaty/alliance** (`@0x57E7D`).
  `func_057DC0` writes the matrix **symmetrically** (`matrix[A][B] = matrix[B][A]`,
  `@0x57EC5`/`@0x57ED0`): state `1` = treaty established, `0` = cleared/war; it emits
  `@SIGNTREATY` (`0x188D`) / `@CANCELTREATY` (`0x1898`) / `@DECLAREWAR` (`0x18A5`).
- **Treaty cooldown** at `[power*2 + 0x53C8]` (word) — set to `turn + 0x10`
  (`@0x58075`/`0x5914C`); a 16-turn re-parley lockout. **BYTE_VERIFIED.**
- PowerRecord base `DGROUP:0x8808`, stride 316 (0x13C), 4 powers.

> `func_03ECF0` was previously mislabeled "diplomatic_action_init" — per `RULINGS.md`
> it is the **per-unit confrontation/command AI evaluator**, **not** diplomacy.

## 3. Formulas & rules
**Meeting / parley dispatcher — `func_057F4E` (file `0x057F4E..0x059B3C`, page 0x0F,
ENTER 0xD6). BYTE_VERIFIED (located + key mutations, 2026-06-19; verified vs EXE).**
Runs when two powers meet and exchange treaty / peace / tribute / war. Structure:
- **human-only gate** `@0x57F8C` (`cmp [bp+6],4; imul bx,*0x34; cmp [bx+0x543F],0`).
- **dialog** via `0x1A1F:0x688 → func_06F61C`; option tree via `func_057A3A`; topic
  keys (all byte-verified pushes) include `PIRACY/SIEGES/TRIBUTE/WANTSTUFF/PROVOKE/
  WARMANLY/WORTHY/PEACE/OLDPEACE/PEACEUSA/GIVECASH/GIFTS/THREATS/WITHDRAW`.
- **declare war:** set war-matrix bit `0x02` (`@0x58A7B`); **make peace:** clear bit
  `0x80` (`@0x58BE1`) + treaty-bit clear (`rel_clear_event 0x40`); **sign treaty:**
  treaty-bit set (`rel_apply_event 0x40`, `0x181F:0xA06`), **gold transfer** on a paid
  treaty (subtract from power-b gold), per-unit ownership transfer (UnitRecord stride
  `0x1C`), and the cooldown write above.
- **Difficulty-scaled demand terms — BYTE_VERIFIED (2026-06-20)** (within
  `func_057F4E`, `diff=[0x53A6]`):
  - **AI war/refusal grace period** = `10·(10 − diff)` turns vs `[0x538E]`
    (100/90/80/70/60 — lower difficulty = longer peace) (`@0x58374`).
  - **Tribute/demand value** scaled `value · 10·(diff+8) / 100` (×0.8…×1.2)
    (`@0x583A0`); a flat **demand surcharge `+= 500·(diff+1)`** (`@0x5842B`); a
    `(diff+1)·value >> 3` term feeds a 0..400 roll (`@0x58409`); an
    attitude/demand component `+= (diff−2)·meeting_val` (`@0x58580`).
  - **AI action probability** gate `random_int(1000) < 200·diff + 100` (10%…90%)
    (`@0x58315`). See `spec/systems/difficulty.md` §3.
  - **AI willingness thresholds — BYTE_VERIFIED (re-verified vs EXE 2026-06-25).**
    Attitude is a per-power byte at `DGROUP:0x940C` (displacement `[bx-0x6BF4]`,
    indexed by the power arg). (a) **No-action gate** `func_057F4E @0x58C24`: the AI
    declines to act when `(attitude>>2) > demand_score` **and** (`demand_score <= 0xC`
    **OR** `random_int(0,4) != 0`) — i.e. it only proceeds past the gate when
    `(attitude>>2) <= demand_score`, or when `demand_score > 0xC` and the
    `random_int(0,4)` roll hits 0 (`shr al,2` `@0x58C2B`; `cmp [bp-6],0xC` `@0x58C35`;
    `lcall 0x181f,0x4d4 (random)` `@0x58C42`). (b) **Final accept/affordability gate**
    `@0x58E1F`: struct ptr `[0x84FC]`, demand value (`[bp-0x66]`, sign-extended via
    `cdq`) is compared against the 32-bit gold field at `+0x2A/+0x2C` (`cmp [bx+0x2C],dx`
    `@0x58E1F`, `cmp [bx+0x2A],ax` `@0x58E29`). (c) **Target eligibility** `@0x57B1A`:
    requires turn `>= 0x28` (`cmp [0x538E],0x28` `@0x57B10`) **and** at least one of the
    two powers' attitude `>= 8` (`cmp byte ptr [bx-0x6BF4],8` `@0x57B1A`/`@0x57B24`).
    Plus the difficulty-scaled demand terms above.
- **Privateer attribution** (BYTE_VERIFIED, see §2 / §6.3): in the war-declaration resolver `func_03ECF0`, a unit-type guard `cmp byte ptr [bx+0x3146],0x10` (`@0x3F092`, type `0x10` = Privateer) routes a privateer attack to `or byte ptr [bx+si-0x77C4],0x80` (`@0x3F0A1`, `-0x77C4 = 0x883C` war-matrix) — setting the **hidden-attribution bit `0x80`** *instead of* the war bit `0x02`, so the aggression is not openly imputed to the controlling power (cleared/revealed `@0x58BE1`). **Blockade:** there is no *diplomatic* blockade topic (0 `blockad*` strings in `data_extracted/text/`), but a mechanical **harbour-blockade census does exist** (amended 2026-08-29): `func_042138` writes ColonyRecord `+0x1B` bit 0 when another power's ship stands within the ±5 box at water-path ≤ 5, bit 1 for a Frigate (`spec/systems/colony.md`), skipping the Custom-House auto-sale and gating `@KINGFRIGATE` (`king.md` §3). The land-adjacency **SIEGE** production restriction is a separate mechanic. **B.**

**Autonomous war starts — the complete war-bit-2 writer inventory
(BYTE_VERIFIED 2026-08-29).** A sweep of every `relation_or`
(`func_007F96`, `0x181f:0xa06`, sole thunk) call and every direct
war-matrix write finds war bit `0x02` set at exactly these sites:
`@0x58A7B` (meeting declaration, above), `@0x59A71` (one-sided war on a
parley outcome inside `func_057F4E`: `0xa06([bp+8], [bp-0xC8], 2)`),
`@0x3F0E8` (the attack resolver `func_03ECF0`), and **one autonomous
driver** `@0x542F0` — and *none* of them is a background European-vs-
European grievance cycle. **There is no autonomous Euro-Euro AI war
start in VICEROY.EXE**; European wars begin only from meetings, attacks,
and the King's own `bit 0x10` war (`king.md` §3).

The autonomous driver `@0x542F0` is a **native tribe declaring war on an
AI European power**, embedded in the per-colony AI pass
(`func_053B7E`, called per AI-power colony from `func_052F7E` — the
`AIPersonality.controller == 1` branch of the turn loop `@0x5A37`).
Actors: `[bp-0x1AE]` = the colony's owner power (ColonyRecord `+0x1A`
`@0x53C38`); the tribe is whichever the colony-head call
`func_046056(x, y, −1, region)` (`0x181f:0xd84` `@0x53CA9`) selected —
the **nearest native settlement in the colony's region** (it chains
`func_0081F2` → `func_0081C6`, leaving `[0x8D52]` = tribe 0..7,
`[0x8D50]` = tribe owner id +4, `[0x8DB8]` = distance). Gates, in order
(`@0x54225..@0x542E4`, census tables from `func_042138`/`func_0427D6`;
note the negative DGROUP displacements are the same bytes as the
positive-offset tables, mod 0x10000):

- region flag `[0x95F2+r]` (`−0x6A0E`) **bit 0** set — a native
  settlement is in the region (`@0x426C7`);
- if flags **& 6** (a *foreign* European unit `@0x423CD` / colony
  `@0x425F3` shares the region) the war path is skipped unless the
  defender is **power 2 (Spain)** (`@0x54244`);
- the power's regional unit strength `[0x95B2 + p·16 + r]` (`−0x6A4E`,
  saturating census byte `@0x423AA`) **≥ 2** (`@0x5425C`);
- tribe total strength `[0x9184+t]` (`−0x6E7C`, `@0x427E9`-zeroed,
  unit-loop summed) **≤ 2 × power total strength** `[0x941C+p]`
  (`−0x6BE4`, `@0x42335`) — ×4 for Spain (`@0x54266..@0x542B5`);
- tribe regional strength `[0x91CC + t·16 + r]` (`−0x6E34`) **<
  4 × the power's regional strength byte** — ×8 for Spain
  (`@0x54283..@0x542CB`);
- tension `func_0082A0(t, p)` (`0x181f:0x30c`) **> 25**, or the
  defender is Spain (`@0x542D2..@0x542E4`) — the tension table geometry
  is confirmed here: `[0x5B1C + (t·0x27 + p)·2]` = TribeRecord `+0x46`,
  4 word slots per 0x4E-stride record = one per European power;
- then `relation_or([bp-0x1AE], [0x8D50], 2)` — war between the tribe
  and the colony's power (`@0x542F0`).

The score half of the same block (`@0x541B4..@0x54222`) computes
`[bp-0x72] = ((pop+[0x8D72])·3/2 − wartier − turn>>7 + stance-adj) /
(wartier+5 ±1)` from the per-power triple at `[0x9566 + p·3]`
(`−0x6A9A..−0x6A98`, a **persisted SAV field** — loader `@0x74C3D..`
reads three bytes per power via `0x1a1f:0x88a`; meaning TBD) and the
per-power-region stance byte `[0x9870 + p·16 + r]` (`−0x6790`, writer
`@0x4DE74..` in the AI strategy pass) — it feeds the garrison sizing,
not the war gate. **Port status:** the port keeps tribe tension only
toward the *player* and rival colonies as static records (ledger B3.6),
so a tribe→AI-power declaration has no consumer there — documented,
not implemented (`docs/REMAINING_WORK.md` C1.17).

> Corroborated by `viceroy_source/src/diplomacy/{meeting,relations,treaty}.c`
> (other branch); the offsets above are re-verified against this branch's EXE.

## 4. UI
Diplomatic dialogs use GAME.TXT keys: `@SIGNTREATY @HAVETREATY @DECLAREWAR @CANCELPEACE @PEACEMANLY @PEACEMEEK @OLDPEACEMANLY @OLDPEACEMEEK @WARMANLY @WARMEEK @WARN1 @WARN2 @WARN3`. **All BYTE_VERIFIED present.** See `docs/SESSION_UI_CATALOG.md`, `docs/UI_DIALOGS.md`.

## 5. Evidence
- `func_057F4E` (file `0x057F4E`) — meeting/parley dispatcher: human gate `@0x57F8C`, war-matrix bit `0x02` set `@0x58A7B` / `0x80` clear `@0x58BE1`, treaty cooldown `[0x53C8+power*2]=turn+0x10` `@0x58075`; difficulty-scaled demand terms `@0x58374`/`@0x583A0`/`@0x5842B`/`@0x58315`. **B**
- `func_057DC0` (file `0x057DC0`) — SIGNTREATY/treaty-state handler: symmetric `+0x40` matrix write `@0x57EC5`/`@0x57ED0`; bits `0x02`/`0x20`/`0x40` tested `@0x57E05`/`@0x57DF0`/`@0x57E7D`; keys `@SIGNTREATY`/`@CANCELTREATY`/`@DECLAREWAR`. **B**
- `notes/rulings/RULINGS.md` — war bit-matrix at `DGROUP:0x883C`; `func_03ECF0` re-attribution (NOT diplomacy). **A (ruling)**
- `data_extracted/text/GAME_sections.json` — treaty/war/peace dialog keys present. **B**
- `docs/GAME_MANUAL.md` — diplomacy function (rivals, treaties, war). **R**

## 6. Open questions
0. ~~The `0x883C` matrix "has no code xrefs".~~ **CORRECTED 2026-06-19** — it does: the
   accessor uses `[bx+si-0x77C4]` (displacement form of `0x883C`), in `func_057F4E`.
   The prior grep searched the literal and missed it.
1. ~~Find the diplomacy dispatcher + per-pair bit layout.~~ **Done** — `func_057F4E`
   (meeting) + `func_057DC0` (SIGNTREATY); war matrix `+0x34` (bit `0x02`=war), treaty
   matrix `+0x40` (`0x02`=war/`0x20`=peace-pending/`0x40`=treaty), all byte-verified.
   **War-matrix `0x08`/`0x80` bits now resolved** (§2: `0x08`=grievance, `0x80`=privateer).
2. ~~Byte-trace AI peace/war **willingness** thresholds.~~ **Done 2026-06-20** — the
   per-power **attitude table is `DGROUP:0x940C`** (byte/power, adjusted on
   unit-ownership transfer by `UnitRecord +0x1F` `@0x5DC76`/`@0x5DC87`). Cutoffs:
   `func_057F4E @0x58C24` — the AI takes no action when `(attitude>>2) > demand_score`
   **and** `demand_score > 12 (0xC)` **and** `random_int(0,4)!=0`; the final accept
   gate is an affordability check `demand vs PowerRecord +0x2C gold` (`@0x58E1F`).
   Target-selection requires **attitude ≥ 8** (`@0x57B1A`). Plus the difficulty-scaled
   demand terms (§3). **B.**
3. ~~Privateer attribution / blockade.~~ **Done 2026-06-20** — **Privateer** (unit
   type `0x10`) hidden attribution is in the war-declaration resolver `func_03ECF0`:
   `@0x3F092 cmp [bx+0x3146],0x10; jne` → `@0x3F0A1 or war_matrix,0x80` (sets the
   hidden bit instead of declaring war). **No naval blockade mechanic exists** (0
   "blockad*" strings; the closest is land-adjacency **SIEGE**, which restricts a
   besieged colony's production to military units). **B.**


## Amendment 2026-09-02 — bit 0x40, the timer row, the import

- **Bit `0x40` of the `+0x34` war row is TREATY (alliance), not "met"**: set
  by SIGNTREATY (`push 0x40; push b; push a; lcall 0x181F:0xA06` `@0x57E91`),
  cleared by CANCELTREATY/DECLAREWAR (`@0x57F3C` via `0x181F:0xA10` =
  `func_008000`, the bit-CLEAR helper, applied both ways `@0x802C..@0x8046`),
  by the war-declaration resolver `@0x3F29D`, and by grievance resolution
  (`and 0xB7` `@0x5318A` clears 0x08|0x40 and sets 0x01).  `@0x006090` keys
  the AI frontier term on it; the @TRADEATWAR gate `@0x5A450` tests only it.
  The prior "0x40 = met/contacted" gloss is withdrawn; contact has no bit of
  its own in the row.
- **The `+0x40` row is a per-pair TIMER, 4 wide**: `mov 1` at signing
  (`@0x57EC5/@0x57ED0`, both ways), `mov 0` on cancel/war
  (`@0x57F2D/@0x57F38`), a computed value `@0x59B31`, and the per-turn
  `dec` when nonzero (`@0x531A3`); the grievance resolution above fires only
  while it reads 0 (`@0x53171`) and `random_int(0,3) == 0` (`@0x5317E`).  It
  is NOT a second bit matrix.
- **The `+0x34` row is 12 wide** (newgame zero loop to 0xC `@0x7583A`: four
  powers, then the eight tribes) — the getter `func_007F34` reads
  `PowerRecord[a] + 0x34 + b` for a European `a` and the tribe table for
  `a >= 4`.
- **Port status (B4.6 closed)**: both importers load the 4x4 European block
  verbatim into the war matrix and derive the treaty map from bit 0x40; the
  C folds both back into `+0x34` on save; the timers ride verbatim (the
  grievance cycle itself is still unported).

## Amendment 2026-09-03 — bit 0x20 is CONTACT; the grace timer; the relation cycle (CORE-B)

- **Bit `0x20` of the `+0x34` row = CONTACT ESTABLISHED** (RULINGS
  2026-09-03a; the 2026-09-02 line "contact has no bit of its own" and the
  §2 "peace-pending" gloss are withdrawn). Readers: the first-meeting gate
  `@0x57FD3`, the native first-contact gate `@0x56C8F`, the report reader
  `@0x2139A`, the AI-AI tick `@0x57DF0`. Writers: `rel_or(mover, other,
  0x20)` `@0x5A1C6` (after the meeting handler returns nonzero) and
  `rel_or(a, tribe, 0x20)` `@0x56C9E`; cleared only by the @OTHERGRANTED
  reset `rel_clear(.., 0xBB)` `@0x2F769`.
- **Bit `0x80` sits in the TARGET's row**: `@0x3F0A1` writes
  `war[target][mover]`; the handler clears `war[b][a]` `@0x58BE1` (b = the
  AI). After the write, `random_int(0,100) < difficulty+1` `@0x3F0AA..`
  identifies the privateer: `strength[target] < strength[mover]`
  (`[0x941C]` words `@0x3F0C5..@0x3F0D2`) → `war[target][mover] |= 2`
  `@0x3F0E8`, else `|= 8` `@0x3F0D7`.
- **The `+0x40` grace timer is written at the tail of every meeting-handler
  run** (`@0x59AF4..@0x59B31`): while `war[a][b] & 0x40`, `timer[b][a] =
  (6 - difficulty) * 2`, halved when `power_attribute_bit(a, 0x13)`
  (Benjamin Franklin, @FATHERS row 19). Its consumer `@0x3F163`
  (`war[a][b] & 0x40` and `timer[a][b] != 0` abort an attack on the
  partner) is documented, not yet ported (the ports' AI attacks only the
  human at war).
- **The AI relation cycle** (`func_052F7E @0x53152..@0x531AE`, once per AI
  power per turn, rows t = 0..3): `war[p][t] & 0x08` and `timer[p][t] == 0`
  and `random_int(0,3) == 0` → `war[p][t] = (w & 0xB7) | 0x01` (one-way);
  then `timer[p][t]--` while nonzero. The prologue's clock reseed
  `@0x52F95` is not mirrored (RULINGS 2026-09-03b).
- **@OTHERGRANTED reset** (`@0x2F741..@0x2F771`): for every other power q,
  `rel_or(p,q,0x40)` then `rel_clear(p,q,0xBB)` — both rows keep only
  TREATY (and 0x04).
- **Port status**: both engines carry `REL.CONTACT`/`REL_CONTACT` = 0x20
  (written at contact), the relation cycle in `rivalTurn`/`rival_turn`
  after the colony pass, the timer stamp at the end of `runMeeting`/
  `run_meeting`, the privateer identification roll, the OTHERGRANTED reset,
  and the C imports/saves the `+0x40` row (`CR.rel_timer`); the `rtimer`
  projection is in both harnesses.
