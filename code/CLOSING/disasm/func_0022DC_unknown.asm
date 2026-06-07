; ============================================================================
; func_0022DC_unknown
; Region   : load_image
; Bytes    : file 0x0022DC..0x0022EB  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0022DC  55                    PUSH   bp ; STACK_PUSH
0022DD  8B EC                 MOV    bp, sp ; MOV
0022DF  B4 00                 MOV    ah, 0 ; MOV
0022E1  CD 16                 INT    0x16 ; SYS
0022E3  0A C0                 OR     al, al ; LOGIC
0022E5  74 05                 JE     0x22ec ; CJUMP
0022E7  32 E4                 XOR    ah, ah ; LOGIC
0022E9  C9                    LEAVE ; EPILOGUE
0022EA  CB                    RETF ; RETURN
