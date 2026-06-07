; ============================================================================
; func_00531C_unknown
; Region   : load_image
; Bytes    : file 0x00531C..0x005375  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00531C  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
005320  57                    PUSH   di ; STACK_PUSH
005321  56                    PUSH   si ; STACK_PUSH
005322  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005325  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
005328  8D 5E 06              LEA    bx, [bp + 6] ; ADDR
00532B  8B 46 16              MOV    ax, word ptr [bp + 0x16] ; LOCAL_LOAD
00532E  8B 56 18              MOV    dx, word ptr [bp + 0x18] ; LOCAL_LOAD
005331  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
005336  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
005339  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
00533C  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
00533F  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
005342  8D 5E 0E              LEA    bx, [bp + 0xe] ; ADDR
005345  8B 46 1A              MOV    ax, word ptr [bp + 0x1a] ; LOCAL_LOAD
005348  8B 56 1C              MOV    dx, word ptr [bp + 0x1c] ; LOCAL_LOAD
00534B  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
005350  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
005353  89 56 F2              MOV    word ptr [bp - 0xe], dx ; LOCAL_STORE
005356  1E                    PUSH   ds ; STACK_PUSH
005357  C5 76 F6              LDS    si, ptr [bp - 0xa] ; MOV_FAR
00535A  C4 7E F0              LES    di, ptr [bp - 0x10] ; MOV_FAR
00535D  33 D2                 XOR    dx, dx ; LOGIC
00535F  32 E4                 XOR    ah, ah ; LOGIC
005361  BB 00 00              MOV    bx, 0 ; MOV
005364  8B 4E 1E              MOV    cx, word ptr [bp + 0x1e] ; LOCAL_LOAD
005367  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
00536C  8A 46 20              MOV    al, byte ptr [bp + 0x20] ; LOCAL_LOAD
00536F  A8 03                 TEST   al, 3 ; LOGIC
005371  75 08                 JNE    0x537b ; CJUMP
005373  83                    DB     0x83 ; DATA_BYTE
005374  C3                    DB     0xC3 ; DATA_BYTE
