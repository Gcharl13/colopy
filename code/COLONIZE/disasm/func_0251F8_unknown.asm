; ============================================================================
; func_0251F8_unknown
; Region   : load_image
; Bytes    : file 0x0251F8..0x02524C  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0251F8  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
0251FC  50                    PUSH   ax                           ; UNKNOWN
0251FD  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
025202  2B C0                 SUB    ax, ax                       ; UNKNOWN
025204  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
025207  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02520A  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02520D  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54]  ; UNKNOWN
025211  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56]  ; UNKNOWN
025215  EB 29                 JMP    0x25240                      ; UNKNOWN
025217  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02521A  0B 46 FA              OR     ax, word ptr [bp - 6]        ; UNKNOWN
02521D  74 2D                 JE     0x2524c                      ; UNKNOWN
02521F  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
025222  C4 5E FA              LES    bx, ptr [bp - 6]             ; UNKNOWN
025225  26 39 47 04           CMP    word ptr es:[bx + 4], ax     ; UNKNOWN
025229  75 0D                 JNE    0x25238                      ; UNKNOWN
02522B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
025230  89 5E F6              MOV    word ptr [bp - 0xa], bx      ; UNKNOWN
025233  8C 46 F8              MOV    word ptr [bp - 8], es        ; UNKNOWN
025236  EB 0E                 JMP    0x25246                      ; UNKNOWN
025238  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10]  ; UNKNOWN
02523C  26 8B 57 12           MOV    dx, word ptr es:[bx + 0x12]  ; UNKNOWN
025240  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
025243  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
025246  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
02524A  74 CB                 JE     0x25217                      ; UNKNOWN
