; ============================================================================
; func_002CE0_unknown
; Region   : load_image
; Bytes    : file 0x002CE0..0x002D27  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002CE0  55                    PUSH   bp ; STACK_PUSH
002CE1  8B EC                 MOV    bp, sp ; MOV
002CE3  57                    PUSH   di ; STACK_PUSH
002CE4  56                    PUSH   si ; STACK_PUSH
002CE5  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
002CE8  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
002CEB  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
002CEE  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
002CF1  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002CF4  50                    PUSH   ax ; STACK_PUSH
002CF5  57                    PUSH   di ; STACK_PUSH
002CF6  8B F0                 MOV    si, ax ; MOV
002CF8  0E                    PUSH   cs ; STACK_PUSH
002CF9  E8 E6 FD              CALL   0x2ae2 ; CALL_NEAR
002CFC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
002CFF  D1 F8                 SAR    ax, 1 ; LOGIC
002D01  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
002D04  D1 F9                 SAR    cx, 1 ; LOGIC
002D06  8B D6                 MOV    dx, si ; MOV
002D08  8B F1                 MOV    si, cx ; MOV
002D0A  2B F0                 SUB    si, ax ; ARITH
002D0C  03 76 0A              ADD    si, word ptr [bp + 0xa] ; ARITH
002D0F  8B C6                 MOV    ax, si ; MOV
002D11  0B C0                 OR     ax, ax ; LOGIC
002D13  7D 02                 JGE    0x2d17 ; CJUMP
002D15  2B C0                 SUB    ax, ax ; ARITH
002D17  8B F0                 MOV    si, ax ; MOV
002D19  56                    PUSH   si ; STACK_PUSH
002D1A  52                    PUSH   dx ; STACK_PUSH
002D1B  57                    PUSH   di ; STACK_PUSH
002D1C  0E                    PUSH   cs ; STACK_PUSH
002D1D  E8 2A FF              CALL   0x2c4a ; CALL_NEAR
002D20  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
002D23  5E                    POP    si ; STACK_POP
002D24  5F                    POP    di ; STACK_POP
002D25  C9                    LEAVE ; EPILOGUE
002D26  CB                    RETF ; RETURN
