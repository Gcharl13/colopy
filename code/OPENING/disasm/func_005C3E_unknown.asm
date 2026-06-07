; ============================================================================
; __aFldiv  (BYTE_VERIFIED via sigmatch — inherited annotation)
; ----------------------------------------------------------------------------
; This function's bytes match VICEROY.EXE at 0x010496 (152 bytes).
; That source location is BYTE_VERIFIED (hand-decompiled in viceroy_source/).
;
; Description: MSC 6.0 32-bit signed long divide
; ----------------------------------------------------------------------------
; Region   : load_image
; Bytes    : file 0x005C3E..0x005CD6  (152 bytes)
; Status   : BYTE_VERIFIED (sigmatch — same bytes as VICEROY 0x010496)
; ============================================================================

005C3E  55                    PUSH   bp ; STACK_PUSH
005C3F  8B EC                 MOV    bp, sp ; MOV
005C41  57                    PUSH   di ; STACK_PUSH
005C42  56                    PUSH   si ; STACK_PUSH
005C43  53                    PUSH   bx ; STACK_PUSH
005C44  33 FF                 XOR    di, di ; LOGIC
005C46  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005C49  0B C0                 OR     ax, ax ; LOGIC
005C4B  7D 11                 JGE    0x5c5e ; CJUMP
005C4D  47                    INC    di ; ARITH
005C4E  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
005C51  F7 D8                 NEG    ax ; ARITH
005C53  F7 DA                 NEG    dx ; ARITH
005C55  1D 00 00              SBB    ax, 0 ; ARITH
005C58  89 46 08              MOV    word ptr [bp + 8], ax ; LOCAL_STORE
005C5B  89 56 06              MOV    word ptr [bp + 6], dx ; LOCAL_STORE
005C5E  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
005C61  0B C0                 OR     ax, ax ; LOGIC
005C63  7D 11                 JGE    0x5c76 ; CJUMP
005C65  47                    INC    di ; ARITH
005C66  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
005C69  F7 D8                 NEG    ax ; ARITH
005C6B  F7 DA                 NEG    dx ; ARITH
005C6D  1D 00 00              SBB    ax, 0 ; ARITH
005C70  89 46 0C              MOV    word ptr [bp + 0xc], ax ; LOCAL_STORE
005C73  89 56 0A              MOV    word ptr [bp + 0xa], dx ; LOCAL_STORE
005C76  0B C0                 OR     ax, ax ; LOGIC
005C78  75 15                 JNE    0x5c8f ; CJUMP
005C7A  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005C7D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005C80  33 D2                 XOR    dx, dx ; LOGIC
005C82  F7 F1                 DIV    cx ; ARITH
005C84  8B D8                 MOV    bx, ax ; MOV
005C86  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005C89  F7 F1                 DIV    cx ; ARITH
005C8B  8B D3                 MOV    dx, bx ; MOV
005C8D  EB 38                 JMP    0x5cc7 ; JUMP
005C8F  8B D8                 MOV    bx, ax ; MOV
005C91  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
005C94  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
005C97  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005C9A  D1 EB                 SHR    bx, 1 ; LOGIC
005C9C  D1 D9                 RCR    cx, 1 ; LOGIC
005C9E  D1 EA                 SHR    dx, 1 ; LOGIC
005CA0  D1 D8                 RCR    ax, 1 ; LOGIC
005CA2  0B DB                 OR     bx, bx ; LOGIC
005CA4  75 F4                 JNE    0x5c9a ; CJUMP
005CA6  F7 F1                 DIV    cx ; ARITH
005CA8  8B F0                 MOV    si, ax ; MOV
005CAA  F7 66 0C              MUL    word ptr [bp + 0xc] ; ARITH
005CAD  91                    XCHG   cx, ax ; MOV
005CAE  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
005CB1  F7 E6                 MUL    si ; ARITH
005CB3  03 D1                 ADD    dx, cx ; ARITH
005CB5  72 0C                 JB     0x5cc3 ; CJUMP
005CB7  3B 56 08              CMP    dx, word ptr [bp + 8] ; CMP
005CBA  77 07                 JA     0x5cc3 ; CJUMP
005CBC  72 06                 JB     0x5cc4 ; CJUMP
005CBE  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
005CC1  76 01                 JBE    0x5cc4 ; CJUMP
005CC3  4E                    DEC    si ; ARITH
005CC4  33 D2                 XOR    dx, dx ; LOGIC
005CC6  96                    XCHG   si, ax ; MOV
005CC7  4F                    DEC    di ; ARITH
005CC8  75 07                 JNE    0x5cd1 ; CJUMP
005CCA  F7 DA                 NEG    dx ; ARITH
005CCC  F7 D8                 NEG    ax ; ARITH
005CCE  83 DA 00              SBB    dx, 0 ; ARITH
005CD1  5B                    POP    bx ; STACK_POP
005CD2  5E                    POP    si ; STACK_POP
005CD3  5F                    POP    di ; STACK_POP
005CD4  5D                    POP    bp ; STACK_POP
005CD5  CA 08 00              RETF   8 ; RETURN
