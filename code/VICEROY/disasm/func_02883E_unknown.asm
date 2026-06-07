; ============================================================================
; func_02883E_unknown
; Region   : overlay
; Bytes    : file 0x02883E..0x0288C8  (138 bytes)
; Purpose  : Town hall / colony-services menu  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; Tagged: "KEEPSTOCKADE", "MORETHANTHREE", "FULL"  (auto-named via string xrefs)
; ============================================================================

02883E  C8 6A 00 00           ENTER  0x6a, 0 ; PROLOGUE
028842  57                    PUSH   di ; STACK_PUSH
028843  56                    PUSH   si ; STACK_PUSH
028844  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1 ; LOCAL_STORE
028849  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02884C  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
028851  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028854  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
028857  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02885A  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
02885F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
028862  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
028865  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
028868  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
02886B  3D 17 00              CMP    ax, 0x17 ; CMP
02886E  75 05                 JNE    0x28875 ; CJUMP
028870  C7 46 9A 15 00        MOV    word ptr [bp - 0x66], 0x15 ; LOCAL_STORE
028875  50                    PUSH   ax ; STACK_PUSH
028876  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
028879  0E                    PUSH   cs ; STACK_PUSH
02887A  E8 83 41              CALL   0x2ca00 ; CALL_NEAR
02887D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
028880  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
028883  E9 5C 02              JMP    0x28ae2 ; JUMP
028886  6A 05                 PUSH   5 ; STACK_PUSH
028888  68 BA 0B              PUSH   0xbba                        ; STRING: "KEEPSTOCKADE"
02888B  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
028890  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
028893  E9 86 02              JMP    0x28b1c ; JUMP
028896  6A 05                 PUSH   5 ; STACK_PUSH
028898  68 C7 0B              PUSH   0xbc7                        ; STRING: "MORETHANTHREE"
02889B  EB EE                 JMP    0x2888b ; JUMP
02889D  90                    NOP ; NOP
02889E  8D 1E D5 0B           LEA    bx, [0xbd5] ; ADDR
0288A2  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
0288A7  E9 72 02              JMP    0x28b1c ; JUMP
0288AA  8D 1E DF 0B           LEA    bx, [0xbdf] ; ADDR
0288AE  EB F2                 JMP    0x288a2 ; JUMP
0288B0  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
0288B3  40                    INC    ax ; ARITH
0288B4  40                    INC    ax ; ARITH
0288B5  1E                    PUSH   ds ; STACK_PUSH
0288B6  50                    PUSH   ax ; STACK_PUSH
0288B7  6A 00                 PUSH   0 ; STACK_PUSH
0288B9  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
0288BE  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0288C1  6A 05                 PUSH   5 ; STACK_PUSH
0288C3  68 E9 0B              PUSH   0xbe9                        ; STRING: "FULL"
0288C6  EB C3                 JMP    0x2888b ; JUMP
