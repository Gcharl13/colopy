; ============================================================================
; func_00C7DF_unknown
; Region   : load_image
; Bytes    : file 0x00C7DF..0x00C7EB  (12 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C7DF  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00C7E3  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00C7E6  A2 83 03              MOV    byte ptr [0x383], al ; GLOBAL_LOAD
00C7E9  C9                    LEAVE ; EPILOGUE
00C7EA  CB                    RETF ; RETURN
