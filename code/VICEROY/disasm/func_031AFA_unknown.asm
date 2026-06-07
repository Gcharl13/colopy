; ============================================================================
; func_031AFA_unknown
; Region   : overlay
; Bytes    : file 0x031AFA..0x031BB0  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031AFA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
031AFE  6A 3B                 PUSH   0x3b ; PUSH_CONST
031B00  6A 60                 PUSH   0x60 ; PUSH_CONST
031B02  6A 78                 PUSH   0x78 ; PUSH_CONST
031B04  68 E0 00              PUSH   0xe0 ; PUSH_CONST
031B07  0E                    PUSH   cs ; STACK_PUSH
031B08  E8 C1 4D              CALL   0x368cc ; CALL_NEAR
031B0B  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031B0E  C7 46 FC E9 00        MOV    word ptr [bp - 4], 0xe9 ; LOCAL_STORE
031B13  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
031B18  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
031B1B  2D 14 00              SUB    ax, 0x14 ; ARITH
031B1E  8B D0                 MOV    dx, ax ; MOV
031B20  9A E0 07 1F 18        LCALL  0x181f, 0x7e0 ; THUNK -> 0x0427:0x005C (thunk @file 0x01ADD0 type B) overlay @file 0x030D70
031B25  EB 67                 JMP    0x31b8e ; JUMP
031B27  90                    NOP ; NOP
031B28  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
031B2B  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
031B30  72 07                 JB     0x31b39 ; CJUMP
031B32  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
031B37  76 4D                 JBE    0x31b86 ; CJUMP
031B39  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff ; LOCAL_STORE
031B3E  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
031B41  39 06 2C 9E           CMP    word ptr [0x9e2c], ax ; CMP
031B45  75 2B                 JNE    0x31b72 ; CJUMP
031B47  C7 46 F8 0A 00        MOV    word ptr [bp - 8], 0xa ; LOCAL_STORE
031B4C  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
031B51  74 0C                 JE     0x31b5f ; CJUMP
031B53  83 3E 3A 9E 04        CMP    word ptr [0x9e3a], 4 ; CMP
031B58  75 05                 JNE    0x31b5f ; CJUMP
031B5A  C7 46 F8 0F 00        MOV    word ptr [bp - 8], 0xf ; LOCAL_STORE
031B5F  83 3E 9A 0F 02        CMP    word ptr [0xf9a], 2 ; CMP
031B64  75 0C                 JNE    0x31b72 ; CJUMP
031B66  83 3E 40 9E 00        CMP    word ptr [0x9e40], 0 ; CMP
031B6B  74 05                 JE     0x31b72 ; CJUMP
031B6D  C7 46 F8 0F 00        MOV    word ptr [bp - 8], 0xf ; LOCAL_STORE
031B72  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
031B75  8D 46 FE              LEA    ax, [bp - 2] ; ADDR
031B78  50                    PUSH   ax ; STACK_PUSH
031B79  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
031B7C  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
031B7F  0E                    PUSH   cs ; STACK_PUSH
031B80  E8 71 4D              CALL   0x368f4 ; CALL_NEAR
031B83  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031B86  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
031B89  9A E4 02 1F 18        LCALL  0x181f, 0x2e4 ; THUNK -> 0x0427:0x004A (thunk @file 0x01A8D4 type B) overlay @file 0x030D5E
031B8E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
031B91  0B C0                 OR     ax, ax ; LOGIC
031B93  7D 93                 JGE    0x31b28 ; CJUMP
031B95  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
031B99  74 13                 JE     0x31bae ; CJUMP
031B9B  6A 78                 PUSH   0x78 ; PUSH_CONST
031B9D  6A 60                 PUSH   0x60 ; PUSH_CONST
031B9F  6A 3B                 PUSH   0x3b ; PUSH_CONST
031BA1  B8 E0 00              MOV    ax, 0xe0 ; CONST_LOAD
031BA4  BA 78 00              MOV    dx, 0x78 ; CONST_LOAD
031BA7  8B D8                 MOV    bx, ax ; MOV
031BA9  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
031BAE  C9                    LEAVE ; EPILOGUE
031BAF  CB                    RETF ; RETURN
