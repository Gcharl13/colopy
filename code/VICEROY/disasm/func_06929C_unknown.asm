; ============================================================================
; func_06929C_unknown
; Region   : overlay
; Bytes    : file 0x06929C..0x069303  (103 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06929C  55                    PUSH   bp ; STACK_PUSH
06929D  8B EC                 MOV    bp, sp ; MOV
06929F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0692A3  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0692A7  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0692AB  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0692AF  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0692B3  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0692B7  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0692BB  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0692BF  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0692C2  2B C0                 SUB    ax, ax ; ARITH
0692C4  99                    CDQ ; ARITH
0692C5  BB 40 01              MOV    bx, 0x140 ; CONST_LOAD
0692C8  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
0692CD  9A 0A 04 1F 18        LCALL  0x181f, 0x40a ; THUNK -> 0x0000:0x37F6 (thunk @file 0x01A9FA type A) overlay @file 0x0290F6
0692D2  80 0E 56 1F 20        OR     byte ptr [0x1f56], 0x20 ; LOGIC
0692D7  A1 9E 08              MOV    ax, word ptr [0x89e] ; GLOBAL_LOAD
0692DA  8B 16 A0 08           MOV    dx, word ptr [0x8a0] ; GLOBAL_LOAD
0692DE  A3 9E 1F              MOV    word ptr [0x1f9e], ax ; GLOBAL_LOAD
0692E1  89 16 A0 1F           MOV    word ptr [0x1fa0], dx ; GLOBAL_LOAD
0692E5  8D 1E BE 1E           LEA    bx, [0x1ebe] ; ADDR
0692E9  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0692EC  2B D2                 SUB    dx, dx ; ARITH
0692EE  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
0692F3  A1 8A 26              MOV    ax, word ptr [0x268a] ; GLOBAL_LOAD
0692F6  8B 16 8C 26           MOV    dx, word ptr [0x268c] ; GLOBAL_LOAD
0692FA  A3 9E 1F              MOV    word ptr [0x1f9e], ax ; GLOBAL_LOAD
0692FD  89 16 A0 1F           MOV    word ptr [0x1fa0], dx ; GLOBAL_LOAD
069301  C9                    LEAVE ; EPILOGUE
069302  CB                    RETF ; RETURN
