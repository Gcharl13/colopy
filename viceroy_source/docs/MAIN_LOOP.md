# Main loop & opening-message triggers — VICEROY.EXE (1994 DOS Colonization)

**Built 2026-05-30.** This document closes two long-standing seams that
`docs/OPENING_SEQUENCE.md` flagged as open and **supersedes** those two
gaps (do not re-open them there):

1. **Gap A** — the resident-→-overlay `_main()` top-level game-loop
   dispatcher had *no decoded function row*.
2. **Gap B** — the `@VICEROY` / `@LANDHO` message **call sites** (the
   triggers that decide to show them) were *catalogued but not byte-traced*;
   only the renderers were known.

All offsets below are **file offsets** into
`raw/COLONIZE/VICEROY.EXE` (load-image base = file `0x2400`; e_cs:e_ip =
`110D:071D` → entry at file `0x13BED`). DGROUP string handles map to the
image by **`file = handle + 0x1D9A0`** (verified, see §C).

Method: static disassembly of `code/VICEROY/disasm/func_*.asm` +
`disasm_overlay_reseg/page_*.asm`, raw-byte decode of the EXE with capstone,
the RTLink thunk tables (`overlay_thunks.json`, `typeA_thunk_targets.json`),
and the GAME.TXT key strings. Every load-bearing instruction is byte-cited.

---

## A. The `_main()` / top game-loop dispatcher

### Call chain from boot (byte-traced through `cstart`)

```
DOS loader
 └─ entry_point        file 0x13BED   LCALL 110D:0727 + LJMP 0D1D:0150   [ported, byte-equal]
      ├─ system_init   file 0x13BF7   EMS/XMS/heap; INT 21h AH=4Ah shrink  [PARTIAL]
      └─ dos_version_check_stub file 0x0F720  DOS≥2.0 gate                 [ported]
           └─ cstart   file 0x0F72D   C runtime startup                    [ported, byte-verified]
                · relocate stack, zero BSS  (@0xF72D..0xF7AE)
                · precompiled-init chain    (lcall 0xD1D:0x1420 / 0x128E / 0x248  @0xF7B9/0xF7BE/0xF7C5)
                · push envp,argv,argc       ([0x27D3],[0x27D1],[0x27CF]  @0xF7CC..0xF7D4)
                · CALL _main                lcall 0x181F:0x0000           @0xF7D8   ◄── the _main call
                · pass rc to exit chain      (push ax; call 0xF8DD  @0xF7DD)
```

**The `_main` call is byte-pinned: `cstart` @ file `0xF7D8` =
`9A 00 00 1F 18` → `lcall 0x181F:0x0000`.** That far-call targets the
**first RTLink thunk** (thunk record at file `0x1A5F0`).

### What thunk `0x181F:0x0000` (file 0x1A5F0) does

Raw thunk bytes @0x1A5F0 = `9A AB 0D 0D 11 | EA 5A 02 00 00 | 19 00 E7 00`:

```
0x1A5F0  lcall 0x110D:0x0DAB     ; → RTLink type-A loader entry (= func_01427B, rtlink_loader_A)
0x1A5F5  ljmp  0x0000:0x025A     ; far-jump; SEGMENT 0x0000 is a placeholder patched at load time
0x1A5FA  dw 0x0019               ; trailer word 1 = target PAGE id  (0x19)
0x1A5FC  dw 0x00E7               ; trailer word 2 = page metadata
```

This is a standard RTLink Plus overlay trampoline (matches
`docs/ARCHITECTURE.md` §"RTLink overlay system" and
`FUNCTIONS_INVENTORY.md`). The loader (`func_01427B` → shared
`func_014293` → `func_0164A2 rtlink_segment_lookup`) reads the trailer,
pages the target segment in from disk if not resident, **patches the
`ljmp 0x0000:…` segment word to the now-resident runtime segment**, then
jumps. The anchor analysis (`code/VICEROY/anchor_map.md` §"Signal 4")
records: *"segment 0x0000 (661 thunks) — main code segment, contains
`_main`."*

