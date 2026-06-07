; ============================================================================
; func_0048EA_unknown
; Region   : load_image
; Bytes    : file 0x0048EA..0x0048FF  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0048EA  55                    PUSH   bp ; STACK_PUSH
0048EB  8B EC                 MOV    bp, sp ; MOV
0048ED  57                    PUSH   di ; STACK_PUSH
0048EE  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
0048F1  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0048F4  8B 15                 MOV    dx, word ptr [di] ; MOV
0048F6  8B 07                 MOV    ax, word ptr [bx] ; MOV
0048F8  89 05                 MOV    word ptr [di], ax ; MOV
0048FA  89 17                 MOV    word ptr [bx], dx ; MOV
0048FC  5F                    POP    di ; STACK_POP
0048FD  C9                    LEAVE ; EPILOGUE
0048FE  CB                    RETF ; RETURN
