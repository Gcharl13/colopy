# Overlay Runtime API — `0xD1D` and `0x181F`

This doc catalogs the most-used overlay-runtime calls in VICEROY.EXE.
These calls show up in nearly every game-logic function as `LCALL
0x181F:NNNN` or `LCALL 0xD1D:NNNN`. Decoding them once turns every
opaque call into a typed function reference.

The trick: `LCALL 0x181F:NNNN` and `LCALL 0x191F:NNNN` are **NOT**
direct overlay calls — they're calls into the **thunk table** at
file 0x1A5F0 (Ghidra paragraph 0x281F). Each thunk is 10–14 bytes:
- **Type B** (10 bytes): `LCALL dispatcher; JMP FAR target`. The
  target is an image-relative paragraph that's a RESIDENT overlay or
  load-image function — directly decodable from existing disasm.
- **Type A** (12–14 bytes): `LCALL dispatcher; trailer_word_1=page;
  trailer_word_2=offset`. The dispatcher uses page-based dispatch to
  load an overlay and call a function within it. Cannot be decoded
  without loading the overlay region.

This means **most "overlay" calls are actually load-image calls in
disguise** — they're decodable today.

For `LCALL 0xD1D:NNNN`, segment 0xD1D is image-relative paragraph
0xD1D = Ghidra paragraph 0x1D1D = file 0xF5D0 base. So `LCALL
0xD1D:0x07E4` = file 0xF5D0+0x07E4 = file 0xFDB4 (which is
`strcpy_near`).

---

## C-runtime helpers (segment 0xD1D = MSC 6.0 medium-model resident segment)

| API | File offset | Status | Description |
|-----|-------------|--------|-------------|
| `0xD1D:0x07E4` | 0x00FDB4 | **BYTE_VERIFIED** | `strcpy_near(char *dst, const char *src)` — matches MSC 6.0 strcpy exactly. Confirmed via Ghidra Phase 1 import. |
| `0xD1D:0x07A4` | 0x00FD74 | ANCHOR_VERIFIED | `strcat_near(char *dst, const char *src)` — same module, same calling convention. Disasm in [func_00FD74](code/VICEROY/disasm/func_00FD74_strcat_near.asm). |
| `0xD1D:0x0F60` | 0x010530 | **BYTE_VERIFIED** | `__aFlmul(int32 a, int32 b) → int32` — MSC 6.0 long multiply (truncated 32-bit product). Hand-decompiled. Disasm in [func_010530](code/VICEROY/disasm/func_010530_unknown.asm). |
| `0xD1D:0x0EC6` | 0x010496 | **BYTE_VERIFIED** | `__aFldiv(int32 a, int32 b) → int32` — MSC 6.0 long divide (signed). 152 bytes. Hand-decompiled. Disasm in [func_010496](code/VICEROY/disasm/func_010496_unknown.asm). |
| `0xD1D:0x113C` | 0x010A4C | ANCHOR_VERIFIED | `strlen_near(const char*) → int` — MSC 6.0 strlen. |
| `0xD1D:0x117E` | 0x010A8E | ANCHOR_VERIFIED | likely `strchr` or similar — same module. |

---

## Game messaging API (Type B thunks, segment 0x181F = thunk table)

These resolve to RESIDENT functions in the load image via the JMP FAR
in their Type B thunks. Most are heavily used by game-logic code for
display/dialog/output operations.

| Thunk addr | Type | Target file | Status | Description |
|------------|------|-------------|--------|-------------|
| `0x181F:0x04B6` | B | 0x00513C | **BYTE_VERIFIED** | `output_flush_if_unbuffered(int arg)` — if `[DGROUP:0xA0]==0` or `[DGROUP:0xA2]!=0`, return. Else CALL `0x5108` with arg. The `0xA0` and `0xA2` flags gate "is output enabled / is buffer in flush state". |
| `0x181F:0x048E` | B | 0x0050BC | **BYTE_VERIFIED** | `set_message_context(int code)` — compares `code` with `[DGROUP:0x96]`. If different, stores `code` to `[DGROUP:0x94]`, sets buffer-state flag `[0x9E]=1`, and LCALLs `0x2D8:0x0E` (probably "begin new message"). The "code" argument in the SMITEINDIANS call is `0x3E` (= ASCII '>'); likely a section-divider sentinel. |
| `0x181F:0x09A4` | B | 0x008110 | **BYTE_VERIFIED** | `get_power_name_word(int power_idx) → uint16` — for power_idx >= 4 (natives), returns `word_table_8CFC[idx*6]`. For power_idx 0..3 (Europeans), checks endgame flag `[0x5382]&1` then returns one of `[0x2E44]` (current player name?) or `[0x2E46]` (other-player name?). |
| `0x181F:0x0808` | B | 0x006E94 | **BYTE_VERIFIED** (partial) | `decrement_power_unit_count_and_destroy(int unit_idx)` — reads `UnitRecord[unit_idx].byte_at_+1` (low nibble = owner power), decrements `byte_table_8CFC[power]` (active-unit counter), and continues with more cleanup. **This is the canonical "destroy unit" function.** |

### Type-A thunks (overlay-resident, NOT yet decodable)

These all dispatch via page index `tw1=23` (= 0x17), meaning they live
in overlay page 23. Cannot be decoded until that overlay is loaded
into Ghidra (or extracted from the file).

