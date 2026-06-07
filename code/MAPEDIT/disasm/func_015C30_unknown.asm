; ============================================================================
; func_015C30_unknown
; Region   : load_image
; Bytes    : file 0x015C30..0x015C54  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015C30  55                    PUSH   bp ; STACK_PUSH
015C31  8B EC                 MOV    bp, sp ; MOV
015C33  8C D9                 MOV    cx, ds ; MOV
015C35  C5 5E 06              LDS    bx, ptr [bp + 6] ; MOV_FAR
015C38  8B D3                 MOV    dx, bx ; MOV
015C3A  EB 0B                 JMP    0x15c47 ; JUMP
015C3C  2C 61                 SUB    al, 0x61 ; ARITH
015C3E  3C 1A                 CMP    al, 0x1a ; CMP
015C40  73 04                 JAE    0x15c46 ; CJUMP
015C42  04 41                 ADD    al, 0x41 ; ARITH
015C44  88 07                 MOV    byte ptr [bx], al ; MOV
015C46  43                    INC    bx ; ARITH
015C47  8A 07                 MOV    al, byte ptr [bx] ; MOV
015C49  0A C0                 OR     al, al ; LOGIC
015C4B  75 EF                 JNE    0x15c3c ; CJUMP
015C4D  92                    XCHG   dx, ax ; MOV
015C4E  8C DA                 MOV    dx, ds ; MOV
015C50  8E D9                 MOV    ds, cx ; MOV
015C52  5D                    POP    bp ; STACK_POP
015C53  CB                    RETF ; RETURN
