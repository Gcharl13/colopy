; ============================================================================
; func_04C1F0_unknown
; Region   : overlay
; Bytes    : file 0x04C1F0..0x04C20B  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C1F0  55                    PUSH   bp ; STACK_PUSH
04C1F1  8B EC                 MOV    bp, sp ; MOV
04C1F3  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C1F6  C1 E3 06              SHL    bx, 6 ; LOGIC
04C1F9  03 5E 08              ADD    bx, word ptr [bp + 8] ; ARITH
04C1FC  C1 E3 02              SHL    bx, 2 ; LOGIC
04C1FF  C6 87 B2 98 FF        MOV    byte ptr [bx - 0x674e], 0xff ; CONST_LOAD
04C204  C6 87 B3 98 00        MOV    byte ptr [bx - 0x674d], 0 ; MOV
04C209  C9                    LEAVE ; EPILOGUE
04C20A  CB                    RETF ; RETURN
