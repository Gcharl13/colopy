; ============================================================================
; func_009C7C_unknown
; Region   : load_image
; Bytes    : file 0x009C7C..0x009C91  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009C7C  55                    PUSH   bp ; STACK_PUSH
009C7D  8B EC                 MOV    bp, sp ; MOV
009C7F  57                    PUSH   di ; STACK_PUSH
009C80  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
009C83  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
009C86  8B 15                 MOV    dx, word ptr [di] ; MOV
009C88  8B 07                 MOV    ax, word ptr [bx] ; MOV
009C8A  89 05                 MOV    word ptr [di], ax ; MOV
009C8C  89 17                 MOV    word ptr [bx], dx ; MOV
009C8E  5F                    POP    di ; STACK_POP
009C8F  C9                    LEAVE ; EPILOGUE
009C90  CB                    RETF ; RETURN
