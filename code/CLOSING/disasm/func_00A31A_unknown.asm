; ============================================================================
; func_00A31A_unknown
; Region   : load_image
; Bytes    : file 0x00A31A..0x00A339  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A31A  55                    PUSH   bp ; STACK_PUSH
00A31B  8B EC                 MOV    bp, sp ; MOV
00A31D  56                    PUSH   si ; STACK_PUSH
00A31E  A1 64 37              MOV    ax, word ptr [0x3764] ; GLOBAL_LOAD
00A321  0B C0                 OR     ax, ax ; LOGIC
00A323  74 15                 JE     0xa33a ; CJUMP
00A325  BE 06 00              MOV    si, 6 ; MOV
00A328  03 F5                 ADD    si, bp ; ARITH
00A32A  B4 0B                 MOV    ah, 0xb ; CONST_LOAD
00A32C  FF 1E 68 37           LCALL  [0x3768] ; LCALL
00A330  0B C0                 OR     ax, ax ; LOGIC
00A332  74 06                 JE     0xa33a ; CJUMP
00A334  33 C0                 XOR    ax, ax ; LOGIC
00A336  5E                    POP    si ; STACK_POP
00A337  C9                    LEAVE ; EPILOGUE
00A338  CB                    RETF ; RETURN
