; ============================================================================
; func_00B77A_unknown
; Region   : load_image
; Bytes    : file 0x00B77A..0x00B7BE  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B77A  55                    PUSH   bp ; STACK_PUSH
00B77B  8B EC                 MOV    bp, sp ; MOV
00B77D  57                    PUSH   di ; STACK_PUSH
00B77E  56                    PUSH   si ; STACK_PUSH
00B77F  C7 06 08 42 00 00     MOV    word ptr [0x4208], 0 ; GLOBAL_LOAD
00B785  B4 35                 MOV    ah, 0x35 ; CONST_LOAD
00B787  B0 67                 MOV    al, 0x67 ; CONST_LOAD
00B789  CD 21                 INT    0x21 ; SYS
00B78B  BF 0A 00              MOV    di, 0xa ; CONST_LOAD
00B78E  BE 3C 42              MOV    si, 0x423c ; CONST_LOAD
00B791  33 DB                 XOR    bx, bx ; LOGIC
00B793  B9 08 00              MOV    cx, 8 ; MOV
00B796  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
00B798  75 22                 JNE    0xb7bc ; CJUMP
00B79A  A1 16 42              MOV    ax, word ptr [0x4216] ; GLOBAL_LOAD
00B79D  0B C0                 OR     ax, ax ; LOGIC
00B79F  75 1B                 JNE    0xb7bc ; CJUMP
00B7A1  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
00B7A3  CD 67                 INT    0x67 ; SYS
00B7A5  0A E4                 OR     ah, ah ; LOGIC
00B7A7  75 13                 JNE    0xb7bc ; CJUMP
00B7A9  B4 46                 MOV    ah, 0x46 ; CONST_LOAD
00B7AB  CD 67                 INT    0x67 ; SYS
00B7AD  0A E4                 OR     ah, ah ; LOGIC
00B7AF  75 0B                 JNE    0xb7bc ; CJUMP
00B7B1  8A E0                 MOV    ah, al ; MOV
00B7B3  C0 E8 04              SHR    al, 4 ; LOGIC
00B7B6  3C 03                 CMP    al, 3 ; CMP
00B7B8  72 02                 JB     0xb7bc ; CJUMP
00B7BA  EB 06                 JMP    0xb7c2 ; JUMP
00B7BC  8B C3                 MOV    ax, bx ; MOV
