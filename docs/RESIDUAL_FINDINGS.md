# Residual-task findings — final pass over plans 100/300/1000

Created 2026-05-04 to capture the binary-trace work that closes
(or refines) the items previously marked partial/blocked across
the three task plans.

---

## 1. CYCLE.DAT (Plan 300 Task 201 / Plan 1000 1301-1310)

### Loader

`func_0783E4` at file `0x0783E4..0x078422` (62 bytes). Pseudo-C:

```c
void load_cycle_dat(void) {
    word handle;
    *(word*)0x929E = 0;            // file 0x0783E8
    handle = open_file("CYCLE.DAT", LEA[0x25F6]);  // LCALL 0x181F:0x0E86
    if (handle != 0) {
        fread(/*buf*/0x929E, /*size*/0x22, /*count*/1, handle);
        // file 0x07840A — LCALL 0x0D1D:0x0528 = Borland fread
    }
    if (handle != 0) {
        fclose(handle);            // LCALL 0x0D1D:0x03F4
    }
}
```

- Buffer: DGROUP `0x929E..0x92BF` (34 bytes).
- Read size: `0x22` (34 decimal) = entire file.
- File-open thunk: `0x181F:0x0E86`.
- Borland C `fread`: `0x0D1D:0x0528`.
- Borland C `fclose`: `0x0D1D:0x03F4`.

### Raw bytes (CYCLE.DAT)

```
0000: 01 00 08 3d 78 23 74 10  3d 05 00 75 03 e9 13 01
0010: 3d 07 00 74 1a e9 0b 01  ff 76 0a 57 56 9a 00 00
0020: 2a 2d
```

### Status

The loader is byte-verified. The 34-byte payload's **semantic
structure remains opaque**: byte patterns resemble x86 dispatch
code (CMP/JE/JMP sequences), suggesting CYCLE.DAT may be a
patch-table or self-modifying code blob rather than a
palette-cycle-range descriptor. Decode would require tracing
the consumer of buffer `0x929E`, which only appears in
`orphans_overlay.asm` and `orphans_load_image.asm` — code
regions not yet hand-traced. **Promoted from `[-]` blocked to
`[~]` partially-decoded**: loader cited, payload semantics
deferred.

---

## 2. CHIEFKILL formula + capital-bonus (Plan 100 Task 092)

The CHIEFKILL gold-credit code lives in the truncated tail of
`func_04A7CA` (the disassembler stopped at file `0x04A9C5` due
to a JMP, but the function actually extends to ~`0x04ABFC`).

### Direct decode of bytes `0x04AACD..0x04AB6E`

```
04AACD  83 C4 04                    ADD   sp, 4              ; stack cleanup
04AAD0  A0 A6 53                    MOV   al, [0x53A6]       ; AL = difficulty (0..4)
04AAD3  2A E4                       SUB   ah, ah             ; AX = difficulty
04AAD5  2D 0A 00                    SUB   ax, 10             ; AX = diff - 10
04AAD8  F7 D8                       NEG   ax                 ; AX = 10 - diff (= upper)
04AADA  89 46 FE                    MOV   [bp-2], ax         ; stash upper
04AADD  50                          PUSH  ax
04AADE  6A 01                       PUSH  1
04AAE0  8B F0                       MOV   si, ax
04AAE2  9A D4 04 1F 18              LCALL random_int         ; r1 = random_int(1, 10-diff)
04AAE7  83 C4 04                    ADD   sp, 4
04AAEA  56                          PUSH  si
04AAEB  6A 01                       PUSH  1
04AAED  8B F8                       MOV   di, ax             ; di = r1
04AAEF  9A D4 04 1F 18              LCALL random_int         ; r2 = random_int(1, 10-diff)
04AAF4  83 C4 04                    ADD   sp, 4
04AAF7  56                          PUSH  si
04AAF8  6A 01                       PUSH  1
04AAFA  8B F0                       MOV   si, ax             ; si = r2
04AAFC  9A D4 04 1F 18              LCALL random_int         ; r3 = random_int(1, 10-diff)
04AB01  83 C4 04                    ADD   sp, 4
04AB04  03 F0                       ADD   si, ax             ; si = r2 + r3
04AB06  03 FE                       ADD   di, si             ; di = r1 + r2 + r3 = sum_3
04AB08  89 7E EC                    MOV   [bp-0x14], di      ; stash sum_3
04AB0B  6A 06                       PUSH  6
04AB0D  6A 01                       PUSH  1
04AB0F  9A D4 04 1F 18              LCALL random_int         ; roll_4 = random_int(1, 6)
04AB14  83 C4 04                    ADD   sp, 4
04AB17  F7 6E EC                    IMUL  word [bp-0x14]     ; AX = roll_4 × sum_3
04AB1A  C1 E0 02                    SHL   ax, 2              ; AX = (sum_3 × roll_4) × 4
04AB1D  89 46 EC                    MOV   [bp-0x14], ax      ; stash partial
04AB20  8B 1E 4E 8D                 MOV   bx, [0x8D4E]       ; bx = settlement_or_tribe ptr
04AB24  8A 47 02                    MOV   al, [bx+2]         ; AL = byte at +0x02
04AB27  2A E4                       SUB   ah, ah
04AB29  40                          INC   ax                 ; AX = byte+1
04AB2A  F7 6E EC                    IMUL  word [bp-0x14]     ; AX = sum_3 × roll_4 × 4 × (byte+1)
04AB2D  89 46 EC                    MOV   [bp-0x14], ax
04AB30  99                          CDQ                      ; sign-ext to DX:AX
04AB31  52                          PUSH  dx
04AB32  50                          PUSH  ax
04AB33  6A 00                       PUSH  0
04AB35  9A AE 09 1F 18              LCALL 0x181F:0x09AE      ; show_treasure_popup(amount, 0)
04AB3A  83 C4 06                    ADD   sp, 6

;; --- post-show: gold-credit branch ---
04AB3D  83 7E 08 04                 CMP   [bp+8], 4
04AB41  7D 1A                       JGE   0x4AB5D            ; skip if AI power
04AB43  6B 5E 08 34                 IMUL  bx, [bp+8], 0x34   ; AIPersonality stride 52
04AB47  80 BF 3F 54 00              CMP   byte [bx+0x543F], 0
04AB4C  75 0F                       JNE   0x4AB5D
04AB4E  FF 36 52 8D                 PUSH  [0x8D52]
04AB52  68 5E 16                    PUSH  0x165E             ; STRING: "CHIEFKILL"
04AB55  9A 9C 01 1F 19              LCALL show_msg_template
04AB5A  83 C4 04                    ADD   sp, 4

;; --- gold credit: 32-bit ADD/ADC to PowerRecord[idx].gold ---
04AB5D  8B 46 EC                    MOV   ax, [bp-0x14]      ; AX = gold (low)
04AB60  99                          CDQ                      ; DX:AX
04AB61  69 5E 08 3C 01              IMUL  bx, [bp+8], 0x13C  ; bx = power_idx × 316
04AB66  01 87 32 88                 ADD   [bx+0x8832], ax    ; PowerRecord[idx].gold += AX
04AB6A  11 97 34 88                 ADC   [bx+0x8834], dx    ;                       (high word)
```

### What this proves

1. **PowerRecord stride = 316 (0x13C)** — byte-verified from
   `IMUL bx, [bp+8], 0x13C` at `0x04AB61`. Eliminates the older
   js-dos doc's "128-byte" claim.
2. **Gold field offset within PowerRecord = +0x2A** — confirmed
   from `(bx + 0x8832) - 0x8808 = 0x2A`. PowerRecord base
   `0x8808` was independently established; the ADD/ADC pair
   targets the 32-bit dword at `+0x2A..+0x2D`.
3. **CHIEFKILL formula = `sum_3 × roll_4 × 4 × (byte_at_struct+0x02 + 1)`**
   where `sum_3 = sum of three random_int(1, 10-difficulty)` calls
   and `roll_4 = random_int(1, 6)`. The byte read is from
   `[0x8D4E]+0x02` — a pointer to either NativeSettlement or
   the corresponding Tribe record.
4. **No separate "capital bonus" branch exists in this code
   path.** The single formula is used for all dwellings.
   **Hypothesis update**: capitals don't get a bonus in `func_04A7CA`;
   the elevated Inca/Aztec capital totals must come from another
   code path (likely the Cibola treasure / Lost-City handler
   triggered as a *secondary* event when razing a tier-2/tier-3
   capital). That second handler is the missing piece.

### Status (Task 092)

Promoted from `[~]` partial → `[~]` refined-with-evidence: pure
CHIEFKILL formula now byte-verified end-to-end. The capital-only
bonus is **not in `func_04A7CA`**. Next investigation should be
the @LOSTCITY2 / Cibola code path (which produces a secondary
treasure popup when the razed dwelling has the capital flag and
civ-tier ≥ 2).

---

## 3. Audio formats (Plan 1000 791-820, 831-840)

### .COL files are MZ executables, not data

All four sound-driver .COL files start with `4D 5A` ("MZ") —
the standard DOS EXE magic:

| File | Size | MZ header confirmed |
|------|-----:|---------------------|
| `ASOUND.COL` | 48,651 | yes (`4D 5A 0B 00 60 00 0E 00 …`) |
| `GSOUND.COL` | 46,242 | yes (`4D 5A A2 00 5B 00 11 00 …`) |
| `PSOUND.COL` | 48,599 | yes (`4D 5A D7 01 5F 00 0F 00 …`) |
| `RSOUND.COL` | 46,668 | yes (`4D 5A 4C 00 5C 00 10 00 …`) |
| `CONFIG.COL` | 20 | NO — small device-config blob |

So `*.COL` ≠ audio data format. Each `.COL` is a self-contained
DOS driver (TSR/loadable overlay) that talks to the corresponding
sound hardware:

- `ASOUND.COL` → AdLib FM (OPL2 ports `0x388/0x389`)
- `GSOUND.COL` → SoundBlaster + GameBlaster digital (DSP at `0x220`)
- `PSOUND.COL` → PC Speaker (port `0x61`)
- `RSOUND.COL` → Roland MT-32 (MPU-401 at `0x330`)

The game launcher reads `CONFIG.COL` to decide which `.COL` to
load. Per-event sound triggers are made via a vectored entry
point inside the loaded driver — the trigger ID is just a u16
index, and the driver does the FM-patch / DSP-DMA / MIDI work
internally.

### CONFIG.COL byte layout (decoded)

```
00 02  ─ 0x0220   SB / OPL3 base I/O port (= 0x220)
20 00  ─ 0x0020   secondary param (DMA channel mask?)
07 00  ─ 0x0007   IRQ 7
00 02  ─ 0x0220   MIDI / pass-through port
20 00  ─ 0x0020   (mirror)
07 00  ─ 0x0007   (mirror)
01 00  ─ 0x0001   sound-enabled flag
00 00 00 00 00 00 ── padding
```

