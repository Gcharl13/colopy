; ============================================================================
; func_05A20E_unknown
; Region   : overlay
; Bytes    : file 0x05A20E..0x05A29B  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "SCOUTCOLONY", "NOMAYORSDURINGREV"  (auto-named via string xrefs)
; ============================================================================

05A20E  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
05A212  56                    PUSH   si ; STACK_PUSH
05A213  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
05A218  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05A21C  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
05A220  25 0F 00              AND    ax, 0xf ; LOGIC
05A223  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
05A226  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05A22A  8A 4F 1A              MOV    cl, byte ptr [bx + 0x1a] ; MOV
05A22D  2A ED                 SUB    ch, ch ; ARITH
05A22F  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
05A232  3D 04 00              CMP    ax, 4 ; CMP
05A235  7D 2B                 JGE    0x5a262 ; CJUMP
05A237  6B F0 34              IMUL   si, ax, 0x34 ; ARITH
05A23A  38 AC 3F 54           CMP    byte ptr [si + 0x543f], ch ; CMP
05A23E  75 22                 JNE    0x5a262 ; CJUMP
05A240  8D 47 02              LEA    ax, [bx + 2] ; ADDR
05A243  1E                    PUSH   ds ; STACK_PUSH
05A244  50                    PUSH   ax ; STACK_PUSH
05A245  6A 00                 PUSH   0 ; STACK_PUSH
05A247  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
05A24C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05A24F  6A 03                 PUSH   3 ; STACK_PUSH
05A251  68 64 1A              PUSH   0x1a64                       ; STRING: "SCOUTCOLONY"
05A254  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
05A259  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05A25C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
05A25F  EB 06                 JMP    0x5a267 ; JUMP
05A261  90                    NOP ; NOP
05A262  C7 46 FA 03 00        MOV    word ptr [bp - 6], 3 ; LOCAL_STORE
05A267  83 7E FA 03           CMP    word ptr [bp - 6], 3 ; CMP
05A26B  74 05                 JE     0x5a272 ; CJUMP
05A26D  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
05A272  83 7E FA 03           CMP    word ptr [bp - 6], 3 ; CMP
05A276  7C 03                 JL     0x5a27b ; CJUMP
05A278  E9 8C 01              JMP    0x5a407 ; JUMP
05A27B  83 7E FA 01           CMP    word ptr [bp - 6], 1 ; CMP
05A27F  75 5B                 JNE    0x5a2dc ; CJUMP
05A281  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
05A286  74 14                 JE     0x5a29c ; CJUMP
05A288  6A 01                 PUSH   1 ; STACK_PUSH
05A28A  68 70 1A              PUSH   0x1a70                       ; STRING: "NOMAYORSDURINGREV"
05A28D  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
05A292  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05A295  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
05A298  5E                    POP    si ; STACK_POP
05A299  C9                    LEAVE ; EPILOGUE
05A29A  CB                    RETF ; RETURN
