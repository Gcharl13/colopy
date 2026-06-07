; ============================================================================
; func_031F28_unknown
; Region   : overlay
; Bytes    : file 0x031F28..0x031F48  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031F28  55                    PUSH   bp ; STACK_PUSH
031F29  8B EC                 MOV    bp, sp ; MOV
031F2B  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
031F2E  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
031F31  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
031F34  9A 92 00 1F 18        LCALL  0x181f, 0x92 ; THUNK -> 0x0009:0x0244 (thunk @file 0x01A682 type B) overlay @file 0x022A0E
031F39  8B E5                 MOV    sp, bp ; MOV
031F3B  6A 00                 PUSH   0 ; STACK_PUSH
031F3D  6A 00                 PUSH   0 ; STACK_PUSH
031F3F  6A 01                 PUSH   1 ; STACK_PUSH
031F41  9A B0 00 1F 18        LCALL  0x181f, 0xb0 ; THUNK -> 0x0009:0x02CC (thunk @file 0x01A6A0 type B) overlay @file 0x022A96
031F46  C9                    LEAVE ; EPILOGUE
031F47  CB                    RETF ; RETURN
