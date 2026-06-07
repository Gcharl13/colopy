; ============================================================================
; func_03D36F_unknown
; Region   : load_image
; Bytes    : file 0x03D36F..0x03D3E8  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D36F  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03D373  6A 40                 PUSH   0x40                         ; UNKNOWN
03D375  6A 01                 PUSH   1                            ; UNKNOWN
03D377  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D37C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D37F  40                    INC    ax                           ; UNKNOWN
03D380  40                    INC    ax                           ; UNKNOWN
03D381  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D384  EB 51                 JMP    0x3d3d7                      ; UNKNOWN
03D386  A0 56 85              MOV    al, byte ptr [0x8556]        ; UNKNOWN
03D389  98                    CWDE                                ; UNKNOWN
03D38A  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D38D  7D 52                 JGE    0x3d3e1                      ; UNKNOWN
03D38F  A0 54 85              MOV    al, byte ptr [0x8554]        ; UNKNOWN
03D392  98                    CWDE                                ; UNKNOWN
03D393  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
03D396  7E 49                 JLE    0x3d3e1                      ; UNKNOWN
03D398  A0 57 85              MOV    al, byte ptr [0x8557]        ; UNKNOWN
03D39B  98                    CWDE                                ; UNKNOWN
03D39C  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03D39F  7D 40                 JGE    0x3d3e1                      ; UNKNOWN
03D3A1  A0 55 85              MOV    al, byte ptr [0x8555]        ; UNKNOWN
03D3A4  98                    CWDE                                ; UNKNOWN
03D3A5  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
03D3A8  7E 37                 JLE    0x3d3e1                      ; UNKNOWN
03D3AA  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D3AD  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D3B0  E8 25 FF              CALL   0x3d2d8                      ; UNKNOWN
03D3B3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D3B6  6A 04                 PUSH   4                            ; UNKNOWN
03D3B8  6A 01                 PUSH   1                            ; UNKNOWN
03D3BA  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
03D3BF  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D3C2  8B D8                 MOV    bx, ax                       ; UNKNOWN
03D3C4  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03D3C6  4B                    DEC    bx                           ; UNKNOWN
03D3C7  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
03D3CB  98                    CWDE                                ; UNKNOWN
03D3CC  01 46 06              ADD    word ptr [bp + 6], ax        ; UNKNOWN
03D3CF  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
03D3D3  98                    CWDE                                ; UNKNOWN
03D3D4  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
03D3D7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D3DA  FF 4E FE              DEC    word ptr [bp - 2]            ; UNKNOWN
03D3DD  0B C0                 OR     ax, ax                       ; UNKNOWN
03D3DF  75 A5                 JNE    0x3d386                      ; UNKNOWN
03D3E1  9A 05 03 EF 21        LCALL  0x21ef, 0x305                ; UNKNOWN
03D3E6  C9                    LEAVE                               ; UNKNOWN
03D3E7  CB                    RETF                                ; UNKNOWN
