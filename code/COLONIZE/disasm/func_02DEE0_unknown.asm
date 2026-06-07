; ============================================================================
; func_02DEE0_unknown
; Region   : load_image
; Bytes    : file 0x02DEE0..0x02DEF4  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DEE0  55                    PUSH   bp                           ; UNKNOWN
02DEE1  8B EC                 MOV    bp, sp                       ; UNKNOWN
02DEE3  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
02DEE7  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
02DEEB  2A FF                 SUB    bh, bh                       ; UNKNOWN
02DEED  8A 87 BF 0A           MOV    al, byte ptr [bx + 0xabf]    ; UNKNOWN
02DEF1  98                    CWDE                                ; UNKNOWN
02DEF2  C9                    LEAVE                               ; UNKNOWN
02DEF3  CB                    RETF                                ; UNKNOWN
