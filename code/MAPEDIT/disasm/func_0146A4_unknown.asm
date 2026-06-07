; ============================================================================
; func_0146A4_unknown
; Region   : load_image
; Bytes    : file 0x0146A4..0x0146B9  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0146A4  55                    PUSH   bp ; STACK_PUSH
0146A5  8B EC                 MOV    bp, sp ; MOV
0146A7  57                    PUSH   di ; STACK_PUSH
0146A8  C4 3E 16 45           LES    di, ptr [0x4516] ; MOV_FAR
0146AC  8C C0                 MOV    ax, es ; MOV
0146AE  0B C7                 OR     ax, di ; LOGIC
0146B0  74 04                 JE     0x146b6 ; CJUMP
0146B2  FF 1E 16 45           LCALL  [0x4516] ; LCALL
0146B6  5F                    POP    di ; STACK_POP
0146B7  C9                    LEAVE ; EPILOGUE
0146B8  CB                    RETF ; RETURN
