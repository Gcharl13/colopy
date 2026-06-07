; ============================================================================
; func_0641EC_unknown
; Region   : overlay
; Bytes    : file 0x0641EC..0x064266  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0641EC  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0641F0  6A 40                 PUSH   0x40 ; PUSH_CONST
0641F2  6A 01                 PUSH   1 ; STACK_PUSH
0641F4  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
0641F9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0641FC  40                    INC    ax ; ARITH
0641FD  40                    INC    ax ; ARITH
0641FE  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
064201  EB 52                 JMP    0x64255 ; JUMP
064203  90                    NOP ; NOP
064204  A0 20 2D              MOV    al, byte ptr [0x2d20] ; GLOBAL_LOAD
064207  98                    CWDE ; ARITH
064208  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
06420B  7D 52                 JGE    0x6425f ; CJUMP
06420D  A0 1E 2D              MOV    al, byte ptr [0x2d1e] ; GLOBAL_LOAD
064210  98                    CWDE ; ARITH
064211  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
064214  7E 49                 JLE    0x6425f ; CJUMP
064216  A0 21 2D              MOV    al, byte ptr [0x2d21] ; GLOBAL_LOAD
064219  98                    CWDE ; ARITH
06421A  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
06421D  7D 40                 JGE    0x6425f ; CJUMP
06421F  A0 1F 2D              MOV    al, byte ptr [0x2d1f] ; GLOBAL_LOAD
064222  98                    CWDE ; ARITH
064223  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
064226  7E 37                 JLE    0x6425f ; CJUMP
064228  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06422B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06422E  E8 23 FF              CALL   0x64154 ; CALL_NEAR
064231  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064234  6A 04                 PUSH   4 ; STACK_PUSH
064236  6A 01                 PUSH   1 ; STACK_PUSH
064238  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
06423D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064240  8B D8                 MOV    bx, ax ; MOV
064242  D1 E3                 SHL    bx, 1 ; LOGIC
064244  4B                    DEC    bx ; ARITH
064245  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
064249  98                    CWDE ; ARITH
06424A  01 46 06              ADD    word ptr [bp + 6], ax ; ARITH
06424D  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
064251  98                    CWDE ; ARITH
064252  01 46 08              ADD    word ptr [bp + 8], ax ; ARITH
064255  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
064258  FF 4E FE              DEC    word ptr [bp - 2] ; ARITH
06425B  0B C0                 OR     ax, ax ; LOGIC
06425D  75 A5                 JNE    0x64204 ; CJUMP
06425F  9A AC 03 1F 18        LCALL  0x181f, 0x3ac ; THUNK -> 0x0262:0x02FE (thunk @file 0x01A99C type B) overlay @file 0x02202E
064264  C9                    LEAVE ; EPILOGUE
064265  CB                    RETF ; RETURN
