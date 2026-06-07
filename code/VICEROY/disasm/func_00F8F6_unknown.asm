; ============================================================================
; func_00F8F6_unknown
; Region   : load_image
; Bytes    : file 0x00F8F6..0x00F960  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F8F6  55                    PUSH   bp ; STACK_PUSH
00F8F7  8B EC                 MOV    bp, sp ; MOV
00F8F9  56                    PUSH   si ; STACK_PUSH
00F8FA  57                    PUSH   di ; STACK_PUSH
00F8FB  B9 01 01              MOV    cx, 0x101 ; CONST_LOAD
00F8FE  51                    PUSH   cx ; STACK_PUSH
00F8FF  0A C9                 OR     cl, cl ; LOGIC
00F901  75 1E                 JNE    0xf921 ; CJUMP
00F903  BE 38 2D              MOV    si, 0x2d38 ; CONST_LOAD
00F906  BF 38 2D              MOV    di, 0x2d38 ; CONST_LOAD
00F909  E8 81 00              CALL   0xf98d ; CALL_NEAR
00F90C  BE 32 2B              MOV    si, 0x2b32 ; CONST_LOAD
00F90F  BF 36 2B              MOV    di, 0x2b36 ; CONST_LOAD
00F912  E8 78 00              CALL   0xf98d ; CALL_NEAR
00F915  81 3E 16 2B D6 D6     CMP    word ptr [0x2b16], 0xd6d6 ; CMP
00F91B  75 04                 JNE    0xf921 ; CJUMP
00F91D  FF 16 1C 2B           CALL   word ptr [0x2b1c] ; CALL_NEAR
00F921  BE 36 2B              MOV    si, 0x2b36 ; CONST_LOAD
00F924  BF 36 2B              MOV    di, 0x2b36 ; CONST_LOAD
00F927  E8 63 00              CALL   0xf98d ; CALL_NEAR
00F92A  BE 36 2B              MOV    si, 0x2b36 ; CONST_LOAD
00F92D  BF 36 2B              MOV    di, 0x2b36 ; CONST_LOAD
00F930  E8 5A 00              CALL   0xf98d ; CALL_NEAR
00F933  9A 6A 12 1D 0D        LCALL  0xd1d, 0x126a ; LCALL
00F938  0B C0                 OR     ax, ax ; LOGIC
00F93A  74 11                 JE     0xf94d ; CJUMP
00F93C  58                    POP    ax ; STACK_POP
00F93D  0A E4                 OR     ah, ah ; LOGIC
00F93F  50                    PUSH   ax ; STACK_PUSH
00F940  75 0B                 JNE    0xf94d ; CJUMP
00F942  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
00F946  75 05                 JNE    0xf94d ; CJUMP
00F948  C7 46 06 FF 00        MOV    word ptr [bp + 6], 0xff ; LOCAL_STORE
00F94D  E8 10 00              CALL   0xf960 ; CALL_NEAR
00F950  58                    POP    ax ; STACK_POP
00F951  0A E4                 OR     ah, ah ; LOGIC
00F953  75 07                 JNE    0xf95c ; CJUMP
00F955  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00F958  B4 4C                 MOV    ah, 0x4c ; CONST_LOAD
00F95A  CD 21                 INT    0x21 ; SYS
00F95C  5F                    POP    di ; STACK_POP
00F95D  5E                    POP    si ; STACK_POP
00F95E  5D                    POP    bp ; STACK_POP
00F95F  CB                    RETF ; RETURN
