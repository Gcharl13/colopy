; ============================================================================
; func_005588_unknown
; Region   : load_image
; Bytes    : file 0x005588..0x0055D1  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005588  55                    PUSH   bp ; STACK_PUSH
005589  8B EC                 MOV    bp, sp ; MOV
00558B  83 EC 0E              SUB    sp, 0xe ; STACK_ALLOC
00558E  57                    PUSH   di ; STACK_PUSH
00558F  56                    PUSH   si ; STACK_PUSH
005590  BF FF FF              MOV    di, 0xffff ; CONST_LOAD
005593  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005596  F6 44 06 40           TEST   byte ptr [si + 6], 0x40 ; LOGIC
00559A  74 03                 JE     0x559f ; CJUMP
00559C  E9 97 00              JMP    0x5636 ; JUMP
00559F  F6 44 06 83           TEST   byte ptr [si + 6], 0x83 ; LOGIC
0055A3  75 03                 JNE    0x55a8 ; CJUMP
0055A5  E9 8E 00              JMP    0x5636 ; JUMP
0055A8  56                    PUSH   si ; STACK_PUSH
0055A9  9A E6 14 52 04        LCALL  0x452, 0x14e6 ; LCALL
0055AE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0055B1  8B F8                 MOV    di, ax ; MOV
0055B3  8B DE                 MOV    bx, si ; MOV
0055B5  81 EB FE 43           SUB    bx, 0x43fe ; ARITH
0055B9  8B 87 A2 44           MOV    ax, word ptr [bx + 0x44a2] ; MOV
0055BD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0055C0  56                    PUSH   si ; STACK_PUSH
0055C1  E8 7C 0E              CALL   0x6440 ; CALL_NEAR
0055C4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0055C7  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
0055CA  2A E4                 SUB    ah, ah ; ARITH
0055CC  50                    PUSH   ax ; STACK_PUSH
0055CD  9A                    DB     0x9A ; DATA_BYTE
0055CE  CA                    DB     0xCA ; DATA_BYTE
0055CF  1A                    DB     0x1A ; DATA_BYTE
0055D0  52                    DB     0x52 ; DATA_BYTE
