; ============================================================================
; func_039888_unknown
; Region   : overlay
; Bytes    : file 0x039888..0x0398A4  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "FOREIGNNOTAVAIL"  (auto-named via string xrefs)
; ============================================================================

039888  C8 72 00 00           ENTER  0x72, 0 ; PROLOGUE
03988C  56                    PUSH   si ; STACK_PUSH
03988D  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
039892  74 10                 JE     0x398a4 ; CJUMP
039894  6A 01                 PUSH   1 ; STACK_PUSH
039896  68 B6 11              PUSH   0x11b6                       ; STRING: "FOREIGNNOTAVAIL"
039899  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
03989E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0398A1  5E                    POP    si ; STACK_POP
0398A2  C9                    LEAVE ; EPILOGUE
0398A3  CB                    RETF ; RETURN
