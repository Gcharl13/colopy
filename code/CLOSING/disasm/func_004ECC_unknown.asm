; ============================================================================
; func_004ECC_unknown
; Region   : load_image
; Bytes    : file 0x004ECC..0x004EF0  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004ECC  55                    PUSH   bp ; STACK_PUSH
004ECD  8B EC                 MOV    bp, sp ; MOV
004ECF  8C D9                 MOV    cx, ds ; MOV
004ED1  C5 5E 06              LDS    bx, ptr [bp + 6] ; MOV_FAR
004ED4  8B D3                 MOV    dx, bx ; MOV
004ED6  EB 0B                 JMP    0x4ee3 ; JUMP
004ED8  2C 61                 SUB    al, 0x61 ; ARITH
004EDA  3C 1A                 CMP    al, 0x1a ; CMP
004EDC  73 04                 JAE    0x4ee2 ; CJUMP
004EDE  04 41                 ADD    al, 0x41 ; ARITH
004EE0  88 07                 MOV    byte ptr [bx], al ; MOV
004EE2  43                    INC    bx ; ARITH
004EE3  8A 07                 MOV    al, byte ptr [bx] ; MOV
004EE5  0A C0                 OR     al, al ; LOGIC
004EE7  75 EF                 JNE    0x4ed8 ; CJUMP
004EE9  92                    XCHG   dx, ax ; MOV
004EEA  8C DA                 MOV    dx, ds ; MOV
004EEC  8E D9                 MOV    ds, cx ; MOV
004EEE  5D                    POP    bp ; STACK_POP
004EEF  CB                    RETF ; RETURN
