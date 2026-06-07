; ============================================================================
; func_05FE60_unknown
; Region   : overlay
; Bytes    : file 0x05FE60..0x05FE7A  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05FE60  55                    PUSH   bp ; STACK_PUSH
05FE61  8B EC                 MOV    bp, sp ; MOV
05FE63  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05FE66  A3 5C A1              MOV    word ptr [0xa15c], ax ; GLOBAL_LOAD
05FE69  6B C0 4A              IMUL   ax, ax, 0x4a ; ARITH
05FE6C  05 00 00              ADD    ax, 0 ; ARITH
05FE6F  A3 14 9E              MOV    word ptr [0x9e14], ax ; GLOBAL_LOAD
05FE72  C7 06 16 9E 22 1B     MOV    word ptr [0x9e16], 0x1b22 ; GLOBAL_LOAD
05FE78  C9                    LEAVE ; EPILOGUE
05FE79  CB                    RETF ; RETURN
