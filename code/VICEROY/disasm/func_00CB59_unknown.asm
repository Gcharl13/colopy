; ============================================================================
; func_00CB59_unknown
; Region   : load_image
; Bytes    : file 0x00CB59..0x00CB72  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CB59  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
00CB5D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00CB60  25 0F 00              AND    ax, 0xf ; LOGIC
00CB63  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
00CB66  83 E3 0F              AND    bx, 0xf ; LOGIC
00CB69  A3 90 05              MOV    word ptr [0x590], ax ; GLOBAL_LOAD
00CB6C  89 1E 92 05           MOV    word ptr [0x592], bx ; GLOBAL_LOAD
00CB70  C9                    LEAVE ; EPILOGUE
00CB71  CB                    RETF ; RETURN
