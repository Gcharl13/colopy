; ============================================================================
; func_00A844_unknown
; Region   : load_image
; Bytes    : file 0x00A844..0x00A888  (68 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A844  55                    PUSH   bp ; STACK_PUSH
00A845  8B EC                 MOV    bp, sp ; MOV
00A847  57                    PUSH   di ; STACK_PUSH
00A848  56                    PUSH   si ; STACK_PUSH
00A849  C7 06 B2 3F 00 00     MOV    word ptr [0x3fb2], 0 ; GLOBAL_LOAD
00A84F  B4 35                 MOV    ah, 0x35 ; CONST_LOAD
00A851  B0 67                 MOV    al, 0x67 ; CONST_LOAD
00A853  CD 21                 INT    0x21 ; SYS
00A855  BF 0A 00              MOV    di, 0xa ; CONST_LOAD
00A858  BE E6 3F              MOV    si, 0x3fe6 ; CONST_LOAD
00A85B  33 DB                 XOR    bx, bx ; LOGIC
00A85D  B9 08 00              MOV    cx, 8 ; MOV
00A860  F3 A6                 REPE CMPSB byte ptr [si], byte ptr es:[di] ; STR
00A862  75 22                 JNE    0xa886 ; CJUMP
00A864  A1 C0 3F              MOV    ax, word ptr [0x3fc0] ; GLOBAL_LOAD
00A867  0B C0                 OR     ax, ax ; LOGIC
00A869  75 1B                 JNE    0xa886 ; CJUMP
00A86B  B4 40                 MOV    ah, 0x40 ; CONST_LOAD
00A86D  CD 67                 INT    0x67 ; SYS
00A86F  0A E4                 OR     ah, ah ; LOGIC
00A871  75 13                 JNE    0xa886 ; CJUMP
00A873  B4 46                 MOV    ah, 0x46 ; CONST_LOAD
00A875  CD 67                 INT    0x67 ; SYS
00A877  0A E4                 OR     ah, ah ; LOGIC
00A879  75 0B                 JNE    0xa886 ; CJUMP
00A87B  8A E0                 MOV    ah, al ; MOV
00A87D  C0 E8 04              SHR    al, 4 ; LOGIC
00A880  3C 03                 CMP    al, 3 ; CMP
00A882  72 02                 JB     0xa886 ; CJUMP
00A884  EB 06                 JMP    0xa88c ; JUMP
00A886  8B C3                 MOV    ax, bx ; MOV
