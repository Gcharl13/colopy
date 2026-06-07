; ============================================================================
; func_00C899_unknown
; Region   : load_image
; Bytes    : file 0x00C899..0x00C8AB  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C899  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00C89D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00C8A0  A3 F6 92              MOV    word ptr [0x92f6], ax ; GLOBAL_LOAD
00C8A3  C7 06 F4 92 00 00     MOV    word ptr [0x92f4], 0 ; GLOBAL_LOAD
00C8A9  C9                    LEAVE ; EPILOGUE
00C8AA  CB                    RETF ; RETURN
