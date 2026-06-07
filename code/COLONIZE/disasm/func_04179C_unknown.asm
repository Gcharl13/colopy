; ============================================================================
; func_04179C_unknown
; Region   : load_image
; Bytes    : file 0x04179C..0x0417CA  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04179C  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0417A0  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
0417A4  1B C0                 SBB    ax, ax                       ; UNKNOWN
0417A6  40                    INC    ax                           ; UNKNOWN
0417A7  83 7E 08 01           CMP    word ptr [bp + 8], 1         ; UNKNOWN
0417AB  1B DB                 SBB    bx, bx                       ; UNKNOWN
0417AD  F7 DB                 NEG    bx                           ; UNKNOWN
0417AF  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
0417B2  D1 E3                 SHL    bx, 1                        ; UNKNOWN
0417B4  09 87 58 C1           OR     word ptr [bx - 0x3ea8], ax   ; UNKNOWN
0417B8  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0417BC  74 1C                 JE     0x417da                      ; UNKNOWN
0417BE  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
0417C2  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0417C6  2A FF                 SUB    bh, bh                       ; UNKNOWN
0417C8  8B C3                 MOV    ax, bx                       ; UNKNOWN
