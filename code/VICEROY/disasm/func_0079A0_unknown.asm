; ============================================================================
; func_0079A0_unknown
; Region   : load_image
; Bytes    : file 0x0079A0..0x007A17  (119 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0079A0  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0079A4  57                    PUSH   di ; STACK_PUSH
0079A5  56                    PUSH   si ; STACK_PUSH
0079A6  8B F0                 MOV    si, ax ; MOV
0079A8  2B FF                 SUB    di, di ; ARITH
0079AA  0B F6                 OR     si, si ; LOGIC
0079AC  7C 6C                 JL     0x7a1a ; CJUMP
0079AE  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
0079B2  7E 66                 JLE    0x7a1a ; CJUMP
0079B4  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0079B7  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
0079BA  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0079BE  2A E4                 SUB    ah, ah ; ARITH
0079C0  50                    PUSH   ax ; STACK_PUSH
0079C1  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0079C5  50                    PUSH   ax ; STACK_PUSH
0079C6  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
0079CB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0079CE  0B C0                 OR     ax, ax ; LOGIC
0079D0  74 48                 JE     0x7a1a ; CJUMP
0079D2  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0079D5  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
0079D9  24 0F                 AND    al, 0xf ; LOGIC
0079DB  3A 06 94 53           CMP    al, byte ptr [0x5394] ; CMP
0079DF  75 37                 JNE    0x7a18 ; CJUMP
0079E1  80 BF 4C 31 01        CMP    byte ptr [bx + 0x314c], 1 ; CMP
0079E6  74 30                 JE     0x7a18 ; CJUMP
0079E8  80 BF 4C 31 06        CMP    byte ptr [bx + 0x314c], 6 ; CMP
0079ED  74 29                 JE     0x7a18 ; CJUMP
0079EF  F6 87 48 31 80        TEST   byte ptr [bx + 0x3148], 0x80 ; LOGIC
0079F4  74 07                 JE     0x79fd ; CJUMP
0079F6  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
0079FB  75 1B                 JNE    0x7a18 ; CJUMP
0079FD  56                    PUSH   si ; STACK_PUSH
0079FE  0E                    PUSH   cs ; STACK_PUSH
0079FF  E8 C8 F2              CALL   0x6cca ; CALL_NEAR
007A02  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007A05  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007A08  38 87 49 31           CMP    byte ptr [bx + 0x3149], al ; CMP
007A0C  73 0A                 JAE    0x7a18 ; CJUMP
007A0E  BF 01 00              MOV    di, 1 ; MOV
007A11  8B C7                 MOV    ax, di ; MOV
007A13  5E                    POP    si ; STACK_POP
007A14  5F                    POP    di ; STACK_POP
007A15  C9                    LEAVE ; EPILOGUE
007A16  CB                    RETF ; RETURN
