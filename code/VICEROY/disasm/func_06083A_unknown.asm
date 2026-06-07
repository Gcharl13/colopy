; ============================================================================
; func_06083A_unknown
; Region   : overlay
; Bytes    : file 0x06083A..0x060955  (283 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06083A  C8 60 00 00           ENTER  0x60, 0 ; PROLOGUE
06083E  56                    PUSH   si ; STACK_PUSH
06083F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
060843  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
060847  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
06084B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
06084F  B0 22                 MOV    al, 0x22 ; CONST_LOAD
060851  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
060856  FF 36 DE 93           PUSH   word ptr [0x93de] ; PUSH_GLOBAL
06085A  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
06085F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060862  52                    PUSH   dx ; STACK_PUSH
060863  50                    PUSH   ax ; STACK_PUSH
060864  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
060867  16                    PUSH   ss ; STACK_PUSH
060868  50                    PUSH   ax ; STACK_PUSH
060869  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
06086E  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
060871  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
060874  50                    PUSH   ax ; STACK_PUSH
060875  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
06087A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06087D  A1 14 9E              MOV    ax, word ptr [0x9e14] ; GLOBAL_LOAD
060880  2D 00 00              SUB    ax, 0 ; ARITH
060883  B9 4A 00              MOV    cx, 0x4a ; CONST_LOAD
060886  99                    CDQ ; ARITH
060887  F7 F9                 IDIV   cx ; ARITH
060889  40                    INC    ax ; ARITH
06088A  50                    PUSH   ax ; STACK_PUSH
06088B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06088E  16                    PUSH   ss ; STACK_PUSH
06088F  50                    PUSH   ax ; STACK_PUSH
060890  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
060895  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
060898  6A 0F                 PUSH   0xf ; PUSH_CONST
06089A  6A 05                 PUSH   5 ; STACK_PUSH
06089C  68 40 01              PUSH   0x140 ; PUSH_CONST
06089F  6A 00                 PUSH   0 ; STACK_PUSH
0608A1  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0608A4  16                    PUSH   ss ; STACK_PUSH
0608A5  50                    PUSH   ax ; STACK_PUSH
0608A6  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
0608AB  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
0608AE  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
0608B2  FF 36 E0 93           PUSH   word ptr [0x93e0] ; PUSH_GLOBAL
0608B6  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0608B9  50                    PUSH   ax ; STACK_PUSH
0608BA  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
0608BF  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0608C2  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0608C5  50                    PUSH   ax ; STACK_PUSH
0608C6  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
0608CB  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0608CE  6A 0F                 PUSH   0xf ; PUSH_CONST
0608D0  6A 19                 PUSH   0x19 ; PUSH_CONST
0608D2  B8 0A 00              MOV    ax, 0xa ; CONST_LOAD
0608D5  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
0608D8  50                    PUSH   ax ; STACK_PUSH
0608D9  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0608DC  16                    PUSH   ss ; STACK_PUSH
0608DD  50                    PUSH   ax ; STACK_PUSH
0608DE  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0608E3  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0608E6  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
0608E9  6A 0F                 PUSH   0xf ; PUSH_CONST
0608EB  6A 19                 PUSH   0x19 ; PUSH_CONST
0608ED  50                    PUSH   ax ; STACK_PUSH
0608EE  FF 36 16 9E           PUSH   word ptr [0x9e16] ; PUSH_GLOBAL
0608F2  FF 36 14 9E           PUSH   word ptr [0x9e14] ; PUSH_GLOBAL
0608F6  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
0608FB  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
0608FE  C4 1E 9E 08           LES    bx, ptr [0x89e] ; MOV_FAR
060902  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
060905  2A E4                 SUB    ah, ah ; ARITH
060907  05 1B 00              ADD    ax, 0x1b ; ARITH
06090A  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
06090D  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
060911  FF 36 E2 93           PUSH   word ptr [0x93e2] ; PUSH_GLOBAL
060915  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
060918  50                    PUSH   ax ; STACK_PUSH
060919  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06091E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060921  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
060924  50                    PUSH   ax ; STACK_PUSH
060925  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
06092A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06092D  6A 0F                 PUSH   0xf ; PUSH_CONST
06092F  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
060932  6A 0A                 PUSH   0xa ; PUSH_CONST
060934  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
060937  16                    PUSH   ss ; STACK_PUSH
060938  50                    PUSH   ax ; STACK_PUSH
060939  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
06093E  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
060941  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
060945  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060949  26 80 7F 20 01        CMP    byte ptr es:[bx + 0x20], 1 ; CMP
06094E  1B DB                 SBB    bx, bx ; ARITH
060950  83 E3 01              AND    bx, 1 ; LOGIC
060953  83                    DB     0x83 ; DATA_BYTE
060954  C3                    DB     0xC3 ; DATA_BYTE
