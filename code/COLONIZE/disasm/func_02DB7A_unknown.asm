; ============================================================================
; func_02DB7A_unknown
; Region   : load_image
; Bytes    : file 0x02DB7A..0x02DB95  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DB7A  55                    PUSH   bp                           ; UNKNOWN
02DB7B  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DB7D  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02DB80  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
02DB83  F7 D8                 NEG    ax                           ; UNKNOWN
02DB85  83 D2 00              ADC    dx, 0                        ; UNKNOWN
02DB88  F7 DA                 NEG    dx                           ; UNKNOWN
02DB8A  52                    PUSH   dx                           ; UNKNOWN
02DB8B  50                    PUSH   ax                           ; UNKNOWN
02DB8C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DB8F  0E                    PUSH   cs                           ; UNKNOWN
02DB90  E8 A8 FF              CALL   0x2db3b                      ; UNKNOWN
02DB93  C9                    LEAVE                               ; UNKNOWN
02DB94  CB                    RETF                                ; UNKNOWN
