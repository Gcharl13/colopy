; ============================================================================
; func_06F554_unknown
; Region   : overlay
; Bytes    : file 0x06F554..0x06F56D  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F554  55                    PUSH   bp ; STACK_PUSH
06F555  8B EC                 MOV    bp, sp ; MOV
06F557  50                    PUSH   ax ; STACK_PUSH
06F558  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
06F55B  0B D2                 OR     dx, dx ; LOGIC
06F55D  74 0F                 JE     0x6f56e ; CJUMP
06F55F  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
06F562  B8 01 00              MOV    ax, 1 ; MOV
06F565  D3 E0                 SHL    ax, cl ; LOGIC
06F567  09 06 54 1F           OR     word ptr [0x1f54], ax ; LOGIC
06F56B  C9                    LEAVE ; EPILOGUE
06F56C  CB                    RETF ; RETURN
