; ============================================================================
; func_018230_unknown
; Region   : load_image
; Bytes    : file 0x018230..0x0182F0  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

018230  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
018234  C7 46 AA 00 00        MOV    word ptr [bp - 0x56], 0      ; UNKNOWN
018239  A0 03 09              MOV    al, byte ptr [0x903]         ; UNKNOWN
01823C  2A E4                 SUB    ah, ah                       ; UNKNOWN
01823E  A3 96 0B              MOV    word ptr [0xb96], ax         ; UNKNOWN
018241  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
018244  40                    INC    ax                           ; UNKNOWN
018245  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
018248  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
01824C  75 13                 JNE    0x18261                      ; UNKNOWN
01824E  6A 00                 PUSH   0                            ; UNKNOWN
018250  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
018255  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018258  0B C0                 OR     ax, ax                       ; UNKNOWN
01825A  75 05                 JNE    0x18261                      ; UNKNOWN
01825C  C7 46 A8 11 00        MOV    word ptr [bp - 0x58], 0x11   ; UNKNOWN
018261  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf       ; UNKNOWN
018265  74 06                 JE     0x1826d                      ; UNKNOWN
018267  83 7E 06 11           CMP    word ptr [bp + 6], 0x11      ; UNKNOWN
01826B  75 28                 JNE    0x18295                      ; UNKNOWN
01826D  6A 0F                 PUSH   0xf                          ; UNKNOWN
01826F  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
018274  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018277  0B C0                 OR     ax, ax                       ; UNKNOWN
018279  74 15                 JE     0x18290                      ; UNKNOWN
01827B  6A 11                 PUSH   0x11                         ; UNKNOWN
01827D  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
018282  83 C4 02              ADD    sp, 2                        ; UNKNOWN
018285  0B C0                 OR     ax, ax                       ; UNKNOWN
018287  74 0C                 JE     0x18295                      ; UNKNOWN
018289  C7 46 A8 30 00        MOV    word ptr [bp - 0x58], 0x30   ; UNKNOWN
01828E  EB 05                 JMP    0x18295                      ; UNKNOWN
018290  C7 46 A8 2F 00        MOV    word ptr [bp - 0x58], 0x2f   ; UNKNOWN
018295  FF 36 76 09           PUSH   word ptr [0x976]             ; UNKNOWN
018299  FF 36 74 09           PUSH   word ptr [0x974]             ; UNKNOWN
01829D  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0182A0  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
0182A3  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
0182A7  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0182AA  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
0182AF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0182B2  9A 9E 14 5F 24        LCALL  0x245f, 0x149e               ; UNKNOWN
0182B7  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0182BA  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
0182BD  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf       ; UNKNOWN
0182C1  75 13                 JNE    0x182d6                      ; UNKNOWN
0182C3  6A 11                 PUSH   0x11                         ; UNKNOWN
0182C5  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
0182CA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0182CD  0B C0                 OR     ax, ax                       ; UNKNOWN
0182CF  74 05                 JE     0x182d6                      ; UNKNOWN
0182D1  C7 46 06 11 00        MOV    word ptr [bp + 6], 0x11      ; UNKNOWN
0182D6  83 7E A0 00           CMP    word ptr [bp - 0x60], 0      ; UNKNOWN
0182DA  7D 15                 JGE    0x182f1                      ; UNKNOWN
0182DC  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; UNKNOWN
0182E0  74 0F                 JE     0x182f1                      ; UNKNOWN
0182E2  83 7E 06 14           CMP    word ptr [bp + 6], 0x14      ; UNKNOWN
0182E6  74 09                 JE     0x182f1                      ; UNKNOWN
0182E8  83 7E 06 11           CMP    word ptr [bp + 6], 0x11      ; UNKNOWN
0182EC  74 03                 JE     0x182f1                      ; UNKNOWN
0182EE  E9                    DB     0xE9                         ; UNKNOWN (raw)
0182EF  CF                    DB     0xCF                         ; UNKNOWN (raw)
