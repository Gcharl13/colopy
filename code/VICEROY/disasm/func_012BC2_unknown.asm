; ============================================================================
; func_012BC2_unknown
; Region   : load_image
; Bytes    : file 0x012BC2..0x012C53  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012BC2  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
012BC6  56                    PUSH   si ; STACK_PUSH
012BC7  83 3E 2E A6 00        CMP    word ptr [0xa62e], 0 ; CMP
012BCC  7C 22                 JL     0x12bf0 ; CJUMP
012BCE  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
012BD1  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
012BD4  2B D2                 SUB    dx, dx ; ARITH
012BD6  3B 16 2E A6           CMP    dx, word ptr [0xa62e] ; CMP
012BDA  7C 0F                 JL     0x12beb ; CJUMP
012BDC  7F 06                 JG     0x12be4 ; CJUMP
012BDE  3B 06 2C A6           CMP    ax, word ptr [0xa62c] ; CMP
012BE2  76 07                 JBE    0x12beb ; CJUMP
012BE4  8B 16 2E A6           MOV    dx, word ptr [0xa62e] ; GLOBAL_LOAD
012BE8  A1 2C A6              MOV    ax, word ptr [0xa62c] ; GLOBAL_LOAD
012BEB  8B F0                 MOV    si, ax ; MOV
012BED  EB 07                 JMP    0x12bf6 ; JUMP
012BEF  90                    NOP ; NOP
012BF0  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
012BF3  26 8B 37              MOV    si, word ptr es:[bx] ; MOV
012BF6  0B F6                 OR     si, si ; LOGIC
012BF8  74 52                 JE     0x12c4c ; CJUMP
012BFA  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
012BFD  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
012C00  6A 00                 PUSH   0 ; STACK_PUSH
012C02  6A 01                 PUSH   1 ; STACK_PUSH
012C04  8B C6                 MOV    ax, si ; MOV
012C06  2B D2                 SUB    dx, dx ; ARITH
012C08  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
012C0B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
012C0E  8B 1E 38 A6           MOV    bx, word ptr [0xa638] ; GLOBAL_LOAD
012C12  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
012C17  0B D0                 OR     dx, ax ; LOGIC
012C19  75 05                 JNE    0x12c20 ; CJUMP
012C1B  2B F6                 SUB    si, si ; ARITH
012C1D  EB 2D                 JMP    0x12c4c ; JUMP
012C1F  90                    NOP ; NOP
012C20  83 3E 2E A6 00        CMP    word ptr [0xa62e], 0 ; CMP
012C25  7C 17                 JL     0x12c3e ; CJUMP
012C27  7F 07                 JG     0x12c30 ; CJUMP
012C29  83 3E 2C A6 00        CMP    word ptr [0xa62c], 0 ; CMP
012C2E  74 0E                 JE     0x12c3e ; CJUMP
012C30  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
012C33  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
012C36  29 06 2C A6           SUB    word ptr [0xa62c], ax ; ARITH
012C3A  19 16 2E A6           SBB    word ptr [0xa62e], dx ; ARITH
012C3E  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
012C41  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
012C44  01 06 28 A6           ADD    word ptr [0xa628], ax ; ARITH
012C48  11 16 2A A6           ADC    word ptr [0xa62a], dx ; ARITH
012C4C  8B C6                 MOV    ax, si ; MOV
012C4E  5E                    POP    si ; STACK_POP
012C4F  C9                    LEAVE ; EPILOGUE
012C50  CA 08 00              RETF   8 ; RETURN
