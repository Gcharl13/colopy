; ============================================================================
; func_0068AA_unknown
; Region   : load_image
; Bytes    : file 0x0068AA..0x006939  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0068AA  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0068AE  57                    PUSH   di ; STACK_PUSH
0068AF  56                    PUSH   si ; STACK_PUSH
0068B0  8B F0                 MOV    si, ax ; MOV
0068B2  2B DB                 SUB    bx, bx ; ARITH
0068B4  6B FE 1C              IMUL   di, si, 0x1c ; ARITH
0068B7  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
0068BA  39 9D 5C 31           CMP    word ptr [di + 0x315c], bx ; CMP
0068BE  7C 12                 JL     0x68d2 ; CJUMP
0068C0  8B DF                 MOV    bx, di ; MOV
0068C2  8B 87 5E 31           MOV    ax, word ptr [bx + 0x315e] ; MOV
0068C6  6B 9F 5C 31 1C        IMUL   bx, word ptr [bx + 0x315c], 0x1c ; ARITH
0068CB  89 87 5E 31           MOV    word ptr [bx + 0x315e], ax ; MOV
0068CF  BB 01 00              MOV    bx, 1 ; MOV
0068D2  8B 7E FE              MOV    di, word ptr [bp - 2] ; LOCAL_LOAD
0068D5  83 BD 5E 31 00        CMP    word ptr [di + 0x315e], 0 ; CMP
0068DA  7C 12                 JL     0x68ee ; CJUMP
0068DC  8B DF                 MOV    bx, di ; MOV
0068DE  8B 87 5C 31           MOV    ax, word ptr [bx + 0x315c] ; MOV
0068E2  6B 9F 5E 31 1C        IMUL   bx, word ptr [bx + 0x315e], 0x1c ; ARITH
0068E7  89 87 5C 31           MOV    word ptr [bx + 0x315c], ax ; MOV
0068EB  BB 01 00              MOV    bx, 1 ; MOV
0068EE  0B DB                 OR     bx, bx ; LOGIC
0068F0  75 36                 JNE    0x6928 ; CJUMP
0068F2  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
0068F5  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0068F9  2A E4                 SUB    ah, ah ; ARITH
0068FB  50                    PUSH   ax ; STACK_PUSH
0068FC  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
006900  50                    PUSH   ax ; STACK_PUSH
006901  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
006906  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006909  0B C0                 OR     ax, ax ; LOGIC
00690B  74 1B                 JE     0x6928 ; CJUMP
00690D  6A 00                 PUSH   0 ; STACK_PUSH
00690F  6A 01                 PUSH   1 ; STACK_PUSH
006911  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
006914  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
006918  2A E4                 SUB    ah, ah ; ARITH
00691A  50                    PUSH   ax ; STACK_PUSH
00691B  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
00691F  50                    PUSH   ax ; STACK_PUSH
006920  9A 5E 01 7F 03        LCALL  0x37f, 0x15e ; LCALL
006925  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
006928  B0 FF                 MOV    al, 0xff ; CONST_LOAD
00692A  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00692D  88 87 44 31           MOV    byte ptr [bx + 0x3144], al ; MOV
006931  88 87 45 31           MOV    byte ptr [bx + 0x3145], al ; MOV
006935  5E                    POP    si ; STACK_POP
006936  5F                    POP    di ; STACK_POP
006937  C9                    LEAVE ; EPILOGUE
006938  CB                    RETF ; RETURN
