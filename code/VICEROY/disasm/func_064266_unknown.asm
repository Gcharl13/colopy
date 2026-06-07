; ============================================================================
; func_064266_unknown
; Region   : overlay
; Bytes    : file 0x064266..0x0642A3  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064266  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
06426A  6A 30                 PUSH   0x30 ; PUSH_CONST
06426C  6A 01                 PUSH   1 ; STACK_PUSH
06426E  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064273  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
064276  40                    INC    ax ; ARITH
064277  40                    INC    ax ; ARITH
064278  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
06427B  E9 D9 00              JMP    0x64357 ; JUMP
06427E  A0 20 2D              MOV    al, byte ptr [0x2d20] ; GLOBAL_LOAD
064281  98                    CWDE ; ARITH
064282  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
064285  7C 03                 JL     0x6428a ; CJUMP
064287  E9 DA 00              JMP    0x64364 ; JUMP
06428A  A0 1E 2D              MOV    al, byte ptr [0x2d1e] ; GLOBAL_LOAD
06428D  98                    CWDE ; ARITH
06428E  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
064291  7F 03                 JG     0x64296 ; CJUMP
064293  E9 CE 00              JMP    0x64364 ; JUMP
064296  A0 21 2D              MOV    al, byte ptr [0x2d21] ; GLOBAL_LOAD
064299  98                    CWDE ; ARITH
06429A  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
06429D  7C 03                 JL     0x642a2 ; CJUMP
06429F  E9 C2 00              JMP    0x64364 ; JUMP
0642A2  A0                    DB     0xA0 ; DATA_BYTE
