; ============================================================================
; func_0734F8_unknown
; Region   : overlay
; Bytes    : file 0x0734F8..0x0735BA  (194 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0734F8  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
0734FC  57                    PUSH   di ; STACK_PUSH
0734FD  56                    PUSH   si ; STACK_PUSH
0734FE  BF 01 00              MOV    di, 1 ; MOV
073501  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
073506  74 03                 JE     0x7350b ; CJUMP
073508  BF 02 00              MOV    di, 2 ; MOV
07350B  68 76 21              PUSH   0x2176 ; PUSH_CONST
07350E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
073511  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
073516  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
073519  8B F0                 MOV    si, ax ; MOV
07351B  0B F6                 OR     si, si ; LOGIC
07351D  75 03                 JNE    0x73522 ; CJUMP
07351F  E9 6C 05              JMP    0x73a8e ; JUMP
073522  8D 1E 7A 21           LEA    bx, [0x217a] ; ADDR
073526  8B C6                 MOV    ax, si ; MOV
073528  9A E4 0D 1F 1A        LCALL  0x1a1f, 0xde4 ; THUNK -> 0x0B2C:0x0040 (thunk @file 0x01D3D4 type B) overlay @file 0x028826
07352D  A1 1A 08              MOV    ax, word ptr [0x81a] ; GLOBAL_LOAD
073530  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
073533  56                    PUSH   si ; STACK_PUSH
073534  6A 01                 PUSH   1 ; STACK_PUSH
073536  6A 02                 PUSH   2 ; STACK_PUSH
073538  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
07353B  50                    PUSH   ax ; STACK_PUSH
07353C  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
073541  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073544  0B C0                 OR     ax, ax ; LOGIC
073546  75 03                 JNE    0x7354b ; CJUMP
073548  E9 43 05              JMP    0x73a8e ; JUMP
07354B  56                    PUSH   si ; STACK_PUSH
07354C  6A 01                 PUSH   1 ; STACK_PUSH
07354E  6A 04                 PUSH   4 ; STACK_PUSH
073550  68 3A 85              PUSH   0x853a ; PUSH_CONST
073553  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
073558  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07355B  0B C0                 OR     ax, ax ; LOGIC
07355D  75 03                 JNE    0x73562 ; CJUMP
07355F  E9 2C 05              JMP    0x73a8e ; JUMP
073562  56                    PUSH   si ; STACK_PUSH
073563  6A 01                 PUSH   1 ; STACK_PUSH
073565  68 8E 00              PUSH   0x8e ; PUSH_CONST
073568  68 80 53              PUSH   0x5380 ; PUSH_CONST
07356B  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
073570  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
073573  0B C0                 OR     ax, ax ; LOGIC
073575  75 03                 JNE    0x7357a ; CJUMP
073577  E9 14 05              JMP    0x73a8e ; JUMP
07357A  56                    PUSH   si ; STACK_PUSH
07357B  6A 01                 PUSH   1 ; STACK_PUSH
07357D  68 D0 00              PUSH   0xd0 ; PUSH_CONST
073580  68 0E 54              PUSH   0x540e ; PUSH_CONST
073583  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
073588  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07358B  0B C0                 OR     ax, ax ; LOGIC
07358D  75 03                 JNE    0x73592 ; CJUMP
07358F  E9 FC 04              JMP    0x73a8e ; JUMP
073592  56                    PUSH   si ; STACK_PUSH
073593  6A 01                 PUSH   1 ; STACK_PUSH
073595  6A 18                 PUSH   0x18 ; PUSH_CONST
073597  68 8E 94              PUSH   0x948e ; PUSH_CONST
07359A  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
07359F  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0735A2  0B C0                 OR     ax, ax ; LOGIC
0735A4  75 03                 JNE    0x735a9 ; CJUMP
0735A6  E9 E5 04              JMP    0x73a8e ; JUMP
0735A9  83 3E 9E 53 00        CMP    word ptr [0x539e], 0 ; CMP
0735AE  74 1C                 JE     0x735cc ; CJUMP
0735B0  56                    PUSH   si ; STACK_PUSH
0735B1  6A 01                 PUSH   1 ; STACK_PUSH
0735B3  69 06 9E 53 CA 00     IMUL   ax, word ptr [0x539e], 0xca ; ARITH
0735B9  50                    PUSH   ax ; STACK_PUSH
