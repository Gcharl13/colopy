; ============================================================================
; func_0772C4_unknown
; Region   : overlay
; Bytes    : file 0x0772C4..0x0772D9  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0772C4  55                    PUSH   bp ; STACK_PUSH
0772C5  8B EC                 MOV    bp, sp ; MOV
0772C7  57                    PUSH   di ; STACK_PUSH
0772C8  C4 3E 5E 24           LES    di, ptr [0x245e] ; MOV_FAR
0772CC  8C C0                 MOV    ax, es ; MOV
0772CE  0B C7                 OR     ax, di ; LOGIC
0772D0  74 04                 JE     0x772d6 ; CJUMP
0772D2  FF 1E 5E 24           LCALL  [0x245e] ; LCALL
0772D6  5F                    POP    di ; STACK_POP
0772D7  C9                    LEAVE ; EPILOGUE
0772D8  CB                    RETF ; RETURN
