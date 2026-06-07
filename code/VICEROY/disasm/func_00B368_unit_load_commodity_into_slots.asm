; ============================================================================
; func_00B368_unknown
; Region   : load_image
; Bytes    : file 0x00B368..0x00B3E6  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B368  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
00B36C  56                    PUSH   si ; STACK_PUSH
00B36D  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
00B372  EB 50                 JMP    0xb3c4 ; JUMP
00B374  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00B377  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B37A  0E                    PUSH   cs ; STACK_PUSH
00B37B  E8 24 FF              CALL   0xb2a2 ; CALL_NEAR
00B37E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B381  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
00B384  75 3B                 JNE    0xb3c1 ; CJUMP
00B386  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00B389  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B38C  0E                    PUSH   cs ; STACK_PUSH
00B38D  E8 60 FF              CALL   0xb2f0 ; CALL_NEAR
00B390  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B393  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00B396  2D 64 00              SUB    ax, 0x64 ; ARITH
00B399  F7 D8                 NEG    ax ; ARITH
00B39B  0B C0                 OR     ax, ax ; LOGIC
00B39D  74 22                 JE     0xb3c1 ; CJUMP
00B39F  3B 46 0A              CMP    ax, word ptr [bp + 0xa] ; CMP
00B3A2  7E 03                 JLE    0xb3a7 ; CJUMP
00B3A4  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00B3A7  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B3AA  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
00B3AD  50                    PUSH   ax ; STACK_PUSH
00B3AE  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00B3B1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B3B4  0E                    PUSH   cs ; STACK_PUSH
00B3B5  E8 4C FF              CALL   0xb304 ; CALL_NEAR
00B3B8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00B3BB  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00B3BE  29 46 0A              SUB    word ptr [bp + 0xa], ax ; ARITH
00B3C1  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
00B3C4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B3C8  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
00B3CC  2A E4                 SUB    ah, ah ; ARITH
00B3CE  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
00B3D1  7F A1                 JG     0xb374 ; CJUMP
00B3D3  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
00B3D7  74 4D                 JE     0xb426 ; CJUMP
00B3D9  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B3DD  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
00B3E1  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B3E4  8B CB                 MOV    cx, bx ; MOV
