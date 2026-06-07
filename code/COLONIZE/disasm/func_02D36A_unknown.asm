; ============================================================================
; func_02D36A_unknown
; Region   : load_image
; Bytes    : file 0x02D36A..0x02D385  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D36A  55                    PUSH   bp                           ; UNKNOWN
02D36B  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D36D  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
02D371  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
02D375  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D378  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D37B  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D37D  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
02D382  48                    DEC    ax                           ; UNKNOWN
02D383  C9                    LEAVE                               ; UNKNOWN
02D384  CB                    RETF                                ; UNKNOWN
