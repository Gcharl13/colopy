; ============================================================================
; func_002A9C_unknown
; Region   : load_image
; Bytes    : file 0x002A9C..0x002AB8  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002A9C  55                    PUSH   bp ; STACK_PUSH
002A9D  8B EC                 MOV    bp, sp ; MOV
002A9F  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
002AA2  0B 46 08              OR     ax, word ptr [bp + 8] ; LOGIC
002AA5  74 0F                 JE     0x2ab6 ; CJUMP
002AA7  C7 06 38 03 FF FF     MOV    word ptr [0x338], 0xffff ; GLOBAL_LOAD
002AAD  FF 5E 06              LCALL  [bp + 6] ; LCALL
002AB0  C7 06 38 03 00 00     MOV    word ptr [0x338], 0 ; GLOBAL_LOAD
002AB6  C9                    LEAVE ; EPILOGUE
002AB7  CB                    RETF ; RETURN
