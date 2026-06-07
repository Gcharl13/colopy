; ============================================================================
; func_004B04_unknown
; Region   : load_image
; Bytes    : file 0x004B04..0x004B8A  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004B04  55                    PUSH   bp ; STACK_PUSH
004B05  8B EC                 MOV    bp, sp ; MOV
004B07  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
004B0A  56                    PUSH   si ; STACK_PUSH
004B0B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
004B0E  0B F6                 OR     si, si ; LOGIC
004B10  7C 06                 JL     0x4b18 ; CJUMP
004B12  39 36 57 40           CMP    word ptr [0x4057], si ; CMP
004B16  7F 0C                 JG     0x4b24 ; CJUMP
004B18  C7 06 4A 40 09 00     MOV    word ptr [0x404a], 9 ; GLOBAL_LOAD
004B1E  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
004B21  99                    CDQ ; ARITH
004B22  EB 61                 JMP    0x4b85 ; JUMP
004B24  B8 01 00              MOV    ax, 1 ; MOV
004B27  50                    PUSH   ax ; STACK_PUSH
004B28  2B C0                 SUB    ax, ax ; ARITH
004B2A  50                    PUSH   ax ; STACK_PUSH
004B2B  50                    PUSH   ax ; STACK_PUSH
004B2C  56                    PUSH   si ; STACK_PUSH
004B2D  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
004B32  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004B35  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
004B38  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
004B3B  3D FF FF              CMP    ax, 0xffff ; CMP
004B3E  75 0C                 JNE    0x4b4c ; CJUMP
004B40  3B D0                 CMP    dx, ax ; CMP
004B42  75 08                 JNE    0x4b4c ; CJUMP
004B44  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
004B47  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
004B4A  EB 33                 JMP    0x4b7f ; JUMP
004B4C  B8 02 00              MOV    ax, 2 ; MOV
004B4F  50                    PUSH   ax ; STACK_PUSH
004B50  2B C0                 SUB    ax, ax ; ARITH
004B52  50                    PUSH   ax ; STACK_PUSH
004B53  50                    PUSH   ax ; STACK_PUSH
004B54  56                    PUSH   si ; STACK_PUSH
004B55  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
004B5A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004B5D  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
004B60  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
004B63  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
004B66  75 05                 JNE    0x4b6d ; CJUMP
004B68  3B 56 FA              CMP    dx, word ptr [bp - 6] ; CMP
004B6B  74 12                 JE     0x4b7f ; CJUMP
004B6D  2B C0                 SUB    ax, ax ; ARITH
004B6F  50                    PUSH   ax ; STACK_PUSH
004B70  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
004B73  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
004B76  56                    PUSH   si ; STACK_PUSH
004B77  9A 3A 1A 7D 03        LCALL  0x37d, 0x1a3a ; LCALL
004B7C  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004B7F  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
004B82  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
004B85  5E                    POP    si ; STACK_POP
004B86  8B E5                 MOV    sp, bp ; MOV
004B88  5D                    POP    bp ; STACK_POP
004B89  CB                    RETF ; RETURN
