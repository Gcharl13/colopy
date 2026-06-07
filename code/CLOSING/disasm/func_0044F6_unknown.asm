; ============================================================================
; func_0044F6_unknown
; Region   : load_image
; Bytes    : file 0x0044F6..0x004560  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0044F6  55                    PUSH   bp ; STACK_PUSH
0044F7  8B EC                 MOV    bp, sp ; MOV
0044F9  56                    PUSH   si ; STACK_PUSH
0044FA  57                    PUSH   di ; STACK_PUSH
0044FB  B9 01 01              MOV    cx, 0x101 ; CONST_LOAD
0044FE  51                    PUSH   cx ; STACK_PUSH
0044FF  0A C9                 OR     cl, cl ; LOGIC
004501  75 1E                 JNE    0x4521 ; CJUMP
004503  BE 62 45              MOV    si, 0x4562 ; CONST_LOAD
004506  BF 62 45              MOV    di, 0x4562 ; CONST_LOAD
004509  E8 81 00              CALL   0x458d ; CALL_NEAR
00450C  BE CC 43              MOV    si, 0x43cc ; CONST_LOAD
00450F  BF D0 43              MOV    di, 0x43d0 ; CONST_LOAD
004512  E8 78 00              CALL   0x458d ; CALL_NEAR
004515  81 3E B0 43 D6 D6     CMP    word ptr [0x43b0], 0xd6d6 ; CMP
00451B  75 04                 JNE    0x4521 ; CJUMP
00451D  FF 16 B6 43           CALL   word ptr [0x43b6] ; CALL_NEAR
004521  BE D0 43              MOV    si, 0x43d0 ; CONST_LOAD
004524  BF D0 43              MOV    di, 0x43d0 ; CONST_LOAD
004527  E8 63 00              CALL   0x458d ; CALL_NEAR
00452A  BE D0 43              MOV    si, 0x43d0 ; CONST_LOAD
00452D  BF D0 43              MOV    di, 0x43d0 ; CONST_LOAD
004530  E8 5A 00              CALL   0x458d ; CALL_NEAR
004533  9A EE 0E 7D 03        LCALL  0x37d, 0xeee ; LCALL
004538  0B C0                 OR     ax, ax ; LOGIC
00453A  74 11                 JE     0x454d ; CJUMP
00453C  58                    POP    ax ; STACK_POP
00453D  0A E4                 OR     ah, ah ; LOGIC
00453F  50                    PUSH   ax ; STACK_PUSH
004540  75 0B                 JNE    0x454d ; CJUMP
004542  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
004546  75 05                 JNE    0x454d ; CJUMP
004548  C7 46 06 FF 00        MOV    word ptr [bp + 6], 0xff ; LOCAL_STORE
00454D  E8 10 00              CALL   0x4560 ; CALL_NEAR
004550  58                    POP    ax ; STACK_POP
004551  0A E4                 OR     ah, ah ; LOGIC
004553  75 07                 JNE    0x455c ; CJUMP
004555  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004558  B4 4C                 MOV    ah, 0x4c ; CONST_LOAD
00455A  CD 21                 INT    0x21 ; SYS
00455C  5F                    POP    di ; STACK_POP
00455D  5E                    POP    si ; STACK_POP
00455E  5D                    POP    bp ; STACK_POP
00455F  CB                    RETF ; RETURN
