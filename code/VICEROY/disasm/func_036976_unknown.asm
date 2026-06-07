; ============================================================================
; func_036976_unknown
; Region   : overlay
; Bytes    : file 0x036976..0x03698E  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036976  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03697A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
03697D  8B 07                 MOV    ax, word ptr [bx] ; MOV
03697F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
036982  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
036985  D1 E8                 SHR    ax, 1 ; LOGIC
036987  73 03                 JAE    0x3698c ; CJUMP
036989  33 46 08              XOR    ax, word ptr [bp + 8] ; LOGIC
03698C  C9                    LEAVE ; EPILOGUE
03698D  CB                    RETF ; RETURN
