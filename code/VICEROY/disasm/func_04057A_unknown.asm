; ============================================================================
; func_04057A_unknown
; Region   : overlay
; Bytes    : file 0x04057A..0x040607  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04057A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
04057E  57                    PUSH   di ; STACK_PUSH
04057F  56                    PUSH   si ; STACK_PUSH
040580  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
040585  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
040589  7D 0B                 JGE    0x40596 ; CJUMP
04058B  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04058F  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
040594  74 6A                 JE     0x40600 ; CJUMP
040596  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
040599  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
04059C  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04059F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0405A2  9A 78 0D 1F 18        LCALL  0x181f, 0xd78 ; THUNK -> 0x0000:0x07C2 (thunk @file 0x01B368 type A) overlay @file 0x0260C2
0405A7  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0405AA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0405AD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0405B0  9A 92 0A 1F 18        LCALL  0x181f, 0xa92 ; THUNK -> 0x05EB:0x0544 (thunk @file 0x01B082 type B) overlay @file 0x027534
0405B5  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0405B8  8B C8                 MOV    cx, ax ; MOV
0405BA  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0405BD  8B DA                 MOV    bx, dx ; MOV
0405BF  99                    CDQ ; ARITH
0405C0  2B C8                 SUB    cx, ax ; ARITH
0405C2  1B DA                 SBB    bx, dx ; ARITH
0405C4  8B F0                 MOV    si, ax ; MOV
0405C6  D1 F8                 SAR    ax, 1 ; LOGIC
0405C8  8B FA                 MOV    di, dx ; MOV
0405CA  99                    CDQ ; ARITH
0405CB  3B DA                 CMP    bx, dx ; CMP
0405CD  7C 31                 JL     0x40600 ; CJUMP
0405CF  7F 04                 JG     0x405d5 ; CJUMP
0405D1  3B C8                 CMP    cx, ax ; CMP
0405D3  72 2B                 JB     0x40600 ; CJUMP
0405D5  57                    PUSH   di ; STACK_PUSH
0405D6  56                    PUSH   si ; STACK_PUSH
0405D7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0405DA  9A F6 0A 1F 18        LCALL  0x181f, 0xaf6 ; THUNK -> 0x05EB:0x0596 (thunk @file 0x01B0E6 type B) overlay @file 0x027586
0405DF  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0405E2  8B 1E 4E 8D           MOV    bx, word ptr [0x8d4e] ; GLOBAL_LOAD
0405E6  FE 47 05              INC    byte ptr [bx + 5] ; ARITH
0405E9  6A 01                 PUSH   1 ; STACK_PUSH
0405EB  6A 10                 PUSH   0x10 ; PUSH_CONST
0405ED  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0405F0  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0405F3  9A 8C 06 1F 18        LCALL  0x181f, 0x68c ; THUNK -> 0x037F:0x015E (thunk @file 0x01AC7C type B) overlay @file 0x02EC9A
0405F8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0405FB  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
040600  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
040603  5E                    POP    si ; STACK_POP
040604  5F                    POP    di ; STACK_POP
040605  C9                    LEAVE ; EPILOGUE
040606  CB                    RETF ; RETURN
