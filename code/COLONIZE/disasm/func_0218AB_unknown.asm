; ============================================================================
; func_0218AB_unknown
; Region   : load_image
; Bytes    : file 0x0218AB..0x021926  (123 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0218AB  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
0218AF  57                    PUSH   di                           ; UNKNOWN
0218B0  56                    PUSH   si                           ; UNKNOWN
0218B1  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
0218B6  6A 7E                 PUSH   0x7e                         ; UNKNOWN
0218B8  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0218BB  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0218BE  9A F6 13 65 5F        LCALL  0x5f65, 0x13f6               ; UNKNOWN
0218C3  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0218C6  8B F0                 MOV    si, ax                       ; UNKNOWN
0218C8  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
0218CB  6A 7E                 PUSH   0x7e                         ; UNKNOWN
0218CD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0218D0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0218D3  9A 1C 13 65 5F        LCALL  0x5f65, 0x131c               ; UNKNOWN
0218D8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0218DB  8B F8                 MOV    di, ax                       ; UNKNOWN
0218DD  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
0218E0  3B C6                 CMP    ax, si                       ; UNKNOWN
0218E2  75 04                 JNE    0x218e8                      ; UNKNOWN
0218E4  3B D1                 CMP    dx, cx                       ; UNKNOWN
0218E6  74 45                 JE     0x2192d                      ; UNKNOWN
0218E8  8E DA                 MOV    ds, dx                       ; UNKNOWN
0218EA  80 7D 01 46           CMP    byte ptr [di + 1], 0x46      ; UNKNOWN
0218EE  75 3D                 JNE    0x2192d                      ; UNKNOWN
0218F0  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
0218F3  26 8A 5C 01           MOV    bl, byte ptr es:[si + 1]     ; UNKNOWN
0218F7  2A FF                 SUB    bh, bh                       ; UNKNOWN
0218F9  36 F6 87 BB 13 04     TEST   byte ptr ss:[bx + 0x13bb], 4 ; UNKNOWN
0218FF  74 2C                 JE     0x2192d                      ; UNKNOWN
021901  B9 3B 01              MOV    cx, 0x13b                    ; UNKNOWN
021904  83 C7 03              ADD    di, 3                        ; UNKNOWN
021907  80 3D 30              CMP    byte ptr [di], 0x30          ; UNKNOWN
02190A  75 0C                 JNE    0x21918                      ; UNKNOWN
02190C  B9 54 01              MOV    cx, 0x154                    ; UNKNOWN
02190F  80 7D 02 30           CMP    byte ptr [di + 2], 0x30      ; UNKNOWN
021913  75 03                 JNE    0x21918                      ; UNKNOWN
021915  B9 5E 01              MOV    cx, 0x15e                    ; UNKNOWN
021918  26 80 7C FF 31        CMP    byte ptr es:[si - 1], 0x31   ; UNKNOWN
02191D  75 05                 JNE    0x21924                      ; UNKNOWN
02191F  83 C1 09              ADD    cx, 9                        ; UNKNOWN
021922  EB 2F                 JMP    0x21953                      ; UNKNOWN
021924  8B C3                 MOV    ax, bx                       ; UNKNOWN
