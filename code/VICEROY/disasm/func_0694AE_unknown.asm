; ============================================================================
; func_0694AE_unknown
; Region   : overlay
; Bytes    : file 0x0694AE..0x0696C5  (535 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "CARGO"  (auto-named via string xrefs)
; ============================================================================

0694AE  C8 66 00 00           ENTER  0x66, 0 ; PROLOGUE
0694B2  56                    PUSH   si ; STACK_PUSH
0694B3  0E                    PUSH   cs ; STACK_PUSH
0694B4  E8 DB 21              CALL   0x6b692 ; CALL_NEAR
0694B7  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
0694BA  2A E4                 SUB    ah, ah ; ARITH
0694BC  50                    PUSH   ax ; STACK_PUSH
0694BD  6A 05                 PUSH   5 ; STACK_PUSH
0694BF  68 40 01              PUSH   0x140 ; PUSH_CONST
0694C2  6A 00                 PUSH   0 ; STACK_PUSH
0694C4  FF 36 92 2E           PUSH   word ptr [0x2e92] ; PUSH_GLOBAL
0694C8  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
0694CD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0694D0  52                    PUSH   dx ; STACK_PUSH
0694D1  50                    PUSH   ax ; STACK_PUSH
0694D2  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0694D7  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0694DA  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
0694DE  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
0694E1  2A E4                 SUB    ah, ah ; ARITH
0694E3  05 07 00              ADD    ax, 7 ; ARITH
0694E6  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
0694E9  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
0694ED  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0694F0  50                    PUSH   ax ; STACK_PUSH
0694F1  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
0694F6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0694F9  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0694FC  D1 E3                 SHL    bx, 1 ; LOGIC
0694FE  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
069502  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069505  50                    PUSH   ax ; STACK_PUSH
069506  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06950B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06950E  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069511  50                    PUSH   ax ; STACK_PUSH
069512  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
069517  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06951A  6A 00                 PUSH   0 ; STACK_PUSH
06951C  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06951F  50                    PUSH   ax ; STACK_PUSH
069520  0E                    PUSH   cs ; STACK_PUSH
069521  E8 5A 21              CALL   0x6b67e ; CALL_NEAR
069524  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069527  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06952A  50                    PUSH   ax ; STACK_PUSH
06952B  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
069530  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
069533  A0 31 08              MOV    al, byte ptr [0x831] ; GLOBAL_LOAD
069536  2A E4                 SUB    ah, ah ; ARITH
069538  50                    PUSH   ax ; STACK_PUSH
069539  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
06953C  68 40 01              PUSH   0x140 ; PUSH_CONST
06953F  6A 00                 PUSH   0 ; STACK_PUSH
069541  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069544  16                    PUSH   ss ; STACK_PUSH
069545  50                    PUSH   ax ; STACK_PUSH
069546  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
06954B  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
06954E  C7 46 AA 0A 00        MOV    word ptr [bp - 0x56], 0xa ; LOCAL_STORE
069553  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
069557  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06955A  2A E4                 SUB    ah, ah ; ARITH
06955C  05 0E 00              ADD    ax, 0xe ; ARITH
06955F  01 46 A8              ADD    word ptr [bp - 0x58], ax ; ARITH
069562  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
069567  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
06956B  75 15                 JNE    0x69582 ; CJUMP
06956D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069570  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
069573  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
069576  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
069579  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
06957C  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
06957F  E9 B1 00              JMP    0x69633 ; JUMP
069582  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
069586  74 06                 JE     0x6958e ; CJUMP
069588  83 7E 06 0D           CMP    word ptr [bp + 6], 0xd ; CMP
06958C  75 16                 JNE    0x695a4 ; CJUMP
06958E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069591  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
069594  D1 E6                 SHL    si, 1 ; LOGIC
069596  89 42 9A              MOV    word ptr [bp + si - 0x66], ax ; LOCAL_STORE
069599  C7 42 A0 FF FF        MOV    word ptr [bp + si - 0x60], 0xffff ; LOCAL_STORE
06959E  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
0695A1  E9 94 00              JMP    0x69638 ; JUMP
0695A4  83 7E 06 07           CMP    word ptr [bp + 6], 7 ; CMP
0695A8  75 10                 JNE    0x695ba ; CJUMP
0695AA  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0695AD  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
0695B0  D1 E6                 SHL    si, 1 ; LOGIC
0695B2  89 42 9A              MOV    word ptr [bp + si - 0x66], ax ; LOCAL_STORE
0695B5  89 42 A0              MOV    word ptr [bp + si - 0x60], ax ; LOCAL_STORE
0695B8  EB E4                 JMP    0x6959e ; JUMP
0695BA  83 7E 06 06           CMP    word ptr [bp + 6], 6 ; CMP
0695BE  74 0C                 JE     0x695cc ; CJUMP
0695C0  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe ; CMP
0695C4  74 06                 JE     0x695cc ; CJUMP
0695C6  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf ; CMP
0695CA  75 22                 JNE    0x695ee ; CJUMP
0695CC  B8 06 00              MOV    ax, 6 ; MOV
0695CF  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
0695D2  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
0695D5  B8 0E 00              MOV    ax, 0xe ; CONST_LOAD
0695D8  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
0695DB  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
0695DE  B8 0F 00              MOV    ax, 0xf ; CONST_LOAD
0695E1  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
0695E4  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
0695E7  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3 ; LOCAL_STORE
0695EC  EB 4A                 JMP    0x69638 ; JUMP
0695EE  83 7E 06 05           CMP    word ptr [bp + 6], 5 ; CMP
0695F2  75 16                 JNE    0x6960a ; CJUMP
0695F4  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0695F7  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
0695FA  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
0695FD  C7 46 9C 10 00        MOV    word ptr [bp - 0x64], 0x10 ; LOCAL_STORE
069602  C7 46 A2 0D 00        MOV    word ptr [bp - 0x5e], 0xd ; LOCAL_STORE
069607  EB 2A                 JMP    0x69633 ; JUMP
069609  90                    NOP ; NOP
06960A  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
06960E  7D 0E                 JGE    0x6961e ; CJUMP
069610  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069613  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
069616  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
069619  05 08 00              ADD    ax, 8 ; ARITH
06961C  EB 0F                 JMP    0x6962d ; JUMP
06961E  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
069621  2D 08 00              SUB    ax, 8 ; ARITH
069624  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
069627  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
06962A  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06962D  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
069630  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
069633  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
069638  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0 ; LOCAL_STORE
06963D  EB 1D                 JMP    0x6965c ; JUMP
06963F  90                    NOP ; NOP
069640  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
069643  8B 76 A6              MOV    si, word ptr [bp - 0x5a] ; LOCAL_LOAD
069646  D1 E6                 SHL    si, 1 ; LOGIC
069648  FF 72 A0              PUSH   word ptr [bp + si - 0x60] ; PUSH_GLOBAL
06964B  FF 72 9A              PUSH   word ptr [bp + si - 0x66] ; PUSH_GLOBAL
06964E  0E                    PUSH   cs ; STACK_PUSH
06964F  E8 4F 20              CALL   0x6b6a1 ; CALL_NEAR
069652  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
069655  83 46 A8 14           ADD    word ptr [bp - 0x58], 0x14 ; ARITH
069659  FF 46 A6              INC    word ptr [bp - 0x5a] ; ARITH
06965C  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
06965F  39 46 A6              CMP    word ptr [bp - 0x5a], ax ; CMP
069662  7C DC                 JL     0x69640 ; CJUMP
069664  68 CD 1E              PUSH   0x1ecd                       ; STRING: "CARGO"
069667  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
06966A  50                    PUSH   ax ; STACK_PUSH
06966B  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
069670  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
069673  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
069676  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
069679  16                    PUSH   ss ; STACK_PUSH
06967A  50                    PUSH   ax ; STACK_PUSH
06967B  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
069680  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
069683  83 46 A8 0A           ADD    word ptr [bp - 0x58], 0xa ; ARITH
069687  8B 46 A8              MOV    ax, word ptr [bp - 0x58] ; LOCAL_LOAD
06968A  A3 5A 1F              MOV    word ptr [0x1f5a], ax ; GLOBAL_LOAD
06968D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
069690  D1 E3                 SHL    bx, 1 ; LOGIC
069692  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
069696  6A 00                 PUSH   0 ; STACK_PUSH
069698  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
06969D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0696A0  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0696A3  50                    PUSH   ax ; STACK_PUSH
0696A4  0E                    PUSH   cs ; STACK_PUSH
0696A5  E8 E5 1F              CALL   0x6b68d ; CALL_NEAR
0696A8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0696AB  6A 00                 PUSH   0 ; STACK_PUSH
0696AD  68 40 01              PUSH   0x140 ; PUSH_CONST
0696B0  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0696B3  2B C0                 SUB    ax, ax ; ARITH
0696B5  99                    CDQ ; ARITH
0696B6  2B DB                 SUB    bx, bx ; ARITH
0696B8  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0696BD  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
0696C2  5E                    POP    si ; STACK_POP
0696C3  C9                    LEAVE ; EPILOGUE
0696C4  CB                    RETF ; RETURN
