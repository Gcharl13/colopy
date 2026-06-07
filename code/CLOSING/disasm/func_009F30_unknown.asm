; ============================================================================
; func_009F30_unknown
; Region   : load_image
; Bytes    : file 0x009F30..0x009F45  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009F30  55                    PUSH   bp ; STACK_PUSH
009F31  8B EC                 MOV    bp, sp ; MOV
009F33  57                    PUSH   di ; STACK_PUSH
009F34  C4 3E 98 3F           LES    di, ptr [0x3f98] ; MOV_FAR
009F38  8C C0                 MOV    ax, es ; MOV
009F3A  0B C7                 OR     ax, di ; LOGIC
009F3C  74 04                 JE     0x9f42 ; CJUMP
009F3E  FF 1E 98 3F           LCALL  [0x3f98] ; LCALL
009F42  5F                    POP    di ; STACK_POP
009F43  C9                    LEAVE ; EPILOGUE
009F44  CB                    RETF ; RETURN
