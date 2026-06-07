; ============================================================================
; func_025ABA_unknown
; Region   : load_image
; Bytes    : file 0x025ABA..0x025AE5  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025ABA  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
025ABE  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
025AC1  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
025AC4  83 C1 74              ADD    cx, 0x74                     ; UNKNOWN
025AC7  53                    PUSH   bx                           ; UNKNOWN
025AC8  51                    PUSH   cx                           ; UNKNOWN
025AC9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
025ACC  FF 76 04              PUSH   word ptr [bp + 4]            ; UNKNOWN
025ACF  C4 5E 08              LES    bx, ptr [bp + 8]             ; UNKNOWN
025AD2  26 8B 4F 48           MOV    cx, word ptr es:[bx + 0x48]  ; UNKNOWN
025AD6  26 03 4F 2A           ADD    cx, word ptr es:[bx + 0x2a]  ; UNKNOWN
025ADA  03 C1                 ADD    ax, cx                       ; UNKNOWN
025ADC  2B DB                 SUB    bx, bx                       ; UNKNOWN
025ADE  E8 BA F3              CALL   0x24e9b                      ; UNKNOWN
025AE1  C9                    LEAVE                               ; UNKNOWN
025AE2  C2 08 00              RET    8                            ; UNKNOWN
