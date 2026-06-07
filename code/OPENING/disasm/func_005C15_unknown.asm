; ============================================================================
; func_005C15_unknown
; Region   : load_image
; Bytes    : file 0x005C15..0x005C3E  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C15  55                    PUSH   bp ; STACK_PUSH
005C16  8B EC                 MOV    bp, sp ; MOV
005C18  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
005C1A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
005C1D  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
005C20  81 3E 06 46 D6 D6     CMP    word ptr [0x4606], 0xd6d6 ; CMP
005C26  75 04                 JNE    0x5c2c ; CJUMP
005C28  FF 16 08 46           CALL   word ptr [0x4608] ; CALL_NEAR
005C2C  1E                    PUSH   ds ; STACK_PUSH
005C2D  C5 56 08              LDS    dx, ptr [bp + 8] ; MOV_FAR
005C30  CD 21                 INT    0x21 ; SYS
005C32  1F                    POP    ds ; STACK_POP
005C33  72 05                 JB     0x5c3a ; CJUMP
005C35  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
005C38  89 07                 MOV    word ptr [bx], ax ; MOV
005C3A  E9 1F 07              JMP    0x635c ; JUMP
005C3D  00                    DB     0x00 ; DATA_BYTE
