; ============================================================================
; func_010292_unknown
; Region   : load_image
; Bytes    : file 0x010292..0x0102C8  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010292  55                    PUSH   bp ; STACK_PUSH
010293  8B EC                 MOV    bp, sp ; MOV
010295  57                    PUSH   di ; STACK_PUSH
010296  56                    PUSH   si ; STACK_PUSH
010297  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
01029A  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
01029D  1E                    PUSH   ds ; STACK_PUSH
01029E  07                    POP    es ; STACK_POP
01029F  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0102A2  E3 3D                 JCXZ   0x102e1 ; CJUMP
0102A4  B7 41                 MOV    bh, 0x41 ; CONST_LOAD
0102A6  B3 5A                 MOV    bl, 0x5a ; CONST_LOAD
0102A8  B6 20                 MOV    dh, 0x20 ; CONST_LOAD
0102AA  8A 24                 MOV    ah, byte ptr [si] ; MOV
0102AC  8A 05                 MOV    al, byte ptr [di] ; MOV
0102AE  0A E4                 OR     ah, ah ; LOGIC
0102B0  74 20                 JE     0x102d2 ; CJUMP
0102B2  0A C0                 OR     al, al ; LOGIC
0102B4  74 1C                 JE     0x102d2 ; CJUMP
0102B6  46                    INC    si ; ARITH
0102B7  47                    INC    di ; ARITH
0102B8  3A E7                 CMP    ah, bh ; CMP
0102BA  72 06                 JB     0x102c2 ; CJUMP
0102BC  3A E3                 CMP    ah, bl ; CMP
0102BE  77 02                 JA     0x102c2 ; CJUMP
0102C0  02 E6                 ADD    ah, dh ; ARITH
0102C2  3A C7                 CMP    al, bh ; CMP
0102C4  72 06                 JB     0x102cc ; CJUMP
0102C6  3A C3                 CMP    al, bl ; CMP
