; ============================================================================
; func_039E98_unknown
; Region   : overlay
; Bytes    : file 0x039E98..0x039EE1  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

039E98  55                    PUSH   bp ; STACK_PUSH
039E99  8B EC                 MOV    bp, sp ; MOV
039E9B  83 06 0E 2D 08        ADD    word ptr [0x2d0e], 8 ; ARITH
039EA0  81 3E 0E 2D 24 01     CMP    word ptr [0x2d0e], 0x124 ; CMP
039EA6  7C 13                 JL     0x39ebb ; CJUMP
039EA8  83 06 10 2D 08        ADD    word ptr [0x2d10], 8 ; ARITH
039EAD  A0 0E 2D              MOV    al, byte ptr [0x2d0e] ; GLOBAL_LOAD
039EB0  25 08 00              AND    ax, 8 ; LOGIC
039EB3  D1 F8                 SAR    ax, 1 ; LOGIC
039EB5  05 10 00              ADD    ax, 0x10 ; ARITH
039EB8  A3 0E 2D              MOV    word ptr [0x2d0e], ax ; GLOBAL_LOAD
039EBB  81 3E 10 2D 90 00     CMP    word ptr [0x2d10], 0x90 ; CMP
039EC1  7D 1C                 JGE    0x39edf ; CJUMP
039EC3  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
039EC7  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
039ECB  FF 36 10 2D           PUSH   word ptr [0x2d10] ; PUSH_GLOBAL
039ECF  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
039ED2  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
039ED6  8B 16 0E 2D           MOV    dx, word ptr [0x2d0e] ; GLOBAL_LOAD
039EDA  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
039EDF  C9                    LEAVE ; EPILOGUE
039EE0  C3                    RET ; RETURN
