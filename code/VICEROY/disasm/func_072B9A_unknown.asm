; ============================================================================
; func_072B9A_unknown
; Region   : overlay
; Bytes    : file 0x072B9A..0x072C4E  (180 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

072B9A  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
072B9E  57                    PUSH   di ; STACK_PUSH
072B9F  56                    PUSH   si ; STACK_PUSH
072BA0  2B C0                 SUB    ax, ax ; ARITH
072BA2  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
072BA5  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
072BA8  B8 0C 00              MOV    ax, 0xc ; CONST_LOAD
072BAB  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
072BAE  50                    PUSH   ax ; STACK_PUSH
072BAF  9A 7C 02 1F 18        LCALL  0x181f, 0x27c ; THUNK -> 0x0101:0x000E (thunk @file 0x01A86C type B) overlay @file 0x06040A
072BB4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
072BB7  8B F0                 MOV    si, ax ; MOV
072BB9  89 56 E6              MOV    word ptr [bp - 0x1a], dx ; LOCAL_STORE
072BBC  0B D0                 OR     dx, ax ; LOGIC
072BBE  75 0A                 JNE    0x72bca ; CJUMP
072BC0  C7 06 22 08 21 03     MOV    word ptr [0x822], 0x321 ; GLOBAL_LOAD
072BC6  EB 7C                 JMP    0x72c44 ; JUMP
072BC8  90                    NOP ; NOP
072BC9  90                    NOP ; NOP
072BCA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
072BCD  B8 00 40              MOV    ax, 0x4000 ; CONST_LOAD
072BD0  9A 72 03 1F 1A        LCALL  0x1a1f, 0x372 ; THUNK -> 0x0000:0x0002 (thunk @file 0x01C962 type A) overlay @file 0x025902
072BD5  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
072BD8  89 56 EA              MOV    word ptr [bp - 0x16], dx ; LOCAL_STORE
072BDB  0B D0                 OR     dx, ax ; LOGIC
072BDD  75 09                 JNE    0x72be8 ; CJUMP
072BDF  C7 06 22 08 22 03     MOV    word ptr [0x822], 0x322 ; GLOBAL_LOAD
072BE5  EB 5D                 JMP    0x72c44 ; JUMP
072BE7  90                    NOP ; NOP
072BE8  89 76 E4              MOV    word ptr [bp - 0x1c], si ; LOCAL_STORE
072BEB  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
072BEE  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
072BF1  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
072BF4  2B F6                 SUB    si, si ; ARITH
072BF6  8B 4E E4              MOV    cx, word ptr [bp - 0x1c] ; LOCAL_LOAD
072BF9  8B 46 E6              MOV    ax, word ptr [bp - 0x1a] ; LOCAL_LOAD
072BFC  8B F9                 MOV    di, cx ; MOV
072BFE  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
072C01  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
072C04  89 7E E0              MOV    word ptr [bp - 0x20], di ; LOCAL_STORE
072C07  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
072C0A  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
072C0D  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
072C10  6A 00                 PUSH   0 ; STACK_PUSH
072C12  8D 44 01              LEA    ax, [si + 1] ; ADDR
072C15  8D 5E DC              LEA    bx, [bp - 0x24] ; ADDR
072C18  2B D2                 SUB    dx, dx ; ARITH
072C1A  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
072C1F  81 C7 00 01           ADD    di, 0x100 ; ARITH
072C23  8D 44 01              LEA    ax, [si + 1] ; ADDR
072C26  8B F0                 MOV    si, ax ; MOV
072C28  83 FE 0C              CMP    si, 0xc ; CMP
072C2B  7C D4                 JL     0x72c01 ; CJUMP
072C2D  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
072C30  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
072C33  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
072C38  8B 46 E4              MOV    ax, word ptr [bp - 0x1c] ; LOCAL_LOAD
072C3B  8B 56 E6              MOV    dx, word ptr [bp - 0x1a] ; LOCAL_LOAD
072C3E  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
072C41  89 56 EE              MOV    word ptr [bp - 0x12], dx ; LOCAL_STORE
072C44  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
072C47  8B 56 EE              MOV    dx, word ptr [bp - 0x12] ; LOCAL_LOAD
072C4A  5E                    POP    si ; STACK_POP
072C4B  5F                    POP    di ; STACK_POP
072C4C  C9                    LEAVE ; EPILOGUE
072C4D  CB                    RETF ; RETURN
