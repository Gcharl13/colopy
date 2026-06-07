; ============================================================================
; func_00D7F4_unknown
; Region   : load_image
; Bytes    : file 0x00D7F4..0x00D85D  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D7F4  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
00D7F8  56                    PUSH   si ; STACK_PUSH
00D7F9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00D7FC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00D7FF  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D802  16                    PUSH   ss ; STACK_PUSH
00D803  50                    PUSH   ax ; STACK_PUSH
00D804  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D809  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D80C  6A 5C                 PUSH   0x5c ; PUSH_CONST
00D80E  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D811  16                    PUSH   ss ; STACK_PUSH
00D812  50                    PUSH   ax ; STACK_PUSH
00D813  9A EA 10 1D 0D        LCALL  0xd1d, 0x10ea ; LCALL
00D818  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00D81B  8B F0                 MOV    si, ax ; MOV
00D81D  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
00D820  0B D0                 OR     dx, ax ; LOGIC
00D822  74 06                 JE     0xd82a ; CJUMP
00D824  46                    INC    si ; ARITH
00D825  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00D828  EB 08                 JMP    0xd832 ; JUMP
00D82A  8D 46 AC              LEA    ax, [bp - 0x54] ; ADDR
00D82D  8B F0                 MOV    si, ax ; MOV
00D82F  8C 56 FE              MOV    word ptr [bp - 2], ss ; LOCAL_STORE
00D832  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00D835  56                    PUSH   si ; STACK_PUSH
00D836  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D839  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D83C  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
00D841  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D844  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00D847  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00D84A  9A 18 11 1D 0D        LCALL  0xd1d, 0x1118 ; LCALL
00D84F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00D852  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00D855  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
00D858  5E                    POP    si ; STACK_POP
00D859  C9                    LEAVE ; EPILOGUE
00D85A  CA 08 00              RETF   8 ; RETURN
