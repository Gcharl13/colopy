; ============================================================================
; func_00A9F4_unknown
; Region   : load_image
; Bytes    : file 0x00A9F4..0x00AA5E  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A9F4  55                    PUSH   bp ; STACK_PUSH
00A9F5  8B EC                 MOV    bp, sp ; MOV
00A9F7  57                    PUSH   di ; STACK_PUSH
00A9F8  56                    PUSH   si ; STACK_PUSH
00A9F9  83 3E B4 3F 00        CMP    word ptr [0x3fb4], 0 ; CMP
00A9FE  74 52                 JE     0xaa52 ; CJUMP
00AA00  83 3E BA 3F 01        CMP    word ptr [0x3fba], 1 ; CMP
00AA05  76 4B                 JBE    0xaa52 ; CJUMP
00AA07  A1 BA 3F              MOV    ax, word ptr [0x3fba] ; GLOBAL_LOAD
00AA0A  2D 00 08              SUB    ax, 0x800 ; ARITH
00AA0D  1B C9                 SBB    cx, cx ; ARITH
00AA0F  23 C1                 AND    ax, cx ; LOGIC
00AA11  80 C4 08              ADD    ah, 8 ; ARITH
00AA14  A3 BA 3F              MOV    word ptr [0x3fba], ax ; GLOBAL_LOAD
00AA17  A1 DA 3F              MOV    ax, word ptr [0x3fda] ; GLOBAL_LOAD
00AA1A  8B 16 DC 3F           MOV    dx, word ptr [0x3fdc] ; GLOBAL_LOAD
00AA1E  A3 F6 3F              MOV    word ptr [0x3ff6], ax ; GLOBAL_LOAD
00AA21  89 16 F8 3F           MOV    word ptr [0x3ff8], dx ; GLOBAL_LOAD
00AA25  0E                    PUSH   cs ; STACK_PUSH
00AA26  E8 A1 FF              CALL   0xa9ca ; CALL_NEAR
00AA29  0B C0                 OR     ax, ax ; LOGIC
00AA2B  75 25                 JNE    0xaa52 ; CJUMP
00AA2D  C4 3E F6 3F           LES    di, ptr [0x3ff6] ; MOV_FAR
00AA31  8B 0E BA 3F           MOV    cx, word ptr [0x3fba] ; GLOBAL_LOAD
00AA35  32 C0                 XOR    al, al ; LOGIC
00AA37  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
00AA39  C4 1E F6 3F           LES    bx, ptr [0x3ff6] ; MOV_FAR
00AA3D  8B 36 BA 3F           MOV    si, word ptr [0x3fba] ; GLOBAL_LOAD
00AA41  26 C6 40 FF FF        MOV    byte ptr es:[bx + si - 1], 0xff ; CONST_LOAD
00AA46  8D 44 FF              LEA    ax, [si - 1] ; ADDR
00AA49  A3 F0 3F              MOV    word ptr [0x3ff0], ax ; GLOBAL_LOAD
00AA4C  C7 06 F4 3F FF FF     MOV    word ptr [0x3ff4], 0xffff ; GLOBAL_LOAD
00AA52  9A 5C 01 E4 09        LCALL  0x9e4, 0x15c ; LCALL
00AA57  A1 F4 3F              MOV    ax, word ptr [0x3ff4] ; GLOBAL_LOAD
00AA5A  5E                    POP    si ; STACK_POP
00AA5B  5F                    POP    di ; STACK_POP
00AA5C  C9                    LEAVE ; EPILOGUE
00AA5D  CB                    RETF ; RETURN
