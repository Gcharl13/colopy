; ============================================================================
; func_06436C_unknown
; Region   : overlay
; Bytes    : file 0x06436C..0x0643B5  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06436C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
064370  6A 10                 PUSH   0x10 ; PUSH_CONST
064372  6A 01                 PUSH   1 ; STACK_PUSH
064374  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
064379  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
06437C  40                    INC    ax ; ARITH
06437D  40                    INC    ax ; ARITH
06437E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
064381  EB 64                 JMP    0x643e7 ; JUMP
064383  90                    NOP ; NOP
064384  A0 20 2D              MOV    al, byte ptr [0x2d20] ; GLOBAL_LOAD
064387  98                    CWDE ; ARITH
064388  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
06438B  7D 64                 JGE    0x643f1 ; CJUMP
06438D  A0 1E 2D              MOV    al, byte ptr [0x2d1e] ; GLOBAL_LOAD
064390  98                    CWDE ; ARITH
064391  3B 46 06              CMP    ax, word ptr [bp + 6] ; CMP
064394  7E 5B                 JLE    0x643f1 ; CJUMP
064396  A0 21 2D              MOV    al, byte ptr [0x2d21] ; GLOBAL_LOAD
064399  98                    CWDE ; ARITH
06439A  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
06439D  7D 52                 JGE    0x643f1 ; CJUMP
06439F  A0 1F 2D              MOV    al, byte ptr [0x2d1f] ; GLOBAL_LOAD
0643A2  98                    CWDE ; ARITH
0643A3  3B 46 08              CMP    ax, word ptr [bp + 8] ; CMP
0643A6  7E 49                 JLE    0x643f1 ; CJUMP
0643A8  FF 36 C6 85           PUSH   word ptr [0x85c6] ; PUSH_GLOBAL
0643AC  FF 36 C4 85           PUSH   word ptr [0x85c4] ; PUSH_GLOBAL
0643B0  FF 36 C2 85           PUSH   word ptr [0x85c2] ; PUSH_GLOBAL
0643B4  FF                    DB     0xFF ; DATA_BYTE
