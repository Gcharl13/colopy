; ============================================================================
; func_0504B1_unknown
; Region   : load_image
; Bytes    : file 0x0504B1..0x050507  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0504B1  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0504B5  57                    PUSH   di                           ; UNKNOWN
0504B6  56                    PUSH   si                           ; UNKNOWN
0504B7  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c  ; UNKNOWN
0504BB  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0504BF  2A E4                 SUB    ah, ah                       ; UNKNOWN
0504C1  50                    PUSH   ax                           ; UNKNOWN
0504C2  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0504C6  50                    PUSH   ax                           ; UNKNOWN
0504C7  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
0504CC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0504CF  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0504D2  50                    PUSH   ax                           ; UNKNOWN
0504D3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0504D6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0504D9  0E                    PUSH   cs                           ; UNKNOWN
0504DA  E8 01 FF              CALL   0x503de                      ; UNKNOWN
0504DD  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0504E0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
0504E3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0504E6  8B F0                 MOV    si, ax                       ; UNKNOWN
0504E8  0E                    PUSH   cs                           ; UNKNOWN
0504E9  E8 5B FE              CALL   0x50347                      ; UNKNOWN
0504EC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0504EF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0504F2  8B F8                 MOV    di, ax                       ; UNKNOWN
0504F4  0E                    PUSH   cs                           ; UNKNOWN
0504F5  E8 8D FD              CALL   0x50285                      ; UNKNOWN
0504F8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0504FB  03 F7                 ADD    si, di                       ; UNKNOWN
0504FD  03 C6                 ADD    ax, si                       ; UNKNOWN
0504FF  79 02                 JNS    0x50503                      ; UNKNOWN
050501  2B C0                 SUB    ax, ax                       ; UNKNOWN
050503  5E                    POP    si                           ; UNKNOWN
050504  5F                    POP    di                           ; UNKNOWN
050505  C9                    LEAVE                               ; UNKNOWN
050506  CB                    RETF                                ; UNKNOWN
