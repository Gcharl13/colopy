; ============================================================================
; func_0474F9_unknown
; Region   : load_image
; Bytes    : file 0x0474F9..0x047525  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0474F9  55                    PUSH   bp                           ; UNKNOWN
0474FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
0474FC  0E                    PUSH   cs                           ; UNKNOWN
0474FD  E8 EF FD              CALL   0x472ef                      ; UNKNOWN
047500  C6 06 C6 0B 01        MOV    byte ptr [0xbc6], 1          ; UNKNOWN
047505  A0 E8 0E              MOV    al, byte ptr [0xee8]         ; UNKNOWN
047508  A2 C7 0B              MOV    byte ptr [0xbc7], al         ; UNKNOWN
04750B  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
04750E  A2 C8 0B              MOV    byte ptr [0xbc8], al         ; UNKNOWN
047511  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
047516  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
047519  13 56 0A              ADC    dx, word ptr [bp + 0xa]      ; UNKNOWN
04751C  A3 3A C6              MOV    word ptr [0xc63a], ax        ; UNKNOWN
04751F  89 16 3C C6           MOV    word ptr [0xc63c], dx        ; UNKNOWN
047523  C9                    LEAVE                               ; UNKNOWN
047524  CB                    RETF                                ; UNKNOWN
