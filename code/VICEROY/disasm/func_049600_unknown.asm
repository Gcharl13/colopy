; ============================================================================
; func_049600_unknown
; Region   : overlay
; Bytes    : file 0x049600..0x0496BA  (186 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

049600  C8 D8 00 00           ENTER  0xd8, 0 ; PROLOGUE
049604  57                    PUSH   di ; STACK_PUSH
049605  56                    PUSH   si ; STACK_PUSH
049606  C7 86 3A FF FF FF     MOV    word ptr [bp - 0xc6], 0xffff ; LOCAL_STORE
04960C  C7 86 3C FF 01 00     MOV    word ptr [bp - 0xc4], 1 ; LOCAL_STORE
049612  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
049616  7C 18                 JL     0x49630 ; CJUMP
049618  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4 ; CMP
04961C  7D 12                 JGE    0x49630 ; CJUMP
04961E  6B 5E 0A 34           IMUL   bx, word ptr [bp + 0xa], 0x34 ; ARITH
049622  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
049627  75 07                 JNE    0x49630 ; CJUMP
049629  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
04962E  EB 05                 JMP    0x49635 ; JUMP
049630  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
049635  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
049639  74 3C                 JE     0x49677 ; CJUMP
04963B  6A 03                 PUSH   3 ; STACK_PUSH
04963D  6A 00                 PUSH   0 ; STACK_PUSH
04963F  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
049644  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
049647  0B C0                 OR     ax, ax ; LOGIC
049649  75 2C                 JNE    0x49677 ; CJUMP
04964B  6A 05                 PUSH   5 ; STACK_PUSH
04964D  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
049652  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
049655  83 3E 52 8D 00        CMP    word ptr [0x8d52], 0 ; CMP
04965A  75 0A                 JNE    0x49666 ; CJUMP
04965C  6A 07                 PUSH   7 ; STACK_PUSH
04965E  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
049663  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
049666  83 3E 52 8D 01        CMP    word ptr [0x8d52], 1 ; CMP
04966B  75 0A                 JNE    0x49677 ; CJUMP
04966D  6A 06                 PUSH   6 ; STACK_PUSH
04966F  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
049674  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
049677  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04967B  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
049680  72 07                 JB     0x49689 ; CJUMP
049682  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
049687  76 09                 JBE    0x49692 ; CJUMP
049689  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04968D  C6 87 58 31 00        MOV    byte ptr [bx + 0x3158], 0 ; MOV
049692  C7 86 40 FF 00 00     MOV    word ptr [bp - 0xc0], 0 ; LOCAL_STORE
049698  8A 86 40 FF           MOV    al, byte ptr [bp - 0xc0] ; LOCAL_LOAD
04969C  8B B6 40 FF           MOV    si, word ptr [bp - 0xc0] ; LOCAL_LOAD
0496A0  88 42 86              MOV    byte ptr [bp + si - 0x7a], al ; LOCAL_STORE
0496A3  88 82 6A FF           MOV    byte ptr [bp + si - 0x96], al ; LOCAL_STORE
0496A7  FF 86 40 FF           INC    word ptr [bp - 0xc0] ; ARITH
0496AB  83 BE 40 FF 10        CMP    word ptr [bp - 0xc0], 0x10 ; CMP
0496B0  7C E6                 JL     0x49698 ; CJUMP
0496B2  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
0496B6  9A                    DB     0x9A ; DATA_BYTE
0496B7  CA                    DB     0xCA ; DATA_BYTE
0496B8  04                    DB     0x04 ; DATA_BYTE
0496B9  1F                    DB     0x1F ; DATA_BYTE
