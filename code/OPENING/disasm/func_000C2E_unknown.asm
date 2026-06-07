; ============================================================================
; func_000C2E_unknown
; Region   : load_image
; Bytes    : file 0x000C2E..0x000C51  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

000C2E  55                    PUSH   bp ; STACK_PUSH
000C2F  8B EC                 MOV    bp, sp ; MOV
000C31  56                    PUSH   si ; STACK_PUSH
000C32  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
000C35  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
000C38  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
000C3B  3E 8A 04              MOV    al, byte ptr ds:[si] ; MOV
000C3E  3E 8A 27              MOV    ah, byte ptr ds:[bx] ; MOV
000C41  2A C4                 SUB    al, ah ; ARITH
000C43  73 02                 JAE    0xc47 ; CJUMP
000C45  32 C0                 XOR    al, al ; LOGIC
000C47  3E 88 04              MOV    byte ptr ds:[si], al ; MOV
000C4A  43                    INC    bx ; ARITH
000C4B  46                    INC    si ; ARITH
000C4C  E2 ED                 LOOP   0xc3b ; CJUMP
000C4E  5E                    POP    si ; STACK_POP
000C4F  C9                    LEAVE ; EPILOGUE
000C50  CB                    RETF ; RETURN
