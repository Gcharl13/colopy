; ============================================================================
; func_0157E2_unknown
; Region   : load_image
; Bytes    : file 0x0157E2..0x015868  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0157E2  55                    PUSH   bp ; STACK_PUSH
0157E3  8B EC                 MOV    bp, sp ; MOV
0157E5  83 EC 08              SUB    sp, 8 ; STACK_ALLOC
0157E8  56                    PUSH   si ; STACK_PUSH
0157E9  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
0157EC  0B F6                 OR     si, si ; LOGIC
0157EE  7C 06                 JL     0x157f6 ; CJUMP
0157F0  39 36 75 45           CMP    word ptr [0x4575], si ; CMP
0157F4  7F 0C                 JG     0x15802 ; CJUMP
0157F6  C7 06 68 45 09 00     MOV    word ptr [0x4568], 9 ; GLOBAL_LOAD
0157FC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0157FF  99                    CDQ ; ARITH
015800  EB 61                 JMP    0x15863 ; JUMP
015802  B8 01 00              MOV    ax, 1 ; MOV
015805  50                    PUSH   ax ; STACK_PUSH
015806  2B C0                 SUB    ax, ax ; ARITH
015808  50                    PUSH   ax ; STACK_PUSH
015809  50                    PUSH   ax ; STACK_PUSH
01580A  56                    PUSH   si ; STACK_PUSH
01580B  9A D2 1B 88 13        LCALL  0x1388, 0x1bd2 ; LCALL
015810  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
015813  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
015816  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
015819  3D FF FF              CMP    ax, 0xffff ; CMP
01581C  75 0C                 JNE    0x1582a ; CJUMP
01581E  3B D0                 CMP    dx, ax ; CMP
015820  75 08                 JNE    0x1582a ; CJUMP
015822  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
015825  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
015828  EB 33                 JMP    0x1585d ; JUMP
01582A  B8 02 00              MOV    ax, 2 ; MOV
01582D  50                    PUSH   ax ; STACK_PUSH
01582E  2B C0                 SUB    ax, ax ; ARITH
015830  50                    PUSH   ax ; STACK_PUSH
015831  50                    PUSH   ax ; STACK_PUSH
015832  56                    PUSH   si ; STACK_PUSH
015833  9A D2 1B 88 13        LCALL  0x1388, 0x1bd2 ; LCALL
015838  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
01583B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
01583E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
015841  3B 46 F8              CMP    ax, word ptr [bp - 8] ; CMP
015844  75 05                 JNE    0x1584b ; CJUMP
015846  3B 56 FA              CMP    dx, word ptr [bp - 6] ; CMP
015849  74 12                 JE     0x1585d ; CJUMP
01584B  2B C0                 SUB    ax, ax ; ARITH
01584D  50                    PUSH   ax ; STACK_PUSH
01584E  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
015851  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
015854  56                    PUSH   si ; STACK_PUSH
015855  9A D2 1B 88 13        LCALL  0x1388, 0x1bd2 ; LCALL
01585A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
01585D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
015860  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
015863  5E                    POP    si ; STACK_POP
015864  8B E5                 MOV    sp, bp ; MOV
015866  5D                    POP    bp ; STACK_POP
015867  CB                    RETF ; RETURN
