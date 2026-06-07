; ============================================================================
; func_00E7DE_unknown
; Region   : load_image
; Bytes    : file 0x00E7DE..0x00E83A  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E7DE  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
00E7E2  8B 0E 52 05           MOV    cx, word ptr [0x552]         ; UNKNOWN
00E7E6  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
00E7E9  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
00E7EC  99                    CDQ                                 ; UNKNOWN
00E7ED  F7 F9                 IDIV   cx                           ; UNKNOWN
00E7EF  89 56 08              MOV    word ptr [bp + 8], dx        ; UNKNOWN
00E7F2  8B DA                 MOV    bx, dx                       ; UNKNOWN
00E7F4  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
00E7F7  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00E7FA  39 87 5E 05           CMP    word ptr [bx + 0x55e], ax    ; UNKNOWN
00E7FE  75 09                 JNE    0xe809                       ; UNKNOWN
00E800  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
00E803  39 87 60 05           CMP    word ptr [bx + 0x560], ax    ; UNKNOWN
00E807  74 2C                 JE     0xe835                       ; UNKNOWN
00E809  B4 44                 MOV    ah, 0x44                     ; UNKNOWN
00E80B  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
00E80E  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
00E811  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
00E814  CD 67                 INT    0x67                         ; UNKNOWN
00E816  8A C4                 MOV    al, ah                       ; UNKNOWN
00E818  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E81A  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E81D  0B C0                 OR     ax, ax                       ; UNKNOWN
00E81F  75 19                 JNE    0xe83a                       ; UNKNOWN
00E821  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
00E824  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
00E827  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
00E82A  89 87 5E 05           MOV    word ptr [bx + 0x55e], ax    ; UNKNOWN
00E82E  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
00E831  89 87 60 05           MOV    word ptr [bx + 0x560], ax    ; UNKNOWN
00E835  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00E838  C9                    LEAVE                               ; UNKNOWN
00E839  CB                    RETF                                ; UNKNOWN
