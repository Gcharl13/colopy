; ============================================================================
; func_007630_unknown
; Region   : load_image
; Bytes    : file 0x007630..0x007655  (37 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007630  55                    PUSH   bp ; STACK_PUSH
007631  8B EC                 MOV    bp, sp ; MOV
007633  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007637  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
00763B  2A FF                 SUB    bh, bh ; ARITH
00763D  83 FB 04              CMP    bx, 4 ; CMP
007640  74 14                 JE     0x7656 ; CJUMP
007642  83 FB 05              CMP    bx, 5 ; CMP
007645  74 0F                 JE     0x7656 ; CJUMP
007647  83 FB 15              CMP    bx, 0x15 ; CMP
00764A  74 0A                 JE     0x7656 ; CJUMP
00764C  83 FB 16              CMP    bx, 0x16 ; CMP
00764F  74 05                 JE     0x7656 ; CJUMP
007651  2B C0                 SUB    ax, ax ; ARITH
007653  C9                    LEAVE ; EPILOGUE
007654  CB                    RETF ; RETURN
