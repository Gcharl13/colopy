; ============================================================================
; func_06C492_unknown
; Region   : overlay
; Bytes    : file 0x06C492..0x06C4CF  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C492  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
06C496  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
06C49B  6A 7E                 PUSH   0x7e ; PUSH_CONST
06C49D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C4A0  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06C4A3  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
06C4A8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06C4AB  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06C4AE  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06C4B1  6A 7E                 PUSH   0x7e ; PUSH_CONST
06C4B3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C4B6  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06C4B9  9A 10 10 1D 0D        LCALL  0xd1d, 0x1010 ; LCALL
06C4BE  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
06C4C1  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
06C4C4  75 05                 JNE    0x6c4cb ; CJUMP
06C4C6  3B 56 FC              CMP    dx, word ptr [bp - 4] ; CMP
06C4C9  74 21                 JE     0x6c4ec ; CJUMP
06C4CB  8E C2                 MOV    es, dx ; MOV
06C4CD  8B D8                 MOV    bx, ax ; MOV
