; ============================================================================
; func_002BC8_unknown
; Region   : load_image
; Bytes    : file 0x002BC8..0x002C0C  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002BC8  55                    PUSH   bp ; STACK_PUSH
002BC9  8B EC                 MOV    bp, sp ; MOV
002BCB  57                    PUSH   di ; STACK_PUSH
002BCC  56                    PUSH   si ; STACK_PUSH
002BCD  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002BD0  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
002BD3  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
002BD6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002BD9  50                    PUSH   ax ; STACK_PUSH
002BDA  57                    PUSH   di ; STACK_PUSH
002BDB  8B F0                 MOV    si, ax ; MOV
002BDD  0E                    PUSH   cs ; STACK_PUSH
002BDE  E8 E5 FE              CALL   0x2ac6 ; CALL_NEAR
002BE1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002BE4  D1 F8                 SAR    ax, 1 ; LOGIC
002BE6  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
002BE9  D1 F9                 SAR    cx, 1 ; LOGIC
002BEB  8B D6                 MOV    dx, si ; MOV
002BED  8B F1                 MOV    si, cx ; MOV
002BEF  2B F0                 SUB    si, ax ; ARITH
002BF1  03 76 0A              ADD    si, word ptr [bp + 0xa] ; ARITH
002BF4  8B C6                 MOV    ax, si ; MOV
002BF6  0B C0                 OR     ax, ax ; LOGIC
002BF8  7D 02                 JGE    0x2bfc ; CJUMP
002BFA  2B C0                 SUB    ax, ax ; ARITH
002BFC  8B F0                 MOV    si, ax ; MOV
002BFE  56                    PUSH   si ; STACK_PUSH
002BFF  52                    PUSH   dx ; STACK_PUSH
002C00  57                    PUSH   di ; STACK_PUSH
002C01  0E                    PUSH   cs ; STACK_PUSH
002C02  E8 33 FF              CALL   0x2b38 ; CALL_NEAR
002C05  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
002C08  5E                    POP    si ; STACK_POP
002C09  5F                    POP    di ; STACK_POP
002C0A  C9                    LEAVE ; EPILOGUE
002C0B  CB                    RETF ; RETURN
