; ============================================================================
; func_02ECF2_unknown
; Region   : load_image
; Bytes    : file 0x02ECF2..0x02ED35  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02ECF2  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02ECF6  2B C0                 SUB    ax, ax                       ; UNKNOWN
02ECF8  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02ECFB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02ECFE  EB 2A                 JMP    0x2ed2a                      ; UNKNOWN
02ED00  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
02ED03  50                    PUSH   ax                           ; UNKNOWN
02ED04  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
02ED07  50                    PUSH   ax                           ; UNKNOWN
02ED08  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
02ED0B  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
02ED0F  98                    CWDE                                ; UNKNOWN
02ED10  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02ED13  50                    PUSH   ax                           ; UNKNOWN
02ED14  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
02ED18  98                    CWDE                                ; UNKNOWN
02ED19  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
02ED1C  50                    PUSH   ax                           ; UNKNOWN
02ED1D  0E                    PUSH   cs                           ; UNKNOWN
02ED1E  E8 92 FF              CALL   0x2ecb3                      ; UNKNOWN
02ED21  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02ED24  01 46 FE              ADD    word ptr [bp - 2], ax        ; UNKNOWN
02ED27  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02ED2A  83 7E FC 08           CMP    word ptr [bp - 4], 8         ; UNKNOWN
02ED2E  7C D0                 JL     0x2ed00                      ; UNKNOWN
02ED30  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02ED33  C9                    LEAVE                               ; UNKNOWN
02ED34  CB                    RETF                                ; UNKNOWN
