; ============================================================================
; func_003982_unknown
; Region   : load_image
; Bytes    : file 0x003982..0x00399E  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

003982  55                    PUSH   bp ; STACK_PUSH
003983  8B EC                 MOV    bp, sp ; MOV
003985  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
003988  0B 46 08              OR     ax, word ptr [bp + 8] ; LOGIC
00398B  74 0F                 JE     0x399c ; CJUMP
00398D  C7 06 8E 05 FF FF     MOV    word ptr [0x58e], 0xffff ; GLOBAL_LOAD
003993  FF 5E 06              LCALL  [bp + 6] ; LCALL
003996  C7 06 8E 05 00 00     MOV    word ptr [0x58e], 0 ; GLOBAL_LOAD
00399C  C9                    LEAVE ; EPILOGUE
00399D  CB                    RETF ; RETURN
