# Random Events / Lost City Rumors

> **Layer 2 — Specification (population stub).** Primary-only per `/METHODOLOGY.md`. Tiers: B/A/R. Details pending — breadth pass.

**Overall confidence:** event strings `BYTE_VERIFIED`; **Lost-City rumor: trigger
PROCEDURAL (`func_006188` coordinate-hash `@0x6188` — corrects the earlier
`0xB0`-marker model; see §6.1, 2026-06-21) + handler + `random_int(1,9)`→`@LOSTCITY<n>` +
full per-index meanings + FoY=8 immigrants + reward credit to `+0x2A` + scout bonus
`BYTE_VERIFIED`** (`func_061454`); **per-index reward magnitudes `BYTE_VERIFIED`** (n=3 `10·3d8`, n=7 `2·4d10`, n=2 Cibola treasure `100·(10·(scout+2)+1d20)`; scout-scaled). (`func_05BE84` is the native **raid** handler — see `natives.md`.)
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

- **Reward magnitudes — BYTE_VERIFIED** (`func_061454`, per `@LOSTCITY<n>` index in
  `[bp-6]`; each outcome rolls summed dice via `random_int(1,N)` = `0x181F:0x4D4`):
  - **n=3 (ruins, gold `%NUMBER0`):** `gold = 10 · (3d8)` — three `random_int(1,8)`
    summed then `×10` (`@0x61776..0x617AB`: `shl 2; add; shl 1` = ×10). With an
    **explorer/scout bonus** `s = [bp-0x34]`, scaled by `(s+2)/2` (`@0x617B4` `imul;
    sar 1`). Base range `[30,240]`.
  - **n=7 (friendly tribe, gift of gold):** `gold = 2 · (4d10)` — four
    `random_int(1,10)` summed then `×2` (`@0x617C6..0x61804`). Range `[8,80]`.
  - **n=2 (Cibola, treasure unit `%NUMBER1`):** `value = 10·(s+2) + random_int(1,20)`
    (`@0x6166A..0x61686`: `1d20`; `(s+2)·5·2 = 10·(s+2)`), stored in the created
    **Treasure unit** (type `0xA`) `+0x17` class byte (`@0x6166BC`), so the gold shown
    is `%NUMBER1 = value × 100`. With a **Seasoned Scout** `s=1`: `100·(30+1d20)` =
    3100–5000; without: `100·(20+1d20)` = 2100–4000. *(Corrects an earlier draft that
    cited the unrelated `[bp-0x36]` count.)*
  - **n=9 (survivors):** non-gold — adds colonist(s) (`@0x6180F`).
  - **Burial sub-outcomes (n=4 → `[bp-0x38]`):** **`@BURIAL1`** (empty) `[bp-0x10]=0`
    (`@0x619F8`); **`@BURIAL2`** (trinkets, gold `%NUMBER0`) = `10·(3d8)` — three
    `random_int(1,8)` ×10 (`@0x61A1D..0x61A52`, same form as ruins); **`@BURIAL3`**
    (incredible treasure `%NUMBER1`) `[bp-0x32] = 2·(1d8 + 2·(s+5))` (`@0x61A5D..0x61A75`),
    shown ×100 → `200·(1d8 + 2s + 10)`. **B (2026-06-20).**
  - **Master quality roll** `[bp-0xa] = random_int(1,100) + s·10` (`@0x6151D..0x61537`,
    `s` = scout-proximity bonus `[bp-0x34]`), the threshold variable that selects
    vanish/nothing/treasure sub-outcomes. **B.**
  The **Seasoned-Scout bonus `s`** (`[bp-0x34]`, 0 or 1) scales n=2/n=3 (difficulty
  does **not** enter these reward rolls).
  - **Message substitution — BYTE_VERIFIED:** `%NUMBER0` (immediate gold) = `[bp-0x10]`
    (`@0x618A1`, `fmt_int32` slot 0); **`%NUMBER1` (treasure-unit worth) = `[bp-0x32] × 100`**
    (`@0x618B1` `imul ax,[bp-0x32],0x64`, slot 1) — i.e. the treasure unit stores
    `value/100` and the dialog shows the ×100 gross, consistent with the
    `100 × UnitRecord[+0x15]` treasure convention (§3, `func_05C878`).
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
  `unit_type == 5` (Scout, `@0x614A6`) and class byte `UnitRecord +0x17` (abs `0x315B`) `== 0x16`
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
- **Per-index reward magnitudes — BYTE_VERIFIED (2026-06-20):** summed-dice rolls per
  outcome (n=3 `10·3d8`, n=7 `2·4d10`, n=2 Cibola `100·(10·(scout+2)+1d20)`),
  scout-scaled — see §2. **`%NUMBER1` = `[bp-0x32]×100` byte-verified** (`@0x618B1`).
  **Burial `%NUMBER0/1` rolls RESOLVED 2026-06-20** (BURIAL2 `10·3d8`, BURIAL3
  `2·(1d8+2·(s+5))` ×100 — see §2). **Debug-force-Cibola RESOLVED:** `@0x615DB
  test [0x5382],1; je; mov [bp-6],2` — when game-flag `[0x5382]` **bit 0** (the
  engine-wide debug/cheat flag, *not* bit 1) is set, the outcome is forced to **2**
  (Cibola treasure). **B.**
