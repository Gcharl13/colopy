; ============================================================================
; func_056B08_unknown
; Region   : overlay
; Bytes    : file 0x056B08..0x056B92  (138 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

056B08  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
056B0C  56                    PUSH   si ; STACK_PUSH
056B0D  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
056B12  8A 46 F2              MOV    al, byte ptr [bp - 0xe] ; LOCAL_LOAD
056B15  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
056B18  88 87 50 A1           MOV    byte ptr [bx - 0x5eb0], al ; MOV
056B1C  6A 00                 PUSH   0 ; STACK_PUSH
056B1E  6A 64                 PUSH   0x64 ; PUSH_CONST
056B20  69 F3 3C 01           IMUL   si, bx, 0x13c ; ARITH
056B24  FF B4 34 88           PUSH   word ptr [si - 0x77cc] ; PUSH_GLOBAL
056B28  FF B4 32 88           PUSH   word ptr [si - 0x77ce] ; PUSH_GLOBAL
056B2C  9A C6 0E 1D 0D        LCALL  0xd1d, 0xec6 ; LCALL
056B31  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
056B34  8A 8F 98 92           MOV    cl, byte ptr [bx - 0x6d68] ; MOV
056B38  2A ED                 SUB    ch, ch ; ARITH
056B3A  D1 E1                 SHL    cx, 1 ; LOGIC
056B3C  03 C1                 ADD    ax, cx ; ARITH
056B3E  8A 8F 10 94           MOV    cl, byte ptr [bx - 0x6bf0] ; MOV
056B42  2A ED                 SUB    ch, ch ; ARITH
056B44  03 C1                 ADD    ax, cx ; ARITH
056B46  D1 E3                 SHL    bx, 1 ; LOGIC
056B48  03 87 1C 94           ADD    ax, word ptr [bx - 0x6be4] ; ARITH
056B4C  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
056B4F  8B F3                 MOV    si, bx ; MOV
056B51  89 42 F8              MOV    word ptr [bp + si - 8], ax ; LOCAL_STORE
056B54  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
056B57  83 7E F2 04           CMP    word ptr [bp - 0xe], 4 ; CMP
056B5B  7C B5                 JL     0x56b12 ; CJUMP
056B5D  1E                    PUSH   ds ; STACK_PUSH
056B5E  68 50 A1              PUSH   0xa150 ; PUSH_CONST
056B61  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
056B64  16                    PUSH   ss ; STACK_PUSH
056B65  50                    PUSH   ax ; STACK_PUSH
056B66  B8 04 00              MOV    ax, 4 ; MOV
056B69  9A D0 0E 1F 19        LCALL  0x191f, 0xed0 ; THUNK -> 0x0CF8:0x000A (thunk @file 0x01C4C0 type B)
056B6E  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
056B73  8A 46 F2              MOV    al, byte ptr [bp - 0xe] ; LOCAL_LOAD
056B76  8B 5E F2              MOV    bx, word ptr [bp - 0xe] ; LOCAL_LOAD
056B79  8A 9F 50 A1           MOV    bl, byte ptr [bx - 0x5eb0] ; MOV
056B7D  2A FF                 SUB    bh, bh ; ARITH
056B7F  89 5E F4              MOV    word ptr [bp - 0xc], bx ; LOCAL_STORE
056B82  88 87 7C 91           MOV    byte ptr [bx - 0x6e84], al ; MOV
056B86  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
056B89  83 7E F2 04           CMP    word ptr [bp - 0xe], 4 ; CMP
056B8D  7C E4                 JL     0x56b73 ; CJUMP
056B8F  5E                    POP    si ; STACK_POP
056B90  C9                    LEAVE ; EPILOGUE
056B91  CB                    RETF ; RETURN
