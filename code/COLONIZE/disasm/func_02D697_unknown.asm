; ============================================================================
; func_02D697_unknown
; Region   : load_image
; Bytes    : file 0x02D697..0x02D735  (158 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D697  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
02D69B  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff    ; UNKNOWN
02D6A0  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D6A2  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02D6A5  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
02D6A8  EB 7D                 JMP    0x2d727                      ; UNKNOWN
02D6AA  8B 5E F6              MOV    bx, word ptr [bp - 0xa]      ; UNKNOWN
02D6AD  8A 87 2F 09           MOV    al, byte ptr [bx + 0x92f]    ; UNKNOWN
02D6B1  98                    CWDE                                ; UNKNOWN
02D6B2  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02D6B5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02D6B8  50                    PUSH   ax                           ; UNKNOWN
02D6B9  8A 87 26 09           MOV    al, byte ptr [bx + 0x926]    ; UNKNOWN
02D6BD  98                    CWDE                                ; UNKNOWN
02D6BE  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
02D6C1  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02D6C4  50                    PUSH   ax                           ; UNKNOWN
02D6C5  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
02D6CA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D6CD  0B C0                 OR     ax, ax                       ; UNKNOWN
02D6CF  74 53                 JE     0x2d724                      ; UNKNOWN
02D6D1  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02D6D4  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02D6D7  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
02D6DC  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D6DF  0B C0                 OR     ax, ax                       ; UNKNOWN
02D6E1  74 41                 JE     0x2d724                      ; UNKNOWN
02D6E3  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1         ; UNKNOWN
02D6E8  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02D6EB  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02D6EE  9A BC 01 C9 33        LCALL  0x33c9, 0x1bc                ; UNKNOWN
02D6F3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02D6F6  2A E4                 SUB    ah, ah                       ; UNKNOWN
02D6F8  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02D6FB  0B C0                 OR     ax, ax                       ; UNKNOWN
02D6FD  75 05                 JNE    0x2d704                      ; UNKNOWN
02D6FF  C7 46 F4 10 00        MOV    word ptr [bp - 0xc], 0x10    ; UNKNOWN
02D704  83 7E F8 00           CMP    word ptr [bp - 8], 0         ; UNKNOWN
02D708  7C 08                 JL     0x2d712                      ; UNKNOWN
02D70A  8B 46 F8              MOV    ax, word ptr [bp - 8]        ; UNKNOWN
02D70D  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
02D710  7D 12                 JGE    0x2d724                      ; UNKNOWN
02D712  8B 46 F4              MOV    ax, word ptr [bp - 0xc]      ; UNKNOWN
02D715  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
02D718  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02D71B  A3 7A 73              MOV    word ptr [0x737a], ax        ; UNKNOWN
02D71E  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
02D721  A3 7C 73              MOV    word ptr [0x737c], ax        ; UNKNOWN
02D724  FF 46 F6              INC    word ptr [bp - 0xa]          ; UNKNOWN
02D727  83 7E F6 08           CMP    word ptr [bp - 0xa], 8       ; UNKNOWN
02D72B  7D 03                 JGE    0x2d730                      ; UNKNOWN
02D72D  E9 7A FF              JMP    0x2d6aa                      ; UNKNOWN
02D730  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02D733  C9                    LEAVE                               ; UNKNOWN
02D734  CB                    RETF                                ; UNKNOWN
