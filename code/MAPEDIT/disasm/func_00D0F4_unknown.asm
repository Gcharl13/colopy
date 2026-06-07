; ============================================================================
; func_00D0F4_unknown
; Region   : load_image
; Bytes    : file 0x00D0F4..0x00D101  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D0F4  55                    PUSH   bp ; STACK_PUSH
00D0F5  8B EC                 MOV    bp, sp ; MOV
00D0F7  B4 01                 MOV    ah, 1 ; MOV
00D0F9  CD 16                 INT    0x16 ; SYS
00D0FB  75 05                 JNE    0xd102 ; CJUMP
00D0FD  33 C0                 XOR    ax, ax ; LOGIC
00D0FF  C9                    LEAVE ; EPILOGUE
00D100  CB                    RETF ; RETURN
