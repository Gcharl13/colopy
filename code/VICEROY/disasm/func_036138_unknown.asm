; ============================================================================
; func_036138_unknown
; Region   : overlay
; Bytes    : file 0x036138..0x0361B4  (124 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

036138  C8 62 00 00           ENTER  0x62, 0 ; PROLOGUE
03613C  56                    PUSH   si ; STACK_PUSH
03613D  C7 46 A8 00 00        MOV    word ptr [bp - 0x58], 0 ; LOCAL_STORE
036142  8B 1E 12 9E           MOV    bx, word ptr [0x9e12] ; GLOBAL_LOAD
036146  80 BF 98 92 00        CMP    byte ptr [bx - 0x6d68], 0 ; CMP
03614B  75 03                 JNE    0x36150 ; CJUMP
03614D  E9 4B 02              JMP    0x3639b ; JUMP
036150  83 3E 8E 53 1E        CMP    word ptr [0x538e], 0x1e ; CMP
036155  7D 03                 JGE    0x3615a ; CJUMP
036157  E9 41 02              JMP    0x3639b ; JUMP
03615A  C7 46 A4 12 00        MOV    word ptr [bp - 0x5c], 0x12 ; LOCAL_STORE
03615F  81 3E 8A 53 40 06     CMP    word ptr [0x538a], 0x640 ; CMP
036165  7E 05                 JLE    0x3616c ; CJUMP
036167  C7 46 A4 0F 00        MOV    word ptr [bp - 0x5c], 0xf ; LOCAL_STORE
03616C  81 3E 8A 53 A4 06     CMP    word ptr [0x538a], 0x6a4 ; CMP
036172  7E 04                 JLE    0x36178 ; CJUMP
036174  83 6E A4 03           SUB    word ptr [bp - 0x5c], 3 ; ARITH
036178  81 3E 8A 53 D6 06     CMP    word ptr [0x538a], 0x6d6 ; CMP
03617E  7E 04                 JLE    0x36184 ; CJUMP
036180  83 6E A4 03           SUB    word ptr [bp - 0x5c], 3 ; ARITH
036184  83 FB 04              CMP    bx, 4 ; CMP
036187  7D 17                 JGE    0x361a0 ; CJUMP
036189  6B DB 34              IMUL   bx, bx, 0x34 ; ARITH
03618C  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
036191  75 0D                 JNE    0x361a0 ; CJUMP
036193  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
036196  2A E4                 SUB    ah, ah ; ARITH
036198  48                    DEC    ax ; ARITH
036199  48                    DEC    ax ; ARITH
03619A  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
03619D  EB 06                 JMP    0x361a5 ; JUMP
03619F  90                    NOP ; NOP
0361A0  C7 46 9E 00 00        MOV    word ptr [bp - 0x62], 0 ; LOCAL_STORE
0361A5  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
0361A8  8B 4E A4              MOV    cx, word ptr [bp - 0x5c] ; LOCAL_LOAD
0361AB  8B 56 9E              MOV    dx, word ptr [bp - 0x62] ; LOCAL_LOAD
0361AE  D1 E2                 SHL    dx, 1 ; LOGIC
0361B0  2B CA                 SUB    cx, dx ; ARITH
0361B2  89                    DB     0x89 ; DATA_BYTE
0361B3  4E                    DB     0x4E ; DATA_BYTE
