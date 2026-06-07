; ============================================================================
; func_04C7F0_unknown
; Region   : overlay
; Bytes    : file 0x04C7F0..0x04C846  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C7F0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
04C7F4  57                    PUSH   di ; STACK_PUSH
04C7F5  56                    PUSH   si ; STACK_PUSH
04C7F6  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
04C7FA  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
04C7FE  2A E4                 SUB    ah, ah ; ARITH
04C800  50                    PUSH   ax ; STACK_PUSH
04C801  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
04C805  50                    PUSH   ax ; STACK_PUSH
04C806  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
04C80B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C80E  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
04C811  50                    PUSH   ax ; STACK_PUSH
04C812  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04C815  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C818  0E                    PUSH   cs ; STACK_PUSH
04C819  E8 FA 6C              CALL   0x53516 ; CALL_NEAR
04C81C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
04C81F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
04C822  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C825  8B F0                 MOV    si, ax ; MOV
04C827  0E                    PUSH   cs ; STACK_PUSH
04C828  E8 BE 6C              CALL   0x534e9 ; CALL_NEAR
04C82B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04C82E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
04C831  8B F8                 MOV    di, ax ; MOV
04C833  0E                    PUSH   cs ; STACK_PUSH
04C834  E8 99 6C              CALL   0x534d0 ; CALL_NEAR
04C837  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04C83A  03 F7                 ADD    si, di ; ARITH
04C83C  03 C6                 ADD    ax, si ; ARITH
04C83E  79 02                 JNS    0x4c842 ; CJUMP
04C840  2B C0                 SUB    ax, ax ; ARITH
04C842  5E                    POP    si ; STACK_POP
04C843  5F                    POP    di ; STACK_POP
04C844  C9                    LEAVE ; EPILOGUE
04C845  CB                    RETF ; RETURN
