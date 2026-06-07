; ============================================================================
; func_04E562_unknown
; Region   : load_image
; Bytes    : file 0x04E562..0x04E64E  (236 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E562  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
04E566  56                    PUSH   si                           ; UNKNOWN
04E567  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
04E56C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04E570  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
04E574  2A E4                 SUB    ah, ah                       ; UNKNOWN
04E576  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04E579  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
04E57D  2A ED                 SUB    ch, ch                       ; UNKNOWN
04E57F  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
04E582  51                    PUSH   cx                           ; UNKNOWN
04E583  50                    PUSH   ax                           ; UNKNOWN
04E584  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
04E589  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E58C  0B C0                 OR     ax, ax                       ; UNKNOWN
04E58E  75 03                 JNE    0x4e593                      ; UNKNOWN
04E590  E9 B5 00              JMP    0x4e648                      ; UNKNOWN
04E593  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
04E597  80 BF 82 88 00        CMP    byte ptr [bx - 0x777e], 0    ; UNKNOWN
04E59C  74 03                 JE     0x4e5a1                      ; UNKNOWN
04E59E  E9 A7 00              JMP    0x4e648                      ; UNKNOWN
04E5A1  80 BF 97 88 1B        CMP    byte ptr [bx - 0x7769], 0x1b ; UNKNOWN
04E5A6  74 03                 JE     0x4e5ab                      ; UNKNOWN
04E5A8  E9 9D 00              JMP    0x4e648                      ; UNKNOWN
04E5AB  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04E5AE  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04E5B1  8B F3                 MOV    si, bx                       ; UNKNOWN
04E5B3  9A D1 03 C9 33        LCALL  0x33c9, 0x3d1                ; UNKNOWN
04E5B8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E5BB  0B C0                 OR     ax, ax                       ; UNKNOWN
04E5BD  7C 03                 JL     0x4e5c2                      ; UNKNOWN
04E5BF  E9 86 00              JMP    0x4e648                      ; UNKNOWN
04E5C2  6A 02                 PUSH   2                            ; UNKNOWN
04E5C4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04E5C7  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
04E5CC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E5CF  83 F8 02              CMP    ax, 2                        ; UNKNOWN
04E5D2  7D 74                 JGE    0x4e648                      ; UNKNOWN
04E5D4  FE 84 96 88           INC    byte ptr [si - 0x776a]       ; UNKNOWN
04E5D8  80 BC 96 88 08        CMP    byte ptr [si - 0x776a], 8    ; UNKNOWN
04E5DD  76 69                 JBE    0x4e648                      ; UNKNOWN
04E5DF  8A 84 83 88           MOV    al, byte ptr [si - 0x777d]   ; UNKNOWN
04E5E3  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
04E5E6  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
04E5E9  83 F8 04              CMP    ax, 4                        ; UNKNOWN
04E5EC  7D 18                 JGE    0x4e606                      ; UNKNOWN
04E5EE  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
04E5F1  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04E5F6  75 0E                 JNE    0x4e606                      ; UNKNOWN
04E5F8  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04E5FB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04E5FE  9A AF 03 0B 38        LCALL  0x380b, 0x3af                ; UNKNOWN
04E603  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E606  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04E609  9A 1C 08 B7 36        LCALL  0x36b7, 0x81c                ; UNKNOWN
04E60E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04E611  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
04E616  83 7E F8 04           CMP    word ptr [bp - 8], 4         ; UNKNOWN
04E61A  7D 2C                 JGE    0x4e648                      ; UNKNOWN
04E61C  6B 5E F8 34           IMUL   bx, word ptr [bp - 8], 0x34  ; UNKNOWN
04E620  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
04E625  75 21                 JNE    0x4e648                      ; UNKNOWN
04E627  6A 01                 PUSH   1                            ; UNKNOWN
04E629  6A 01                 PUSH   1                            ; UNKNOWN
04E62B  6A 01                 PUSH   1                            ; UNKNOWN
04E62D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
04E630  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
04E633  9A 0C 00 E4 35        LCALL  0x35e4, 0xc                  ; UNKNOWN
04E638  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
04E63B  6A 04                 PUSH   4                            ; UNKNOWN
04E63D  68 BC 29              PUSH   0x29bc                       ; UNKNOWN
04E640  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
04E645  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04E648  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
04E64B  5E                    POP    si                           ; UNKNOWN
04E64C  C9                    LEAVE                               ; UNKNOWN
04E64D  CB                    RETF                                ; UNKNOWN
