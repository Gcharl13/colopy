; ============================================================================
; func_00768C_unknown
; Region   : load_image
; Bytes    : file 0x00768C..0x00772D  (161 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00768C  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
007690  57                    PUSH   di ; STACK_PUSH
007691  56                    PUSH   si ; STACK_PUSH
007692  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
007695  C7 46 F6 FF FF        MOV    word ptr [bp - 0xa], 0xffff ; LOCAL_STORE
00769A  6A 00                 PUSH   0 ; STACK_PUSH
00769C  56                    PUSH   si ; STACK_PUSH
00769D  0E                    PUSH   cs ; STACK_PUSH
00769E  E8 A5 F4              CALL   0x6b46 ; CALL_NEAR
0076A1  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0076A4  8B C6                 MOV    ax, si ; MOV
0076A6  0E                    PUSH   cs ; STACK_PUSH
0076A7  E8 C8 EF              CALL   0x6672 ; CALL_NEAR
0076AA  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0076AD  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0076B1  2A E4                 SUB    ah, ah ; ARITH
0076B3  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0076B6  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
0076BA  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
0076BD  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0076C2  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
0076C5  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
0076C8  0E                    PUSH   cs ; STACK_PUSH
0076C9  E8 00 F0              CALL   0x66cc ; CALL_NEAR
0076CC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0076CF  8B 76 FC              MOV    si, word ptr [bp - 4] ; LOCAL_LOAD
0076D2  8B 7E F6              MOV    di, word ptr [bp - 0xa] ; LOCAL_LOAD
0076D5  0B C0                 OR     ax, ax ; LOGIC
0076D7  7C 2B                 JL     0x7704 ; CJUMP
0076D9  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
0076DC  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
0076E0  3C 0D                 CMP    al, 0xd ; CMP
0076E2  72 12                 JB     0x76f6 ; CJUMP
0076E4  3C 12                 CMP    al, 0x12 ; CMP
0076E6  77 0E                 JA     0x76f6 ; CJUMP
0076E8  8B 7E FE              MOV    di, word ptr [bp - 2] ; LOCAL_LOAD
0076EB  57                    PUSH   di ; STACK_PUSH
0076EC  0E                    PUSH   cs ; STACK_PUSH
0076ED  E8 3E 00              CALL   0x772e ; CALL_NEAR
0076F0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0076F3  BE 01 00              MOV    si, 1 ; MOV
0076F6  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0076F9  0E                    PUSH   cs ; STACK_PUSH
0076FA  E8 BD EF              CALL   0x66ba ; CALL_NEAR
0076FD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007700  0B F6                 OR     si, si ; LOGIC
007702  74 D1                 JE     0x76d5 ; CJUMP
007704  89 7E F6              MOV    word ptr [bp - 0xa], di ; LOCAL_STORE
007707  0B F6                 OR     si, si ; LOGIC
007709  75 B2                 JNE    0x76bd ; CJUMP
00770B  8B 7E F8              MOV    di, word ptr [bp - 8] ; LOCAL_LOAD
00770E  8B C7                 MOV    ax, di ; MOV
007710  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
007713  0E                    PUSH   cs ; STACK_PUSH
007714  E8 B5 EF              CALL   0x66cc ; CALL_NEAR
007717  8B F0                 MOV    si, ax ; MOV
007719  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00771C  57                    PUSH   di ; STACK_PUSH
00771D  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
007720  0E                    PUSH   cs ; STACK_PUSH
007721  E8 58 F3              CALL   0x6a7c ; CALL_NEAR
007724  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007727  8B C6                 MOV    ax, si ; MOV
007729  5E                    POP    si ; STACK_POP
00772A  5F                    POP    di ; STACK_POP
00772B  C9                    LEAVE ; EPILOGUE
00772C  CB                    RETF ; RETURN
