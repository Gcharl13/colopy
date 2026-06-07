; ============================================================================
; func_005B08_unknown
; Region   : load_image
; Bytes    : file 0x005B08..0x005B45  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005B08  55                    PUSH   bp ; STACK_PUSH
005B09  8B EC                 MOV    bp, sp ; MOV
005B0B  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
005B0E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
005B11  05 84 00              ADD    ax, 0x84 ; ARITH
005B14  52                    PUSH   dx ; STACK_PUSH
005B15  50                    PUSH   ax ; STACK_PUSH
005B16  B8 14 00              MOV    ax, 0x14 ; CONST_LOAD
005B19  99                    CDQ ; ARITH
005B1A  9A 0A 01 45 0F        LCALL  0xf45, 0x10a ; LCALL
005B1F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
005B22  26 89 47 64           MOV    word ptr es:[bx + 0x64], ax ; MOV
005B26  26 89 57 66           MOV    word ptr es:[bx + 0x66], dx ; MOV
005B2A  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
005B2D  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
005B30  26 C4 5F 64           LES    bx, ptr es:[bx + 0x64] ; MOV_FAR
005B34  26 89 47 0C           MOV    word ptr es:[bx + 0xc], ax ; MOV
005B38  26 89 57 0E           MOV    word ptr es:[bx + 0xe], dx ; MOV
005B3C  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
005B3F  26 89 47 04           MOV    word ptr es:[bx + 4], ax ; MOV
005B43  8B C3                 MOV    ax, bx ; MOV
