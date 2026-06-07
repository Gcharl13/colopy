; ============================================================================
; func_01B874_unknown
; Region   : load_image
; Bytes    : file 0x01B874..0x01B8D8  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B874  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
01B878  56                    PUSH   si                           ; UNKNOWN
01B879  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
01B87E  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
01B881  D1 E6                 SHL    si, 1                        ; UNKNOWN
01B883  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01B887  83 B8 9A 00 01        CMP    word ptr [bx + si + 0x9a], 1 ; UNKNOWN
01B88C  7D 4A                 JGE    0x1b8d8                      ; UNKNOWN
01B88E  6A 01                 PUSH   1                            ; UNKNOWN
01B890  9A BD 00 2B 3E        LCALL  0x3e2b, 0xbd                 ; UNKNOWN
01B895  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B898  6A 06                 PUSH   6                            ; UNKNOWN
01B89A  0E                    PUSH   cs                           ; UNKNOWN
01B89B  E8 55 E3              CALL   0x19bf3                      ; UNKNOWN
01B89E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B8A1  FF B4 A1 3D           PUSH   word ptr [si + 0x3da1]       ; UNKNOWN
01B8A5  9A A9 01 2B 3E        LCALL  0x3e2b, 0x1a9                ; UNKNOWN
01B8AA  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B8AD  6A 07                 PUSH   7                            ; UNKNOWN
01B8AF  0E                    PUSH   cs                           ; UNKNOWN
01B8B0  E8 40 E3              CALL   0x19bf3                      ; UNKNOWN
01B8B3  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01B8B6  83 3E E8 0E 01        CMP    word ptr [0xee8], 1          ; UNKNOWN
01B8BB  1B C0                 SBB    ax, ax                       ; UNKNOWN
01B8BD  83 E0 78              AND    ax, 0x78                     ; UNKNOWN
01B8C0  99                    CDQ                                 ; UNKNOWN
01B8C1  52                    PUSH   dx                           ; UNKNOWN
01B8C2  50                    PUSH   ax                           ; UNKNOWN
01B8C3  6A 03                 PUSH   3                            ; UNKNOWN
01B8C5  0E                    PUSH   cs                           ; UNKNOWN
01B8C6  E8 0A E3              CALL   0x19bd3                      ; UNKNOWN
01B8C9  83 C4 06              ADD    sp, 6                        ; UNKNOWN
01B8CC  C7 06 C6 32 14 00     MOV    word ptr [0x32c6], 0x14      ; UNKNOWN
01B8D2  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
01B8D5  5E                    POP    si                           ; UNKNOWN
01B8D6  C9                    LEAVE                               ; UNKNOWN
01B8D7  CB                    RETF                                ; UNKNOWN
