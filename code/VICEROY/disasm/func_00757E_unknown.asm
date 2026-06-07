; ============================================================================
; func_00757E_unknown
; Region   : load_image
; Bytes    : file 0x00757E..0x00759F  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00757E  55                    PUSH   bp ; STACK_PUSH
00757F  8B EC                 MOV    bp, sp ; MOV
007581  56                    PUSH   si ; STACK_PUSH
007582  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007585  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007588  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
00758C  2A E4                 SUB    ah, ah ; ARITH
00758E  50                    PUSH   ax ; STACK_PUSH
00758F  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
007593  50                    PUSH   ax ; STACK_PUSH
007594  9A A0 02 7F 03        LCALL  0x37f, 0x2a0 ; LCALL
007599  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00759C  5E                    POP    si ; STACK_POP
00759D  C9                    LEAVE ; EPILOGUE
00759E  CB                    RETF ; RETURN
