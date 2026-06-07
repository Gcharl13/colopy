; ============================================================================
; func_00772E_unknown
; Region   : load_image
; Bytes    : file 0x00772E..0x0077C3  (149 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00772E  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
007732  57                    PUSH   di ; STACK_PUSH
007733  56                    PUSH   si ; STACK_PUSH
007734  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
007739  A1 00 02              MOV    ax, word ptr [0x200] ; GLOBAL_LOAD
00773C  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00773F  B8 01 00              MOV    ax, 1 ; MOV
007742  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
007745  A3 00 02              MOV    word ptr [0x200], ax ; GLOBAL_LOAD
007748  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00774B  83 7E F4 00           CMP    word ptr [bp - 0xc], 0 ; CMP
00774F  74 03                 JE     0x7754 ; CJUMP
007751  E9 8B 00              JMP    0x77df ; JUMP
007754  6A 00                 PUSH   0 ; STACK_PUSH
007756  56                    PUSH   si ; STACK_PUSH
007757  0E                    PUSH   cs ; STACK_PUSH
007758  E8 EB F3              CALL   0x6b46 ; CALL_NEAR
00775B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00775E  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007761  89 5E F2              MOV    word ptr [bp - 0xe], bx ; LOCAL_STORE
007764  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
007769  75 74                 JNE    0x77df ; CJUMP
00776B  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
007770  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007774  24 0F                 AND    al, 0xf ; LOGIC
007776  2A 87 44 31           SUB    al, byte ptr [bx + 0x3144] ; ARITH
00777A  3C 14                 CMP    al, 0x14 ; CMP
00777C  74 61                 JE     0x77df ; CJUMP
00777E  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
007782  2A E4                 SUB    ah, ah ; ARITH
007784  50                    PUSH   ax ; STACK_PUSH
007785  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
007789  50                    PUSH   ax ; STACK_PUSH
00778A  9A E4 03 7F 03        LCALL  0x37f, 0x3e4 ; LCALL
00778F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007792  0B C0                 OR     ax, ax ; LOGIC
007794  7D 49                 JGE    0x77df ; CJUMP
007796  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
007799  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
00779D  2A E4                 SUB    ah, ah ; ARITH
00779F  8B F8                 MOV    di, ax ; MOV
0077A1  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0077A5  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0077A8  6A FC                 PUSH   -4 ; STACK_PUSH
0077AA  6A FC                 PUSH   -4 ; STACK_PUSH
0077AC  56                    PUSH   si ; STACK_PUSH
0077AD  0E                    PUSH   cs ; STACK_PUSH
0077AE  E8 21 F2              CALL   0x69d2 ; CALL_NEAR
0077B1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0077B4  8B C7                 MOV    ax, di ; MOV
0077B6  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
0077B9  0E                    PUSH   cs ; STACK_PUSH
0077BA  E8 0F EF              CALL   0x66cc ; CALL_NEAR
0077BD  50                    PUSH   ax ; STACK_PUSH
0077BE  0E                    PUSH   cs ; STACK_PUSH
0077BF  E8 CA FE              CALL   0x768c ; CALL_NEAR
0077C2  83                    DB     0x83 ; DATA_BYTE
