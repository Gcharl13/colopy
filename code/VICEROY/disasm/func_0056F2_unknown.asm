; ============================================================================
; func_0056F2_unknown
; Region   : load_image
; Bytes    : file 0x0056F2..0x00575F  (109 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "closing", "-gok", "-p:"  (auto-named via string xrefs)
; ============================================================================

0056F2  C8 14 01 00           ENTER  0x114, 0 ; PROLOGUE
0056F6  68 1B 01              PUSH   0x11b                        ; STRING: "closing "
0056F9  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056FD  50                    PUSH   ax ; STACK_PUSH
0056FE  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
005703  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005706  68 24 01              PUSH   0x124                        ; STRING: "-gok"
005709  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
00570D  50                    PUSH   ax ; STACK_PUSH
00570E  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
005713  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005716  83 3E 06 26 00        CMP    word ptr [0x2606], 0 ; CMP
00571B  74 10                 JE     0x572d ; CJUMP
00571D  68 29 01              PUSH   0x129 ; PUSH_CONST
005720  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
005724  50                    PUSH   ax ; STACK_PUSH
005725  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
00572A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00572D  83 3E 6C 03 00        CMP    word ptr [0x36c], 0 ; CMP
005732  74 20                 JE     0x5754 ; CJUMP
005734  68 2B 01              PUSH   0x12b                        ; STRING: " -p:"
005737  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
00573B  50                    PUSH   ax ; STACK_PUSH
00573C  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
005741  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005744  68 FE 84              PUSH   0x84fe ; PUSH_CONST
005747  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
00574B  50                    PUSH   ax ; STACK_PUSH
00574C  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
005751  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005754  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
005758  50                    PUSH   ax ; STACK_PUSH
005759  0E                    PUSH   cs ; STACK_PUSH
00575A  E8 7D FD              CALL   0x54da ; CALL_NEAR
00575D  C9                    LEAVE ; EPILOGUE
00575E  CB                    RETF ; RETURN
