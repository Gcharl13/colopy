; ============================================================================
; func_02D861_unknown
; Region   : load_image
; Bytes    : file 0x02D861..0x02D873  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D861  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
02D865  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D867  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02D86A  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02D86E  8B 87 C2 00           MOV    ax, word ptr [bx + 0xc2]     ; UNKNOWN
02D872  8B                    DB     0x8B                         ; UNKNOWN (raw)
