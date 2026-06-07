; ============================================================================
; func_00A276_unknown
; Region   : load_image
; Bytes    : file 0x00A276..0x00A296  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00A276  55                    PUSH   bp ; STACK_PUSH
00A277  8B EC                 MOV    bp, sp ; MOV
00A279  A1 64 37              MOV    ax, word ptr [0x3764] ; GLOBAL_LOAD
00A27C  0B C0                 OR     ax, ax ; LOGIC
00A27E  74 1C                 JE     0xa29c ; CJUMP
00A280  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
00A282  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00A285  FF 1E 68 37           LCALL  [0x3768] ; LCALL
00A289  0A C0                 OR     al, al ; LOGIC
00A28B  75 0F                 JNE    0xa29c ; CJUMP
00A28D  80 FB B0              CMP    bl, 0xb0 ; CMP
00A290  75 0A                 JNE    0xa29c ; CJUMP
00A292  8B C2                 MOV    ax, dx ; MOV
00A294  C1                    DB     0xC1 ; DATA_BYTE
00A295  E0                    DB     0xE0 ; DATA_BYTE
