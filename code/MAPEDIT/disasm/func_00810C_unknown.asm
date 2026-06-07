; ============================================================================
; func_00810C_unknown
; Region   : load_image
; Bytes    : file 0x00810C..0x008121  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00810C  55                    PUSH   bp ; STACK_PUSH
00810D  8B EC                 MOV    bp, sp ; MOV
00810F  50                    PUSH   ax ; STACK_PUSH
008110  B8 01 00              MOV    ax, 1 ; MOV
008113  29 46 FE              SUB    word ptr [bp - 2], ax ; ARITH
008116  8A 4E FE              MOV    cl, byte ptr [bp - 2] ; LOCAL_LOAD
008119  D3 E0                 SHL    ax, cl ; LOGIC
00811B  23 06 54 05           AND    ax, word ptr [0x554] ; LOGIC
00811F  C9                    LEAVE ; EPILOGUE
008120  CB                    RETF ; RETURN
