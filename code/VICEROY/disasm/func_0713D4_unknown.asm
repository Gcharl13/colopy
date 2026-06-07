; ============================================================================
; func_0713D4_unknown
; Region   : overlay
; Bytes    : file 0x0713D4..0x07147C  (168 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0713D4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0713D8  50                    PUSH   ax ; STACK_PUSH
0713D9  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0713DE  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0713E3  83 3E 8C 01 00        CMP    word ptr [0x18c], 0 ; CMP
0713E8  75 5F                 JNE    0x71449 ; CJUMP
0713EA  1E                    PUSH   ds ; STACK_PUSH
0713EB  68 54 85              PUSH   0x8554 ; PUSH_CONST
0713EE  1E                    PUSH   ds ; STACK_PUSH
0713EF  68 54 85              PUSH   0x8554 ; PUSH_CONST
0713F2  1E                    PUSH   ds ; STACK_PUSH
0713F3  68 54 01              PUSH   0x154 ; PUSH_CONST
0713F6  9A AA 0C 1F 1A        LCALL  0x1a1f, 0xcaa ; THUNK -> 0x0B32:0x005C (thunk @file 0x01D29A type B) overlay @file 0x040656
0713FB  1E                    PUSH   ds ; STACK_PUSH
0713FC  68 54 85              PUSH   0x8554 ; PUSH_CONST
0713FF  8D 1E 94 20           LEA    bx, [0x2094] ; ADDR
071403  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
071408  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
07140B  C7 06 3A 85 78 00     MOV    word ptr [0x853a], 0x78 ; GLOBAL_LOAD
071411  C7 06 3C 85 4B 00     MOV    word ptr [0x853c], 0x4b ; GLOBAL_LOAD
071417  C7 06 A4 85 28 23     MOV    word ptr [0x85a4], 0x2328 ; GLOBAL_LOAD
07141D  C7 06 A6 85 00 00     MOV    word ptr [0x85a6], 0 ; GLOBAL_LOAD
071423  0B C0                 OR     ax, ax ; LOGIC
071425  74 22                 JE     0x71449 ; CJUMP
071427  50                    PUSH   ax ; STACK_PUSH
071428  6A 01                 PUSH   1 ; STACK_PUSH
07142A  6A 04                 PUSH   4 ; STACK_PUSH
07142C  68 3A 85              PUSH   0x853a ; PUSH_CONST
07142F  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
071434  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
071437  0B C0                 OR     ax, ax ; LOGIC
071439  74 0E                 JE     0x71449 ; CJUMP
07143B  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
07143E  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
071442  A3 A4 85              MOV    word ptr [0x85a4], ax ; GLOBAL_LOAD
071445  89 16 A6 85           MOV    word ptr [0x85a6], dx ; GLOBAL_LOAD
071449  0E                    PUSH   cs ; STACK_PUSH
07144A  E8 2F 00              CALL   0x7147c ; CALL_NEAR
07144D  0B C0                 OR     ax, ax ; LOGIC
07144F  75 18                 JNE    0x71469 ; CJUMP
071451  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
071454  0E                    PUSH   cs ; STACK_PUSH
071455  E8 29 00              CALL   0x71481 ; CALL_NEAR
071458  0B C0                 OR     ax, ax ; LOGIC
07145A  74 08                 JE     0x71464 ; CJUMP
07145C  C7 06 58 01 13 00     MOV    word ptr [0x158], 0x13 ; GLOBAL_LOAD
071462  EB 05                 JMP    0x71469 ; JUMP
071464  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
071469  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
07146D  74 08                 JE     0x71477 ; CJUMP
07146F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
071472  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
071477  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
07147A  C9                    LEAVE ; EPILOGUE
07147B  CB                    RETF ; RETURN
