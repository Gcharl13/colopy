; ============================================================================
; func_008BC6_unknown
; Region   : load_image
; Bytes    : file 0x008BC6..0x008BD3  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008BC6  55                    PUSH   bp ; STACK_PUSH
008BC7  8B EC                 MOV    bp, sp ; MOV
008BC9  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
008BCC  8A 87 F5 02           MOV    al, byte ptr [bx + 0x2f5] ; MOV
008BD0  98                    CWDE ; ARITH
008BD1  C9                    LEAVE ; EPILOGUE
008BD2  CB                    RETF ; RETURN
