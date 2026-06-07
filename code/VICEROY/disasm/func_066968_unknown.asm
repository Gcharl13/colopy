; ============================================================================
; func_066968_unknown
; Region   : overlay
; Bytes    : file 0x066968..0x0669CC  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066968  C8 38 00 00           ENTER  0x38, 0 ; PROLOGUE
06696C  57                    PUSH   di ; STACK_PUSH
06696D  56                    PUSH   si ; STACK_PUSH
06696E  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0 ; CMP
066972  7C 0E                 JL     0x66982 ; CJUMP
066974  8A 4E 0E              MOV    cl, byte ptr [bp + 0xe] ; LOCAL_LOAD
066977  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
06697A  D3 E0                 SHL    ax, cl ; LOGIC
06697C  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
06697F  EB 06                 JMP    0x66987 ; JUMP
066981  90                    NOP ; NOP
066982  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
066987  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
06698A  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
06698D  57                    PUSH   di ; STACK_PUSH
06698E  56                    PUSH   si ; STACK_PUSH
06698F  9A 0E 07 1F 18        LCALL  0x181f, 0x70e ; THUNK -> 0x037F:0x00F6 (thunk @file 0x01ACFE type B) overlay @file 0x02EC32
066994  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
066997  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
06699A  89 56 D8              MOV    word ptr [bp - 0x28], dx ; LOCAL_STORE
06699D  57                    PUSH   di ; STACK_PUSH
06699E  56                    PUSH   si ; STACK_PUSH
06699F  9A 40 07 1F 18        LCALL  0x181f, 0x740 ; THUNK -> 0x037F:0x012A (thunk @file 0x01AD30 type B) overlay @file 0x02EC66
0669A4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0669A7  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
0669AA  89 56 D4              MOV    word ptr [bp - 0x2c], dx ; LOCAL_STORE
0669AD  57                    PUSH   di ; STACK_PUSH
0669AE  56                    PUSH   si ; STACK_PUSH
0669AF  9A 36 07 1F 18        LCALL  0x181f, 0x736 ; THUNK -> 0x037F:0x02E0 (thunk @file 0x01AD26 type B) overlay @file 0x02EE1C
0669B4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0669B7  89 46 CE              MOV    word ptr [bp - 0x32], ax ; LOCAL_STORE
0669BA  89 56 D0              MOV    word ptr [bp - 0x30], dx ; LOCAL_STORE
0669BD  57                    PUSH   di ; STACK_PUSH
0669BE  56                    PUSH   si ; STACK_PUSH
0669BF  9A A0 06 1F 18        LCALL  0x181f, 0x6a0 ; THUNK -> 0x037F:0x0194 (thunk @file 0x01AC90 type B) overlay @file 0x02ECD0
0669C4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0669C7  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
0669CA  89                    DB     0x89 ; DATA_BYTE
0669CB  56                    DB     0x56 ; DATA_BYTE
