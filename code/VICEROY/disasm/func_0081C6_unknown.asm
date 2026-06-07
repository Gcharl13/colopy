; ============================================================================
; func_0081C6_unknown
; Region   : load_image
; Bytes    : file 0x0081C6..0x0081F2  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0081C6  55                    PUSH   bp ; STACK_PUSH
0081C7  8B EC                 MOV    bp, sp ; MOV
0081C9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0081CC  A3 52 8D              MOV    word ptr [0x8d52], ax ; GLOBAL_LOAD
0081CF  0B C0                 OR     ax, ax ; LOGIC
0081D1  7C 05                 JL     0x81d8 ; CJUMP
0081D3  3D 08 00              CMP    ax, 8 ; CMP
0081D6  7C 05                 JL     0x81dd ; CJUMP
0081D8  C7 46 06 00 00        MOV    word ptr [bp + 6], 0 ; LOCAL_STORE
0081DD  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0081E0  05 04 00              ADD    ax, 4 ; ARITH
0081E3  A3 50 8D              MOV    word ptr [0x8d50], ax ; GLOBAL_LOAD
0081E6  6B 46 06 4E           IMUL   ax, word ptr [bp + 6], 0x4e ; ARITH
0081EA  05 D6 5A              ADD    ax, 0x5ad6 ; ARITH
0081ED  A3 4E 8D              MOV    word ptr [0x8d4e], ax ; GLOBAL_LOAD
0081F0  C9                    LEAVE ; EPILOGUE
0081F1  CB                    RETF ; RETURN
