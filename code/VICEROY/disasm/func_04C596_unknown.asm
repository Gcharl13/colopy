; ============================================================================
; func_04C596_unknown
; Region   : overlay
; Bytes    : file 0x04C596..0x04C5C0  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C596  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C59A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C59F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C5A2  C1 E3 04              SHL    bx, 4 ; LOGIC
04C5A5  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C5A8  C1 E3 02              SHL    bx, 2 ; LOGIC
04C5AB  C6 87 AC 9E FF        MOV    byte ptr [bx - 0x6154], 0xff ; CONST_LOAD
04C5B0  C6 87 AD 9E 00        MOV    byte ptr [bx - 0x6153], 0 ; MOV
04C5B5  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C5B8  83 7E FE 10           CMP    word ptr [bp - 2], 0x10 ; CMP
04C5BC  7C E1                 JL     0x4c59f ; CJUMP
04C5BE  C9                    LEAVE ; EPILOGUE
04C5BF  CB                    RETF ; RETURN
