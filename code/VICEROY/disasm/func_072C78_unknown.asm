; ============================================================================
; func_072C78_unknown
; Region   : overlay
; Bytes    : file 0x072C78..0x072CA4  (44 bytes)
; Purpose  : Name new colony prompt  (auto-inferred from string xref)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: ".SAV", "COLONY"  (auto-named via string xrefs)
; ============================================================================

072C78  55                    PUSH   bp ; STACK_PUSH
072C79  8B EC                 MOV    bp, sp ; MOV
072C7B  68 E2 20              PUSH   0x20e2                       ; STRING: "COLONY"
072C7E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
072C81  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
072C86  8B E5                 MOV    sp, bp ; MOV
072C88  1E                    PUSH   ds ; STACK_PUSH
072C89  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
072C8C  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
072C8F  BA 02 00              MOV    dx, 2 ; MOV
072C92  9A 9A 0E 1F 18        LCALL  0x181f, 0xe9a ; THUNK -> 0x09F6:0x0002 (thunk @file 0x01B48A type B) overlay @file 0x030C68
072C97  68 E9 20              PUSH   0x20e9                       ; STRING: ".SAV"
072C9A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
072C9D  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
072CA2  C9                    LEAVE ; EPILOGUE
072CA3  CB                    RETF ; RETURN
