# Religious Immigration + Europe Recruit — byte-verified findings (2026-05-31)

Source: RE workflow `w6ublr7oi` (find→verify→synth, capstone CS_MODE_16 on
`COLONIZE/VICEROY.EXE`) **plus a direct follow-up disassembly** that corrected
the workflow's "resident-undumped" conclusion. All offsets are FILE offsets
unless marked SEG:OFF. Status tags: **BV** = byte-verified, **TBD** = not yet
decoded (do NOT guess per the prime directive).

This documents the DOS mechanic so the Godot port's RECRUIT / immigration can be
wired faithfully **once the remaining inner pieces are decoded**. It is NOT yet
safe to wire numerically — see "What is still TBD".

---

## 1. Control flow (BV)

The crosses→immigrant step is `func_0363A2` (file **0x0363A2..0x036573**, page
0x04), gated by `(g_5382 & 1)`, operating DS-relative on the CURRENT PowerRecord
at `[0x84FC]` (= `0x8808 + player*0x13C`; pointer set by `func_030550`, which
also stores the player index at `[0x9E12]`).

Per-step bytes:
1. needed/threshold written: `mov [bx+0x30],ax` @ 0x0363EF — `ax` = return of the
   threshold helper (see §3).
2. accumulate: `cx = <per-turn crosses incr>`; `add [bx+0x2e],cx` @ 0x0363F5;
   clamp `>=0` @ 0x0363FB-0x036401.
3. trigger: `cmp cx,ax` (current vs needed) @ 0x036404; `jg` → spawn path.
4. reset: `sub ax,ax; mov [bx+0x2e],ax` @ 0x03645E (crosses := 0).
5. arrival announced with string handle 0x1190 = `"UNREST"` + 0x1197 = `"TUTORIAL5"`.

**Mislabel correction:** `viceroy_source/src/overlay/overlay_0341D6_0388DE.c`
decodes `func_0363A2` as "OUT-OF-SCOPE screen dispatch" because the per-function
slice was TRUNCATED at 0x0363C3. That C label is **WRONG** — the real body
(0x0363A2..0x036573) is this religious-immigration step.

The F2 "Religious Adviser" display (`func_037958`, file 0x0379A7-0x0379B4) reads
the SAME `+0x2e` (current) / `+0x30` (needed) and renders `"(%d of %d)"`
(handle 0x11A9) via gauge `lcall 0x181f:0x236`. **BV.**

---

## 2. PowerRecord fields used (BV reads/writes)

| off   | role (this code)                         | status |
|-------|------------------------------------------|--------|
| +0x2e | current accumulated crosses (word)       | BV (add @0x0363F5, reset @0x03645E, F2 read) |
| +0x30 | needed crosses / threshold (word)        | BV (write @0x0363EF, F2 read) |
| +0x1e | artillery-bought counter (word)          | BV (recruit artillery escalation, §4) |

**UNRESOLVED CONFLICT — PowerRecord +0x02.** The immigrant-type selector (§5)
treats `+0x02/+0x03/+0x04` of the per-power record as 3 dock-pool unit-type
bytes (`mov al,[bx+si+2]`), but `docs/DATA_MODEL.md` marks +0x02 =
`rebel_sentiment_pct` (USER-VERIFIED from a frame). Both cannot be the same
byte. Likely the dock-pool slots are at a different base than `0x8808`, or the
selector's `bx` is a different table pointer. **Do NOT assert either layout for
the pool slots until reconciled (needs a runtime capture of both fields).**

---

## 3. Threshold helper `func_035D9A` (BV) — SEG 0x191F:0x0B34 → file 0x035D9A

The workflow flagged this "resident-undumped"; that is **REFUTED**.
`typeA_thunk_targets.json` resolves `0x191F:0x0B34 → file 0x035D9A` (and the two
type helpers below), all in the SAME overlay page 0x04 as the King functions
(`0x034AE0`, `0x036138`) already byte-verified this cycle. Full disasm (capstone,
file 0x035D9A..0x035E7E):

