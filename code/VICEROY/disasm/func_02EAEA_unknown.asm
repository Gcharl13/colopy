; ============================================================================
; func_02EAEA_unknown
; Region   : overlay
; Bytes    : file 0x02EAEA..0x02EB1B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EAEA  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
02EAEE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
02EAF1  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
02EAF6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02EAF9  9A 72 0C 1F 18        LCALL  0x181f, 0xc72 ; THUNK -> 0x05EB:0x26E4 (thunk @file 0x01B262 type B) overlay @file 0x0296D4
02EAFE  9A 22 0C 1F 18        LCALL  0x181f, 0xc22 ; THUNK -> 0x05EB:0x3956 (thunk @file 0x01B212 type B) overlay @file 0x02A946
02EB03  6A 00                 PUSH   0 ; STACK_PUSH
02EB05  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
02EB08  9A 4A 0C 1F 18        LCALL  0x181f, 0xc4a ; THUNK -> 0x05EB:0x096E (thunk @file 0x01B23A type B) overlay @file 0x02795E
02EB0D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02EB10  50                    PUSH   ax ; STACK_PUSH
02EB11  9A 36 0C 1F 18        LCALL  0x181f, 0xc36 ; THUNK -> 0x05EB:0x1068 (thunk @file 0x01B226 type B) overlay @file 0x028058
02EB16  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
02EB19  C9                    LEAVE ; EPILOGUE
02EB1A  CB                    RETF ; RETURN
