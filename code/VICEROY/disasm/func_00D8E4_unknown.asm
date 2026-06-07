; ============================================================================
; func_00D8E4_unknown
; Region   : load_image
; Bytes    : file 0x00D8E4..0x00D971  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D8E4  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
00D8E8  56                    PUSH   si ; STACK_PUSH
00D8E9  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D8EC  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D8EF  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D8F2  16                    PUSH   ss ; STACK_PUSH
00D8F3  50                    PUSH   ax ; STACK_PUSH
00D8F4  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D8F9  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D8FC  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D8FF  8B F0                 MOV    si, ax ; MOV
00D901  8C 56 FE              MOV    word ptr [bp - 2], ss ; LOCAL_STORE
00D904  8B D8                 MOV    bx, ax ; MOV
00D906  36 80 3F 00           CMP    byte ptr ss:[bx], 0 ; CMP
00D90A  74 0A                 JE     0xd916 ; CJUMP
00D90C  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
00D90F  46                    INC    si ; ARITH
00D910  26 80 3C 00           CMP    byte ptr es:[si], 0 ; CMP
00D914  75 F9                 JNE    0xd90f ; CJUMP
00D916  8E 46 FE              MOV    es, word ptr [bp - 2] ; LOCAL_LOAD
00D919  8D 5C FF              LEA    bx, [si - 1] ; ADDR
00D91C  26 80 3F 5C           CMP    byte ptr es:[bx], 0x5c ; CMP
00D920  74 0F                 JE     0xd931 ; CJUMP
00D922  68 2A 26              PUSH   0x262a ; PUSH_CONST
00D925  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D928  50                    PUSH   ax ; STACK_PUSH
00D929  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
00D92E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D931  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D934  16                    PUSH   ss ; STACK_PUSH
00D935  50                    PUSH   ax ; STACK_PUSH
00D936  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00D939  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00D93C  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D941  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D944  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D947  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D94A  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00D94D  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00D950  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
00D955  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D958  FF 76 10              PUSH   word ptr [bp + 0x10] ; PUSH_GLOBAL
00D95B  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00D95E  9A 18 11 1D 0D        LCALL  0xd1d, 0x1118 ; LCALL
00D963  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D966  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
00D969  8B 56 10              MOV    dx, word ptr [bp + 0x10] ; LOCAL_LOAD
00D96C  5E                    POP    si ; STACK_POP
00D96D  C9                    LEAVE ; EPILOGUE
00D96E  CA 0C 00              RETF   0xc ; RETURN
