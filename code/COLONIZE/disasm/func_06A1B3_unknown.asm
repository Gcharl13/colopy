; ============================================================================
; func_06A1B3_unknown
; Region   : load_image
; Bytes    : file 0x06A1B3..0x06A1F2  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06A1B3  55                    PUSH   bp                           ; UNKNOWN
06A1B4  8B EC                 MOV    bp, sp                       ; UNKNOWN
06A1B6  56                    PUSH   si                           ; UNKNOWN
06A1B7  57                    PUSH   di                           ; UNKNOWN
06A1B8  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
06A1BB  8B FE                 MOV    di, si                       ; UNKNOWN
06A1BD  81 EF 78 12           SUB    di, 0x1278                   ; UNKNOWN
06A1C1  81 C7 18 13           ADD    di, 0x1318                   ; UNKNOWN
06A1C5  F6 05 10              TEST   byte ptr [di], 0x10          ; UNKNOWN
06A1C8  74 24                 JE     0x6a1ee                      ; UNKNOWN
06A1CA  33 DB                 XOR    bx, bx                       ; UNKNOWN
06A1CC  8A 5C 07              MOV    bl, byte ptr [si + 7]        ; UNKNOWN
06A1CF  F6 87 47 12 40        TEST   byte ptr [bx + 0x1247], 0x40 ; UNKNOWN
06A1D4  74 18                 JE     0x6a1ee                      ; UNKNOWN
06A1D6  56                    PUSH   si                           ; UNKNOWN
06A1D7  0E                    PUSH   cs                           ; UNKNOWN
06A1D8  E8 8D EA              CALL   0x68c68                      ; UNKNOWN
06A1DB  58                    POP    ax                           ; UNKNOWN
06A1DC  83 7E 04 00           CMP    word ptr [bp + 4], 0         ; UNKNOWN
06A1E0  74 0C                 JE     0x6a1ee                      ; UNKNOWN
06A1E2  33 C0                 XOR    ax, ax                       ; UNKNOWN
06A1E4  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
06A1E6  89 45 02              MOV    word ptr [di + 2], ax        ; UNKNOWN
06A1E9  89 04                 MOV    word ptr [si], ax            ; UNKNOWN
06A1EB  89 44 04              MOV    word ptr [si + 4], ax        ; UNKNOWN
06A1EE  5F                    POP    di                           ; UNKNOWN
06A1EF  5E                    POP    si                           ; UNKNOWN
06A1F0  5D                    POP    bp                           ; UNKNOWN
06A1F1  C3                    RET                                 ; UNKNOWN