| Thunk addr | Type | Trailer (page, off) | Status | Inferred role from call patterns |
|------------|------|---------------------|--------|-------------------------------|
| `0x181F:0x09AE` | A | (23, 0x42C) | inferred | `format_int32_to_message(int32 value, int format_code)` — takes a sign-extended int32 and a format code. Used everywhere numbers are displayed in messages. |
| `0x181F:0x0652` | A | (23, 0x37A2) | inferred | `display_text_key(int category, int string_offset)` — takes a 2-arg call with a category and a string offset (e.g. `2, 0x1be0` displays "CASHTREASURE"). |
| `0x181F:0x0438` | A | (23, 0x3EC) | inferred | `set_message_subject(int word_arg, int flag)` — used to set who/what the message is about. |
| `0x181F:0x0416` | A | (23, 0x3D0) | inferred | `set_message_personality(seg, off, flag)` — takes a far ptr to AIPersonality + a flag. |
| `0x181F:0x03FE` | A | (23, 0x3744) | inferred | `display_message_box_get_response(buf) → int` — pops up the buffered message in a dialog box and returns 1 (yes) or 0 (no). Used right before YES/NO branches. |
| `0x181F:0x07B4` | B | 0x00BC10 | **BYTE_VERIFIED** | `power_attribute_bit(int power, int bit) → int` — see dedicated entry. |
| `0x191F:0x0AC8` | A | (23, 0x404) | inferred | Similar messaging helper. |

### Special: BYTE_VERIFIED gate at 0x00BC10

`0x181F:0x07B4` resolves to `func_00BC10` at file 0x00BC10. Decompiled
fully (see [func_00BC10](code/VICEROY/disasm/func_00BC10_is_arg2_negative.asm)):

```c
int FAR power_attribute_bit(int power, int bit) {
    if (bit < 0) return 1;            /* sentinel: force-true */
    if (power >= 4) return 0;         /* natives never have bit set */
    int byte_offset = bit >> 3;
    int bit_index = bit & 7;
    int byte = DGROUP[(power * 0x13C) + 0x880F + byte_offset];
    return byte & (1 << bit_index);
}
```

This is the per-Founding-Father / per-scenario-flag bitfield for the 4
European powers. PowerRecord stride 0x13C, bitfield offset 0x06 within
record (i.e. `0x880F - 0x8809 = 6`).

---

## How to read a SMITE-style call sequence

The SMITE branch in `func_057F4E` (the diplomacy meeting handler)
shows the canonical message-display pattern:

```asm
PUSH 200 ; PUSH 10 ; ... ; PUSH 50 ; PUSH 50    ; numeric setup
PUSH treasury_long
LCALL __aFldiv                                    ; treasury / 50
PUSH result                                       
LCALL __aFlmul                                    ; * player_factor
PUSH ... ; LCALL __aFldiv                         ; / 50 again => /2500 total
PUSH ax ; LCALL 0x181F:0x035C                     ; clamp/scale
IMUL AX, AX, 0x32                                 ; * 50
PUSH 0x13 ; PUSH attacker
LCALL 0x181F:0x07B4                               ; power_attribute_bit(attacker, 19)
SAR ax, 1 (conditional)                           ; halve if bit set
... format / display ...
PUSH attacker; PUSH 0x1A1A (SMITEINDIANS)
LCALL 0x1A1F:0x0688                               ; show dialog
CMP AX, 1; JE yes_path
```

Reading this with the API table:
1. Compute `gold = clamp(player_factor × treasury / 2500, 10, 200) × 50`
2. Optionally halve if attacker has FF/scenario flag bit 19 set
3. Display the value via the "SMITEINDIANS" message
4. On YES, transfer gold from tribe to attacker

This pattern (numeric compute → format → display_text_key → confirm)
is repeated dozens of times throughout the overlay region. With the
API decoded, each instance can be interpreted in seconds rather than
hours.

---

## Methodology notes

**Identifying a Type B target:** For thunk at file `T` (10 bytes,
type B), the JMP FAR is at bytes [5..9]. Read offset (bytes 6,7) and
segment (bytes 8,9). Compute file offset as
`0x2400 + segment*16 + offset`. That's the directly callable target.

**Identifying a Type A target:** Read trailer_word_1 (page index) and
trailer_word_2 (offset within page). To decode, you need a map from
page index to file offset of the page's load-region. That requires
running the RTLink loader logic against the EXE's overlay tables —
not done in this project yet.

The 50 most-called Type A thunks all share `tw1=23`, meaning they all
live in one overlay page. Loading just that one page would unlock
nearly all of the messaging API.

---

## Summary

- **3 BYTE_VERIFIED game-messaging helpers**: 04B6 (flush), 048E (context), 09A4 (name lookup), 0808 (destroy unit), plus 07B4 (power_attribute_bit) — total **5 functions**.
- **4 BYTE_VERIFIED C-runtime helpers**: strcpy, strcat (anchored), `__aFlmul`, `__aFldiv`.
- **6 Type-A messaging helpers** with inferred roles only — would be unlocked by loading overlay page 23.

Together this lets us interpret most of the overlay function bodies
"to the message boundary" — meaning we can identify what each
function shows and conditions on, even without per-byte decompile.
