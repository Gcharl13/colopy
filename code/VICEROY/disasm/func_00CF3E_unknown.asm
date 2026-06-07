; ============================================================================
; func_00CF3E_unknown
; Region   : load_image
; Bytes    : file 0x00CF3E..0x00CFC4  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CF3E  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
00CF42  06                    PUSH   es ; STACK_PUSH
00CF43  57                    PUSH   di ; STACK_PUSH
00CF44  56                    PUSH   si ; STACK_PUSH
00CF45  83 3E F8 92 00        CMP    word ptr [0x92f8], 0 ; CMP
00CF4A  74 5A                 JE     0xcfa6 ; CJUMP
00CF4C  80 3E 99 A8 00        CMP    byte ptr [0xa899], 0 ; CMP
00CF51  75 53                 JNE    0xcfa6 ; CJUMP
00CF53  BE 10 00              MOV    si, 0x10 ; CONST_LOAD
00CF56  2B 36 A4 05           SUB    si, word ptr [0x5a4] ; ARITH
00CF5A  BF 10 00              MOV    di, 0x10 ; CONST_LOAD
00CF5D  2B 3E A6 05           SUB    di, word ptr [0x5a6] ; ARITH
00CF61  8B 0E 94 05           MOV    cx, word ptr [0x594] ; GLOBAL_LOAD
00CF65  3B 0E B4 05           CMP    cx, word ptr [0x5b4] ; CMP
00CF69  7F 3B                 JG     0xcfa6 ; CJUMP
00CF6B  8B D1                 MOV    dx, cx ; MOV
00CF6D  03 D6                 ADD    dx, si ; ARITH
00CF6F  4A                    DEC    dx ; ARITH
00CF70  3B 16 B2 05           CMP    dx, word ptr [0x5b2] ; CMP
00CF74  7C 30                 JL     0xcfa6 ; CJUMP
00CF76  A1 96 05              MOV    ax, word ptr [0x596] ; GLOBAL_LOAD
00CF79  3B 06 B8 05           CMP    ax, word ptr [0x5b8] ; CMP
00CF7D  7F 27                 JG     0xcfa6 ; CJUMP
00CF7F  8B D8                 MOV    bx, ax ; MOV
00CF81  03 DF                 ADD    bx, di ; ARITH
00CF83  4B                    DEC    bx ; ARITH
00CF84  3B 1E B6 05           CMP    bx, word ptr [0x5b6] ; CMP
00CF88  7C 1C                 JL     0xcfa6 ; CJUMP
00CF8A  2B 06 B6 05           SUB    ax, word ptr [0x5b6] ; ARITH
00CF8E  7C 1C                 JL     0xcfac ; CJUMP
00CF90  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00CF93  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00CF98  2B 1E B8 05           SUB    bx, word ptr [0x5b8] ; ARITH
00CF9C  7F 22                 JG     0xcfc0 ; CJUMP
00CF9E  8B C7                 MOV    ax, di ; MOV
00CFA0  88 46 FA              MOV    byte ptr [bp - 6], al ; LOCAL_STORE
00CFA3  EB 22                 JMP    0xcfc7 ; JUMP
00CFA5  90                    NOP ; NOP
00CFA6  B8 00 00              MOV    ax, 0 ; MOV
00CFA9  E9 CC 00              JMP    0xd078 ; JUMP
00CFAC  8B D8                 MOV    bx, ax ; MOV
00CFAE  F7 D8                 NEG    ax ; ARITH
00CFB0  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00CFB3  03 DF                 ADD    bx, di ; ARITH
00CFB5  88 5E FA              MOV    byte ptr [bp - 6], bl ; LOCAL_STORE
00CFB8  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0 ; LOCAL_STORE
00CFBD  EB 08                 JMP    0xcfc7 ; JUMP
00CFBF  90                    NOP ; NOP
00CFC0  8B C7                 MOV    ax, di ; MOV
00CFC2  2B C3                 SUB    ax, bx ; ARITH
