; ============================================================================
; func_00913C_set_field_at_40_or_unit_byte
; Region   : load_image
; Bytes    : file 0x00913C..0x009184  (72 bytes)
;            NOTE: the auto-boundary detector split this into two pieces at
;                  0x9166 (a JLE-target past an inline LEAVE/RETF). The full
;                  function covers 0x913C..0x9183 inclusive. Same dual-tail
;                  pattern as func_0085D6.
; Purpose  : Dual-mode setter for the +0x40 byte-array. If `index < struct.count`,
;            writes [bp+8] into *(0x8542)[+0x40 + index]. Otherwise treats the
;            (index - count) overflow as an offset into a UnitRecord-style
;            external table: calls helper 0x8BD4 to convert the offset, then
;            writes the byte into UnitRecord[idx].byte[+0x315B-base] (DGROUP
;            offset 0x315B + converted_idx * 0x1C). The caller's value at
;            [bp+8] is also preprocessed with a 0x17→0x15 remap (terrain or
;            unit-type renumbering).
; Args     : [bp+6] = index (struct-local OR overflow into Unit table),
;            [bp+8] = value (subject to 0x17→0x15 remap before storing)
; Returns  : (no explicit return — byte stored in struct or UnitRecord)
; Callers  : TBD
; Callees  : helper at 0x8BD4 (near-call) — converts overflow index
; Verified : Two LEAVE/RETF tails: 0x9163 (in-struct branch) and 0x9182
;            (UnitRecord branch). UnitRecord stride 0x1C confirms cross-table.
; Source   : Pattern: bound-check + fall-through to overflow-via-helper +
;            UnitRecord-stride write.
; ============================================================================

00913C  C8 02 00 00           ENTER  2, 0                         ; allocate 2-byte local frame (unused)
009140  56                    PUSH   si                           ; preserve SI
009141  83 7E 08 17           CMP    word ptr [bp + 8], 0x17      ; value == 23?
009145  75 05                 JNE    0x914c                       ; if not 23, skip remap
009147  C7 46 08 15 00        MOV    word ptr [bp + 8], 0x15      ; remap 23 → 21 (likely terrain/unit-type renumber)
00914C  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
009150  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.count
009153  98                    CWDE                                ; AL → AX
009154  3B 46 06              CMP    ax, word ptr [bp + 6]        ; count vs index
009157  7E 0D                 JLE    0x9166                       ; if count <= index, fall through to overflow branch
009159  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = value (already remapped if was 23)
00915C  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = index
00915F  88 40 40              MOV    byte ptr [bx + si + 0x40], al ; struct.byte[+0x40 + index] = value
009162  5E                    POP    si                           ; restore SI
009163  C9                    LEAVE                               ; teardown
009164  CB                    RETF                                ; far-return (in-struct branch)
009165  90                    NOP                                 ; padding (auto-detector mistakenly split here)
; ----- overflow branch: index >= count → write to UnitRecord -----
009166  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; AL = struct.count (recompute — BX still valid)
009169  98                    CWDE                                ; AL → AX
00916A  2B 46 06              SUB    ax, word ptr [bp + 6]        ; AX = count - index (negative)
00916D  F7 D8                 NEG    ax                           ; AX = index - count (positive overflow)
00916F  50                    PUSH   ax                           ; push overflow-index for converter
009170  0E                    PUSH   cs                           ; push CS for near-CALL
009171  E8 60 FA              CALL   0x8bd4                       ; near-call helper: convert overflow → UnitRecord index
009174  83 C4 02              ADD    sp, 2                        ; pop arg
009177  6B D8 1C              IMUL   bx, ax, 0x1c                 ; BX = converted_idx * 0x1C (UnitRecord stride 28 bytes)
00917A  8A 46 08              MOV    al, byte ptr [bp + 8]        ; AL = value
00917D  88 87 5B 31           MOV    byte ptr [bx + 0x315b], al   ; UnitRecord[converted_idx].byte[+0x315B-base] = value
009181  5E                    POP    si                           ; restore SI
009182  C9                    LEAVE                               ; teardown
009183  CB                    RETF                                ; far-return (overflow branch)
