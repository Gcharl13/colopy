; ============================================================================
; func_0065C4_unknown
; Region   : load_image
; Bytes    : file 0x0065C4..0x006607  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0065C4  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0065C8  57                    PUSH   di ; STACK_PUSH
0065C9  56                    PUSH   si ; STACK_PUSH
0065CA  8B F0                 MOV    si, ax ; MOV
0065CC  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
0065CF  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
0065D2  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
0065D7  72 0D                 JB     0x65e6 ; CJUMP
0065D9  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
0065DE  77 06                 JA     0x65e6 ; CJUMP
0065E0  BF 01 00              MOV    di, 1 ; MOV
0065E3  EB 03                 JMP    0x65e8 ; JUMP
0065E5  90                    NOP ; NOP
0065E6  2B FF                 SUB    di, di ; ARITH
0065E8  52                    PUSH   dx ; STACK_PUSH
0065E9  57                    PUSH   di ; STACK_PUSH
0065EA  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
0065EE  2A E4                 SUB    ah, ah ; ARITH
0065F0  8A 9F 47 31           MOV    bl, byte ptr [bx + 0x3147] ; MOV
0065F4  83 E3 0F              AND    bx, 0xf ; LOGIC
0065F7  8B 76 FE              MOV    si, word ptr [bp - 2] ; LOCAL_LOAD
0065FA  8A 94 45 31           MOV    dl, byte ptr [si + 0x3145] ; MOV
0065FE  2A F6                 SUB    dh, dh ; ARITH
006600  E8 65 FE              CALL   0x6468 ; CALL_NEAR
006603  5E                    POP    si ; STACK_POP
006604  5F                    POP    di ; STACK_POP
006605  C9                    LEAVE ; EPILOGUE
006606  CB                    RETF ; RETURN
