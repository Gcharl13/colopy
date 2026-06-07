; ============================================================================
; func_0373CA_unknown
; Region   : overlay
; Bytes    : file 0x0373CA..0x03740E  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0373CA  55                    PUSH   bp ; STACK_PUSH
0373CB  8B EC                 MOV    bp, sp ; MOV
0373CD  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
0373D1  7D 05                 JGE    0x373d8 ; CJUMP
0373D3  C7 46 08 B8 00        MOV    word ptr [bp + 8], 0xb8 ; LOCAL_STORE
0373D8  83 7E 06 FF           CMP    word ptr [bp + 6], -1 ; CMP
0373DC  75 05                 JNE    0x373e3 ; CJUMP
0373DE  C7 46 06 91 00        MOV    word ptr [bp + 6], 0x91 ; LOCAL_STORE
0373E3  83 7E 06 FE           CMP    word ptr [bp + 6], -2 ; CMP
0373E7  75 05                 JNE    0x373ee ; CJUMP
0373E9  C7 46 06 1E 01        MOV    word ptr [bp + 6], 0x11e ; LOCAL_STORE
0373EE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0373F2  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0373F6  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0373FA  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0373FE  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
037401  05 0D 00              ADD    ax, 0xd ; ARITH
037404  50                    PUSH   ax ; STACK_PUSH
037405  6A 77                 PUSH   0x77 ; PUSH_CONST
037407  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03740A  8B D8                 MOV    bx, ax ; MOV
03740C  83                    DB     0x83 ; DATA_BYTE
03740D  C3                    DB     0xC3 ; DATA_BYTE
