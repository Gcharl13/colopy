; ============================================================================
; func_04497C_unknown
; Region   : load_image
; Bytes    : file 0x04497C..0x044A01  (133 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04497C  55                    PUSH   bp                           ; UNKNOWN
04497D  8B EC                 MOV    bp, sp                       ; UNKNOWN
04497F  50                    PUSH   ax                           ; UNKNOWN
044980  0E                    PUSH   cs                           ; UNKNOWN
044981  E8 02 F0              CALL   0x43986                      ; UNKNOWN
044984  83 3E 82 82 00        CMP    word ptr [0x8282], 0         ; UNKNOWN
044989  75 07                 JNE    0x44992                      ; UNKNOWN
04498B  83 3E 84 82 00        CMP    word ptr [0x8284], 0         ; UNKNOWN
044990  74 57                 JE     0x449e9                      ; UNKNOWN
044992  83 3E 4A 0A 00        CMP    word ptr [0xa4a], 0          ; UNKNOWN
044997  74 39                 JE     0x449d2                      ; UNKNOWN
044999  6A F8                 PUSH   -8                           ; UNKNOWN
04499B  6A 00                 PUSH   0                            ; UNKNOWN
04499D  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
0449A1  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
0449A5  6A 00                 PUSH   0                            ; UNKNOWN
0449A7  6A 00                 PUSH   0                            ; UNKNOWN
0449A9  8B 1E 4A 0A           MOV    bx, word ptr [0xa4a]         ; UNKNOWN
0449AD  FF 77 06              PUSH   word ptr [bx + 6]            ; UNKNOWN
0449B0  FF 77 04              PUSH   word ptr [bx + 4]            ; UNKNOWN
0449B3  FF 77 02              PUSH   word ptr [bx + 2]            ; UNKNOWN
0449B6  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
0449B8  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
0449BC  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
0449C0  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
0449C4  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
0449C8  9A 0C 00 B6 5A        LCALL  0x5ab6, 0xc                  ; UNKNOWN
0449CD  83 C4 1C              ADD    sp, 0x1c                     ; UNKNOWN
0449D0  EB 17                 JMP    0x449e9                      ; UNKNOWN
0449D2  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
0449D6  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
0449DA  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
0449DE  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
0449E2  2A C0                 SUB    al, al                       ; UNKNOWN
0449E4  9A 02 00 47 5A        LCALL  0x5a47, 2                    ; UNKNOWN
0449E9  FF 36 92 82           PUSH   word ptr [0x8292]            ; UNKNOWN
0449ED  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
0449F0  A1 80 82              MOV    ax, word ptr [0x8280]        ; UNKNOWN
0449F3  8B 16 86 82           MOV    dx, word ptr [0x8286]        ; UNKNOWN
0449F7  8B 1E 90 82           MOV    bx, word ptr [0x8290]        ; UNKNOWN
0449FB  0E                    PUSH   cs                           ; UNKNOWN
0449FC  E8 C6 FC              CALL   0x446c5                      ; UNKNOWN
0449FF  C9                    LEAVE                               ; UNKNOWN
044A00  CB                    RETF                                ; UNKNOWN
