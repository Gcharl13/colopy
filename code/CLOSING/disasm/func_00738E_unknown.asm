; ============================================================================
; func_00738E_unknown
; Region   : load_image
; Bytes    : file 0x00738E..0x00739C  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00738E  55                    PUSH   bp ; STACK_PUSH
00738F  8B EC                 MOV    bp, sp ; MOV
007391  50                    PUSH   ax ; STACK_PUSH
007392  57                    PUSH   di ; STACK_PUSH
007393  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
007396  2B D2                 SUB    dx, dx ; ARITH
007398  8B CA                 MOV    cx, dx ; MOV
00739A  BB                    DB     0xBB ; DATA_BYTE
00739B  F6                    DB     0xF6 ; DATA_BYTE
