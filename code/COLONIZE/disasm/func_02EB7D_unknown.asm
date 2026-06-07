; ============================================================================
; func_02EB7D_unknown
; Region   : load_image
; Bytes    : file 0x02EB7D..0x02EBBB  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EB7D  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02EB81  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02EB86  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
02EB8A  7C 2A                 JL     0x2ebb6                      ; UNKNOWN
02EB8C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EB8F  0E                    PUSH   cs                           ; UNKNOWN
02EB90  E8 34 F5              CALL   0x2e0c7                      ; UNKNOWN
02EB93  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EB96  0B C0                 OR     ax, ax                       ; UNKNOWN
02EB98  7C 1C                 JL     0x2ebb6                      ; UNKNOWN
02EB9A  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
02EB9F  8B D8                 MOV    bx, ax                       ; UNKNOWN
02EBA1  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02EBA3  03 D8                 ADD    bx, ax                       ; UNKNOWN
02EBA5  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
02EBA8  8A 87 17 39           MOV    al, byte ptr [bx + 0x3917]   ; UNKNOWN
02EBAC  98                    CWDE                                ; UNKNOWN
02EBAD  0B C0                 OR     ax, ax                       ; UNKNOWN
02EBAF  7C 05                 JL     0x2ebb6                      ; UNKNOWN
02EBB1  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; UNKNOWN
02EBB6  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02EBB9  C9                    LEAVE                               ; UNKNOWN
02EBBA  CB                    RETF                                ; UNKNOWN
