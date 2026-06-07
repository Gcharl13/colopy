; ============================================================================
; func_04C50C_unknown
; Region   : overlay
; Bytes    : file 0x04C50C..0x04C51A  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C50C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C510  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C515  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
04C518  8B C3                 MOV    ax, bx ; MOV
