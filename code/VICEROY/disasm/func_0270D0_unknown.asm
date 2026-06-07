; ============================================================================
; func_0270D0_unknown
; Region   : overlay
; Bytes    : file 0x0270D0..0x0271C3  (243 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0270D0  C8 7E 00 00           ENTER  0x7e, 0 ; PROLOGUE
0270D4  57                    PUSH   di ; STACK_PUSH
0270D5  56                    PUSH   si ; STACK_PUSH
0270D6  6A 30                 PUSH   0x30 ; PUSH_CONST
0270D8  6A 78                 PUSH   0x78 ; PUSH_CONST
0270DA  68 82 00              PUSH   0x82 ; PUSH_CONST
0270DD  6A 00                 PUSH   0 ; STACK_PUSH
0270DF  0E                    PUSH   cs ; STACK_PUSH
0270E0  E8 E0 59              CALL   0x2cac3 ; CALL_NEAR
0270E3  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0270E6  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
0270EA  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
0270ED  98                    CWDE ; ARITH
0270EE  03 06 72 8D           ADD    ax, word ptr [0x8d72] ; ARITH
0270F2  89 46 98              MOV    word ptr [bp - 0x68], ax ; LOCAL_STORE
0270F5  C7 46 A4 01 00        MOV    word ptr [bp - 0x5c], 1 ; LOCAL_STORE
0270FA  C7 46 A0 8F 00        MOV    word ptr [bp - 0x60], 0x8f ; LOCAL_STORE
0270FF  2B C0                 SUB    ax, ax ; ARITH
027101  89 46 82              MOV    word ptr [bp - 0x7e], ax ; LOCAL_STORE
027104  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
027107  EB 32                 JMP    0x2713b ; JUMP
027109  90                    NOP ; NOP
02710A  50                    PUSH   ax ; STACK_PUSH
02710B  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
027110  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027113  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
027116  FF 76 92              PUSH   word ptr [bp - 0x6e] ; PUSH_GLOBAL
027119  9A 74 0A 1F 18        LCALL  0x181f, 0xa74 ; THUNK -> 0x05EB:0x0F1C (thunk @file 0x01B064 type B) overlay @file 0x027F0C
02711E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027121  89 46 9A              MOV    word ptr [bp - 0x66], ax ; LOCAL_STORE
027124  8B F0                 MOV    si, ax ; MOV
027126  D1 E6                 SHL    si, 1 ; LOGIC
027128  03 F0                 ADD    si, ax ; ARITH
02712A  C1 E6 02              SHL    si, 2 ; LOGIC
02712D  C4 1E 3E 08           LES    bx, ptr [0x83e] ; MOV_FAR
027131  26 8B 40 3E           MOV    ax, word ptr es:[bx + si + 0x3e] ; MOV
027135  01 46 82              ADD    word ptr [bp - 0x7e], ax ; ARITH
027138  FF 46 92              INC    word ptr [bp - 0x6e] ; ARITH
02713B  8B 46 92              MOV    ax, word ptr [bp - 0x6e] ; LOCAL_LOAD
02713E  39 46 98              CMP    word ptr [bp - 0x68], ax ; CMP
027141  7F C7                 JG     0x2710a ; CJUMP
027143  C6 06 90 A8 02        MOV    byte ptr [0xa890], 2 ; GLOBAL_LOAD
027148  C7 46 A6 04 00        MOV    word ptr [bp - 0x5a], 4 ; LOCAL_STORE
02714D  83 3E 72 8D 00        CMP    word ptr [0x8d72], 0 ; CMP
027152  75 0C                 JNE    0x27160 ; CJUMP
027154  C7 46 A6 00 00        MOV    word ptr [bp - 0x5a], 0 ; LOCAL_STORE
027159  EB 05                 JMP    0x27160 ; JUMP
02715B  90                    NOP ; NOP
02715C  FE 0E 90 A8           DEC    byte ptr [0xa890] ; ARITH
027160  A0 90 A8              MOV    al, byte ptr [0xa890] ; GLOBAL_LOAD
027163  98                    CWDE ; ARITH
027164  8B 4E 98              MOV    cx, word ptr [bp - 0x68] ; LOCAL_LOAD
027167  49                    DEC    cx ; ARITH
027168  F7 E9                 IMUL   cx ; ARITH
02716A  03 46 A6              ADD    ax, word ptr [bp - 0x5a] ; ARITH
02716D  03 46 82              ADD    ax, word ptr [bp - 0x7e] ; ARITH
027170  3D 60 00              CMP    ax, 0x60 ; CMP
027173  7D E7                 JGE    0x2715c ; CJUMP
027175  FF 46 A4              INC    word ptr [bp - 0x5c] ; ARITH
027178  FF 4E A0              DEC    word ptr [bp - 0x60] ; ARITH
02717B  2B C0                 SUB    ax, ax ; ARITH
02717D  89 46 AC              MOV    word ptr [bp - 0x54], ax ; LOCAL_STORE
027180  89 46 92              MOV    word ptr [bp - 0x6e], ax ; LOCAL_STORE
027183  E9 2D 01              JMP    0x272b3 ; JUMP
027186  C7 46 9C 0A 00        MOV    word ptr [bp - 0x64], 0xa ; LOCAL_STORE
02718B  83 3E 2E 03 01        CMP    word ptr [0x32e], 1 ; CMP
027190  75 0E                 JNE    0x271a0 ; CJUMP
027192  83 3E 34 03 00        CMP    word ptr [0x334], 0 ; CMP
027197  75 07                 JNE    0x271a0 ; CJUMP
027199  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02719E  74 51                 JE     0x271f1 ; CJUMP
0271A0  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
0271A5  74 07                 JE     0x271ae ; CJUMP
0271A7  83 3E 54 8D 00        CMP    word ptr [0x8d54], 0 ; CMP
0271AC  74 43                 JE     0x271f1 ; CJUMP
0271AE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0271B2  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0271B6  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0271BA  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0271BE  8B 5E 9A              MOV    bx, word ptr [bp - 0x66] ; LOCAL_LOAD
0271C1  8B C3                 MOV    ax, bx ; MOV
