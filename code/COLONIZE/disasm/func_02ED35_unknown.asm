; ============================================================================
; func_02ED35_unknown
; Region   : load_image
; Bytes    : file 0x02ED35..0x02ED6D  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02ED35  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02ED39  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02ED3E  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02ED41  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02ED44  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02ED49  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ED4C  0B C0                 OR     ax, ax                       ; UNKNOWN
02ED4E  74 18                 JE     0x2ed68                      ; UNKNOWN
02ED50  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02ED53  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02ED56  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
02ED5B  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02ED5E  84 46 0A              TEST   byte ptr [bp + 0xa], al      ; UNKNOWN
02ED61  74 05                 JE     0x2ed68                      ; UNKNOWN
02ED63  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
02ED68  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02ED6B  C9                    LEAVE                               ; UNKNOWN
02ED6C  CB                    RETF                                ; UNKNOWN
