; ============================================================================
; func_024632_unknown
; Region   : overlay
; Bytes    : file 0x024632..0x024692  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024632  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
024636  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02463B  A1 28 93              MOV    ax, word ptr [0x9328] ; GLOBAL_LOAD
02463E  39 06 3E 93           CMP    word ptr [0x933e], ax ; CMP
024642  75 3E                 JNE    0x24682 ; CJUMP
024644  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
024649  74 37                 JE     0x24682 ; CJUMP
02464B  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
024650  83 3E 9C 92 00        CMP    word ptr [0x929c], 0 ; CMP
024655  74 05                 JE     0x2465c ; CJUMP
024657  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
02465C  83 3E C6 53 00        CMP    word ptr [0x53c6], 0 ; CMP
024661  74 09                 JE     0x2466c ; CJUMP
024663  C7 06 C4 53 00 00     MOV    word ptr [0x53c4], 0 ; GLOBAL_LOAD
024669  EB 17                 JMP    0x24682 ; JUMP
02466B  90                    NOP ; NOP
02466C  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
024671  75 0B                 JNE    0x2467e ; CJUMP
024673  6A 00                 PUSH   0 ; STACK_PUSH
024675  0E                    PUSH   cs ; STACK_PUSH
024676  E8 D7 04              CALL   0x24b50 ; CALL_NEAR
024679  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02467C  EB 04                 JMP    0x24682 ; JUMP
02467E  0E                    PUSH   cs ; STACK_PUSH
02467F  E8 23 05              CALL   0x24ba5 ; CALL_NEAR
024682  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
024686  74 05                 JE     0x2468d ; CJUMP
024688  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
02468D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
024690  C9                    LEAVE ; EPILOGUE
024691  CB                    RETF ; RETURN
