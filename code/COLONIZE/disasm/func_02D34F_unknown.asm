; ============================================================================
; func_02D34F_unknown
; Region   : load_image
; Bytes    : file 0x02D34F..0x02D36A  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D34F  55                    PUSH   bp                           ; UNKNOWN
02D350  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D352  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
02D356  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
02D35A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02D35D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02D360  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D362  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
02D367  48                    DEC    ax                           ; UNKNOWN
02D368  C9                    LEAVE                               ; UNKNOWN
02D369  CB                    RETF                                ; UNKNOWN
