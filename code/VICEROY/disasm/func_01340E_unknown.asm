; ============================================================================
; func_01340E_unknown
; Region   : load_image
; Bytes    : file 0x01340E..0x01342E  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01340E  55                    PUSH   bp ; STACK_PUSH
01340F  8B EC                 MOV    bp, sp ; MOV
013411  A1 E4 26              MOV    ax, word ptr [0x26e4] ; GLOBAL_LOAD
013414  0B C0                 OR     ax, ax ; LOGIC
013416  74 1C                 JE     0x13434 ; CJUMP
013418  B4 10                 MOV    ah, 0x10 ; CONST_LOAD
01341A  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
01341D  FF 1E E8 26           LCALL  [0x26e8] ; LCALL
013421  0A C0                 OR     al, al ; LOGIC
013423  75 0F                 JNE    0x13434 ; CJUMP
013425  80 FB B0              CMP    bl, 0xb0 ; CMP
013428  75 0A                 JNE    0x13434 ; CJUMP
01342A  8B C2                 MOV    ax, dx ; MOV
01342C  C1                    DB     0xC1 ; DATA_BYTE
01342D  E0                    DB     0xE0 ; DATA_BYTE
