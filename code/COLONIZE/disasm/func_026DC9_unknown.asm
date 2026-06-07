; ============================================================================
; func_026DC9_unknown
; Region   : load_image
; Bytes    : file 0x026DC9..0x026E98  (207 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026DC9  C8 5E 00 00           ENTER  0x5e, 0                      ; UNKNOWN
026DCD  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
026DD2  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026DD5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026DD8  E8 36 F0              CALL   0x25e11                      ; UNKNOWN
026DDB  0B C0                 OR     ax, ax                       ; UNKNOWN
026DDD  74 03                 JE     0x26de2                      ; UNKNOWN
026DDF  E9 B1 00              JMP    0x26e93                      ; UNKNOWN
026DE2  A3 0A 0A              MOV    word ptr [0xa0a], ax         ; UNKNOWN
026DE5  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
026DE8  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
026DEC  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
026DEF  26 8B 47 12           MOV    ax, word ptr es:[bx + 0x12]  ; UNKNOWN
026DF3  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
026DF6  26 8B 47 14           MOV    ax, word ptr es:[bx + 0x14]  ; UNKNOWN
026DFA  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
026DFD  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16]  ; UNKNOWN
026E01  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
026E04  83 3E 04 0A 00        CMP    word ptr [0xa04], 0          ; UNKNOWN
026E09  7C 09                 JL     0x26e14                      ; UNKNOWN
026E0B  06                    PUSH   es                           ; UNKNOWN
026E0C  53                    PUSH   bx                           ; UNKNOWN
026E0D  0E                    PUSH   cs                           ; UNKNOWN
026E0E  E8 1D F6              CALL   0x2642e                      ; UNKNOWN
026E11  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026E14  FF 76 A2              PUSH   word ptr [bp - 0x5e]         ; UNKNOWN
026E17  FF 76 A4              PUSH   word ptr [bp - 0x5c]         ; UNKNOWN
026E1A  FF 76 A6              PUSH   word ptr [bp - 0x5a]         ; UNKNOWN
026E1D  FF 76 A8              PUSH   word ptr [bp - 0x58]         ; UNKNOWN
026E20  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E23  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E26  0E                    PUSH   cs                           ; UNKNOWN
026E27  E8 8D FD              CALL   0x26bb7                      ; UNKNOWN
026E2A  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
026E2D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E30  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E33  B8 01 00              MOV    ax, 1                        ; UNKNOWN
026E36  99                    CDQ                                 ; UNKNOWN
026E37  8B D8                 MOV    bx, ax                       ; UNKNOWN
026E39  E8 25 FB              CALL   0x26961                      ; UNKNOWN
026E3C  C7 06 0A 0A 00 00     MOV    word ptr [0xa0a], 0          ; UNKNOWN
026E42  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E45  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E48  B8 01 00              MOV    ax, 1                        ; UNKNOWN
026E4B  E8 97 EC              CALL   0x25ae5                      ; UNKNOWN
026E4E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E51  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E54  2B C0                 SUB    ax, ax                       ; UNKNOWN
026E56  E8 68 F6              CALL   0x264c1                      ; UNKNOWN
026E59  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E5C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E5F  2B C0                 SUB    ax, ax                       ; UNKNOWN
026E61  E8 F4 F8              CALL   0x26758                      ; UNKNOWN
026E64  83 3E 04 0A 00        CMP    word ptr [0xa04], 0          ; UNKNOWN
026E69  7D 0D                 JGE    0x26e78                      ; UNKNOWN
026E6B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E6E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E71  0E                    PUSH   cs                           ; UNKNOWN
026E72  E8 B9 F5              CALL   0x2642e                      ; UNKNOWN
026E75  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026E78  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E7B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E7E  0E                    PUSH   cs                           ; UNKNOWN
026E7F  E8 3C F5              CALL   0x263be                      ; UNKNOWN
026E82  83 C4 04              ADD    sp, 4                        ; UNKNOWN
026E85  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
026E88  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
026E8B  E8 F5 F4              CALL   0x26383                      ; UNKNOWN
026E8E  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0      ; UNKNOWN
026E93  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
026E96  C9                    LEAVE                               ; UNKNOWN
026E97  CB                    RETF                                ; UNKNOWN
