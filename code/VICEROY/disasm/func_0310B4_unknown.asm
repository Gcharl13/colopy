; ============================================================================
; func_0310B4_unknown
; Region   : overlay
; Bytes    : file 0x0310B4..0x031109  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0310B4  C8 74 00 00           ENTER  0x74, 0 ; PROLOGUE
0310B8  56                    PUSH   si ; STACK_PUSH
0310B9  6A 15                 PUSH   0x15 ; PUSH_CONST
0310BB  68 40 01              PUSH   0x140 ; PUSH_CONST
0310BE  68 B3 00              PUSH   0xb3 ; PUSH_CONST
0310C1  6A 00                 PUSH   0 ; STACK_PUSH
0310C3  0E                    PUSH   cs ; STACK_PUSH
0310C4  E8 05 58              CALL   0x368cc ; CALL_NEAR
0310C7  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0310CA  C7 46 98 01 00        MOV    word ptr [bp - 0x68], 1 ; LOCAL_STORE
0310CF  C7 46 96 B5 00        MOV    word ptr [bp - 0x6a], 0xb5 ; LOCAL_STORE
0310D4  C7 46 8E 00 00        MOV    word ptr [bp - 0x72], 0 ; LOCAL_STORE
0310D9  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
0310DD  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
0310E1  FF 76 96              PUSH   word ptr [bp - 0x6a] ; PUSH_GLOBAL
0310E4  8B 46 8E              MOV    ax, word ptr [bp - 0x72] ; LOCAL_LOAD
0310E7  8B F0                 MOV    si, ax ; MOV
0310E9  8B C8                 MOV    cx, ax ; MOV
0310EB  D1 E6                 SHL    si, 1 ; LOGIC
0310ED  03 F1                 ADD    si, cx ; ARITH
0310EF  C1 E6 02              SHL    si, 2 ; LOGIC
0310F2  05 17 00              ADD    ax, 0x17 ; ARITH
0310F5  8B 56 98              MOV    dx, word ptr [bp - 0x68] ; LOCAL_LOAD
0310F8  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
0310FC  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; MOV
031101  D1 F9                 SAR    cx, 1 ; LOGIC
031103  2B D1                 SUB    dx, cx ; ARITH
031105  83 C2 09              ADD    dx, 9 ; ARITH
031108  89                    DB     0x89 ; DATA_BYTE
