; ============================================================================
; func_05FE7A_unknown
; Region   : overlay
; Bytes    : file 0x05FE7A..0x05FEA0  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05FE7A  55                    PUSH   bp ; STACK_PUSH
05FE7B  8B EC                 MOV    bp, sp ; MOV
05FE7D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05FE80  A3 5E A1              MOV    word ptr [0xa15e], ax ; GLOBAL_LOAD
05FE83  8B C8                 MOV    cx, ax ; MOV
05FE85  C1 E0 02              SHL    ax, 2 ; LOGIC
05FE88  03 C1                 ADD    ax, cx ; ARITH
05FE8A  D1 E0                 SHL    ax, 1 ; LOGIC
05FE8C  03 06 14 9E           ADD    ax, word ptr [0x9e14] ; ARITH
05FE90  8B 16 16 9E           MOV    dx, word ptr [0x9e16] ; GLOBAL_LOAD
05FE94  05 22 00              ADD    ax, 0x22 ; ARITH
05FE97  A3 18 9E              MOV    word ptr [0x9e18], ax ; GLOBAL_LOAD
05FE9A  89 16 1A 9E           MOV    word ptr [0x9e1a], dx ; GLOBAL_LOAD
05FE9E  C9                    LEAVE ; EPILOGUE
05FE9F  CB                    RETF ; RETURN
