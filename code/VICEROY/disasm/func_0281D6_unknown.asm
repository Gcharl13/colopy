; ============================================================================
; func_0281D6_unknown
; Region   : overlay
; Bytes    : file 0x0281D6..0x02826A  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0281D6  C8 80 00 00           ENTER  0x80, 0 ; PROLOGUE
0281DA  56                    PUSH   si ; STACK_PUSH
0281DB  6A 15                 PUSH   0x15 ; PUSH_CONST
0281DD  68 40 01              PUSH   0x140 ; PUSH_CONST
0281E0  68 B3 00              PUSH   0xb3 ; PUSH_CONST
0281E3  6A 00                 PUSH   0 ; STACK_PUSH
0281E5  0E                    PUSH   cs ; STACK_PUSH
0281E6  E8 DA 48              CALL   0x2cac3 ; CALL_NEAR
0281E9  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0281EC  C7 46 92 01 00        MOV    word ptr [bp - 0x6e], 1 ; LOCAL_STORE
0281F1  C7 46 8E B5 00        MOV    word ptr [bp - 0x72], 0xb5 ; LOCAL_STORE
0281F6  C7 46 82 00 00        MOV    word ptr [bp - 0x7e], 0 ; LOCAL_STORE
0281FB  EB 34                 JMP    0x28231 ; JUMP
0281FD  90                    NOP ; NOP
0281FE  6A 0A                 PUSH   0xa ; PUSH_CONST
028200  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
028203  50                    PUSH   ax ; STACK_PUSH
028204  FF 76 8A              PUSH   word ptr [bp - 0x76] ; PUSH_GLOBAL
028207  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa ; LCALL
02820C  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02820F  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
028212  FF 76 84              PUSH   word ptr [bp - 0x7c] ; PUSH_GLOBAL
028215  8B 46 88              MOV    ax, word ptr [bp - 0x78] ; LOCAL_LOAD
028218  40                    INC    ax ; ARITH
028219  50                    PUSH   ax ; STACK_PUSH
02821A  8D 46 AA              LEA    ax, [bp - 0x56] ; ADDR
02821D  16                    PUSH   ss ; STACK_PUSH
02821E  50                    PUSH   ax ; STACK_PUSH
02821F  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
028224  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
028227  89 46 88              MOV    word ptr [bp - 0x78], ax ; LOCAL_STORE
02822A  83 46 92 13           ADD    word ptr [bp - 0x6e], 0x13 ; ARITH
02822E  FF 46 82              INC    word ptr [bp - 0x7e] ; ARITH
028231  83 7E 82 10           CMP    word ptr [bp - 0x7e], 0x10 ; CMP
028235  7C 03                 JL     0x2823a ; CJUMP
028237  E9 5A 01              JMP    0x28394 ; JUMP
02823A  FF 36 40 08           PUSH   word ptr [0x840] ; PUSH_GLOBAL
02823E  FF 36 3E 08           PUSH   word ptr [0x83e] ; PUSH_GLOBAL
028242  FF 76 8E              PUSH   word ptr [bp - 0x72] ; PUSH_GLOBAL
028245  8B 46 82              MOV    ax, word ptr [bp - 0x7e] ; LOCAL_LOAD
028248  8B F0                 MOV    si, ax ; MOV
02824A  8B C8                 MOV    cx, ax ; MOV
02824C  D1 E6                 SHL    si, 1 ; LOGIC
02824E  03 F1                 ADD    si, cx ; ARITH
028250  C1 E6 02              SHL    si, 2 ; LOGIC
028253  05 17 00              ADD    ax, 0x17 ; ARITH
028256  8B 56 92              MOV    dx, word ptr [bp - 0x6e] ; LOCAL_LOAD
028259  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
02825D  26 8B 88 52 01        MOV    cx, word ptr es:[bx + si + 0x152] ; MOV
028262  D1 F9                 SAR    cx, 1 ; LOGIC
028264  2B D1                 SUB    dx, cx ; ARITH
028266  83 C2 09              ADD    dx, 9 ; ARITH
028269  89                    DB     0x89 ; DATA_BYTE
