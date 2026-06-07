; ============================================================================
; func_0082DC_unknown
; Region   : load_image
; Bytes    : file 0x0082DC..0x008308  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0082DC  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0082E0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0082E5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0082E8  A3 C6 8D              MOV    word ptr [0x8dc6], ax ; GLOBAL_LOAD
0082EB  0B C0                 OR     ax, ax ; LOGIC
0082ED  7C 06                 JL     0x82f5 ; CJUMP
0082EF  3B 06 9E 53           CMP    ax, word ptr [0x539e] ; CMP
0082F3  7C 0A                 JL     0x82ff ; CJUMP
0082F5  C7 46 06 00 00        MOV    word ptr [bp + 6], 0 ; LOCAL_STORE
0082FA  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0082FF  A0 96 53              MOV    al, byte ptr [0x5396] ; GLOBAL_LOAD
008302  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca ; ARITH
008307  81                    DB     0x81 ; DATA_BYTE
