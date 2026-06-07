; ============================================================================
; func_002C98_unknown
; Region   : load_image
; Bytes    : file 0x002C98..0x002CBC  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002C98  55                    PUSH   bp ; STACK_PUSH
002C99  8B EC                 MOV    bp, sp ; MOV
002C9B  57                    PUSH   di ; STACK_PUSH
002C9C  56                    PUSH   si ; STACK_PUSH
002C9D  1E                    PUSH   ds ; STACK_PUSH
002C9E  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
002CA1  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
002CA4  48                    DEC    ax ; ARITH
002CA5  8E D8                 MOV    ds, ax ; MOV
002CA7  33 F6                 XOR    si, si ; LOGIC
002CA9  B9 08 00              MOV    cx, 8 ; MOV
002CAC  AC                    LODSB  al, byte ptr [si] ; STR
002CAD  0A C0                 OR     al, al ; LOGIC
002CAF  AA                    STOSB  byte ptr es:[di], al ; STR
002CB0  E0 FA                 LOOPNE 0x2cac ; CJUMP
002CB2  32 C0                 XOR    al, al ; LOGIC
002CB4  AA                    STOSB  byte ptr es:[di], al ; STR
002CB5  1F                    POP    ds ; STACK_POP
002CB6  5E                    POP    si ; STACK_POP
002CB7  5F                    POP    di ; STACK_POP
002CB8  C9                    LEAVE ; EPILOGUE
002CB9  CA 08 00              RETF   8 ; RETURN
