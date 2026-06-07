; ============================================================================
; func_02D988_unknown
; Region   : load_image
; Bytes    : file 0x02D988..0x02D9A7  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D988  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02D98C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02D991  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D994  0E                    PUSH   cs                           ; UNKNOWN
02D995  E8 E0 FF              CALL   0x2d978                      ; UNKNOWN
02D998  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D99B  0B C0                 OR     ax, ax                       ; UNKNOWN
02D99D  74 03                 JE     0x2d9a2                      ; UNKNOWN
02D99F  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02D9A2  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02D9A5  8B C3                 MOV    ax, bx                       ; UNKNOWN
