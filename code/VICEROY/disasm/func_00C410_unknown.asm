; ============================================================================
; func_00C410_unknown
; Region   : load_image
; Bytes    : file 0x00C410..0x00C459  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C410  55                    PUSH   bp ; STACK_PUSH
00C411  8B EC                 MOV    bp, sp ; MOV
00C413  57                    PUSH   di ; STACK_PUSH
00C414  56                    PUSH   si ; STACK_PUSH
00C415  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
00C418  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
00C41B  26 80 3C 2A           CMP    byte ptr es:[si], 0x2a ; CMP
00C41F  75 03                 JNE    0xc424 ; CJUMP
00C421  46                    INC    si ; ARITH
00C422  8C C0                 MOV    ax, es ; MOV
00C424  83 3E 6C 03 00        CMP    word ptr [0x36c], 0 ; CMP
00C429  75 13                 JNE    0xc43e ; CJUMP
00C42B  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00C42E  06                    PUSH   es ; STACK_PUSH
00C42F  56                    PUSH   si ; STACK_PUSH
00C430  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C433  57                    PUSH   di ; STACK_PUSH
00C434  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00C439  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00C43C  EB 12                 JMP    0xc450 ; JUMP
00C43E  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00C441  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00C444  57                    PUSH   di ; STACK_PUSH
00C445  1E                    PUSH   ds ; STACK_PUSH
00C446  68 FE 84              PUSH   0x84fe ; PUSH_CONST
00C449  06                    PUSH   es ; STACK_PUSH
00C44A  56                    PUSH   si ; STACK_PUSH
00C44B  9A 04 00 4E 0B        LCALL  0xb4e, 4 ; LCALL
00C450  8B C7                 MOV    ax, di ; MOV
00C452  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
00C455  5E                    POP    si ; STACK_POP
00C456  5F                    POP    di ; STACK_POP
00C457  C9                    LEAVE ; EPILOGUE
00C458  CB                    RETF ; RETURN
