; ============================================================================
; func_061F02_unknown
; Region   : overlay
; Bytes    : file 0x061F02..0x061F61  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

061F02  C8 84 00 00           ENTER  0x84, 0 ; PROLOGUE
061F06  53                    PUSH   bx ; STACK_PUSH
061F07  52                    PUSH   dx ; STACK_PUSH
061F08  50                    PUSH   ax ; STACK_PUSH
061F09  56                    PUSH   si ; STACK_PUSH
061F0A  A1 F2 1D              MOV    ax, word ptr [0x1df2] ; GLOBAL_LOAD
061F0D  89 46 DC              MOV    word ptr [bp - 0x24], ax ; LOCAL_STORE
061F10  0B C0                 OR     ax, ax ; LOGIC
061F12  75 1B                 JNE    0x61f2f ; CJUMP
061F14  F6 06 94 08 10        TEST   byte ptr [0x894], 0x10 ; LOGIC
061F19  74 14                 JE     0x61f2f ; CJUMP
061F1B  39 06 A2 53           CMP    word ptr [0x53a2], ax ; CMP
061F1F  75 09                 JNE    0x61f2a ; CJUMP
061F21  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
061F24  39 06 D6 1D           CMP    word ptr [0x1dd6], ax ; CMP
061F28  75 05                 JNE    0x61f2f ; CJUMP
061F2A  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1 ; LOCAL_STORE
061F2F  A1 4E A1              MOV    ax, word ptr [0xa14e] ; GLOBAL_LOAD
061F32  2D 08 00              SUB    ax, 8 ; ARITH
061F35  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
061F38  A1 4C A1              MOV    ax, word ptr [0xa14c] ; GLOBAL_LOAD
061F3B  2D 08 00              SUB    ax, 8 ; ARITH
061F3E  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
061F41  83 3E D2 1D 0D        CMP    word ptr [0x1dd2], 0xd ; CMP
061F46  7C 0E                 JL     0x61f56 ; CJUMP
061F48  83 3E D2 1D 12        CMP    word ptr [0x1dd2], 0x12 ; CMP
061F4D  7F 07                 JG     0x61f56 ; CJUMP
061F4F  C7 46 E2 01 00        MOV    word ptr [bp - 0x1e], 1 ; LOCAL_STORE
061F54  EB 05                 JMP    0x61f5b ; JUMP
061F56  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0 ; LOCAL_STORE
061F5B  8B 1E D2 1D           MOV    bx, word ptr [0x1dd2] ; GLOBAL_LOAD
061F5F  8B C3                 MOV    ax, bx ; MOV
