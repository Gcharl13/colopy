; ============================================================================
; func_042F82_unknown
; Region   : load_image
; Bytes    : file 0x042F82..0x042FEF  (109 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042F82  C8 12 00 00           ENTER  0x12, 0                      ; UNKNOWN
042F86  57                    PUSH   di                           ; UNKNOWN
042F87  56                    PUSH   si                           ; UNKNOWN
042F88  8A 0E 0E 3E           MOV    cl, byte ptr [0x3e0e]        ; UNKNOWN
042F8C  80 C1 04              ADD    cl, 4                        ; UNKNOWN
042F8F  B0 01                 MOV    al, 1                        ; UNKNOWN
042F91  D2 E0                 SHL    al, cl                       ; UNKNOWN
042F93  88 46 F3              MOV    byte ptr [bp - 0xd], al      ; UNKNOWN
042F96  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
042F99  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
042F9C  48                    DEC    ax                           ; UNKNOWN
042F9D  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
042FA0  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
042FA3  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
042FA6  48                    DEC    ax                           ; UNKNOWN
042FA7  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
042FAA  8D 46 EE              LEA    ax, [bp - 0x12]              ; UNKNOWN
042FAD  50                    PUSH   ax                           ; UNKNOWN
042FAE  8D 46 F0              LEA    ax, [bp - 0x10]              ; UNKNOWN
042FB1  50                    PUSH   ax                           ; UNKNOWN
042FB2  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
042FB5  50                    PUSH   ax                           ; UNKNOWN
042FB6  8D 46 06              LEA    ax, [bp + 6]                 ; UNKNOWN
042FB9  50                    PUSH   ax                           ; UNKNOWN
042FBA  9A 02 00 BE 17        LCALL  0x17be, 2                    ; UNKNOWN
042FBF  83 C4 08              ADD    sp, 8                        ; UNKNOWN
042FC2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
042FC7  83 3E 16 3E 00        CMP    word ptr [0x3e16], 0         ; UNKNOWN
042FCC  7F 03                 JG     0x42fd1                      ; UNKNOWN
042FCE  E9 F2 00              JMP    0x430c3                      ; UNKNOWN
042FD1  C7 46 FC B8 40        MOV    word ptr [bp - 4], 0x40b8    ; UNKNOWN
042FD6  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
042FD9  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
042FDB  2A E4                 SUB    ah, ah                       ; UNKNOWN
042FDD  8B F8                 MOV    di, ax                       ; UNKNOWN
042FDF  8A 4F 01              MOV    cl, byte ptr [bx + 1]        ; UNKNOWN
042FE2  2A ED                 SUB    ch, ch                       ; UNKNOWN
042FE4  8B F1                 MOV    si, cx                       ; UNKNOWN
042FE6  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
042FE9  7D 03                 JGE    0x42fee                      ; UNKNOWN
042FEB  E9 C2 00              JMP    0x430b0                      ; UNKNOWN
042FEE  39                    DB     0x39                         ; UNKNOWN (raw)
