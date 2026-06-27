# Immigration & Recruitment

> **Layer 2 — Specification.** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R/TBD. Immigration & recruitment mechanics are byte-resolved (crosses loop, threshold, per-turn increment, type selection, refill, recruit pool, placement, `0x30E` profession map, `+0x1F` population, and the `+0x00 &0x40` dock-immigrant latch).

**Overall confidence:** crosses loop control-flow + threshold shape + **per-turn cross increment (base 2 + per-colony `+0x05`)** `BYTE_VERIFIED`; immigrant-type selection **`BYTE_VERIFIED`** (`random_int(0,2)` slot pick + `func_034C24` difficulty-weighted refill); (dock pool confirmed at `+0x02..+0x04`). **Canonical primary:** `docs/IMMIGRATION_RECRUIT_FINDINGS.md` (byte-cited), `docs/DATA_MODEL.md`; `data_extracted/text/NAMES_sections.json` `@CLASS`; `data_extracted/text/GAME_sections.json` `@RECRUIT*`.

## 1. Purpose & behavior
Religious freedom (crosses, from churches/cathedrals) accumulates immigrant points; when they reach a threshold a new colonist arrives on the Europe docks. The player may also pay gold to **recruit** a specific waiting colonist immediately. Some types (Artillery) escalate in cost each purchase. **RECONSTRUCTED** (manual + byte-cited control flow).

## 2. State & data
Operates on the CURRENT `PowerRecord` via far ptr `DGROUP:0x84FC` (= `0x8808 + player*0x13C`).

| Field | Type | Meaning | Tier | Evidence |
|-------|------|---------|------|----------|
| `PowerRecord +0x2E` | u16 | current accumulated crosses | **BYTE_VERIFIED** | `IMMIGRATION_RECRUIT_FINDINGS.md`: add @`0x0363F5`, reset @`0x03645E`, F2 read |
| `PowerRecord +0x30` | u16 | needed crosses / threshold (disasm) | **BYTE_VERIFIED** | write @`0x0363EF` (= `func_035D9A` threshold); F2 read. ⚠ runtime dump labels `+0x30` "recruit cost" (not write-verified) — conflict logged, RULINGS 2026-06-19 |
| `PowerRecord +0x1E` | u16 | `artillery_bought_count` (Europe recruit escalation) | **BYTE_VERIFIED** (2026-05-31) | `DATA_MODEL.md`: read×100 @`0x035124`/`0x03527B`, inc @`0x035282`, zeroed @`0x03662F` |
| recruit-pool slot `+0x04` | u16 | recruit gold cost (pool @ `DGROUP:0x978C + slot*6`) | **BYTE_VERIFIED** | `DATA_MODEL.md`/`func_074688`: read @`0x051E52`,`0x035114` |
| pool slots `+0x02/+0x03/+0x04` | u8 | **dock-pool colonist-type bytes** (3 waiting immigrants) | **BYTE_VERIFIED** | selector `func_0363A2 @0x36473`/refill `@0x36494`; Brewster rewrites them (`func_03BC42 @0x3BF85`) |

`@CLASS` (immigrant/colonist classes, BYTE_VERIFIED present): Petty Criminals, Indentured Servants, Peasant Farmers, Skilled Craftsmen, Hardy Pioneers, Town Merchants, Trained Mercenaries, Educated Elite.

## 3. Formulas & rules
- **Crosses loop** `func_0363A2` (file `0x0363A2..0x036573`), gated by `(g_5382 & 1)`: accumulate `+0x2E`, clamp ≥0; if current > needed → spawn immigrant, reset `+0x2E := 0`. **BYTE_VERIFIED.**
- **Threshold helper** `func_035D9A` (file `0x035D9A`, reached from the crosses
  loop via thunk `0x191F:0xB34`): `base 0x2`, then table loops over `DGROUP:0x5D60`
  (stride 202) and the UnitRecord table; `if accum<4000: accum*=2; accum+=8; clamp
  4000`; difficulty scale `accum*(8-difficulty[0x53A6])/8`; **England (player 0):
  accum*2/3**. **BYTE_VERIFIED shape.**
