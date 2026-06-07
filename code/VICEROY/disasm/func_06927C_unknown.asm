; ============================================================================
; func_06927C_unknown
; Region   : overlay
; Bytes    : file 0x06927C..0x06929C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "PEDIA"  (auto-named via string xrefs)
; ============================================================================

06927C  55                    PUSH   bp ; STACK_PUSH
06927D  8B EC                 MOV    bp, sp ; MOV
06927F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
069282  68 B2 1E              PUSH   0x1eb2                       ; STRING: "PEDIA"
069285  68 B8 1E              PUSH   0x1eb8                       ; STRING: "PEDIA"
069288  9A 22 04 1F 18        LCALL  0x181f, 0x422 ; THUNK -> 0x0000:0x0208 (thunk @file 0x01AA12 type A) overlay @file 0x025B08
06928D  8B E5                 MOV    sp, bp ; MOV
06928F  68 3C 83              PUSH   0x833c ; PUSH_CONST
069292  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
069295  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
06929A  C9                    LEAVE ; EPILOGUE
06929B  CB                    RETF ; RETURN
