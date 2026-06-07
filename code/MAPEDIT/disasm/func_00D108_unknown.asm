; ============================================================================
; func_00D108_unknown
; Region   : load_image
; Bytes    : file 0x00D108..0x00D117  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D108  55                    PUSH   bp ; STACK_PUSH
00D109  8B EC                 MOV    bp, sp ; MOV
00D10B  B4 00                 MOV    ah, 0 ; MOV
00D10D  CD 16                 INT    0x16 ; SYS
00D10F  0A C0                 OR     al, al ; LOGIC
00D111  74 05                 JE     0xd118 ; CJUMP
00D113  32 E4                 XOR    ah, ah ; LOGIC
00D115  C9                    LEAVE ; EPILOGUE
00D116  CB                    RETF ; RETURN
