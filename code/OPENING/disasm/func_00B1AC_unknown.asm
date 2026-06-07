; ============================================================================
; func_00B1AC_unknown
; Region   : load_image
; Bytes    : file 0x00B1AC..0x00B1CC  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B1AC  55                    PUSH   bp ; STACK_PUSH
00B1AD  8B EC                 MOV    bp, sp ; MOV
00B1AF  A1 BA 39              MOV    ax, word ptr [0x39ba] ; GLOBAL_LOAD
00B1B2  0B C0                 OR     ax, ax ; LOGIC
00B1B4  74 1C                 JE     0xb1d2 ; CJUMP
00B1B6  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
00B1B8  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00B1BB  FF 1E BE 39           LCALL  [0x39be] ; LCALL
00B1BF  0A C0                 OR     al, al ; LOGIC
00B1C1  75 0F                 JNE    0xb1d2 ; CJUMP
00B1C3  80 FB B0              CMP    bl, 0xb0 ; CMP
00B1C6  75 0A                 JNE    0xb1d2 ; CJUMP
00B1C8  8B C2                 MOV    ax, dx ; MOV
00B1CA  C1                    DB     0xC1 ; DATA_BYTE
00B1CB  E0                    DB     0xE0 ; DATA_BYTE
