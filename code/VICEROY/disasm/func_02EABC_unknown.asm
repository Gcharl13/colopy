; ============================================================================
; func_02EABC_unknown
; Region   : overlay
; Bytes    : file 0x02EABC..0x02EAEA  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EABC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
02EAC0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02EAC3  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
02EAC8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02EACB  9A 72 0C 1F 18        LCALL  0x181f, 0xc72 ; THUNK -> 0x05EB:0x26E4 (thunk @file 0x01B262 type B) overlay @file 0x0296D4
02EAD0  9A 22 0C 1F 18        LCALL  0x181f, 0xc22 ; THUNK -> 0x05EB:0x3956 (thunk @file 0x01B212 type B) overlay @file 0x02A946
02EAD5  6A 00                 PUSH   0 ; STACK_PUSH
02EAD7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02EADA  9A 4A 0C 1F 18        LCALL  0x181f, 0xc4a ; THUNK -> 0x05EB:0x096E (thunk @file 0x01B23A type B) overlay @file 0x02795E
02EADF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02EAE2  50                    PUSH   ax ; STACK_PUSH
02EAE3  9A 4C 05 1F 19        LCALL  0x191f, 0x54c ; THUNK -> 0x0000:0x2F3E (thunk @file 0x01BB3C type A) overlay @file 0x02883E
02EAE8  C9                    LEAVE ; EPILOGUE
02EAE9  CB                    RETF ; RETURN
