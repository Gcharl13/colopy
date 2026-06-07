; ============================================================================
; func_0153EA_unknown
; Region   : load_image
; Bytes    : file 0x0153EA..0x015422  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0153EA  55                    PUSH   bp                           ; UNKNOWN
0153EB  8B EC                 MOV    bp, sp                       ; UNKNOWN
0153ED  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0153F0  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0153F3  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
0153F8  8B E5                 MOV    sp, bp                       ; UNKNOWN
0153FA  0B C0                 OR     ax, ax                       ; UNKNOWN
0153FC  75 2A                 JNE    0x15428                      ; UNKNOWN
0153FE  39 46 0C              CMP    word ptr [bp + 0xc], ax      ; UNKNOWN
015401  7C 1F                 JL     0x15422                      ; UNKNOWN
015403  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
015406  2A 46 08              SUB    al, byte ptr [bp + 8]        ; UNKNOWN
015409  3C 14                 CMP    al, 0x14                     ; UNKNOWN
01540B  75 15                 JNE    0x15422                      ; UNKNOWN
01540D  8B 5E 0C              MOV    bx, word ptr [bp + 0xc]      ; UNKNOWN
015410  D1 E3                 SHL    bx, 1                        ; UNKNOWN
015412  FF B7 E1 37           PUSH   word ptr [bx + 0x37e1]       ; UNKNOWN
015416  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
015419  9A ED 00 13 24        LCALL  0x2413, 0xed                 ; UNKNOWN
01541E  8B E5                 MOV    sp, bp                       ; UNKNOWN
015420  C9                    LEAVE                               ; UNKNOWN
015421  CB                    RETF                                ; UNKNOWN
