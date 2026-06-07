; ============================================================================
; func_00B1DC_unknown
; Region   : load_image
; Bytes    : file 0x00B1DC..0x00B203  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B1DC  55                    PUSH   bp ; STACK_PUSH
00B1DD  8B EC                 MOV    bp, sp ; MOV
00B1DF  56                    PUSH   si ; STACK_PUSH
00B1E0  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B1E3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B1E6  9A 12 01 AB 02        LCALL  0x2ab, 0x112 ; LCALL
00B1EB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B1EE  2A E4                 SUB    ah, ah ; ARITH
00B1F0  24 1F                 AND    al, 0x1f ; LOGIC
00B1F2  8B F0                 MOV    si, ax ; MOV
00B1F4  83 FE 19              CMP    si, 0x19 ; CMP
00B1F7  74 0B                 JE     0xb204 ; CJUMP
00B1F9  83 FE 1A              CMP    si, 0x1a ; CMP
00B1FC  74 06                 JE     0xb204 ; CJUMP
00B1FE  2B C0                 SUB    ax, ax ; ARITH
00B200  5E                    POP    si ; STACK_POP
00B201  C9                    LEAVE ; EPILOGUE
00B202  CB                    RETF ; RETURN
