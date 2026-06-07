; ============================================================================
; func_0707B6_unknown
; Region   : overlay
; Bytes    : file 0x0707B6..0x070842  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0707B6  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
0707BA  57                    PUSH   di ; STACK_PUSH
0707BB  56                    PUSH   si ; STACK_PUSH
0707BC  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0707C0  7D 03                 JGE    0x707c5 ; CJUMP
0707C2  E9 65 01              JMP    0x7092a ; JUMP
0707C5  83 7E 06 03           CMP    word ptr [bp + 6], 3 ; CMP
0707C9  7E 03                 JLE    0x707ce ; CJUMP
0707CB  E9 5C 01              JMP    0x7092a ; JUMP
0707CE  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
0707D1  50                    PUSH   ax ; STACK_PUSH
0707D2  8D 4E AC              LEA    cx, [bp - 0x54] ; ADDR
0707D5  51                    PUSH   cx ; STACK_PUSH
0707D6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0707D9  0E                    PUSH   cs ; STACK_PUSH
0707DA  E8 7D 04              CALL   0x70c5a ; CALL_NEAR
0707DD  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0707E0  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0707E4  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0707E8  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0707EC  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0707F0  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0707F4  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0707F8  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0707FC  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
070800  6A 52                 PUSH   0x52 ; PUSH_CONST
070802  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
070805  8B 56 AA              MOV    dx, word ptr [bp - 0x56] ; LOCAL_LOAD
070808  BB 58 00              MOV    bx, 0x58 ; CONST_LOAD
07080B  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
070810  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
070813  8A 87 48 08           MOV    al, byte ptr [bx + 0x848] ; MOV
070817  88 46 A8              MOV    byte ptr [bp - 0x58], al ; LOCAL_STORE
07081A  39 1E 98 53           CMP    word ptr [0x5398], bx ; CMP
07081E  74 03                 JE     0x70823 ; CJUMP
070820  E9 F3 00              JMP    0x70916 ; JUMP
070823  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
070827  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
07082B  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
07082F  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
070833  8B 4E AA              MOV    cx, word ptr [bp - 0x56] ; LOCAL_LOAD
070836  83 C1 51              ADD    cx, 0x51 ; ARITH
070839  51                    PUSH   cx ; STACK_PUSH
07083A  50                    PUSH   ax ; STACK_PUSH
07083B  8B 46 AC              MOV    ax, word ptr [bp - 0x54] ; LOCAL_LOAD
07083E  8B D8                 MOV    bx, ax ; MOV
070840  83                    DB     0x83 ; DATA_BYTE
070841  C3                    DB     0xC3 ; DATA_BYTE
