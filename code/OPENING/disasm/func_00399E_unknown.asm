; ============================================================================
; func_00399E_unknown
; Region   : load_image
; Bytes    : file 0x00399E..0x0039C8  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00399E  55                    PUSH   bp ; STACK_PUSH
00399F  8B EC                 MOV    bp, sp ; MOV
0039A1  57                    PUSH   di ; STACK_PUSH
0039A2  56                    PUSH   si ; STACK_PUSH
0039A3  1E                    PUSH   ds ; STACK_PUSH
0039A4  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
0039A7  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0039AA  48                    DEC    ax ; ARITH
0039AB  8E C0                 MOV    es, ax ; MOV
0039AD  BF 08 00              MOV    di, 8 ; MOV
0039B0  33 C0                 XOR    ax, ax ; LOGIC
0039B2  B9 04 00              MOV    cx, 4 ; MOV
0039B5  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
0039B7  BF 08 00              MOV    di, 8 ; MOV
0039BA  B9 08 00              MOV    cx, 8 ; MOV
0039BD  AC                    LODSB  al, byte ptr [si] ; STR
0039BE  0A C0                 OR     al, al ; LOGIC
0039C0  AA                    STOSB  byte ptr es:[di], al ; STR
0039C1  E0 FA                 LOOPNE 0x39bd ; CJUMP
0039C3  1F                    POP    ds ; STACK_POP
0039C4  5E                    POP    si ; STACK_POP
0039C5  5F                    POP    di ; STACK_POP
0039C6  C9                    LEAVE ; EPILOGUE
0039C7  CB                    RETF ; RETURN
