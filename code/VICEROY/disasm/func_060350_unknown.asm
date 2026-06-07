; ============================================================================
; func_060350_unknown
; Region   : overlay
; Bytes    : file 0x060350..0x060370  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060350  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
060354  83 7E 06 06           CMP    word ptr [bp + 6], 6 ; CMP
060358  7C 16                 JL     0x60370 ; CJUMP
06035A  83 6E 06 06           SUB    word ptr [bp + 6], 6 ; ARITH
06035E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
060361  D1 F8                 SAR    ax, 1 ; LOGIC
060363  03 06 18 9E           ADD    ax, word ptr [0x9e18] ; ARITH
060367  8B 16 1A 9E           MOV    dx, word ptr [0x9e1a] ; GLOBAL_LOAD
06036B  05 03 00              ADD    ax, 3 ; ARITH
06036E  C9                    LEAVE ; EPILOGUE
06036F  CB                    RETF ; RETURN
