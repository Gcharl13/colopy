; ============================================================================
; func_029BBE_unknown
; Region   : overlay
; Bytes    : file 0x029BBE..0x029BF1  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

029BBE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
029BC2  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
029BC6  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
029BCA  83 7E 08 64           CMP    word ptr [bp + 8], 0x64 ; CMP
029BCE  7C 06                 JL     0x29bd6 ; CJUMP
029BD0  B8 17 00              MOV    ax, 0x17 ; CONST_LOAD
029BD3  EB 04                 JMP    0x29bd9 ; JUMP
029BD5  90                    NOP ; NOP
029BD6  B8 27 00              MOV    ax, 0x27 ; CONST_LOAD
029BD9  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
029BDC  2B D2                 SUB    dx, dx ; ARITH
029BDE  9A F8 08 1F 19        LCALL  0x191f, 0x8f8 ; THUNK -> 0x0B78:0x0000 (thunk @file 0x01BEE8 type B)
029BE3  C7 06 44 03 01 00     MOV    word ptr [0x344], 1 ; GLOBAL_LOAD
029BE9  C7 06 54 8D 07 00     MOV    word ptr [0x8d54], 7 ; GLOBAL_LOAD
029BEF  C9                    LEAVE ; EPILOGUE
029BF0  CB                    RETF ; RETURN
