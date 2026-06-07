; ============================================================================
; func_03FDAB_unknown
; Region   : load_image
; Bytes    : file 0x03FDAB..0x03FE3A  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FDAB  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03FDAF  57                    PUSH   di                           ; UNKNOWN
03FDB0  56                    PUSH   si                           ; UNKNOWN
03FDB1  8B F0                 MOV    si, ax                       ; UNKNOWN
03FDB3  2B DB                 SUB    bx, bx                       ; UNKNOWN
03FDB5  6B FE 1C              IMUL   di, si, 0x1c                 ; UNKNOWN
03FDB8  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
03FDBB  39 9D 98 88           CMP    word ptr [di - 0x7768], bx   ; UNKNOWN
03FDBF  7C 12                 JL     0x3fdd3                      ; UNKNOWN
03FDC1  8B DF                 MOV    bx, di                       ; UNKNOWN
03FDC3  8B 87 9A 88           MOV    ax, word ptr [bx - 0x7766]   ; UNKNOWN
03FDC7  6B 9F 98 88 1C        IMUL   bx, word ptr [bx - 0x7768], 0x1c ; UNKNOWN
03FDCC  89 87 9A 88           MOV    word ptr [bx - 0x7766], ax   ; UNKNOWN
03FDD0  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03FDD3  8B 7E FE              MOV    di, word ptr [bp - 2]        ; UNKNOWN
03FDD6  83 BD 9A 88 00        CMP    word ptr [di - 0x7766], 0    ; UNKNOWN
03FDDB  7C 12                 JL     0x3fdef                      ; UNKNOWN
03FDDD  8B DF                 MOV    bx, di                       ; UNKNOWN
03FDDF  8B 87 98 88           MOV    ax, word ptr [bx - 0x7768]   ; UNKNOWN
03FDE3  6B 9F 9A 88 1C        IMUL   bx, word ptr [bx - 0x7766], 0x1c ; UNKNOWN
03FDE8  89 87 98 88           MOV    word ptr [bx - 0x7768], ax   ; UNKNOWN
03FDEC  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03FDEF  0B DB                 OR     bx, bx                       ; UNKNOWN
03FDF1  75 36                 JNE    0x3fe29                      ; UNKNOWN
03FDF3  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
03FDF6  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03FDFA  2A E4                 SUB    ah, ah                       ; UNKNOWN
03FDFC  50                    PUSH   ax                           ; UNKNOWN
03FDFD  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03FE01  50                    PUSH   ax                           ; UNKNOWN
03FE02  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
03FE07  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03FE0A  0B C0                 OR     ax, ax                       ; UNKNOWN
03FE0C  74 1B                 JE     0x3fe29                      ; UNKNOWN
03FE0E  6A 00                 PUSH   0                            ; UNKNOWN
03FE10  6A 01                 PUSH   1                            ; UNKNOWN
03FE12  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
03FE15  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03FE19  2A E4                 SUB    ah, ah                       ; UNKNOWN
03FE1B  50                    PUSH   ax                           ; UNKNOWN
03FE1C  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03FE20  50                    PUSH   ax                           ; UNKNOWN
03FE21  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
03FE26  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03FE29  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
03FE2B  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
03FE2E  88 87 80 88           MOV    byte ptr [bx - 0x7780], al   ; UNKNOWN
03FE32  88 87 81 88           MOV    byte ptr [bx - 0x777f], al   ; UNKNOWN
03FE36  5E                    POP    si                           ; UNKNOWN
03FE37  5F                    POP    di                           ; UNKNOWN
03FE38  C9                    LEAVE                               ; UNKNOWN
03FE39  CB                    RETF                                ; UNKNOWN