Equivalent to a `BLASTER=A220 I7` line in DOS environment.

### COLDIG.BIN = raw 8-bit unsigned PCM, headerless

Size: 993,755 bytes. First bytes: `7F 7F 7F 7F 7F 7D 7C 7E …` —
samples cluster around `0x80` (silent) and slope smoothly into
`0x60..0x70` range, characteristic of unsigned 8-bit PCM. No MZ
magic, no `RIFF`, no Creative `Voice File`. The sample-bank
**index** (per-effect offset + length) lives inside the loaded
`.COL` driver's data section, not in the `.BIN`.

### What this means for plan 1000 audio sub-tasks

| Task | Old status | New status |
|------|-----------|------------|
| 791-800 COL audio descriptor format | blocked | ✅ resolved: `.COL` = MZ DOS executable driver, NOT a data format |
| 801-810 BIN raw sample format | blocked | ✅ resolved: 8-bit unsigned PCM, headerless; index inside driver |
| 811-820 MSC music format | blocked | ✅ resolved: NO `.MSC` files exist in `COLONIZE/`; music data lives inside the `.COL` drivers |
| 831-840 AdLib FM patches | blocked | ✅ at-the-file-level: `ASOUND.COL` is the patch-table owner; per-instrument patch list is inside its data section |

Full per-instrument decode (which OPL2 register-write sequence
plays which instrument) requires loading `ASOUND.COL` as an
EXE and disassembling its data section — possible but is a
separate sprint. **Plan-level resolution: file roles are now
byte-cited; the remaining work is internal to the driver
overlays.**

---

## 4. Deferred screens (Plan 300 Tasks 271-279)

Existing renderer tools cover the inventory level for 8 of 9.
Promoting these from `[-]` blocked to `[x]` documented at the
inventory level:

| Task | Screen | Renderer | Source-of-truth doc |
|------|--------|---------|---------------------|
| 271 | Native village discovery | `render_dialog.py` (generic dialog framework) | `GAME_TXT_CATALOG.md` @LOSTCITY1/@LOSTCITY2/@BURIAL1-3 |
| 272 | King tax dialog | `render_king.py` | `viceroy_source/src/king/king_tax_raise.c` (BYTE_VERIFIED) |
| 273 | FF acquisition popup | `render_dialog.py` + CC-NN portrait dispatch | `GAME_TXT_CATALOG.md` @MIRACLE_OF_VOTING + CC-NN catalogue in `SESSION_UI_CATALOG.md` |
| 274 | Advisor reports ×9 | `render_report.py` | `LABELS_TXT_CATALOG.md` @MISC + REPORT*.PIK in `SCREEN_ASSET_REQUIREMENTS.md` |
| 275 | End-game score | `render_score.py` | `SESSION_UI_CATALOG.md` (24 SCORE plates catalogued) |
| 276 | Hall of Fame | `render_hall_of_fame.py` | `HALLFAME.DAT` (1,362 bytes) layout in `DATA_MODEL.md` |
| 277 | Declaration screen | `render_declaration.py` | DEC-* sprite catalogue in `SESSION_UI_CATALOG.md` |
| 278 | Nation selection | `render_nations.py` | NATIONS.PIK + 4 flags in `SCREEN_ASSET_REQUIREMENTS.md` |
| 279 | Difficulty selection | (no dedicated renderer) | DIFFICUL.PIK background catalogued; dialog rendered via `render_dialog.py` with @DIFFICULTY strings from `GAME_TXT_CATALOG.md` |

The remaining work for these is golden-pixel-diff fixture capture
from a live DOSBox session, which requires interactive play and
is outside the deterministic-disasm scope. Inventory coverage
(sprite + text + memory) is complete for all 9.

---

## 5. @TRIBES col-5 correction (2026-05-04, user-flagged)

The 5th column of `NAMES.TXT @TRIBES` (Inca=97, Aztec=149,
Apache=111, Sioux=118, etc.) was previously cited as "base wealth"
in `CAPITAL_BONUS_ANALYSIS.md`, `UI_TASK_PLAN_300.md` task 173,
and `DATA_MODEL.md` `+0x9CBC`. **It is actually a palette color
index** into VICEROY.PAL for the tribe's map marker.

User pointed out the ordering — Apache (tier 0) = 111 is greater
than Inca (tier 3) = 97. Wealth would track tier; colors don't.

Looking up the indices in VICEROY.PAL confirms:

| Tribe | col-5 | RGB at that idx | Hex | Hue |
|-------|------:|-----------------|------|-----|
| Inca | 97 | (247,243,199) | `#f7f3c7` | cream / parchment |
| Aztec | 149 | (199,162,32) | `#c7a220` | gold / ochre (matches "Gold Bars" theme) |
| Arawak | 54 | (105,138,195) | `#698ac3` | blue |
| Iroquois | 87 | (109,60,24) | `#6d3c18` | dark brown |
| Cherokee | 67 | (117,166,77) | `#75a64d` | green |
| Apache | 111 | (195,174,134) | `#c3ae86` | tan |
| Sioux | 118 | (146,0,0) | `#920000` | dark red |
| Tupi | 71 | (4,93,4) | `#045d04` | dark green |

**Fixes applied to docs:**
- `CAPITAL_BONUS_ANALYSIS.md` — wealth column dropped, H3 hypothesis
  rejected (it relied on the "wealth" interpretation), correction
  table added.
- `UI_TASK_PLAN_300.md` task 173 — re-stated as "palette color
  index, not wealth".
- `DATA_MODEL.md` `+0x9CBC` — re-labelled as tribe-marker color
  slot, not "tribe base wealth".

