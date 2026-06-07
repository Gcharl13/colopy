; ============================================================================
; func_0320EE_unknown
; Region   : overlay
; Bytes    : file 0x0320EE..0x032121  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0320EE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0320F2  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0320F6  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0320FA  83 7E 08 64           CMP    word ptr [bp + 8], 0x64 ; CMP
0320FE  7C 06                 JL     0x32106 ; CJUMP
032100  B8 17 00              MOV    ax, 0x17 ; CONST_LOAD
032103  EB 04                 JMP    0x32109 ; JUMP
032105  90                    NOP ; NOP
032106  B8 27 00              MOV    ax, 0x27 ; CONST_LOAD
032109  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
03210C  2B D2                 SUB    dx, dx ; ARITH
03210E  9A F8 08 1F 19        LCALL  0x191f, 0x8f8 ; THUNK -> 0x0B78:0x0000 (thunk @file 0x01BEE8 type B)
032113  C7 06 3E 9E 01 00     MOV    word ptr [0x9e3e], 1 ; GLOBAL_LOAD
032119  C7 06 3A 9E 0A 00     MOV    word ptr [0x9e3a], 0xa ; GLOBAL_LOAD
03211F  C9                    LEAVE ; EPILOGUE
032120  CB                    RETF ; RETURN
