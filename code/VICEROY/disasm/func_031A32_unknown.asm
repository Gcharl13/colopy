; ============================================================================
; func_031A32_unknown
; Region   : overlay
; Bytes    : file 0x031A32..0x031AF9  (199 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031A32  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
031A36  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
031A39  50                    PUSH   ax ; STACK_PUSH
031A3A  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
031A3D  50                    PUSH   ax ; STACK_PUSH
031A3E  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
031A41  50                    PUSH   ax ; STACK_PUSH
031A42  8D 4E FE              LEA    cx, [bp - 2] ; ADDR
031A45  51                    PUSH   cx ; STACK_PUSH
031A46  8D 56 FC              LEA    dx, [bp - 4] ; ADDR
031A49  52                    PUSH   dx ; STACK_PUSH
031A4A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
031A4D  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
031A50  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
031A52  0E                    PUSH   cs ; STACK_PUSH
031A53  E8 35 4E              CALL   0x3688b ; CALL_NEAR
031A56  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
031A59  83 7E FC 02           CMP    word ptr [bp - 4], 2 ; CMP
031A5D  7D 5A                 JGE    0x31ab9 ; CJUMP
031A5F  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
031A62  6A 10                 PUSH   0x10 ; PUSH_CONST
031A64  6A 64                 PUSH   0x64 ; PUSH_CONST
031A66  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
031A69  2B D2                 SUB    dx, dx ; ARITH
031A6B  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
031A6E  9A BC 02 1F 18        LCALL  0x181f, 0x2bc ; THUNK -> 0x012B:0x01BA (thunk @file 0x01A8AC type B) overlay @file 0x023724
031A73  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
031A77  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
031A7C  72 3B                 JB     0x31ab9 ; CJUMP
031A7E  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
031A83  77 34                 JA     0x31ab9 ; CJUMP
031A85  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
031A89  75 2E                 JNE    0x31ab9 ; CJUMP
031A8B  80 BF 50 31 00        CMP    byte ptr [bx + 0x3150], 0 ; CMP
031A90  74 27                 JE     0x31ab9 ; CJUMP
031A92  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
031A96  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
031A9A  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
031A9D  6A 00                 PUSH   0 ; STACK_PUSH
031A9F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
031AA2  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
031AA7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031AAA  05 17 00              ADD    ax, 0x17 ; ARITH
031AAD  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
031AB1  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
031AB4  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
031AB9  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
031ABD  7C 33                 JL     0x31af2 ; CJUMP
031ABF  83 7E FC 02           CMP    word ptr [bp - 4], 2 ; CMP
031AC3  7D 2D                 JGE    0x31af2 ; CJUMP
031AC5  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
031AC9  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
031ACD  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
031AD1  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
031AD5  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
031AD8  03 46 FA              ADD    ax, word ptr [bp - 6] ; ARITH
031ADB  50                    PUSH   ax ; STACK_PUSH
031ADC  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
031ADF  50                    PUSH   ax ; STACK_PUSH
031AE0  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
031AE3  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
031AE6  03 D8                 ADD    bx, ax ; ARITH
031AE8  48                    DEC    ax ; ARITH
031AE9  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
031AEC  4A                    DEC    dx ; ARITH
031AED  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
031AF2  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
031AF5  FF 07                 INC    word ptr [bx] ; ARITH
031AF7  C9                    LEAVE ; EPILOGUE
031AF8  CB                    RETF ; RETURN
