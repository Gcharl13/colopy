; ============================================================================
; func_009DB4_unknown
; Region   : load_image
; Bytes    : file 0x009DB4..0x009DF9  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009DB4  55                    PUSH   bp ; STACK_PUSH
009DB5  8B EC                 MOV    bp, sp ; MOV
009DB7  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
009DBA  8B 07                 MOV    ax, word ptr [bx] ; MOV
009DBC  3B 06 F2 49           CMP    ax, word ptr [0x49f2] ; CMP
009DC0  7D 03                 JGE    0x9dc5 ; CJUMP
009DC2  A1 F2 49              MOV    ax, word ptr [0x49f2] ; GLOBAL_LOAD
009DC5  89 07                 MOV    word ptr [bx], ax ; MOV
009DC7  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
009DCA  8B 07                 MOV    ax, word ptr [bx] ; MOV
009DCC  3B 06 F4 49           CMP    ax, word ptr [0x49f4] ; CMP
009DD0  7D 03                 JGE    0x9dd5 ; CJUMP
009DD2  A1 F4 49              MOV    ax, word ptr [0x49f4] ; GLOBAL_LOAD
009DD5  89 07                 MOV    word ptr [bx], ax ; MOV
009DD7  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
009DDA  8B 07                 MOV    ax, word ptr [bx] ; MOV
009DDC  3B 06 26 60           CMP    ax, word ptr [0x6026] ; CMP
009DE0  7E 03                 JLE    0x9de5 ; CJUMP
009DE2  A1 26 60              MOV    ax, word ptr [0x6026] ; GLOBAL_LOAD
009DE5  89 07                 MOV    word ptr [bx], ax ; MOV
009DE7  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
009DEA  8B 07                 MOV    ax, word ptr [bx] ; MOV
009DEC  3B 06 3E 60           CMP    ax, word ptr [0x603e] ; CMP
009DF0  7E 03                 JLE    0x9df5 ; CJUMP
009DF2  A1 3E 60              MOV    ax, word ptr [0x603e] ; GLOBAL_LOAD
009DF5  89 07                 MOV    word ptr [bx], ax ; MOV
009DF7  C9                    LEAVE ; EPILOGUE
009DF8  CB                    RETF ; RETURN
