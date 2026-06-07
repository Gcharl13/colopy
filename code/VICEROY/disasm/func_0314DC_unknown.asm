; ============================================================================
; func_0314DC_unknown
; Region   : overlay
; Bytes    : file 0x0314DC..0x0315AF  (211 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0314DC  C8 68 00 00           ENTER  0x68, 0 ; PROLOGUE
0314E0  56                    PUSH   si ; STACK_PUSH
0314E1  6A 3C                 PUSH   0x3c ; PUSH_CONST
0314E3  6A 51                 PUSH   0x51 ; PUSH_CONST
0314E5  6A 76                 PUSH   0x76 ; PUSH_CONST
0314E7  68 8F 00              PUSH   0x8f ; PUSH_CONST
0314EA  0E                    PUSH   cs ; STACK_PUSH
0314EB  E8 DE 53              CALL   0x368cc ; CALL_NEAR
0314EE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0314F1  83 3E A2 0F 00        CMP    word ptr [0xfa2], 0 ; CMP
0314F6  75 68                 JNE    0x31560 ; CJUMP
0314F8  6A 45                 PUSH   0x45 ; PUSH_CONST
0314FA  6A 78                 PUSH   0x78 ; PUSH_CONST
0314FC  6A 51                 PUSH   0x51 ; PUSH_CONST
0314FE  68 8F 00              PUSH   0x8f ; PUSH_CONST
031501  FF 36 D0 2D           PUSH   word ptr [0x2dd0] ; PUSH_GLOBAL
031505  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
03150A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03150D  52                    PUSH   dx ; STACK_PUSH
03150E  50                    PUSH   ax ; STACK_PUSH
03150F  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
031514  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031517  C7 46 A4 00 00        MOV    word ptr [bp - 0x5c], 0 ; LOCAL_STORE
03151C  EB 03                 JMP    0x31521 ; JUMP
03151E  FF 46 A4              INC    word ptr [bp - 0x5c] ; ARITH
031521  83 7E A4 06           CMP    word ptr [bp - 0x5c], 6 ; CMP
031525  7C 03                 JL     0x3152a ; CJUMP
031527  E9 86 02              JMP    0x317b0 ; JUMP
03152A  8D 46 9E              LEA    ax, [bp - 0x62] ; ADDR
03152D  50                    PUSH   ax ; STACK_PUSH
03152E  8D 46 A0              LEA    ax, [bp - 0x60] ; ADDR
031531  50                    PUSH   ax ; STACK_PUSH
031532  8D 46 A8              LEA    ax, [bp - 0x58] ; ADDR
031535  50                    PUSH   ax ; STACK_PUSH
031536  8D 4E AA              LEA    cx, [bp - 0x56] ; ADDR
031539  51                    PUSH   cx ; STACK_PUSH
03153A  FF 76 A4              PUSH   word ptr [bp - 0x5c] ; PUSH_GLOBAL
03153D  0E                    PUSH   cs ; STACK_PUSH
03153E  E8 04 53              CALL   0x36845 ; CALL_NEAR
031541  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
031544  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
031548  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
03154C  FF 76 A8              PUSH   word ptr [bp - 0x58] ; PUSH_GLOBAL
03154F  B8 7B 00              MOV    ax, 0x7b ; CONST_LOAD
031552  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
031556  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
031559  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
03155E  EB BE                 JMP    0x3151e ; JUMP
031560  FF 36 1C 9E           PUSH   word ptr [0x9e1c] ; PUSH_GLOBAL
031564  0E                    PUSH   cs ; STACK_PUSH
031565  E8 9B 53              CALL   0x36903 ; CALL_NEAR
031568  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03156B  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
03156E  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
031572  FF 36 E8 2D           PUSH   word ptr [0x2de8] ; PUSH_GLOBAL
031576  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
031579  50                    PUSH   ax ; STACK_PUSH
03157A  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03157F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031582  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
031585  50                    PUSH   ax ; STACK_PUSH
031586  9A BE 01 1F 18        LCALL  0x181f, 0x1be ; THUNK -> 0x004B:0x0042 (thunk @file 0x01A7AE type B) overlay @file 0x0603EA
03158B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03158E  6B 5E 9A 1C           IMUL   bx, word ptr [bp - 0x66], 0x1c ; ARITH
031592  80 BF 46 31 0E        CMP    byte ptr [bx + 0x3146], 0xe ; CMP
031597  74 30                 JE     0x315c9 ; CJUMP
031599  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
03159C  50                    PUSH   ax ; STACK_PUSH
03159D  8B F3                 MOV    si, bx ; MOV
03159F  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
0315A4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0315A7  8A 9C 46 31           MOV    bl, byte ptr [si + 0x3146] ; MOV
0315AB  2A FF                 SUB    bh, bh ; ARITH
0315AD  8B C3                 MOV    ax, bx ; MOV
