; ============================================================================
; func_008000_unknown
; Region   : load_image
; Bytes    : file 0x008000..0x008073  (115 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "Treaty off error"  (auto-named via string xrefs)
; ============================================================================

008000  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
008004  56                    PUSH   si ; STACK_PUSH
008005  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008008  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00800B  0E                    PUSH   cs ; STACK_PUSH
00800C  E8 25 FF              CALL   0x7f34 ; CALL_NEAR
00800F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008012  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
008015  F7 D1                 NOT    cx ; LOGIC
008017  23 C1                 AND    ax, cx ; LOGIC
008019  50                    PUSH   ax ; STACK_PUSH
00801A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00801D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008020  8B F1                 MOV    si, cx ; MOV
008022  0E                    PUSH   cs ; STACK_PUSH
008023  E8 3C FF              CALL   0x7f62 ; CALL_NEAR
008026  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
008029  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00802C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00802F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008032  0E                    PUSH   cs ; STACK_PUSH
008033  E8 FE FE              CALL   0x7f34 ; CALL_NEAR
008036  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008039  23 F0                 AND    si, ax ; LOGIC
00803B  56                    PUSH   si ; STACK_PUSH
00803C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00803F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008042  0E                    PUSH   cs ; STACK_PUSH
008043  E8 1C FF              CALL   0x7f62 ; CALL_NEAR
008046  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
008049  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00804C  23 46 0A              AND    ax, word ptr [bp + 0xa] ; LOGIC
00804F  8B 4E FE              MOV    cx, word ptr [bp - 2] ; LOCAL_LOAD
008052  23 4E 0A              AND    cx, word ptr [bp + 0xa] ; LOGIC
008055  3B C1                 CMP    ax, cx ; CMP
008057  74 14                 JE     0x806d ; CJUMP
008059  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00805C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00805F  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
008062  68 12 02              PUSH   0x212                        ; STRING: "Treaty off error"
008065  9A 7E 07 1F 18        LCALL  0x181f, 0x77e ; THUNK -> 0x0000:0x00E2 (thunk @file 0x01AD6E type A) overlay @file 0x0259E2
00806A  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00806D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
008070  5E                    POP    si ; STACK_POP
008071  C9                    LEAVE ; EPILOGUE
008072  CB                    RETF ; RETURN
