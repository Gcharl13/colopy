; ============================================================================
; func_0237C7_unknown
; Region   : load_image
; Bytes    : file 0x0237C7..0x0237DB  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0237C7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0237CB  57                    PUSH   di                           ; UNKNOWN
0237CC  56                    PUSH   si                           ; UNKNOWN
0237CD  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0237D0  89 5E FC              MOV    word ptr [bp - 4], bx        ; UNKNOWN
0237D3  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
0237D7  2A FF                 SUB    bh, bh                       ; UNKNOWN
0237D9  8B CB                 MOV    cx, bx                       ; UNKNOWN
