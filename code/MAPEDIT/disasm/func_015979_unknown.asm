; ============================================================================
; func_015979_unknown
; Region   : load_image
; Bytes    : file 0x015979..0x0159A2  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015979  55                    PUSH   bp ; STACK_PUSH
01597A  8B EC                 MOV    bp, sp ; MOV
01597C  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
01597E  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
015981  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
015984  81 3E 96 48 D6 D6     CMP    word ptr [0x4896], 0xd6d6 ; CMP
01598A  75 04                 JNE    0x15990 ; CJUMP
01598C  FF 16 98 48           CALL   word ptr [0x4898] ; CALL_NEAR
015990  1E                    PUSH   ds ; STACK_PUSH
015991  C5 56 08              LDS    dx, ptr [bp + 8] ; MOV_FAR
015994  CD 21                 INT    0x21 ; SYS
015996  1F                    POP    ds ; STACK_POP
015997  72 05                 JB     0x1599e ; CJUMP
015999  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
01599C  89 07                 MOV    word ptr [bx], ax ; MOV
01599E  E9 1F 07              JMP    0x160c0 ; JUMP
0159A1  00                    DB     0x00 ; DATA_BYTE
