; ============================================================================
; func_071246_unknown
; Region   : overlay
; Bytes    : file 0x071246..0x071350  (266 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

071246  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
07124A  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
07124F  1E                    PUSH   ds ; STACK_PUSH
071250  68 54 85              PUSH   0x8554 ; PUSH_CONST
071253  1E                    PUSH   ds ; STACK_PUSH
071254  68 54 85              PUSH   0x8554 ; PUSH_CONST
071257  1E                    PUSH   ds ; STACK_PUSH
071258  68 54 01              PUSH   0x154 ; PUSH_CONST
07125B  9A AA 0C 1F 1A        LCALL  0x1a1f, 0xcaa ; THUNK -> 0x0B32:0x005C (thunk @file 0x01D29A type B) overlay @file 0x040656
071260  1E                    PUSH   ds ; STACK_PUSH
071261  68 54 85              PUSH   0x8554 ; PUSH_CONST
071264  8D 1E 91 20           LEA    bx, [0x2091] ; ADDR
071268  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
07126D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
071270  0B C0                 OR     ax, ax ; LOGIC
071272  75 0A                 JNE    0x7127e ; CJUMP
071274  C7 06 58 01 01 00     MOV    word ptr [0x158], 1 ; GLOBAL_LOAD
07127A  E9 C0 00              JMP    0x7133d ; JUMP
07127D  90                    NOP ; NOP
07127E  50                    PUSH   ax ; STACK_PUSH
07127F  6A 01                 PUSH   1 ; STACK_PUSH
071281  6A 04                 PUSH   4 ; STACK_PUSH
071283  68 3A 85              PUSH   0x853a ; PUSH_CONST
071286  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
07128B  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
07128E  0B C0                 OR     ax, ax ; LOGIC
071290  75 0A                 JNE    0x7129c ; CJUMP
071292  C7 06 58 01 02 00     MOV    word ptr [0x158], 2 ; GLOBAL_LOAD
071298  E9 A2 00              JMP    0x7133d ; JUMP
07129B  90                    NOP ; NOP
07129C  A1 52 01              MOV    ax, word ptr [0x152] ; GLOBAL_LOAD
07129F  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0712A2  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
0712A5  6A 01                 PUSH   1 ; STACK_PUSH
0712A7  6A 02                 PUSH   2 ; STACK_PUSH
0712A9  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
0712AC  50                    PUSH   ax ; STACK_PUSH
0712AD  9A 0C 06 1D 0D        LCALL  0xd1d, 0x60c ; LCALL
0712B2  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0712B5  0B C0                 OR     ax, ax ; LOGIC
0712B7  74 D9                 JE     0x71292 ; CJUMP
0712B9  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
0712BC  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
0712C0  A3 A4 85              MOV    word ptr [0x85a4], ax ; GLOBAL_LOAD
0712C3  89 16 A6 85           MOV    word ptr [0x85a6], dx ; GLOBAL_LOAD
0712C7  83 3E 5A 01 00        CMP    word ptr [0x15a], 0 ; CMP
0712CC  75 67                 JNE    0x71335 ; CJUMP
0712CE  FF 36 5E 01           PUSH   word ptr [0x15e] ; PUSH_GLOBAL
0712D2  FF 36 5C 01           PUSH   word ptr [0x15c] ; PUSH_GLOBAL
0712D6  6A 00                 PUSH   0 ; STACK_PUSH
0712D8  6A 01                 PUSH   1 ; STACK_PUSH
0712DA  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
0712DD  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
0712E2  0B D0                 OR     dx, ax ; LOGIC
0712E4  75 08                 JNE    0x712ee ; CJUMP
0712E6  C7 06 58 01 04 00     MOV    word ptr [0x158], 4 ; GLOBAL_LOAD
0712EC  EB 4F                 JMP    0x7133d ; JUMP
0712EE  FF 36 62 01           PUSH   word ptr [0x162] ; PUSH_GLOBAL
0712F2  FF 36 60 01           PUSH   word ptr [0x160] ; PUSH_GLOBAL
0712F6  6A 00                 PUSH   0 ; STACK_PUSH
0712F8  6A 01                 PUSH   1 ; STACK_PUSH
0712FA  A1 A4 85              MOV    ax, word ptr [0x85a4] ; GLOBAL_LOAD
0712FD  8B 16 A6 85           MOV    dx, word ptr [0x85a6] ; GLOBAL_LOAD
071301  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
071304  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
071309  0B D0                 OR     dx, ax ; LOGIC
07130B  75 09                 JNE    0x71316 ; CJUMP
07130D  C7 06 58 01 05 00     MOV    word ptr [0x158], 5 ; GLOBAL_LOAD
071313  EB 28                 JMP    0x7133d ; JUMP
071315  90                    NOP ; NOP
071316  FF 36 66 01           PUSH   word ptr [0x166] ; PUSH_GLOBAL
07131A  FF 36 64 01           PUSH   word ptr [0x164] ; PUSH_GLOBAL
07131E  6A 00                 PUSH   0 ; STACK_PUSH
071320  6A 01                 PUSH   1 ; STACK_PUSH
071322  A1 A4 85              MOV    ax, word ptr [0x85a4] ; GLOBAL_LOAD
071325  8B 16 A6 85           MOV    dx, word ptr [0x85a6] ; GLOBAL_LOAD
071329  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
07132C  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
071331  0B D0                 OR     dx, ax ; LOGIC
071333  74 D8                 JE     0x7130d ; CJUMP
071335  2B C0                 SUB    ax, ax ; ARITH
071337  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
07133A  A3 58 01              MOV    word ptr [0x158], ax ; GLOBAL_LOAD
07133D  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
071341  74 08                 JE     0x7134b ; CJUMP
071343  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
071346  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
07134B  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
07134E  C9                    LEAVE ; EPILOGUE
07134F  CB                    RETF ; RETURN
