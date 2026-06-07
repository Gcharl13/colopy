; ============================================================================
; func_0030F2_unknown
; Region   : load_image
; Bytes    : file 0x0030F2..0x0030FF  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0030F2  55                    PUSH   bp ; STACK_PUSH
0030F3  8B EC                 MOV    bp, sp ; MOV
0030F5  B4 01                 MOV    ah, 1 ; MOV
0030F7  CD 16                 INT    0x16 ; SYS
0030F9  75 05                 JNE    0x3100 ; CJUMP
0030FB  33 C0                 XOR    ax, ax ; LOGIC
0030FD  C9                    LEAVE ; EPILOGUE
0030FE  CB                    RETF ; RETURN
