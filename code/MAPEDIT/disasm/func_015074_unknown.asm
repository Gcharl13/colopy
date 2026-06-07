; ============================================================================
; func_015074_unknown
; Region   : load_image
; Bytes    : file 0x015074..0x0150DE  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015074  55                    PUSH   bp ; STACK_PUSH
015075  8B EC                 MOV    bp, sp ; MOV
015077  56                    PUSH   si ; STACK_PUSH
015078  57                    PUSH   di ; STACK_PUSH
015079  B9 01 01              MOV    cx, 0x101 ; CONST_LOAD
01507C  51                    PUSH   cx ; STACK_PUSH
01507D  0A C9                 OR     cl, cl ; LOGIC
01507F  75 1E                 JNE    0x1509f ; CJUMP
015081  BE B2 49              MOV    si, 0x49b2 ; CONST_LOAD
015084  BF B2 49              MOV    di, 0x49b2 ; CONST_LOAD
015087  E8 81 00              CALL   0x1510b ; CALL_NEAR
01508A  BE B2 48              MOV    si, 0x48b2 ; CONST_LOAD
01508D  BF B6 48              MOV    di, 0x48b6 ; CONST_LOAD
015090  E8 78 00              CALL   0x1510b ; CALL_NEAR
015093  81 3E 96 48 D6 D6     CMP    word ptr [0x4896], 0xd6d6 ; CMP
015099  75 04                 JNE    0x1509f ; CJUMP
01509B  FF 16 9C 48           CALL   word ptr [0x489c] ; CALL_NEAR
01509F  BE B6 48              MOV    si, 0x48b6 ; CONST_LOAD
0150A2  BF B6 48              MOV    di, 0x48b6 ; CONST_LOAD
0150A5  E8 63 00              CALL   0x1510b ; CALL_NEAR
0150A8  BE B6 48              MOV    si, 0x48b6 ; CONST_LOAD
0150AB  BF B6 48              MOV    di, 0x48b6 ; CONST_LOAD
0150AE  E8 5A 00              CALL   0x1510b ; CALL_NEAR
0150B1  9A A2 0F 88 13        LCALL  0x1388, 0xfa2 ; LCALL
0150B6  0B C0                 OR     ax, ax ; LOGIC
0150B8  74 11                 JE     0x150cb ; CJUMP
0150BA  58                    POP    ax ; STACK_POP
0150BB  0A E4                 OR     ah, ah ; LOGIC
0150BD  50                    PUSH   ax ; STACK_PUSH
0150BE  75 0B                 JNE    0x150cb ; CJUMP
0150C0  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0150C4  75 05                 JNE    0x150cb ; CJUMP
0150C6  C7 46 06 FF 00        MOV    word ptr [bp + 6], 0xff ; LOCAL_STORE
0150CB  E8 10 00              CALL   0x150de ; CALL_NEAR
0150CE  58                    POP    ax ; STACK_POP
0150CF  0A E4                 OR     ah, ah ; LOGIC
0150D1  75 07                 JNE    0x150da ; CJUMP
0150D3  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0150D6  B4 4C                 MOV    ah, 0x4c ; CONST_LOAD
0150D8  CD 21                 INT    0x21 ; SYS
0150DA  5F                    POP    di ; STACK_POP
0150DB  5E                    POP    si ; STACK_POP
0150DC  5D                    POP    bp ; STACK_POP
0150DD  CB                    RETF ; RETURN
