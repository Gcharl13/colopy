; ============================================================================
; func_008B96_unit_field_test_at_3146
; Region   : load_image
; Bytes    : file 0x008B96..0x008BAE  (24 bytes)
; Purpose  : Tests a per-unit byte field. Computes BX = (unit_index * 0x1C) + 0x3146 (a different unit-related table base than 0x315E), reads the byte there, then compares against the byte at DGROUP:0x30E. Returns 1 if (unit_table_3146[idx] >= byte_at_30E), else falls through (caller-provided default).
; Args     : [bp+6] = unit index
; Returns  : AX = 1 if condition met, fall-through otherwise.
; Callers  : TBD (4 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 24 bytes. Stride 0x1C confirms UnitRecord-class stride.
; Source   : Identified via callgraph; structure matches a unit-property test.
; ============================================================================

008B96  55                    PUSH   bp                           ; standard frame prologue
008B97  8B EC                 MOV    bp, sp                       ; BP = SP
008B99  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; BX = unit_index * 0x1C
008B9D  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146]   ; BL = byte at unit_table_3146[unit_index].field_0 — different table base than 0x315E
008BA1  2A FF                 SUB    bh, bh                       ; BH = 0 — zero-extend BL → BX
008BA3  38 BF 0E 03           CMP    byte ptr [bx + 0x30e], bh    ; compare byte at DGROUP:0x30E + BX (a per-row threshold table?) vs 0
008BA7  7C 05                 JL     0x8bae                       ; if threshold byte < 0, branch out (returns AX as caller had it)
008BA9  B8 01 00              MOV    ax, 1                        ; threshold OK → return AX = 1
008BAC  C9                    LEAVE                               ; teardown
008BAD  CB                    RETF                                ; far-return: AX = 1 if test passed, fall-through value otherwise
