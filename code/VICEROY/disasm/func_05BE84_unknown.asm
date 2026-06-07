; ============================================================================
; func_05BE84_unknown
; Region   : overlay
; Bytes    : file 0x05BE84..0x05BEF5  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05BE84  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
05BE88  56                    PUSH   si ; STACK_PUSH
05BE89  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05BE8C  2D 04 00              SUB    ax, 4 ; ARITH
05BE8F  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
05BE92  50                    PUSH   ax ; STACK_PUSH
05BE93  9A 42 0A 1F 18        LCALL  0x181f, 0xa42 ; THUNK -> 0x05DC:0x0006 (thunk @file 0x01B032 type B) overlay @file 0x0219E8
05BE98  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05BE9B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
05BE9E  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
05BEA3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05BEA6  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05BEAA  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
05BEAD  2A E4                 SUB    ah, ah ; ARITH
05BEAF  89 46 DE              MOV    word ptr [bp - 0x22], ax ; LOCAL_STORE
05BEB2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
05BEB5  9A 1A 0A 1F 18        LCALL  0x181f, 0xa1a ; THUNK -> 0x05B3:0x0198 (thunk @file 0x01B00A type B) overlay @file 0x05FDC4
05BEBA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05BEBD  50                    PUSH   ax ; STACK_PUSH
05BEBE  6A 00                 PUSH   0 ; STACK_PUSH
05BEC0  9A 38 04 1F 18        LCALL  0x181f, 0x438 ; THUNK -> 0x0000:0x03EC (thunk @file 0x01AA28 type A) overlay @file 0x025CEC
05BEC5  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05BEC8  A1 42 85              MOV    ax, word ptr [0x8542] ; GLOBAL_LOAD
05BECB  40                    INC    ax ; ARITH
05BECC  40                    INC    ax ; ARITH
05BECD  1E                    PUSH   ds ; STACK_PUSH
05BECE  50                    PUSH   ax ; STACK_PUSH
05BECF  6A 01                 PUSH   1 ; STACK_PUSH
05BED1  9A 16 04 1F 18        LCALL  0x181f, 0x416 ; THUNK -> 0x0000:0x03D0 (thunk @file 0x01AA06 type A) overlay @file 0x025CD0
05BED6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
05BED9  6A 00                 PUSH   0 ; STACK_PUSH
05BEDB  9A B0 0A 1F 18        LCALL  0x181f, 0xab0 ; THUNK -> 0x05EB:0x039E (thunk @file 0x01B0A0 type B) overlay @file 0x02738E
05BEE0  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05BEE3  8B C8                 MOV    cx, ax ; MOV
05BEE5  D1 E0                 SHL    ax, 1 ; LOGIC
05BEE7  03 C1                 ADD    ax, cx ; ARITH
05BEE9  40                    INC    ax ; ARITH
05BEEA  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
05BEED  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
05BEF1  9A                    DB     0x9A ; DATA_BYTE
05BEF2  CA                    DB     0xCA ; DATA_BYTE
05BEF3  04                    DB     0x04 ; DATA_BYTE
05BEF4  1F                    DB     0x1F ; DATA_BYTE
