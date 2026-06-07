; ============================================================================
; func_0317CC_unknown
; Region   : overlay
; Bytes    : file 0x0317CC..0x0318D1  (261 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0317CC  C8 56 00 00           ENTER  0x56, 0 ; PROLOGUE
0317D0  6A 33                 PUSH   0x33 ; PUSH_CONST
0317D2  6A 46                 PUSH   0x46 ; PUSH_CONST
0317D4  6A 76                 PUSH   0x76 ; PUSH_CONST
0317D6  6A 48                 PUSH   0x48 ; PUSH_CONST
0317D8  0E                    PUSH   cs ; STACK_PUSH
0317D9  E8 F0 50              CALL   0x368cc ; CALL_NEAR
0317DC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0317DF  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
0317E3  FF 36 CE 2D           PUSH   word ptr [0x2dce] ; PUSH_GLOBAL
0317E7  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0317EA  50                    PUSH   ax ; STACK_PUSH
0317EB  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0317F0  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0317F3  6A 45                 PUSH   0x45 ; PUSH_CONST
0317F5  6A 78                 PUSH   0x78 ; PUSH_CONST
0317F7  6A 46                 PUSH   0x46 ; PUSH_CONST
0317F9  6A 48                 PUSH   0x48 ; PUSH_CONST
0317FB  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
0317FE  16                    PUSH   ss ; STACK_PUSH
0317FF  50                    PUSH   ax ; STACK_PUSH
031800  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
031805  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031808  C6 46 AE 00           MOV    byte ptr [bp - 0x52], 0 ; LOCAL_STORE
03180C  6B 06 12 9E 34        IMUL   ax, word ptr [0x9e12], 0x34 ; ARITH
031811  05 26 54              ADD    ax, 0x5426 ; ARITH
031814  50                    PUSH   ax ; STACK_PUSH
031815  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
031818  50                    PUSH   ax ; STACK_PUSH
031819  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
03181E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031821  6A 45                 PUSH   0x45 ; PUSH_CONST
031823  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
031827  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
03182A  2A E4                 SUB    ah, ah ; ARITH
03182C  05 79 00              ADD    ax, 0x79 ; ARITH
03182F  50                    PUSH   ax ; STACK_PUSH
031830  6A 46                 PUSH   0x46 ; PUSH_CONST
031832  6A 48                 PUSH   0x48 ; PUSH_CONST
031834  8D 46 AE              LEA    ax, [bp - 0x52] ; ADDR
031837  16                    PUSH   ss ; STACK_PUSH
031838  50                    PUSH   ax ; STACK_PUSH
031839  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
03183E  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031841  C7 46 AC 49 00        MOV    word ptr [bp - 0x54], 0x49 ; LOCAL_STORE
031846  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03184B  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
03184E  2D 1C 00              SUB    ax, 0x1c ; ARITH
031851  8B D0                 MOV    dx, ax ; MOV
031853  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
031858  EB 1F                 JMP    0x31879 ; JUMP
03185A  6A FF                 PUSH   -1 ; STACK_PUSH
03185C  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
03185F  50                    PUSH   ax ; STACK_PUSH
031860  6A 01                 PUSH   1 ; STACK_PUSH
031862  6A 0D                 PUSH   0xd ; PUSH_CONST
031864  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
031867  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
03186A  0E                    PUSH   cs ; STACK_PUSH
03186B  E8 BD 50              CALL   0x3692b ; CALL_NEAR
03186E  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
031871  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
031874  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
031879  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
03187C  0B C0                 OR     ax, ax ; LOGIC
03187E  7D DA                 JGE    0x3185a ; CJUMP
031880  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
031883  2D 18 00              SUB    ax, 0x18 ; ARITH
031886  8B D0                 MOV    dx, ax ; MOV
031888  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
03188D  EB 20                 JMP    0x318af ; JUMP
03188F  90                    NOP ; NOP
031890  6A FF                 PUSH   -1 ; STACK_PUSH
031892  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
031895  50                    PUSH   ax ; STACK_PUSH
031896  6A 01                 PUSH   1 ; STACK_PUSH
031898  6A 0D                 PUSH   0xd ; PUSH_CONST
03189A  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
03189D  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
0318A0  0E                    PUSH   cs ; STACK_PUSH
0318A1  E8 87 50              CALL   0x3692b ; CALL_NEAR
0318A4  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0318A7  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
0318AA  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
0318AF  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
0318B2  0B C0                 OR     ax, ax ; LOGIC
0318B4  7D DA                 JGE    0x31890 ; CJUMP
0318B6  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0318BA  74 13                 JE     0x318cf ; CJUMP
0318BC  6A 76                 PUSH   0x76 ; PUSH_CONST
0318BE  6A 46                 PUSH   0x46 ; PUSH_CONST
0318C0  6A 33                 PUSH   0x33 ; PUSH_CONST
0318C2  B8 48 00              MOV    ax, 0x48 ; CONST_LOAD
0318C5  BA 76 00              MOV    dx, 0x76 ; CONST_LOAD
0318C8  8B D8                 MOV    bx, ax ; MOV
0318CA  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0318CF  C9                    LEAVE ; EPILOGUE
0318D0  CB                    RETF ; RETURN
