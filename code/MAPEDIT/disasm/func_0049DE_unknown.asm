; ============================================================================
; func_0049DE_unknown
; Region   : load_image
; Bytes    : file 0x0049DE..0x004A1F  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0049DE  55                    PUSH   bp ; STACK_PUSH
0049DF  8B EC                 MOV    bp, sp ; MOV
0049E1  56                    PUSH   si ; STACK_PUSH
0049E2  8B 46 04              MOV    ax, word ptr [bp + 4] ; LOCAL_LOAD
0049E5  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
0049E8  05 84 00              ADD    ax, 0x84 ; ARITH
0049EB  52                    PUSH   dx ; STACK_PUSH
0049EC  50                    PUSH   ax ; STACK_PUSH
0049ED  53                    PUSH   bx ; STACK_PUSH
0049EE  8B F3                 MOV    si, bx ; MOV
0049F0  9A 84 06 88 13        LCALL  0x1388, 0x684 ; LCALL
0049F5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0049F8  40                    INC    ax ; ARITH
0049F9  2B D2                 SUB    dx, dx ; ARITH
0049FB  9A 0A 01 45 0F        LCALL  0xf45, 0x10a ; LCALL
004A00  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
004A03  26 89 47 6C           MOV    word ptr es:[bx + 0x6c], ax ; MOV
004A07  26 89 57 6E           MOV    word ptr es:[bx + 0x6e], dx ; MOV
004A0B  1E                    PUSH   ds ; STACK_PUSH
004A0C  56                    PUSH   si ; STACK_PUSH
004A0D  52                    PUSH   dx ; STACK_PUSH
004A0E  26 FF 77 6C           PUSH   word ptr es:[bx + 0x6c] ; PUSH_GLOBAL
004A12  9A EC 0D 88 13        LCALL  0x1388, 0xdec ; LCALL
004A17  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004A1A  5E                    POP    si ; STACK_POP
004A1B  C9                    LEAVE ; EPILOGUE
004A1C  C2 04 00              RET    4 ; RETURN
