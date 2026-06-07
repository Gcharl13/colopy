; ============================================================================
; func_003514_unknown
; Region   : load_image
; Bytes    : file 0x003514..0x00351F  (11 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003514  55                    PUSH   bp ; STACK_PUSH
003515  8B EC                 MOV    bp, sp ; MOV
003517  53                    PUSH   bx ; STACK_PUSH
003518  50                    PUSH   ax ; STACK_PUSH
003519  57                    PUSH   di ; STACK_PUSH
00351A  56                    PUSH   si ; STACK_PUSH
00351B  8B FA                 MOV    di, dx ; MOV
00351D  9A                    DB     0x9A ; DATA_BYTE
00351E  CB                    DB     0xCB ; DATA_BYTE
