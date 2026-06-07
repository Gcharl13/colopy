; ============================================================================
; func_008262_unknown
; Region   : load_image
; Bytes    : file 0x008262..0x008276  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008262  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
008266  83 7E 06 19           CMP    word ptr [bp + 6], 0x19 ; CMP
00826A  7D 0A                 JGE    0x8276 ; CJUMP
00826C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
008271  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008274  C9                    LEAVE ; EPILOGUE
008275  CB                    RETF ; RETURN
