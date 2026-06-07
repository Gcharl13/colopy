; ============================================================================
; func_066E0C_unknown
; Region   : overlay
; Bytes    : file 0x066E0C..0x066E51  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066E0C  55                    PUSH   bp ; STACK_PUSH
066E0D  8B EC                 MOV    bp, sp ; MOV
066E0F  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
066E12  8B 07                 MOV    ax, word ptr [bx] ; MOV
066E14  3B 06 28 83           CMP    ax, word ptr [0x8328] ; CMP
066E18  7D 03                 JGE    0x66e1d ; CJUMP
066E1A  A1 28 83              MOV    ax, word ptr [0x8328] ; GLOBAL_LOAD
066E1D  89 07                 MOV    word ptr [bx], ax ; MOV
066E1F  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
066E22  8B 07                 MOV    ax, word ptr [bx] ; MOV
066E24  3B 06 2E 83           CMP    ax, word ptr [0x832e] ; CMP
066E28  7D 03                 JGE    0x66e2d ; CJUMP
066E2A  A1 2E 83              MOV    ax, word ptr [0x832e] ; GLOBAL_LOAD
066E2D  89 07                 MOV    word ptr [bx], ax ; MOV
066E2F  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
066E32  8B 07                 MOV    ax, word ptr [bx] ; MOV
066E34  3B 06 04 88           CMP    ax, word ptr [0x8804] ; CMP
066E38  7E 03                 JLE    0x66e3d ; CJUMP
066E3A  A1 04 88              MOV    ax, word ptr [0x8804] ; GLOBAL_LOAD
066E3D  89 07                 MOV    word ptr [bx], ax ; MOV
066E3F  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
066E42  8B 07                 MOV    ax, word ptr [bx] ; MOV
066E44  3B 06 06 88           CMP    ax, word ptr [0x8806] ; CMP
066E48  7E 03                 JLE    0x66e4d ; CJUMP
066E4A  A1 06 88              MOV    ax, word ptr [0x8806] ; GLOBAL_LOAD
066E4D  89 07                 MOV    word ptr [bx], ax ; MOV
066E4F  C9                    LEAVE ; EPILOGUE
066E50  CB                    RETF ; RETURN
