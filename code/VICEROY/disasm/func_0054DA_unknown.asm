; ============================================================================
; func_0054DA_unknown
; Region   : load_image
; Bytes    : file 0x0054DA..0x005504  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0054DA  C8 40 03 00           ENTER  0x340, 0 ; PROLOGUE
0054DE  57                    PUSH   di ; STACK_PUSH
0054DF  56                    PUSH   si ; STACK_PUSH
0054E0  2B C0                 SUB    ax, ax ; ARITH
0054E2  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0054E5  89 86 DC FC           MOV    word ptr [bp - 0x324], ax ; LOCAL_STORE
0054E9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0054EC  89 86 C4 FC           MOV    word ptr [bp - 0x33c], ax ; LOCAL_STORE
0054F0  EB 7A                 JMP    0x556c ; JUMP
0054F2  90                    NOP ; NOP
0054F3  90                    NOP ; NOP
0054F4  6A 20                 PUSH   0x20 ; PUSH_CONST
0054F6  53                    PUSH   bx ; STACK_PUSH
0054F7  9A 56 0C 1D 0D        LCALL  0xd1d, 0xc56 ; LCALL
0054FC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0054FF  89 86 C2 FC           MOV    word ptr [bp - 0x33e], ax ; LOCAL_STORE
005503  0B                    DB     0x0B ; DATA_BYTE
