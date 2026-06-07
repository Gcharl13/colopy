; ============================================================================
; func_015B28_unknown
; Region   : load_image
; Bytes    : file 0x015B28..0x015B52  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015B28  55                    PUSH   bp ; STACK_PUSH
015B29  8B EC                 MOV    bp, sp ; MOV
015B2B  57                    PUSH   di ; STACK_PUSH
015B2C  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015B2F  8B DF                 MOV    bx, di ; MOV
015B31  33 C0                 XOR    ax, ax ; LOGIC
015B33  B9 FF FF              MOV    cx, 0xffff ; CONST_LOAD
015B36  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015B38  41                    INC    cx ; ARITH
015B39  F7 D9                 NEG    cx ; ARITH
015B3B  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
015B3E  8B FB                 MOV    di, bx ; MOV
015B40  F2 AE                 REPNE SCASB al, byte ptr es:[di] ; STR
015B42  4F                    DEC    di ; ARITH
015B43  26 38 05              CMP    byte ptr es:[di], al ; CMP
015B46  74 04                 JE     0x15b4c ; CJUMP
015B48  33 FF                 XOR    di, di ; LOGIC
015B4A  8E C7                 MOV    es, di ; MOV
015B4C  8B C7                 MOV    ax, di ; MOV
015B4E  8C C2                 MOV    dx, es ; MOV
015B50  5F                    POP    di ; STACK_POP
015B51  8B                    DB     0x8B ; DATA_BYTE
