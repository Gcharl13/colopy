; ============================================================================
; func_00239E_unknown
; Region   : load_image
; Bytes    : file 0x00239E..0x0023CF  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00239E  55                    PUSH   bp ; STACK_PUSH
00239F  8B EC                 MOV    bp, sp ; MOV
0023A1  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0023A4  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0023A7  68 F4 3A              PUSH   0x3af4 ; PUSH_CONST
0023AA  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
0023AD  FF 36 BA 04           PUSH   word ptr [0x4ba] ; PUSH_GLOBAL
0023B1  FF 36 B8 04           PUSH   word ptr [0x4b8] ; PUSH_GLOBAL
0023B5  9A 48 00 0B 03        LCALL  0x30b, 0x48 ; LCALL
0023BA  8B E5                 MOV    sp, bp ; MOV
0023BC  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0023BF  05 0F 00              ADD    ax, 0xf ; ARITH
0023C2  50                    PUSH   ax ; STACK_PUSH
0023C3  6A 03                 PUSH   3 ; STACK_PUSH
0023C5  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
0023C8  6A 13                 PUSH   0x13 ; PUSH_CONST
0023CA  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0023CD  8B C3                 MOV    ax, bx ; MOV
