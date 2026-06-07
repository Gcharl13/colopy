; ============================================================================
; func_009C38_unknown
; Region   : load_image
; Bytes    : file 0x009C38..0x009C55  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009C38  55                    PUSH   bp ; STACK_PUSH
009C39  8B EC                 MOV    bp, sp ; MOV
009C3B  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
009C3E  0B 46 06              OR     ax, word ptr [bp + 6] ; LOGIC
009C41  74 10                 JE     0x9c53 ; CJUMP
009C43  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
009C46  89 1E 48 41           MOV    word ptr [0x4148], bx ; GLOBAL_LOAD
009C4A  FF 5E 04              LCALL  [bp + 4] ; LCALL
009C4D  C7 06 48 41 00 00     MOV    word ptr [0x4148], 0 ; GLOBAL_LOAD
009C53  C9                    LEAVE ; EPILOGUE
009C54  C3                    RET ; RETURN
