; ============================================================================
; func_030F76_unknown
; Region   : overlay
; Bytes    : file 0x030F76..0x0310B4  (318 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030F76  C8 64 00 00           ENTER  0x64, 0 ; PROLOGUE
030F7A  8B 1E 12 9E           MOV    bx, word ptr [0x9e12] ; GLOBAL_LOAD
030F7E  D1 E3                 SHL    bx, 1 ; LOGIC
030F80  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
030F84  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
030F89  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030F8C  52                    PUSH   dx ; STACK_PUSH
030F8D  50                    PUSH   ax ; STACK_PUSH
030F8E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030F91  16                    PUSH   ss ; STACK_PUSH
030F92  50                    PUSH   ax ; STACK_PUSH
030F93  9A 7E 11 1D 0D        LCALL  0xd1d, 0x117e ; LCALL
030F98  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
030F9B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030F9E  50                    PUSH   ax ; STACK_PUSH
030F9F  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
030FA4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030FA7  8B 1E 12 9E           MOV    bx, word ptr [0x9e12] ; GLOBAL_LOAD
030FAB  D1 E3                 SHL    bx, 1 ; LOGIC
030FAD  FF B7 42 8D           PUSH   word ptr [bx - 0x72be] ; PUSH_GLOBAL
030FB1  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
030FB6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030FB9  52                    PUSH   dx ; STACK_PUSH
030FBA  50                    PUSH   ax ; STACK_PUSH
030FBB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030FBE  16                    PUSH   ss ; STACK_PUSH
030FBF  50                    PUSH   ax ; STACK_PUSH
030FC0  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
030FC5  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
030FC8  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030FCB  50                    PUSH   ax ; STACK_PUSH
030FCC  9A DC 01 1F 18        LCALL  0x181f, 0x1dc ; THUNK -> 0x004B:0x0052 (thunk @file 0x01A7CC type B) overlay @file 0x0603FA
030FD1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030FD4  8B 1E 8C 53           MOV    bx, word ptr [0x538c] ; GLOBAL_LOAD
030FD8  D1 E3                 SHL    bx, 1 ; LOGIC
030FDA  FF B7 00 98           PUSH   word ptr [bx - 0x6800] ; PUSH_GLOBAL
030FDE  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
030FE3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
030FE6  52                    PUSH   dx ; STACK_PUSH
030FE7  50                    PUSH   ax ; STACK_PUSH
030FE8  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030FEB  16                    PUSH   ss ; STACK_PUSH
030FEC  50                    PUSH   ax ; STACK_PUSH
030FED  9A B4 11 1D 0D        LCALL  0xd1d, 0x11b4 ; LCALL
030FF2  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
030FF5  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
030FF8  50                    PUSH   ax ; STACK_PUSH
030FF9  9A B4 01 1F 18        LCALL  0x181f, 0x1b4 ; THUNK -> 0x004B:0x0032 (thunk @file 0x01A7A4 type B) overlay @file 0x0603DA
030FFE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031001  6A 0A                 PUSH   0xa ; PUSH_CONST
031003  8D 46 9C              LEA    ax, [bp - 0x64] ; ADDR
031006  50                    PUSH   ax ; STACK_PUSH
031007  FF 36 8A 53           PUSH   word ptr [0x538a] ; PUSH_GLOBAL
03100B  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
031010  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
031013  8D 46 9C              LEA    ax, [bp - 0x64] ; ADDR
031016  50                    PUSH   ax ; STACK_PUSH
031017  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03101A  50                    PUSH   ax ; STACK_PUSH
03101B  9A A4 07 1D 0D        LCALL  0xd1d, 0x7a4 ; LCALL
031020  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031023  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031026  50                    PUSH   ax ; STACK_PUSH
031027  9A DC 01 1F 18        LCALL  0x181f, 0x1dc ; THUNK -> 0x004B:0x0052 (thunk @file 0x01A7CC type B) overlay @file 0x0603FA
03102C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03102F  FF 36 B0 93           PUSH   word ptr [0x93b0] ; PUSH_GLOBAL
031033  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031036  50                    PUSH   ax ; STACK_PUSH
031037  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
03103C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03103F  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
031043  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
031046  98                    CWDE ; ARITH
031047  50                    PUSH   ax ; STACK_PUSH
031048  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03104B  16                    PUSH   ss ; STACK_PUSH
03104C  50                    PUSH   ax ; STACK_PUSH
03104D  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
031052  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
031055  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031058  50                    PUSH   ax ; STACK_PUSH
031059  9A 0A 01 1F 18        LCALL  0x181f, 0x10a ; THUNK -> 0x004B:0x0062 (thunk @file 0x01A6FA type B) overlay @file 0x06040A
03105E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031061  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031064  50                    PUSH   ax ; STACK_PUSH
031065  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
03106A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03106D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031070  50                    PUSH   ax ; STACK_PUSH
031071  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
031076  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031079  FF 36 A0 93           PUSH   word ptr [0x93a0] ; PUSH_GLOBAL
03107D  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031080  50                    PUSH   ax ; STACK_PUSH
031081  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
031086  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
031089  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03108C  50                    PUSH   ax ; STACK_PUSH
03108D  9A 78 01 1F 18        LCALL  0x181f, 0x178 ; THUNK -> 0x004B:0x0000 (thunk @file 0x01A768 type B) overlay @file 0x0603A8
031092  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
031095  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
031098  50                    PUSH   ax ; STACK_PUSH
031099  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
03109D  9A 1E 0B 1F 18        LCALL  0x181f, 0xb1e ; THUNK -> 0x05EB:0x05B2 (thunk @file 0x01B10E type B) overlay @file 0x0275A2
0310A2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0310A5  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
0310A8  16                    PUSH   ss ; STACK_PUSH
0310A9  50                    PUSH   ax ; STACK_PUSH
0310AA  FF 76 04              PUSH   word ptr [bp + 4] ; STACK_PUSH
0310AD  9A B0 00 1F 18        LCALL  0x181f, 0xb0 ; THUNK -> 0x0009:0x02CC (thunk @file 0x01A6A0 type B) overlay @file 0x022A96
0310B2  C9                    LEAVE ; EPILOGUE
0310B3  C3                    RET ; RETURN
