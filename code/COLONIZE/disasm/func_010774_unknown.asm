; ============================================================================
; func_010774_unknown
; Region   : load_image
; Bytes    : file 0x010774..0x0107ED  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010774  C8 A2 00 00           ENTER  0xa2, 0                      ; UNKNOWN
010778  56                    PUSH   si                           ; UNKNOWN
010779  2B C0                 SUB    ax, ax                       ; UNKNOWN
01077B  89 86 7E FF           MOV    word ptr [bp - 0x82], ax     ; UNKNOWN
01077F  89 46 96              MOV    word ptr [bp - 0x6a], ax     ; UNKNOWN
010782  89 46 86              MOV    word ptr [bp - 0x7a], ax     ; UNKNOWN
010785  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
010788  B9 E7 FF              MOV    cx, 0xffe7                   ; UNKNOWN
01078B  99                    CDQ                                 ; UNKNOWN
01078C  F7 F9                 IDIV   cx                           ; UNKNOWN
01078E  03 06 06 3E           ADD    ax, word ptr [0x3e06]        ; UNKNOWN
010792  89 46 84              MOV    word ptr [bp - 0x7c], ax     ; UNKNOWN
010795  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
010799  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
01079D  2A E4                 SUB    ah, ah                       ; UNKNOWN
01079F  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
0107A2  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0107A6  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
0107A9  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
0107AD  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
0107B0  89 86 6C FF           MOV    word ptr [bp - 0x94], ax     ; UNKNOWN
0107B4  83 E8 04              SUB    ax, 4                        ; UNKNOWN
0107B7  89 46 BE              MOV    word ptr [bp - 0x42], ax     ; UNKNOWN
0107BA  50                    PUSH   ax                           ; UNKNOWN
0107BB  9A 06 00 BA 33        LCALL  0x33ba, 6                    ; UNKNOWN
0107C0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0107C3  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
0107C6  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
0107C9  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
0107CE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0107D1  83 E0 0A              AND    ax, 0xa                      ; UNKNOWN
0107D4  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
0107D7  FF 76 9C              PUSH   word ptr [bp - 0x64]         ; UNKNOWN
0107DA  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
0107DD  9A 04 01 C9 33        LCALL  0x33c9, 0x104                ; UNKNOWN
0107E2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0107E5  83 E0 40              AND    ax, 0x40                     ; UNKNOWN
0107E8  89 46 C2              MOV    word ptr [bp - 0x3e], ax     ; UNKNOWN
0107EB  FF                    DB     0xFF                         ; UNKNOWN (raw)
0107EC  B6                    DB     0xB6                         ; UNKNOWN (raw)
