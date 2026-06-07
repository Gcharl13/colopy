; ============================================================================
; func_068FA0_unknown
; Region   : overlay
; Bytes    : file 0x068FA0..0x068FDB  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068FA0  55                    PUSH   bp ; STACK_PUSH
068FA1  8B EC                 MOV    bp, sp ; MOV
068FA3  56                    PUSH   si ; STACK_PUSH
068FA4  81 3E AA A5 D8 00     CMP    word ptr [0xa5aa], 0xd8 ; CMP
068FAA  7D 2C                 JGE    0x68fd8 ; CJUMP
068FAC  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
068FAF  8B 1E AA A5           MOV    bx, word ptr [0xa5aa] ; GLOBAL_LOAD
068FB3  D1 E3                 SHL    bx, 1 ; LOGIC
068FB5  C4 36 A6 1E           LES    si, ptr [0x1ea6] ; MOV_FAR
068FB9  26 89 00              MOV    word ptr es:[bx + si], ax ; MOV
068FBC  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
068FBF  C4 1E AA 1E           LES    bx, ptr [0x1eaa] ; MOV_FAR
068FC3  8B 36 AA A5           MOV    si, word ptr [0xa5aa] ; GLOBAL_LOAD
068FC7  26 88 00              MOV    byte ptr es:[bx + si], al ; MOV
068FCA  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
068FCD  C4 1E AE 1E           LES    bx, ptr [0x1eae] ; MOV_FAR
068FD1  26 88 00              MOV    byte ptr es:[bx + si], al ; MOV
068FD4  FF 06 AA A5           INC    word ptr [0xa5aa] ; ARITH
068FD8  5E                    POP    si ; STACK_POP
068FD9  C9                    LEAVE ; EPILOGUE
068FDA  CB                    RETF ; RETURN
