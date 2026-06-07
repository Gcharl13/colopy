; ============================================================================
; func_03C932_unknown
; Region   : overlay
; Bytes    : file 0x03C932..0x03C992  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "SEIZURELAND"  (auto-named via string xrefs)
; ============================================================================

03C932  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03C936  57                    PUSH   di ; STACK_PUSH
03C937  56                    PUSH   si ; STACK_PUSH
03C938  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
03C93B  48                    DEC    ax ; ARITH
03C93C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03C93F  EB 1C                 JMP    0x3c95d ; JUMP
03C941  90                    NOP ; NOP
03C942  6A 01                 PUSH   1 ; STACK_PUSH
03C944  68 A2 12              PUSH   0x12a2                       ; STRING: "SEIZURELAND"
03C947  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
03C94C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03C94F  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
03C952  9A 08 08 1F 18        LCALL  0x181f, 0x808 ; THUNK -> 0x0427:0x0824 (thunk @file 0x01ADF8 type B) overlay @file 0x031538
03C957  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03C95A  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
03C95D  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
03C961  7D 03                 JGE    0x3c966 ; CJUMP
03C963  E9 A0 00              JMP    0x3ca06 ; JUMP
03C966  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
03C969  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C96D  38 87 44 31           CMP    byte ptr [bx + 0x3144], al ; CMP
03C971  75 E7                 JNE    0x3c95a ; CJUMP
03C973  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
03C976  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C97A  38 87 45 31           CMP    byte ptr [bx + 0x3145], al ; CMP
03C97E  75 DA                 JNE    0x3c95a ; CJUMP
03C980  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
03C984  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
03C988  24 0F                 AND    al, 0xf ; LOGIC
03C98A  3A 06 D2 53           CMP    al, byte ptr [0x53d2] ; CMP
03C98E  74 CA                 JE     0x3c95a ; CJUMP
03C990  6B                    DB     0x6B ; DATA_BYTE
03C991  5E                    DB     0x5E ; DATA_BYTE
