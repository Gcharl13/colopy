; ============================================================================
; func_061E10_unknown
; Region   : overlay
; Bytes    : file 0x061E10..0x061E95  (133 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

061E10  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
061E14  53                    PUSH   bx ; STACK_PUSH
061E15  52                    PUSH   dx ; STACK_PUSH
061E16  50                    PUSH   ax ; STACK_PUSH
061E17  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
061E1C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
061E1F  EB 56                 JMP    0x61e77 ; JUMP
061E21  90                    NOP ; NOP
061E22  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
061E25  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
061E29  75 49                 JNE    0x61e74 ; CJUMP
061E2B  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
061E2E  40                    INC    ax ; ARITH
061E2F  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
061E32  7C 40                 JL     0x61e74 ; CJUMP
061E34  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
061E37  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
061E3A  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
061E3F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
061E42  3B 46 04              CMP    ax, word ptr [bp + 4] ; CMP
061E45  75 DB                 JNE    0x61e22 ; CJUMP
061E47  0B C0                 OR     ax, ax ; LOGIC
061E49  74 12                 JE     0x61e5d ; CJUMP
061E4B  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
061E4E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
061E51  9A B4 06 1F 18        LCALL  0x181f, 0x6b4 ; THUNK -> 0x037F:0x01CA (thunk @file 0x01ACA4 type B) overlay @file 0x02ED06
061E56  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
061E59  FE C8                 DEC    al ; ARITH
061E5B  75 C5                 JNE    0x61e22 ; CJUMP
061E5D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
061E60  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
061E63  89 07                 MOV    word ptr [bx], ax ; MOV
061E65  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
061E68  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
061E6B  89 07                 MOV    word ptr [bx], ax ; MOV
061E6D  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
061E72  EB AE                 JMP    0x61e22 ; JUMP
061E74  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
061E77  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
061E7B  75 11                 JNE    0x61e8e ; CJUMP
061E7D  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
061E80  40                    INC    ax ; ARITH
061E81  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
061E84  7C 08                 JL     0x61e8e ; CJUMP
061E86  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
061E89  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
061E8C  EB 97                 JMP    0x61e25 ; JUMP
061E8E  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
061E91  C9                    LEAVE ; EPILOGUE
061E92  C2 04 00              RET    4 ; RETURN
