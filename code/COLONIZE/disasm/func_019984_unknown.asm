; ============================================================================
; func_019984_unknown
; Region   : load_image
; Bytes    : file 0x019984..0x0199D8  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

019984  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
019988  6A 2D                 PUSH   0x2d                         ; UNKNOWN
01998A  6A 11                 PUSH   0x11                         ; UNKNOWN
01998C  68 84 00              PUSH   0x84                         ; UNKNOWN
01998F  68 2F 01              PUSH   0x12f                        ; UNKNOWN
019992  0E                    PUSH   cs                           ; UNKNOWN
019993  E8 0F DE              CALL   0x177a5                      ; UNKNOWN
019996  83 C4 08              ADD    sp, 8                        ; UNKNOWN
019999  83 3E 10 09 00        CMP    word ptr [0x910], 0          ; UNKNOWN
01999E  75 1C                 JNE    0x199bc                      ; UNKNOWN
0199A0  6A 44                 PUSH   0x44                         ; UNKNOWN
0199A2  6A 03                 PUSH   3                            ; UNKNOWN
0199A4  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0199A8  74 05                 JE     0x199af                      ; UNKNOWN
0199AA  A0 06 09              MOV    al, byte ptr [0x906]         ; UNKNOWN
0199AD  EB 03                 JMP    0x199b2                      ; UNKNOWN
0199AF  A0 04 09              MOV    al, byte ptr [0x904]         ; UNKNOWN
0199B2  2A E4                 SUB    ah, ah                       ; UNKNOWN
0199B4  50                    PUSH   ax                           ; UNKNOWN
0199B5  0E                    PUSH   cs                           ; UNKNOWN
0199B6  E8 F6 FE              CALL   0x198af                      ; UNKNOWN
0199B9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
0199BC  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0199C0  74 14                 JE     0x199d6                      ; UNKNOWN
0199C2  68 84 00              PUSH   0x84                         ; UNKNOWN
0199C5  6A 11                 PUSH   0x11                         ; UNKNOWN
0199C7  6A 2D                 PUSH   0x2d                         ; UNKNOWN
0199C9  B8 2F 01              MOV    ax, 0x12f                    ; UNKNOWN
0199CC  BA 84 00              MOV    dx, 0x84                     ; UNKNOWN
0199CF  8B D8                 MOV    bx, ax                       ; UNKNOWN
0199D1  9A 3B 00 B4 5C        LCALL  0x5cb4, 0x3b                 ; UNKNOWN
0199D6  C9                    LEAVE                               ; UNKNOWN
0199D7  CB                    RETF                                ; UNKNOWN
