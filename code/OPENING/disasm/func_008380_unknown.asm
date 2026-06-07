; ============================================================================
; func_008380_unknown
; Region   : load_image
; Bytes    : file 0x008380..0x00838E  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008380  55                    PUSH   bp ; STACK_PUSH
008381  8B EC                 MOV    bp, sp ; MOV
008383  50                    PUSH   ax ; STACK_PUSH
008384  57                    PUSH   di ; STACK_PUSH
008385  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
008388  2B D2                 SUB    dx, dx ; ARITH
00838A  8B CA                 MOV    cx, dx ; MOV
00838C  BB                    DB     0xBB ; DATA_BYTE
00838D  4C                    DB     0x4C ; DATA_BYTE
