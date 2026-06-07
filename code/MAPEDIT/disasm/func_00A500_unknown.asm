; ============================================================================
; func_00A500_unknown
; Region   : load_image
; Bytes    : file 0x00A500..0x00A547  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A500  55                    PUSH   bp ; STACK_PUSH
00A501  8B EC                 MOV    bp, sp ; MOV
00A503  57                    PUSH   di ; STACK_PUSH
00A504  56                    PUSH   si ; STACK_PUSH
00A505  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00A508  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
00A50B  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00A50E  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00A511  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00A514  50                    PUSH   ax ; STACK_PUSH
00A515  57                    PUSH   di ; STACK_PUSH
00A516  8B F0                 MOV    si, ax ; MOV
00A518  0E                    PUSH   cs ; STACK_PUSH
00A519  E8 E6 FD              CALL   0xa302 ; CALL_NEAR
00A51C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A51F  D1 F8                 SAR    ax, 1 ; LOGIC
00A521  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A524  D1 F9                 SAR    cx, 1 ; LOGIC
00A526  8B D6                 MOV    dx, si ; MOV
00A528  8B F1                 MOV    si, cx ; MOV
00A52A  2B F0                 SUB    si, ax ; ARITH
00A52C  03 76 0A              ADD    si, word ptr [bp + 0xa] ; ARITH
00A52F  8B C6                 MOV    ax, si ; MOV
00A531  0B C0                 OR     ax, ax ; LOGIC
00A533  7D 02                 JGE    0xa537 ; CJUMP
00A535  2B C0                 SUB    ax, ax ; ARITH
00A537  8B F0                 MOV    si, ax ; MOV
00A539  56                    PUSH   si ; STACK_PUSH
00A53A  52                    PUSH   dx ; STACK_PUSH
00A53B  57                    PUSH   di ; STACK_PUSH
00A53C  0E                    PUSH   cs ; STACK_PUSH
00A53D  E8 2A FF              CALL   0xa46a ; CALL_NEAR
00A540  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
00A543  5E                    POP    si ; STACK_POP
00A544  5F                    POP    di ; STACK_POP
00A545  C9                    LEAVE ; EPILOGUE
00A546  CB                    RETF ; RETURN
