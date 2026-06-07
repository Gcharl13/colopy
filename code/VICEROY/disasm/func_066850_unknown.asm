; ============================================================================
; func_066850_unknown
; Region   : overlay
; Bytes    : file 0x066850..0x066883  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066850  C8 08 01 00           ENTER  0x108, 0 ; PROLOGUE
066854  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
066857  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06685A  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06685D  8D 86 F8 FE           LEA    ax, [bp - 0x108] ; ADDR
066861  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
066864  8C 56 FE              MOV    word ptr [bp - 2], ss ; LOCAL_STORE
066867  FF 36 76 01           PUSH   word ptr [0x176] ; PUSH_GLOBAL
06686B  FF 36 74 01           PUSH   word ptr [0x174] ; PUSH_GLOBAL
06686F  6A 00                 PUSH   0 ; STACK_PUSH
066871  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
066874  8D 5E F8              LEA    bx, [bp - 8] ; ADDR
066877  2B D2                 SUB    dx, dx ; ARITH
066879  9A 54 02 1F 18        LCALL  0x181f, 0x254 ; THUNK -> 0x0C36:0x000A (thunk @file 0x01A844 type B)
06687E  8A 46 80              MOV    al, byte ptr [bp - 0x80] ; LOCAL_LOAD
066881  C9                    LEAVE ; EPILOGUE
066882  CB                    RETF ; RETURN
