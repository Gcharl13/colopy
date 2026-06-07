; ============================================================================
; func_00176A_unknown
; Region   : load_image
; Bytes    : file 0x00176A..0x0017B3  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00176A  55                    PUSH   bp ; STACK_PUSH
00176B  8B EC                 MOV    bp, sp ; MOV
00176D  57                    PUSH   di ; STACK_PUSH
00176E  56                    PUSH   si ; STACK_PUSH
00176F  8B 76 0A              MOV    si, word ptr [bp + 0xa] ; LOCAL_LOAD
001772  8E 46 0C              MOV    es, word ptr [bp + 0xc] ; LOCAL_LOAD
001775  26 80 3C 2A           CMP    byte ptr es:[si], 0x2a ; CMP
001779  75 03                 JNE    0x177e ; CJUMP
00177B  46                    INC    si ; ARITH
00177C  8C C0                 MOV    ax, es ; MOV
00177E  83 3E 9C 01 00        CMP    word ptr [0x19c], 0 ; CMP
001783  75 13                 JNE    0x1798 ; CJUMP
001785  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
001788  06                    PUSH   es ; STACK_PUSH
001789  56                    PUSH   si ; STACK_PUSH
00178A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00178D  57                    PUSH   di ; STACK_PUSH
00178E  9A 38 0D 7D 03        LCALL  0x37d, 0xd38 ; LCALL
001793  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
001796  EB 12                 JMP    0x17aa ; JUMP
001798  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00179B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00179E  57                    PUSH   di ; STACK_PUSH
00179F  1E                    PUSH   ds ; STACK_PUSH
0017A0  68 5E 4F              PUSH   0x4f5e ; PUSH_CONST
0017A3  06                    PUSH   es ; STACK_PUSH
0017A4  56                    PUSH   si ; STACK_PUSH
0017A5  9A 06 00 BB 01        LCALL  0x1bb, 6 ; LCALL
0017AA  8B C7                 MOV    ax, di ; MOV
0017AC  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0017AF  5E                    POP    si ; STACK_POP
0017B0  5F                    POP    di ; STACK_POP
0017B1  C9                    LEAVE ; EPILOGUE
0017B2  CB                    RETF ; RETURN
