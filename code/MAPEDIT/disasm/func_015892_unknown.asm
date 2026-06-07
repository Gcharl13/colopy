; ============================================================================
; func_015892_unknown
; Region   : load_image
; Bytes    : file 0x015892..0x0158C8  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015892  55                    PUSH   bp ; STACK_PUSH
015893  8B EC                 MOV    bp, sp ; MOV
015895  57                    PUSH   di ; STACK_PUSH
015896  56                    PUSH   si ; STACK_PUSH
015897  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
01589A  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
01589D  1E                    PUSH   ds ; STACK_PUSH
01589E  07                    POP    es ; STACK_POP
01589F  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
0158A2  E3 3D                 JCXZ   0x158e1 ; CJUMP
0158A4  B7 41                 MOV    bh, 0x41 ; CONST_LOAD
0158A6  B3 5A                 MOV    bl, 0x5a ; CONST_LOAD
0158A8  B6 20                 MOV    dh, 0x20 ; CONST_LOAD
0158AA  8A 24                 MOV    ah, byte ptr [si] ; MOV
0158AC  8A 05                 MOV    al, byte ptr [di] ; MOV
0158AE  0A E4                 OR     ah, ah ; LOGIC
0158B0  74 20                 JE     0x158d2 ; CJUMP
0158B2  0A C0                 OR     al, al ; LOGIC
0158B4  74 1C                 JE     0x158d2 ; CJUMP
0158B6  46                    INC    si ; ARITH
0158B7  47                    INC    di ; ARITH
0158B8  3A E7                 CMP    ah, bh ; CMP
0158BA  72 06                 JB     0x158c2 ; CJUMP
0158BC  3A E3                 CMP    ah, bl ; CMP
0158BE  77 02                 JA     0x158c2 ; CJUMP
0158C0  02 E6                 ADD    ah, dh ; ARITH
0158C2  3A C7                 CMP    al, bh ; CMP
0158C4  72 06                 JB     0x158cc ; CJUMP
0158C6  3A C3                 CMP    al, bl ; CMP
