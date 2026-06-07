; ============================================================================
; func_005DC4_unknown
; Region   : load_image
; Bytes    : file 0x005DC4..0x005DEE  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DC4  55                    PUSH   bp ; STACK_PUSH
005DC5  8B EC                 MOV    bp, sp ; MOV
005DC7  57                    PUSH   di ; STACK_PUSH
005DC8  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
005DCB  8B DF                 MOV    bx, di ; MOV
005DCD  33 C0                 XOR    ax, ax ; LOGIC
005DCF  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
005DD2  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005DD4  41                    INC    cx ; ARITH
005DD5  F7 D9                 NEG    cx ; ARITH
005DD7  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
005DDA  8B FB                 MOV    di, bx ; MOV
005DDC  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
005DDE  4F                    DEC    di ; ARITH
005DDF  26 38 05              CMP    byte ptr es:[di], al ; CMP
005DE2  74 04                 JE     0x5de8 ; CJUMP
005DE4  33 FF                 XOR    di, di ; LOGIC
005DE6  8E C7                 MOV    es, di ; MOV
005DE8  8B C7                 MOV    ax, di ; MOV
005DEA  8C C2                 MOV    dx, es ; MOV
005DEC  5F                    POP    di ; STACK_POP
005DED  8B                    DB     0x8B ; DATA_BYTE
