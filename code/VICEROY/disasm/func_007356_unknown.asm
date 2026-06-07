; ============================================================================
; func_007356_unknown
; Region   : load_image
; Bytes    : file 0x007356..0x00738E  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007356  55                    PUSH   bp ; STACK_PUSH
007357  8B EC                 MOV    bp, sp ; MOV
007359  57                    PUSH   di ; STACK_PUSH
00735A  56                    PUSH   si ; STACK_PUSH
00735B  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00735E  2B F6                 SUB    si, si ; ARITH
007360  56                    PUSH   si ; STACK_PUSH
007361  6B DF 1C              IMUL   bx, di, 0x1c ; ARITH
007364  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
007368  2A E4                 SUB    ah, ah ; ARITH
00736A  50                    PUSH   ax ; STACK_PUSH
00736B  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
00736F  50                    PUSH   ax ; STACK_PUSH
007370  0E                    PUSH   cs ; STACK_PUSH
007371  E8 FA FE              CALL   0x726e ; CALL_NEAR
007374  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007377  0B C0                 OR     ax, ax ; LOGIC
007379  74 09                 JE     0x7384 ; CJUMP
00737B  56                    PUSH   si ; STACK_PUSH
00737C  57                    PUSH   di ; STACK_PUSH
00737D  0E                    PUSH   cs ; STACK_PUSH
00737E  E8 9B FC              CALL   0x701c ; CALL_NEAR
007381  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007384  46                    INC    si ; ARITH
007385  83 FE 04              CMP    si, 4 ; CMP
007388  7C D6                 JL     0x7360 ; CJUMP
00738A  5E                    POP    si ; STACK_POP
00738B  5F                    POP    di ; STACK_POP
00738C  C9                    LEAVE ; EPILOGUE
00738D  CB                    RETF ; RETURN
