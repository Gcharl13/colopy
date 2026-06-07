; ============================================================================
; func_0120D2_unknown
; Region   : load_image
; Bytes    : file 0x0120D2..0x0120E6  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0120D2  55                    PUSH   bp ; STACK_PUSH
0120D3  8B EC                 MOV    bp, sp ; MOV
0120D5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0120D8  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
0120DB  A3 04 44              MOV    word ptr [0x4404], ax ; GLOBAL_LOAD
0120DE  89 16 06 44           MOV    word ptr [0x4406], dx ; GLOBAL_LOAD
0120E2  C9                    LEAVE ; EPILOGUE
0120E3  CA 04 00              RETF   4 ; RETURN
