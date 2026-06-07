; ============================================================================
; func_00E6EE_unknown
; Region   : load_image
; Bytes    : file 0x00E6EE..0x00E702  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E6EE  55                    PUSH   bp ; STACK_PUSH
00E6EF  8B EC                 MOV    bp, sp ; MOV
00E6F1  BA DA 03              MOV    dx, 0x3da ; CONST_LOAD
00E6F4  B4 08                 MOV    ah, 8 ; MOV
00E6F6  EC                    IN     al, dx ; IO
00E6F7  22 C4                 AND    al, ah ; LOGIC
00E6F9  75 FB                 JNE    0xe6f6 ; CJUMP
00E6FB  EC                    IN     al, dx ; IO
00E6FC  22 C4                 AND    al, ah ; LOGIC
00E6FE  74 FB                 JE     0xe6fb ; CJUMP
00E700  C9                    LEAVE ; EPILOGUE
00E701  CB                    RETF ; RETURN
