; ============================================================================
; func_00D6C4_unknown
; Region   : load_image
; Bytes    : file 0x00D6C4..0x00D6FF  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D6C4  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00D6C8  53                    PUSH   bx ; STACK_PUSH
00D6C9  57                    PUSH   di ; STACK_PUSH
00D6CA  56                    PUSH   si ; STACK_PUSH
00D6CB  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
00D6CE  2B F6                 SUB    si, si ; ARITH
00D6D0  8B F8                 MOV    di, ax ; MOV
00D6D2  83 FE 4F              CMP    si, 0x4f ; CMP
00D6D5  7D 18                 JGE    0xd6ef ; CJUMP
00D6D7  57                    PUSH   di ; STACK_PUSH
00D6D8  9A 86 07 1D 0D        LCALL  0xd1d, 0x786 ; LCALL
00D6DD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00D6E0  8B C8                 MOV    cx, ax ; MOV
00D6E2  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00D6E5  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00D6E8  88 07                 MOV    byte ptr [bx], al ; MOV
00D6EA  46                    INC    si ; ARITH
00D6EB  0B C9                 OR     cx, cx ; LOGIC
00D6ED  75 E3                 JNE    0xd6d2 ; CJUMP
00D6EF  57                    PUSH   di ; STACK_PUSH
00D6F0  9A 86 07 1D 0D        LCALL  0xd1d, 0x786 ; LCALL
00D6F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00D6F8  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
00D6FB  5E                    POP    si ; STACK_POP
00D6FC  5F                    POP    di ; STACK_POP
00D6FD  C9                    LEAVE ; EPILOGUE
00D6FE  CB                    RETF ; RETURN
