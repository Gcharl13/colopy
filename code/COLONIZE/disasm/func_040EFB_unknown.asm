; ============================================================================
; func_040EFB_unknown
; Region   : load_image
; Bytes    : file 0x040EFB..0x040F4E  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040EFB  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040EFF  57                    PUSH   di                           ; UNKNOWN
040F00  56                    PUSH   si                           ; UNKNOWN
040F01  8B F0                 MOV    si, ax                       ; UNKNOWN
040F03  2B DB                 SUB    bx, bx                       ; UNKNOWN
040F05  0B F6                 OR     si, si                       ; UNKNOWN
040F07  7C 4B                 JL     0x40f54                      ; UNKNOWN
040F09  39 36 14 3E           CMP    word ptr [0x3e14], si        ; UNKNOWN
040F0D  7E 45                 JLE    0x40f54                      ; UNKNOWN
040F0F  6B FE 1C              IMUL   di, si, 0x1c                 ; UNKNOWN
040F12  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
040F15  80 BD 80 88 00        CMP    byte ptr [di - 0x7780], 0    ; UNKNOWN
040F1A  7C 38                 JL     0x40f54                      ; UNKNOWN
040F1C  8B DF                 MOV    bx, di                       ; UNKNOWN
040F1E  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
040F22  24 0F                 AND    al, 0xf                      ; UNKNOWN
040F24  3A 06 0C 3E           CMP    al, byte ptr [0x3e0c]        ; UNKNOWN
040F28  75 28                 JNE    0x40f52                      ; UNKNOWN
040F2A  F6 87 84 88 80        TEST   byte ptr [bx - 0x777c], 0x80 ; UNKNOWN
040F2F  74 07                 JE     0x40f38                      ; UNKNOWN
040F31  80 BF 82 88 0B        CMP    byte ptr [bx - 0x777e], 0xb  ; UNKNOWN
040F36  75 1A                 JNE    0x40f52                      ; UNKNOWN
040F38  56                    PUSH   si                           ; UNKNOWN
040F39  0E                    PUSH   cs                           ; UNKNOWN
040F3A  E8 87 F2              CALL   0x401c4                      ; UNKNOWN
040F3D  83 C4 02              ADD    sp, 2                        ; UNKNOWN
040F40  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
040F43  38 87 85 88           CMP    byte ptr [bx - 0x777b], al   ; UNKNOWN
040F47  73 09                 JAE    0x40f52                      ; UNKNOWN
040F49  BB 01 00              MOV    bx, 1                        ; UNKNOWN
040F4C  8B C3                 MOV    ax, bx                       ; UNKNOWN
