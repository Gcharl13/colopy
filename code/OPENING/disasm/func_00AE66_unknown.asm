; ============================================================================
; func_00AE66_unknown
; Region   : load_image
; Bytes    : file 0x00AE66..0x00AE7B  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AE66  55                    PUSH   bp ; STACK_PUSH
00AE67  8B EC                 MOV    bp, sp ; MOV
00AE69  57                    PUSH   di ; STACK_PUSH
00AE6A  C4 3E EE 41           LES    di, ptr [0x41ee] ; MOV_FAR
00AE6E  8C C0                 MOV    ax, es ; MOV
00AE70  0B C7                 OR     ax, di ; LOGIC
00AE72  74 04                 JE     0xae78 ; CJUMP
00AE74  FF 1E EE 41           LCALL  [0x41ee] ; LCALL
00AE78  5F                    POP    di ; STACK_POP
00AE79  C9                    LEAVE ; EPILOGUE
00AE7A  CB                    RETF ; RETURN
