; ============================================================================
; func_00B65A_unknown
; Region   : load_image
; Bytes    : file 0x00B65A..0x00B681  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B65A  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
00B65E  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
00B663  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
00B666  50                    PUSH   ax ; STACK_PUSH
00B667  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B66A  0E                    PUSH   cs ; STACK_PUSH
00B66B  E8 3A FF              CALL   0xb5a8 ; CALL_NEAR
00B66E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B671  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B674  48                    DEC    ax ; ARITH
00B675  74 05                 JE     0xb67c ; CJUMP
00B677  48                    DEC    ax ; ARITH
00B678  74 28                 JE     0xb6a2 ; CJUMP
00B67A  EB 70                 JMP    0xb6ec ; JUMP
00B67C  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
00B67F  8B C3                 MOV    ax, bx ; MOV
