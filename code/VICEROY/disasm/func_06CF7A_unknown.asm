; ============================================================================
; func_06CF7A_unknown
; Region   : overlay
; Bytes    : file 0x06CF7A..0x06CFB7  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06CF7A  55                    PUSH   bp ; STACK_PUSH
06CF7B  8B EC                 MOV    bp, sp ; MOV
06CF7D  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
06CF80  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
06CF83  05 84 00              ADD    ax, 0x84 ; ARITH
06CF86  52                    PUSH   dx ; STACK_PUSH
06CF87  50                    PUSH   ax ; STACK_PUSH
06CF88  B8 14 00              MOV    ax, 0x14 ; CONST_LOAD
06CF8B  99                    CDQ ; ARITH
06CF8C  9A 2C 00 1F 18        LCALL  0x181f, 0x2c ; THUNK -> 0x0000:0x0118 (thunk @file 0x01A61C type A) overlay @file 0x025A18
06CF91  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06CF94  26 89 47 64           MOV    word ptr es:[bx + 0x64], ax ; MOV
06CF98  26 89 57 66           MOV    word ptr es:[bx + 0x66], dx ; MOV
06CF9C  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06CF9F  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06CFA2  26 C4 5F 64           LES    bx, ptr es:[bx + 0x64] ; MOV_FAR
06CFA6  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
06CFAA  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx ; MOV
06CFAE  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
06CFB1  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
06CFB5  8B C3                 MOV    ax, bx ; MOV
