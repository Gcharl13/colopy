; ============================================================================
; func_0696B6_unknown
; Region   : load_image
; Bytes    : file 0x0696B6..0x069772  (188 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0696B6  55                    PUSH   bp                           ; UNKNOWN
0696B7  8B EC                 MOV    bp, sp                       ; UNKNOWN
0696B9  81 EC 22 01           SUB    sp, 0x122                    ; UNKNOWN
0696BD  57                    PUSH   di                           ; UNKNOWN
0696BE  56                    PUSH   si                           ; UNKNOWN
0696BF  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
0696C2  8D BE DE FE           LEA    di, [bp - 0x122]             ; UNKNOWN
0696C6  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0696CA  75 08                 JNE    0x696d4                      ; UNKNOWN
0696CC  9A 2C 10 65 5F        LCALL  0x5f65, 0x102c               ; UNKNOWN
0696D1  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
0696D4  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
0696D7  04 40                 ADD    al, 0x40                     ; UNKNOWN
0696D9  88 05                 MOV    byte ptr [di], al            ; UNKNOWN
0696DB  47                    INC    di                           ; UNKNOWN
0696DC  C6 05 3A              MOV    byte ptr [di], 0x3a          ; UNKNOWN
0696DF  47                    INC    di                           ; UNKNOWN
0696E0  C6 05 5C              MOV    byte ptr [di], 0x5c          ; UNKNOWN
0696E3  47                    INC    di                           ; UNKNOWN
0696E4  C6 46 F3 47           MOV    byte ptr [bp - 0xd], 0x47    ; UNKNOWN
0696E8  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
0696EB  88 46 F8              MOV    byte ptr [bp - 8], al        ; UNKNOWN
0696EE  89 7E FA              MOV    word ptr [bp - 6], di        ; UNKNOWN
0696F1  8D 46 E4              LEA    ax, [bp - 0x1c]              ; UNKNOWN
0696F4  50                    PUSH   ax                           ; UNKNOWN
0696F5  8D 4E F2              LEA    cx, [bp - 0xe]               ; UNKNOWN
0696F8  51                    PUSH   cx                           ; UNKNOWN
0696F9  9A 70 27 65 5F        LCALL  0x5f65, 0x2770               ; UNKNOWN
0696FE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
069701  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
069705  74 11                 JE     0x69718                      ; UNKNOWN
069707  C7 06 38 12 0D 00     MOV    word ptr [0x1238], 0xd       ; UNKNOWN
06970D  8B 46 E4              MOV    ax, word ptr [bp - 0x1c]     ; UNKNOWN
069710  A3 43 12              MOV    word ptr [0x1243], ax        ; UNKNOWN
069713  2B C0                 SUB    ax, ax                       ; UNKNOWN
069715  EB 55                 JMP    0x6976c                      ; UNKNOWN
069717  90                    NOP                                 ; UNKNOWN
069718  8D 86 DE FE           LEA    ax, [bp - 0x122]             ; UNKNOWN
06971C  50                    PUSH   ax                           ; UNKNOWN
06971D  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
069722  83 C4 02              ADD    sp, 2                        ; UNKNOWN
069725  40                    INC    ax                           ; UNKNOWN
069726  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
069729  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
06972C  0B FF                 OR     di, di                       ; UNKNOWN
06972E  75 21                 JNE    0x69751                      ; UNKNOWN
069730  3B C6                 CMP    ax, si                       ; UNKNOWN
069732  7E 02                 JLE    0x69736                      ; UNKNOWN
069734  8B F0                 MOV    si, ax                       ; UNKNOWN
069736  56                    PUSH   si                           ; UNKNOWN
069737  9A 82 23 65 5F        LCALL  0x5f65, 0x2382               ; UNKNOWN
06973C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
06973F  8B F8                 MOV    di, ax                       ; UNKNOWN
069741  0B FF                 OR     di, di                       ; UNKNOWN
069743  75 09                 JNE    0x6974e                      ; UNKNOWN
069745  C7 06 38 12 0C 00     MOV    word ptr [0x1238], 0xc       ; UNKNOWN
06974B  EB 1F                 JMP    0x6976c                      ; UNKNOWN
06974D  90                    NOP                                 ; UNKNOWN
06974E  89 7E 08              MOV    word ptr [bp + 8], di        ; UNKNOWN
069751  39 76 E2              CMP    word ptr [bp - 0x1e], si     ; UNKNOWN
069754  7E 08                 JLE    0x6975e                      ; UNKNOWN
069756  C7 06 38 12 22 00     MOV    word ptr [0x1238], 0x22      ; UNKNOWN
06975C  EB B5                 JMP    0x69713                      ; UNKNOWN
06975E  8D 86 DE FE           LEA    ax, [bp - 0x122]             ; UNKNOWN
069762  50                    PUSH   ax                           ; UNKNOWN
069763  57                    PUSH   di                           ; UNKNOWN
069764  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
069769  83 C4 04              ADD    sp, 4                        ; UNKNOWN
06976C  5E                    POP    si                           ; UNKNOWN
06976D  5F                    POP    di                           ; UNKNOWN
06976E  8B E5                 MOV    sp, bp                       ; UNKNOWN
069770  5D                    POP    bp                           ; UNKNOWN
069771  CB                    RETF                                ; UNKNOWN
