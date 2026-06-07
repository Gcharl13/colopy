; ============================================================================
; func_00B250_unknown
; Region   : load_image
; Bytes    : file 0x00B250..0x00B26F  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B250  55                    PUSH   bp ; STACK_PUSH
00B251  8B EC                 MOV    bp, sp ; MOV
00B253  56                    PUSH   si ; STACK_PUSH
00B254  A1 BA 39              MOV    ax, word ptr [0x39ba] ; GLOBAL_LOAD
00B257  0B C0                 OR     ax, ax ; LOGIC
00B259  74 15                 JE     0xb270 ; CJUMP
00B25B  BE 06 00              MOV    si, 6 ; MOV
00B25E  03 F5                 ADD    si, bp ; ARITH
00B260  B4 0B                 MOV    ah, 0xb ; CONST_LOAD
00B262  FF 1E BE 39           LCALL  [0x39be] ; LCALL
00B266  0B C0                 OR     ax, ax ; LOGIC
00B268  74 06                 JE     0xb270 ; CJUMP
00B26A  33 C0                 XOR    ax, ax ; LOGIC
00B26C  5E                    POP    si ; STACK_POP
00B26D  C9                    LEAVE ; EPILOGUE
00B26E  CB                    RETF ; RETURN
