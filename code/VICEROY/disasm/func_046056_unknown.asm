; ============================================================================
; func_046056_unknown
; Region   : overlay
; Bytes    : file 0x046056..0x0460F8  (162 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046056  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
04605A  C7 46 F6 FF FF        MOV    word ptr [bp - 0xa], 0xffff ; LOCAL_STORE
04605F  C7 46 FE 0F 27        MOV    word ptr [bp - 2], 0x270f ; LOCAL_STORE
046064  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
046069  EB 6B                 JMP    0x460d6 ; JUMP
04606B  90                    NOP ; NOP
04606C  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
046070  7C 0C                 JL     0x4607e ; CJUMP
046072  6B D8 12              IMUL   bx, ax, 0x12 ; ARITH
046075  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
046078  38 87 EE 54           CMP    byte ptr [bx + 0x54ee], al ; CMP
04607C  75 55                 JNE    0x460d3 ; CJUMP
04607E  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0 ; CMP
046082  7C 1D                 JL     0x460a1 ; CJUMP
046084  6B 5E FA 12           IMUL   bx, word ptr [bp - 6], 0x12 ; ARITH
046088  8A 87 ED 54           MOV    al, byte ptr [bx + 0x54ed] ; MOV
04608C  2A E4                 SUB    ah, ah ; ARITH
04608E  50                    PUSH   ax ; STACK_PUSH
04608F  8A 87 EC 54           MOV    al, byte ptr [bx + 0x54ec] ; MOV
046093  50                    PUSH   ax ; STACK_PUSH
046094  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
046099  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04609C  3B 46 0C              CMP    ax, word ptr [bp + 0xc] ; CMP
04609F  75 32                 JNE    0x460d3 ; CJUMP
0460A1  6B 5E FA 12           IMUL   bx, word ptr [bp - 6], 0x12 ; ARITH
0460A5  8A 87 ED 54           MOV    al, byte ptr [bx + 0x54ed] ; MOV
0460A9  2A E4                 SUB    ah, ah ; ARITH
0460AB  2B 46 08              SUB    ax, word ptr [bp + 8] ; ARITH
0460AE  F7 D8                 NEG    ax ; ARITH
0460B0  50                    PUSH   ax ; STACK_PUSH
0460B1  8A 87 EC 54           MOV    al, byte ptr [bx + 0x54ec] ; MOV
0460B5  2A E4                 SUB    ah, ah ; ARITH
0460B7  2B 46 06              SUB    ax, word ptr [bp + 6] ; ARITH
0460BA  F7 D8                 NEG    ax ; ARITH
0460BC  50                    PUSH   ax ; STACK_PUSH
0460BD  9A 70 03 1F 18        LCALL  0x181f, 0x370 ; THUNK -> 0x024C:0x0040 (thunk @file 0x01A960 type B) overlay @file 0x0287C6
0460C2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0460C5  3B 46 FE              CMP    ax, word ptr [bp - 2] ; CMP
0460C8  7F 09                 JG     0x460d3 ; CJUMP
0460CA  8B 4E FA              MOV    cx, word ptr [bp - 6] ; LOCAL_LOAD
0460CD  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
0460D0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0460D3  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
0460D6  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0460D9  39 06 9A 53           CMP    word ptr [0x539a], ax ; CMP
0460DD  7F 8D                 JG     0x4606c ; CJUMP
0460DF  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0460E2  A3 B8 8D              MOV    word ptr [0x8db8], ax ; GLOBAL_LOAD
0460E5  83 7E F6 00           CMP    word ptr [bp - 0xa], 0 ; CMP
0460E9  7C 08                 JL     0x460f3 ; CJUMP
0460EB  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
0460EE  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
0460F3  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
0460F6  C9                    LEAVE ; EPILOGUE
0460F7  CB                    RETF ; RETURN
