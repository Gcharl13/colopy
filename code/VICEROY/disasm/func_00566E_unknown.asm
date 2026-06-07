; ============================================================================
; func_00566E_unknown
; Region   : load_image
; Bytes    : file 0x00566E..0x0056F2  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "opening", "-p:"  (auto-named via string xrefs)
; ============================================================================

00566E  C8 14 01 00           ENTER  0x114, 0 ; PROLOGUE
005672  68 06 01              PUSH   0x106                        ; STRING: "opening "
005675  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
005679  50                    PUSH   ax ; STACK_PUSH
00567A  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
00567F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005682  68 0F 01              PUSH   0x10f ; PUSH_CONST
005685  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
005689  50                    PUSH   ax ; STACK_PUSH
00568A  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
00568F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005692  83 3E 06 26 00        CMP    word ptr [0x2606], 0 ; CMP
005697  74 10                 JE     0x56a9 ; CJUMP
005699  68 12 01              PUSH   0x112 ; PUSH_CONST
00569C  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056A0  50                    PUSH   ax ; STACK_PUSH
0056A1  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
0056A6  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0056A9  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
0056AE  74 10                 JE     0x56c0 ; CJUMP
0056B0  68 14 01              PUSH   0x114 ; PUSH_CONST
0056B3  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056B7  50                    PUSH   ax ; STACK_PUSH
0056B8  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
0056BD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0056C0  83 3E 6C 03 00        CMP    word ptr [0x36c], 0 ; CMP
0056C5  74 20                 JE     0x56e7 ; CJUMP
0056C7  68 16 01              PUSH   0x116                        ; STRING: " -p:"
0056CA  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056CE  50                    PUSH   ax ; STACK_PUSH
0056CF  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
0056D4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0056D7  68 FE 84              PUSH   0x84fe ; PUSH_CONST
0056DA  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056DE  50                    PUSH   ax ; STACK_PUSH
0056DF  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
0056E4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0056E7  8D 86 EC FE           LEA    ax, [bp - 0x114] ; ADDR
0056EB  50                    PUSH   ax ; STACK_PUSH
0056EC  0E                    PUSH   cs ; STACK_PUSH
0056ED  E8 EA FD              CALL   0x54da ; CALL_NEAR
0056F0  C9                    LEAVE ; EPILOGUE
0056F1  CB                    RETF ; RETURN
