; ============================================================================
; func_034AE0_unknown
; Region   : overlay
; Bytes    : file 0x034AE0..0x034B44  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034AE0  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
034AE4  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
034AE8  80 7F 01 01           CMP    byte ptr [bx + 1], 1 ; CMP
034AEC  7E 74                 JLE    0x34b62 ; CJUMP
034AEE  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
034AF1  25 FE 00              AND    ax, 0xfe ; LOGIC
034AF4  D1 E0                 SHL    ax, 1 ; LOGIC
034AF6  05 04 00              ADD    ax, 4 ; ARITH
034AF9  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
034AFC  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
034AFF  B9 90 01              MOV    cx, 0x190 ; CONST_LOAD
034B02  99                    CDQ ; ARITH
034B03  F7 F9                 IDIV   cx ; ARITH
034B05  8B C8                 MOV    cx, ax ; MOV
034B07  41                    INC    cx ; ARITH
034B08  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
034B0B  F7 E9                 IMUL   cx ; ARITH
034B0D  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
034B10  04 05                 ADD    al, 5 ; ARITH
034B12  3A 47 01              CMP    al, byte ptr [bx + 1] ; CMP
034B15  7D 4B                 JGE    0x34b62 ; CJUMP
034B17  8A 46 F8              MOV    al, byte ptr [bp - 8] ; LOCAL_LOAD
034B1A  38 47 01              CMP    byte ptr [bx + 1], al ; CMP
034B1D  7E 14                 JLE    0x34b33 ; CJUMP
034B1F  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
034B22  2A E4                 SUB    ah, ah ; ARITH
034B24  40                    INC    ax ; ARITH
034B25  50                    PUSH   ax ; STACK_PUSH
034B26  6A 01                 PUSH   1 ; STACK_PUSH
034B28  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
034B2D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034B30  48                    DEC    ax ; ARITH
034B31  74 11                 JE     0x34b44 ; CJUMP
034B33  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
034B37  8D 06 9C 10           LEA    ax, [0x109c] ; ADDR
034B3B  2B D2                 SUB    dx, dx ; ARITH
034B3D  9A 98 09 1F 18        LCALL  0x181f, 0x998 ; THUNK -> 0x0000:0x36CA (thunk @file 0x01AF88 type A) overlay @file 0x028FCA
034B42  C9                    LEAVE ; EPILOGUE
034B43  CB                    RETF ; RETURN
