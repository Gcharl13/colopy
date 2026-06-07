; ============================================================================
; func_037340_unknown
; Region   : overlay
; Bytes    : file 0x037340..0x0373A4  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "REPORT"  (auto-named via string xrefs)
; ============================================================================

037340  C8 52 03 00           ENTER  0x352, 0 ; PROLOGUE
037344  68 A2 11              PUSH   0x11a2                       ; STRING: "REPORT"
037347  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03734A  50                    PUSH   ax ; STACK_PUSH
03734B  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
037350  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
037353  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
037356  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
037359  16                    PUSH   ss ; STACK_PUSH
03735A  50                    PUSH   ax ; STACK_PUSH
03735B  9A 82 01 1F 18        LCALL  0x181f, 0x182 ; THUNK -> 0x004B:0x012E (thunk @file 0x01A772 type B) overlay @file 0x0604D6
037360  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
037363  8D 86 AE FC           LEA    ax, [bp - 0x352] ; ADDR
037367  16                    PUSH   ss ; STACK_PUSH
037368  50                    PUSH   ax ; STACK_PUSH
037369  6A 00                 PUSH   0 ; STACK_PUSH
03736B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03736F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
037373  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
037377  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03737B  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
03737E  50                    PUSH   ax ; STACK_PUSH
03737F  9A 4E 04 1F 18        LCALL  0x181f, 0x44e ; THUNK -> 0x0000:0x000E (thunk @file 0x01AA3E type A) overlay @file 0x02590E
037384  83 C4 10              ADD    sp, 0x10 ; STACK_CLEANUP
037387  0B C0                 OR     ax, ax ; LOGIC
037389  74 19                 JE     0x373a4 ; CJUMP
03738B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
03738F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
037393  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
037397  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
03739B  B0 22                 MOV    al, 0x22 ; CONST_LOAD
03739D  9A 84 04 1F 18        LCALL  0x181f, 0x484 ; THUNK -> 0x0B8D:0x0004 (thunk @file 0x01AA74 type B)
0373A2  C9                    LEAVE ; EPILOGUE
0373A3  CB                    RETF ; RETURN
