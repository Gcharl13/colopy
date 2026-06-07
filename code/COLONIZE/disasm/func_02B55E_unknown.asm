; ============================================================================
; func_02B55E_unknown
; Region   : load_image
; Bytes    : file 0x02B55E..0x02B5D1  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B55E  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02B562  56                    PUSH   si                           ; UNKNOWN
02B563  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B566  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B569  0E                    PUSH   cs                           ; UNKNOWN
02B56A  E8 29 FF              CALL   0x2b496                      ; UNKNOWN
02B56D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B570  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
02B573  F7 D1                 NOT    cx                           ; UNKNOWN
02B575  23 C1                 AND    ax, cx                       ; UNKNOWN
02B577  50                    PUSH   ax                           ; UNKNOWN
02B578  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B57B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B57E  8B F1                 MOV    si, cx                       ; UNKNOWN
02B580  0E                    PUSH   cs                           ; UNKNOWN
02B581  E8 3E FF              CALL   0x2b4c2                      ; UNKNOWN
02B584  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B587  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02B58A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B58D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B590  0E                    PUSH   cs                           ; UNKNOWN
02B591  E8 02 FF              CALL   0x2b496                      ; UNKNOWN
02B594  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02B597  23 F0                 AND    si, ax                       ; UNKNOWN
02B599  56                    PUSH   si                           ; UNKNOWN
02B59A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02B59D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02B5A0  0E                    PUSH   cs                           ; UNKNOWN
02B5A1  E8 1E FF              CALL   0x2b4c2                      ; UNKNOWN
02B5A4  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02B5A7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02B5AA  23 46 0A              AND    ax, word ptr [bp + 0xa]      ; UNKNOWN
02B5AD  8B 4E FE              MOV    cx, word ptr [bp - 2]        ; UNKNOWN
02B5B0  23 4E 0A              AND    cx, word ptr [bp + 0xa]      ; UNKNOWN
02B5B3  3B C1                 CMP    ax, cx                       ; UNKNOWN
02B5B5  74 14                 JE     0x2b5cb                      ; UNKNOWN
02B5B7  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02B5BA  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02B5BD  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02B5C0  68 32 1D              PUSH   0x1d32                       ; UNKNOWN
02B5C3  9A DD 00 AA 38        LCALL  0x38aa, 0xdd                 ; UNKNOWN
02B5C8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02B5CB  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02B5CE  5E                    POP    si                           ; UNKNOWN
02B5CF  C9                    LEAVE                               ; UNKNOWN
02B5D0  CB                    RETF                                ; UNKNOWN
