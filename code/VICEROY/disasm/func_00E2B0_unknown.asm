; ============================================================================
; func_00E2B0_unknown
; Region   : load_image
; Bytes    : file 0x00E2B0..0x00E34F  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "$MPOP.$"  (auto-named via string xrefs)
; ============================================================================

00E2B0  C8 2A 00 00           ENTER  0x2a, 0 ; PROLOGUE
00E2B4  52                    PUSH   dx ; STACK_PUSH
00E2B5  50                    PUSH   ax ; STACK_PUSH
00E2B6  53                    PUSH   bx ; STACK_PUSH
00E2B7  57                    PUSH   di ; STACK_PUSH
00E2B8  56                    PUSH   si ; STACK_PUSH
00E2B9  68 34 26              PUSH   0x2634                       ; STRING: "$MPOP.$"
00E2BC  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
00E2BF  50                    PUSH   ax ; STACK_PUSH
00E2C0  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
00E2C5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00E2C8  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
00E2CB  16                    PUSH   ss ; STACK_PUSH
00E2CC  50                    PUSH   ax ; STACK_PUSH
00E2CD  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
00E2D0  BA 01 00              MOV    dx, 1 ; MOV
00E2D3  9A 02 00 F6 09        LCALL  0x9f6, 2 ; LCALL
00E2D8  68 48 26              PUSH   0x2648 ; PUSH_CONST
00E2DB  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
00E2DE  50                    PUSH   ax ; STACK_PUSH
00E2DF  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
00E2E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00E2E7  8B F8                 MOV    di, ax ; MOV
00E2E9  0B FF                 OR     di, di ; LOGIC
00E2EB  74 35                 JE     0xe322 ; CJUMP
00E2ED  2B F6                 SUB    si, si ; ARITH
00E2EF  39 76 06              CMP    word ptr [bp + 6], si ; CMP
00E2F2  7E 2E                 JLE    0xe322 ; CJUMP
00E2F4  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
00E2F7  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
00E2FA  03 D6                 ADD    dx, si ; ARITH
00E2FC  8B 5E D0              MOV    bx, word ptr [bp - 0x30] ; LOCAL_LOAD
00E2FF  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
00E302  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00E307  52                    PUSH   dx ; STACK_PUSH
00E308  50                    PUSH   ax ; STACK_PUSH
00E309  6A 00                 PUSH   0 ; STACK_PUSH
00E30B  6A 01                 PUSH   1 ; STACK_PUSH
00E30D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00E310  99                    CDQ ; ARITH
00E311  8B DF                 MOV    bx, di ; MOV
00E313  9A 0E 00 01 0B        LCALL  0xb01, 0xe ; LCALL
00E318  0B D0                 OR     dx, ax ; LOGIC
00E31A  74 06                 JE     0xe322 ; CJUMP
00E31C  46                    INC    si ; ARITH
00E31D  39 76 06              CMP    word ptr [bp + 6], si ; CMP
00E320  7F D5                 JG     0xe2f7 ; CJUMP
00E322  0B FF                 OR     di, di ; LOGIC
00E324  74 23                 JE     0xe349 ; CJUMP
00E326  57                    PUSH   di ; STACK_PUSH
00E327  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
00E32C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00E32F  83 7E D4 00           CMP    word ptr [bp - 0x2c], 0 ; CMP
00E333  75 14                 JNE    0xe349 ; CJUMP
00E335  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
00E338  C6 87 3E 26 00        MOV    byte ptr [bx + 0x263e], 0 ; MOV
00E33D  8D 46 D6              LEA    ax, [bp - 0x2a] ; ADDR
00E340  50                    PUSH   ax ; STACK_PUSH
00E341  9A 4A 0E 1D 0D        LCALL  0xd1d, 0xe4a ; LCALL
00E346  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00E349  5E                    POP    si ; STACK_POP
00E34A  5F                    POP    di ; STACK_POP
00E34B  C9                    LEAVE ; EPILOGUE
00E34C  CA 08 00              RETF   8 ; RETURN
