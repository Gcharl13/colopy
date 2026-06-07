; ============================================================================
; func_012D4A_unknown
; Region   : load_image
; Bytes    : file 0x012D4A..0x012DA9  (95 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012D4A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
012D4E  57                    PUSH   di ; STACK_PUSH
012D4F  56                    PUSH   si ; STACK_PUSH
012D50  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
012D53  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
012D56  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
012D5B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012D5E  BE FF FF              MOV    si, 0xffff ; CONST_LOAD
012D61  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
012D64  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
012D67  9A 3C 11 1D 0D        LCALL  0xd1d, 0x113c ; LCALL
012D6C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
012D6F  8B D8                 MOV    bx, ax ; MOV
012D71  03 5E 06              ADD    bx, word ptr [bp + 6] ; ARITH
012D74  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
012D77  4B                    DEC    bx ; ARITH
012D78  8B FB                 MOV    di, bx ; MOV
012D7A  8C 46 FE              MOV    word ptr [bp - 2], es ; LOCAL_STORE
012D7D  26 80 3F 20           CMP    byte ptr es:[bx], 0x20 ; CMP
012D81  74 0B                 JE     0x12d8e ; CJUMP
012D83  26 80 3D 09           CMP    byte ptr es:[di], 9 ; CMP
012D87  74 05                 JE     0x12d8e ; CJUMP
012D89  2B F6                 SUB    si, si ; ARITH
012D8B  EB 08                 JMP    0x12d95 ; JUMP
012D8D  90                    NOP ; NOP
012D8E  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
012D91  26 C6 05 00           MOV    byte ptr es:[di], 0 ; MOV
012D95  8D 45 FF              LEA    ax, [di - 1] ; ADDR
012D98  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
012D9B  73 02                 JAE    0x12d9f ; CJUMP
012D9D  2B F6                 SUB    si, si ; ARITH
012D9F  0B F6                 OR     si, si ; LOGIC
012DA1  75 BB                 JNE    0x12d5e ; CJUMP
012DA3  5E                    POP    si ; STACK_POP
012DA4  5F                    POP    di ; STACK_POP
012DA5  C9                    LEAVE ; EPILOGUE
012DA6  CA 04 00              RETF   4 ; RETURN
