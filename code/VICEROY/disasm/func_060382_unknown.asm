; ============================================================================
; func_060382_unknown
; Region   : overlay
; Bytes    : file 0x060382..0x06039A  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060382  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
060386  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
06038A  74 0E                 JE     0x6039a ; CJUMP
06038C  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
060390  26 8A 47 02           MOV    al, byte ptr es:[bx + 2] ; MOV
060394  C0 F8 04              SAR    al, 4 ; LOGIC
060397  98                    CWDE ; ARITH
060398  C9                    LEAVE ; EPILOGUE
060399  CB                    RETF ; RETURN
