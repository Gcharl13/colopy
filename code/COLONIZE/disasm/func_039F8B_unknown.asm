; ============================================================================
; func_039F8B_unknown
; Region   : load_image
; Bytes    : file 0x039F8B..0x039FD3  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039F8B  55                    PUSH   bp                           ; UNKNOWN
039F8C  8B EC                 MOV    bp, sp                       ; UNKNOWN
039F8E  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
039F91  0B C0                 OR     ax, ax                       ; UNKNOWN
039F93  7D 02                 JGE    0x39f97                      ; UNKNOWN
039F95  2B C0                 SUB    ax, ax                       ; UNKNOWN
039F97  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
039F9A  83 F8 03              CMP    ax, 3                        ; UNKNOWN
039F9D  7E 03                 JLE    0x39fa2                      ; UNKNOWN
039F9F  B8 03 00              MOV    ax, 3                        ; UNKNOWN
039FA2  89 46 06              MOV    word ptr [bp + 6], ax        ; UNKNOWN
039FA5  A3 34 0B              MOV    word ptr [0xb34], ax         ; UNKNOWN
039FA8  9A 06 00 98 3A        LCALL  0x3a98, 6                    ; UNKNOWN
039FAD  6A 00                 PUSH   0                            ; UNKNOWN
039FAF  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
039FB3  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
039FB7  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
039FBB  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
039FBF  9A F9 02 0B 38        LCALL  0x380b, 0x2f9                ; UNKNOWN
039FC4  8B E5                 MOV    sp, bp                       ; UNKNOWN
039FC6  0B C0                 OR     ax, ax                       ; UNKNOWN
039FC8  75 07                 JNE    0x39fd1                      ; UNKNOWN
039FCA  6A 01                 PUSH   1                            ; UNKNOWN
039FCC  9A C6 00 E4 35        LCALL  0x35e4, 0xc6                 ; UNKNOWN
039FD1  C9                    LEAVE                               ; UNKNOWN
039FD2  CB                    RETF                                ; UNKNOWN
