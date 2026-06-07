; ============================================================================
; func_004DC4_unknown
; Region   : load_image
; Bytes    : file 0x004DC4..0x004DEE  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004DC4  55                    PUSH   bp ; STACK_PUSH
004DC5  8B EC                 MOV    bp, sp ; MOV
004DC7  57                    PUSH   di ; STACK_PUSH
004DC8  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
004DCB  8B DF                 MOV    bx, di ; MOV
004DCD  33 C0                 XOR    ax, ax ; LOGIC
004DCF  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
004DD2  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004DD4  41                    INC    cx ; ARITH
004DD5  F7 D9                 NEG    cx ; ARITH
004DD7  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
004DDA  8B FB                 MOV    di, bx ; MOV
004DDC  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
004DDE  4F                    DEC    di ; ARITH
004DDF  26 38 05              CMP    byte ptr es:[di], al ; CMP
004DE2  74 04                 JE     0x4de8 ; CJUMP
004DE4  33 FF                 XOR    di, di ; LOGIC
004DE6  8E C7                 MOV    es, di ; MOV
004DE8  8B C7                 MOV    ax, di ; MOV
004DEA  8C C2                 MOV    dx, es ; MOV
004DEC  5F                    POP    di ; STACK_POP
004DED  8B                    DB     0x8B ; DATA_BYTE
