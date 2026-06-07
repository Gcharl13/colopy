; ============================================================================
; func_0103C2_unknown
; Region   : load_image
; Bytes    : file 0x0103C2..0x0103D3  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0103C2  55                    PUSH   bp ; STACK_PUSH
0103C3  8B EC                 MOV    bp, sp ; MOV
0103C5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0103C8  A3 EE 28              MOV    word ptr [0x28ee], ax ; GLOBAL_LOAD
0103CB  C7 06 F0 28 00 00     MOV    word ptr [0x28f0], 0 ; GLOBAL_LOAD
0103D1  5D                    POP    bp ; STACK_POP
0103D2  CB                    RETF ; RETURN