### Status: STRUCTURALLY PINNED, exact entry offset = TBD (loader-computed)

- **What is byte-certain:** `_main` is entered from `cstart` @0xF7D8 via
  the RTLink overlay loader, into the **main code segment (overlay record
  0)**. Record 0 is the page whose file image begins at **0x020670**
  (`overlay_pages.json` rec 0; code starts 0x020EE0), re-segmented as
  `disasm_overlay_reseg/page_01.asm`. This page is the resident game-engine
  core: it contains the per-turn **event/report dispatcher** `func_0235D6`
  (file 0x0235D6, 2374 bytes — see §A2) and ~34 engine functions.

- **What is NOT cleanly pinnable by static analysis:** the *exact*
  function-entry file offset of `_main`. The thunk's `ljmp` segment is
  `0x0000` (a load-time placeholder) and the trailer page id (`0x19`)
  resolves, under the static `typeA_thunk_targets.json` formula
  (`target = page.code_offset + jmpf_off`), to file **0x07004A** — but that
  lands *inside* a render routine in page 0x19 (a screen-draw page), which
  is **inconsistent** with the documented "segment 0x0000 = main code"
  fact. The discrepancy is the known RTLink seam: the loader's
  page-directory state (which runtime paragraph each page is mapped to) is
  not recoverable from the file image alone, so the LJMP target cannot be
  resolved to one offset without **emulating** `func_0164A2`'s directory
  walk. This matches the project's own open item
  (`anchor_map.md` "Where to go next" #1: "Decode the segment-id ↔
  overlay-file-offset mapping … unlocks all 1,020 thunk targets").

  ⇒ **cite-or-TBD verdict: the `_main` *call* is byte-verified; its
  resident-overlay *entry offset* is TBD pending a loader emulation /
  page-directory decode.** It is NOT one of `func_0759E8` / `func_0755CC` /
  `func_07431E` (those are the menu and new-game functions `_main`
  eventually drives, in page 0x1A — see OPENING_SEQUENCE.md).

### A2. The phase dispatch `_main` drives (byte-traced anchors)

`_main`'s body is the title→per-turn state machine sketched in
`ARCHITECTURE.md` §"Game loop". Its **per-turn event/report phase** IS
decoded — it is the resident dispatcher **`func_0235D6`** (file `0x0235D6`,
in the main code segment / page 0x01):

```
func_0235D6  ENTER 0x1E              @0x0235D6
  ax = [bp+6]                        ; phase / event / screen id argument
  switch (ax) over ids 0..0x1A:      @0x0235E5 cmp ax,0x1A ; … dec/je ladder
     id 1 → CALL 0x24BB4   (near, in-page handler)   @0x235FE
     id 2 → CALL 0x24BE6                              @0x23606
     id 3 → CALL 0x24B28                              @0x2360E
     id 4 → CALL 0x24B37                              @0x23616
     id 0x1A → lcall 0x191F:0x32E  (page-06 handler)  @0x2361E
     …  (27-case switch; many cases reach page-06 European-event handlers
         through lcall 0x191F:0x3xx — see docs/EVENT_DISPATCH.md)
```

Flags this phase reads (verified in `docs/EVENT_DISPATCH.md`):
`[0x5381] bit 0x80` (multiplayer), `[0x5382]` (event-pending bits),
`[0x53D0]` (rebel sentiment %, independence gate vs 50), `[0x539C]` (unit
count). The end-of-turn enqueue that *feeds* this switch is in page 0x06
and remains mis-segmented (open, per EVENT_DISPATCH.md).

The main code segment (page 0x01) also holds the **per-unit first-time
advisor** `func_020F50` (file 0x020F50, 1714 B): iterates units of the
human power (`[0x5392]`, UnitRecord base `0x3144` stride `0x1C`), and on
first occurrence pushes GAME.TXT tip handles (0x8B3, 0x8BD, …) via
`lcall 0x181F:0x652`, setting one-shot flags `[0x5386] bit 0x10`,
`[0x5387] bit 0x40`, `[0x5380] bit 1`. (Adjacent to the loop, not the loop
itself.)

---

## B. `@VICEROY` / `@VICEROY2` investiture trigger

### Emitter: `func_075594` (file 0x075594, 55 bytes) — byte-verified

```
func_075594  ENTER 0x14              @0x075594
  0x075598  push 0x2334              ; ◄── @VICEROY key string  (DS handle 0x2334)
  0x07559B  lea ax,[bp-0x14] ; push ax
  0x07559F  lcall 0x0D1D:0x07E4      ; message-format primitive (key → framebuffer text)
  0x0755A7  cmp word [0x5398], 3     ; ◄── human power index == 3 ?  (Netherlands)
  0x0755AC  jne 0x755BD
  0x0755AE    push 2 ; push ss ; lea ax,[bp-0x14] ; push ax
  0x0755B5    lcall 0x181F:0x0182    ; Stadtholder/@VICEROY2 variant selector
  0x0755BD  lea ax,[bp-0x14] ; push ax ; push 1 ; push 1 ; push cs
  0x0755C6  CALL 0x076370            ; render the modal panel
  0x0755CA  retf
```

- **Key:** the `@VICEROY` string (`raw/COLONIZE/GAME.TXT` @file 0xB3B; the
  in-EXE key string `VICEROY\0` is at file 0x1FCD4 → handle
  `0x1FCD4 − 0x1D9A0 = 0x2334`). The `push 0x2334` at file **0x075598** is
  the **sole** push of this handle in the entire image (byte-searched), so
  `func_075594` is the unique `@VICEROY` emitter.
- **Condition / variant:** `cmp [0x5398],3` @0x0755A7. `[0x5398]` is the
  RNG-picked **human power index** (set in `func_07431E` new-game-init —
  `random_int(0,3)` clamped ≤3, per OPENING_SEQUENCE.md byte-check).
  **Power 3 = Netherlands**, which takes the extra `lcall 0x181F:0x0182`
  branch to substitute the **`@VICEROY2`** ("The Stadtholder") text for the
  default `@VICEROY` ("The King of %COUNTRY"). GAME.TXT confirms the two
  keys are identical except this title line (@VICEROY @file 0xB3B,
  @VICEROY2 @file 0xC63).
- **Attribution:** `docs/enrich/setup_misc_score.json` →
  `VICEROY.func = func_075594 (show simple message dialog)`,
  `inputs = "…Netherlands shows the 'Stadtholder' variant @VICEROY2…"`.

### Trigger / caller — coronation at new-game start

`func_075594` has **no near-call, far-call, or thunk reference** in the
static image (byte-searched all encodings of its address and a thunk-table
scan): it is reached through a **runtime-populated screen/dialog dispatch
pointer**, the same indirect mechanism used for the other one-shot opening
panels. Per `OPENING_SEQUENCE.md` (Stage 6) the investiture fires from the
**tail of `func_0755CC` (new-game init, file 0x0755CC)** — after the
per-power starting-unit seeding and before the framebuffer blit / draw
game-screen-0x25 / return-to-player. `func_0755CC` is the new-game init that
runs once at "Year of Our Lord 1492".

⇒ **Trigger condition (plain):** *fired once at game start / coronation,
from the new-game-init hand-off (`func_0755CC`), selecting `@VICEROY2`
(Stadtholder) iff the human power index `[0x5398] == 3` (Netherlands), else
`@VICEROY` (King of %COUNTRY).* Emitter byte-verified; the indirect
dispatch into `func_075594` is the same loader-pointer seam as Gap A
(call-pointer not a static immediate).

---

## C. `@LANDHO` "name this new land" trigger — fully byte-traced

### Emitter: the post-landfall hook at file 0x020EFE (page 0x01)

`@LANDHO` (GAME.TXT @file 0xEA7: *"Land Ho! What shall we call this new
land, Your Excellency?"*, `@default=America`). In-EXE key string
`LANDHO\0` @file 0x1E242 → handle `0x1E242 − 0x1D9A0 = 0x8A2`.

A small hook function in the **main code segment** (page 0x01, file
**0x020EFE**, ending `retf` @0x020F4E) emits it:

```
0x020EFE  push 1 ; lcall 0x181F:0x0524     ; pre-setup
0x020F08  mov word [0x1F5E], 0
0x020F0E  push 0x17                          ; arg
0x020F10  imul dx,[0x5394],0x34 ; add dx,0x5426   ; dx = &name_buf[human_power*0x34]
0x020F19  lea bx,[0x87C]                     ; bx = "GAME" resource handle 0x87C
0x020F1D  lea ax,[0x8A2]                     ; ◄── @LANDHO key string (handle 0x8A2)
0x020F21  lcall 0x191F:0x0120               ; ◄── generic name-input dialog (→ file 0x6F64C)
0x020F26  push 0x9820 ; imul…[0x5394]*0x34+0x5426 ; lcall 0x0D1D:0x07E4  ; store named result
0x020F3A  test byte [0x5382],0x80           ; multiplayer?
0x020F3F  je 0x020F4E
0x020F41    push 0 ; push 0x8A9 ; lcall 0x181F:0x0652   ; MP-path message variant
0x020F4E  retf
```

The dialog handler `lcall 0x191F:0x0120` resolves (Type-A thunk @file
0x1B710, page 0x17) to **file 0x06F64C** — a modal **name-input** routine
(`ENTER 6`; takes the key seg:off in `cx:dx`; sets dialog-active flag
`[0x2008]`). Cross-confirmation: that exact handler is the *generic* "Name:"
dialog, reused by **6** call sites, each LEA-ing a different GAME.TXT key
right before the call:

| caller (file) | key LEA'd | GAME.TXT prompt |
|---|---|---|
| **0x020F21** | **0x8A2 = @LANDHO** | "Land Ho! … name this new land" |
| 0x02BB4A | 0xD30 = @RENAMECOLONY | "rename this colony" |
| 0x040CE6 | 0x146F = @COLONY | "name this colony" |
| 0x060F89 / 0x06124D | 0x1D53/0x1D8C = @TRADENAME | trade-route name |
| 0x07440D | 0x2192 = @LEADERNAME | leader name (new-game) |

So file 0x020EFE is unambiguously the **@LANDHO** emitter.

### Trigger: ship landfall — `func_03FDDE`, move-result case 6

The @LANDHO emitter (file 0x020EFE) has **exactly one caller** in the image
(byte-searched as `lcall 0x181F:0x0F6C`, the Type-A thunk @file 0x1B55C
that targets it): **file 0x03FFCF, inside `func_03FDDE`** — the ship
move/arrival handler (`src/combat/naval.c`, BYTE_VERIFIED;
file 0x03FDDE..0x040002).

`func_03FDDE` dispatches on a move-result selector `[0x9E4E]` via a 9-entry
jump table (`jmp cs:[bx+0x60A]` @0x03FF44; table @file 0x03FF4A; code-seg
base file 0x03F940). **Case 6** (file 0x03FEF6) is the landfall path; its
tail (file 0x03FF81..0x03FFEF) does:

```
0x03FF81  imul bx,[0x5394],0x34 ; test byte [bx+0x543e],0x80   ; one-shot GUARD
0x03FF8B  jne done                                              ; already named this power? → skip
          ; 3×3 neighbourhood flood-scan around the landing tile:
0x03FFAE  push sy ; push sx ; lcall 0x181F:0x768   ; probe tile (land/new-world?)
0x03FFBC  or ax,ax ; jne next                       ; nothing → keep scanning
          ; first hit → FIRE:
0x03FFC0  imul bx,[0x5394],0x34
0x03FFC5  or byte [bx+0x543e], 0x80                  ; ◄── SET per-power "land named" flag (one-shot)
0x03FFCA  mov word [bp-0x10], 1                       ; done = 1
0x03FFCF  lcall 0x181F:0x0F6C                         ; ◄── CALL @LANDHO emitter (file 0x020EFE)
0x03FFD4  jmp …
```

⇒ **Trigger condition (plain):** *when a ship makes landfall on the New
World, `func_03FDDE` reaches move-result case 6; if the human power's
"land-named" flag `[power*0x34 + 0x543E] bit 0x80` is not yet set, it
flood-scans the 3×3 around the landing tile, and on the first land tile
found it sets that flag (one-shot) and calls the `@LANDHO` emitter (file
0x020EFE), prompting "name this new land."* Fully byte-traced end-to-end.

This is the **opening** "name the New World" prompt — distinct from the
in-game **`@LANDFALL`** "shall we make landfall" yes/no (handle 0x13EA, also
inside `func_03FDDE`, cases 2/3). `OPENING_SEQUENCE.md` had marked the
@LANDHO emitter "NOT TRACED"; this resolves it.

---

## D. Byte citations (rechecked against the EXE image, 2026-05-30)

| # | File offset | Bytes | Decode | Meaning |
|---|---|---|---|---|
| 1 | 0x0F7D8 | `9A 00 00 1F 18` | `lcall 0x181F:0x0000` | `cstart` → `_main` (overlay thunk @0x1A5F0) |
| 2 | 0x1A5F0 | `9A AB 0D 0D 11 EA 5A 02 00 00 19 00 E7 00` | `lcall 0x110D:0xDAB` + `ljmp 0:0x25A` + trailer page 0x19 | RTLink trampoline to main code segment |
| 3 | 0x075598 | `68 34 23` | `push 0x2334` | @VICEROY key (unique push site) |
| 4 | 0x0755A7 | `83 3E 98 53 03` | `cmp word [0x5398],3` | Netherlands → @VICEROY2 variant gate |
| 5 | 0x020F1D | `8D 06 A2 08` | `lea ax,[0x8A2]` | @LANDHO key into the emitter |
| 6 | 0x020F21 | `9A 20 01 1F 19` | `lcall 0x191F:0x0120` | → name-input dialog (file 0x6F64C) |
| 7 | 0x03FFCF | `9A 6C 0F 1F 18` | `lcall 0x181F:0x0F6C` | landfall → call @LANDHO emitter (the sole caller) |
| 8 | 0x03FFC5 | `80 8F 3E 54 80` | `or byte [bx+0x543E],0x80` | one-shot per-power "land named" flag |

Handle→file base verification: `VICEROY\0`@0x1FCD4, `LANDHO\0`@0x1E242,
`LANDFALL\0`@0x1ED8A; each `file − handle == 0x1D9A0` (handles 0x2334 /
0x8A2 / 0x13EA respectively). ✔

---

## E. Status summary

| Item | Status |
|---|---|
| `_main` **call** from cstart (@0xF7D8 → thunk 0x1A5F0) | **BYTE-VERIFIED** |
| `_main` resident-overlay segment (main code seg / overlay record 0 / page 0x01) | **IDENTIFIED** |
| `_main` exact function-entry offset | **TBD** — loader-computed LJMP; needs page-directory emulation (same seam as `anchor_map.md` open item #1) |
| Per-turn phase dispatcher `func_0235D6` (27-case event/report switch) | **DECODED** (control flow) |
| `@VICEROY`/`@VICEROY2` emitter `func_075594` + variant gate `[0x5398]==3` | **BYTE-VERIFIED** |
| `@VICEROY` trigger/caller (coronation, `func_0755CC` tail, indirect dispatch) | attributed (enrich + OPENING_SEQUENCE); dispatch pointer = loader seam |
| `@LANDHO` emitter (file 0x020EFE) | **BYTE-VERIFIED** |
| `@LANDHO` trigger: `func_03FDDE` landfall case 6 + flag `[0x543E + power*0x34] bit 0x80` | **BYTE-VERIFIED end-to-end** |

**Supersedes** in `docs/OPENING_SEQUENCE.md`: gap #1 (`_main` not pinned →
now structurally pinned, exact-entry TBD with reason) and gap #3
(`@VICEROY`/`@LANDHO` emitter call sites → @LANDHO fully traced; @VICEROY
emitter+condition byte-verified, caller attributed). Gaps #2 (`system_init`
regions 2–4) and #4 (`func_065D26` world-gen tail) are untouched.
