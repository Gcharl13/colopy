; ============================================================================
; func_06C2D6_unknown
; Region   : overlay
; Bytes    : file 0x06C2D6..0x06C327  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "~{}|"  (auto-named via string xrefs)
; ============================================================================

06C2D6  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
06C2DA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C2DD  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06C2E0  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06C2E3  16                    PUSH   ss ; STACK_PUSH
06C2E4  50                    PUSH   ax ; STACK_PUSH
06C2E5  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
06C2EA  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
06C2ED  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06C2F0  89 46 AE              MOV    word ptr [bp - 0x52], ax ; LOCAL_STORE
06C2F3  EB 2A                 JMP    0x6c31f ; JUMP
06C2F5  90                    NOP ; NOP
06C2F6  8A 07                 MOV    al, byte ptr [bx] ; MOV
06C2F8  2A E4                 SUB    ah, ah ; ARITH
06C2FA  50                    PUSH   ax ; STACK_PUSH
06C2FB  68 8C 1F              PUSH   0x1f8c                       ; STRING: "~{}|"
06C2FE  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
06C303  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06C306  0B C0                 OR     ax, ax ; LOGIC
06C308  74 12                 JE     0x6c31c ; CJUMP
06C30A  8B 46 AE              MOV    ax, word ptr [bp - 0x52] ; LOCAL_LOAD
06C30D  40                    INC    ax ; ARITH
06C30E  50                    PUSH   ax ; STACK_PUSH
06C30F  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
06C312  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06C317  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06C31A  EB 03                 JMP    0x6c31f ; JUMP
06C31C  FF 46 AE              INC    word ptr [bp - 0x52] ; ARITH
06C31F  8B 5E AE              MOV    bx, word ptr [bp - 0x52] ; LOCAL_LOAD
06C322  80 3F 00              CMP    byte ptr [bx], 0 ; CMP
06C325  75 CF                 JNE    0x6c2f6 ; CJUMP
