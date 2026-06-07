; ============================================================================
; func_00BC0C_unknown
; Region   : load_image
; Bytes    : file 0x00BC0C..0x00BC85  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BC0C  55                    PUSH   bp ; STACK_PUSH
00BC0D  8B EC                 MOV    bp, sp ; MOV
00BC0F  56                    PUSH   si ; STACK_PUSH
00BC10  83 3E 28 5E 00        CMP    word ptr [0x5e28], 0 ; CMP
00BC15  7C 21                 JL     0xbc38 ; CJUMP
00BC17  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00BC1A  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
00BC1D  2B D2                 SUB    dx, dx ; ARITH
00BC1F  3B 16 28 5E           CMP    dx, word ptr [0x5e28] ; CMP
00BC23  7C 0F                 JL     0xbc34 ; CJUMP
00BC25  7F 06                 JG     0xbc2d ; CJUMP
00BC27  3B 06 26 5E           CMP    ax, word ptr [0x5e26] ; CMP
00BC2B  76 07                 JBE    0xbc34 ; CJUMP
00BC2D  8B 16 28 5E           MOV    dx, word ptr [0x5e28] ; GLOBAL_LOAD
00BC31  A1 26 5E              MOV    ax, word ptr [0x5e26] ; GLOBAL_LOAD
00BC34  8B F0                 MOV    si, ax ; MOV
00BC36  EB 06                 JMP    0xbc3e ; JUMP
00BC38  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00BC3B  26 8B 37              MOV    si, word ptr es:[bx] ; MOV
00BC3E  0B F6                 OR     si, si ; LOGIC
00BC40  74 3C                 JE     0xbc7e ; CJUMP
00BC42  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00BC45  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00BC48  6A 00                 PUSH   0 ; STACK_PUSH
00BC4A  56                    PUSH   si ; STACK_PUSH
00BC4B  B8 01 00              MOV    ax, 1 ; MOV
00BC4E  99                    CDQ ; ARITH
00BC4F  8B 1E BC 5C           MOV    bx, word ptr [0x5cbc] ; GLOBAL_LOAD
00BC53  9A 08 00 B4 08        LCALL  0x8b4, 8 ; LCALL
00BC58  8B F0                 MOV    si, ax ; MOV
00BC5A  83 3E 28 5E 00        CMP    word ptr [0x5e28], 0 ; CMP
00BC5F  7C 13                 JL     0xbc74 ; CJUMP
00BC61  7F 07                 JG     0xbc6a ; CJUMP
00BC63  83 3E 26 5E 00        CMP    word ptr [0x5e26], 0 ; CMP
00BC68  74 0A                 JE     0xbc74 ; CJUMP
00BC6A  2B C0                 SUB    ax, ax ; ARITH
00BC6C  29 36 26 5E           SUB    word ptr [0x5e26], si ; ARITH
00BC70  19 06 28 5E           SBB    word ptr [0x5e28], ax ; ARITH
00BC74  2B C0                 SUB    ax, ax ; ARITH
00BC76  01 36 04 4F           ADD    word ptr [0x4f04], si ; ARITH
00BC7A  11 06 06 4F           ADC    word ptr [0x4f06], ax ; ARITH
00BC7E  8B C6                 MOV    ax, si ; MOV
00BC80  5E                    POP    si ; STACK_POP
00BC81  C9                    LEAVE ; EPILOGUE
00BC82  CA 08 00              RETF   8 ; RETURN
