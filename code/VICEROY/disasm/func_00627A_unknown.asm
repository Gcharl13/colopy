; ============================================================================
; func_00627A_unknown
; Region   : load_image
; Bytes    : file 0x00627A..0x0062B3  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00627A  55                    PUSH   bp ; STACK_PUSH
00627B  8B EC                 MOV    bp, sp ; MOV
00627D  57                    PUSH   di ; STACK_PUSH
00627E  56                    PUSH   si ; STACK_PUSH
00627F  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
006282  BE 19 00              MOV    si, 0x19 ; CONST_LOAD
006285  57                    PUSH   di ; STACK_PUSH
006286  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006289  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00628E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006291  0B C0                 OR     ax, ax ; LOGIC
006293  74 18                 JE     0x62ad ; CJUMP
006295  57                    PUSH   di ; STACK_PUSH
006296  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
006299  9A 0E 01 7F 03        LCALL  0x37f, 0x10e ; LCALL
00629E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0062A1  2A E4                 SUB    ah, ah ; ARITH
0062A3  50                    PUSH   ax ; STACK_PUSH
0062A4  0E                    PUSH   cs ; STACK_PUSH
0062A5  E8 A6 FF              CALL   0x624e ; CALL_NEAR
0062A8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0062AB  8B F0                 MOV    si, ax ; MOV
0062AD  8B C6                 MOV    ax, si ; MOV
0062AF  5E                    POP    si ; STACK_POP
0062B0  5F                    POP    di ; STACK_POP
0062B1  C9                    LEAVE ; EPILOGUE
0062B2  CB                    RETF ; RETURN
