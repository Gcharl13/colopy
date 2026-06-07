; ============================================================================
; func_053B14_unknown
; Region   : overlay
; Bytes    : file 0x053B14..0x053B26  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053B14  55                    PUSH   bp ; STACK_PUSH
053B15  8B EC                 MOV    bp, sp ; MOV
053B17  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053B1B  80 67 1C 7F           AND    byte ptr [bx + 0x1c], 0x7f ; LOGIC
053B1F  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
053B22  04 1F                 ADD    al, 0x1f ; ARITH
053B24  C9                    LEAVE ; EPILOGUE
053B25  CB                    RETF ; RETURN
