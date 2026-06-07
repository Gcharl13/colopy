; ============================================================================
; func_00B550_unknown
; Region   : load_image
; Bytes    : file 0x00B550..0x00B5A8  (88 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B550  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00B554  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
00B559  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
00B55E  EB 2A                 JMP    0xb58a ; JUMP
00B560  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B564  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
00B568  2A E4                 SUB    ah, ah ; ARITH
00B56A  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
00B56D  7E 21                 JLE    0xb590 ; CJUMP
00B56F  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00B572  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B575  0E                    PUSH   cs ; STACK_PUSH
00B576  E8 29 FD              CALL   0xb2a2 ; CALL_NEAR
00B579  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B57C  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
00B57F  75 06                 JNE    0xb587 ; CJUMP
00B581  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00B584  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00B587  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
00B58A  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
00B58E  7C D0                 JL     0xb560 ; CJUMP
00B590  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
00B594  7C 0D                 JL     0xb5a3 ; CJUMP
00B596  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00B599  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B59C  0E                    PUSH   cs ; STACK_PUSH
00B59D  E8 50 FD              CALL   0xb2f0 ; CALL_NEAR
00B5A0  A3 C4 8D              MOV    word ptr [0x8dc4], ax ; GLOBAL_LOAD
00B5A3  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00B5A6  C9                    LEAVE ; EPILOGUE
00B5A7  CB                    RETF ; RETURN
