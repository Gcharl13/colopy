; ============================================================================
; func_028792_unknown
; Region   : overlay
; Bytes    : file 0x028792..0x0287B2  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028792  55                    PUSH   bp ; STACK_PUSH
028793  8B EC                 MOV    bp, sp ; MOV
028795  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
028798  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02879B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02879E  9A 92 00 1F 18        LCALL  0x181f, 0x92 ; THUNK -> 0x0009:0x0244 (thunk @file 0x01A682 type B) overlay @file 0x022A0E
0287A3  8B E5                 MOV    sp, bp ; MOV
0287A5  6A 00                 PUSH   0 ; STACK_PUSH
0287A7  6A 00                 PUSH   0 ; STACK_PUSH
0287A9  6A 01                 PUSH   1 ; STACK_PUSH
0287AB  9A B0 00 1F 18        LCALL  0x181f, 0xb0 ; THUNK -> 0x0009:0x02CC (thunk @file 0x01A6A0 type B) overlay @file 0x022A96
0287B0  C9                    LEAVE ; EPILOGUE
0287B1  CB                    RETF ; RETURN
