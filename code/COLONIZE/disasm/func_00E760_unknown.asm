; ============================================================================
; func_00E760_unknown
; Region   : load_image
; Bytes    : file 0x00E760..0x00E7AA  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E760  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
00E764  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
00E769  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
00E76C  8B 56 0A              MOV    dx, word ptr [bp + 0xa]      ; UNKNOWN
00E76F  05 FF 3F              ADD    ax, 0x3fff                   ; UNKNOWN
00E772  83 D2 00              ADC    dx, 0                        ; UNKNOWN
00E775  D1 E0                 SHL    ax, 1                        ; UNKNOWN
00E777  D1 D2                 RCL    dx, 1                        ; UNKNOWN
00E779  D1 E0                 SHL    ax, 1                        ; UNKNOWN
00E77B  D1 D2                 RCL    dx, 1                        ; UNKNOWN
00E77D  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
00E780  83 3E C8 05 08        CMP    word ptr [0x5c8], 8          ; UNKNOWN
00E785  7D 34                 JGE    0xe7bb                       ; UNKNOWN
00E787  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
00E78A  B4 43                 MOV    ah, 0x43                     ; UNKNOWN
00E78C  CD 67                 INT    0x67                         ; UNKNOWN
00E78E  8A C4                 MOV    al, ah                       ; UNKNOWN
00E790  32 E4                 XOR    ah, ah                       ; UNKNOWN
00E792  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00E795  0B C0                 OR     ax, ax                       ; UNKNOWN
00E797  75 22                 JNE    0xe7bb                       ; UNKNOWN
00E799  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
00E79C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
00E79F  8B 1E C8 05           MOV    bx, word ptr [0x5c8]         ; UNKNOWN
00E7A3  D1 E3                 SHL    bx, 1                        ; UNKNOWN
00E7A5  89 87 CA 05           MOV    word ptr [bx + 0x5ca], ax    ; UNKNOWN
00E7A9  FF                    DB     0xFF                         ; UNKNOWN (raw)