- **Treasure value & King-galleon transport — `func_05C878`. FULLY BYTE_VERIFIED
  (2026-06-19, verified vs EXE).** Strings `CASHTREASURE`/`KINGGALLEON`/`LOOTCASH`.
  - **Treasure gold = `100 × UnitRecord[+0x15]`** (a Treasure unit stores value/100 in
    its class byte) `@0x5C882`.
  - **Post-independence** (`[0x5382]&1`): no King — the treasure is **cashed in full**,
    no cut `@0x5C88B`.
  - **Pre-independence:** the King offers to ship it (`@KINGGALLEON` dialog; accept/
    decline via `0x181F:0x3FE @0x5C94A`). On **accept**, the King's **cut percentage**
    is (`@0x5C958..0x5C9AB`):
    - **with Hernán Cortés** (Founding-Father **#10**; bit test `0x181F:0x7B4(0xA, power)`
      `@0x5C965`) → **cut% = your tax rate** (`PowerRecord +0x01`);
    - **without Cortés** → **cut% = `max(5·difficulty + 50, 2·tax_rate)`** (`@0x5C976`:
      `(diff+10)·5` vs `tax·2`), then **clamped to ≤ 90%** `@0x5C9A3`. So at Discoverer
      (diff 0) it's **50%**, rising `50→55→60→65→70` by difficulty (or `2·tax` if higher).
    - **King's cut = `treasure × cut% / 100`** (`@0x5C9BF` mul, `@0x5C9C6` ÷100); the
      **player receives `treasure − cut`** `@0x5C9F0`. The dialog shows cut / gross / net.
  - **`DGROUP:0x8394` is NOT the galleon fee — RESOLVED 2026-06-20.** It is a
    **per-difficulty (5-entry) table of king-salutation string pointers** — the
    `%STRING0` "form of address" the Crown uses for you (your difficulty rank
    Discoverer/Explorer/Conquistador/Governor/Viceroy). The same `[bx − 0x7C6C]`
    (`= 0x8394 + diff·2`) pattern feeds slot 0 of the `@KINGGALLEON2/3`, `@KINGWAR`,
    and `@KINGNEWWAR` messages (`@0x5C8C2`, `@0x36063`, `@0x3622C`; `0x181F:0x438`
    msg-arg, followed by the king's name into slot 1 → the messages' opening
    "%STRING0 %STRING1"). **There is no per-difficulty fee table and no dump is
    needed** — the actual galleon **fee = the Crown's cut %**, fully byte-verified by
    the inline Cortés/tax/difficulty formula above.
- **Burial-ground → native alarm — BYTE_VERIFIED (2026-06-20):** a desecrated burial
  ground raises native **tension by +100** against the current nation via the tension
  applier `func_045DF2` (`@0x61B84`: `push 0(cat); push 0x64(+100); push
  [0x5394](current nation); push [bp-0x30](settlement)`), gated on a valid settlement
  (`@0x61B36`). Tension is `[0,100]`, so +100 maxes it → war footing. See
  `spec/systems/natives.md` §3. **B.**

## 4. UI
Outcome surfaced via the dialog/text-template framework (`func_06EEEC` text
template parser, `func_06F0F4` dialog framework — `docs/ARCHITECTURE.md`,
BYTE_VERIFIED entry points). **Concrete box geometry is dialog-framework runtime
state, not a constant in the rumor handler — RESOLVED-AS-STATE (2026-06-27).** The
box x/y/size is held in three DGROUP dialog-state globals `[0x1f9e]`, `[0x1fa0]`,
`[0x1fa2]`, **written** by the geometry setter `func_06EED4` (file `0x06EED4`) from
its three args — `[0x1f9e]=[bp+6] @0x6EEDD`, `[0x1fa0]=[bp+8] @0x6EEE0`,
`[0x1fa2]=[bp+0xA] @0x6EEE7` — and **read/rendered** by the framework root
`func_06F0F4`, which pushes all three to the box renderer `@0x6F135` (`PUSH [0x1fa0]`),
`@0x6F139` (`PUSH [0x1f9e]`), `@0x6F13D` (`PUSH [0x1fa2]`). `func_06EED4` is invoked by
the dialog-opening callers (`func_060CE0`, `func_072CC2`, `func_075FB6`), **not** by the
rumor handler `func_061454` — which contains no write to `[0x1f9e..0x1fa2]` and sets no
box constant; it only builds the message string and hands it to the generic template
framework. So the on-screen pixel geometry of the Lost-City outcome dialog is live
dialog state set per-invocation in `[0x1f9e]/[0x1fa0]/[0x1fa2]` and rendered by
`func_06F0F4 @0x6F135`; it is not a static constant anywhere in the rumor path. **B.**

