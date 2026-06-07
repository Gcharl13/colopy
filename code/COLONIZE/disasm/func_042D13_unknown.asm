; ============================================================================
; func_042D13_unknown
; Region   : load_image
; Bytes    : file 0x042D13..0x042DB2  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042D13  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
042D17  83 7E 06 04           CMP    word ptr [bp + 6], 4         ; UNKNOWN
042D1B  7D 17                 JGE    0x42d34                      ; UNKNOWN
042D1D  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34  ; UNKNOWN
042D21  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
042D26  75 0C                 JNE    0x42d34                      ; UNKNOWN
042D28  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
042D2B  2A E4                 SUB    ah, ah                       ; UNKNOWN
042D2D  83 C0 03              ADD    ax, 3                        ; UNKNOWN
042D30  D1 E0                 SHL    ax, 1                        ; UNKNOWN
042D32  EB 0A                 JMP    0x42d3e                      ; UNKNOWN
042D34  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
042D37  2A E4                 SUB    ah, ah                       ; UNKNOWN
042D39  83 E8 0E              SUB    ax, 0xe                      ; UNKNOWN
042D3C  F7 D8                 NEG    ax                           ; UNKNOWN
042D3E  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
042D41  C1 66 FC 03           SHL    word ptr [bp - 4], 3         ; UNKNOWN
042D45  81 3E 02 3E 40 06     CMP    word ptr [0x3e02], 0x640     ; UNKNOWN
042D4B  7C 08                 JL     0x42d55                      ; UNKNOWN
042D4D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
042D50  D1 F8                 SAR    ax, 1                        ; UNKNOWN
042D52  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
042D55  81 3E 02 3E 72 06     CMP    word ptr [0x3e02], 0x672     ; UNKNOWN
042D5B  7C 08                 JL     0x42d65                      ; UNKNOWN
042D5D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
042D60  D1 F8                 SAR    ax, 1                        ; UNKNOWN
042D62  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
042D65  81 3E 02 3E A4 06     CMP    word ptr [0x3e02], 0x6a4     ; UNKNOWN
042D6B  7C 08                 JL     0x42d75                      ; UNKNOWN
042D6D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
042D70  D1 F8                 SAR    ax, 1                        ; UNKNOWN
042D72  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
042D75  81 3E 02 3E D6 06     CMP    word ptr [0x3e02], 0x6d6     ; UNKNOWN
042D7B  7C 08                 JL     0x42d85                      ; UNKNOWN
042D7D  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
042D80  D1 F8                 SAR    ax, 1                        ; UNKNOWN
042D82  01 46 FC              ADD    word ptr [bp - 4], ax        ; UNKNOWN
042D85  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; UNKNOWN
042D8A  8A 87 BE 74           MOV    al, byte ptr [bx + 0x74be]   ; UNKNOWN
042D8E  8B C8                 MOV    cx, ax                       ; UNKNOWN
042D90  2A E4                 SUB    ah, ah                       ; UNKNOWN
042D92  40                    INC    ax                           ; UNKNOWN
042D93  F7 6E FC              IMUL   word ptr [bp - 4]            ; UNKNOWN
042D96  40                    INC    ax                           ; UNKNOWN
042D97  0A C9                 OR     cl, cl                       ; UNKNOWN
042D99  75 02                 JNE    0x42d9d                      ; UNKNOWN
042D9B  D1 F8                 SAR    ax, 1                        ; UNKNOWN
042D9D  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
042DA2  74 0C                 JE     0x42db0                      ; UNKNOWN
042DA4  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
042DA7  2A E4                 SUB    ah, ah                       ; UNKNOWN
042DA9  69 C0 DC 05           IMUL   ax, ax, 0x5dc                ; UNKNOWN
042DAD  05 D0 07              ADD    ax, 0x7d0                    ; UNKNOWN
042DB0  C9                    LEAVE                               ; UNKNOWN
042DB1  CB                    RETF                                ; UNKNOWN
