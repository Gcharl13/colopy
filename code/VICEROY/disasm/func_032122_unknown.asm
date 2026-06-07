; ============================================================================
; func_032122_unknown
; Region   : overlay
; Bytes    : file 0x032122..0x03214D  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

032122  55                    PUSH   bp ; STACK_PUSH
032123  8B EC                 MOV    bp, sp ; MOV
032125  6A 01                 PUSH   1 ; STACK_PUSH
032127  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
03212C  8B E5                 MOV    sp, bp ; MOV
03212E  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
032132  9A A4 09 1F 18        LCALL  0x181f, 0x9a4 ; THUNK -> 0x05B3:0x01E0 (thunk @file 0x01AF94 type B) overlay @file 0x05FE0C
032137  8B E5                 MOV    sp, bp ; MOV
032139  50                    PUSH   ax ; STACK_PUSH
03213A  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
03213F  8B E5                 MOV    sp, bp ; MOV
032141  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
032145  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
032149  2A FF                 SUB    bh, bh ; ARITH
03214B  8B C3                 MOV    ax, bx ; MOV
