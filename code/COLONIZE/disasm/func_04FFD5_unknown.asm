; ============================================================================
; func_04FFD5_unknown
; Region   : load_image
; Bytes    : file 0x04FFD5..0x050029  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FFD5  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
04FFD9  2B C0                 SUB    ax, ax                       ; UNKNOWN
04FFDB  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04FFDE  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
04FFE1  EB 3B                 JMP    0x5001e                      ; UNKNOWN
04FFE3  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
04FFE6  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
04FFE9  C1 E3 06              SHL    bx, 6                        ; UNKNOWN
04FFEC  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
04FFEF  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
04FFF2  38 87 28 C7           CMP    byte ptr [bx - 0x38d8], al   ; UNKNOWN
04FFF6  75 23                 JNE    0x5001b                      ; UNKNOWN
04FFF8  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
04FFFB  38 87 29 C7           CMP    byte ptr [bx - 0x38d7], al   ; UNKNOWN
04FFFF  75 1A                 JNE    0x5001b                      ; UNKNOWN
050001  8A 46 0C              MOV    al, byte ptr [bp + 0xc]      ; UNKNOWN
050004  38 87 2A C7           CMP    byte ptr [bx - 0x38d6], al   ; UNKNOWN
050008  75 11                 JNE    0x5001b                      ; UNKNOWN
05000A  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
05000D  38 87 2B C7           CMP    byte ptr [bx - 0x38d5], al   ; UNKNOWN
050011  7C 08                 JL     0x5001b                      ; UNKNOWN
050013  8A 87 2B C7           MOV    al, byte ptr [bx - 0x38d5]   ; UNKNOWN
050017  98                    CWDE                                ; UNKNOWN
050018  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
05001B  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
05001E  83 7E FC 40           CMP    word ptr [bp - 4], 0x40      ; UNKNOWN
050022  7C BF                 JL     0x4ffe3                      ; UNKNOWN
050024  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
050027  C9                    LEAVE                               ; UNKNOWN
050028  CB                    RETF                                ; UNKNOWN
