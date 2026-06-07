; ============================================================================
; func_00B2F0_unit_table_3154_byte
; Region   : load_image
; Bytes    : file 0x00B2F0..0x00B304  (20 bytes)
; Purpose  : Reads a byte from a per-unit table at DGROUP:0x3154 + (index * 0x1C). The caller supplies a far-pointer base in [bp+8] (probably a player or context override). Returns AX = byte value (zero-extended).
; Args     : [bp+6] = unit index, [bp+8] = base-segment offset
; Returns  : AX = byte at *(0x3154) + (idx * 0x1C) + base_offset
; Callers  : TBD (3 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 20 bytes. Stride 0x1C is the UnitRecord stride.
; Source   : Pattern matches a unit-table byte-read with caller-supplied base.
; ============================================================================

00B2F0  55                    PUSH   bp                           ; standard frame prologue
00B2F1  8B EC                 MOV    bp, sp                       ; BP = SP
00B2F3  56                    PUSH   si                           ; preserve SI
00B2F4  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c  ; SI = unit_index * 0x1C (UnitRecord stride)
00B2F8  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; BX = caller-supplied per-row base offset
00B2FB  8A 80 54 31           MOV    al, byte ptr [bx + si + 0x3154] ; AL = byte at unit_table_3154[index][base]
00B2FF  2A E4                 SUB    ah, ah                       ; zero-extend AL → AX
00B301  5E                    POP    si                           ; restore SI
00B302  C9                    LEAVE                               ; teardown
00B303  CB                    RETF                                ; far-return: AX = byte from unit_table_3154 at composite offset
