; ============================================================================
; func_04AF5E_unknown
; Region   : overlay
; Bytes    : file 0x04AF5E..0x04AF9C  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04AF5E  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
04AF62  56                    PUSH   si ; STACK_PUSH
04AF63  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
04AF66  FF 36 52 8D           PUSH   word ptr [0x8d52] ; PUSH_GLOBAL
04AF6A  9A 0C 03 1F 18        LCALL  0x181f, 0x30c ; THUNK -> 0x05DC:0x00E0 (thunk @file 0x01A8FC type B) overlay @file 0x021AC2
04AF6F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04AF72  05 4B 00              ADD    ax, 0x4b ; ARITH
04AF75  99                    CDQ ; ARITH
04AF76  52                    PUSH   dx ; STACK_PUSH
04AF77  50                    PUSH   ax ; STACK_PUSH
04AF78  8B 1E 52 8D           MOV    bx, word ptr [0x8d52] ; GLOBAL_LOAD
04AF7C  8A 87 2A 96           MOV    al, byte ptr [bx - 0x69d6] ; MOV
04AF80  2A E4                 SUB    ah, ah ; ARITH
04AF82  8B C8                 MOV    cx, ax ; MOV
04AF84  C1 E0 03              SHL    ax, 3 ; LOGIC
04AF87  99                    CDQ ; ARITH
04AF88  8B F0                 MOV    si, ax ; MOV
04AF8A  8A 87 84 91           MOV    al, byte ptr [bx - 0x6e7c] ; MOV
04AF8E  C0 E8 02              SHR    al, 2 ; LOGIC
04AF91  25 FE 00              AND    ax, 0xfe ; LOGIC
04AF94  D1 E1                 SHL    cx, 1 ; LOGIC
04AF96  2B C1                 SUB    ax, cx ; ARITH
04AF98  8B CA                 MOV    cx, dx ; MOV
04AF9A  99                    CDQ ; ARITH
04AF9B  03                    DB     0x03 ; DATA_BYTE
