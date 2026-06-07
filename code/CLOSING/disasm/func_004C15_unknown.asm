; ============================================================================
; func_004C15_unknown
; Region   : load_image
; Bytes    : file 0x004C15..0x004C3E  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004C15  55                    PUSH   bp ; STACK_PUSH
004C16  8B EC                 MOV    bp, sp ; MOV
004C18  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
004C1A  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004C1D  8B 4E 0C              MOV    cx, word ptr [bp + 0xc] ; LOCAL_LOAD
004C20  81 3E B0 43 D6 D6     CMP    word ptr [0x43b0], 0xd6d6 ; CMP
004C26  75 04                 JNE    0x4c2c ; CJUMP
004C28  FF 16 B2 43           CALL   word ptr [0x43b2] ; CALL_NEAR
004C2C  1E                    PUSH   ds ; STACK_PUSH
004C2D  C5 56 08              LDS    dx, ptr [bp + 8] ; MOV_FAR
004C30  CD 21                 INT    0x21 ; SYS
004C32  1F                    POP    ds ; STACK_POP
004C33  72 05                 JB     0x4c3a ; CJUMP
004C35  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
004C38  89 07                 MOV    word ptr [bx], ax ; MOV
004C3A  E9 1F 07              JMP    0x535c ; JUMP
004C3D  00                    DB     0x00 ; DATA_BYTE
