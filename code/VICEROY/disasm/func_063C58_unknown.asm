; ============================================================================
; func_063C58_unknown
; Region   : overlay
; Bytes    : file 0x063C58..0x063CCF  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063C58  C8 22 00 00           ENTER  0x22, 0 ; PROLOGUE
063C5C  57                    PUSH   di ; STACK_PUSH
063C5D  56                    PUSH   si ; STACK_PUSH
063C5E  C7 06 D4 1D 01 00     MOV    word ptr [0x1dd4], 1 ; GLOBAL_LOAD
063C64  C7 46 DE 00 00        MOV    word ptr [bp - 0x22], 0 ; LOCAL_STORE
063C69  83 7E DE 00           CMP    word ptr [bp - 0x22], 0 ; CMP
063C6D  74 09                 JE     0x63c78 ; CJUMP
063C6F  BE F6 86              MOV    si, 0x86f6 ; CONST_LOAD
063C72  BF 01 00              MOV    di, 1 ; MOV
063C75  EB 06                 JMP    0x63c7d ; JUMP
063C77  90                    NOP ; NOP
063C78  BE E8 85              MOV    si, 0x85e8 ; CONST_LOAD
063C7B  2B FF                 SUB    di, di ; ARITH
063C7D  68 0E 01              PUSH   0x10e ; PUSH_CONST
063C80  6A 00                 PUSH   0 ; STACK_PUSH
063C82  56                    PUSH   si ; STACK_PUSH
063C83  9A AE 0D 1D 0D        LCALL  0xd1d, 0xdae ; LCALL
063C88  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
063C8B  2B C0                 SUB    ax, ax ; ARITH
063C8D  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
063C90  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
063C93  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
063C98  89 7E EC              MOV    word ptr [bp - 0x14], di ; LOCAL_STORE
063C9B  89 76 E0              MOV    word ptr [bp - 0x20], si ; LOCAL_STORE
063C9E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
063CA3  C7 46 F4 01 00        MOV    word ptr [bp - 0xc], 1 ; LOCAL_STORE
063CA8  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
063CAB  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
063CAE  8D 46 E6              LEA    ax, [bp - 0x1a] ; ADDR
063CB1  50                    PUSH   ax ; STACK_PUSH
063CB2  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
063CB5  8B 56 F4              MOV    dx, word ptr [bp - 0xc] ; LOCAL_LOAD
063CB8  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
063CBB  8B 46 EE              MOV    ax, word ptr [bp - 0x12] ; LOCAL_LOAD
063CBE  8D 5E E8              LEA    bx, [bp - 0x18] ; ADDR
063CC1  E8 14 FF              CALL   0x63bd8 ; CALL_NEAR
063CC4  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
063CC7  0B C0                 OR     ax, ax ; LOGIC
063CC9  7D 03                 JGE    0x63cce ; CJUMP
063CCB  E9 CA 00              JMP    0x63d98 ; JUMP
063CCE  C7                    DB     0xC7 ; DATA_BYTE
