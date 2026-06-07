; ============================================================================
; func_00B92A_unknown
; Region   : load_image
; Bytes    : file 0x00B92A..0x00B994  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B92A  55                    PUSH   bp ; STACK_PUSH
00B92B  8B EC                 MOV    bp, sp ; MOV
00B92D  57                    PUSH   di ; STACK_PUSH
00B92E  56                    PUSH   si ; STACK_PUSH
00B92F  83 3E 0A 42 00        CMP    word ptr [0x420a], 0 ; CMP
00B934  74 52                 JE     0xb988 ; CJUMP
00B936  83 3E 10 42 01        CMP    word ptr [0x4210], 1 ; CMP
00B93B  76 4B                 JBE    0xb988 ; CJUMP
00B93D  A1 10 42              MOV    ax, word ptr [0x4210] ; GLOBAL_LOAD
00B940  2D 00 08              SUB    ax, 0x800 ; ARITH
00B943  1B C9                 SBB    cx, cx ; ARITH
00B945  23 C1                 AND    ax, cx ; LOGIC
00B947  80 C4 08              ADD    ah, 8 ; ARITH
00B94A  A3 10 42              MOV    word ptr [0x4210], ax ; GLOBAL_LOAD
00B94D  A1 30 42              MOV    ax, word ptr [0x4230] ; GLOBAL_LOAD
00B950  8B 16 32 42           MOV    dx, word ptr [0x4232] ; GLOBAL_LOAD
00B954  A3 4C 42              MOV    word ptr [0x424c], ax ; GLOBAL_LOAD
00B957  89 16 4E 42           MOV    word ptr [0x424e], dx ; GLOBAL_LOAD
00B95B  0E                    PUSH   cs ; STACK_PUSH
00B95C  E8 A1 FF              CALL   0xb900 ; CALL_NEAR
00B95F  0B C0                 OR     ax, ax ; LOGIC
00B961  75 25                 JNE    0xb988 ; CJUMP
00B963  C4 3E 4C 42           LES    di, ptr [0x424c] ; MOV_FAR
00B967  8B 0E 10 42           MOV    cx, word ptr [0x4210] ; GLOBAL_LOAD
00B96B  32 C0                 XOR    al, al ; LOGIC
00B96D  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
00B96F  C4 1E 4C 42           LES    bx, ptr [0x424c] ; MOV_FAR
00B973  8B 36 10 42           MOV    si, word ptr [0x4210] ; GLOBAL_LOAD
00B977  26 C6 40 FF FF        MOV    byte ptr es:[bx + si - 1], 0xff ; CONST_LOAD
00B97C  8D 44 FF              LEA    ax, [si - 1] ; ADDR
00B97F  A3 46 42              MOV    word ptr [0x4246], ax ; GLOBAL_LOAD
00B982  C7 06 4A 42 FF FF     MOV    word ptr [0x424a], 0xffff ; GLOBAL_LOAD
00B988  9A 62 01 B7 0A        LCALL  0xab7, 0x162 ; LCALL
00B98D  A1 4A 42              MOV    ax, word ptr [0x424a] ; GLOBAL_LOAD
00B990  5E                    POP    si ; STACK_POP
00B991  5F                    POP    di ; STACK_POP
00B992  C9                    LEAVE ; EPILOGUE
00B993  CB                    RETF ; RETURN
