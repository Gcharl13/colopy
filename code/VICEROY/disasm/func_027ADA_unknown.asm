; ============================================================================
; func_027ADA_unknown
; Region   : overlay
; Bytes    : file 0x027ADA..0x027B62  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

027ADA  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
027ADE  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
027AE3  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
027AE8  74 0D                 JE     0x27af7 ; CJUMP
027AEA  83 3E 54 8D 04        CMP    word ptr [0x8d54], 4 ; CMP
027AEF  75 06                 JNE    0x27af7 ; CJUMP
027AF1  A1 42 03              MOV    ax, word ptr [0x342] ; GLOBAL_LOAD
027AF4  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
027AF7  6A 09                 PUSH   9 ; STACK_PUSH
027AF9  6A 1E                 PUSH   0x1e ; PUSH_CONST
027AFB  68 8A 00              PUSH   0x8a ; PUSH_CONST
027AFE  68 D8 00              PUSH   0xd8 ; PUSH_CONST
027B01  0E                    PUSH   cs ; STACK_PUSH
027B02  E8 BE 4F              CALL   0x2cac3 ; CALL_NEAR
027B05  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
027B08  6A 09                 PUSH   9 ; STACK_PUSH
027B0A  6A 1E                 PUSH   0x1e ; PUSH_CONST
027B0C  68 8A 00              PUSH   0x8a ; PUSH_CONST
027B0F  68 0E 01              PUSH   0x10e ; PUSH_CONST
027B12  0E                    PUSH   cs ; STACK_PUSH
027B13  E8 AD 4F              CALL   0x2cac3 ; CALL_NEAR
027B16  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
027B19  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
027B1D  80 BF 94 00 00        CMP    byte ptr [bx + 0x94], 0 ; CMP
027B22  7C 1D                 JL     0x27b41 ; CJUMP
027B24  83 7E FE 01           CMP    word ptr [bp - 2], 1 ; CMP
027B28  1B C0                 SBB    ax, ax ; ARITH
027B2A  F7 D8                 NEG    ax ; ARITH
027B2C  25 01 00              AND    ax, 1 ; LOGIC
027B2F  50                    PUSH   ax ; STACK_PUSH
027B30  68 8A 00              PUSH   0x8a ; PUSH_CONST
027B33  68 D8 00              PUSH   0xd8 ; PUSH_CONST
027B36  FF 36 A2 93           PUSH   word ptr [0x93a2] ; PUSH_GLOBAL
027B3A  0E                    PUSH   cs ; STACK_PUSH
027B3B  E8 E0 4E              CALL   0x2ca1e ; CALL_NEAR
027B3E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
027B41  83 7E FE 01           CMP    word ptr [bp - 2], 1 ; CMP
027B45  75 05                 JNE    0x27b4c ; CJUMP
027B47  B8 01 00              MOV    ax, 1 ; MOV
027B4A  EB 02                 JMP    0x27b4e ; JUMP
027B4C  2B C0                 SUB    ax, ax ; ARITH
027B4E  25 01 00              AND    ax, 1 ; LOGIC
027B51  50                    PUSH   ax ; STACK_PUSH
027B52  68 8A 00              PUSH   0x8a ; PUSH_CONST
027B55  68 0E 01              PUSH   0x10e ; PUSH_CONST
027B58  FF 36 A4 93           PUSH   word ptr [0x93a4] ; PUSH_GLOBAL
027B5C  0E                    PUSH   cs ; STACK_PUSH
027B5D  E8 BE 4E              CALL   0x2ca1e ; CALL_NEAR
027B60  C9                    LEAVE ; EPILOGUE
027B61  CB                    RETF ; RETURN
