; ============================================================================
; func_00FA7E_unknown
; Region   : load_image
; Bytes    : file 0x00FA7E..0x00FAA9  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FA7E  55                    PUSH   bp ; STACK_PUSH
00FA7F  8B EC                 MOV    bp, sp ; MOV
00FA81  56                    PUSH   si ; STACK_PUSH
00FA82  9A 46 1E 1D 0D        LCALL  0xd1d, 0x1e46 ; LCALL
00FA87  8B F0                 MOV    si, ax ; MOV
00FA89  0B F6                 OR     si, si ; LOGIC
00FA8B  75 05                 JNE    0xfa92 ; CJUMP
00FA8D  2B C0                 SUB    ax, ax ; ARITH
00FA8F  EB 13                 JMP    0xfaa4 ; JUMP
00FA91  90                    NOP ; NOP
00FA92  56                    PUSH   si ; STACK_PUSH
00FA93  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00FA96  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00FA99  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00FA9C  9A FC 16 1D 0D        LCALL  0xd1d, 0x16fc ; LCALL
00FAA1  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00FAA4  5E                    POP    si ; STACK_POP
00FAA5  8B E5                 MOV    sp, bp ; MOV
00FAA7  5D                    POP    bp ; STACK_POP
00FAA8  CB                    RETF ; RETURN
