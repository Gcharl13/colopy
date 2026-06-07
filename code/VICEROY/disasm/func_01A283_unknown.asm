; ============================================================================
; func_01A283_unknown
; Region   : load_image
; Bytes    : file 0x01A283..0x01A2D9  (86 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01A283  55                    PUSH   bp ; STACK_PUSH
01A284  8B EC                 MOV    bp, sp ; MOV
01A286  8E C0                 MOV    es, ax ; MOV
01A288  26 8B 0E 2C 00        MOV    cx, word ptr es:[0x2c] ; GLOBAL_LOAD
01A28D  E3 41                 JCXZ   0x1a2d0 ; CJUMP
01A28F  8E C1                 MOV    es, cx ; MOV
01A291  33 FF                 XOR    di, di ; LOGIC
01A293  26 8A 05              MOV    al, byte ptr es:[di] ; MOV
01A296  0A C0                 OR     al, al ; LOGIC
01A298  74 36                 JE     0x1a2d0 ; CJUMP
01A29A  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
01A29D  AC                    LODSB  al, byte ptr [si] ; STR
01A29E  0A C0                 OR     al, al ; LOGIC
01A2A0  75 08                 JNE    0x1a2aa ; CJUMP
01A2A2  26 80 3D 3D           CMP    byte ptr es:[di], 0x3d ; CMP
01A2A6  74 13                 JE     0x1a2bb ; CJUMP
01A2A8  EB 08                 JMP    0x1a2b2 ; JUMP
01A2AA  26 8A 25              MOV    ah, byte ptr es:[di] ; MOV
01A2AD  47                    INC    di ; ARITH
01A2AE  3A C4                 CMP    al, ah ; CMP
01A2B0  74 EB                 JE     0x1a29d ; CJUMP
01A2B2  32 C0                 XOR    al, al ; LOGIC
01A2B4  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
01A2B7  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
01A2B9  EB D8                 JMP    0x1a293 ; JUMP
01A2BB  8C C0                 MOV    ax, es ; MOV
01A2BD  8E D8                 MOV    ds, ax ; MOV
01A2BF  8B F7                 MOV    si, di ; MOV
01A2C1  46                    INC    si ; ARITH
01A2C2  8E 46 02              MOV    es, word ptr [bp + 2] ; LOCAL_LOAD
01A2C5  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
01A2C8  AC                    LODSB  al, byte ptr [si] ; STR
01A2C9  AA                    STOSB  byte ptr es:[di], al ; STR
01A2CA  0A C0                 OR     al, al ; LOGIC
01A2CC  75 FA                 JNE    0x1a2c8 ; CJUMP
01A2CE  EB 01                 JMP    0x1a2d1 ; JUMP
01A2D0  F9                    STC ; FLAG
01A2D1  5D                    POP    bp ; STACK_POP
01A2D2  07                    POP    es ; STACK_POP
01A2D3  1F                    POP    ds ; STACK_POP
01A2D4  5E                    POP    si ; STACK_POP
01A2D5  5F                    POP    di ; STACK_POP
01A2D6  59                    POP    cx ; STACK_POP
01A2D7  58                    POP    ax ; STACK_POP
01A2D8  CB                    RETF ; RETURN
