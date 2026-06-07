; ============================================================================
; func_00ECA6_unknown
; Region   : load_image
; Bytes    : file 0x00ECA6..0x00ECB5  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00ECA6  55                    PUSH   bp ; STACK_PUSH
00ECA7  8B EC                 MOV    bp, sp ; MOV
00ECA9  8B C8                 MOV    cx, ax ; MOV
00ECAB  88 0E AA 3A           MOV    byte ptr [0x3aaa], cl ; GLOBAL_LOAD
00ECAF  88 16 AB 3A           MOV    byte ptr [0x3aab], dl ; GLOBAL_LOAD
00ECB3  8B C3                 MOV    ax, bx ; MOV
