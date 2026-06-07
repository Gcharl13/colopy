; ============================================================================
; func_00E380_unknown
; Region   : load_image
; Bytes    : file 0x00E380..0x00E39C  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E380  55                    PUSH   bp ; STACK_PUSH
00E381  8B EC                 MOV    bp, sp ; MOV
00E383  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00E386  0B 46 08              OR     ax, word ptr [bp + 8] ; LOGIC
00E389  74 0F                 JE     0xe39a ; CJUMP
00E38B  C7 06 6E 07 FF FF     MOV    word ptr [0x76e], 0xffff ; GLOBAL_LOAD
00E391  FF 5E 06              LCALL  [bp + 6] ; LCALL
00E394  C7 06 6E 07 00 00     MOV    word ptr [0x76e], 0 ; GLOBAL_LOAD
00E39A  C9                    LEAVE ; EPILOGUE
00E39B  CB                    RETF ; RETURN
