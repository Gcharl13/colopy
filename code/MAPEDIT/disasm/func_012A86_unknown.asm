; ============================================================================
; func_012A86_unknown
; Region   : load_image
; Bytes    : file 0x012A86..0x012AF0  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012A86  55                    PUSH   bp ; STACK_PUSH
012A87  8B EC                 MOV    bp, sp ; MOV
012A89  57                    PUSH   di ; STACK_PUSH
012A8A  56                    PUSH   si ; STACK_PUSH
012A8B  83 3E 3A 44 00        CMP    word ptr [0x443a], 0 ; CMP
012A90  74 52                 JE     0x12ae4 ; CJUMP
012A92  83 3E 40 44 01        CMP    word ptr [0x4440], 1 ; CMP
012A97  76 4B                 JBE    0x12ae4 ; CJUMP
012A99  A1 40 44              MOV    ax, word ptr [0x4440] ; GLOBAL_LOAD
012A9C  2D 00 08              SUB    ax, 0x800 ; ARITH
012A9F  1B C9                 SBB    cx, cx ; ARITH
012AA1  23 C1                 AND    ax, cx ; LOGIC
012AA3  80 C4 08              ADD    ah, 8 ; ARITH
012AA6  A3 40 44              MOV    word ptr [0x4440], ax ; GLOBAL_LOAD
012AA9  A1 60 44              MOV    ax, word ptr [0x4460] ; GLOBAL_LOAD
012AAC  8B 16 62 44           MOV    dx, word ptr [0x4462] ; GLOBAL_LOAD
012AB0  A3 7C 44              MOV    word ptr [0x447c], ax ; GLOBAL_LOAD
012AB3  89 16 7E 44           MOV    word ptr [0x447e], dx ; GLOBAL_LOAD
012AB7  0E                    PUSH   cs ; STACK_PUSH
012AB8  E8 A1 FF              CALL   0x12a5c ; CALL_NEAR
012ABB  0B C0                 OR     ax, ax ; LOGIC
012ABD  75 25                 JNE    0x12ae4 ; CJUMP
012ABF  C4 3E 7C 44           LES    di, ptr [0x447c] ; MOV_FAR
012AC3  8B 0E 40 44           MOV    cx, word ptr [0x4440] ; GLOBAL_LOAD
012AC7  32 C0                 XOR    al, al ; LOGIC
012AC9  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
012ACB  C4 1E 7C 44           LES    bx, ptr [0x447c] ; MOV_FAR
012ACF  8B 36 40 44           MOV    si, word ptr [0x4440] ; GLOBAL_LOAD
012AD3  26 C6 40 FF FF        MOV    byte ptr es:[bx + si - 1], 0xff ; CONST_LOAD
012AD8  8D 44 FF              LEA    ax, [si - 1] ; ADDR
012ADB  A3 76 44              MOV    word ptr [0x4476], ax ; GLOBAL_LOAD
012ADE  C7 06 7A 44 FF FF     MOV    word ptr [0x447a], 0xffff ; GLOBAL_LOAD
012AE4  9A 5E 01 2D 11        LCALL  0x112d, 0x15e ; LCALL
012AE9  A1 7A 44              MOV    ax, word ptr [0x447a] ; GLOBAL_LOAD
012AEC  5E                    POP    si ; STACK_POP
012AED  5F                    POP    di ; STACK_POP
012AEE  C9                    LEAVE ; EPILOGUE
012AEF  CB                    RETF ; RETURN
