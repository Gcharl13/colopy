; ============================================================================
; func_00C0D0_unknown
; Region   : load_image
; Bytes    : file 0x00C0D0..0x00C109  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C0D0  55                    PUSH   bp ; STACK_PUSH
00C0D1  8B EC                 MOV    bp, sp ; MOV
00C0D3  80 3E 4A 00 00        CMP    byte ptr [0x4a], 0 ; CMP
00C0D8  74 0E                 JE     0xc0e8 ; CJUMP
00C0DA  6A 00                 PUSH   0 ; STACK_PUSH
00C0DC  6A 00                 PUSH   0 ; STACK_PUSH
00C0DE  6A 00                 PUSH   0 ; STACK_PUSH
00C0E0  9A CC 02 09 00        LCALL  9, 0x2cc ; LCALL
00C0E5  EB 34                 JMP    0xc11b ; JUMP
00C0E7  90                    NOP ; NOP
00C0E8  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
00C0EC  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00C0F0  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
00C0F4  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
00C0F8  6A 07                 PUSH   7 ; STACK_PUSH
00C0FA  6A 00                 PUSH   0 ; STACK_PUSH
00C0FC  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00C0FF  99                    CDQ ; ARITH
00C100  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
00C103  9A 02 00 CA 0B        LCALL  0xbca, 2 ; LCALL
00C108  6A                    DB     0x6A ; DATA_BYTE
