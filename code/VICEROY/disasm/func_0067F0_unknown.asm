; ============================================================================
; func_0067F0_unknown
; Region   : load_image
; Bytes    : file 0x0067F0..0x00681C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0067F0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0067F4  52                    PUSH   dx ; STACK_PUSH
0067F5  57                    PUSH   di ; STACK_PUSH
0067F6  56                    PUSH   si ; STACK_PUSH
0067F7  8B C8                 MOV    cx, ax ; MOV
0067F9  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
0067FC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0067FF  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006802  8B C1                 MOV    ax, cx ; MOV
006804  0E                    PUSH   cs ; STACK_PUSH
006805  E8 6A FE              CALL   0x6672 ; CALL_NEAR
006808  8B F0                 MOV    si, ax ; MOV
00680A  8B 7E FC              MOV    di, word ptr [bp - 4] ; LOCAL_LOAD
00680D  0B F6                 OR     si, si ; LOGIC
00680F  7C 35                 JL     0x6846 ; CJUMP
006811  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006814  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
006818  2A FF                 SUB    bh, bh ; ARITH
00681A  8B C3                 MOV    ax, bx ; MOV
