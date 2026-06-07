; ============================================================================
; func_034D8A_unknown
; Region   : load_image
; Bytes    : file 0x034D8A..0x034DF9  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034D8A  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
034D8E  56                    PUSH   si                           ; UNKNOWN
034D8F  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1      ; UNKNOWN
034D94  83 3E A6 09 00        CMP    word ptr [0x9a6], 0          ; UNKNOWN
034D99  74 5E                 JE     0x34df9                      ; UNKNOWN
034D9B  83 3E EF 0A 00        CMP    word ptr [0xaef], 0          ; UNKNOWN
034DA0  75 57                 JNE    0x34df9                      ; UNKNOWN
034DA2  6A 01                 PUSH   1                            ; UNKNOWN
034DA4  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
034DA9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034DAC  6A 05                 PUSH   5                            ; UNKNOWN
034DAE  0E                    PUSH   cs                           ; UNKNOWN
034DAF  E8 41 FA              CALL   0x347f3                      ; UNKNOWN
034DB2  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034DB5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
034DB8  D1 E3                 SHL    bx, 1                        ; UNKNOWN
034DBA  FF B7 A1 3D           PUSH   word ptr [bx + 0x3da1]       ; UNKNOWN
034DBE  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
034DC3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
034DC6  9A 27 02 2B 3E        LCALL  0x3e2b, 0x227                ; UNKNOWN
034DCB  1E                    PUSH   ds                           ; UNKNOWN
034DCC  68 F5 1F              PUSH   0x1ff5                       ; UNKNOWN
034DCF  9A 86 01 2B 3E        LCALL  0x3e2b, 0x186                ; UNKNOWN
034DD4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
034DD7  83 3E E8 0E 01        CMP    word ptr [0xee8], 1          ; UNKNOWN
034DDC  1B C0                 SBB    ax, ax                       ; UNKNOWN
034DDE  83 E0 78              AND    ax, 0x78                     ; UNKNOWN
034DE1  99                    CDQ                                 ; UNKNOWN
034DE2  52                    PUSH   dx                           ; UNKNOWN
034DE3  50                    PUSH   ax                           ; UNKNOWN
034DE4  6A 03                 PUSH   3                            ; UNKNOWN
034DE6  0E                    PUSH   cs                           ; UNKNOWN
034DE7  E8 E9 F9              CALL   0x347d3                      ; UNKNOWN
034DEA  83 C4 06              ADD    sp, 6                        ; UNKNOWN
034DED  C7 06 BA 79 0F 00     MOV    word ptr [0x79ba], 0xf       ; UNKNOWN
034DF3  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
034DF6  5E                    POP    si                           ; UNKNOWN
034DF7  C9                    LEAVE                               ; UNKNOWN
034DF8  CB                    RETF                                ; UNKNOWN
