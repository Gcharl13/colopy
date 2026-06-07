; ============================================================================
; func_006468_unknown
; Region   : load_image
; Bytes    : file 0x006468..0x0064B7  (79 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006468  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
00646C  53                    PUSH   bx ; STACK_PUSH
00646D  52                    PUSH   dx ; STACK_PUSH
00646E  50                    PUSH   ax ; STACK_PUSH
00646F  57                    PUSH   di ; STACK_PUSH
006470  56                    PUSH   si ; STACK_PUSH
006471  8B F0                 MOV    si, ax ; MOV
006473  8B FA                 MOV    di, dx ; MOV
006475  57                    PUSH   di ; STACK_PUSH
006476  56                    PUSH   si ; STACK_PUSH
006477  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00647C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00647F  0B C0                 OR     ax, ax ; LOGIC
006481  75 03                 JNE    0x6486 ; CJUMP
006483  E9 37 01              JMP    0x65bd ; JUMP
006486  83 7E F2 04           CMP    word ptr [bp - 0xe], 4 ; CMP
00648A  7C 03                 JL     0x648f ; CJUMP
00648C  E9 2E 01              JMP    0x65bd ; JUMP
00648F  57                    PUSH   di ; STACK_PUSH
006490  56                    PUSH   si ; STACK_PUSH
006491  9A A0 02 7F 03        LCALL  0x37f, 0x2a0 ; LCALL
006496  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006499  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00649C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00649F  F7 D8                 NEG    ax ; ARITH
0064A1  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
0064A4  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
0064A7  7E 03                 JLE    0x64ac ; CJUMP
0064A9  E9 11 01              JMP    0x65bd ; JUMP
0064AC  89 76 EE              MOV    word ptr [bp - 0x12], si ; LOCAL_STORE
0064AF  89 7E F0              MOV    word ptr [bp - 0x10], di ; LOCAL_STORE
0064B2  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0064B5  8B C3                 MOV    ax, bx ; MOV
