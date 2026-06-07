; ============================================================================
; func_06FF94_unknown
; Region   : overlay
; Bytes    : file 0x06FF94..0x070060  (204 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06FF94  C8 54 00 00           ENTER  0x54, 0 ; PROLOGUE
06FF98  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06FF9C  FF 36 FA 2E           PUSH   word ptr [0x2efa] ; PUSH_GLOBAL
06FFA0  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06FFA3  50                    PUSH   ax ; STACK_PUSH
06FFA4  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06FFA9  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06FFAC  68 FD 00              PUSH   0xfd ; PUSH_CONST
06FFAF  68 FE 00              PUSH   0xfe ; PUSH_CONST
06FFB2  6A 04                 PUSH   4 ; STACK_PUSH
06FFB4  68 40 01              PUSH   0x140 ; PUSH_CONST
06FFB7  6A 00                 PUSH   0 ; STACK_PUSH
06FFB9  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06FFBC  16                    PUSH   ss ; STACK_PUSH
06FFBD  50                    PUSH   ax ; STACK_PUSH
06FFBE  9A C8 01 1F 18        LCALL  0x181f, 0x1c8 ; THUNK -> 0x004B:0x0430 (thunk @file 0x01A7B8 type B) overlay @file 0x0607D8
06FFC3  83 C4 0E              ADD    sp, 0xe ; STACK_CLEANUP
06FFC6  6A 00                 PUSH   0 ; STACK_PUSH
06FFC8  68 40 01              PUSH   0x140 ; PUSH_CONST
06FFCB  6A 10                 PUSH   0x10 ; PUSH_CONST
06FFCD  2B C0                 SUB    ax, ax ; ARITH
06FFCF  99                    CDQ ; ARITH
06FFD0  2B DB                 SUB    bx, bx ; ARITH
06FFD2  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
06FFD7  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
06FFDB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06FFDE  50                    PUSH   ax ; STACK_PUSH
06FFDF  9A 1E 01 1F 18        LCALL  0x181f, 0x11e ; THUNK -> 0x004B:0x0072 (thunk @file 0x01A70E type B) overlay @file 0x06041A
06FFE4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
06FFE7  FF 36 FC 2E           PUSH   word ptr [0x2efc] ; PUSH_GLOBAL
06FFEB  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06FFEE  50                    PUSH   ax ; STACK_PUSH
06FFEF  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
06FFF4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06FFF7  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
06FFFA  50                    PUSH   ax ; STACK_PUSH
06FFFB  9A 28 01 1F 18        LCALL  0x181f, 0x128 ; THUNK -> 0x004B:0x0082 (thunk @file 0x01A718 type B) overlay @file 0x06042A
070000  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
070003  68 FE 00              PUSH   0xfe ; PUSH_CONST
070006  68 BE 00              PUSH   0xbe ; PUSH_CONST
070009  68 40 01              PUSH   0x140 ; PUSH_CONST
07000C  6A 00                 PUSH   0 ; STACK_PUSH
07000E  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
070011  16                    PUSH   ss ; STACK_PUSH
070012  50                    PUSH   ax ; STACK_PUSH
070013  9A 00 01 1F 18        LCALL  0x181f, 0x100 ; THUNK -> 0x004B:0x0318 (thunk @file 0x01A6F0 type B) overlay @file 0x0606C0
070018  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
07001B  68 B7 00              PUSH   0xb7 ; PUSH_CONST
07001E  68 40 01              PUSH   0x140 ; PUSH_CONST
070021  6A 10                 PUSH   0x10 ; PUSH_CONST
070023  2B C0                 SUB    ax, ax ; ARITH
070025  BA B7 00              MOV    dx, 0xb7 ; CONST_LOAD
070028  2B DB                 SUB    bx, bx ; ARITH
07002A  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
07002F  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0 ; LOCAL_STORE
070034  EB 1B                 JMP    0x70051 ; JUMP
070036  FF 46 AC              INC    word ptr [bp - 0x54] ; ARITH
070039  83 7E AC 03           CMP    word ptr [bp - 0x54], 3 ; CMP
07003D  7D 0F                 JGE    0x7004e ; CJUMP
07003F  FF 76 AC              PUSH   word ptr [bp - 0x54] ; PUSH_GLOBAL
070042  FF 76 AE              PUSH   word ptr [bp - 0x52] ; PUSH_GLOBAL
070045  0E                    PUSH   cs ; STACK_PUSH
070046  E8 02 0C              CALL   0x70c4b ; CALL_NEAR
070049  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
07004C  EB E8                 JMP    0x70036 ; JUMP
07004E  FF 46 AE              INC    word ptr [bp - 0x52] ; ARITH
070051  83 7E AE 04           CMP    word ptr [bp - 0x52], 4 ; CMP
070055  7D 07                 JGE    0x7005e ; CJUMP
070057  C7 46 AC 00 00        MOV    word ptr [bp - 0x54], 0 ; LOCAL_STORE
07005C  EB DB                 JMP    0x70039 ; JUMP
07005E  C9                    LEAVE ; EPILOGUE
07005F  CB                    RETF ; RETURN
