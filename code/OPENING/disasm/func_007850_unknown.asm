; ============================================================================
; func_007850_unknown
; Region   : load_image
; Bytes    : file 0x007850..0x007961  (273 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007850  55                    PUSH   bp ; STACK_PUSH
007851  8B EC                 MOV    bp, sp ; MOV
007853  B8 08 00              MOV    ax, 8 ; MOV
007856  9A DC 03 52 04        LCALL  0x452, 0x3dc ; LCALL
00785B  57                    PUSH   di ; STACK_PUSH
00785C  56                    PUSH   si ; STACK_PUSH
00785D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007860  B8 5C 00              MOV    ax, 0x5c ; CONST_LOAD
007863  50                    PUSH   ax ; STACK_PUSH
007864  56                    PUSH   si ; STACK_PUSH
007865  9A E0 29 52 04        LCALL  0x452, 0x29e0 ; LCALL
00786A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00786D  8B F8                 MOV    di, ax ; MOV
00786F  B8 2F 00              MOV    ax, 0x2f ; CONST_LOAD
007872  50                    PUSH   ax ; STACK_PUSH
007873  56                    PUSH   si ; STACK_PUSH
007874  9A E0 29 52 04        LCALL  0x452, 0x29e0 ; LCALL
007879  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00787C  0B C0                 OR     ax, ax ; LOGIC
00787E  75 08                 JNE    0x7888 ; CJUMP
007880  0B FF                 OR     di, di ; LOGIC
007882  75 0E                 JNE    0x7892 ; CJUMP
007884  8B FE                 MOV    di, si ; MOV
007886  EB 0A                 JMP    0x7892 ; JUMP
007888  0B FF                 OR     di, di ; LOGIC
00788A  74 04                 JE     0x7890 ; CJUMP
00788C  3B C7                 CMP    ax, di ; CMP
00788E  76 02                 JBE    0x7892 ; CJUMP
007890  8B F8                 MOV    di, ax ; MOV
007892  B8 2E 00              MOV    ax, 0x2e ; CONST_LOAD
007895  50                    PUSH   ax ; STACK_PUSH
007896  57                    PUSH   di ; STACK_PUSH
007897  9A 2E 0A 52 04        LCALL  0x452, 0xa2e ; LCALL
00789C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00789F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0078A2  0B C0                 OR     ax, ax ; LOGIC
0078A4  74 24                 JE     0x78ca ; CJUMP
0078A6  FF 36 E8 45           PUSH   word ptr [0x45e8] ; PUSH_GLOBAL
0078AA  50                    PUSH   ax ; STACK_PUSH
0078AB  9A 9E 29 52 04        LCALL  0x452, 0x299e ; LCALL
0078B0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0078B3  50                    PUSH   ax ; STACK_PUSH
0078B4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0078B7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0078BA  56                    PUSH   si ; STACK_PUSH
0078BB  9A 9C 25 52 04        LCALL  0x452, 0x259c ; LCALL
0078C0  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0078C3  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0078C6  E9 8F 00              JMP    0x7958 ; JUMP
0078C9  90                    NOP ; NOP
0078CA  56                    PUSH   si ; STACK_PUSH
0078CB  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
0078D0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0078D3  05 05 00              ADD    ax, 5 ; ARITH
0078D6  50                    PUSH   ax ; STACK_PUSH
0078D7  9A 30 25 52 04        LCALL  0x452, 0x2530 ; LCALL
0078DC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0078DF  8B F8                 MOV    di, ax ; MOV
0078E1  0B FF                 OR     di, di ; LOGIC
0078E3  75 05                 JNE    0x78ea ; CJUMP
0078E5  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0078E8  EB 71                 JMP    0x795b ; JUMP
0078EA  56                    PUSH   si ; STACK_PUSH
0078EB  57                    PUSH   di ; STACK_PUSH
0078EC  9A C6 06 52 04        LCALL  0x452, 0x6c6 ; LCALL
0078F1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0078F4  56                    PUSH   si ; STACK_PUSH
0078F5  9A 24 07 52 04        LCALL  0x452, 0x724 ; LCALL
0078FA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0078FD  03 C7                 ADD    ax, di ; ARITH
0078FF  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007902  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
007907  C7 46 F8 02 00        MOV    word ptr [bp - 8], 2 ; LOCAL_STORE
00790C  EB 03                 JMP    0x7911 ; JUMP
00790E  FF 4E F8              DEC    word ptr [bp - 8] ; ARITH
007911  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
007915  7C 38                 JL     0x794f ; CJUMP
007917  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
00791A  D1 E3                 SHL    bx, 1 ; LOGIC
00791C  FF B7 E8 45           PUSH   word ptr [bx + 0x45e8] ; PUSH_GLOBAL
007920  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
007923  9A C6 06 52 04        LCALL  0x452, 0x6c6 ; LCALL
007928  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00792B  2B C0                 SUB    ax, ax ; ARITH
00792D  50                    PUSH   ax ; STACK_PUSH
00792E  57                    PUSH   di ; STACK_PUSH
00792F  9A 08 30 52 04        LCALL  0x452, 0x3008 ; LCALL
007934  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007937  40                    INC    ax ; ARITH
007938  74 D4                 JE     0x790e ; CJUMP
00793A  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00793D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
007940  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007943  57                    PUSH   di ; STACK_PUSH
007944  9A 9C 25 52 04        LCALL  0x452, 0x259c ; LCALL
007949  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00794C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00794F  57                    PUSH   di ; STACK_PUSH
007950  9A 36 25 52 04        LCALL  0x452, 0x2536 ; LCALL
007955  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007958  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00795B  5E                    POP    si ; STACK_POP
00795C  5F                    POP    di ; STACK_POP
00795D  8B E5                 MOV    sp, bp ; MOV
00795F  5D                    POP    bp ; STACK_POP
007960  CB                    RETF ; RETURN
