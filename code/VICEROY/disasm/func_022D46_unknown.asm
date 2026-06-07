; ============================================================================
; func_022D46_unknown
; Region   : overlay
; Bytes    : file 0x022D46..0x022D5D  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "TRADENONE"  (auto-named via string xrefs)
; ============================================================================

022D46  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
022D4A  83 3E A0 53 00        CMP    word ptr [0x53a0], 0 ; CMP
022D4F  75 0D                 JNE    0x22d5e ; CJUMP
022D51  6A 00                 PUSH   0 ; STACK_PUSH
022D53  68 2D 0A              PUSH   0xa2d                        ; STRING: "TRADENONE"
022D56  9A 52 06 1F 18        LCALL  0x181f, 0x652 ; THUNK -> 0x0000:0x37A2 (thunk @file 0x01AC42 type A) overlay @file 0x0290A2
022D5B  C9                    LEAVE ; EPILOGUE
022D5C  CB                    RETF ; RETURN
