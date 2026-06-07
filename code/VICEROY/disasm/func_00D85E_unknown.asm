; ============================================================================
; func_00D85E_unknown
; Region   : load_image
; Bytes    : file 0x00D85E..0x00D8E4  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D85E  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
00D862  57                    PUSH   di ; STACK_PUSH
00D863  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D866  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D869  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D86C  16                    PUSH   ss ; STACK_PUSH
00D86D  50                    PUSH   ax ; STACK_PUSH
00D86E  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D873  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D876  6A 5C                 PUSH   0x5c ; PUSH_CONST
00D878  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D87B  16                    PUSH   ss ; STACK_PUSH
00D87C  50                    PUSH   ax ; STACK_PUSH
00D87D  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
00D882  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00D885  8B F8                 MOV    di, ax ; MOV
00D887  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
00D88A  0B D0                 OR     dx, ax ; LOGIC
00D88C  74 2A                 JE     0xd8b8 ; CJUMP
00D88E  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
00D891  26 80 7D 01 00        CMP    byte ptr es:[di + 1], 0 ; CMP
00D896  74 04                 JE     0xd89c ; CJUMP
00D898  26 C6 05 00           MOV    byte ptr es:[di], 0 ; MOV
00D89C  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D89F  16                    PUSH   ss ; STACK_PUSH
00D8A0  50                    PUSH   ax ; STACK_PUSH
00D8A1  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D8A4  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D8A7  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D8AC  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D8AF  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
00D8B2  26 C6 05 5C           MOV    byte ptr es:[di], 0x5c ; CONST_LOAD
00D8B6  EB 13                 JMP    0xd8cb ; JUMP
00D8B8  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D8BB  16                    PUSH   ss ; STACK_PUSH
00D8BC  50                    PUSH   ax ; STACK_PUSH
00D8BD  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D8C0  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D8C3  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D8C8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D8CB  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D8CE  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D8D1  9A 18 11 1D 0D        LCALL  0xd1d, 0x1118 ; LCALL
00D8D6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D8D9  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00D8DC  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00D8DF  5F                    POP    di ; STACK_POP
00D8E0  C9                    LEAVE ; EPILOGUE
00D8E1  CA 08 00              RETF   8 ; RETURN
