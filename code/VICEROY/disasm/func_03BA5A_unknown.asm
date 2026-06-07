; ============================================================================
; func_03BA5A_unknown
; Region   : overlay
; Bytes    : file 0x03BA5A..0x03BA78  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03BA5A  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
03BA5E  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
03BA61  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03BA64  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
03BA67  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; ARITH
03BA6C  80 BF 1C 88 19        CMP    byte ptr [bx - 0x77e4], 0x19 ; CMP
03BA71  72 05                 JB     0x3ba78 ; CJUMP
03BA73  B8 05 00              MOV    ax, 5 ; MOV
03BA76  C9                    LEAVE ; EPILOGUE
03BA77  CB                    RETF ; RETURN