## 5. Evidence
- `data_extracted/text/GAME_sections.json` — @LOSTCITY0..9, @BURIAL1..3, @VANISH, @CASHTREASURE. **B** (strings).
- `func_061454` (file `0x61454`) — Lost-City rumor handler: builds `LOSTCITY`+digit; checks unit_type 5 (Scout) + class 0x16 (Seasoned Scout). **B**
- `docs/GAME_MANUAL.md` — Rumors of Lost Cities; Corrupting Burial Grounds; Seasoned Scout. **R** (function).
- `docs/ARCHITECTURE.md` — `func_05A20E` scout interactions; `func_05C878` treasure transport. **B** (entry points).
- `func_05BE84` — native **raid** outcome dispatch (RAID* keys) — see `natives.md` §3. **B**

## 6. Open questions
1. **Trigger feature byte — RESOLVED 2026-06-21: rumor presence is PROCEDURAL, not a
   stored `0xA0`/`0xB0` marker** (corrects the earlier "runtime-`0xB0`" reconcile; the
   `0xA0`-vs-`0xB0` question is dissolved). The rumor-presence predicate is **`func_006188`**
   (`@0x6188`), called per tile entry (`@0x30822`). It does **not** read a stored "lost-city"
   value — it **computes** presence from a **coordinate hash against a global map seed
   `[0x190]`**: `((y>>2)·0x13 + (x>>2)·0x11 + seed + 8) & 0x1F − (x&3)·4 == (y&3)`
   (`@0x61C7..0x61F8`), gated by:
   - terrain ≠ ocean/sea-lane/arctic (`0x18`/`0x19`/`0x1A`, `@0x61A6..0x61B3`), and
   - the tile's **feature high-nibble must be `0xF` ("none")** — read via `0x5DF0`→`0x5D9C`
     (`shr al,4`; `0xF`→−1; `func_006188` requires the `−1`, `@0x61BB..0x61C5`).
   The map is **one byte/tile** in the far array at `[0x164]:[0x166]`, index `y·[0x853A]+x`
   (`[0x853A]` = width 56): **low nibble = terrain/owner, high nibble = feature** (`0x5DBA`
   reads low, `0x5DF0` reads high, `0x5DCC` XOR-mutates it). So a tile carrying a stored
   `0xB0`/`0xA0` high-nibble feature would **suppress** a rumor (nibble ≠ `0xF`), not mark
   one — the memory-map doc's "`0xB0` = lost-city tile, cleared on entry" is the **consumed
   /feature state**, not a placement marker (per `TRUTH_HIERARCHY`, EXE disasm at a cited
   offset outranks the memory-map note; see `notes/rulings/RULINGS.md`). Map is 56×72
   row-major. See `spec/systems/map_system.md`. The trigger's `0x181F:0x7E0` (file `0x66CC`)
   is the generic **"find unit at map coords"** scan (unit table `0x3144` stride `0x1C`),
   and the consumer is the byte-verified `func_061454` — **nothing here is a missing
   function or an un-pinned constant.**

   - **`0xA0`-vs-`0xB0` discrepancy — CLOSED BY BYTE PROOF (2026-06-25).** The map
     generator **`func_064A10`** (overlay page `0x14`, file `0x64A10`) ORs feature mask
     **`0xA0`** into the tile byte at **two FIXED coordinates** — `(1,0x15)` `@0x65C0D`
     and `(0x44,0x2b)` `@0x65C21` — each `26 80 0f a0` = `or byte ptr es:[bx],0xa0`,
     the pointer from tile helper `0x181F:0x70E`, both gated by `cmp [bp+6],0`
     (generator/scenario mode) **and** `cmp [0x2174],0/jne` (map-loaded flag). This is the
     SAME generator that seeds the rumor hash: its first act `@0x64A23` stores
     `random_int(0,0x7fff)` into `[0x190]` (the seed `func_006188` reads). **There is NO
     `0xB0` write and NO `==0xB0` read anywhere in `VICEROY.EXE`:** an exhaustive scan of
     all 494,910 bytes for every tile-byte form of a `0xB0` immediate
     (`cmp/test/and/or al,0xb0`; `cmp ah/dl,0xb0`; grp1 `0x80 /r` on `[bx]`/`es:[bx]` with
     `0xb0` imm) returns **zero** matches — the only tile-byte grp1-imm writes in the whole
     image are the two `or …,0xa0` above. The earlier model's extra `0x10` bit (`0xA0`→`0xB0`)
     is therefore **set by no instruction**; the `==0xB0` trigger-read function **does not
     exist**. Consistent with the procedural predicate above: a stored `0xA` high-nibble
     feature (the generator's `0xA0`) makes `0x5DF0` return ≥0, so `func_006188`'s
     `jge`-fail `@0x61C5` **suppresses** a rumor on those two tiles rather than marking one.
     (The two fixed `0xA0` tiles are a distinct stored feature, not a rumor placement; the
     nibble-`0xA` acts purely as a **rumor-suppression marker** — the *only* consuming read is the
     predicate above (`0x5DF0`≥0 ⇒ `func_006188` `jge`-fail suppresses a rumor on those tiles); an
     image-wide scan finds no other reader of a `0xA` high-nibble, so it has no further game effect.
     **B — single-consumer proven; inert beyond rumor suppression.**)

     - **0x10-set site — PROVEN ABSENT (re-verified 2026-06-25).** The Track-1 blocker ("where
       is the `0x10` bit added between mapgen's `0xA0` and a `==0xB0` trigger?") is closed: the
       site **does not exist**. Independent re-scan of all 494,910 bytes of `VICEROY.EXE`:
       (a) the ONLY grp1-imm writes to the tile pointer `es:[bx]` in the whole image are the two
       `26 80 0f a0` (`or es:[bx],0xa0`) at `0x65C0D`/`0x65C21` — there is **no**
       `or/and es:[bx],0x10` and **no** `…,0xb0` (byte- or word-form `26 81/83 0f …` are all
       `cmp`, never OR/AND, and none use `0x10`/`0xA0`/`0xB0`); (b) the only genuine
       `cmp <reg>,0xb0` in the image is `cmp bl,0xb0 @0x13425` (an unrelated routine, not a tile
       read; the other apparent `0xb0` bytes are `[bx+disp]`/`[bp-disp]` displacements, not
       immediates); (c) the handler `func_061454` contains no `cmp al,0xa0`/`0xb0`. So nothing
       sets the `0x10` bit and nothing reads `==0xB0` — the `0xA0`→`0xB0` model has no instruction
       behind it. Presence is procedural (`func_006188`, above): the stored `0xA` high-nibble even
       *suppresses* a rumor via `func_005DF0`'s `0xF`→−1 sentinel + the `jge`-fail `@0x61C5`.
2. ~~Outcome bias cascade — exact per-gate probabilities.~~ **Done 2026-06-20.** The
   outcome index is `[bp-6] = max(anti_streak_floor, random_int(1,9))` (`@0x614F6..0x6151A`),
   where the **anti-streak floor** = `min(prev_floor+1, 3)` rises by 1 each rumor (stored
   in `[bp-0x2C]`, capped at 3): so the **good low outcomes (1 FoY / 2 Cibola) are only
   reachable on the first rumors** — once the floor reaches 3, every outcome is forced
   `≥ 3` (mundane). Sub-outcome refinement then uses the **quality roll
   `[bp-0xA] = random_int(1,100) + scout·10`** against thresholds **10/25** (FoY→vanish/
   nothing demotion `@0x6159A`; Cibola→burial-treasure `@0x61646`). **Per-game rare-outcome
   caps:** `[0x1DC6]` (`inc @0x614E6`, gate `@0x6163D cmp,1`) and `[0x1DC7]`
   (`inc @0x616C9`, gate `@0x61644 cmp,7`) limit Fountain/Cibola. **B.**
3. ~~Numeric effects: which `@LOSTCITY` index = treasure/FoY/burial.~~ **Done 2026-06-19** — full n→meaning table byte-verified (§2): 1 FoY(8 immigrants)/2 Cibola/3 ruins-gold/4 burial/5 vanish/6 nothing/7 gift/8 trespass/9 survivors. Remaining: the per-index reward *magnitude* roll formulas (`[bp-0x10]`/`[bp-0x32]`).
4. ~~Entry function that consumes @LOSTCITY*/@BURIAL*.~~ **DONE** — `func_061454` (builds `LOSTCITY`+digit; Scout/Seasoned-Scout check **B**). The index→`@LOSTCITYn` mapping (full n→meaning table) and the FoY/burial numerics are byte-verified in **§2 / §6 items 2–3** (n=3 `10·3d8`, n=7 `2·4d10`, n=2 Cibola `100·(10·(scout+2)+1d20)`, `@BURIAL3` `2·(1d8+2·(scout+5))×100`). **B.**
