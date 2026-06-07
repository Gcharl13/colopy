; ============================================================================
; func_0022C8_unknown
; Region   : load_image
; Bytes    : file 0x0022C8..0x0022D5  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0022C8  55                    PUSH   bp ; STACK_PUSH
0022C9  8B EC                 MOV    bp, sp ; MOV
0022CB  B4 01                 MOV    ah, 1 ; MOV
0022CD  CD 16                 INT    0x16 ; SYS
0022CF  75 05                 JNE    0x22d6 ; CJUMP
0022D1  33 C0                 XOR    ax, ax ; LOGIC
0022D3  C9                    LEAVE ; EPILOGUE
0022D4  CB                    RETF ; RETURN
