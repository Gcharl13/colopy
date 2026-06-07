; ============================================================================
; func_01000E_unknown
; Region   : load_image
; Bytes    : file 0x01000E..0x01008D  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01000E  55                    PUSH   bp ; STACK_PUSH
01000F  8B EC                 MOV    bp, sp ; MOV
010011  56                    PUSH   si ; STACK_PUSH
010012  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
010015  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
010019  74 0C                 JE     0x10027 ; CJUMP
01001B  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2 ; CMP
01001F  7F 06                 JG     0x10027 ; CJUMP
010021  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
010025  7D 09                 JGE    0x10030 ; CJUMP
010027  C7 06 AC 27 16 00     MOV    word ptr [0x27ac], 0x16 ; GLOBAL_LOAD
01002D  EB 52                 JMP    0x10081 ; JUMP
01002F  90                    NOP ; NOP
010030  80 64 06 EF           AND    byte ptr [si + 6], 0xef ; LOGIC
010034  83 7E 0C 01           CMP    word ptr [bp + 0xc], 1 ; CMP
010038  75 14                 JNE    0x1004e ; CJUMP
01003A  56                    PUSH   si ; STACK_PUSH
01003B  9A 90 22 1D 0D        LCALL  0xd1d, 0x2290 ; LCALL
010040  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
010043  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
010046  11 56 0A              ADC    word ptr [bp + 0xa], dx ; ARITH
010049  C7 46 0C 00 00        MOV    word ptr [bp + 0xc], 0 ; LOCAL_STORE
01004E  56                    PUSH   si ; STACK_PUSH
01004F  9A 96 18 1D 0D        LCALL  0xd1d, 0x1896 ; LCALL
010054  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
010057  F6 44 06 80           TEST   byte ptr [si + 6], 0x80 ; LOGIC
01005B  74 04                 JE     0x10061 ; CJUMP
01005D  80 64 06 FC           AND    byte ptr [si + 6], 0xfc ; LOGIC
010061  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
010064  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
010067  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01006A  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
01006D  2A E4                 SUB    ah, ah ; ARITH
01006F  50                    PUSH   ax ; STACK_PUSH
010070  9A 9A 1E 1D 0D        LCALL  0xd1d, 0x1e9a ; LCALL
010075  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
010078  3D FF FF              CMP    ax, 0xffff ; CMP
01007B  75 09                 JNE    0x10086 ; CJUMP
01007D  3B D0                 CMP    dx, ax ; CMP
01007F  75 05                 JNE    0x10086 ; CJUMP
010081  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
010084  EB 02                 JMP    0x10088 ; JUMP
010086  2B C0                 SUB    ax, ax ; ARITH
010088  5E                    POP    si ; STACK_POP
010089  8B E5                 MOV    sp, bp ; MOV
01008B  5D                    POP    bp ; STACK_POP
01008C  CB                    RETF ; RETURN
