; ============================================================================
; func_0128D6_unknown
; Region   : load_image
; Bytes    : file 0x0128D6..0x01291A  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0128D6  55                    PUSH   bp ; STACK_PUSH
0128D7  8B EC                 MOV    bp, sp ; MOV
0128D9  57                    PUSH   di ; STACK_PUSH
0128DA  56                    PUSH   si ; STACK_PUSH
0128DB  C7 06 38 44 00 00     MOV    word ptr [0x4438], 0 ; GLOBAL_LOAD
0128E1  B4 35                 MOV    ah, 0x35 ; CONST_LOAD
0128E3  B0 67                 MOV    al, 0x67 ; CONST_LOAD
0128E5  CD 21                 INT    0x21 ; SYS
0128E7  BF 0A 00              MOV    di, 0xa ; CONST_LOAD
0128EA  BE 6C 44              MOV    si, 0x446c ; CONST_LOAD
0128ED  33 DB                 XOR    bx, bx ; LOGIC
0128EF  B9 08 00              MOV    cx, 8 ; MOV
0128F2  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
0128F4  75 22                 JNE    0x12918 ; CJUMP
0128F6  A1 46 44              MOV    ax, word ptr [0x4446] ; GLOBAL_LOAD
0128F9  0B C0                 OR     ax, ax ; LOGIC
0128FB  75 1B                 JNE    0x12918 ; CJUMP
0128FD  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
0128FF  CD 67                 INT    0x67 ; SYS
012901  0A E4                 OR     ah, ah ; LOGIC
012903  75 13                 JNE    0x12918 ; CJUMP
012905  B4 46                 MOV    ah, 0x46 ; CONST_LOAD
012907  CD 67                 INT    0x67 ; SYS
012909  0A E4                 OR     ah, ah ; LOGIC
01290B  75 0B                 JNE    0x12918 ; CJUMP
01290D  8A E0                 MOV    ah, al ; MOV
01290F  C0 E8 04              SHR    al, 4 ; LOGIC
012912  3C 03                 CMP    al, 3 ; CMP
012914  72 02                 JB     0x12918 ; CJUMP
012916  EB 06                 JMP    0x1291e ; JUMP
012918  8B C3                 MOV    ax, bx ; MOV
