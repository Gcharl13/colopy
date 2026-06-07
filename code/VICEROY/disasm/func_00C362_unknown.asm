; ============================================================================
; func_00C362_unknown
; Region   : load_image
; Bytes    : file 0x00C362..0x00C40F  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C362  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00C366  52                    PUSH   dx ; STACK_PUSH
00C367  50                    PUSH   ax ; STACK_PUSH
00C368  57                    PUSH   di ; STACK_PUSH
00C369  56                    PUSH   si ; STACK_PUSH
00C36A  BF 01 00              MOV    di, 1 ; MOV
00C36D  2B F6                 SUB    si, si ; ARITH
00C36F  3B D6                 CMP    dx, si ; CMP
00C371  7E 23                 JLE    0xc396 ; CJUMP
00C373  0B F6                 OR     si, si ; LOGIC
00C375  7E 07                 JLE    0xc37e ; CJUMP
00C377  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
00C37A  F7 EF                 IMUL   di ; ARITH
00C37C  8B F8                 MOV    di, ax ; MOV
00C37E  1E                    PUSH   ds ; STACK_PUSH
00C37F  68 68 03              PUSH   0x368 ; PUSH_CONST
00C382  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C385  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C388  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
00C38D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00C390  46                    INC    si ; ARITH
00C391  3B 76 F8              CMP    si, word ptr [bp - 8] ; CMP
00C394  7C DD                 JL     0xc373 ; CJUMP
00C396  89 7E FA              MOV    word ptr [bp - 6], di ; LOCAL_STORE
00C399  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C39C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C39F  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
00C3A4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C3A7  8B F0                 MOV    si, ax ; MOV
00C3A9  2B 76 F8              SUB    si, word ptr [bp - 8] ; ARITH
00C3AC  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C3AF  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C3B2  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
00C3B7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C3BA  3B C6                 CMP    ax, si ; CMP
00C3BC  76 45                 JBE    0xc403 ; CJUMP
00C3BE  89 76 FC              MOV    word ptr [bp - 4], si ; LOCAL_STORE
00C3C1  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
00C3C4  8B 7E F6              MOV    di, word ptr [bp - 0xa] ; LOCAL_LOAD
00C3C7  3B F7                 CMP    si, di ; CMP
00C3C9  7F 18                 JG     0xc3e3 ; CJUMP
00C3CB  8B C7                 MOV    ax, di ; MOV
00C3CD  99                    CDQ ; ARITH
00C3CE  F7 FE                 IDIV   si ; ARITH
00C3D0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00C3D3  F7 EE                 IMUL   si ; ARITH
00C3D5  2B F8                 SUB    di, ax ; ARITH
00C3D7  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
00C3DA  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
00C3DD  03 5E FC              ADD    bx, word ptr [bp - 4] ; ARITH
00C3E0  26 00 07              ADD    byte ptr es:[bx], al ; ARITH
00C3E3  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
00C3E6  8B C6                 MOV    ax, si ; MOV
00C3E8  99                    CDQ ; ARITH
00C3E9  F7 F9                 IDIV   cx ; ARITH
00C3EB  8B F0                 MOV    si, ax ; MOV
00C3ED  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C3F0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00C3F3  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
00C3F8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C3FB  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00C3FE  3B 46 FC              CMP    ax, word ptr [bp - 4] ; CMP
00C401  77 C4                 JA     0xc3c7 ; CJUMP
00C403  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00C406  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00C409  5E                    POP    si ; STACK_POP
00C40A  5F                    POP    di ; STACK_POP
00C40B  C9                    LEAVE ; EPILOGUE
00C40C  CA 04 00              RETF   4 ; RETURN