```
enter 4,0
mov bx,[bp+8]            ; arg2 = output pointer (*out)
mov word [bx],2         ; *out = 2
xor accum,accum ; i=0   ; [bp-2]=accum, [bp-4]=i
; LOOP 1 (0x35DB0): over a stride-0xCA(202) table @ DGROUP:0x5D60, count [0x539E]:
;   if record[i].+0 == arg1([bp+6]):  accum += (sbyte)record[i].+5
; LOOP 2 (0x35DD8): over UnitRecord table @ DGROUP:0x3144 stride 0x1C, count [0x539C]:
;   if (unit[i].+3 & 0x0F) == arg1 and (unit[i].+0 - arg1)==... and helper(0x181f:0xb78)>=0
;      and (PowerRecord[arg1].+0 & 0x40):  accum++ / adjust *out
; --- threshold shaping (0x35E2E) ---
cmp accum,4000 ; if < 4000: accum *= 2        ; shl [bp-2],1
add accum,8                                    ; +8 base
clamp accum to 4000 (0xFA0)
if player[0x9E12] < 4 and AIPersonality[player*0x34 + 0x543F] != 0:
    accum = accum * (8 - difficulty[0x53A6]) / 8     ; sar ax,3
if player[0x9E12] == 0 (ENGLAND):
    accum = accum * 2 / 3                            ; shl ax,1; idiv 3
return accum
```

