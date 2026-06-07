; ============================================================================
; func_00701C_unknown
; Region   : load_image
; Bytes    : file 0x00701C..0x00704C  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00701C  55                    PUSH   bp ; STACK_PUSH
00701D  8B EC                 MOV    bp, sp ; MOV
00701F  57                    PUSH   di ; STACK_PUSH
007020  56                    PUSH   si ; STACK_PUSH
007021  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007024  8B C6                 MOV    ax, si ; MOV
007026  0E                    PUSH   cs ; STACK_PUSH
007027  E8 48 F6              CALL   0x6672 ; CALL_NEAR
00702A  8B F0                 MOV    si, ax ; MOV
00702C  0B F6                 OR     si, si ; LOGIC
00702E  7C 18                 JL     0x7048 ; CJUMP
007030  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
007033  57                    PUSH   di ; STACK_PUSH
007034  56                    PUSH   si ; STACK_PUSH
007035  0E                    PUSH   cs ; STACK_PUSH
007036  E8 C9 FF              CALL   0x7002 ; CALL_NEAR
007039  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00703C  8B C6                 MOV    ax, si ; MOV
00703E  0E                    PUSH   cs ; STACK_PUSH
00703F  E8 78 F6              CALL   0x66ba ; CALL_NEAR
007042  8B F0                 MOV    si, ax ; MOV
007044  0B F6                 OR     si, si ; LOGIC
007046  7D EB                 JGE    0x7033 ; CJUMP
007048  5E                    POP    si ; STACK_POP
007049  5F                    POP    di ; STACK_POP
00704A  C9                    LEAVE ; EPILOGUE
00704B  CB                    RETF ; RETURN
