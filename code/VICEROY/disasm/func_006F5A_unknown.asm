; ============================================================================
; func_006F5A_unknown
; Region   : load_image
; Bytes    : file 0x006F5A..0x006FC3  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006F5A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
006F5E  57                    PUSH   di ; STACK_PUSH
006F5F  56                    PUSH   si ; STACK_PUSH
006F60  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006F63  0B F6                 OR     si, si ; LOGIC
006F65  7C 54                 JL     0x6fbb ; CJUMP
006F67  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006F6A  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
006F6E  2A E4                 SUB    ah, ah ; ARITH
006F70  8B F8                 MOV    di, ax ; MOV
006F72  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
006F76  2A ED                 SUB    ch, ch ; ARITH
006F78  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
006F7B  51                    PUSH   cx ; STACK_PUSH
006F7C  50                    PUSH   ax ; STACK_PUSH
006F7D  56                    PUSH   si ; STACK_PUSH
006F7E  0E                    PUSH   cs ; STACK_PUSH
006F7F  E8 50 FA              CALL   0x69d2 ; CALL_NEAR
006F82  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
006F85  8B C6                 MOV    ax, si ; MOV
006F87  9A F8 02 F1 03        LCALL  0x3f1, 0x2f8 ; LCALL
006F8C  6A 00                 PUSH   0 ; STACK_PUSH
006F8E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
006F91  57                    PUSH   di ; STACK_PUSH
006F92  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
006F95  57                    PUSH   di ; STACK_PUSH
006F96  9A FC 02 84 09        LCALL  0x984, 0x2fc ; LCALL
006F9B  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
006F9E  0B C0                 OR     ax, ax ; LOGIC
006FA0  75 19                 JNE    0x6fbb ; CJUMP
006FA2  6A 01                 PUSH   1 ; STACK_PUSH
006FA4  6A 07                 PUSH   7 ; STACK_PUSH
006FA6  6A 07                 PUSH   7 ; STACK_PUSH
006FA8  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
006FAB  2D 03 00              SUB    ax, 3 ; ARITH
006FAE  50                    PUSH   ax ; STACK_PUSH
006FAF  8D 45 FD              LEA    ax, [di - 3] ; ADDR
006FB2  50                    PUSH   ax ; STACK_PUSH
006FB3  9A BA 09 1F 18        LCALL  0x181f, 0x9ba ; THUNK -> 0x0000:0x0004 (thunk @file 0x01AFAA type A) overlay @file 0x025904
006FB8  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
006FBB  89 36 92 53           MOV    word ptr [0x5392], si ; GLOBAL_LOAD
006FBF  5E                    POP    si ; STACK_POP
006FC0  5F                    POP    di ; STACK_POP
006FC1  C9                    LEAVE ; EPILOGUE
006FC2  CB                    RETF ; RETURN
