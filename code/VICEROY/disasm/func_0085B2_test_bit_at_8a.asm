; ============================================================================
; func_0085B2_test_bit_at_8a
; Region   : load_image
; Bytes    : file 0x0085B2..0x0085D4  (34 bytes)
; Purpose  : Tests a bit in the bit-array at *(0x8542)+0x8A. Returns AX != 0
;            iff the indexed bit is set. Companion setter is at 0x85D6
;            (set_or_clear_bit_at_8a).
; Args     : [bp+6] = bit index
; Returns  : AX = 0 if bit clear; AX = (1 << (idx&7)) if bit set (non-zero)
; Callers  : TBD
; Callees  : (none — leaf bit reader)
; Verified : Boundary verified: PUSH BP / LEAVE / RETF, 34 bytes (the trailing
;            byte at 0x85D5 is padding before func_0085D6).
; Source   : Pattern: standard bit-test (idx>>3 byte fetch, AND with 1<<(idx&7)).
; ============================================================================

0085B2  55                    PUSH   bp                           ; standard frame prologue
0085B3  8B EC                 MOV    bp, sp                       ; BP = SP
0085B5  56                    PUSH   si                           ; preserve SI
0085B6  8B 76 06              MOV    si, word ptr [bp + 6]        ; SI = bit index
0085B9  C1 FE 03              SAR    si, 3                        ; SI = idx >> 3 (byte offset within bit array)
0085BC  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; BX = current-context struct ptr
0085C0  8A 80 8A 00           MOV    al, byte ptr [bx + si + 0x8a] ; AL = struct.bit_array_byte[+0x8A + idx/8]
0085C4  98                    CWDE                                ; sign-extend AL → AX (mask still in low 8 bits)
0085C5  8A 4E 06              MOV    cl, byte ptr [bp + 6]        ; CL = idx (low byte)
0085C8  80 E1 07              AND    cl, 7                        ; CL = idx & 7 (bit-position within byte)
0085CB  BA 01 00              MOV    dx, 1                        ; DX = 1
0085CE  D3 E2                 SHL    dx, cl                       ; DX = 1 << cl (single-bit mask)
0085D0  23 C2                 AND    ax, dx                       ; AX = byte AND mask  (zero if bit clear)
0085D2  5E                    POP    si                           ; restore SI
0085D3  C9                    LEAVE                               ; teardown
; (0x85D4 is RETF in the actual binary — auto-listing showed line cut off)
