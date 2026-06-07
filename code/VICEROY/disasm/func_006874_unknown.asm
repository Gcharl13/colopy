; ============================================================================
; func_006874_unknown
; Region   : load_image
; Bytes    : file 0x006874..0x0068A9  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006874  55                    PUSH   bp ; STACK_PUSH
006875  8B EC                 MOV    bp, sp ; MOV
006877  57                    PUSH   di ; STACK_PUSH
006878  56                    PUSH   si ; STACK_PUSH
006879  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00687C  2B FF                 SUB    di, di ; ARITH
00687E  8B C6                 MOV    ax, si ; MOV
006880  0E                    PUSH   cs ; STACK_PUSH
006881  E8 EE FD              CALL   0x6672 ; CALL_NEAR
006884  8B F0                 MOV    si, ax ; MOV
006886  0B F6                 OR     si, si ; LOGIC
006888  7C 19                 JL     0x68a3 ; CJUMP
00688A  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
00688D  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006890  38 87 46 31           CMP    byte ptr [bx + 0x3146], al ; CMP
006894  75 01                 JNE    0x6897 ; CJUMP
006896  47                    INC    di ; ARITH
006897  8B C6                 MOV    ax, si ; MOV
006899  0E                    PUSH   cs ; STACK_PUSH
00689A  E8 1D FE              CALL   0x66ba ; CALL_NEAR
00689D  8B F0                 MOV    si, ax ; MOV
00689F  0B F6                 OR     si, si ; LOGIC
0068A1  7D E7                 JGE    0x688a ; CJUMP
0068A3  8B C7                 MOV    ax, di ; MOV
0068A5  5E                    POP    si ; STACK_POP
0068A6  5F                    POP    di ; STACK_POP
0068A7  C9                    LEAVE ; EPILOGUE
0068A8  CB                    RETF ; RETURN
