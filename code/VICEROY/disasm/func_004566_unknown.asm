; ============================================================================
; func_004566_unknown
; Region   : load_image
; Bytes    : file 0x004566..0x0046AC  (326 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004566  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
00456A  57                    PUSH   di ; STACK_PUSH
00456B  56                    PUSH   si ; STACK_PUSH
00456C  2B C0                 SUB    ax, ax ; ARITH
00456E  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
004571  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
004574  6A 01                 PUSH   1 ; STACK_PUSH
004576  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
004579  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
00457C  FF 76 0E              PUSH   word ptr [bp + 0xe] ; PUSH_GLOBAL
00457F  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
004582  9A FC 02 84 09        LCALL  0x984, 0x2fc ; LCALL
004587  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
00458A  8B 46 10              MOV    ax, word ptr [bp + 0x10] ; LOCAL_LOAD
00458D  3B 46 0C              CMP    ax, word ptr [bp + 0xc] ; CMP
004590  7E 03                 JLE    0x4595 ; CJUMP
004592  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
004595  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
004598  8B 46 12              MOV    ax, word ptr [bp + 0x12] ; LOCAL_LOAD
00459B  3B 46 0E              CMP    ax, word ptr [bp + 0xe] ; CMP
00459E  7E 03                 JLE    0x45a3 ; CJUMP
0045A0  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
0045A3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0045A6  A1 D4 5A              MOV    ax, word ptr [0x5ad4] ; GLOBAL_LOAD
0045A9  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
0045AC  BE 01 00              MOV    si, 1 ; MOV
0045AF  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0045B2  39 46 10              CMP    word ptr [bp + 0x10], ax ; CMP
0045B5  74 06                 JE     0x45bd ; CJUMP
0045B7  D1 66 EA              SHL    word ptr [bp - 0x16], 1 ; LOGIC
0045BA  BE 02 00              MOV    si, 2 ; MOV
0045BD  A1 26 83              MOV    ax, word ptr [0x8326] ; GLOBAL_LOAD
0045C0  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
0045C3  BF 01 00              MOV    di, 1 ; MOV
0045C6  8B 46 0E              MOV    ax, word ptr [bp + 0xe] ; LOCAL_LOAD
0045C9  39 46 12              CMP    word ptr [bp + 0x12], ax ; CMP
0045CC  74 06                 JE     0x45d4 ; CJUMP
0045CE  D1 66 E8              SHL    word ptr [bp - 0x18], 1 ; LOGIC
0045D1  BF 02 00              MOV    di, 2 ; MOV
0045D4  8A 0E 84 01           MOV    cl, byte ptr [0x184] ; GLOBAL_LOAD
0045D8  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
0045DB  D3 F8                 SAR    ax, cl ; LOGIC
0045DD  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0045E0  57                    PUSH   di ; STACK_PUSH
0045E1  56                    PUSH   si ; STACK_PUSH
0045E2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0045E5  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0045E8  9A 2C 03 1F 18        LCALL  0x181f, 0x32c ; THUNK -> 0x0000:0x00C8 (thunk @file 0x01A91C type A) overlay @file 0x0259C8
0045ED  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0045F0  57                    PUSH   di ; STACK_PUSH
0045F1  56                    PUSH   si ; STACK_PUSH
0045F2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0045F5  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0045F8  9A 44 03 1F 18        LCALL  0x181f, 0x344 ; THUNK -> 0x0000:0x04BC (thunk @file 0x01A934 type A) overlay @file 0x025DBC
0045FD  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
004600  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
004604  7C 59                 JL     0x465f ; CJUMP
004606  6B 5E 0A 1C           IMUL   bx, word ptr [bp + 0xa], 0x1c ; ARITH
00460A  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
00460E  2A E4                 SUB    ah, ah ; ARITH
004610  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
004613  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
004617  2A ED                 SUB    ch, ch ; ARITH
004619  89 4E E0              MOV    word ptr [bp - 0x20], cx ; LOCAL_STORE
00461C  6A 01                 PUSH   1 ; STACK_PUSH
00461E  6A 01                 PUSH   1 ; STACK_PUSH
004620  51                    PUSH   cx ; STACK_PUSH
004621  50                    PUSH   ax ; STACK_PUSH
004622  9A 2C 03 1F 18        LCALL  0x181f, 0x32c ; THUNK -> 0x0000:0x00C8 (thunk @file 0x01A91C type A) overlay @file 0x0259C8
004627  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00462A  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
00462D  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
004631  03 06 2C 83           ADD    ax, word ptr [0x832c] ; ARITH
004635  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
004639  05 08 00              ADD    ax, 8 ; ARITH
00463C  50                    PUSH   ax ; STACK_PUSH
00463D  FF 36 D4 5A           PUSH   word ptr [0x5ad4] ; PUSH_GLOBAL
004641  FF 36 86 01           PUSH   word ptr [0x186] ; PUSH_GLOBAL
004645  8B 46 E2              MOV    ax, word ptr [bp - 0x1e] ; LOCAL_LOAD
004648  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
00464C  03 06 2A 83           ADD    ax, word ptr [0x832a] ; ARITH
004650  F7 2E D4 5A           IMUL   word ptr [0x5ad4] ; ARITH
004654  8B D8                 MOV    bx, ax ; MOV
004656  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
004659  2B D2                 SUB    dx, dx ; ARITH
00465B  0E                    PUSH   cs ; STACK_PUSH
00465C  E8 0B F2              CALL   0x386a ; CALL_NEAR
00465F  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
004662  2B 06 2E 83           SUB    ax, word ptr [0x832e] ; ARITH
004666  03 06 2C 83           ADD    ax, word ptr [0x832c] ; ARITH
00466A  F7 2E 26 83           IMUL   word ptr [0x8326] ; ARITH
00466E  05 08 00              ADD    ax, 8 ; ARITH
004671  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
004674  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
004678  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00467C  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
004680  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
004684  FF 36 36 83           PUSH   word ptr [0x8336] ; PUSH_GLOBAL
004688  FF 36 34 83           PUSH   word ptr [0x8334] ; PUSH_GLOBAL
00468C  FF 36 32 83           PUSH   word ptr [0x8332] ; PUSH_GLOBAL
004690  FF 36 30 83           PUSH   word ptr [0x8330] ; PUSH_GLOBAL
004694  6A 00                 PUSH   0 ; STACK_PUSH
004696  FF 76 EA              PUSH   word ptr [bp - 0x16] ; PUSH_GLOBAL
004699  FF 76 E8              PUSH   word ptr [bp - 0x18] ; PUSH_GLOBAL
00469C  8B D0                 MOV    dx, ax ; MOV
00469E  A1 2A 83              MOV    ax, word ptr [0x832a] ; GLOBAL_LOAD
0046A1  2B 06 28 83           SUB    ax, word ptr [0x8328] ; ARITH
0046A5  03 46 FC              ADD    ax, word ptr [bp - 4] ; ARITH
0046A8  8B CA                 MOV    cx, dx ; MOV
0046AA  F7                    DB     0xF7 ; DATA_BYTE
0046AB  2E                    DB     0x2E ; DATA_BYTE
