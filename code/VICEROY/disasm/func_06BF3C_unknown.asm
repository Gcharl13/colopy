; ============================================================================
; func_06BF3C_unknown
; Region   : overlay
; Bytes    : file 0x06BF3C..0x06BF65  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MYR0"  (auto-named via string xrefs)
; ============================================================================

06BF3C  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
06BF40  68 83 1F              PUSH   0x1f83                       ; STRING: "MYR0"
06BF43  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
06BF46  50                    PUSH   ax ; STACK_PUSH
06BF47  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06BF4C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BF4F  A0 60 1F              MOV    al, byte ptr [0x1f60] ; GLOBAL_LOAD
06BF52  00 46 EF              ADD    byte ptr [bp - 0x11], al ; ARITH
06BF55  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06BF58  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06BF5B  8D 5E EC              LEA    bx, [bp - 0x14] ; ADDR
06BF5E  E8 EF FE              CALL   0x6be50 ; CALL_NEAR
06BF61  C9                    LEAVE ; EPILOGUE
06BF62  C2 04 00              RET    4 ; RETURN
