; ============================================================================
; func_013EB4_unknown
; Region   : load_image
; Bytes    : file 0x013EB4..0x013EE9  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013EB4  55                    PUSH   bp ; STACK_PUSH
013EB5  8B EC                 MOV    bp, sp ; MOV
013EB7  52                    PUSH   dx ; STACK_PUSH
013EB8  50                    PUSH   ax ; STACK_PUSH
013EB9  EB 2F                 JMP    0x13eea ; JUMP
013EBB  A1 68 3C              MOV    ax, word ptr [0x3c68] ; GLOBAL_LOAD
013EBE  0B C0                 OR     ax, ax ; LOGIC
013EC0  74 28                 JE     0x13eea ; CJUMP
013EC2  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
013EC5  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
013EC8  2D 01 00              SUB    ax, 1 ; ARITH
013ECB  83 DA 00              SBB    dx, 0 ; ARITH
013ECE  B9 00 04              MOV    cx, 0x400 ; CONST_LOAD
013ED1  F7 F1                 DIV    cx ; ARITH
013ED3  05 01 00              ADD    ax, 1 ; ARITH
013ED6  83 D2 00              ADC    dx, 0 ; ARITH
013ED9  8B D0                 MOV    dx, ax ; MOV
013EDB  B4 09                 MOV    ah, 9 ; MOV
013EDD  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
013EE1  0B C0                 OR     ax, ax ; LOGIC
013EE3  74 05                 JE     0x13eea ; CJUMP
013EE5  8B C2                 MOV    ax, dx ; MOV
013EE7  C9                    LEAVE ; EPILOGUE
013EE8  CB                    RETF ; RETURN
