; ============================================================================
; func_04075F_unknown
; Region   : load_image
; Bytes    : file 0x04075F..0x0407D1  (114 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04075F  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
040763  57                    PUSH   di                           ; UNKNOWN
040764  56                    PUSH   si                           ; UNKNOWN
040765  2B FF                 SUB    di, di                       ; UNKNOWN
040767  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
04076A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04076D  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
040772  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040775  0B C0                 OR     ax, ax                       ; UNKNOWN
040777  74 52                 JE     0x407cb                      ; UNKNOWN
040779  2B F6                 SUB    si, si                       ; UNKNOWN
04077B  83 FE 08              CMP    si, 8                        ; UNKNOWN
04077E  7D 4B                 JGE    0x407cb                      ; UNKNOWN
040780  8A 84 2F 09           MOV    al, byte ptr [si + 0x92f]    ; UNKNOWN
040784  98                    CWDE                                ; UNKNOWN
040785  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
040788  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04078B  50                    PUSH   ax                           ; UNKNOWN
04078C  8A 84 26 09           MOV    al, byte ptr [si + 0x926]    ; UNKNOWN
040790  98                    CWDE                                ; UNKNOWN
040791  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
040794  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
040797  50                    PUSH   ax                           ; UNKNOWN
040798  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
04079D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0407A0  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
0407A3  75 05                 JNE    0x407aa                      ; UNKNOWN
0407A5  BF 01 00              MOV    di, 1                        ; UNKNOWN
0407A8  EB 02                 JMP    0x407ac                      ; UNKNOWN
0407AA  2B FF                 SUB    di, di                       ; UNKNOWN
0407AC  46                    INC    si                           ; UNKNOWN
0407AD  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0407B0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0407B3  9A 47 03 C9 33        LCALL  0x33c9, 0x347                ; UNKNOWN
0407B8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0407BB  3B 46 0A              CMP    ax, word ptr [bp + 0xa]      ; UNKNOWN
0407BE  75 05                 JNE    0x407c5                      ; UNKNOWN
0407C0  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0407C3  EB 02                 JMP    0x407c7                      ; UNKNOWN
0407C5  2B C0                 SUB    ax, ax                       ; UNKNOWN
0407C7  0B F8                 OR     di, ax                       ; UNKNOWN
0407C9  74 B0                 JE     0x4077b                      ; UNKNOWN
0407CB  8B C7                 MOV    ax, di                       ; UNKNOWN
0407CD  5E                    POP    si                           ; UNKNOWN
0407CE  5F                    POP    di                           ; UNKNOWN
0407CF  C9                    LEAVE                               ; UNKNOWN
0407D0  CB                    RETF                                ; UNKNOWN
