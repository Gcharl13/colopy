; ============================================================================
; func_004ED4_unknown
; Region   : load_image
; Bytes    : file 0x004ED4..0x004F15  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004ED4  55                    PUSH   bp ; STACK_PUSH
004ED5  8B EC                 MOV    bp, sp ; MOV
004ED7  0B C0                 OR     ax, ax ; LOGIC
004ED9  74 0D                 JE     0x4ee8 ; CJUMP
004EDB  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
004EDE  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
004EE2  26 8B 57 04           MOV    dx, word ptr es:[bx + 4] ; MOV
004EE6  EB 1D                 JMP    0x4f05 ; JUMP
004EE8  0B D2                 OR     dx, dx ; LOGIC
004EEA  74 0E                 JE     0x4efa ; CJUMP
004EEC  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
004EEF  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
004EF3  26 8B 57 06           MOV    dx, word ptr es:[bx + 6] ; MOV
004EF7  EB 0C                 JMP    0x4f05 ; JUMP
004EF9  90                    NOP ; NOP
004EFA  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
004EFD  26 FF 77 0A           PUSH   word ptr es:[bx + 0xa] ; PUSH_GLOBAL
004F01  26 8B 57 02           MOV    dx, word ptr es:[bx + 2] ; MOV
004F05  26 8B 5F 08           MOV    bx, word ptr es:[bx + 8] ; MOV
004F09  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
004F0C  9A 06 00 6A 0D        LCALL  0xd6a, 6 ; LCALL
004F11  C9                    LEAVE ; EPILOGUE
004F12  C2 04 00              RET    4 ; RETURN
