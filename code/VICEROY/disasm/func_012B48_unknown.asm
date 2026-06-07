; ============================================================================
; func_012B48_unknown
; Region   : load_image
; Bytes    : file 0x012B48..0x012BC1  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012B48  55                    PUSH   bp ; STACK_PUSH
012B49  8B EC                 MOV    bp, sp ; MOV
012B4B  56                    PUSH   si ; STACK_PUSH
012B4C  83 3E 32 A6 00        CMP    word ptr [0xa632], 0 ; CMP
012B51  7C 21                 JL     0x12b74 ; CJUMP
012B53  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
012B56  26 8B 07              MOV    ax, word ptr es:[bx] ; MOV
012B59  2B D2                 SUB    dx, dx ; ARITH
012B5B  3B 16 32 A6           CMP    dx, word ptr [0xa632] ; CMP
012B5F  7C 0F                 JL     0x12b70 ; CJUMP
012B61  7F 06                 JG     0x12b69 ; CJUMP
012B63  3B 06 30 A6           CMP    ax, word ptr [0xa630] ; CMP
012B67  76 07                 JBE    0x12b70 ; CJUMP
012B69  8B 16 32 A6           MOV    dx, word ptr [0xa632] ; GLOBAL_LOAD
012B6D  A1 30 A6              MOV    ax, word ptr [0xa630] ; GLOBAL_LOAD
012B70  8B F0                 MOV    si, ax ; MOV
012B72  EB 06                 JMP    0x12b7a ; JUMP
012B74  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
012B77  26 8B 37              MOV    si, word ptr es:[bx] ; MOV
012B7A  0B F6                 OR     si, si ; LOGIC
012B7C  74 3C                 JE     0x12bba ; CJUMP
012B7E  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
012B81  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
012B84  6A 00                 PUSH   0 ; STACK_PUSH
012B86  56                    PUSH   si ; STACK_PUSH
012B87  B8 01 00              MOV    ax, 1 ; MOV
012B8A  99                    CDQ ; ARITH
012B8B  8B 1E 42 A6           MOV    bx, word ptr [0xa642] ; GLOBAL_LOAD
012B8F  9A 0E 00 01 0B        LCALL  0xb01, 0xe ; LCALL
012B94  8B F0                 MOV    si, ax ; MOV
012B96  83 3E 32 A6 00        CMP    word ptr [0xa632], 0 ; CMP
012B9B  7C 13                 JL     0x12bb0 ; CJUMP
012B9D  7F 07                 JG     0x12ba6 ; CJUMP
012B9F  83 3E 30 A6 00        CMP    word ptr [0xa630], 0 ; CMP
012BA4  74 0A                 JE     0x12bb0 ; CJUMP
012BA6  2B C0                 SUB    ax, ax ; ARITH
012BA8  29 36 30 A6           SUB    word ptr [0xa630], si ; ARITH
012BAC  19 06 32 A6           SBB    word ptr [0xa632], ax ; ARITH
012BB0  2B C0                 SUB    ax, ax ; ARITH
012BB2  01 36 34 A6           ADD    word ptr [0xa634], si ; ARITH
012BB6  11 06 36 A6           ADC    word ptr [0xa636], ax ; ARITH
012BBA  8B C6                 MOV    ax, si ; MOV
012BBC  5E                    POP    si ; STACK_POP
012BBD  C9                    LEAVE ; EPILOGUE
012BBE  CA 08 00              RETF   8 ; RETURN
