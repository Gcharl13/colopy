; ============================================================================
; func_046EC0_unknown
; Region   : overlay
; Bytes    : file 0x046EC0..0x046F27  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046EC0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
046EC4  57                    PUSH   di ; STACK_PUSH
046EC5  56                    PUSH   si ; STACK_PUSH
046EC6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
046EC9  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
046ECE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
046ED1  6A 00                 PUSH   0 ; STACK_PUSH
046ED3  6A 02                 PUSH   2 ; STACK_PUSH
046ED5  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12 ; ARITH
046ED9  8A 87 ED 54           MOV    al, byte ptr [bx + 0x54ed] ; MOV
046EDD  2A E4                 SUB    ah, ah ; ARITH
046EDF  50                    PUSH   ax ; STACK_PUSH
046EE0  8A 87 EC 54           MOV    al, byte ptr [bx + 0x54ec] ; MOV
046EE4  50                    PUSH   ax ; STACK_PUSH
046EE5  9A 8C 06 1F 18        LCALL  0x181f, 0x68c ; THUNK -> 0x037F:0x015E (thunk @file 0x01AC7C type B) overlay @file 0x02EC9A
046EEA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
046EED  A1 9C 53              MOV    ax, word ptr [0x539c] ; GLOBAL_LOAD
046EF0  48                    DEC    ax ; ARITH
046EF1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
046EF4  EB 14                 JMP    0x46f0a ; JUMP
046EF6  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
046EF9  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
046EFD  38 87 4A 31           CMP    byte ptr [bx + 0x314a], al ; CMP
046F01  7E 04                 JLE    0x46f07 ; CJUMP
046F03  FE 8F 4A 31           DEC    byte ptr [bx + 0x314a] ; ARITH
046F07  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
046F0A  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
046F0E  7C 24                 JL     0x46f34 ; CJUMP
046F10  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c ; ARITH
046F14  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
046F18  24 0F                 AND    al, 0xf ; LOGIC
046F1A  3C 04                 CMP    al, 4 ; CMP
046F1C  72 E9                 JB     0x46f07 ; CJUMP
046F1E  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
046F21  38 87 4A 31           CMP    byte ptr [bx + 0x314a], al ; CMP
046F25  75 CF                 JNE    0x46ef6 ; CJUMP
