; ============================================================================
; func_053820_unknown
; Region   : overlay
; Bytes    : file 0x053820..0x0538B6  (150 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053820  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
053824  56                    PUSH   si ; STACK_PUSH
053825  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
05382A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05382E  8A 07                 MOV    al, byte ptr [bx] ; MOV
053830  2A E4                 SUB    ah, ah ; ARITH
053832  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
053835  8A 4F 01              MOV    cl, byte ptr [bx + 1] ; MOV
053838  2A ED                 SUB    ch, ch ; ARITH
05383A  89 4E E4              MOV    word ptr [bp - 0x1c], cx ; LOCAL_STORE
05383D  51                    PUSH   cx ; STACK_PUSH
05383E  50                    PUSH   ax ; STACK_PUSH
05383F  9A 22 07 1F 18        LCALL  0x181f, 0x722 ; THUNK -> 0x037F:0x02A0 (thunk @file 0x01AD12 type B) overlay @file 0x02EDDC
053844  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
053847  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
05384A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
05384E  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
053851  2A E4                 SUB    ah, ah ; ARITH
053853  89 46 E2              MOV    word ptr [bp - 0x1e], ax ; LOCAL_STORE
053856  8B F0                 MOV    si, ax ; MOV
053858  C1 E6 04              SHL    si, 4 ; LOGIC
05385B  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
05385E  80 B8 E6 94 02        CMP    byte ptr [bx + si - 0x6b1a], 2 ; CMP
053863  73 03                 JAE    0x53868 ; CJUMP
053865  E9 C5 01              JMP    0x53a2d ; JUMP
053868  8B F0                 MOV    si, ax ; MOV
05386A  C1 E6 04              SHL    si, 4 ; LOGIC
05386D  8A 80 E6 94           MOV    al, byte ptr [bx + si - 0x6b1a] ; MOV
053871  48                    DEC    ax ; ARITH
053872  48                    DEC    ax ; ARITH
053873  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
053876  C7 46 E0 00 00        MOV    word ptr [bp - 0x20], 0 ; LOCAL_STORE
05387B  EB 28                 JMP    0x538a5 ; JUMP
05387D  90                    NOP ; NOP
05387E  8B 46 F0              MOV    ax, word ptr [bp - 0x10] ; LOCAL_LOAD
053881  2B 46 EA              SUB    ax, word ptr [bp - 0x16] ; ARITH
053884  F7 D0                 NOT    ax ; LOGIC
053886  40                    INC    ax ; ARITH
053887  3D 07 00              CMP    ax, 7 ; CMP
05388A  7C 5A                 JL     0x538e6 ; CJUMP
05388C  8B C1                 MOV    ax, cx ; MOV
05388E  2B 46 E4              SUB    ax, word ptr [bp - 0x1c] ; ARITH
053891  0B C0                 OR     ax, ax ; LOGIC
053893  7F 08                 JG     0x5389d ; CJUMP
053895  8B C1                 MOV    ax, cx ; MOV
053897  2B 46 E4              SUB    ax, word ptr [bp - 0x1c] ; ARITH
05389A  F7 D0                 NOT    ax ; LOGIC
05389C  40                    INC    ax ; ARITH
05389D  3D 07 00              CMP    ax, 7 ; CMP
0538A0  7C 44                 JL     0x538e6 ; CJUMP
0538A2  FF 46 E0              INC    word ptr [bp - 0x20] ; ARITH
0538A5  8B 46 E0              MOV    ax, word ptr [bp - 0x20] ; LOCAL_LOAD
0538A8  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
0538AC  7F 03                 JG     0x538b1 ; CJUMP
0538AE  E9 7C 01              JMP    0x53a2d ; JUMP
0538B1  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
0538B5  8A                    DB     0x8A ; DATA_BYTE
