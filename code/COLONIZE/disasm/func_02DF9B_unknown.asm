; ============================================================================
; func_02DF9B_unknown
; Region   : load_image
; Bytes    : file 0x02DF9B..0x02DFDD  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DF9B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02DF9F  2B C0                 SUB    ax, ax                       ; UNKNOWN
02DFA1  A3 3A 73              MOV    word ptr [0x733a], ax        ; UNKNOWN
02DFA4  A3 3C 73              MOV    word ptr [0x733c], ax        ; UNKNOWN
02DFA7  A3 3E 73              MOV    word ptr [0x733e], ax        ; UNKNOWN
02DFAA  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DFAE  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02DFB0  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DFB2  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
02DFB5  2A F6                 SUB    dh, dh                       ; UNKNOWN
02DFB7  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
02DFBC  A3 40 73              MOV    word ptr [0x7340], ax        ; UNKNOWN
02DFBF  EB 3D                 JMP    0x2dffe                      ; UNKNOWN
02DFC1  50                    PUSH   ax                           ; UNKNOWN
02DFC2  0E                    PUSH   cs                           ; UNKNOWN
02DFC3  E8 FE FE              CALL   0x2dec4                      ; UNKNOWN
02DFC6  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02DFC9  0B C0                 OR     ax, ax                       ; UNKNOWN
02DFCB  74 04                 JE     0x2dfd1                      ; UNKNOWN
02DFCD  FF 06 3A 73           INC    word ptr [0x733a]            ; UNKNOWN
02DFD1  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
02DFD5  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
02DFD9  2A FF                 SUB    bh, bh                       ; UNKNOWN
02DFDB  8B C3                 MOV    ax, bx                       ; UNKNOWN
