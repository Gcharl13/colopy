; ============================================================================
; func_026374_unknown
; Region   : overlay
; Bytes    : file 0x026374..0x02640C  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026374  C8 0E 00 00           ENTER  0xe, 0 ; PROLOGUE
026378  56                    PUSH   si ; STACK_PUSH
026379  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02637D  8A 07                 MOV    al, byte ptr [bx] ; MOV
02637F  2A E4                 SUB    ah, ah ; ARITH
026381  A3 7C 01              MOV    word ptr [0x17c], ax ; GLOBAL_LOAD
026384  8A 47 01              MOV    al, byte ptr [bx + 1] ; MOV
026387  A3 7E 01              MOV    word ptr [0x17e], ax ; GLOBAL_LOAD
02638A  9A 5E 0C 1F 18        LCALL  0x181f, 0xc5e ; THUNK -> 0x05EB:0x0470 (thunk @file 0x01B24E type B) overlay @file 0x027460
02638F  8B D0                 MOV    dx, ax ; MOV
026391  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
026395  8A 47 1A              MOV    al, byte ptr [bx + 0x1a] ; MOV
026398  2A E4                 SUB    ah, ah ; ARITH
02639A  9A A4 08 1F 19        LCALL  0x191f, 0x8a4 ; THUNK -> 0x0000:0x10AE (thunk @file 0x01BE94 type A) overlay @file 0x0269AE
02639F  9A 96 08 1F 19        LCALL  0x191f, 0x896 ; THUNK -> 0x0000:0x0248 (thunk @file 0x01BE86 type A) overlay @file 0x025B48
0263A4  9A 88 08 1F 19        LCALL  0x191f, 0x888 ; THUNK -> 0x0000:0x00EA (thunk @file 0x01BE78 type A) overlay @file 0x0259EA
0263A9  6A 50                 PUSH   0x50 ; PUSH_CONST
0263AB  6A 50                 PUSH   0x50 ; PUSH_CONST
0263AD  6A 08                 PUSH   8 ; STACK_PUSH
0263AF  68 C8 00              PUSH   0xc8 ; PUSH_CONST
0263B2  6A 00                 PUSH   0 ; STACK_PUSH
0263B4  6A 00                 PUSH   0 ; STACK_PUSH
0263B6  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0263BA  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0263BE  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0263C2  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0263C6  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
0263CA  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
0263CE  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
0263D2  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
0263D6  9A 10 05 1F 18        LCALL  0x181f, 0x510 ; THUNK -> 0x02E9:0x008C (thunk @file 0x01AB00 type B)
0263DB  83 C4 1C              ADD    sp, 0x1c ; STACK_CLEANUP
0263DE  9A 5E 0C 1F 18        LCALL  0x181f, 0xc5e ; THUNK -> 0x05EB:0x0470 (thunk @file 0x01B24E type B) overlay @file 0x027460
0263E3  8B D8                 MOV    bx, ax ; MOV
0263E5  8A 87 29 03           MOV    al, byte ptr [bx + 0x329] ; MOV
0263E9  2A E4                 SUB    ah, ah ; ARITH
0263EB  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
0263EE  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0263F3  E9 A4 00              JMP    0x2649a ; JUMP
0263F6  8B D8                 MOV    bx, ax ; MOV
0263F8  8B C8                 MOV    cx, ax ; MOV
0263FA  8A 87 DE 00           MOV    al, byte ptr [bx + 0xde] ; MOV
0263FE  98                    CWDE ; ARITH
0263FF  8B 36 42 85           MOV    si, word ptr [0x8542] ; GLOBAL_LOAD
026403  8A 54 01              MOV    dl, byte ptr [si + 1] ; MOV
026406  2A F6                 SUB    dh, dh ; ARITH
026408  03 C2                 ADD    ax, dx ; ARITH
02640A  89                    DB     0x89 ; DATA_BYTE
02640B  46                    DB     0x46 ; DATA_BYTE
