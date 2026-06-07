; ============================================================================
; func_00A3E8_unknown
; Region   : load_image
; Bytes    : file 0x00A3E8..0x00A42C  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A3E8  55                    PUSH   bp ; STACK_PUSH
00A3E9  8B EC                 MOV    bp, sp ; MOV
00A3EB  57                    PUSH   di ; STACK_PUSH
00A3EC  56                    PUSH   si ; STACK_PUSH
00A3ED  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00A3F0  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00A3F3  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00A3F6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00A3F9  50                    PUSH   ax ; STACK_PUSH
00A3FA  57                    PUSH   di ; STACK_PUSH
00A3FB  8B F0                 MOV    si, ax ; MOV
00A3FD  0E                    PUSH   cs ; STACK_PUSH
00A3FE  E8 E5 FE              CALL   0xa2e6 ; CALL_NEAR
00A401  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00A404  D1 F8                 SAR    ax, 1 ; LOGIC
00A406  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
00A409  D1 F9                 SAR    cx, 1 ; LOGIC
00A40B  8B D6                 MOV    dx, si ; MOV
00A40D  8B F1                 MOV    si, cx ; MOV
00A40F  2B F0                 SUB    si, ax ; ARITH
00A411  03 76 0A              ADD    si, word ptr [bp + 0xa] ; ARITH
00A414  8B C6                 MOV    ax, si ; MOV
00A416  0B C0                 OR     ax, ax ; LOGIC
00A418  7D 02                 JGE    0xa41c ; CJUMP
00A41A  2B C0                 SUB    ax, ax ; ARITH
00A41C  8B F0                 MOV    si, ax ; MOV
00A41E  56                    PUSH   si ; STACK_PUSH
00A41F  52                    PUSH   dx ; STACK_PUSH
00A420  57                    PUSH   di ; STACK_PUSH
00A421  0E                    PUSH   cs ; STACK_PUSH
00A422  E8 33 FF              CALL   0xa358 ; CALL_NEAR
00A425  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
00A428  5E                    POP    si ; STACK_POP
00A429  5F                    POP    di ; STACK_POP
00A42A  C9                    LEAVE ; EPILOGUE
00A42B  CB                    RETF ; RETURN
