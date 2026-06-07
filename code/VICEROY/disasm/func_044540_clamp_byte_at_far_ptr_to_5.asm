; ============================================================================
; func_044540_clamp_byte_at_far_ptr_to_5
; Region   : overlay
; Bytes    : file 0x044540..0x044553  (19 bytes)
; Purpose  : Reads a byte at the far pointer in [bp+4..7]. If the byte equals 6, decrements it to 5; otherwise returns it unchanged. AX = clamped byte (zero-extended).
; Args     : [bp+4..7] = far pointer to byte
; Returns  : AX = byte (with value 6 mapped to 5)
; Callers  : TBD (3 distinct call sites)
; Callees  : (none — leaf)
; Verified : Boundary verified: 19 bytes ending in RETF.
; Source   : Pattern: LES BX, [bp+4]; read byte; CMP 6; conditional DEC.
; ============================================================================

044540  55                    PUSH   bp                           ; standard frame prologue
044541  8B EC                 MOV    bp, sp                       ; BP = SP
044543  C4 5E 04              LES    bx, ptr [bp + 4]             ; ES:BX = far pointer to byte
044546  26 8A 1F              MOV    bl, byte ptr es:[bx]         ; BL = byte at *(far pointer)
044549  2A FF                 SUB    bh, bh                       ; zero-extend BL → BX
04454B  83 FB 06              CMP    bx, 6                        ; byte == 6?
04454E  75 01                 JNE    0x44551                      ; if not, leave it alone
044550  4B                    DEC    bx                           ; if it was 6, decrement to 5 (clamp to 5 ceiling)
044551  8B C3                 MOV    ax, bx                       ; AX = clamped byte (zero-extended)
