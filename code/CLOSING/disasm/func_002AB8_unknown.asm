; ============================================================================
; func_002AB8_unknown
; Region   : load_image
; Bytes    : file 0x002AB8..0x002AE2  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002AB8  55                    PUSH   bp ; STACK_PUSH
002AB9  8B EC                 MOV    bp, sp ; MOV
002ABB  57                    PUSH   di ; STACK_PUSH
002ABC  56                    PUSH   si ; STACK_PUSH
002ABD  1E                    PUSH   ds ; STACK_PUSH
002ABE  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
002AC1  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
002AC4  48                    DEC    ax ; ARITH
002AC5  8E C0                 MOV    es, ax ; MOV
002AC7  BF 08 00              MOV    di, 8 ; MOV
002ACA  33 C0                 XOR    ax, ax ; LOGIC
002ACC  B9 04 00              MOV    cx, 4 ; MOV
002ACF  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
002AD1  BF 08 00              MOV    di, 8 ; MOV
002AD4  B9 08 00              MOV    cx, 8 ; MOV
002AD7  AC                    LODSB  al, byte ptr [si] ; STR
002AD8  0A C0                 OR     al, al ; LOGIC
002ADA  AA                    STOSB  byte ptr es:[di], al ; STR
002ADB  E0 FA                 LOOPNE 0x2ad7 ; CJUMP
002ADD  1F                    POP    ds ; STACK_POP
002ADE  5E                    POP    si ; STACK_POP
002ADF  5F                    POP    di ; STACK_POP
002AE0  C9                    LEAVE ; EPILOGUE
002AE1  CB                    RETF ; RETURN
