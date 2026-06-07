; ============================================================================
; func_00684C_unknown
; Region   : load_image
; Bytes    : file 0x00684C..0x006873  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00684C  55                    PUSH   bp ; STACK_PUSH
00684D  8B EC                 MOV    bp, sp ; MOV
00684F  57                    PUSH   di ; STACK_PUSH
006850  56                    PUSH   si ; STACK_PUSH
006851  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006854  2B FF                 SUB    di, di ; ARITH
006856  8B C6                 MOV    ax, si ; MOV
006858  0E                    PUSH   cs ; STACK_PUSH
006859  E8 16 FE              CALL   0x6672 ; CALL_NEAR
00685C  8B F0                 MOV    si, ax ; MOV
00685E  0B F6                 OR     si, si ; LOGIC
006860  7C 0B                 JL     0x686d ; CJUMP
006862  47                    INC    di ; ARITH
006863  0E                    PUSH   cs ; STACK_PUSH
006864  E8 53 FE              CALL   0x66ba ; CALL_NEAR
006867  8B F0                 MOV    si, ax ; MOV
006869  0B F6                 OR     si, si ; LOGIC
00686B  7D F5                 JGE    0x6862 ; CJUMP
00686D  8B C7                 MOV    ax, di ; MOV
00686F  5E                    POP    si ; STACK_POP
006870  5F                    POP    di ; STACK_POP
006871  C9                    LEAVE ; EPILOGUE
006872  CB                    RETF ; RETURN
