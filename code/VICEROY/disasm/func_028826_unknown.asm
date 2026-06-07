; ============================================================================
; func_028826_unknown
; Region   : overlay
; Bytes    : file 0x028826..0x02883D  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028826  55                    PUSH   bp ; STACK_PUSH
028827  8B EC                 MOV    bp, sp ; MOV
028829  C7 06 B8 0B 01 00     MOV    word ptr [0xbb8], 1 ; GLOBAL_LOAD
02882F  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
028832  A3 CE 9C              MOV    word ptr [0x9cce], ax ; GLOBAL_LOAD
028835  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
028838  A3 D0 9C              MOV    word ptr [0x9cd0], ax ; GLOBAL_LOAD
02883B  C9                    LEAVE ; EPILOGUE
02883C  CB                    RETF ; RETURN
