; ============================================================================
; func_005452_unknown
; Region   : load_image
; Bytes    : file 0x005452..0x0054BC  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005452  55                    PUSH   bp ; STACK_PUSH
005453  8B EC                 MOV    bp, sp ; MOV
005455  56                    PUSH   si ; STACK_PUSH
005456  57                    PUSH   di ; STACK_PUSH
005457  B9 01 01              MOV    cx, 0x101 ; CONST_LOAD
00545A  51                    PUSH   cx ; STACK_PUSH
00545B  0A C9                 OR     cl, cl ; LOGIC
00545D  75 1E                 JNE    0x547d ; CJUMP
00545F  BE B8 47              MOV    si, 0x47b8 ; CONST_LOAD
005462  BF B8 47              MOV    di, 0x47b8 ; CONST_LOAD
005465  E8 81 00              CALL   0x54e9 ; CALL_NEAR
005468  BE 22 46              MOV    si, 0x4622 ; CONST_LOAD
00546B  BF 26 46              MOV    di, 0x4626 ; CONST_LOAD
00546E  E8 78 00              CALL   0x54e9 ; CALL_NEAR
005471  81 3E 06 46 D6 D6     CMP    word ptr [0x4606], 0xd6d6 ; CMP
005477  75 04                 JNE    0x547d ; CJUMP
005479  FF 16 0C 46           CALL   word ptr [0x460c] ; CALL_NEAR
00547D  BE 26 46              MOV    si, 0x4626 ; CONST_LOAD
005480  BF 26 46              MOV    di, 0x4626 ; CONST_LOAD
005483  E8 63 00              CALL   0x54e9 ; CALL_NEAR
005486  BE 26 46              MOV    si, 0x4626 ; CONST_LOAD
005489  BF 26 46              MOV    di, 0x4626 ; CONST_LOAD
00548C  E8 5A 00              CALL   0x54e9 ; CALL_NEAR
00548F  9A 9E 0F 52 04        LCALL  0x452, 0xf9e ; LCALL
005494  0B C0                 OR     ax, ax ; LOGIC
005496  74 11                 JE     0x54a9 ; CJUMP
005498  58                    POP    ax ; STACK_POP
005499  0A E4                 OR     ah, ah ; LOGIC
00549B  50                    PUSH   ax ; STACK_PUSH
00549C  75 0B                 JNE    0x54a9 ; CJUMP
00549E  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0054A2  75 05                 JNE    0x54a9 ; CJUMP
0054A4  C7 46 06 FF 00        MOV    word ptr [bp + 6], 0xff ; LOCAL_STORE
0054A9  E8 10 00              CALL   0x54bc ; CALL_NEAR
0054AC  58                    POP    ax ; STACK_POP
0054AD  0A E4                 OR     ah, ah ; LOGIC
0054AF  75 07                 JNE    0x54b8 ; CJUMP
0054B1  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0054B4  B4 4C                 MOV    ah, 0x4c ; CONST_LOAD
0054B6  CD 21                 INT    0x21 ; SYS
0054B8  5F                    POP    di ; STACK_POP
0054B9  5E                    POP    si ; STACK_POP
0054BA  5D                    POP    bp ; STACK_POP
0054BB  CB                    RETF ; RETURN