**BV facts (the wirable shape):**
- base `+8` (`add [bp-2],8` @0x035E38);
- doubling when `accum < 4000` (`shl` @0x035E35);
- hard clamp to **4000** (0xFA0) @0x035E44;
- difficulty scaling `accum*(8-difficulty)/8` for AI-flagged powers @0x035E5D-6B;
- **England (player 0) gets `accum*2/3`** @0x035E75-7B (the historical English
  immigration bonus — byte-verified; tech-ref's "England 2/3" CONFIRMED).

So the classic "start 8, +3/immigrant, England 2/3" is PARTLY right: the **+8**
and **England ×2/3** are real; the per-immigrant growth is NOT a flat +3 — it is
driven by the LOOP-1/LOOP-2 `accum` sum (see TBD).

---

## 4. Recruit GOLD cost (BV source; per-type base TBD)

- cost = `*(u16*)(DGROUP:0x978C + slot*6 + 0x04)` — READ from a pre-filled
  recruit-pool word, NOT a slot*N formula. Reads: file 0x035114, 0x03524B,
  0x051E52; afford-check `cmp ax,[bx+0x2a]`(gold) @0x051E65. **BV.**
- Setter that writes slot+0x04: `func_074688`, write @0x0746AC. **BV (site).**
- ARTILLERY (unit type 0x0B): `cost = pool_cost + PowerRecord[+0x1e]*100`, then
  `PowerRecord[+0x1e]++`. `imul ax,[bx+0x1e],0x64` @0x035124/0x03527B; inc
  @0x035282; zeroed at new-game @0x03662F. **BV.** (Already wired in the Godot
  PURCHASE path.)
- The per-unit-type BASE number written into slot+0x04 by the pool-fill
  generator (caller of `func_074688`) = **TBD** (see below). The tech-ref
  "+10/recruit" and "100+difficulty*50" carry NO offset → **REFUTED**.

---

## 5. Immigrant-type selection (BV mechanism; weighting TBD)

When crosses hit threshold (file 0x036462-0x036494):
- `si = random_int(0,2)` via `lcall 0x181f:0x04d4` (BV RNG) — pick 1 of 3 slots.
- emitted type = `(byte)record[bx+si+0x02]` (`8a 40 02` @0x036473).
- the picked slot is REFILLED: `mov [bx+si+2],al` (`88 40 02` @0x036494), where
  `al` comes from the type helpers:
  - `0x191F:0x0AFC → file 0x034C24` (replacement-type generator),
  - `0x191F:0x0B26 → file 0x030C68` (post-process), flag from `[0x538E] & 3`.
  Both resolved in `typeA_thunk_targets.json` (dumped, NOT resident).
- William Brewster FF (id 20) forces the next immigrant = Free Colonist
  (see `founding_fathers/recruit.c` / Godot `congress.gd`).

The pick-one-of-three + refill MECHANISM is **BV**; the per-type spawn WEIGHTING
(bodies of `func_034C24` / `func_030C68`) is **TBD**.

---

## 6. What is still TBD (do NOT guess — decode at these offsets)

1. **accum inner-sum semantics** (LOOP 1 / LOOP 2 of `func_035D9A`): what
   `record[+5]` of the stride-0xCA table @0x5D60 is, the unit filter
   (`unit[+0]-arg1==?`, the 0xEC compare), and the `lcall 0x181f:0xb78` sub-helper
   (resolve via `typeA_thunk_targets.json`).
2. **crosses-per-turn increment** (the `cx` added to +0x2E @0x0363F5): traces to a
   thunk output, NOT a `PowerRecord+0x10` field (the "+0x10 = crosses_per_turn"
   id is RECONSTRUCTED/UNVERIFIED). Decode the church/cathedral crosses sum +
   nation modifier.
3. **immigrant-type weighting**: bodies of `func_034C24` (0x191F:0x0AFC) and
   `func_030C68` (0x191F:0x0B26) — both dumped; decode the weight table.
4. **per-type recruit base price**: the base written into pool slot+0x04 by the
   `func_074688` caller (pool-fill generator) — find the caller via xrefs.
5. **PowerRecord +0x02 conflict** (§2) — reconcile dock-pool-type vs
   rebel_sentiment via a runtime capture.

---

## 7. Godot wiring guidance

- **Safe now:** none of the immigration NUMBERS are safe to port yet — the
  threshold OUTER shape is BV but depends on the un-decoded `accum` inner sum, so
  porting it would require faking the sum. Do NOT wire a numeric threshold.
- **Keep RECRUIT as an honest TBD** in `europe_screen.gd` until §6 lands.
- When wiring lands, model: PowerRecord-equivalent `crosses` (current) +
  `crosses_needed` (threshold from §3), per-turn accrual (§6.2), the 3-slot dock
  pool with `random_int(0,2)` selection + refill (§5), and the cost = slot's
  stored price (§4). England gets the ×2/3 threshold bonus.
- This is a multi-piece subsystem; the Godot port also lacks the byte-exact
  colony/unit tables the `accum` sum reads — that modelling is its own task.

## 8. Corrections applied to other docs
- `func_0363A2` is the immigration step, NOT "screen dispatch" (overlay C label
  wrong due to a truncated slice).
- The recruit/immigration helpers `0x191F:0x0AFC/0x0B26/0x0B34` are **dumped**
  (resolve to file 0x034C24/0x030C68/0x035D9A via `typeA_thunk_targets.json`),
  REFUTING the "resident-undumped" conclusion. (Caveat: task #53 — re-verify the
  157 corrected thunk targets — is still open; `0x191F:0x0B34→0x035D9A` was
  spot-verified here by disassembling the target and confirming it is the
  threshold helper that writes `PowerRecord+0x30`.)

---

## 9. Follow-on decode — workflow `w6hwizbjb` (refined; remaining blockers narrowed to 3 resident helpers)

A second 9-agent workflow (capstone on raw bytes, adversarial verify) decoded the
inner pieces. Net result: the THRESHOLD formula is fully recovered; the immigration
RATE and immigrant-TYPE distribution are gated behind exactly **three resident
SEG-0x181F helpers** that are genuinely absent from `typeA_thunk_targets.json`
(70 seg-0x181F entries; gaps over these offsets). **Immigration is therefore NOT
byte-faithfully wirable until those 3 are decoded or a runtime capture is taken.**

### 9.1 Threshold accum — FULLY DECODED (BV)
`accum = (LOOP1) + (LOOP2)`:
- LOOP1 @0x035DB0 over **ColonyRecord** base DGROUP:0x5D46 stride 0xCA, count
  [0x539E]: where `colony[+0x1A]==player`, `accum += (s8)colony[+0x1F]`
  (in-colony worker count).
- LOOP2 @0x035DD8 over **UnitRecord** base 0x3144 stride 0x1C, count [0x539C]:
  `accum++` for every unit with `(unit[+0x03] & 0x0F) == player` (the `accum++`
  @0x035DF8 is gated ONLY by this owner-nibble match; the later
  0xEC / `0x181F:0x0B78` / `PowerRecord&0x40` chain adjusts `*out`, NOT accum —
  this CORRECTS the first-pass claim that accum was filtered).

So `accum` = (workers across the player's colonies) + (count of the player's
units). Shaping (BV, §3) then yields the threshold. NET: bigger empire → higher
crosses threshold → slower immigration; England gets ×2/3.

### 9.2 Recruit-cost table `0x978C` IS the Europe PURCHASE catalog (BV; cross-validates the port)
The `0x978C + slot*6 + 0x04` cost word is filled at startup (setter `func_074688`,
caller @0x07610B → init tail-calls) with the **6 ship/artillery PURCHASE prices**:
Artillery(@UNIT 0x0B)=**500** @0x07497E, Caravel(0x0D)=**1000** @0x074990,
Merchantman(0x0E)=**2000** @0x0749A2, Galleon(0x0F)=**3000** @0x0749B4,
Privateer(0x10)=**2000** @0x0749C6, Frigate(0x11)=**5000** @0x0749D8.
These are EXACTLY the values already wired in the Godot PURCHASE path
(`europe_screen.gd PURCHASE_UNITS`) — independent byte-verification of PURCHASE.
**Implication:** `0x978C` is the purchase catalog, so the immigrant dock-pool
RECRUIT price is a *separate* quantity (the dock pool itself is PowerRecord
+0x02/+0x03/+0x04 unit-type bytes) and is **still not isolated** — do not assume
the immigrant recruit price equals a purchase price.

### 9.3 Per-turn crosses increment — mechanism BV, value NOT reproducible (+ ROLE suspect)
In `func_0363A2`: `cx = *out` (threshold helper's 2nd out-param) and
`PowerRecord+0x2e += cx`. `*out` = 2 if LOOP2 found zero "qualifying" units, else
`0xFFFE`(-2) then −2 per further qualifying unit. "Qualifying" depends on resident
`0x181F:0x0B78`. **Caveat:** a negative per-turn increment contradicts normal
crosses accrual (churches add crosses), so `func_0363A2` (gated by `g_5382&1`) is
likely NOT the main per-turn accrual path — the real church/cathedral crosses
production is added elsewhere (UNIDENTIFIED). Do not wire this as the accrual.

### 9.4 Immigrant-type distribution — mechanism BV, weighting behind resident helpers
Pick `slot=random_int(0,2)`; emit `dock_pool[slot]`; refill via `func_034C24`
(returns unit type 0x1A or 0x1C decided by resident `0x181F:0x07B4`) +
post-process `func_030C68` (category map 0x14→2 / 0x15→1 / 0x16→5 / 0x18→3, allocates
a unit record via resident `0x181F:0x095C`). The per-type spawn ODDS are behind
`0x181F:0x07B4` and `0x181F:0x095C`. Not reproducible yet.

### 9.5 REMAINING BLOCKERS (precise — decode these 3 resident SEG-0x181F helpers, or capture at runtime)
1. **`0x181F:0x0B78`** — gates "qualifying units" for the crosses increment `*out`.
2. **`0x181F:0x07B4`** — decides immigrant type 0x1A vs 0x1C (the type ladder).
3. **`0x181F:0x095C`** — unit-record allocator for the spawned immigrant.
These are load-image/resident (SEG 0x181F); per MEMORY, Type-B `0x181F` thunks
JMP-FAR to a fixed load-image paragraph and *may* be decodable by resolving that
paragraph — but they are NOT in the current Type-A artifact and two workflows
could not surface them. Plus: the **real per-turn crosses accrual function**
(§9.3) is unidentified, and the **PowerRecord+0x02 dock-pool vs rebel_sentiment**
conflict (§2) needs a runtime capture.

### 9.6 Verdict for the Godot port
**Do NOT wire immigration numerically.** Byte-verified + safe to use *when a pool
exists*: the threshold shaping (§3/§9.1) and England ×2/3. Still missing for a
faithful system: the per-turn accrual, the immigrant-type odds, and the dock-pool
byte layout — all behind the §9.5 blockers. RECRUIT stays an honest TBD.

---

## 10. WINDOWS ORACLE BREAKS THE WALL (2026-06-01) — all §9.5 blockers now readable

The user supplied a Ghidra C/H export of the **Windows build** (`coloniz4e.exe`,
102k lines, RTLink-free). Because Win16 NE has no overlay manager, every DOS
"resident SEG-0x181F" helper from §9.5 is a plain, fully-decompiled function. The
shared game logic means these are the same algorithms (verified where DOS bytes
exist). **Immigration is now fully decodable — no resident walls remain.**

### 10.1 Windows ⇄ DOS function map (immigration/recruit)
| Windows fn | role | DOS twin | status |
|---|---|---|---|
| `FUN_1048_9397` | per-turn immigration step | `func_0363A2` | confirmed identical (PR+0x2e/+0x30, slot=random_int(0,2), Brewster, UNREST) |
| `FUN_1048_8b7b` | crosses threshold + increment | `func_035D9A` | **byte-identical** to my §9.1 decode |
| `FUN_1048_7339` | immigrant-TYPE generator | resident `0x181F:0x07B4` (§9.5 #2) | **now readable** (was the wall) |
| `FUN_1048_407d` | type → unit-record mapper | resident `0x181F:0x095C` (§9.5 #4) | now readable (not yet transcribed) |
| `FUN_1018_4521` | "qualifying unit" test (increment) | resident `0x181F:0x0B78` (§9.5 #1) | now readable |
| `FUN_1018_3915` | dock-slot type validity check | — | now readable |
| `FUN_1020_a959(p,0x14)` | does power own FF 0x14 (Brewster) | — | now readable |

### 10.2 Immigrant-type generator `FUN_1048_7339(flag)` — shape (line 68751)
`flag = ((turn & 3) == 0)`. On the `flag==0` branch (≈3/4 turns):
- `lvl = (player<4 && AIpersonality==0) ? difficulty : 1`
- `if random_int(1,15) <= (lvl+3)>>1` → type **0x1A** (or **0x1C** if Brewster)
- else `if random_int(1,10) <= (lvl+3)>>1` → type **0x19** (or 0x1C if Brewster)
- else `if random_int(1,8) <= (lvl+3)>>1` → type **0x1C**
Otherwise (and on `flag==1`): a wraparound-RNG draw over types `0..0x18` using the
per-power counters PR+0x44/PR+0x45 (`(PR44+PR45)&0x1f`, retry while >0x18), with
fixed remaps `0x12→0x0d, 0x13→0x16, 1→8, 2→5, 3→0, …` (continues past line 68840 —
**not yet fully transcribed**). The types are @UNIT line indices.

### 10.3 King event (already applied this session — `king.gd`)
The same Windows file (`FUN_1048_902e` / `FUN_1048_6700`) was used to recover the
King roll FOLD and **correct** the tax-amount (`func_034AE0` was a misattribution →
navact `random_int(3,4)`, stampact `random_int(5,8)`), both **byte-verified against
DOS** and shipped (commit 25ce353a). Tax cap 75 confirmed (`FUN_1048_6700` @0x4b).

### 10.4 Remaining to wire immigration (now unblocked — a build, not an RE wall)
1. Finish transcribing `FUN_1048_7339` (type weighting tail) + `FUN_1048_407d`
   (type→unit mapper), cross-checking DOS bytes where dumped.
2. Identify the **main per-turn crosses accrual** (church/cathedral production →
   PR+0x2e) — `FUN_1048_9397`'s ±2 increment is a side term, not the accrual; find
   the colony-production path that adds crosses (likely in the colony turn update).
3. Build the port immigration subsystem: `crosses` (PR+0x2e) + `crosses_needed`
   (PR+0x30 from §9.1), the 3-slot dock pool (reconcile the PR+0x02 conflict, §2),
   `random_int(0,2)` selection + refill via §10.2, recruit cost (the immigrant
   recruit price, distinct from the §9.2 PURCHASE catalog).
DOS stays authoritative; verify each transferred number against DOS bytes.

### 10.5 Helpers decoded via `tools/win_dos_xref.py` (no agents, 2026-06-01)
Using the new cross-reference tool (`win` to read + `card` to auto-match/verify),
the last two helpers were decoded + DOS-confirmed in seconds:

**`FUN_1048_407d(type)` — type → unit-record mapper** (DOS twin `0x030C68`, tool
auto-match score 0.636, shared consts {0x14,0x15,0x16,0x18,0x1c,0x34,0x64}):
```
category = 0
if type==0x14: category=2      if type==0x18: category=3
if type==0x16: category=5
if type==0x15: category=1; if random_int(0, lvl+4)==0: category=4   # lvl=difficulty (AI:1)
idx = alloc_unit_record(category, player, player-0x14, player-0x14)  # FUN_1038_2246 (DOS 0x181F:0x095C)
if idx>=0:
    unit[idx].+0x00 = 1            # DOS disp -0x5ef6 == DGROUP 0x314C (alive flag)
    unit[idx].<typefld> = type     # DOS disp -0x5ee7 == DGROUP 0x315B
    if category==2: unit[idx].<fld> = 100   # DOS disp -0x5ee9 == DGROUP 0x3159
return idx
```
(DOS disps from the tool: 0x314c/0x3159/0x315b — matches the §9 workflow's unit-write
finding exactly.)

**`FUN_1018_4521(unit_idx)` — "qualifying unit" test** (the resident DOS
`0x181F:0x0B78`, §9.5 #1 — was the hardest wall; turns out to be a one-liner):
```
return (s8) table_010A[ unit[unit_idx].field_5efc ]   # unit stride 0x1c
```
A unit-attribute lookup: read a unit byte field, index a table at base 0x10A, return
the (signed) entry. The increment path treats `>= 0` as "qualifying".

**Immigration is now decoded end-to-end** (threshold, increment mechanism, type
generator, type→unit mapper, qualifying-unit, allocator). The ONLY piece left for a
faithful wire is the **main per-turn crosses accrual** (church/cathedral production →
PR+0x2e; the FUN_1048_9397 ±2 is a side term) — find it in the colony turn update
(now a one-shot `match`/`card`, not a workflow). Then it is purely a port build.
