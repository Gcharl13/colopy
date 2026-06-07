; ============================================================================
; func_06787C_unknown
; Region   : overlay
; Bytes    : file 0x06787C..0x0678F3  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06787C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
067880  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
067884  B8 0F 00              MOV    ax, 0xf ; CONST_LOAD
067887  D3 E0                 SHL    ax, cl ; LOGIC
067889  A3 44 85              MOV    word ptr [0x8544], ax ; GLOBAL_LOAD
06788C  B8 0C 00              MOV    ax, 0xc ; CONST_LOAD
06788F  D3 E0                 SHL    ax, cl ; LOGIC
067891  A3 46 85              MOV    word ptr [0x8546], ax ; GLOBAL_LOAD
067894  83 3E 8A 01 00        CMP    word ptr [0x18a], 0 ; CMP
067899  74 0F                 JE     0x678aa ; CJUMP
06789B  B8 05 00              MOV    ax, 5 ; MOV
06789E  A3 44 85              MOV    word ptr [0x8544], ax ; GLOBAL_LOAD
0678A1  A3 46 85              MOV    word ptr [0x8546], ax ; GLOBAL_LOAD
0678A4  C7 06 84 01 00 00     MOV    word ptr [0x184], 0 ; GLOBAL_LOAD
0678AA  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
0678AE  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0678B1  D3 F8                 SAR    ax, cl ; LOGIC
0678B3  A3 D4 5A              MOV    word ptr [0x5ad4], ax ; GLOBAL_LOAD
0678B6  A3 26 83              MOV    word ptr [0x8326], ax ; GLOBAL_LOAD
0678B9  A1 44 85              MOV    ax, word ptr [0x8544] ; GLOBAL_LOAD
0678BC  D1 F8                 SAR    ax, 1 ; LOGIC
0678BE  2B 06 7C 01           SUB    ax, word ptr [0x17c] ; ARITH
0678C2  F7 D8                 NEG    ax ; ARITH
0678C4  A3 28 83              MOV    word ptr [0x8328], ax ; GLOBAL_LOAD
0678C7  8B 0E 46 85           MOV    cx, word ptr [0x8546] ; GLOBAL_LOAD
0678CB  D1 F9                 SAR    cx, 1 ; LOGIC
0678CD  2B 0E 7E 01           SUB    cx, word ptr [0x17e] ; ARITH
0678D1  F7 D9                 NEG    cx ; ARITH
0678D3  89 0E 2E 83           MOV    word ptr [0x832e], cx ; GLOBAL_LOAD
0678D7  83 3E 8A 01 00        CMP    word ptr [0x18a], 0 ; CMP
0678DC  75 34                 JNE    0x67912 ; CJUMP
0678DE  3D 01 00              CMP    ax, 1 ; CMP
0678E1  7D 03                 JGE    0x678e6 ; CJUMP
0678E3  B8 01 00              MOV    ax, 1 ; MOV
0678E6  8B 16 3A 85           MOV    dx, word ptr [0x853a] ; GLOBAL_LOAD
0678EA  2B 16 44 85           SUB    dx, word ptr [0x8544] ; ARITH
0678EE  4A                    DEC    dx ; ARITH
0678EF  3B C2                 CMP    ax, dx ; CMP
0678F1  7E 02                 JLE    0x678f5 ; CJUMP
