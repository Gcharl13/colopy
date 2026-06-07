; ============================================================================
; func_009786_unknown
; Region   : load_image
; Bytes    : file 0x009786..0x009792  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009786  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00978A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00978D  8A 87 CA 02           MOV    al, byte ptr [bx + 0x2ca] ; MOV
009791  98                    CWDE ; ARITH
