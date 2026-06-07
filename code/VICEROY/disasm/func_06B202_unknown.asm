; ============================================================================
; func_06B202_unknown
; Region   : overlay
; Bytes    : file 0x06B202..0x06B256  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06B202  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
06B206  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06B209  E9 6E 01              JMP    0x6b37a ; JUMP
06B20C  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
06B211  EB 04                 JMP    0x6b217 ; JUMP
06B213  90                    NOP ; NOP
06B214  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
06B217  83 7E FC 10           CMP    word ptr [bp - 4], 0x10 ; CMP
06B21B  7C 03                 JL     0x6b220 ; CJUMP
06B21D  E9 76 01              JMP    0x6b396 ; JUMP
06B220  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06B223  6A 00                 PUSH   0 ; STACK_PUSH
06B225  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
06B228  D1 E3                 SHL    bx, 1 ; LOGIC
06B22A  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
06B22E  0E                    PUSH   cs ; STACK_PUSH
06B22F  E8 51 04              CALL   0x6b683 ; CALL_NEAR
06B232  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06B235  EB DD                 JMP    0x6b214 ; JUMP
06B237  90                    NOP ; NOP
06B238  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
06B23D  EB 04                 JMP    0x6b243 ; JUMP
06B23F  90                    NOP ; NOP
06B240  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
06B243  83 7E FC 17           CMP    word ptr [bp - 4], 0x17 ; CMP
06B247  7C 03                 JL     0x6b24c ; CJUMP
06B249  E9 4A 01              JMP    0x6b396 ; JUMP
06B24C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06B24F  6A 01                 PUSH   1 ; STACK_PUSH
06B251  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
06B254  8B C3                 MOV    ax, bx ; MOV
