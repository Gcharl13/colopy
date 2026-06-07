; ============================================================================
; func_044556_unknown
; Region   : overlay
; Bytes    : file 0x044556..0x04458A  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044556  55                    PUSH   bp ; STACK_PUSH
044557  8B EC                 MOV    bp, sp ; MOV
044559  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04455C  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
04455F  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
044562  26 89 07              MOV    word ptr es:[bx], ax ; MOV
044565  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
044568  26 89 47 02           MOV    word ptr es:[bx + 2], ax ; MOV
04456C  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
04456F  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
044573  8B 46 14              MOV    ax, word ptr [bp + 0x14] ; LOCAL_LOAD
044576  26 89 47 06           MOV    word ptr es:[bx + 6], ax ; MOV
04457A  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
04457D  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
044580  26 89 47 08           MOV    word ptr es:[bx + 8], ax ; MOV
044584  26 89 57 0A           MOV    word ptr es:[bx + 0xa], dx ; MOV
044588  C9                    LEAVE ; EPILOGUE
044589  CB                    RETF ; RETURN
