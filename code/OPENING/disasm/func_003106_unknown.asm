; ============================================================================
; func_003106_unknown
; Region   : load_image
; Bytes    : file 0x003106..0x003115  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003106  55                    PUSH   bp ; STACK_PUSH
003107  8B EC                 MOV    bp, sp ; MOV
003109  B4 00                 MOV    ah, 0 ; MOV
00310B  CD 16                 INT    0x16 ; SYS
00310D  0A C0                 OR     al, al ; LOGIC
00310F  74 05                 JE     0x3116 ; CJUMP
003111  32 E4                 XOR    ah, ah ; LOGIC
003113  C9                    LEAVE ; EPILOGUE
003114  CB                    RETF ; RETURN
