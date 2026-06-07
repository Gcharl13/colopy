; ============================================================================
; func_06D9CC_unknown
; Region   : overlay
; Bytes    : file 0x06D9CC..0x06DA82  (182 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06D9CC  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
06D9D0  50                    PUSH   ax ; STACK_PUSH
06D9D1  57                    PUSH   di ; STACK_PUSH
06D9D2  56                    PUSH   si ; STACK_PUSH
06D9D3  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06D9D6  26 8B 4F 24           MOV    cx, word ptr es:[bx + 0x24] ; MOV
06D9DA  26 03 4F 48           ADD    cx, word ptr es:[bx + 0x48] ; ARITH
06D9DE  26 03 4F 22           ADD    cx, word ptr es:[bx + 0x22] ; ARITH
06D9E2  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
06D9E5  26 8B 57 26           MOV    dx, word ptr es:[bx + 0x26] ; MOV
06D9E9  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
06D9EC  26 8B 77 54           MOV    si, word ptr es:[bx + 0x54] ; MOV
06D9F0  26 8B 7F 56           MOV    di, word ptr es:[bx + 0x56] ; MOV
06D9F4  89 76 F0              MOV    word ptr [bp - 0x10], si ; LOCAL_STORE
06D9F7  89 7E F2              MOV    word ptr [bp - 0xe], di ; LOCAL_STORE
06D9FA  0B C0                 OR     ax, ax ; LOGIC
06D9FC  74 68                 JE     0x6da66 ; CJUMP
06D9FE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
06DA02  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
06DA06  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06DA0A  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06DA0E  26 FF B7 82 00        PUSH   word ptr es:[bx + 0x82] ; PUSH_GLOBAL
06DA13  26 FF B7 80 00        PUSH   word ptr es:[bx + 0x80] ; PUSH_GLOBAL
06DA18  E8 4B F3              CALL   0x6cd66 ; CALL_NEAR
06DA1B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06DA1E  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06DA21  26 03 47 46           ADD    ax, word ptr es:[bx + 0x46] ; ARITH
06DA25  26 F7 6F 02           IMUL   word ptr es:[bx + 2] ; ARITH
06DA29  50                    PUSH   ax ; STACK_PUSH
06DA2A  26 FF 77 10           PUSH   word ptr es:[bx + 0x10] ; PUSH_GLOBAL
06DA2E  26 FF 77 12           PUSH   word ptr es:[bx + 0x12] ; PUSH_GLOBAL
06DA32  26 FF 77 14           PUSH   word ptr es:[bx + 0x14] ; PUSH_GLOBAL
06DA36  26 8A 47 3C           MOV    al, byte ptr es:[bx + 0x3c] ; MOV
06DA3A  50                    PUSH   ax ; STACK_PUSH
06DA3B  26 8A 47 3E           MOV    al, byte ptr es:[bx + 0x3e] ; MOV
06DA3F  50                    PUSH   ax ; STACK_PUSH
06DA40  6A 00                 PUSH   0 ; STACK_PUSH
06DA42  6A 00                 PUSH   0 ; STACK_PUSH
06DA44  26 8B 47 48           MOV    ax, word ptr es:[bx + 0x48] ; MOV
06DA48  26 8B 4F 20           MOV    cx, word ptr es:[bx + 0x20] ; MOV
06DA4C  BB 01 00              MOV    bx, 1 ; MOV
06DA4F  2B D8                 SUB    bx, ax ; ARITH
06DA51  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
06DA54  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
06DA57  26 2B 44 22           SUB    ax, word ptr es:[si + 0x22] ; ARITH
06DA5B  48                    DEC    ax ; ARITH
06DA5C  D1 E3                 SHL    bx, 1 ; LOGIC
06DA5E  03 D9                 ADD    bx, cx ; ARITH
06DA60  8B 56 F6              MOV    dx, word ptr [bp - 0xa] ; LOCAL_LOAD
06DA63  E8 26 E7              CALL   0x6c18c ; CALL_NEAR
06DA66  8B 46 F2              MOV    ax, word ptr [bp - 0xe] ; LOCAL_LOAD
06DA69  0B 46 F0              OR     ax, word ptr [bp - 0x10] ; LOGIC
06DA6C  75 03                 JNE    0x6da71 ; CJUMP
06DA6E  E9 BD 01              JMP    0x6dc2e ; JUMP
06DA71  C4 5E F0              LES    bx, ptr [bp - 0x10] ; MOV_FAR
06DA74  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
06DA77  25 02 00              AND    ax, 2 ; LOGIC
06DA7A  A3 62 1F              MOV    word ptr [0x1f62], ax ; GLOBAL_LOAD
06DA7D  C4 76 04              LES    si, ptr [bp + 4] ; MOV_FAR
06DA80  8B C3                 MOV    ax, bx ; MOV
