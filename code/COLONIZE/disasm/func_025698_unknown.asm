; ============================================================================
; func_025698_unknown
; Region   : load_image
; Bytes    : file 0x025698..0x0256BB  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025698  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
02569C  57                    PUSH   di                           ; UNKNOWN
02569D  56                    PUSH   si                           ; UNKNOWN
02569E  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0256A1  26 8B 47 60           MOV    ax, word ptr es:[bx + 0x60]  ; UNKNOWN
0256A5  26 8B 57 62           MOV    dx, word ptr es:[bx + 0x62]  ; UNKNOWN
0256A9  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0256AC  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
0256AF  2B C0                 SUB    ax, ax                       ; UNKNOWN
0256B1  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0256B4  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0256B7  8B C2                 MOV    ax, dx                       ; UNKNOWN
0256B9  0B                    DB     0x0B                         ; UNKNOWN (raw)
0256BA  46                    DB     0x46                         ; UNKNOWN (raw)
