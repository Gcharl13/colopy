; ============================================================================
; func_023376_unknown
; Region   : load_image
; Bytes    : file 0x023376..0x02349B  (293 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023376  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
02337A  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
02337F  75 0A                 JNE    0x2338b                      ; UNKNOWN
023381  83 3E E2 09 00        CMP    word ptr [0x9e2], 0          ; UNKNOWN
023386  75 03                 JNE    0x2338b                      ; UNKNOWN
023388  E9 BB 01              JMP    0x23546                      ; UNKNOWN
02338B  6A 08                 PUSH   8                            ; UNKNOWN
02338D  9A 0E 00 04 5D        LCALL  0x5d04, 0xe                  ; UNKNOWN
023392  83 C4 02              ADD    sp, 2                        ; UNKNOWN
023395  0B C0                 OR     ax, ax                       ; UNKNOWN
023397  74 03                 JE     0x2339c                      ; UNKNOWN
023399  E9 AA 01              JMP    0x23546                      ; UNKNOWN
02339C  A3 E2 09              MOV    word ptr [0x9e2], ax         ; UNKNOWN
02339F  39 06 D8 09           CMP    word ptr [0x9d8], ax         ; UNKNOWN
0233A3  7C 0F                 JL     0x233b4                      ; UNKNOWN
0233A5  A1 D8 09              MOV    ax, word ptr [0x9d8]         ; UNKNOWN
0233A8  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0233AB  C7 06 D8 09 FF FF     MOV    word ptr [0x9d8], 0xffff     ; UNKNOWN
0233B1  E9 87 01              JMP    0x2353b                      ; UNKNOWN
0233B4  FF 36 88 3E           PUSH   word ptr [0x3e88]            ; UNKNOWN
0233B8  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
0233BD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0233C0  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
0233C5  75 26                 JNE    0x233ed                      ; UNKNOWN
0233C7  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
0233CC  C7 46 FC 0C 00        MOV    word ptr [bp - 4], 0xc       ; UNKNOWN
0233D1  6A 08                 PUSH   8                            ; UNKNOWN
0233D3  6A 00                 PUSH   0                            ; UNKNOWN
0233D5  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0233DA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0233DD  0B C0                 OR     ax, ax                       ; UNKNOWN
0233DF  75 30                 JNE    0x23411                      ; UNKNOWN
0233E1  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd       ; UNKNOWN
0233E6  C7 46 FC 0B 00        MOV    word ptr [bp - 4], 0xb       ; UNKNOWN
0233EB  EB 24                 JMP    0x23411                      ; UNKNOWN
0233ED  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd       ; UNKNOWN
0233F2  C7 46 FC 06 00        MOV    word ptr [bp - 4], 6         ; UNKNOWN
0233F7  6A 04                 PUSH   4                            ; UNKNOWN
0233F9  6A 00                 PUSH   0                            ; UNKNOWN
0233FB  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
023400  83 C4 04              ADD    sp, 4                        ; UNKNOWN
023403  0B C0                 OR     ax, ax                       ; UNKNOWN
023405  75 0A                 JNE    0x23411                      ; UNKNOWN
023407  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02340C  C7 46 FC 0C 00        MOV    word ptr [bp - 4], 0xc       ; UNKNOWN
023411  80 3E A0 09 00        CMP    byte ptr [0x9a0], 0          ; UNKNOWN
023416  74 0A                 JE     0x23422                      ; UNKNOWN
023418  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02341D  C7 46 FC 18 00        MOV    word ptr [bp - 4], 0x18      ; UNKNOWN
023422  A1 DE 09              MOV    ax, word ptr [0x9de]         ; UNKNOWN
023425  EB 5F                 JMP    0x23486                      ; UNKNOWN
023427  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02342C  C7 46 FC 07 00        MOV    word ptr [bp - 4], 7         ; UNKNOWN
023431  EB 6F                 JMP    0x234a2                      ; UNKNOWN
023433  C7 46 FE 08 00        MOV    word ptr [bp - 2], 8         ; UNKNOWN
023438  C7 46 FC 05 00        MOV    word ptr [bp - 4], 5         ; UNKNOWN
02343D  EB 63                 JMP    0x234a2                      ; UNKNOWN
02343F  C7 46 FE 0D 00        MOV    word ptr [bp - 2], 0xd       ; UNKNOWN
023444  C7 46 FC 06 00        MOV    word ptr [bp - 4], 6         ; UNKNOWN
023449  EB 57                 JMP    0x234a2                      ; UNKNOWN
02344B  C7 46 FE 13 00        MOV    word ptr [bp - 2], 0x13      ; UNKNOWN
023450  C7 46 FC 04 00        MOV    word ptr [bp - 4], 4         ; UNKNOWN
023455  EB 4B                 JMP    0x234a2                      ; UNKNOWN
023457  83 3E DA 09 33        CMP    word ptr [0x9da], 0x33       ; UNKNOWN
02345C  74 44                 JE     0x234a2                      ; UNKNOWN
02345E  C7 46 FE 17 00        MOV    word ptr [bp - 2], 0x17      ; UNKNOWN
023463  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
023468  EB 38                 JMP    0x234a2                      ; UNKNOWN
02346A  83 3E DA 09 35        CMP    word ptr [0x9da], 0x35       ; UNKNOWN
02346F  74 31                 JE     0x234a2                      ; UNKNOWN
023471  C7 46 FE 19 00        MOV    word ptr [bp - 2], 0x19      ; UNKNOWN
023476  EB EB                 JMP    0x23463                      ; UNKNOWN
023478  83 3E DA 09 36        CMP    word ptr [0x9da], 0x36       ; UNKNOWN
02347D  74 23                 JE     0x234a2                      ; UNKNOWN
02347F  C7 46 FE 1A 00        MOV    word ptr [bp - 2], 0x1a      ; UNKNOWN
023484  EB DD                 JMP    0x23463                      ; UNKNOWN
023486  48                    DEC    ax                           ; UNKNOWN
023487  83 F8 06              CMP    ax, 6                        ; UNKNOWN
02348A  77 16                 JA     0x234a2                      ; UNKNOWN
02348C  D1 E0                 SHL    ax, 1                        ; UNKNOWN
02348E  93                    XCHG   bx, ax                       ; UNKNOWN
02348F  2E FF A7 14 02        JMP    word ptr cs:[bx + 0x214]     ; UNKNOWN
023494  A7                    CMPSW  word ptr [si], word ptr es:[di] ; UNKNOWN
023495  01 B3 01 BF           ADD    word ptr [bp + di - 0x40ff], si ; UNKNOWN
023499  01 CB                 ADD    bx, cx                       ; UNKNOWN
