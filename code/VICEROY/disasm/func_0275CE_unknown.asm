; ============================================================================
; func_0275CE_unknown
; Region   : overlay
; Bytes    : file 0x0275CE..0x027606  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0275CE  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0275D2  56                    PUSH   si ; STACK_PUSH
0275D3  A0 36 03              MOV    al, byte ptr [0x336] ; GLOBAL_LOAD
0275D6  2A E4                 SUB    ah, ah ; ARITH
0275D8  A3 70 00              MOV    word ptr [0x70], ax ; GLOBAL_LOAD
0275DB  C7 46 FC 86 00        MOV    word ptr [bp - 4], 0x86 ; LOCAL_STORE
0275E0  9A 18 02 1F 18        LCALL  0x181f, 0x218 ; THUNK -> 0x0097:0x067A (thunk @file 0x01A808 type B) overlay @file 0x027746
0275E5  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
0275EA  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0275ED  8B D8                 MOV    bx, ax ; MOV
0275EF  D1 E3                 SHL    bx, 1 ; LOGIC
0275F1  83 BF C8 8D 00        CMP    word ptr [bx - 0x7238], 0 ; CMP
0275F6  74 1F                 JE     0x27617 ; CJUMP
0275F8  3D 05 00              CMP    ax, 5 ; CMP
0275FB  74 1A                 JE     0x27617 ; CJUMP
0275FD  0B C0                 OR     ax, ax ; LOGIC
0275FF  74 16                 JE     0x27617 ; CJUMP
027601  05 17 00              ADD    ax, 0x17 ; ARITH
027604  8B CB                 MOV    cx, bx ; MOV
