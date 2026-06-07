; ============================================================================
; func_0411B8_unknown
; Region   : load_image
; Bytes    : file 0x0411B8..0x041232  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0411B8  C8 0E 00 00           ENTER  0xe, 0                       ; UNKNOWN
0411BC  83 3E 56 C1 01        CMP    word ptr [0xc156], 1         ; UNKNOWN
0411C1  1B C0                 SBB    ax, ax                       ; UNKNOWN
0411C3  F7 D8                 NEG    ax                           ; UNKNOWN
0411C5  A3 56 C1              MOV    word ptr [0xc156], ax        ; UNKNOWN
0411C8  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
0411CD  75 18                 JNE    0x411e7                      ; UNKNOWN
0411CF  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
0411D4  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
0411D8  2A E4                 SUB    ah, ah                       ; UNKNOWN
0411DA  50                    PUSH   ax                           ; UNKNOWN
0411DB  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
0411DF  50                    PUSH   ax                           ; UNKNOWN
0411E0  0E                    PUSH   cs                           ; UNKNOWN
0411E1  E8 B2 FF              CALL   0x41196                      ; UNKNOWN
0411E4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0411E7  83 3E 3E 3E 00        CMP    word ptr [0x3e3e], 0         ; UNKNOWN
0411EC  74 0A                 JE     0x411f8                      ; UNKNOWN
0411EE  6A 01                 PUSH   1                            ; UNKNOWN
0411F0  9A 5E 01 10 0C        LCALL  0xc10, 0x15e                 ; UNKNOWN
0411F5  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0411F8  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
0411FC  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
041200  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
041205  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041208  0B C0                 OR     ax, ax                       ; UNKNOWN
04120A  74 2A                 JE     0x41236                      ; UNKNOWN
04120C  FF 36 56 C1           PUSH   word ptr [0xc156]            ; UNKNOWN
041210  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
041215  74 05                 JE     0x4121c                      ; UNKNOWN
041217  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
04121A  EB 03                 JMP    0x4121f                      ; UNKNOWN
04121C  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
04121F  50                    PUSH   ax                           ; UNKNOWN
041220  6A 01                 PUSH   1                            ; UNKNOWN
041222  6A 01                 PUSH   1                            ; UNKNOWN
041224  6A 01                 PUSH   1                            ; UNKNOWN
041226  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
04122A  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
04122E  9A                    DB     0x9A                         ; UNKNOWN (raw)
04122F  5B                    DB     0x5B                         ; UNKNOWN (raw)
041230  03                    DB     0x03                         ; UNKNOWN (raw)
041231  CF                    DB     0xCF                         ; UNKNOWN (raw)
