; ============================================================================
; func_044B7A_unknown
; Region   : overlay
; Bytes    : file 0x044B7A..0x044BB7  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

044B7A  C8 16 00 00           ENTER  0x16, 0 ; PROLOGUE
044B7E  57                    PUSH   di ; STACK_PUSH
044B7F  56                    PUSH   si ; STACK_PUSH
044B80  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
044B85  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
044B88  26 8B 47 38           MOV    ax, word ptr es:[bx + 0x38] ; MOV
044B8C  26 8B 57 3A           MOV    dx, word ptr es:[bx + 0x3a] ; MOV
044B90  8B F8                 MOV    di, ax ; MOV
044B92  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
044B95  8B C8                 MOV    cx, ax ; MOV
044B97  8B F2                 MOV    si, dx ; MOV
044B99  8B D8                 MOV    bx, ax ; MOV
044B9B  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
044B9E  0B F1                 OR     si, cx ; LOGIC
044BA0  74 5C                 JE     0x44bfe ; CJUMP
044BA2  8E DA                 MOV    ds, dx ; MOV
044BA4  8B 4F 02              MOV    cx, word ptr [bx + 2] ; MOV
044BA7  03 4F 04              ADD    cx, word ptr [bx + 4] ; ARITH
044BAA  8C D8                 MOV    ax, ds ; MOV
044BAC  8B FB                 MOV    di, bx ; MOV
044BAE  8E C0                 MOV    es, ax ; MOV
044BB0  C5 5F 16              LDS    bx, ptr [bx + 0x16] ; MOV_FAR
044BB3  8C D8                 MOV    ax, ds ; MOV
044BB5  0B C3                 OR     ax, bx ; LOGIC
