; ============================================================================
; func_021687_unknown
; Region   : load_image
; Bytes    : file 0x021687..0x0216BB  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021687  55                    PUSH   bp                           ; UNKNOWN
021688  8B EC                 MOV    bp, sp                       ; UNKNOWN
02168A  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02168D  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
021690  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
021693  26 89 07              MOV    word ptr es:[bx], ax         ; UNKNOWN
021696  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
021699  26 89 47 02           MOV    word ptr es:[bx + 2], ax     ; UNKNOWN
02169D  8B 46 12              MOV    ax, word ptr [bp + 0x12]     ; UNKNOWN
0216A0  26 89 47 04           MOV    word ptr es:[bx + 4], ax     ; UNKNOWN
0216A4  8B 46 14              MOV    ax, word ptr [bp + 0x14]     ; UNKNOWN
0216A7  26 89 47 06           MOV    word ptr es:[bx + 6], ax     ; UNKNOWN
0216AB  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
0216AE  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
0216B1  26 89 47 08           MOV    word ptr es:[bx + 8], ax     ; UNKNOWN
0216B5  26 89 57 0A           MOV    word ptr es:[bx + 0xa], dx   ; UNKNOWN
0216B9  C9                    LEAVE                               ; UNKNOWN
0216BA  CB                    RETF                                ; UNKNOWN
