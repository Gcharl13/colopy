; ============================================================================
; func_06FDF0_unknown
; Region   : overlay
; Bytes    : file 0x06FDF0..0x06FE1C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FDF0  55                    PUSH   bp ; STACK_PUSH
06FDF1  8B EC                 MOV    bp, sp ; MOV
06FDF3  6B 46 06 4C           IMUL   ax, word ptr [bp + 6], 0x4c ; ARITH
06FDF7  05 0A 00              ADD    ax, 0xa ; ARITH
06FDFA  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
06FDFD  89 07                 MOV    word ptr [bx], ax ; MOV
06FDFF  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
06FE03  7E 05                 JLE    0x6fe0a ; CJUMP
06FE05  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
06FE08  EB 02                 JMP    0x6fe0c ; JUMP
06FE0A  2B C0                 SUB    ax, ax ; ARITH
06FE0C  6B 4E 08 3C           IMUL   cx, word ptr [bp + 8], 0x3c ; ARITH
06FE10  03 C1                 ADD    ax, cx ; ARITH
06FE12  05 10 00              ADD    ax, 0x10 ; ARITH
06FE15  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
06FE18  89 07                 MOV    word ptr [bx], ax ; MOV
06FE1A  C9                    LEAVE ; EPILOGUE
06FE1B  CB                    RETF ; RETURN
