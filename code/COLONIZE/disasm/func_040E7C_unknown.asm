; ============================================================================
; func_040E7C_unknown
; Region   : load_image
; Bytes    : file 0x040E7C..0x040EF3  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040E7C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040E80  57                    PUSH   di                           ; UNKNOWN
040E81  56                    PUSH   si                           ; UNKNOWN
040E82  8B F0                 MOV    si, ax                       ; UNKNOWN
040E84  2B FF                 SUB    di, di                       ; UNKNOWN
040E86  0B F6                 OR     si, si                       ; UNKNOWN
040E88  7C 6B                 JL     0x40ef5                      ; UNKNOWN
040E8A  39 36 14 3E           CMP    word ptr [0x3e14], si        ; UNKNOWN
040E8E  7E 65                 JLE    0x40ef5                      ; UNKNOWN
040E90  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040E93  89 5E FE              MOV    word ptr [bp - 2], bx        ; UNKNOWN
040E96  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
040E9A  2A E4                 SUB    ah, ah                       ; UNKNOWN
040E9C  50                    PUSH   ax                           ; UNKNOWN
040E9D  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
040EA1  50                    PUSH   ax                           ; UNKNOWN
040EA2  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
040EA7  83 C4 04              ADD    sp, 4                        ; UNKNOWN
040EAA  0B C0                 OR     ax, ax                       ; UNKNOWN
040EAC  74 47                 JE     0x40ef5                      ; UNKNOWN
040EAE  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040EB1  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
040EB5  24 0F                 AND    al, 0xf                      ; UNKNOWN
040EB7  3A 06 0C 3E           CMP    al, byte ptr [0x3e0c]        ; UNKNOWN
040EBB  75 36                 JNE    0x40ef3                      ; UNKNOWN
040EBD  80 BF 88 88 01        CMP    byte ptr [bx - 0x7778], 1    ; UNKNOWN
040EC2  74 2F                 JE     0x40ef3                      ; UNKNOWN
040EC4  80 BF 88 88 06        CMP    byte ptr [bx - 0x7778], 6    ; UNKNOWN
040EC9  74 28                 JE     0x40ef3                      ; UNKNOWN
040ECB  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
040ED0  74 07                 JE     0x40ed9                      ; UNKNOWN
040ED2  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
040ED7  75 1A                 JNE    0x40ef3                      ; UNKNOWN
040ED9  56                    PUSH   si                           ; UNKNOWN
040EDA  0E                    PUSH   cs                           ; UNKNOWN
040EDB  E8 E6 F2              CALL   0x401c4                      ; UNKNOWN
040EDE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
040EE1  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040EE4  38 87 85 88           CMP    byte ptr [bx - 0x777b], al   ; UNKNOWN
040EE8  73 09                 JAE    0x40ef3                      ; UNKNOWN
040EEA  BF 01 00              MOV    di, 1                        ; UNKNOWN
040EED  8B C7                 MOV    ax, di                       ; UNKNOWN
040EEF  5E                    POP    si                           ; UNKNOWN
040EF0  5F                    POP    di                           ; UNKNOWN
040EF1  C9                    LEAVE                               ; UNKNOWN
040EF2  CB                    RETF                                ; UNKNOWN
