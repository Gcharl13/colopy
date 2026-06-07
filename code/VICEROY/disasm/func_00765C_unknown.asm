; ============================================================================
; func_00765C_unknown
; Region   : load_image
; Bytes    : file 0x00765C..0x007686  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00765C  55                    PUSH   bp ; STACK_PUSH
00765D  8B EC                 MOV    bp, sp ; MOV
00765F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007663  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
007667  2A FF                 SUB    bh, bh ; ARITH
007669  83 FB 01              CMP    bx, 1 ; CMP
00766C  74 18                 JE     0x7686 ; CJUMP
00766E  83 FB 04              CMP    bx, 4 ; CMP
007671  74 13                 JE     0x7686 ; CJUMP
007673  83 FB 0B              CMP    bx, 0xb ; CMP
007676  74 0E                 JE     0x7686 ; CJUMP
007678  83 FB 14              CMP    bx, 0x14 ; CMP
00767B  74 09                 JE     0x7686 ; CJUMP
00767D  83 FB 16              CMP    bx, 0x16 ; CMP
007680  74 04                 JE     0x7686 ; CJUMP
007682  2B C0                 SUB    ax, ax ; ARITH
007684  C9                    LEAVE ; EPILOGUE
007685  CB                    RETF ; RETURN
