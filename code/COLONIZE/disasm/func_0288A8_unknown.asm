; ============================================================================
; func_0288A8_unknown
; Region   : load_image
; Bytes    : file 0x0288A8..0x0288CD  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0288A8  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
0288AC  57                    PUSH   di                           ; UNKNOWN
0288AD  56                    PUSH   si                           ; UNKNOWN
0288AE  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
0288B3  EB 5C                 JMP    0x28911                      ; UNKNOWN
0288B5  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0288B8  8A 8F 83 88           MOV    cl, byte ptr [bx - 0x777d]   ; UNKNOWN
0288BC  80 E1 0F              AND    cl, 0xf                      ; UNKNOWN
0288BF  3A 0E 0C 3E           CMP    cl, byte ptr [0x3e0c]        ; UNKNOWN
0288C3  75 49                 JNE    0x2890e                      ; UNKNOWN
0288C5  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0288C9  2A FF                 SUB    bh, bh                       ; UNKNOWN
0288CB  8B CB                 MOV    cx, bx                       ; UNKNOWN