- **Per-turn crosses increment** — produced by the **same** `func_035D9A` via its
  out-param `[bp+8]`, **BYTE_VERIFIED** (`@0x35DA1..0x35E2B`): seeds the delta at
  **`2`** (`@0x35DA1`), then over each colony (count `[0x539E]`, table `DGROUP:0x5D60`
  stride **`0xCA`**) **adds the per-colony cross byte `+0x05`** (`@0x35DBD..0x35DC2`)
  when that colony's owner byte `+0x00 == player` (`@0x35DB7`). A field-unit loop
  (count `[0x539C]`, `UnitRecord` owner nibble `+0x01 &0xF == player`, plus a
  PowerRecord flag `+0x00 &0x40` gate `@0x35E18`) can override the delta to `-2`
  (`0xFFFE` `@0x35E27`). **Full override gate is now byte-decoded** (`@0x35DE7..0x35E2B`):
  a unit qualifies for the override only when (a) owner nibble `UnitRecord +0x03 &0xF
  == player` (`@0x35DEA`: `[bx+0x3147]`, base `0x3144`), (b) `(s8)(UnitRecord +0x00 -
  player) == 0xEC` (`@0x35DFB..0x35E04`), (c) the resident helper `0x181F:0x0B78` (now
  decodable, file `0x008BB2`) returns `>= 0` (`@0x35E0F`: `or ax,ax; jl`), where that
  helper computes `(s8)table[0x30E + UnitRecord +0x02]` (`@0x008BB5..0x008BC4`), and (d)
  PowerRecord `+0x00 &0x40` set (`@0x35E18`); when all hold and `*out > 0` the delta is
  forced to `-2` (`@0x35E27`), else `*out -= 2` per qualifying unit (`@0x35DD8`). The
  caller `func_0363A2` adds this delta to `+0x2E`
  (`@0x363F5`) and **spawns an immigrant when `accumulated > threshold`**
  (`@0x36404`: `cmp cx, ax; jg`), then resets `+0x2E := 0`. **B.** (Base `+2`/turn +
  per-colony church/cathedral cross output. The override *mechanism/fields* are
  byte-verified; the `DGROUP:0x30E` attribute table is now **decoded**: it is a
  **24-byte unit_type → `@JOB` profession-index map** (file `0x1DCAE` = DGROUP `0x30E`,
  read by helper `func_008BB2 @0x008BBF`: `mov bl,[bx+0x3146]` (UnitRecord `+0x02`=unit_type)
  → `mov al,[bx+0x30e]`). Bytes: Colonists→`0x13`(@JOB Colonist), Soldiers→`0x15`(Soldier),
  Pioneers→`0x14`(Pioneer), Missionaries→`0x18`(Missionary), Dragoons/Cont.Cav→`0x17`(Dragoon),
  Scouts→`0x16`(Scout), Cont.Army→`0x15`(Soldier); all hardware/ships/treasure/King's-Regulars
  (ut 6,8)/Cavalry/natives = **`0xFF`** = no colonist. The gate (`(s8)val >= 0`) therefore selects
  **field units that carry a player colonist** (the value IS that colonist's `@JOB` profession =
  the unit's `UnitRecord +0x17` class code, range `0x13..0x1C`); cross-confirmed at
  `func_033BE4 @0x33C44..0x33C5B` which gates on the same helper then reads `[si+0x315b]`
  (UnitRecord `+0x17` profession). **B** (table image + @JOB/@UNIT + `+0x17` cross-use). Only the
  PowerRecord `+0x00 &0x40` flag's *meaning* stays `TBD` — that bit is tested at `@0x35E18`
  but has **no resident write site** (`grep` of `[bx-0x77f8]`/`[0x8808]` finds only a `&0xFB`
  clear of bit `0x04` `@0x03E158`, never a `0x40` set), so it is loaded from the save image or
  set via a computed-mask/block op — name a save-field or runtime write trace to close it.)
  > **⚠ Cross-doc reconciliation (2026-06-27):** the per-colony cross byte read here is
  > `[colony·0xCA + 0x5D65]` = **`ColonyRecord +0x1F`** (the `0x5D60` base = `0x5D46 + 0x1A`
  > owner field, so "+0x05" from it = `+0x1F`). `colony.md` labels `+0x1F` = **population**.
  > **Resolved (byte, no runtime needed):** `+0x1F` IS population — independently byte-verified at
  > `@0x00A5EE` (`mov al,[bx+0x1f]; cwde; shl ax,1` = food `eaten = 2·pop`) and the colonist-growth
  > `inc byte ptr [bx+0x1f]` (`func_009318 @0x009464`) / starvation `dec [+0x1f]` (`func_008FB4 @0x902E`).
  > `func_035D9A @0x35DBD` reads the SAME byte (`0x5D65 = 0x5D46+0x1F`), so **base immigration
  > scales with colonist count: per-turn crosses += Σ (player colony population)** plus the base `+2`.
  > Both docs cite the same physical byte and that byte is population; no label is wrong.
- **Artillery recruit cost** = `base + artillery_bought_count*100`, then counter++ (NOT `base<<count`). **BYTE_VERIFIED** (`DATA_MODEL.md`).
- Immigrant **type** selection — **BYTE_VERIFIED** (`func_0363A2 @0x36456..0x3649E`):
  1. **Pick a dock slot:** `random_int(0,2)` (`@0x36462`) chooses one of **3 dock
     slots** at `[current-power +0x02 + slot]` (slots 0/1/2 → `+0x02/+0x03/+0x04`);
     that slot's stored colonist type is the immigrant who arrives (`@0x36473`).
  2. **Refill the slot:** the emptied slot is regenerated by `func_034C24`
     (thunk `@0x36822`, arg = turn-parity `[0x538E]&3==1`) and written back
     (`@0x36494`).
  3. **Refill distribution** (`func_034C24`): roll `random_int(1,15)`; a
     **difficulty**-scaled threshold (`(diff+…)/2`, `[0x53A6]`) splits a **high-tier**
     branch (returns class `0x1A`, or **`0x1C` with William Brewster** FF `0x14`,
     `@0x34C79`) from a **low-tier** branch (`@0x34C94`: `random_int(1,10)` over the
     criminal/servant/free classes). So **harder difficulty ⇒ more low-tier
     colonists; Brewster shifts the pool toward the top class.**
  - **Brewster (FF `0x14`)** also enables a **non-random** selection path at spawn
    (`@0x36437 → func_0368E5`), letting the player choose the waiting colonist.
  - The dock-pool bytes are read at current-power `+0x02..+0x04`; this corroborates
    the dock-pool-at-`+0x02` reading. (The long-standing label clash with
    `+0x02 = rebel_sentiment_pct` is a **cross-system overlap to reconcile**, not
    resolved here — both systems index `+0x02` of `[0x84FC]`.)

## 4. UI
F2 Religious Adviser renders `(%d of %d)` from `+0x2E`/`+0x30` (`func_037958`, gauge `lcall 0x181f:0x236`). Recruit menu opened with `R`/`1`; strings `@RECRUIT @RECRUIT2 @RECRUITCHOOSE`. See `docs/ADVISOR_REPORTS_AUDIT.md`.

## 5. Evidence
- `docs/IMMIGRATION_RECRUIT_FINDINGS.md` — crosses loop `func_0363A2`, threshold `func_035D9A`, byte-cited. **B**
- `docs/DATA_MODEL.md` — `+0x2E/+0x30/+0x1E`, recruit-pool `0x978C` slot `+0x04`. **B**
- `data_extracted/text/NAMES_sections.json` `@CLASS`; `GAME_sections.json` `@RECRUIT*`. **B (present)**

## 6. Open questions (TBD)
1. ~~Resolve the `+0x02` dock-pool conflict.~~ **Resolved 2026-06-19** — the dock-pool
   unit-type bytes are **`PowerRecord +0x02..+0x04`** (3 slots), byte-confirmed by the
   William Brewster FF effect which rewrites criminals/servants (`0x19`/`0x1A`) → free
   colonist (`0x1C`) at exactly `+0x02..+0x04` (`func_03BC42 @0x3BF85`, see
   `founding_fathers.md`). **Selector RESOLVED 2026-06-20:** `random_int(0,2)` picks the slot, `func_034C24` refills it (difficulty-weighted; Brewster→top class).
2. ~~Byte-verify per-turn crosses increment source~~ **Done 2026-06-19** — `func_035D9A` out-param: base `2` + per-colony cross byte `+0x05` (table `DGROUP:0x5D60` stride `0xCA`); spawn when `+0x2E > +0x30` (`@0x36404`), reset `+0x2E:=0` (**B**). Remaining: the field-unit `-2` override *semantics* (the gate mechanism is now byte-decoded — see §3; the `0x30E` table is now decoded as the **unit_type → @JOB-profession-index map** (`0xFF`=no colonist; file `0x1DCAE`, `func_008BB2 @0x008BBF`; the gate `>=0` ⇒ unit carries a player colonist — see §3); the PowerRecord `+0x00 &0x40` flag is now byte-resolved as the **"immigrant arrived on this power's docks" latch** — SET in `func_0363A2 @0x036528` (`mov bx,[0x84fc]; or byte ptr [bx],0x40`) right after a successful `func_030C68` placement, sticky (no resident clear), and read only at `func_035D9A @0x35E18` to gate the `-2` override; the earlier "no write site" claim missed it because the setter uses the `[bx]` accessor not `[bx-0x77f8]` (**B**)). **Immigrant-placement handler RESOLVED 2026-06-25:** the spawned colonist's UnitRecord is created by `func_030C68` (file `0x030C68`, reached from `func_0363A2 @0x3649B` via thunk `0x36831 → 0x191F:0x0B26`): it maps the dock-pool type to a category (`0x14→2`, `0x18→3`, `0x16→5`, `0x15→1`, with a `random_int(0,lvl+4)==0 → 4` upgrade, `@0x030C71..0x030CD4`) then calls the unit-record allocator `0x181F:0x095C` (resident, file `0x006D24`) which appends a UnitRecord at index `[0x539C]` (`mov si,[0x539C]; inc [0x539C]` `@0x006D64`, stride `0x1C`, base `0x3144`), and on success writes the alive flag `+0x08:=1` (`@0x030CFA`), type `+0x17:=type` (`@0x030D02`), and for category 2 the field `+0x15:=0x64` (`@0x030D0C`). **B.**
3. ~~Map recruit-pool slot full layout (type, cost, count) and non-artillery cost.~~
   **Done 2026-06-20.** The recruit pool is **`DGROUP:0x978C`, stride 6** (6-byte slots),
   built by the setter **`func_074688`** (`@0x74698..0x746B3`): `+0x00` = recruit/unit
   **type**, `+0x01`/`+0x02`/`+0x03` = attribute bytes (category/flags), `+0x04` (word) =
   the slot **value/cost**. The **non-artillery recruit cost is this `+0x04` word**
   (read `@0x051E52`/`@0x035114`); **artillery** instead escalates `base +
   artillery_bought_count·100` (`PowerRecord +0x1E`, §3) — the one type with a
   count-based cost. **B** (structure + cost rule); exact per-attribute-byte labels are
   the only remainder.
