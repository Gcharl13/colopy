; ============================================================================
; func_002DAA_unknown
; Region   : load_image
; Bytes    : file 0x002DAA..0x002DBF  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002DAA  55                    PUSH   bp ; STACK_PUSH
002DAB  8B EC                 MOV    bp, sp ; MOV
002DAD  57                    PUSH   di ; STACK_PUSH
002DAE  56                    PUSH   si ; STACK_PUSH
002DAF  B4 52                 MOV    ah, 0x52 ; CONST_LOAD
002DB1  CD 21                 INT    0x21 ; SYS
002DB3  26 8B 5F FE           MOV    bx, word ptr es:[bx - 2] ; MOV
002DB7  33 FF                 XOR    di, di ; LOGIC
002DB9  33 F6                 XOR    si, si ; LOGIC
002DBB  33 C0                 XOR    ax, ax ; LOGIC
002DBD  8E C3                 MOV    es, bx ; MOV
