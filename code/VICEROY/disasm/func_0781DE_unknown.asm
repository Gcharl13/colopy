; ============================================================================
; func_0781DE_unknown
; Region   : overlay
; Bytes    : file 0x0781DE..0x078242  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0781DE  C8 02 03 00           ENTER  0x302, 0 ; PROLOGUE
0781E2  53                    PUSH   bx ; STACK_PUSH
0781E3  56                    PUSH   si ; STACK_PUSH
0781E4  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0781E9  1E                    PUSH   ds ; STACK_PUSH
0781EA  53                    PUSH   bx ; STACK_PUSH
0781EB  8D 1E F2 25           LEA    bx, [0x25f2] ; ADDR
0781EF  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
0781F4  8B F0                 MOV    si, ax ; MOV
0781F6  0B F6                 OR     si, si ; LOGIC
0781F8  74 33                 JE     0x7822d ; CJUMP
0781FA  56                    PUSH   si ; STACK_PUSH
0781FB  6A 01                 PUSH   1 ; STACK_PUSH
0781FD  68 00 03              PUSH   0x300 ; PUSH_CONST
078200  8D 86 FE FC           LEA    ax, [bp - 0x302] ; ADDR
078204  50                    PUSH   ax ; STACK_PUSH
078205  9A 28 05 1D 0D        LCALL  0xd1d, 0x528 ; LCALL
07820A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07820D  0B C0                 OR     ax, ax ; LOGIC
07820F  74 1C                 JE     0x7822d ; CJUMP
078211  68 00 03              PUSH   0x300 ; PUSH_CONST
078214  8D 86 FE FC           LEA    ax, [bp - 0x302] ; ADDR
078218  16                    PUSH   ss ; STACK_PUSH
078219  50                    PUSH   ax ; STACK_PUSH
07821A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
07821D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
078220  9A B2 0F 1D 0D        LCALL  0xd1d, 0xfb2 ; LCALL
078225  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
078228  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
07822D  0B F6                 OR     si, si ; LOGIC
07822F  74 09                 JE     0x7823a ; CJUMP
078231  56                    PUSH   si ; STACK_PUSH
078232  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
078237  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07823A  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
07823D  5E                    POP    si ; STACK_POP
07823E  C9                    LEAVE ; EPILOGUE
07823F  CA 04 00              RETF   4 ; RETURN
