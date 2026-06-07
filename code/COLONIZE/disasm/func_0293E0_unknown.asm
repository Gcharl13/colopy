; ============================================================================
; func_0293E0_unknown
; Region   : load_image
; Bytes    : file 0x0293E0..0x029404  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0293E0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
0293E4  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0293E8  7D 1B                 JGE    0x29405                      ; UNKNOWN
0293EA  68 C5 19              PUSH   0x19c5                       ; UNKNOWN
0293ED  A0 24 0A              MOV    al, byte ptr [0xa24]         ; UNKNOWN
0293F0  98                    CWDE                                ; UNKNOWN
0293F1  50                    PUSH   ax                           ; UNKNOWN
0293F2  6A 00                 PUSH   0                            ; UNKNOWN
0293F4  0E                    PUSH   cs                           ; UNKNOWN
0293F5  E8 33 F6              CALL   0x28a2b                      ; UNKNOWN
0293F8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0293FB  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
0293FE  0B C0                 OR     ax, ax                       ; UNKNOWN
029400  7D 03                 JGE    0x29405                      ; UNKNOWN
029402  E9                    DB     0xE9                         ; UNKNOWN (raw)
029403  CB                    DB     0xCB                         ; UNKNOWN (raw)
