; ============================================================================
; func_028337_unknown
; Region   : load_image
; Bytes    : file 0x028337..0x02841E  (231 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028337  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02833B  56                    PUSH   si                           ; UNKNOWN
02833C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
028341  81 7E 06 E7 03        CMP    word ptr [bp + 6], 0x3e7     ; UNKNOWN
028346  74 1A                 JE     0x28362                      ; UNKNOWN
028348  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02834B  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
028350  83 C4 02              ADD    sp, 2                        ; UNKNOWN
028353  A0 0C 3E              MOV    al, byte ptr [0x3e0c]        ; UNKNOWN
028356  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02835A  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
02835D  74 03                 JE     0x28362                      ; UNKNOWN
02835F  E9 FF 00              JMP    0x28461                      ; UNKNOWN
028362  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
028366  7D 03                 JGE    0x2836b                      ; UNKNOWN
028368  E9 F1 00              JMP    0x2845c                      ; UNKNOWN
02836B  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
02836F  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
028374  73 03                 JAE    0x28379                      ; UNKNOWN
028376  E9 AE 00              JMP    0x28427                      ; UNKNOWN
028379  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
02837E  76 03                 JBE    0x28383                      ; UNKNOWN
028380  E9 A4 00              JMP    0x28427                      ; UNKNOWN
028383  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
028387  2A E4                 SUB    ah, ah                       ; UNKNOWN
028389  50                    PUSH   ax                           ; UNKNOWN
02838A  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
02838E  50                    PUSH   ax                           ; UNKNOWN
02838F  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
028394  83 C4 04              ADD    sp, 4                        ; UNKNOWN
028397  0B C0                 OR     ax, ax                       ; UNKNOWN
028399  75 0A                 JNE    0x283a5                      ; UNKNOWN
02839B  6A 01                 PUSH   1                            ; UNKNOWN
02839D  A1 88 82              MOV    ax, word ptr [0x8288]        ; UNKNOWN
0283A0  48                    DEC    ax                           ; UNKNOWN
0283A1  48                    DEC    ax                           ; UNKNOWN
0283A2  50                    PUSH   ax                           ; UNKNOWN
0283A3  EB 33                 JMP    0x283d8                      ; UNKNOWN
0283A5  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
0283A9  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0283AD  2A E4                 SUB    ah, ah                       ; UNKNOWN
0283AF  50                    PUSH   ax                           ; UNKNOWN
0283B0  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0283B4  50                    PUSH   ax                           ; UNKNOWN
0283B5  8B F3                 MOV    si, bx                       ; UNKNOWN
0283B7  9A A7 00 5F 24        LCALL  0x245f, 0xa7                 ; UNKNOWN
0283BC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0283BF  0B C0                 OR     ax, ax                       ; UNKNOWN
0283C1  75 0D                 JNE    0x283d0                      ; UNKNOWN
0283C3  8A 84 81 88           MOV    al, byte ptr [si - 0x777f]   ; UNKNOWN
0283C7  2A E4                 SUB    ah, ah                       ; UNKNOWN
0283C9  50                    PUSH   ax                           ; UNKNOWN
0283CA  8A 84 80 88           MOV    al, byte ptr [si - 0x7780]   ; UNKNOWN
0283CE  EB D2                 JMP    0x283a2                      ; UNKNOWN
0283D0  FF 36 7C 73           PUSH   word ptr [0x737c]            ; UNKNOWN
0283D4  FF 36 7A 73           PUSH   word ptr [0x737a]            ; UNKNOWN
0283D8  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
0283DD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0283E0  2A E4                 SUB    ah, ah                       ; UNKNOWN
0283E2  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0283E5  81 7E 06 E7 03        CMP    word ptr [bp + 6], 0x3e7     ; UNKNOWN
0283EA  74 32                 JE     0x2841e                      ; UNKNOWN
0283EC  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
0283F0  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
0283F3  50                    PUSH   ax                           ; UNKNOWN
0283F4  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
0283F6  50                    PUSH   ax                           ; UNKNOWN
0283F7  9A A7 00 5F 24        LCALL  0x245f, 0xa7                 ; UNKNOWN
0283FC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0283FF  0B C0                 OR     ax, ax                       ; UNKNOWN
028401  74 5E                 JE     0x28461                      ; UNKNOWN
028403  FF 36 7C 73           PUSH   word ptr [0x737c]            ; UNKNOWN
028407  FF 36 7A 73           PUSH   word ptr [0x737a]            ; UNKNOWN
02840B  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
028410  83 C4 04              ADD    sp, 4                        ; UNKNOWN
028413  3A 46 FC              CMP    al, byte ptr [bp - 4]        ; UNKNOWN
028416  74 44                 JE     0x2845c                      ; UNKNOWN
028418  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02841B  5E                    POP    si                           ; UNKNOWN
02841C  C9                    LEAVE                               ; UNKNOWN
02841D  CB                    RETF                                ; UNKNOWN
