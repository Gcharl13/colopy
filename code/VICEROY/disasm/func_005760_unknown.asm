; ============================================================================
; func_005760_unknown
; Region   : load_image
; Bytes    : file 0x005760..0x0057DF  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005760  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
005764  56                    PUSH   si ; STACK_PUSH
005765  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00576A  9A A8 05 1F 18        LCALL  0x181f, 0x5a8 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB98 type A) overlay @file 0x025900
00576F  6A 04                 PUSH   4 ; STACK_PUSH
005771  9A AA 00 84 09        LCALL  0x984, 0xaa ; LCALL
005776  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005779  9A 9A 05 1F 18        LCALL  0x181f, 0x59a ; THUNK -> 0x0000:0x00D8 (thunk @file 0x01AB8A type A) overlay @file 0x0259D8
00577E  6A 05                 PUSH   5 ; STACK_PUSH
005780  9A AA 00 84 09        LCALL  0x984, 0xaa ; LCALL
005785  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005788  9A F6 04 84 09        LCALL  0x984, 0x4f6 ; LCALL
00578D  80 3E 29 08 00        CMP    byte ptr [0x829], 0 ; CMP
005792  74 4A                 JE     0x57de ; CJUMP
005794  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0 ; LOCAL_STORE
005799  EB 2A                 JMP    0x57c5 ; JUMP
00579B  90                    NOP ; NOP
00579C  FF 46 F2              INC    word ptr [bp - 0xe] ; ARITH
00579F  83 7E F2 10           CMP    word ptr [bp - 0xe], 0x10 ; CMP
0057A3  7D 1D                 JGE    0x57c2 ; CJUMP
0057A5  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
0057A9  8B 76 F2              MOV    si, word ptr [bp - 0xe] ; LOCAL_LOAD
0057AC  8A 40 4C              MOV    al, byte ptr [bx + si + 0x4c] ; MOV
0057AF  98                    CWDE ; ARITH
0057B0  48                    DEC    ax ; ARITH
0057B1  79 02                 JNS    0x57b5 ; CJUMP
0057B3  2B C0                 SUB    ax, ax ; ARITH
0057B5  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
0057B8  C1 E3 04              SHL    bx, 4 ; LOGIC
0057BB  88 80 BC 84           MOV    byte ptr [bx + si - 0x7b44], al ; MOV
0057BF  EB DB                 JMP    0x579c ; JUMP
0057C1  90                    NOP ; NOP
0057C2  FF 46 EC              INC    word ptr [bp - 0x14] ; ARITH
0057C5  83 7E EC 04           CMP    word ptr [bp - 0x14], 4 ; CMP
0057C9  7D 13                 JGE    0x57de ; CJUMP
0057CB  FF 76 EC              PUSH   word ptr [bp - 0x14] ; PUSH_GLOBAL
0057CE  9A 82 05 1F 18        LCALL  0x181f, 0x582 ; THUNK -> 0x0000:0x0000 (thunk @file 0x01AB72 type A) overlay @file 0x025900
0057D3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0057D6  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
0057DB  EB C2                 JMP    0x579f ; JUMP
0057DD  90                    NOP ; NOP
0057DE  83                    DB     0x83 ; DATA_BYTE
