; ============================================================================
; func_0246E2_unknown
; Region   : overlay
; Bytes    : file 0x0246E2..0x024725  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0246E2  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0246E6  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
0246EB  83 3E 90 53 00        CMP    word ptr [0x5390], 0 ; CMP
0246F0  75 06                 JNE    0x246f8 ; CJUMP
0246F2  C7 06 B0 97 01 00     MOV    word ptr [0x97b0], 1 ; GLOBAL_LOAD
0246F8  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
0246FD  05 14 00              ADD    ax, 0x14 ; ARITH
024700  83 D2 00              ADC    dx, 0 ; ARITH
024703  A3 EC 97              MOV    word ptr [0x97ec], ax ; GLOBAL_LOAD
024706  89 16 EE 97           MOV    word ptr [0x97ee], dx ; GLOBAL_LOAD
02470A  83 3E 90 53 01        CMP    word ptr [0x5390], 1 ; CMP
02470F  1B C0                 SBB    ax, ax ; ARITH
024711  F7 D8                 NEG    ax ; ARITH
024713  A3 9C 92              MOV    word ptr [0x929c], ax ; GLOBAL_LOAD
024716  9A CC 0D 1F 18        LCALL  0x181f, 0xdcc ; THUNK -> 0x0984:0x010A (thunk @file 0x01B3BC type B) overlay @file 0x032020
02471B  9A 7A 04 1F 18        LCALL  0x181f, 0x47a ; THUNK -> 0x0ACB:0x0030 (thunk @file 0x01AA6A type B) overlay @file 0x0318D2
024720  BB 40 00              MOV    bx, 0x40 ; CONST_LOAD
024723  8E C3                 MOV    es, bx ; MOV
