; ============================================================================
; func_012A36_unknown
; Region   : load_image
; Bytes    : file 0x012A36..0x012A44  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012A36  55                    PUSH   bp ; STACK_PUSH
012A37  8B EC                 MOV    bp, sp ; MOV
012A39  50                    PUSH   ax ; STACK_PUSH
012A3A  57                    PUSH   di ; STACK_PUSH
012A3B  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
012A3E  2B D2                 SUB    dx, dx ; ARITH
012A40  8B CA                 MOV    cx, dx ; MOV
012A42  BB                    DB     0xBB ; DATA_BYTE
012A43  F0                    DB     0xF0 ; DATA_BYTE
