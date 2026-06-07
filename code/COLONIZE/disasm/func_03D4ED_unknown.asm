; ============================================================================
; func_03D4ED_unknown
; Region   : load_image
; Bytes    : file 0x03D4ED..0x03D578  (139 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D4ED  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03D4F1  6A 10                 PUSH   0x10                         ; UNKNOWN
03D4F3  6A 01                 PUSH   1                            ; UNKNOWN
03D4F5  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D4FA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D4FD  40                    INC    ax                           ; UNKNOWN
03D4FE  40                    INC    ax                           ; UNKNOWN
03D4FF  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D502  EB 63                 JMP    0x3d567                      ; UNKNOWN
03D504  A0 56 85              MOV    al, byte ptr [0x8556]        ; UNKNOWN
03D507  98                    CWDE                                ; UNKNOWN
03D508  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D50B  7D 64                 JGE    0x3d571                      ; UNKNOWN
03D50D  A0 54 85              MOV    al, byte ptr [0x8554]        ; UNKNOWN
03D510  98                    CWDE                                ; UNKNOWN
03D511  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D514  7E 5B                 JLE    0x3d571                      ; UNKNOWN
03D516  A0 57 85              MOV    al, byte ptr [0x8557]        ; UNKNOWN
03D519  98                    CWDE                                ; UNKNOWN
03D51A  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03D51D  7D 52                 JGE    0x3d571                      ; UNKNOWN
03D51F  A0 55 85              MOV    al, byte ptr [0x8555]        ; UNKNOWN
03D522  98                    CWDE                                ; UNKNOWN
03D523  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03D526  7E 49                 JLE    0x3d571                      ; UNKNOWN
03D528  FF 36 12 83           PUSH   word ptr [0x8312]            ; UNKNOWN
03D52C  FF 36 10 83           PUSH   word ptr [0x8310]            ; UNKNOWN
03D530  FF 36 0E 83           PUSH   word ptr [0x830e]            ; UNKNOWN
03D534  FF 36 0C 83           PUSH   word ptr [0x830c]            ; UNKNOWN
03D538  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03D53B  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
03D53E  BB 01 00              MOV    bx, 1                        ; UNKNOWN
03D541  9A 08 00 73 5A        LCALL  0x5a73, 8                    ; UNKNOWN
03D546  6A 04                 PUSH   4                            ; UNKNOWN
03D548  6A 01                 PUSH   1                            ; UNKNOWN
03D54A  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D54F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D552  8B D8                 MOV    bx, ax                       ; UNKNOWN
03D554  4B                    DEC    bx                           ; UNKNOWN
03D555  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03D557  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03D55B  98                    CWDE                                ; UNKNOWN
03D55C  01 46 06              ADD    word ptr [bp + 6], ax        ; UNKNOWN
03D55F  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
03D563  98                    CWDE                                ; UNKNOWN
03D564  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
03D567  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D56A  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
03D56D  0B C0                 OR     ax, ax                       ; UNKNOWN
03D56F  75 93                 JNE    0x3d504                      ; UNKNOWN
03D571  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03D576  C9                    LEAVE                               ; UNKNOWN
03D577  CB                    RETF                                ; UNKNOWN
