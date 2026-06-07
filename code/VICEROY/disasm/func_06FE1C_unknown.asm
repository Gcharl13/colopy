; ============================================================================
; func_06FE1C_unknown
; Region   : overlay
; Bytes    : file 0x06FE1C..0x06FEA9  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FE1C  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
06FE20  56                    PUSH   si ; STACK_PUSH
06FE21  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
06FE24  50                    PUSH   ax ; STACK_PUSH
06FE25  8D 4E AC              LEA    cx, [bp - 0x54] ; ADDR
06FE28  51                    PUSH   cx ; STACK_PUSH
06FE29  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06FE2C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06FE2F  0E                    PUSH   cs ; STACK_PUSH
06FE30  E8 0E 0E              CALL   0x70c41 ; CALL_NEAR
06FE33  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
06FE36  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
06FE3A  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
06FE3E  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
06FE42  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
06FE46  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06FE4A  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06FE4E  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06FE52  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06FE56  6A 30                 PUSH   0x30 ; PUSH_CONST
06FE58  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
06FE5B  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
06FE5E  BB 48 00              MOV    bx, 0x48 ; CONST_LOAD
06FE61  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
06FE66  C6 46 A8 0A           MOV    byte ptr [bp - 0x58], 0xa ; LOCAL_STORE
06FE6A  A1 0A A6              MOV    ax, word ptr [0xa60a] ; GLOBAL_LOAD
06FE6D  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
06FE70  75 04                 JNE    0x6fe76 ; CJUMP
06FE72  C6 46 A8 0E           MOV    byte ptr [bp - 0x58], 0xe ; LOCAL_STORE
06FE76  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
06FE79  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
06FE7C  D1 E3                 SHL    bx, 1 ; LOGIC
06FE7E  39 87 7E 1E           CMP    word ptr [bx + 0x1e7e], ax ; CMP
06FE82  74 03                 JE     0x6fe87 ; CJUMP
06FE84  E9 F6 00              JMP    0x6ff7d ; JUMP
06FE87  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06FE8B  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06FE8F  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06FE93  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06FE97  8B 4E AA              MOV    cx, word ptr [bp - 0x56] ; LOCAL_LOAD
06FE9A  83 C1 2F              ADD    cx, 0x2f ; ARITH
06FE9D  51                    PUSH   cx ; STACK_PUSH
06FE9E  8A 4E A8              MOV    cl, byte ptr [bp - 0x58] ; LOCAL_LOAD
06FEA1  51                    PUSH   cx ; STACK_PUSH
06FEA2  8B D3                 MOV    dx, bx ; MOV
06FEA4  8B 5E AC              MOV    bx, word ptr [bp - 0x54] ; LOCAL_LOAD
06FEA7  8B C3                 MOV    ax, bx ; MOV
