; ============================================================================
; func_00730A_unknown
; Region   : load_image
; Bytes    : file 0x00730A..0x007355  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00730A  55                    PUSH   bp ; STACK_PUSH
00730B  8B EC                 MOV    bp, sp ; MOV
00730D  57                    PUSH   di ; STACK_PUSH
00730E  56                    PUSH   si ; STACK_PUSH
00730F  2B FF                 SUB    di, di ; ARITH
007311  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
007315  7D 15                 JGE    0x732c ; CJUMP
007317  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00731A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00731D  9A 00 02 7F 03        LCALL  0x37f, 0x200 ; LCALL
007322  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007325  8A C8                 MOV    cl, al ; MOV
007327  BF 10 00              MOV    di, 0x10 ; CONST_LOAD
00732A  D3 E7                 SHL    di, cl ; LOGIC
00732C  2B F6                 SUB    si, si ; ARITH
00732E  56                    PUSH   si ; STACK_PUSH
00732F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007332  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007335  0E                    PUSH   cs ; STACK_PUSH
007336  E8 35 FF              CALL   0x726e ; CALL_NEAR
007339  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00733C  0B C0                 OR     ax, ax ; LOGIC
00733E  74 09                 JE     0x7349 ; CJUMP
007340  8B CE                 MOV    cx, si ; MOV
007342  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
007345  D3 E0                 SHL    ax, cl ; LOGIC
007347  0B F8                 OR     di, ax ; LOGIC
007349  46                    INC    si ; ARITH
00734A  83 FE 04              CMP    si, 4 ; CMP
00734D  7C DF                 JL     0x732e ; CJUMP
00734F  8B C7                 MOV    ax, di ; MOV
007351  5E                    POP    si ; STACK_POP
007352  5F                    POP    di ; STACK_POP
007353  C9                    LEAVE ; EPILOGUE
007354  CB                    RETF ; RETURN
