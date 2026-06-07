; ============================================================================
; func_009692_unknown
; Region   : load_image
; Bytes    : file 0x009692..0x0096D5  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009692  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
009696  2B C0                 SUB    ax, ax                       ; UNKNOWN
009698  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
00969B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00969E  EB 28                 JMP    0x96c8                       ; UNKNOWN
0096A0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0096A3  0E                    PUSH   cs                           ; UNKNOWN
0096A4  E8 5B FA              CALL   0x9102                       ; UNKNOWN
0096A7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0096AA  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0096AD  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0096B0  0E                    PUSH   cs                           ; UNKNOWN
0096B1  E8 14 FA              CALL   0x90c8                       ; UNKNOWN
0096B4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0096B7  83 7E F8 13           CMP    word ptr [bp - 8], 0x13      ; CMP
0096BB  7D 08                 JGE    0x96c5                       ; UNKNOWN
0096BD  39 46 F8              CMP    word ptr [bp - 8], ax        ; UNKNOWN
0096C0  75 03                 JNE    0x96c5                       ; UNKNOWN
0096C2  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
0096C5  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
0096C8  8B 1E 42 85           MOV    bx, word ptr [0x8542]        ; UNKNOWN
0096CC  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; MOV
0096CF  98                    CWDE                                ; UNKNOWN
0096D0  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
0096D3  7F CB                 JG     0x96a0                       ; UNKNOWN
