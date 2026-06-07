; ============================================================================
; __aFldiv  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x010496 (152 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 32-bit signed long divide
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x004C3E..0x004CD6  (152 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x010496)
; ============================================================================

004C3E  55                    PUSH   bp ; STACK_PUSH
004C3F  8B EC                 MOV    bp, sp ; MOV
004C41  57                    PUSH   di ; STACK_PUSH
004C42  56                    PUSH   si ; STACK_PUSH
004C43  53                    PUSH   bx ; STACK_PUSH
004C44  33 FF                 XOR    di, di ; LOGIC
004C46  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
004C49  0B C0                 OR     ax, ax ; LOGIC
004C4B  7D 11                 JGE    0x4c5e ; CJUMP
004C4D  47                    INC    di ; ARITH
004C4E  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
004C51  F7 D8                 NEG    ax ; ARITH
004C53  F7 DA                 NEG    dx ; ARITH
004C55  1D 00 00              SBB    ax, 0 ; ARITH
004C58  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
004C5B  89 56 06              MOV    word ptr [bp + 6], dx ; LOCAL_STORE
004C5E  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
004C61  0B C0                 OR     ax, ax ; LOGIC
004C63  7D 11                 JGE    0x4c76 ; CJUMP
004C65  47                    INC    di ; ARITH
004C66  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
004C69  F7 D8                 NEG    ax ; ARITH
004C6B  F7 DA                 NEG    dx ; ARITH
004C6D  1D 00 00              SBB    ax, 0 ; ARITH
004C70  89 46 0C              MOV    word ptr [bp + 0xc], ax ; LOCAL_STORE
004C73  89 56 0A              MOV    word ptr [bp + 0xa], dx ; LOCAL_STORE
004C76  0B C0                 OR     ax, ax ; LOGIC
004C78  75 15                 JNE    0x4c8f ; CJUMP
004C7A  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
004C7D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
004C80  33 D2                 XOR    dx, dx ; LOGIC
004C82  F7 F1                 DIV    cx ; ARITH
004C84  8B D8                 MOV    bx, ax ; MOV
004C86  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004C89  F7 F1                 DIV    cx ; ARITH
004C8B  8B D3                 MOV    dx, bx ; MOV
004C8D  EB 38                 JMP    0x4cc7 ; JUMP
004C8F  8B D8                 MOV    bx, ax ; MOV
004C91  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
004C94  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
004C97  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004C9A  D1 EB                 SHR    bx, 1 ; LOGIC
004C9C  D1 D9                 RCR    cx, 1 ; LOGIC
004C9E  D1 EA                 SHR    dx, 1 ; LOGIC
004CA0  D1 D8                 RCR    ax, 1 ; LOGIC
004CA2  0B DB                 OR     bx, bx ; LOGIC
004CA4  75 F4                 JNE    0x4c9a ; CJUMP
004CA6  F7 F1                 DIV    cx ; ARITH
004CA8  8B F0                 MOV    si, ax ; MOV
004CAA  F7 66 0C              MUL    word ptr [bp + 0xc] ; ARITH
004CAD  91                    XCHG   cx, ax ; MOV
004CAE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
004CB1  F7 E6                 MUL    si ; ARITH
004CB3  03 D1                 ADD    dx, cx ; ARITH
004CB5  72 0C                 JB     0x4cc3 ; CJUMP
004CB7  3B 56 08              CMP    dx, word ptr [bp + 8] ; CMP
004CBA  77 07                 JA     0x4cc3 ; CJUMP
004CBC  72 06                 JB     0x4cc4 ; CJUMP
004CBE  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
004CC1  76 01                 JBE    0x4cc4 ; CJUMP
004CC3  4E                    DEC    si ; ARITH
004CC4  33 D2                 XOR    dx, dx ; LOGIC
004CC6  96                    XCHG   si, ax ; MOV
004CC7  4F                    DEC    di ; ARITH
004CC8  75 07                 JNE    0x4cd1 ; CJUMP
004CCA  F7 DA                 NEG    dx ; ARITH
004CCC  F7 D8                 NEG    ax ; ARITH
004CCE  83 DA 00              SBB    dx, 0 ; ARITH
004CD1  5B                    POP    bx ; STACK_POP
004CD2  5E                    POP    si ; STACK_POP
004CD3  5F                    POP    di ; STACK_POP
004CD4  5D                    POP    bp ; STACK_POP
004CD5  CA 08 00              RETF   8 ; RETURN
