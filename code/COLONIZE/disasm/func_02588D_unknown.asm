; ============================================================================
; func_02588D_unknown
; Region   : load_image
; Bytes    : file 0x02588D..0x0258AF  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02588D  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
025891  56                    PUSH   si                           ; UNKNOWN
025892  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
025895  26 8B 47 5C           MOV    ax, word ptr es:[bx + 0x5c]  ; UNKNOWN
025899  26 8B 57 5E           MOV    dx, word ptr es:[bx + 0x5e]  ; UNKNOWN
02589D  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0258A0  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
0258A3  2B C0                 SUB    ax, ax                       ; UNKNOWN
0258A5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
0258A8  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
0258AB  8B C2                 MOV    ax, dx                       ; UNKNOWN
0258AD  0B                    DB     0x0B                         ; UNKNOWN (raw)
0258AE  46                    DB     0x46                         ; UNKNOWN (raw)
