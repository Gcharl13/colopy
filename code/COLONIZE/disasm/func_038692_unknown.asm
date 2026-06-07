; ============================================================================
; func_038692_unknown
; Region   : load_image
; Bytes    : file 0x038692..0x038835  (419 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

038692  C8 1C 00 00           ENTER  0x1c, 0                      ; UNKNOWN
038696  57                    PUSH   di                           ; UNKNOWN
038697  56                    PUSH   si                           ; UNKNOWN
038698  2B C0                 SUB    ax, ax                       ; UNKNOWN
03869A  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
03869D  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
0386A0  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0386A3  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
0386A6  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0386A9  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
0386AC  83 F8 04              CMP    ax, 4                        ; UNKNOWN
0386AF  7C 03                 JL     0x386b4                      ; UNKNOWN
0386B1  E9 90 02              JMP    0x38944                      ; UNKNOWN
0386B4  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
0386B7  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
0386BC  74 03                 JE     0x386c1                      ; UNKNOWN
0386BE  E9 83 02              JMP    0x38944                      ; UNKNOWN
0386C1  6A 13                 PUSH   0x13                         ; UNKNOWN
0386C3  50                    PUSH   ax                           ; UNKNOWN
0386C4  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
0386C9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0386CC  0B C0                 OR     ax, ax                       ; UNKNOWN
0386CE  74 03                 JE     0x386d3                      ; UNKNOWN
0386D0  E9 71 02              JMP    0x38944                      ; UNKNOWN
0386D3  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0386D6  2A E4                 SUB    ah, ah                       ; UNKNOWN
0386D8  40                    INC    ax                           ; UNKNOWN
0386D9  40                    INC    ax                           ; UNKNOWN
0386DA  F7 2E 06 3E           IMUL   word ptr [0x3e06]            ; UNKNOWN
0386DE  3D 20 03              CMP    ax, 0x320                    ; UNKNOWN
0386E1  7D 03                 JGE    0x386e6                      ; UNKNOWN
0386E3  E9 5E 02              JMP    0x38944                      ; UNKNOWN
0386E6  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
0386EB  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
0386EE  39 46 E6              CMP    word ptr [bp - 0x1a], ax     ; UNKNOWN
0386F1  75 03                 JNE    0x386f6                      ; UNKNOWN
0386F3  E9 85 00              JMP    0x3877b                      ; UNKNOWN
0386F6  39 06 4A 3E           CMP    word ptr [0x3e4a], ax        ; UNKNOWN
0386FA  74 7F                 JE     0x3877b                      ; UNKNOWN
0386FC  69 D8 3C 01           IMUL   bx, ax, 0x13c                ; UNKNOWN
038700  F6 87 AA 74 04        TEST   byte ptr [bx + 0x74aa], 4    ; UNKNOWN
038705  75 74                 JNE    0x3877b                      ; UNKNOWN
038707  50                    PUSH   ax                           ; UNKNOWN
038708  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
03870B  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
038710  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038713  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
038716  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
038719  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
03871E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038721  A8 40                 TEST   al, 0x40                     ; UNKNOWN
038723  74 03                 JE     0x38728                      ; UNKNOWN
038725  FF 46 E4              INC    word ptr [bp - 0x1c]         ; UNKNOWN
038728  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
03872B  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
03872E  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
038733  83 C4 04              ADD    sp, 4                        ; UNKNOWN
038736  24 60                 AND    al, 0x60                     ; UNKNOWN
038738  3C 20                 CMP    al, 0x20                     ; UNKNOWN
03873A  75 3F                 JNE    0x3877b                      ; UNKNOWN
03873C  FF 46 F2              INC    word ptr [bp - 0xe]          ; UNKNOWN
03873F  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
038744  8B 46 E6              MOV    ax, word ptr [bp - 0x1a]     ; UNKNOWN
038747  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
03874A  05 57 87              ADD    ax, 0x8757                   ; UNKNOWN
03874D  74 23                 JE     0x38772                      ; UNKNOWN
03874F  8B 46 EE              MOV    ax, word ptr [bp - 0x12]     ; UNKNOWN
038752  C1 E0 04              SHL    ax, 4                        ; UNKNOWN
038755  05 57 87              ADD    ax, 0x8757                   ; UNKNOWN
038758  74 18                 JE     0x38772                      ; UNKNOWN
03875A  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
03875D  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03875F  8B 87 C6 86           MOV    ax, word ptr [bx - 0x793a]   ; UNKNOWN
038763  01 46 F8              ADD    word ptr [bp - 8], ax        ; UNKNOWN
038766  8B 5E E6              MOV    bx, word ptr [bp - 0x1a]     ; UNKNOWN
038769  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03876B  8B 87 C6 86           MOV    ax, word ptr [bx - 0x793a]   ; UNKNOWN
03876F  01 46 F0              ADD    word ptr [bp - 0x10], ax     ; UNKNOWN
038772  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
038775  83 7E FC 0F           CMP    word ptr [bp - 4], 0xf       ; UNKNOWN
038779  7C C9                 JL     0x38744                      ; UNKNOWN
03877B  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
03877E  83 7E EE 04           CMP    word ptr [bp - 0x12], 4      ; UNKNOWN
038782  7D 03                 JGE    0x38787                      ; UNKNOWN
038784  E9 64 FF              JMP    0x386eb                      ; UNKNOWN
038787  83 7E E4 00           CMP    word ptr [bp - 0x1c], 0      ; UNKNOWN
03878B  75 03                 JNE    0x38790                      ; UNKNOWN
03878D  E9 B4 01              JMP    0x38944                      ; UNKNOWN
038790  83 7E F2 00           CMP    word ptr [bp - 0xe], 0       ; UNKNOWN
038794  74 03                 JE     0x38799                      ; UNKNOWN
038796  E9 AB 01              JMP    0x38944                      ; UNKNOWN
038799  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
03879C  39 46 F0              CMP    word ptr [bp - 0x10], ax     ; UNKNOWN
03879F  7D 03                 JGE    0x387a4                      ; UNKNOWN
0387A1  E9 A0 01              JMP    0x38944                      ; UNKNOWN
0387A4  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
0387A8  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
0387AD  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0387B0  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
0387B3  40                    INC    ax                           ; UNKNOWN
0387B4  40                    INC    ax                           ; UNKNOWN
0387B5  D1 E0                 SHL    ax, 1                        ; UNKNOWN
0387B7  2B 46 E4              SUB    ax, word ptr [bp - 0x1c]     ; UNKNOWN
0387BA  6B C0 14              IMUL   ax, ax, 0x14                 ; UNKNOWN
0387BD  50                    PUSH   ax                           ; UNKNOWN
0387BE  6A 00                 PUSH   0                            ; UNKNOWN
0387C0  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0387C5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0387C8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0387CB  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
0387CE  2A E4                 SUB    ah, ah                       ; UNKNOWN
0387D0  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
0387D3  7D 03                 JGE    0x387d8                      ; UNKNOWN
0387D5  E9 6C 01              JMP    0x38944                      ; UNKNOWN
0387D8  6A 03                 PUSH   3                            ; UNKNOWN
0387DA  6A 00                 PUSH   0                            ; UNKNOWN
0387DC  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0387E1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0387E4  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
0387E7  39 46 E6              CMP    word ptr [bp - 0x1a], ax     ; UNKNOWN
0387EA  74 EC                 JE     0x387d8                      ; UNKNOWN
0387EC  50                    PUSH   ax                           ; UNKNOWN
0387ED  FF 76 E6              PUSH   word ptr [bp - 0x1a]         ; UNKNOWN
0387F0  9A 06 00 49 22        LCALL  0x2249, 6                    ; UNKNOWN
0387F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0387F8  A8 40                 TEST   al, 0x40                     ; UNKNOWN
0387FA  74 DC                 JE     0x387d8                      ; UNKNOWN
0387FC  69 5E EE 3C 01        IMUL   bx, word ptr [bp - 0x12], 0x13c ; UNKNOWN
038801  F6 87 AA 74 04        TEST   byte ptr [bx + 0x74aa], 4    ; UNKNOWN
038806  75 D0                 JNE    0x387d8                      ; UNKNOWN
038808  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
03880D  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
038810  2A E4                 SUB    ah, ah                       ; UNKNOWN
038812  40                    INC    ax                           ; UNKNOWN
038813  6B C0 64              IMUL   ax, ax, 0x64                 ; UNKNOWN
038816  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
038819  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
03881C  8A 8F D6 86           MOV    cl, byte ptr [bx - 0x792a]   ; UNKNOWN
038820  8B 5E E6              MOV    bx, word ptr [bp - 0x1a]     ; UNKNOWN
038823  38 8F D6 86           CMP    byte ptr [bx - 0x792a], cl   ; UNKNOWN
038827  73 1B                 JAE    0x38844                      ; UNKNOWN
038829  2A ED                 SUB    ch, ch                       ; UNKNOWN
03882B  8A 97 D6 86           MOV    dl, byte ptr [bx - 0x792a]   ; UNKNOWN
03882F  2A F6                 SUB    dh, dh                       ; UNKNOWN
038831  2B CA                 SUB    cx, dx                       ; UNKNOWN
038833  8B D1                 MOV    dx, cx                       ; UNKNOWN
