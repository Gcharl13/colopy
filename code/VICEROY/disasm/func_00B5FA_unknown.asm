; ============================================================================
; func_00B5FA_unknown
; Region   : load_image
; Bytes    : file 0x00B5FA..0x00B629  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B5FA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
00B5FE  2B C0                 SUB    ax, ax ; ARITH
00B600  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00B603  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00B606  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
00B609  50                    PUSH   ax ; STACK_PUSH
00B60A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B60D  0E                    PUSH   cs ; STACK_PUSH
00B60E  E8 97 FF              CALL   0xb5a8 ; CALL_NEAR
00B611  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B614  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B617  48                    DEC    ax ; ARITH
00B618  74 0A                 JE     0xb624 ; CJUMP
00B61A  48                    DEC    ax ; ARITH
00B61B  74 27                 JE     0xb644 ; CJUMP
00B61D  FF 36 FA 2D           PUSH   word ptr [0x2dfa] ; PUSH_GLOBAL
00B621  EB 11                 JMP    0xb634 ; JUMP
00B623  90                    NOP ; NOP
00B624  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
00B627  8B C3                 MOV    ax, bx ; MOV
