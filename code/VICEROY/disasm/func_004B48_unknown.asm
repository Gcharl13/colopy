; ============================================================================
; func_004B48_unknown
; Region   : load_image
; Bytes    : file 0x004B48..0x004B61  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004B48  55                    PUSH   bp ; STACK_PUSH
004B49  8B EC                 MOV    bp, sp ; MOV
004B4B  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
004B4E  0B D2                 OR     dx, dx ; LOGIC
004B50  7D 04                 JGE    0x4b56 ; CJUMP
004B52  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
004B55  4A                    DEC    dx ; ARITH
004B56  39 56 08              CMP    word ptr [bp + 8], dx ; CMP
004B59  7F 02                 JG     0x4b5d ; CJUMP
004B5B  2B D2                 SUB    dx, dx ; ARITH
004B5D  8B C2                 MOV    ax, dx ; MOV
004B5F  C9                    LEAVE ; EPILOGUE
004B60  CB                    RETF ; RETURN
