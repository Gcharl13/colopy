; ============================================================================
; func_06BF12_unknown
; Region   : overlay
; Bytes    : file 0x06BF12..0x06BF3B  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "MSS0"  (auto-named via string xrefs)
; ============================================================================

06BF12  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
06BF16  68 7E 1F              PUSH   0x1f7e                       ; STRING: "MSS0"
06BF19  8D 46 EC              LEA    ax, [bp - 0x14] ; ADDR
06BF1C  50                    PUSH   ax ; STACK_PUSH
06BF1D  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
06BF22  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06BF25  A0 5E 1F              MOV    al, byte ptr [0x1f5e] ; GLOBAL_LOAD
06BF28  00 46 EF              ADD    byte ptr [bp - 0x11], al ; ARITH
06BF2B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06BF2E  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
06BF31  8D 5E EC              LEA    bx, [bp - 0x14] ; ADDR
06BF34  E8 19 FF              CALL   0x6be50 ; CALL_NEAR
06BF37  C9                    LEAVE ; EPILOGUE
06BF38  C2 04 00              RET    4 ; RETURN