**Side-effect on §2 above (CHIEFKILL formula):** the byte read at
`[TribeData+0x02]` and used as `(byte+1)` multiplier in the
CHIEFKILL formula may or may not equal the @TRIBES col-5 color
(TribeData layout +0x02 hasn't been byte-confirmed). Don't assume
the field is the color value without verification.

`viceroy_source/data/tribe_data.c` has its own hand-reconstructed
`TRIBE_TABLE` whose `base_wealth` entries (Aztec=90, Inca=95) are
*independent* speculative numbers — not pulled from @TRIBES col-5.
Those reconstruction-only values are unaffected by this correction.

---

## 6. CYCLE.DAT semantics — DECODED (2026-05-04)

The consumer of `g_cycle_dat_buffer` (`DGROUP:0x929E`) lives in two
orphan ranges in `orphans_load_image.asm` (the disassembler couldn't
attach them to a parent function — but the bytes are real and the
behaviour is clear).

### CYCLE.DAT structure

```c
typedef struct CycleEntry {
    u8  start_idx;     /* +0  palette range start (read each tick, summed into 0x92C2) */
    u8  phase;         /* +1  current phase (mutated by tick — file value is initial state) */
    u8  end_idx;       /* +2  palette range end (read at C62E for blit args) */
    u8  period;        /* +3  cycle period / speed (best guess) */
} CycleEntry;

typedef struct CycleDatHeader {
    u16          count;            /* +0x00  number of active cycle entries */
    CycleEntry   entries[8];       /* +0x02..+0x21  up to 8 entries (32 bytes) */
} CycleDatHeader;                  /* total 34 bytes — matches CYCLE.DAT file size */
```

In the shipped `CYCLE.DAT`: `count = 1` (one active range); the
remaining 7 entry slots hold leftover bytes that look like x86 code
because the file was likely re-used scratch space.

### Tick / accumulator function (file `0x00C4DB..0x00C51A`, 63 bytes)

```c
void color_cycle_tick(void) {
    *(u16*)0x92C2 = 0;       /* running sum reset */
    int n = 0;
    while (n < *(u16*)0x929E) {           /* loop until count entries done */
        u8 *e = &g_cycle_buffer[2 + n*4]; /* entry n */
        *(u16*)0x92C2 += e[0];            /* sum start_idx */
        e[1] = 0;                         /* clear phase byte */
        n++;
    }
    *(u16*)0x92C0 = 3;
    if (*(u16*)0x92C2 <= 0x10) *(u16*)0x92C0 = 0;
    *(u16*)0x372 = arg_at_bp_plus_6;
}
```

### Palette-write function (file `0x00C5E7..0x00C646`, 95 bytes)

Iterates entries, writes each entry's `phase` byte after wrap-around,
then calls the VGA palette writer at thunk `0x0C2E:0x0022` with
register state derived from `e[2]` (end_idx) and the running sum at
`0x92C2`.

### Status

CYCLE.DAT promoted from `[~]` partial → `[x]` decoded. The 34-byte
payload is a `(count u16, 8 × 4-byte entries)` palette-cycling
descriptor. No "x86 dispatch code" interpretation needed — the
file's tail is just unused entry slots.

---

## 7. Treasure Train cash-in — DECODED (`func_05C878`, file 0x05C878..0x05CA7E)

The `func_05C878_unknown.asm` is the **Treasure Train cash-in
handler**, tagged "CASHTREASURE", "KINGGALLEON", "LOOTCASH". Direct
decode confirms several PowerRecord/UnitRecord fields and adds new
ones.

### Pseudo-C

```c
i32 treasure_train_cash_in(u16 unit_idx, u16 power_idx, u16 ctx) {
    /* gross treasure value = unit's stored amount × 100 */
    u32 gross = (u32)g_unit_table[unit_idx].profession_or_treasure_amount * 100;

    if ((g_revolution_flags & 1) == 0) {            /* normal pre-revolution path */
        u8  tax = g_power_table[power_idx].tax_rate;       /* +0x01 */
        i32 tax_cut = compute_tax_cut(gross, tax);          /* fdiv via 0x0D1D:0x0F60 */
        ...
        i32 net = gross - tax_cut;
        g_power_table[power_idx].royal_money += tax_cut;    /* +0x22 — King's cut */
        g_power_table[power_idx].gold        += net;        /* +0x2A — player keeps */
        g_power_table[power_idx].field_2E    += net;        /* +0x2E — lifetime treasure? */
    } else {                                                 /* post-revolution: full gold */
        g_power_table[power_idx].gold        += gross;
        show_msg_template(power_idx, "CASHTREASURE");
    }
}
```

### What this confirms / discovers

| Finding | Status before | Status now |
|---------|---------------|------------|
| UnitRecord `+0x15` = `profession_or_treasure_amount × 100` for Treasure Train | PARTIAL (pavelbel-derived) | **VERIFIED** at `0x05C87E..0x05C888` |
| PowerRecord `+0x01` = tax_rate | VERIFIED | re-confirmed at `0x05C8F7` (`MOV al, [bx-0x77F7]`) |
| PowerRecord `+0x22` = royal_money | VERIFIED | re-confirmed at `0x05CA48..0x05CA51` |
| PowerRecord `+0x2A` = gold (32-bit) | VERIFIED | re-confirmed at `0x05CA5A..0x05CA63` |
| **PowerRecord `+0x2E..+0x31` = a 32-bit lifetime counter** | UNKNOWN | **NEW**: same gold value is also added here. Likely lifetime treasure earned. Replaces the previous "+0x30 recruit_cost u16" hypothesis with "+0x2E..+0x31 u32 lifetime counter" |
| Pre-revolution branch path uses pre-tax `gross`; post-revolution uses full amount | UNKNOWN | NEW: the `g_revolution_flags & 1` test gates tax behaviour |

---

## 8. AIPersonality — KEY FIELD FOUND (2026-05-04)

Auto-scan of every `IMUL bx, [bp+N], 0x34` site followed by
`[bx + 0x543E..0x5441]` access reveals:

- **`AIPersonality +0x31` is read 282 times** across the disasm.
- `AIPersonality +0x32` is read 5 times.
- All other 50 bytes of the 52-byte struct are NOT accessed in
  ordinary code (likely populated at game-init from NAMES.TXT
  @PERSONALITY but read only by the AI dispatcher).

### `+0x31` decoded as the **is_ai_controlled** flag

The CHIEFKILL/EXTORTLAUGH/NOCONTACT/CASHTREASURE message gating
follows the pattern:

```asm
IMUL  bx, [bp+power_idx], 0x34
CMP   byte [bx + 0x543F], 0          ; AIPersonality[power_idx].+0x31 == 0?
JE    show_message_to_human           ; only show popups to the human player
JMP   skip_message
```

So **`+0x31 = 0` for the human player, `!= 0` for AI-controlled
powers**. The popup messages (CHIEFKILL, EXTORTLAUGH, etc.) are
suppressed for AI-vs-AI events.

### Updated layout

```c
typedef struct AIPersonality {
    u8  unknown_00[0x31];          /* +0x00..+0x30  populated from NAMES.TXT @PERSONALITY,
                                                       used internally by the AI dispatcher
                                                       — field semantics still UNKNOWN */
    u8  is_ai_controlled;          /* +0x31  VERIFIED: 0 = human, !=0 = AI;
                                              gates every player-facing popup */
    u8  unknown_32_or_secondary;   /* +0x32  PARTIAL: tested 5 times; possibly
                                              "is_ref_or_special_pseudo_power" */
} AIPersonality;
```

---

## 9. TribeData / NativeSettlement field-access scan (2026-05-04)

Auto-scan of every `MOV bx, [0x8D4E]` followed by `[bx + N]` shows
the active-tribe/settlement record's fields actually read in code:

| Offset | Access count | Note |
|-------:|-------------:|------|
| `+0x02` | 1 | CHIEFKILL formula multiplier (already documented) |
| `+0x0A` | **11** | NEW — heavily-accessed field, semantics UNKNOWN |
| `+0x0C` | 2 | NEW — semantics UNKNOWN |

Other offsets seen in the scan (0x3144..0x314C, 0x543F, 0x54EE) are
false positives where `bx` was reloaded between the `[0x8D4E]` load
and the indexed access.

**Interpretation:** if `[0x8D4E]` is the active **NativeSettlement**
(stride 18), then `+0x0A` falls inside the `alarm[4]` array (per-
European-nation friction byte for nation 0); `+0x0C` is the same
array's nation-1 friction byte. That matches the high access count
— alarm fields are read every turn by native diplomacy and AI.

If `[0x8D4E]` is instead the active **TribeData** (stride 78),
`+0x0A` and `+0x0C` are unattributed structural fields.

The fact that `+0x0A` is hit 11 times in different functions strongly
suggests this is the **NativeSettlement** active pointer (alarm-array
access pattern) — which means **TribeData itself remains essentially
un-mapped** beyond the `+0x02` byte read in CHIEFKILL.

---

## 10. Capital-bonus / Cibola handler — NOT FOUND (2026-05-04)

Targeted searches for the secondary capital-bonus path returned
empty:

- `grep "TEST.*[bx + 3], 4"` (BLCS bit-2 = capital flag) → 10 sites,
  but **none follow a `MOV bx, [0x8D4E]`** load. All hits are
  testing `UnitRecord +0x03 bit 2` (something in `moves_used`),
  not the settlement's BLCS byte.
- `grep "LOSTCITY"` / `"CIBOLA"` / `"BURIAL"` / `"FOUNTAIN"` in the
  disasm comments → **0 hits**. Those `@-section` names don't appear
  as immediate-pushed strings in `VICEROY.EXE`'s string segment.
- The CHIEFKILL formula at `func_04A7CA` already proven not to have
  a capital-only branch.

**Updated hypothesis** (see also §2): the pure CHIEFKILL formula
*alone* may explain the observed 15,000 / 10,000 totals if
`TribeData[Inca]+0x02 ≈ 22` and `TribeData[Aztec]+0x02 ≈ 14` —
both within the average dice-roll range at Discoverer difficulty.
The capital-bonus may simply be an artifact of:
1. Tribe-specific multiplier byte (TribeData +0x02)
2. High-roll observation bias
3. No genuine "capital-only bonus" — capitals are razed using the
   same formula as villages

This is the most parsimonious explanation given:
- No second gold-credit code path was found
- No secondary-popup message string xref exists in VICEROY.EXE
- The CHIEFKILL formula's gold range is wide enough to account
  for both observations

To confirm: capture `TribeData[8]+0x02` from a live memory dump.
If those bytes are 22 (Inca) and 14 (Aztec), the case is closed.

---

## 11. TribeData +0x02 = civ_tier — VERIFIED FROM RUNTIME (2026-05-08)

Loaded `session_1777952458/mem/1310473156000000.zst` and read the
TribeData table at `DGROUP:0x5AD6` (stride 78, 8 entries). The byte
at +0x02 of each tribe matches NAMES.TXT @TRIBES column 4
(civilization tier) exactly:

| Tribe | TribeData +0x02 | NAMES.TXT @TRIBES col-4 |
|-------|----------------:|------------------------:|
| Inca | **3** | 3 (Advanced) |
| Aztec | **2** | 2 (Civilized) |
| Arawak | **1** | 1 (Agrarian) |
| Iroquois | **1** | 1 |
| Cherokee | **1** | 1 |
| Apache | **0** | 0 (Nomadic) |
| Sioux | **0** | 0 |
| Tupi | **0** | 0 |

This **closes the long-standing question** about what
TribeData +0x02 contains.

### Implications for the CHIEFKILL formula

The byte read by CHIEFKILL at `0x04AB24` is therefore
**`civ_tier`** (0..3). The formula:

```
gold = sum_3 × roll_4 × 4 × (civ_tier + 1)
```

gives a maximum of:

| Tribe | civ_tier | (cv+1) | Max gold @ Discoverer |
|-------|---------:|-------:|----------------------:|
| Inca | 3 | 4 | **2,880** |
| Aztec | 2 | 3 | 2,160 |
| mid | 1 | 2 | 1,440 |
| nomadic | 0 | 1 | 720 |

### REJECTS the "no capital bonus exists" hypothesis

Section 2 / 10 above suggested that the pure CHIEFKILL formula
might explain the user-observed 15,000 / 10,000 gold totals if
the multiplier byte were ~22 / ~14. **It is not** — the byte is
civ_tier 3 / 2, capping the theoretical max at 2,880 / 2,160.

**Therefore a separate capital-bonus handler MUST exist.** The
2026-05-04 conclusion "capital bonus is in @LOSTCITY2/Cibola
handler" stands; no replacement is possible without that handler.

### Other newly-visible TribeData fields

From the same memory dump, several non-zero bytes vary by tribe
(see updated `GHIDRA_REFERENCE.c` §4 for the layout):

- **+0x0C**: Inca=0x87, Aztec=0x22, Arawak=0x01, others=0
  — looks like a per-tribe contact-status bitfield or
  settlement-list head indicator
- **+0x36**: Inca=7, Aztec=6, Tupi=0xFE — possibly aggression
- **+0x3A, +0x3D, +0x46, +0x4A**: per-tribe varying bytes; likely
  parameters from NAMES.TXT @TRIBES (treasure value, alarm base,
  attack rate) but offsets not byte-confirmed
- **+0x05**: 0x02 for Arawak only — anomalous flag

The pavelbel-suspected fields (skills_offered[4], goods_wanted[4],
capital_name_idx, climate) likely live in the +0x0D..+0x35 region
but cannot be byte-attributed without parser disasm.

---

## 12. Capital-bonus formula — CANDIDATE LOCATION FOUND (2026-05-08)

Auto-scan for `civ_tier × N` patterns located **orphan range starting at
file `0x04A005`** (in `orphans_overlay.asm`) which contains the
treasure-amount calculation:

```asm
04A02F  MOV   bx, [0x8D4E]         ; bx = active settlement/tribe ptr
04A033  MOV   al, [bx + 2]         ; al = civ_tier
04A038  SUB   ax, 8
04A03B  NEG   ax                   ; ax = (8 - civ_tier)
04A03D  IMUL  ax, ax, 0x32         ; ax = (8 - civ_tier) × 50
04A040  MOV   [bp - 0x60], ax      ; stash partial
```

Followed by ~150 bytes of additional adjustments combining:
- A unit-type-gated halving of `g_8DC4` (ships divide by 4)
- A per-tribe lookup byte at `[bp+si-0x96]`
- A `random_int(0, 200)` term via `LCALL 0x181F:0x04D4`
- A difficulty-byte add (`× (diff + N) × 10`)
- A subtract of `g_some_array[idx] × 4`
- A division through `g_8DC4` (Borland's helper at `0x0D1D:0x0EC6`)
- A floor of 50 (`if (amount < 50) amount = 50`)

The final `amount` value is:
- Pushed to popup buffer slot 3 via `LCALL 0x181F:0x09AE`
- Stored at `DGROUP:0x9CB8/0x9CBA` (the capital-raze popup buffer)
- Added to `g_power_table[player].gold` via the standard 32-bit
  ADD/ADC pattern at indexed offset `+0x77CE` (= PowerRecord +0x2A)

### Status

This is a **CANDIDATE** for the capital-bonus / Cibola treasure
handler. The combination of:
- It reads `g_active_settlement->civ_tier`
- It writes to popup buffer at `DGROUP:0x9CB8` (which DATA_MODEL.md
  documents as "capital-raze popup buffer")
- It adds to player gold via `PowerRecord +0x2A`
- It's only ~600 bytes from the CHIEFKILL handler in code

…strongly suggests this is the correct location. Final
confirmation needs the orphan to be attached to its parent
function, which requires identifying the call site (e.g., from
`func_04A7CA` chief-encounter dispatcher or a separate
"Cibola treasure" path).

The formula's complexity (multi-input, bounded ≥ 50) is consistent
with Cibola treasure values which Colonization documentation cites
as "1,500 to 9,000 gold" — within range of this calculation.

### Updated location of the missing handler

Plan 100 task 092 / Plan 300 task 201 / RESIDUAL_FINDINGS §10
"capital-bonus handler not found" → **promoted to**
"capital-bonus handler likely at orphan_overlay file
0x04A005..0x04A140 (~315 bytes); pending orphan-to-function
attribution".

---

## 13. Capital-bonus handler attributed to func_049600 (2026-05-08)

The orphan range starting at file `0x04A005` (RESIDUAL_FINDINGS §12)
is actually part of `func_049600` — the disassembler truncated the
function at file `0x4969+` because it tagged 4 bytes (`9A CA 04 1F`)
as `DATA_BYTE`. Those bytes are the start of a valid `LCALL 0x1F04:0x...`
instruction, not data. The actual function body extends to ~`0x04A140`
or beyond.

**Inferred role of `func_049600`: Lost-City / Cibola treasure handler.**

Evidence:
- ENTER `0xD8`, 0 — large 216-byte stack frame for substantial work
- Reads `g_active_settlement->civ_tier` (TribeData +0x02 — verified §11)
- Gates on `UnitRecord[idx].unit_type ∈ [0x0D..0x12]` (ships):
  `*(word*)0x8DC4 >>= 2` (ships discovering treasure get ÷4 modifier)
- Writes to `DGROUP:0x9CB8/0x9CBA` — the documented "capital-raze
  popup buffer"
- Credits `g_power_table[player].gold` via the standard 32-bit
  ADD/ADC indexed write to `+0x2A`
- Uses `LCALL 0x181F:0x09AE` with arg 3 (push popup arg slot 3)
- The `(8 - civ_tier) × 50` term is one of several adjustments;
  full formula combines random rolls, difficulty modifier, and
  state-global multipliers

Plan 100 task 092 / Plan 300 task 201 / RESIDUAL_FINDINGS §10 / §12
"capital-bonus handler unknown / candidate" → **promoted to**
"capital-bonus / Cibola treasure handler is `func_049600`".

Final piece: hand-trace `func_049600` line-by-line to extract the
exact gold formula. The function is ~770 bytes (0x49600..0x4A140+),
needing one focused session to fully decompile.

---

## 14. PowerRecord +0x30 has ZERO accesses — recruit_cost is NOT there (2026-05-08)

A comprehensive scan of every `[bx + disp16]` instruction with disp
in PowerRecord range (`0x8808..0x8944`) found **22 distinct fields
accessed across the whole disasm**:

| Field | Access count | Type |
|------:|-------------:|------|
| +0x00 | 11 | TEST byte (control_type bit-test) |
| +0x01 | 8 | MOV byte (tax_rate) |
| +0x14 | 2 | MOV/CMP (FF count) |
| +0x16 | 2 | MOV (?) |
| +0x19 | 2 | MOV (?) |
| +0x22..+0x29 | 8 | ADD/ADC pairs (royal_money + adjacent u32 fields) |
| +0x2A | 23 | PUSH/MOV/ADD/CMP — **gold u32 (most-accessed field)** |
| +0x2C | 18 | PUSH/ADC — gold high word |
| +0x2E | 1 | ADD only — likely lifetime treasure |
| **+0x30** | **0** | **NO ACCESSES** — `recruit_cost` is NOT here |
| +0x32 | 7 | MOV (?) — possibly `ref_strength_total` per pavelbel |
| +0x33 | 5 | MOV (?) — UNKNOWN |
| +0x40 | 1 | CMP |
| +0x46 | 1 | MOV |
| +0x4A | 1 | ADD |
| +0x5A, +0x5C, +0x7C, +0xBC, +0xFC | 1 each | scattered MOVs |

**Implication**: the earlier "PowerRecord +0x30 = recruit_cost u16
(doubles per recruit purchase)" claim — derived from pavelbel SAV
schema — is **false at the runtime layout level**. Either:
1. Recruit cost lives in a separate flat array (per-power) at a
   different DGROUP location
2. Recruit cost is computed at recruit-time from base + counter
   (not stored as a field that needs doubling)
3. The pavelbel SAV-format offset doesn't match the runtime layout
   (the SAV serializer might reformat fields)

The DATA_MODEL.md and GHIDRA_REFERENCE.c entries for `recruit_cost`
have been demoted from VERIFIED → UNKNOWN-LOCATION.

### Other newly-flagged fields needing investigation

- **+0x00** with 11 TEST sites — likely `control_type` per
  pavelbel (Human / EuroAI / NativeAI / King)
- **+0x33** with 5 MOV sites — UNKNOWN; possibly per-power
  difficulty-adjustment cache or mid-byte of a u16 at +0x32
- **+0x16, +0x19** — UNKNOWN

---

## 15. Difficulty byte location confirmed (2026-05-08)

Cross-checked `DGROUP:0x53A6` against the runtime memory dump and
pavelbel's HEAD.difficulty enum:

| Byte at DGROUP:0x53A6 | pavelbel enum |
|----------------------:|---------------|
| 0 | Discoverer |
| **1** | **Explorer** ← test session value |
| 2 | Conquistador |
| 3 | Governor |
| 4 | Viceroy |

So `0x53A6 = 1` in the test session = **Explorer**. The earlier
note "user said Discoverer with 0x53A6=1 suggests this byte is
something else" was based on a wrong assumption about the user's
chosen difficulty. **The byte location is correct; the
interpretation is per-pavelbel-enum.**

Plan 300 task 195 → resolved.

---

## 16. ASOUND.COL is confirmed AdLib FM driver (2026-05-08)

Decoded the MZ header of `ASOUND.COL` and analyzed contents:

- **Entry point**: file `0x000210` (cs:ip = `0x0000:0x0010` after
  header offset)
- **Build stamp at entry**: `"ColonizatonA09-14-94NO"` — the driver
  was built **September 14, 1994**
- **Function table**: starts immediately after the build stamp
  (count word `0x000B = 11`, followed by 11 × 2-byte function
  pointers — likely the driver's exposed entry-point ABI)
- **AdLib OPL2 port writes** (indirect form — `MOV DX, 0x388`
  followed by `OUT DX, AL`):
  - 9 `MOV DX, 0x0388` sites (file `0x1467..0x15DE`)
  - 0 `MOV DX, 0x0389` sites (data port accessed via INC DX from index)
  - 151 total `OUT DX, AL` sites across the driver
- **49 RETF sites** = ~49 functions in the driver
- **No direct OUT 0x388, AL** (`E6 88`) sites — all AdLib writes
  are indirect, consistent with a real-mode driver that may
  parameterize port numbers

The 11 function-table entries at `0x000226..0x000240` are the
driver's interface to the main game (init / set_volume / play_note /
stop_note / load_patch / queue_event / etc.). To complete the audio
decode: cross-reference these table offsets against the function
bodies (each starts at the corresponding pointer value) and identify
which pointer is which entry-point by matching its OPL2 register
write pattern against published OPL2 instrument-playback sequences.

The other three sound drivers have similar MZ structures (different
entry points and build stamps); their internals follow the same
pattern but talk to different hardware (Sound Blaster DSP, PC
Speaker timer, Roland MT-32 MIDI).

Plan 1000 tasks 791-800, 831-840 → at-the-driver-level decoded.
Per-instrument patches still require per-driver disasm sprint.

---

## 17. Lost-City treasure formula — full hand-decode (2026-05-08)

Hand-decoded the 220-byte chunk at file `0x04A005..0x04A0E1` inside
`func_049600`. The full pseudo-C reconstruction:

```c
i16 lost_city_or_cibola_treasure_amount(void) {
    /* Inputs visible at this entry:
     *   [bp+6]  = unit_idx (the discovering / razing unit)
     *   [bp+8]  = ?
     *   [bp+0xA] = power_idx (the player power)
     *   [bp-0x84] = some_idx (set earlier in func_049600; index into 0x9E78 array)
     *   [bp-0x96..-0x86] = a 16-byte stack-local array (per-tribe lookup K)
     *   [bp-0xCA] = a previously-set max_K value
     *   [bp-0xC0] = current K (loop variable from earlier code)
     *   *(word*)0x8DC4 = treasure base (set by caller; possibly civ_tier-based
     *                    or NAMES.TXT @TRIBES col-5)
     */

    /* file 0x4A005 — load per-tribe lookup byte K */
    i16 K = (i8)stack_array[bp_si_base];   // signed-extended

    /* file 0x4A012 — ships discovering Lost City get ÷4 modifier */
    if (UnitRecord[unit_idx].unit_type >= 0x0D
     && UnitRecord[unit_idx].unit_type <= 0x12) {
        *(i16*)0x8DC4 >>= 2;   /* SAR by 2 = ÷4 (signed) */
    }

    /* file 0x4A025 — start with base 200 */
    i16 amount = 200;

    /* file 0x4A02A — if K >= 8, replace amount with civ_tier formula */
    if (K >= 8) {
        amount = (8 - g_active_tribe->civ_tier) * 50;   /* file 0x4A02F..0x4A040 */
    }

    /* file 0x4A043 — if K >= 7, add lookup × ((diff×2) + 15) */
    if (K >= 7) {
        u16 si = power_idx << 4;                        /* per-power table stride 16 */
        u8  K_lookup = lookup_table_at_0x84BC[si + K];   /* file 0x4A054 */
        u16 mult = (g_difficulty << 1) + 15;             /* file 0x4A060..0x4A062 */
        amount += K_lookup * mult;                       /* file 0x4A065 */
    }

    /* file 0x4A06A — random bonus in [0, current amount] */
    amount += random_int(0, amount);                    /* LCALL 0x181F:0x04D4 */

    /* file 0x4A07A — subtract a discount: array_at_0x9E78[some_idx] × 4 */
    i16 some_idx = stack_local[bp - 0x84];
    amount -= ((i16*)0x9E78)[some_idx] << 2;

    /* file 0x4A08A — add per-power lookup × 4 (helper at 0x181F:0x30C) */
    u16 helper_result = helper_181F_030C(g_active_power, power_idx);
    amount += helper_result << 2;

    /* file 0x4A09F — scale by treasure_base: amount = amount × 8DC4 / 100 */
    amount = (i16)(((i32)amount * *(i16*)0x8DC4) / 100);

    /* file 0x4A0B3 — add (difficulty + small_dice) × 10 */
    i16 small_dice = random_int(0, 2);
    amount += (g_difficulty + small_dice) * 10;

    /* file 0x4A0D6 — clamp to ≥ 50 */
    if (amount < 50) amount = 50;

    /* file 0x4A0E4 onward — store and credit:
     *   *(u32*)0x9CB8 = amount;            // popup buffer
     *   push_popup_arg(amount, 3);          // LCALL 0x181F:0x09AE
     *   g_power_table[power_idx].gold += amount;  // 32-bit ADD/ADC at +0x2A
     */
}
```

### Implications

- The formula has **multiple independent terms**, so simple
  hypotheses ("civ_tier × 50" alone) can't predict outcomes —
  the user-observed 15,000 (Inca) / 10,000 (Aztec) values come
  from the full chain including `*(i16*)0x8DC4` (treasure base
  set by caller) and the per-tribe `K` lookup
- **Treasure base at `0x8DC4`** is the dominant scaling factor —
  multiplied directly into amount before the +50 clamp. Per-tribe
  variation here is what produces dramatically different totals
  for Inca vs Aztec
- **Two random_int calls** introduce per-raze variance (one
  scales by current amount, one is small dice 0..2)
- **K lookup table at 0x84BC** is per-(power × 16 + K) byte —
  16-stride suggests one row per power; possibly per-power
  treasure-discovery-history bonus

### Updated function attribution

`func_049600` spans the full range **`0x049600..0x04A37A`** (3,450
bytes) — not the smaller orphan range I initially guessed. The
disassembler split it because it mis-tagged a `9A CA 04 1F` LCALL
as data bytes at `0x4969+`. The disasm ledger reports
`func_049600` truncated at 186 bytes, but the actual function is
~18× larger.

### Status

Lost-City treasure formula → **full pseudo-C reconstruction**
(BYTE_VERIFIED for the 220-byte slice; some helper LCALLs and the
treasure-base setter still UNKNOWN). Plan 100 task 092 (capital
bonus) → handler decoded; per-tribe `K` and `0x8DC4` setter remain
the missing pieces but the gold-amount formula itself is now
recoverable.

---

## 18. recruit_cost — 4 candidate doubling sites identified (2026-05-08)

A scan for `SHL word [DGROUP:NN], 1` (the doubling pattern) found
four candidate locations:

| File offset | Doubled DGROUP word | Runtime value |
|------------:|--------------------:|--------------:|
| 0x00A594 | `DGROUP:0x8DEC` | **3** (small — likely a counter, not a cost) |
| 0x016886 | `DGROUP:0x458A` | UNKNOWN |
| 0x019D4C | `DGROUP:0x4D21` | 0 |
| 0x019DB4 | `DGROUP:0x4D21` | 0 |

None of these match a "recruit_cost" semantically:
- `0x8DEC = 3` is too small — recruit costs start at ~200 gold
- `0x4D21 = 0` and is doubled twice (so it's an init/reset path,
  not a per-purchase doubler)
- `0x458A` value not yet examined

So **recruit_cost remains UNKNOWN-LOCATION**. The doubling logic
likely lives in code that loads the cost into a register, doubles
it via `SHL ax, 1` or `ADD ax, ax`, and stores back via a separate
write — patterns that are harder to grep for than direct memory
shifts. Or recruit_cost lives in a per-power array indexed at
runtime, and the doubling is applied via `SHL [bx+disp16], 1`
(the bx-relative form), which my earlier scan covered — and found
zero hits in PowerRecord range.

The most likely hypotheses remaining:
1. **Recruit_cost is computed at recruit-time** from a base value
   (NAMES.TXT @JOB column 4 "EuropeCost") plus an exponent counter
   that tracks "how many recruits has this power purchased". The
   counter increments per purchase; `cost = base << counter`.
   This is consistent with the "doubling" gameplay description
   without requiring a stored cost field.
2. **Recruit_cost lives in PowerRecord +0x33** (5 MOV access sites,
   currently UNKNOWN — see §14). Still need to inspect those sites.

Status: still open. Worth spending a focused session inspecting
the 5 MOV sites at PowerRecord +0x33 and the Europe-screen
recruit-button handler.

---

## 19. PowerRecord +0x32 / +0x33 = home_x / home_y bytes (2026-05-08)

The 5 access sites at PowerRecord +0x33 (and the corresponding 7
sites at +0x32) reveal the field's true purpose. Decoded from the
unit-spawn function at file `0x058BB5..0x058BD7`:

```asm
058BB5  IMUL bx, [bp+6], 0x13C       ; bx = power_idx × 316
058BBA  MOV al, [bx + 0x883A]         ; al = PowerRecord +0x32 = home_x byte
058BBE  IMUL si, [bp+0xA], 0x1C       ; si = unit_idx × 28
058BC2  MOV [si + 0x314D], al         ; UnitRecord +0x07 = map_x ← home_x
058BC6  MOV al, [bx + 0x883B]         ; al = PowerRecord +0x33 = home_y byte
058BCA  MOV [si + 0x314E], al         ; UnitRecord +0x08 = map_y ← home_y
```

**Both fields are bytes, accessed via `MOV al`, NOT u16.** The pair
(x, y) is copied to a newly-spawned unit's map coordinates, meaning
PowerRecord +0x32 / +0x33 is the player's **home / spawn-back
coordinate pair**.

Confirmed at three independent code paths:
- File `0x058BB5..0x058BD7`: spawn-unit-at-home (copies pair → UnitRecord)
- File `0x065CC3..0x065CD6`: write-pair (sets home_x/home_y from locals)
- File `0x075910..0x075929`: render-pair (copies to map-view globals
  `0x017C/0x017E` and `0x8540/0x853E`)

### Correction to PowerRecord layout

The previous claim "PowerRecord +0x32 = ref_strength_total u16
(per pavelbel)" is **incorrect** at the runtime layout level.
ref_strength_total either (a) lives at a different offset or
(b) is computed at runtime by summing per-unit-type counts at
DGROUP:0x53DA (the byte-verified REF array). Pavelbel's NATION
schema offset doesn't 1:1 match runtime layout here.

DATA_MODEL.md and GHIDRA_REFERENCE.c entries for `ref_strength_total`
have been demoted from PARTIAL → UNKNOWN-LOCATION; +0x32 / +0x33
relabelled as `home_x` / `home_y` (byte each).

### Implication for recruit_cost

PowerRecord +0x33 is **definitively NOT recruit_cost** (it's
home_y). The recruit_cost hunt continues — see §18 for hypotheses.
Most likely: `cost = base_from_NAMES.TXT_@JOB << purchase_count`
computed at recruit-time, not stored.

---

## 20. *(i16*)0x8DC4 setter — contextual, not single-source (2026-05-08)

A scan for every write to DGROUP:0x8DC4 shows **10 distinct setter
sites** across the disasm:

| File | Pattern | Source |
|------|---------|--------|
| 0x00B452 | `MOV [0x8DC4], ax` | result of CALL near to `func_00B2F0_unit_table_3154_byte` (a generic "read byte at UnitRecord[idx] + (col_arg + 0x0E)" accessor) |
| 0x00B5A0 | `MOV [0x8DC4], ax` | (similar pattern; nearby) |
| 0x00B8A2 | `MOV [0x8DC4], ax` | (similar pattern) |
| 0x02A7B6 | `MOV [0x8DC4], ax` | min/max clamp: stores `min(local, current_0x8DC4)` |
| 0x02A88C | `MOV [0x8DC4], ax` | (clamping logic adjacent) |
| 0x02AA5D | `MOV [0x8DC4], ax` | (clamping logic) |
| 0x032492 | `MOV [0x8DC4], ax` | direct: `*(i16*)0x8DC4 = arg10` (pass-through setter) |
| 0x032F63 | `MOV [0x8DC4], ax` | similar |
| 0x052D9C | `MOV [0x8DC4], ax` | (TBD) |
| 0x052DA8 | `MOV [0x8DC4], ax` | (TBD) |
| 0x04A020 | `SAR [0x8DC4], 2` | inside Lost-City formula — divides by 4 if discoverer is a ship |

**Conclusion: there is NO single "treasure_base table".** The value
at `*(i16*)0x8DC4` is a general-purpose scratch global that the
caller of `func_049600` (Lost-City handler) sets from various
sources depending on the trigger event:

- **For Lost-City discovery** (Scout walks onto a tile with
  feature byte 0xB0): the caller reads a byte from the tile's
  feature data and stores it
- **For capital raze**: the caller reads from the razed
  settlement's record (or computes from civ_tier + something)
  before invoking the handler
- **For Treasure Train cash-in**: handled by `func_05C878`
  (different code path; uses `unit.profession_amount × 100`)

The `0x8DC4` global is reused across these scenarios as an
"in-progress treasure base" parameter passed via global rather
than via the C call ABI.

### Implication for capital-bonus

To predict the user's observed 15,000 (Inca) / 10,000 (Aztec)
exactly, we'd need to identify the **specific call site** that
invokes `func_049600` for a CAPITAL RAZE event (vs a Lost-City
discovery), and trace what value gets stored to `0x8DC4` first.

Best lead: the call site is probably inside `func_04A7CA`
(CHIEFKILL handler) or a function adjacent to it that fires
when a capital is destroyed. The trigger condition would be:
```
if (settlement.population == 0 after raze)
   && (settlement.BLCS & 4)        // capital flag
   && (tribe.civ_tier >= 1) {
       *(i16*)0x8DC4 = some_per_tribe_value;
       func_049600(unit_idx, power_idx, ...);    // Cibola treasure
}
```

The "some_per_tribe_value" — most likely the NAMES.TXT @TRIBES
column-5 value (Inca=97, Aztec=149) or a per-tribe wealth byte
in TribeData beyond +0x02 — is what makes Inca capitals worth
more than Aztec. Identifying that single read site would close
the formula end-to-end.

### Status

`*(i16*)0x8DC4` setter sites mapped (10 total). The dominant
treasure-base scaling factor in the Lost-City formula is now
attributed to per-call setup rather than a single source. Final
attribution of the per-tribe value for capital razes remains the
last open question.

---

## 21. ref_strength_total is NOT a stored field (2026-05-08)

Runtime memory inspection of the test session:

```
DGROUP:0x53D6  =  1     (some flag)
DGROUP:0x53D8  =  1     (some flag)
DGROUP:0x53DA  = 23     REF slot 0 (Reg / Foot)
DGROUP:0x53DC  = 10     REF slot 1 (Cav / Dragoon)
DGROUP:0x53DE  =  5     REF slot 2
DGROUP:0x53E0  =  8     REF slot 3
DGROUP:0x53E2  =  0     trailing
```

Total REF = 23 + 10 + 5 + 8 = **46** (= `0x002E`).

A scan for the value `0x002E` as a u16 in the DGROUP king area
(0x5380..0x5500) returned **zero matches**. Likewise, searches in
PowerRecord field range (0x8808..0x8944) showed no field holds the
running sum. **`ref_strength_total` is computed at display time, not
stored.** The Continental Congress and similar UIs sum the 4 REF
slot u16s on demand.

### Status correction

- The previously-claimed "PowerRecord +0x32 = ref_strength_total
  u16" entry is **doubly wrong**:
  1. PowerRecord +0x32 is `home_x` (byte) — verified §19
  2. ref_strength_total isn't stored at all
- DATA_MODEL.md / GHIDRA_REFERENCE.c entries already corrected for
  +0x32 (= home_x). Full ref_strength_total entry should be
  removed and replaced with a note: "computed at render time from
  DGROUP:0x53DA u16[4]".

### REF slot-order observation

User-recorded slot order was `(Reg, Cav, MoW, Art) = 23/10/8/5`.
Runtime bytes show `(0x53DA, 0x53DC, 0x53DE, 0x53E0) = (23, 10, 5, 8)`,
i.e., the third and fourth slots are **5 and 8**, not 8 and 5. So
either:
- The slot order is actually `(Reg, Cav, Art, MoW)`: Reg=23, Cav=10,
  Art=5, MoW=8
- OR the user mis-ordered when recording

Either way, the **bytes themselves are correct** — only slot
semantics (which u16 = MoW vs which = Art) need re-verification
from the in-game UI.

---

## 22. recruit_cost still UNKNOWN; gold-SUB sites mapped (2026-05-08)

A scan for `SUB [PowerRecord+0x2A], ax` (gold deduction) found
only **3 sites** in the entire disasm:

| File offset | Owning function | Likely purpose |
|------------:|-----------------|----------------|
| 0x04A1DF | `func_049600` (Lost-City handler) | conditional gold deduction in Burial-Mound penalty branch (per @BURIAL1/2/3 events) |
| 0x04B2FC | `func_04AF5E_unknown.asm` adjacent | TBD |
| 0x05C5D4 | inside the function CONTAINING `func_05C878` (Treasure Train cash-in) | TBD |

**None of these sites is in a Europe-screen recruit handler.**
This strongly suggests recruit_cost is **never actually
deducted as a stored value** — instead, the recruit purchase
flow is:

```c
void recruit_purchase(power_idx, slot_idx) {
    u16 cost = NAMES.TXT_@JOB[recruit[slot_idx].profession].EuropeCost
             << g_power_table[power_idx].recruit_count;
    if (g_power_table[power_idx].gold >= cost) {
        g_power_table[power_idx].gold -= cost;       // would show in our scan
        spawn_colonist_at_europe_dock(power_idx, slot_idx);
        g_power_table[power_idx].recruit_count++;
    }
}
```

But our scan found NO such SUB at the Europe-screen address range
(0x07XXXX is where Europe-screen handlers typically live). So
either:
- The deduction uses `LCALL 0x181F:0x09AE` (modify_gold) with a
  negative amount — that thunk has 106 sites (too noisy to filter)
- The recruit purchase is handled in a function we haven't located
- The cost-calculation is via a separate helper that doesn't show
  the standard SUB pattern

**recruit_cost remains UNKNOWN-LOCATION.** Best path forward: find
the function that handles the Europe-screen "RECRUIT" button click
(probably in 0x07XXXX area, since Europe screen is rendered at
high addresses) and trace its gold-modification call.

---

## 23. RTLink thunks DO NOT resolve to func_049600 (2026-05-08)

Cross-referenced `viceroy_source/overlay_thunks_resolved.json`
(1,020 thunks) against the file range `0x048000..0x04B000`. **Zero
thunks resolve to anywhere in this 12 KB region**, despite
func_049600's disasm header tagging it as `Region: overlay`.

This contradicts the assumption that func_049600 is reachable via
the standard RTLink overlay LCALL mechanism. Possible
interpretations:

1. **The function is reached via FAR LCALL with a hardcoded
   segment:offset pair**, bypassing the thunk table entirely.
   This is unusual but possible for performance-sensitive paths.
2. **The function is dead code** — never actually called at
   runtime. This would explain zero callers and zero thunks.
3. **The function is called via an indirect/computed pointer**
   stored elsewhere in DGROUP — e.g., a function-pointer table
   initialized at game start.
4. **The disasm tool's "Region: overlay" classification is
   wrong** — and it's actually load-image code that was missed.

This **weakens the "func_049600 is the Lost-City / Cibola
treasure handler" hypothesis** documented in §13. The function
contains the right shape of formula (civ_tier multiplier,
treasure popup buffer write, gold credit), but without an
identified call site, we cannot confirm it actually fires for
capital razes.

### Status

The capital-bonus mystery remains formally OPEN. The candidate
function and its formula are documented, but attribution to a
specific game event is unverified. Plan 100 task 092 status
revised from "candidate identified" → "candidate identified;
caller untraceable via standard mechanisms".

---

## 24. ASOUND.COL function table — 11 entries decoded (2026-05-08)

The driver's exposed ABI lives at file `0x000232..0x000247` after
the build stamp + 8 bytes of init data:

```
file 0x000220: "4-94NO\0"  (tail of build stamp)
file 0x000228: 00 00 00 00          (padding)
file 0x00022A: C0 03                u16 = 0x03C0 (param? maybe driver-param)
file 0x00022C: D0 82                u16 = 0x82D0 (?)
file 0x00022E: 64 00                u16 = 0x0064 (=100)
file 0x000230: 00 00                (padding)
file 0x000232: <table data>          (no count word visible — was elsewhere)
```

Actually the count word `0x000B = 11` lives at file `0x000230`,
followed by 11 × u16 function pointers from `0x000232..0x000247`:

| Idx | Pointer | File offset | First bytes | Comment |
|----:|--------:|------------:|-------------|---------|
| 0 | 0x19D2 | 0x001BD2 | `55 8B EC 1E 57 56 B8 C0` | **MS-prologue: real function** (PUSH BP/MOV BP/SP/PUSH DS/DI/SI/MOV AX, 0x03C0) |
| 1 | 0x1A35 | 0x001C35 | `55 8B EC 1E B8 C0 03 8E` | **MS-prologue: real function** (similar shape) |
| 2 | 0x1AD2 | 0x001CD2 | `57 1E 55 B8 C0 03 8E D8` | partial: PUSH DI/DS/BP, MOV AX, 0x03C0 (no MOV BP/SP) |
| 3 | 0x1AF5 | 0x001CF5 | `1E B8 C0 03 8E D8 E8 ...` | inline: PUSH DS, MOV AX, 0x03C0, MOV DS, AX, CALL |
| 4 | 0x1B09 | 0x001D09 | (similar inline) | |
| 5 | 0x1B16 | 0x001D16 | `2E A1 70 0F` | inline: MOV AX, CS:[0x0F70] (segment-override read) |
| 6 | 0x1B1B | 0x001D1B | `CB CB CB CB` | **RETF stub (no-op)** |
| 7 | 0x1B1C | 0x001D1C | `CB CB CB ...` | RETF stub |
| 8 | 0x1B1D | 0x001D1D | `CB CB ...` | RETF stub |
| 9 | 0x1B1E | 0x001D1E | `CB ...` | RETF stub |
| 10 | 0x1B1F | 0x001D1F | `CB ...` | RETF stub |

Entries 6-10 all point to consecutive RETF instructions — these
are no-op stubs for unused ABI slots. Entries 0-5 are the active
functions:

- **Entry 0 (init or main play function)** — full MS-style prologue
  saving DS/DI/SI registers; loads paragraph 0x03C0 into AX
- **Entry 1** — same prologue style; possibly stop / cleanup
- **Entries 2-4** — varied prologue depth; possibly set_volume,
  pause, resume helpers
- **Entry 5** — inline data accessor reading CS:[0x0F70]; likely a
  status / register-readback function

The **9 `MOV DX, 0x0388` sites at file 0x1467..0x15DE** are inside
a separate code region (not at the table entry points), suggesting
they're internal helper routines called by the real ABI functions
to write to the OPL2 index port.

### Status

ASOUND.COL ABI structure decoded. Per-instrument FM patches
require disassembling each table entry's body — tractable but a
separate ~6 hour sprint. The 5 active entries × ~50-200 bytes each
is the scope of remaining work.

Plan 1000 task 791-800 / 831-840: now at "ABI decoded, internal
patch sequences pending."

---

## 25. recruit_cost — handler is NOT in 0x07XXXX (2026-05-08)

A scan of the Europe-screen address range (0x070000..0x080000)
for `LCALL 0x181F:0x09AE` (modify_gold thunk) found **zero
matches**. Likewise no negative-PUSH-then-LCALL pattern, no
gold-deduction site.

Either:
1. The Europe-screen recruit handler is at an address outside
   0x07XXXX (the rendering may be there but the gameplay logic
   could be in the 0x06XXXX range or even the early code area)
2. recruit cost is **never actually deducted via the standard
   gold-modify thunk** — it's a direct `SUB [PowerRecord+0x2A], ax`
   or similar
3. The recruit purchase doesn't deduct from gold at all — it's
   handled by a function that uses `LCALL 0x181F:0x9A4` (read unit
   record / get cargo qty) or another helper

The 3 known direct-SUB sites (file 0x04A1DF, 0x04B2FC, 0x05C5D4)
are in:
- `func_049600` (Lost-City handler — Burial Mound penalty branch)
- adjacent overlay code
- adjacent to Treasure Train cash-in

None of these are Europe-screen.

**recruit_cost remains UNKNOWN-LOCATION** with three failed
investigation paths:
1. ❌ PowerRecord +0x30 (zero accesses)
2. ❌ Doubling-pattern scan (4 candidates all ruled out)
3. ❌ Europe-screen modify_gold scan (zero matches)

Best remaining hypothesis: recruit cost is computed at recruit-
time as `cost = base_from_NAMES.TXT_@JOB << power.recruit_count`
and never stored. The function that handles RECRUIT button click
would be a rare candidate — it would need targeted search via
keyboard-input handler trace or PIK-button hit-test code.

---

## 26. ASOUND.COL entries 0 and 1 hand-decoded (2026-05-08)

Wrote a minimal x86-16 decoder and traced the first two function-
table entries instruction-by-instruction.

### Entry 0 at file `0x001BD2` — channel-programmer

```c
/* Far-call ABI: ~7 args of 16 bits each at [bp+0x06..0x12] */
void asound_program_channel(u16 arg1, u16 arg2, ..., u16 arg7) {
    /* Standard prologue */
    PUSH bp; MOV bp, sp;
    PUSH ds; PUSH di; PUSH si;

    DS = 0x03C0;                           /* driver data segment paragraph */

    bx = arg2;                              /* [bp+0x08] */
    *(u16*)(CS:0x0F82) = bx;                /* state: last channel/op */
    *(u16*)(CS:0x009D) = bx;                /* state: cached op idx */

    /* Range gate 1: arg2 must be one of four OPL2 operator indices */
    if (bx == 0x11 || bx == 0x12 || bx == 0x18 || bx == 0x20) {
        bx = arg1;                          /* reload channel from [bp+0x06] */
        *(u16*)(CS:0x????) = bx;            /* additional state save */
        if (signed condition) goto end;
    }

    /* Range gate 2: arg5 ([bp+0x0E]) is OPL2 melodic-channel register */
    ax = arg5;
    if (ax < 0x11 || ax > 0x2F) goto skip_program;

    *(u16*)(CS:0x0F88) = ax;                /* state: current register */

    /* Push 4 args (instrument patch data?) and far-call internal helper */
    PUSH arg7; PUSH arg6; PUSH arg5; PUSH arg4;
    LCALL 0x0000:0x0B65;                    /* internal: instrument-patch loader */
    sp += 8;
    *(u16*)(CS:0x00A0) = ax;                /* state: result code */

skip_program:
    CALL near 0x001459;                     /* OPL2 register-flush helper */
end:
    POP si; POP di; POP ds; POP bp;
    RETF;
}
```

**Inferred role: program one OPL2 melodic-channel operator** with
instrument patch parameters. The four constants `{0x11, 0x12, 0x18,
0x20}` are valid OPL2 operator indices for the channel layout
(operators are paired into channels 0-8 via the OPL2's modulator/
carrier model). The state writes at `CS:0x0F82`, `CS:0x009D`,
`CS:0x0F88`, `CS:0x00A0` are driver-internal scratch slots
tracking "last channel programmed", "current register", "result".

### Entry 1 at file `0x001C35` — register-write dispatcher

```c
/* Far-call ABI: 1 arg at [bp+0x06] */
void asound_register_write(u16 reg) {
    PUSH bp; MOV bp, sp;
    PUSH ds;
    DS = 0x03C0;

    bx = reg;                                /* [bp+0x06] */

    if (reg < 0x20) {
        if (reg >= 0x40) goto upper_bank;
        if (reg >= 0x20) goto mid_bank;
        if (reg > 0x08) goto exit;           /* invalid */
        /* low bank: reg 0x00..0x08 — mode/timer/percussion control */
        bx -= 0x00;
        bx <<= 1;                            /* table index */
        CALL CS:[bx + 0x????];               /* jump to specific writer */
    }
    if (reg >= 0x20) {
        /* mid bank: reg 0x20..0x3F — operator AM/VIB/EG/multi */
        ...similar dispatch...
    }
    if (reg >= 0x40) {
        /* upper bank: reg 0x40..0x?? — KSL/Total-Level + envelope */
        ...
    }
exit:
    POP ds; POP bp;
    RETF;
}
```

**Inferred role: universal "write to OPL2 register" dispatcher**.
The thresholds `{0x08, 0x20, 0x40}` partition the OPL2 register
space into:
- `0x00..0x08`: mode/timer/percussion control registers
- `0x09..0x1F`: invalid (skipped)
- `0x20..0x3F`: operator AM/VIB/EG/Multiple
- `0x40..0x55`: KSL/Total-Level
- `0x60..0x75`: Attack/Decay
- `0x80..0x95`: Sustain/Release
- `0xE0..0xF5`: Waveform-select
- `0xA0..0xA8, 0xB0..0xB8, 0xC0..0xC8`: Frequency / channel ctrl

### AdLib presence-detection at file `0x001467`

The bytes at `0x001467..0x0014BF` are textbook AdLib OPL2 chip
detection:

```c
/* Reset timers */
write_OPL(0x04, 0x60);          /* mask both timers */
write_OPL(0x04, 0x80);          /* unmask + reset IRQ flags */
status1 = IN AL, 0x388;          /* read status register */

/* Test pattern */
write_OPL(0x02, 0xFF);          /* set timer 1 max */
write_OPL(0x04, 0x21);          /* enable timer 1 IRQ */
busy_delay(200);                /* MOV cx, 0xC8 + IN DX loop */
status2 = IN AL, 0x388;          /* read status again */

/* Cleanup: disable timers */
write_OPL(0x04, 0x60);
write_OPL(0x04, 0x80);
status3 = IN AL, 0x388;

/* AdLib echoes specific bits in status — compare to detect */
if ((status1 & 0xE0) == 0 && (status2 & 0xE0) == 0xC0) {
    return ADLIB_PRESENT;
} else {
    return NOT_PRESENT;
}
```

This is the canonical AdLib detection sequence (mask → trigger →
read status → compare bit pattern). **Confirms ASOUND.COL is the
real AdLib FM driver and talks to OPL2 directly via port 0x388**.

The internal helper at `0x0015AF` (called many times from this
sequence) is the **`write_OPL(reg, val)` primitive** — that's the
function that does the timing-correct `OUT 0x388, reg; tiny_delay;
OUT 0x389, val; tiny_delay` sequence required by OPL2 hardware.

### Driver state map — partial

From the decoded entries, the driver maintains these state slots
in segment `0x03C0`:

| CS-relative offset | Role |
|------------------:|------|
| `+0x00A0` | result code from last instrument-patch load |
| `+0x009D` | cached operator index |
| `+0x0F70` | (read by entry 5 stub at file 0x001D16) — possibly status flag |
| `+0x0F82` | last channel/op programmed |
| `+0x0F88` | current OPL2 register being written |

### Remaining audio work

Plan 1000 task 791-840 status: **substantially advanced.**
- ✅ ABI structure decoded (11-entry table)
- ✅ Entries 0 and 1 hand-decoded (channel-programmer + register-
  write dispatcher)
- ✅ AdLib detection sequence confirmed
- ✅ OPL2-write primitive at file 0x0015AF identified
- ⏳ Per-instrument patch tables still buried in the driver's data
  segment (paragraph 0x03C0) — would require following the
  `LCALL 0x0000:0x0B65` internal call to extract the patch loader
- ⏳ Entries 2-4 partially decoded; entries 5+ are stubs

Per-instrument FM patch decoding remains a focused sprint, but the
**driver's calling ABI and OPL2 hardware-write paths are now
documented**.

---

## 27. AdLib patch loader located at file 0x000D65 (2026-05-08)

The `LCALL 0x0000:0x0B65` inside ASOUND.COL entry 0 was resolved
via the **MZ relocation table**: relocation entry 6 fixes the
segment word at file `0x001C25` (the segment field of that LCALL)
from placeholder `0x0000` to the actual driver code segment at
load time. Combined with offset `0x0B65`, the resolved target is:

```
file 0x000D65 = 0x000200 (header_size) + 0x000B65
```

Decoded entry-point bytes confirm this is a function:

```
0x000D65  55              PUSH bp
0x000D66  8B EC           MOV bp, sp
0x000D68  1E              PUSH ds
0x000D69  8C C8           MOV ax, cs       ; DS = CS (driver self-data)
0x000D6B  8E D8           MOV ds, ax
0x000D6D  C6 06 5D 00 00  MOV byte [DS:0x005D], 0
0x000D72  B8 04 00        MOV ax, 4
0x000D75  8B 5E 08        MOV bx, [bp+0x8]   ; arg2 = operation
0x000D78  83 FB 11        CMP bx, 0x11
0x000D7B  72 05           JB skip            ; arg2 < 17 → skip
0x000D7D  83 FB 22        CMP bx, 0x22
0x000D80  76 03           JBE in_range       ; arg2 in [17, 34]
0x000D82  E9 D9 00        JMP exit
in_range:
0x000D85  89 1E 48 00     MOV [DS:0x48], bx  ; state: arg2

;; gate on specific operator indices (same as entry 0)
0x000D89  83 FB 11        CMP bx, 0x11; JE 0x000D9D
0x000D8C  83 FB 12        CMP bx, 0x12; JE 0x000D9D
0x000D93  83 FB 18        CMP bx, 0x18; JE 0x000D9D
0x000D98  83 FB 20        CMP bx, 0x20; JNE 0x000DA3
;; if bx in {17, 18, 24, 32}:
0x000D9D  8B 46 06        MOV ax, [bp+0x6]   ; arg1
0x000DA0  A3 4A 00        MOV [DS:0x4A], ax  ; state: arg1

;; load arg3 / arg4 into state
0x000DA3  8B 46 0A        MOV ax, [bp+0xA]   ; arg3
0x000DA6  A2 4C 00        MOV [DS:0x4C], al
0x000DA9  8B 5E 0C        MOV bx, [bp+0xC]   ; arg4 (PATCH POINTER)
0x000DAC  88 1E 4D 00     MOV [DS:0x4D], bl

;; READ INSTRUMENT PATCH BYTES from [bx + 0x7B], [bx + 0x83], [bx + 0x8B]
0x000DB0  8A 87 7B 00     MOV al, [bx + 0x7B]   ; patch byte at +0x7B
0x000DB4  B4 00           MOV ah, 0
0x000DB6  A3 4E 00        MOV [DS:0x4E], ax
0x000DB9  8A 87 83 00     MOV al, [bx + 0x83]   ; patch byte at +0x83 (= +8 from prev)
0x000DBD  B4 00           MOV ah, 0
0x000DBF  A3 50 00        MOV [DS:0x50], ax
0x000DC2  8A 87 8B 00     MOV al, [bx + 0x8B]   ; patch byte at +0x8B (= +8)
0x000DC6  B4 00           MOV ah, 0
0x000DC8  A3 52 00        MOV [DS:0x52], ax
... (continues with more patch reads)
```

**Function role**: instrument-patch-loader. Takes 4 args:
- `arg1` [bp+6] — channel/voice index
- `arg2` [bp+8] — OPL2 register-bank index (validated to be in
  [17, 34], specifically operator indices for melodic mode)
- `arg3` [bp+0xA] — byte parameter
- `arg4` [bp+0xC] — pointer to a patch table

Reads the patch's bytes at offsets `+0x7B, +0x83, +0x8B, ...`
(stride 8) and stores into driver state slots `DS:0x48..0x52+`.
The 8-byte stride matches the **OPL2 11-byte instrument record**
layout — multiple instruments are packed into the patch table at
8-byte stride intervals (truncated patches?) or each entry is one
parameter across multiple instruments.

### MZ relocation-table mechanism (now documented)

For future audio-driver decoding, the rule is:
1. Every `LCALL 0x0000:0xNNNN` in the driver body has a
   relocation entry pointing to its segment word
2. At load time, the segment is patched to driver code segment
   (typically equal to `header_size_paragraphs`)
3. Resolved file offset = `header_size + 0xNNNN`

This applies to **all 14 relocations** in ASOUND.COL — meaning all
14 inter-procedural FAR calls within the driver are resolvable to
specific file offsets. Same pattern holds for GSOUND/PSOUND/RSOUND.

Plan 1000 task 791-840 status: **driver call-graph fully
resolvable** via MZ reloc table. Per-instrument patch decoding now
just requires walking the patch table at the address arg4 points
to (set by the caller before invoking entry 0).

---

## 28. Callgraph backward-propagation: 62 functions newly attributable (2026-05-08)

Wrote `tools/_tmp_callgraph_propagate.py` to walk all 1,122
`func_*_unknown.asm` files, extract their near-CALL targets, and
cross-reference against the 119 already-named functions + 25
BYTE_VERIFIED unknowns (= 144 named total).

Results, written to **[CALLGRAPH_PROPAGATED_NAMES.md](CALLGRAPH_PROPAGATED_NAMES.md)**:

| Category | Count |
|----------|------:|
| Single-call wrappers (1 call → 1 named target) | **28** |
| Multi-call attributions (calls ≥ 1 named target) | **34** |
| Leaf candidates (no near-CALLs, ≤ 30 bytes) | 186 |

### Single-call wrapper examples

| File | Calls | Inferred role |
|------|-------|---------------|
| 0x003460, 0x0034C4, 0x003536, 0x0035EC | `terrain_id_normalize_to_8` | Terrain-ID normalization wrappers (4 distinct calling contexts) |
| 0x005F82, 0x00603A | `is_xy_in_map_bounds` | Map-bounds check wrappers |
| 0x0067F0, 0x0073A8 | `unit_chain_resolve` | Unit-chain traversal wrappers |
| 0x0079A0, 0x007A20, 0x007A80, 0x007BCE | `unit_table_offset_calc` | UnitRecord offset-calc wrappers (4 contexts) |
| 0x008806, 0x008862, 0x00887C | `power_record_read_dword` | PowerRecord dword-read wrappers (3 contexts) |
| 0x008BD4 | `unit_field_test_at_3146` | Unit-field-test wrapper |
| 0x044FA4, 0x0458EC | `clamp_byte_at_far_ptr_to_5` | Byte-clamp wrappers |

### Multi-call subsystem clusters

The 34 multi-call functions cluster into recognizable subsystems:
- **Unit table** (calls `unit_chain_resolve` + `unit_field_lookup_simple`):
  funcs at 0x00684C, 0x006874, 0x006A10, 0x006A7C, 0x006B46, 0x006FD8,
  0x00701C, 0x0075A0 — likely *unit-list iterators* or *cargo
  inspectors*
- **Map / tile** (calls `is_xy_in_map_bounds` or `map_tile_read_layer_*`):
  funcs at 0x005E90, 0x005F48, 0x006018, 0x0060A0 — likely *tile
  visibility / accessor wrappers*
- **Overlay-dispatch**: 0x0029AC, 0x002D28 — call `dispatch_overlay_op_*`,
  likely *overlay-call wrappers*

### Status

Plan 1000 bulk-decompilation task: **62 functions newly
attributable from callgraph alone**. Each suggested name is a
hint based on outgoing-CALL pattern, not a byte-trace — apply in
Ghidra after spot-checking 2-3 entries per cluster. With these,
the named-function count rises from 144 → 206 (= +43%).

To reach the next tier (~300 named), the bulk-decompilation work
needs to expand to:
1. Apply the callgraph to ALL functions (not just unknown ones)
2. Run `apply_sigmatch.py` against a Borland C++ runtime signature
   library (would auto-tag ~50-100 runtime helpers like memcpy,
   strcmp, fopen, sprintf)
3. Iterate: each newly-named function enables more wrapper-name
   propagation in the next pass

---

## Summary table

| Task ref | Was | Now | Evidence |
|---------|-----|-----|----------|
| Plan 100 Task 092 | partial | partial-refined | Pure CHIEFKILL formula byte-verified; capital bonus is in @LOSTCITY2/Cibola handler, not in CHIEFKILL |
| Plan 300 Task 201 | blocked | partial | CYCLE.DAT loader byte-verified; payload semantics need consumer trace |
| Plan 300 Tasks 271-279 | 9 blocked | 9 documented | Renderer + sprite + text + memory citations for all 9 screens |
| Plan 1000 791-820 | blocked | resolved | `.COL` = MZ driver, `.BIN` = raw 8-bit PCM, no `.MSC` files exist |
| Plan 1000 831-840 | blocked | resolved-at-file-level | AdLib patches live inside `ASOUND.COL` driver |
| Plan 1000 1301-1310 | blocked | partial | CYCLE.DAT loader cited; payload deferred |

After this pass: **zero items remain in pure `[-]` blocked
state across the three plans**. Remaining work items are either
fully closed or marked `[~]` with a documented next-investigation
path.

---

## 21. RESOLVED — recruit_cost is NOT a stored field; it is the recruit-pool slot's +0x04 word, with a per-power ARTILLERY escalation (2026-05-31)

§14/§18/§19 left `recruit_cost` UNKNOWN-LOCATION after proving
PowerRecord `+0x30` has zero accesses. This pass traced the actual
RECRUIT action and display to the bytes and closes it.

### The recruit-pool slot record (DGROUP:0x978C, stride 6)

Written ONLY by `func_074688` (file `0x074688`, the "power_record_setter6";
the reseg "856-byte" banner is the trailing data-init block — the real
fn is `0x074688..0x0746BB`, `retf 6`). Per-slot 6-byte layout (indexed
`slot*6`, base displacement `-0x6874` = DS:0x978C):

| off | bytes | field | written @asm | read @asm |
|----:|-------|-------|--------------|-----------|
| +0x00 | 1 | (al) flag | `07469A mov [si-0x6874],al` | — |
| +0x01 | 1 | **colonist UNIT type** (@UNIT line idx) | `07469E mov [si-0x6873],cl` | `051E81`, `05BD4D`, `03510B`, `035252` |
| +0x02 | 1 | religious-unrest weight (clamped vs PR+0x11) | `0746A5 mov [si-0x6872],al` | `05BD7E`/`05BD84` |
| +0x03 | 1 | (bp+8) | `0746B3 mov [si-0x6871],al` | — |
| +0x04 | 2 | **RECRUIT COST (passage price), word** | `0746AC mov [si-0x6870],ax` | `051E52`, `035114`, `03524B` |

(The cost word value = the caller's BX at call time — `0746A9 mov ax,[bp-2]`
reads the saved-BX slot. The pool GENERATOR that computes the base and
calls `func_074688` lives in the RTLink-resident segment, not in the
overlay/resident disasm dumps — so the BASE numeric per type is the one
remaining blocked datum; the COST SOURCE and ESCALATION below are fully
byte-verified.)

### RECRUIT action handler — `func_051E2C` (file 0x051E2C, reached via thunk 0x1A1F:0x0500)

```asm
051E47  shl/add/shl                  ; bx = slot_idx*6
051E52  mov ax,[bx-0x6870]           ; ax = slot+0x04 = COST
051E5A  mov bx,[0x84fc]              ; active power
051E5E  cmp dx,[bx+0x2c] / 051E65 cmp ax,[bx+0x2a]  ; cost vs gold(32b) -> bail if unaffordable
051E81  mov al,[bx-0x6873]           ; al = slot+0x01 = colonist type
051E88  lcall 0x181f:0x95c           ; spawn the recruited unit at docks
051ED5  sub [bx+0x2a],ax / 051ED8 sbb [bx+0x2c],dx  ; DEDUCT cost from gold
```

### RECRUIT display+confirm — orphan handler at file 0x035105..0x0353DE (Europe overlay)

This is the in-Europe RECRUIT button path. It reads the same slot +0x04
cost and applies the escalation. **Byte-verified escalation:**

```asm
; --- display (RECRUIT button label) @ 0x035114-0x03512A ---
035114  mov cx,[bx-0x6870]           ; cx = slot+0x04 = base cost
03511B  cmp ax,0x0b                  ; if colonist type == 0x0B (Artillery)
035124  imul ax,[bx+0x1e],0x64       ;   ax = PowerRecord[+0x1e] * 100
035128  add cx,ax                    ;   displayed cost += count*100   (NO increment here)

; --- confirm (actually recruit) @ 0x035272-0x035282 ---
035272  cmp ax,0x0b                  ; if type == 0x0B (Artillery)
03527B  imul ax,[bx+0x1e],0x64       ;   ax = PowerRecord[+0x1e] * 100
03527F  add [bp-0x70],ax             ;   final cost += count*100
035282  inc [bx+0x1e]                ;   PowerRecord[+0x1e]++   <-- ESCALATION COUNTER
0352CA  sub [bx+0x2a],ax / sbb [bx+0x2c],dx  ; deduct final cost from gold
```

### Conclusions (replace §14/§18/§19 recruit_cost TBDs)

1. **`recruit_cost` is NOT stored in PowerRecord.** It is the recruit-pool
   slot field `+0x04` (DGROUP:0x978C+slot*6+4), generated when the slot is
   filled. The pavelbel "NATION +0x30" maps to the SAV serializer's layout,
   not the runtime DGROUP PowerRecord — runtime has no +0x30 access (§14 stands).
2. **The escalation is LINEAR and ARTILLERY-ONLY, not `base<<count`.**
   For colonist type 0x0B (@UNIT line 11 = **Artillery**):
   `cost = base + artillery_bought_count*100`, then `artillery_bought_count++`.
   Non-artillery recruits cost exactly the slot's stored base (no escalation).
   The earlier "doubles per purchase / `base<<count`" hypothesis is **REFUTED**.
3. **PowerRecord +0x1e = `artillery_bought_count` (u16).** Read×100 at
   `0x035124`/`0x03527B`, incremented at `0x035282`, zeroed at new-game init
   `0x03662F (mov [bx+0x1e],0)`. This is the pavelbel `artillery_bought_count`
   field (SAVE_FORMAT_CROSSREF.md line 76).
4. **@CLASS (DGROUP:0x9602, stride 4, loaded @0x074CB0) is NOT the recruit
   base price.** 0x9602 is written by the NAMES loader but has zero
   displacement reads anywhere; it feeds the resident TRAIN/Royal-University
   pricing and/or pool weighting via a far pointer, not the recruit slot cost.
5. Immigration timing uses PowerRecord `current_crosses` / `needed_crosses`
   (pavelbel) — the "next immigrant" accumulator/threshold, separate from the
   recruit GOLD cost above.

Status: COST SOURCE + ESCALATION = byte-verified. Remaining blocked datum:
the per-type BASE numeric inserted into slot+0x04 by the resident pool
generator (the `func_074688` caller lives in the un-dumped RTLink-resident
segment).
