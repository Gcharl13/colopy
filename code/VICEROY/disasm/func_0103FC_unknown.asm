; ============================================================================
; func_0103FC_unknown
; Region   : load_image
; Bytes    : file 0x0103FC..0x010419  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0103FC  55                    PUSH   bp ; STACK_PUSH
0103FD  8B EC                 MOV    bp, sp ; MOV
0103FF  33 C0                 XOR    ax, ax ; LOGIC
010401  9A D0 03 1D 0D        LCALL  0xd1d, 0x3d0 ; LCALL
010406  FF 36 D3 27           PUSH   word ptr [0x27d3] ; PUSH_GLOBAL
01040A  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
01040D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
010410  9A 86 25 1D 0D        LCALL  0xd1d, 0x2586 ; LCALL
010415  8B E5                 MOV    sp, bp ; MOV
010417  5D                    POP    bp ; STACK_POP
010418  CB                    RETF ; RETURN
