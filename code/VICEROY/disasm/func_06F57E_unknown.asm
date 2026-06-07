; ============================================================================
; func_06F57E_unknown
; Region   : overlay
; Bytes    : file 0x06F57E..0x06F593  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06F57E  55                    PUSH   bp ; STACK_PUSH
06F57F  8B EC                 MOV    bp, sp ; MOV
06F581  50                    PUSH   ax ; STACK_PUSH
06F582  B8 01 00              MOV    ax, 1 ; MOV
06F585  29 46 FE              SUB    word ptr [bp - 2], ax ; ARITH
06F588  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
06F58B  D3 E0                 SHL    ax, cl ; LOGIC
06F58D  23 06 54 1F           AND    ax, word ptr [0x1f54] ; LOGIC
06F591  C9                    LEAVE ; EPILOGUE
06F592  CB                    RETF ; RETURN
