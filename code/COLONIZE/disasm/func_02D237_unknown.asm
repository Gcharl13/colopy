; ============================================================================
; func_02D237_unknown
; Region   : load_image
; Bytes    : file 0x02D237..0x02D268  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D237  55                    PUSH   bp                           ; UNKNOWN
02D238  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D23A  56                    PUSH   si                           ; UNKNOWN
02D23B  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02D23E  56                    PUSH   si                           ; UNKNOWN
02D23F  0E                    PUSH   cs                           ; UNKNOWN
02D240  E8 8A FF              CALL   0x2d1cd                      ; UNKNOWN
02D243  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D246  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D249  9A 6C 00 E6 21        LCALL  0x21e6, 0x6c                 ; UNKNOWN
02D24E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D251  52                    PUSH   dx                           ; UNKNOWN
02D252  50                    PUSH   ax                           ; UNKNOWN
02D253  1E                    PUSH   ds                           ; UNKNOWN
02D254  56                    PUSH   si                           ; UNKNOWN
02D255  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D25A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D25D  56                    PUSH   si                           ; UNKNOWN
02D25E  0E                    PUSH   cs                           ; UNKNOWN
02D25F  E8 7B FF              CALL   0x2d1dd                      ; UNKNOWN
02D262  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02D265  5E                    POP    si                           ; UNKNOWN
02D266  C9                    LEAVE                               ; UNKNOWN
02D267  CB                    RETF                                ; UNKNOWN
