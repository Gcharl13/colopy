; ============================================================================
; func_026022_unknown
; Region   : overlay
; Bytes    : file 0x026022..0x02613B  (281 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026022  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
026026  56                    PUSH   si ; STACK_PUSH
026027  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
02602B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
02602E  D1 E3                 SHL    bx, 1 ; LOGIC
026030  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
026034  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026037  50                    PUSH   ax ; STACK_PUSH
026038  8B F3                 MOV    si, bx ; MOV
02603A  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
02603F  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
026042  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026045  50                    PUSH   ax ; STACK_PUSH
026046  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
02604B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02604E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026051  50                    PUSH   ax ; STACK_PUSH
026052  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
026057  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02605A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02605E  FF B0 9A 00           PUSH   word ptr [bx + si + 0x9a] ; PUSH_GLOBAL
026062  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026065  16                    PUSH   ss ; STACK_PUSH
026066  50                    PUSH   ax ; STACK_PUSH
026067  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
02606C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02606F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026072  50                    PUSH   ax ; STACK_PUSH
026073  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
026078  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02607B  FF 36 2E 2E           PUSH   word ptr [0x2e2e] ; PUSH_GLOBAL
02607F  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
026082  50                    PUSH   ax ; STACK_PUSH
026083  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
026088  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02608B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
02608E  50                    PUSH   ax ; STACK_PUSH
02608F  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
026094  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
026097  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1 ; LOCAL_STORE
02609C  C7 46 AC B5 00        MOV    word ptr [bp - 0x54], 0xb5 ; LOCAL_STORE
0260A1  6B 46 06 13           IMUL   ax, word ptr [bp + 6], 0x13 ; ARITH
0260A5  05 0A 00              ADD    ax, 0xa ; ARITH
0260A8  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
0260AB  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
0260AF  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
0260B3  8D 4E B0              LEA    cx, [bp - 0x50] ; ADDR
0260B6  16                    PUSH   ss ; STACK_PUSH
0260B7  51                    PUSH   cx ; STACK_PUSH
0260B8  8B F0                 MOV    si, ax ; MOV
0260BA  2B C0                 SUB    ax, ax ; ARITH
0260BC  9A 04 02 1F 18        LCALL  0x181f, 0x204 ; THUNK -> 0x0C2A:0x0006 (thunk @file 0x01A7F4 type B)
0260C1  48                    DEC    ax ; ARITH
0260C2  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
0260C5  40                    INC    ax ; ARITH
0260C6  40                    INC    ax ; ARITH
0260C7  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
0260CA  8B C8                 MOV    cx, ax ; MOV
0260CC  2D 31 01              SUB    ax, 0x131 ; ARITH
0260CF  F7 D8                 NEG    ax ; ARITH
0260D1  50                    PUSH   ax ; STACK_PUSH
0260D2  6A 00                 PUSH   0 ; STACK_PUSH
0260D4  8B C1                 MOV    ax, cx ; MOV
0260D6  D1 F9                 SAR    cx, 1 ; LOGIC
0260D8  2B F1                 SUB    si, cx ; ARITH
0260DA  56                    PUSH   si ; STACK_PUSH
0260DB  8B F0                 MOV    si, ax ; MOV
0260DD  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
0260E2  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0260E5  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
0260E8  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0260EC  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0260F0  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0260F4  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0260F8  B8 07 00              MOV    ax, 7 ; MOV
0260FB  89 46 9E              MOV    word ptr [bp - 0x62], ax ; LOCAL_STORE
0260FE  50                    PUSH   ax ; STACK_PUSH
0260FF  6A 00                 PUSH   0 ; STACK_PUSH
026101  BA C1 00              MOV    dx, 0xc1 ; CONST_LOAD
026104  89 56 A8              MOV    word ptr [bp - 0x58], dx ; LOCAL_STORE
026107  8B DE                 MOV    bx, si ; MOV
026109  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
02610C  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
026111  6A 0F                 PUSH   0xf ; PUSH_CONST
026113  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
026116  BA 0F 00              MOV    dx, 0xf ; CONST_LOAD
026119  8B DA                 MOV    bx, dx ; MOV
02611B  9A F0 01 1F 18        LCALL  0x181f, 0x1f0 ; THUNK -> 0x0C28:0x000A (thunk @file 0x01A7E0 type B)
026120  FF 36 A0 08           PUSH   word ptr [0x8a0] ; PUSH_GLOBAL
026124  FF 36 9E 08           PUSH   word ptr [0x89e] ; PUSH_GLOBAL
026128  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
02612B  16                    PUSH   ss ; STACK_PUSH
02612C  50                    PUSH   ax ; STACK_PUSH
02612D  6A 00                 PUSH   0 ; STACK_PUSH
02612F  8B 46 AA              MOV    ax, word ptr [bp - 0x56] ; LOCAL_LOAD
026132  40                    INC    ax ; ARITH
026133  8D 1E A8 2D           LEA    bx, [0x2da8] ; ADDR
026137  BA C2 00              MOV    dx, 0xc2 ; CONST_LOAD
02613A  9A                    DB     0x9A ; DATA_BYTE
