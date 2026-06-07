; ============================================================================
; func_013EF0_unknown
; Region   : load_image
; Bytes    : file 0x013EF0..0x013F06  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

013EF0  55                    PUSH   bp ; STACK_PUSH
013EF1  8B EC                 MOV    bp, sp ; MOV
013EF3  50                    PUSH   ax ; STACK_PUSH
013EF4  A1 68 3C              MOV    ax, word ptr [0x3c68] ; GLOBAL_LOAD
013EF7  0B C0                 OR     ax, ax ; LOGIC
013EF9  74 09                 JE     0x13f04 ; CJUMP
013EFB  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
013EFE  B4 0A                 MOV    ah, 0xa ; CONST_LOAD
013F00  FF 1E 6C 3C           LCALL  [0x3c6c] ; LCALL
013F04  C9                    LEAVE ; EPILOGUE
013F05  CB                    RETF ; RETURN
