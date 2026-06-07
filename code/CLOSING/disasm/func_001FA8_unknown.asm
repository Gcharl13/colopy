; ============================================================================
; func_001FA8_unknown
; Region   : load_image
; Bytes    : file 0x001FA8..0x001FE1  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

001FA8  55                    PUSH   bp ; STACK_PUSH
001FA9  8B EC                 MOV    bp, sp ; MOV
001FAB  9A 17 01 7D 06        LCALL  0x67d, 0x117 ; LCALL
001FB0  0B C0                 OR     ax, ax ; LOGIC
001FB2  74 0E                 JE     0x1fc2 ; CJUMP
001FB4  6A 00                 PUSH   0 ; STACK_PUSH
001FB6  9A 12 00 8E 06        LCALL  0x68e, 0x12 ; LCALL
001FBB  8B E5                 MOV    sp, bp ; MOV
001FBD  9A 67 00 8E 06        LCALL  0x68e, 0x67 ; LCALL
001FC2  9A EF 01 4E 02        LCALL  0x24e, 0x1ef ; LCALL
001FC7  6A 03                 PUSH   3 ; STACK_PUSH
001FC9  6A 00                 PUSH   0 ; STACK_PUSH
001FCB  9A 90 00 35 07        LCALL  0x735, 0x90 ; LCALL
001FD0  8B E5                 MOV    sp, bp ; MOV
001FD2  B8 03 00              MOV    ax, 3 ; MOV
001FD5  9A 00 00 D3 01        LCALL  0x1d3, 0 ; LCALL
001FDA  B8 03 00              MOV    ax, 3 ; MOV
001FDD  CD 10                 INT    0x10 ; SYS
001FDF  C9                    LEAVE ; EPILOGUE
001FE0  CB                    RETF ; RETURN
