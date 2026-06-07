; ============================================================================
; func_00641A_unknown
; Region   : load_image
; Bytes    : file 0x00641A..0x006455  (59 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00641A  55                    PUSH   bp ; STACK_PUSH
00641B  8B EC                 MOV    bp, sp ; MOV
00641D  56                    PUSH   si ; STACK_PUSH
00641E  83 3E 6A 05 00        CMP    word ptr [0x56a], 0 ; CMP
006423  74 0A                 JE     0x642f ; CJUMP
006425  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
006428  26 F6 47 0A 20        TEST   byte ptr es:[bx + 0xa], 0x20 ; LOGIC
00642D  75 21                 JNE    0x6450 ; CJUMP
00642F  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
006432  26 FF 77 1A           PUSH   word ptr es:[bx + 0x1a] ; PUSH_GLOBAL
006436  26 FF 77 1C           PUSH   word ptr es:[bx + 0x1c] ; PUSH_GLOBAL
00643A  26 FF 77 1E           PUSH   word ptr es:[bx + 0x1e] ; PUSH_GLOBAL
00643E  26 8B 47 18           MOV    ax, word ptr es:[bx + 0x18] ; MOV
006442  8B D8                 MOV    bx, ax ; MOV
006444  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
006447  26 8B 54 1A           MOV    dx, word ptr es:[si + 0x1a] ; MOV
00644B  9A 44 00 34 0C        LCALL  0xc34, 0x44 ; LCALL
006450  5E                    POP    si ; STACK_POP
006451  C9                    LEAVE ; EPILOGUE
006452  C2 04 00              RET    4 ; RETURN
