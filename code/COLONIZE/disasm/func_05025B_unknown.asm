; ============================================================================
; func_05025B_unknown
; Region   : load_image
; Bytes    : file 0x05025B..0x050274  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05025B  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
05025F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
050264  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
050267  C1 E3 04              SHL    bx, 4                        ; UNKNOWN
05026A  03 5E FE              ADD    bx, word ptr [bp - 2]        ; UNKNOWN
05026D  C1 E3 02              SHL    bx, 2                        ; UNKNOWN
050270  C6                    DB     0xC6                         ; UNKNOWN (raw)
050271  87                    DB     0x87                         ; UNKNOWN (raw)
050272  3C                    DB     0x3C                         ; UNKNOWN (raw)
050273  CB                    DB     0xCB                         ; UNKNOWN (raw)
