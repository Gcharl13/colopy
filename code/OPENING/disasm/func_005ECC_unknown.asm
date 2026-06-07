; ============================================================================
; func_005ECC_unknown
; Region   : load_image
; Bytes    : file 0x005ECC..0x005EF0  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005ECC  55                    PUSH   bp ; STACK_PUSH
005ECD  8B EC                 MOV    bp, sp ; MOV
005ECF  8C D9                 MOV    cx, ds ; MOV
005ED1  C5 5E 06              LDS    bx, ptr [bp + 6] ; MOV_FAR
005ED4  8B D3                 MOV    dx, bx ; MOV
005ED6  EB 0B                 JMP    0x5ee3 ; JUMP
005ED8  2C 61                 SUB    al, 0x61 ; ARITH
005EDA  3C 1A                 CMP    al, 0x1a ; CMP
005EDC  73 04                 JAE    0x5ee2 ; CJUMP
005EDE  04 41                 ADD    al, 0x41 ; ARITH
005EE0  88 07                 MOV    byte ptr [bx], al ; MOV
005EE2  43                    INC    bx ; ARITH
005EE3  8A 07                 MOV    al, byte ptr [bx] ; MOV
005EE5  0A C0                 OR     al, al ; LOGIC
005EE7  75 EF                 JNE    0x5ed8 ; CJUMP
005EE9  92                    XCHG   dx, ax ; MOV
005EEA  8C DA                 MOV    dx, ds ; MOV
005EEC  8E D9                 MOV    ds, cx ; MOV
005EEE  5D                    POP    bp ; STACK_POP
005EEF  CB                    RETF ; RETURN
