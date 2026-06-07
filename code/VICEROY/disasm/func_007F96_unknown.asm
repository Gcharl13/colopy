; ============================================================================
; func_007F96_unknown
; Region   : load_image
; Bytes    : file 0x007F96..0x007FFF  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "Treaty on error"  (auto-named via string xrefs)
; ============================================================================

007F96  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
007F9A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007F9D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007FA0  0E                    PUSH   cs ; STACK_PUSH
007FA1  E8 90 FF              CALL   0x7f34 ; CALL_NEAR
007FA4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007FA7  0B 46 0A              OR     ax, word ptr [bp + 0xa] ; LOGIC
007FAA  50                    PUSH   ax ; STACK_PUSH
007FAB  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007FAE  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007FB1  0E                    PUSH   cs ; STACK_PUSH
007FB2  E8 AD FF              CALL   0x7f62 ; CALL_NEAR
007FB5  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007FB8  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
007FBB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007FBE  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007FC1  0E                    PUSH   cs ; STACK_PUSH
007FC2  E8 6F FF              CALL   0x7f34 ; CALL_NEAR
007FC5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007FC8  0B 46 0A              OR     ax, word ptr [bp + 0xa] ; LOGIC
007FCB  50                    PUSH   ax ; STACK_PUSH
007FCC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
007FCF  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
007FD2  0E                    PUSH   cs ; STACK_PUSH
007FD3  E8 8C FF              CALL   0x7f62 ; CALL_NEAR
007FD6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007FD9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
007FDC  23 46 0A              AND    ax, word ptr [bp + 0xa] ; LOGIC
007FDF  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
007FE2  23 4E FE              AND    cx, word ptr [bp - 2] ; LOGIC
007FE5  3B C1                 CMP    ax, cx ; CMP
007FE7  74 11                 JE     0x7ffa ; CJUMP
007FE9  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
007FEC  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
007FEF  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
007FF2  68 02 02              PUSH   0x202                        ; STRING: "Treaty on error"
007FF5  9A 7E 07 1F 18        LCALL  0x181f, 0x77e ; THUNK -> 0x0000:0x00E2 (thunk @file 0x01AD6E type A) overlay @file 0x0259E2
007FFA  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
007FFD  C9                    LEAVE ; EPILOGUE
007FFE  CB                    RETF ; RETURN
