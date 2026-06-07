; ============================================================================
; func_065784_unknown
; Region   : load_image
; Bytes    : file 0x065784..0x065808  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065784  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
065788  06                    PUSH   es                           ; UNKNOWN
065789  57                    PUSH   di                           ; UNKNOWN
06578A  56                    PUSH   si                           ; UNKNOWN
06578B  83 3E 94 CE 00        CMP    word ptr [0xce94], 0         ; UNKNOWN
065790  74 59                 JE     0x657eb                      ; UNKNOWN
065792  80 3E A6 CE 00        CMP    byte ptr [0xcea6], 0         ; UNKNOWN
065797  75 52                 JNE    0x657eb                      ; UNKNOWN
065799  BE 10 00              MOV    si, 0x10                     ; UNKNOWN
06579C  2B 36 9E 0C           SUB    si, word ptr [0xc9e]         ; UNKNOWN
0657A0  BF 10 00              MOV    di, 0x10                     ; UNKNOWN
0657A3  2B 3E A0 0C           SUB    di, word ptr [0xca0]         ; UNKNOWN
0657A7  8B 0E 8E 0C           MOV    cx, word ptr [0xc8e]         ; UNKNOWN
0657AB  3B 0E AE 0C           CMP    cx, word ptr [0xcae]         ; UNKNOWN
0657AF  7F 3A                 JG     0x657eb                      ; UNKNOWN
0657B1  8B D1                 MOV    dx, cx                       ; UNKNOWN
0657B3  03 D6                 ADD    dx, si                       ; UNKNOWN
0657B5  4A                    DEC    dx                           ; UNKNOWN
0657B6  3B 16 AC 0C           CMP    dx, word ptr [0xcac]         ; UNKNOWN
0657BA  7C 2F                 JL     0x657eb                      ; UNKNOWN
0657BC  A1 90 0C              MOV    ax, word ptr [0xc90]         ; UNKNOWN
0657BF  3B 06 B2 0C           CMP    ax, word ptr [0xcb2]         ; UNKNOWN
0657C3  7F 26                 JG     0x657eb                      ; UNKNOWN
0657C5  8B D8                 MOV    bx, ax                       ; UNKNOWN
0657C7  03 DF                 ADD    bx, di                       ; UNKNOWN
0657C9  4B                    DEC    bx                           ; UNKNOWN
0657CA  3B 1E B0 0C           CMP    bx, word ptr [0xcb0]         ; UNKNOWN
0657CE  7C 1B                 JL     0x657eb                      ; UNKNOWN
0657D0  2B 06 B0 0C           SUB    ax, word ptr [0xcb0]         ; UNKNOWN
0657D4  7C 1B                 JL     0x657f1                      ; UNKNOWN
0657D6  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0657D9  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
0657DE  2B 1E B2 0C           SUB    bx, word ptr [0xcb2]         ; UNKNOWN
0657E2  7F 20                 JG     0x65804                      ; UNKNOWN
0657E4  8B C7                 MOV    ax, di                       ; UNKNOWN
0657E6  88 46 FA              MOV    byte ptr [bp - 6], al        ; UNKNOWN
0657E9  EB 20                 JMP    0x6580b                      ; UNKNOWN
0657EB  B8 00 00              MOV    ax, 0                        ; UNKNOWN
0657EE  E9 C8 00              JMP    0x658b9                      ; UNKNOWN
0657F1  8B D8                 MOV    bx, ax                       ; UNKNOWN
0657F3  F7 D8                 NEG    ax                           ; UNKNOWN
0657F5  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0657F8  03 DF                 ADD    bx, di                       ; UNKNOWN
0657FA  88 5E FA              MOV    byte ptr [bp - 6], bl        ; UNKNOWN
0657FD  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
065802  EB 07                 JMP    0x6580b                      ; UNKNOWN
065804  8B C7                 MOV    ax, di                       ; UNKNOWN
065806  2B C3                 SUB    ax, bx                       ; UNKNOWN
