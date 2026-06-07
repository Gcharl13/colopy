; ============================================================================
; func_02701C_unknown
; Region   : overlay
; Bytes    : file 0x02701C..0x0270D0  (180 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02701C  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
027020  56                    PUSH   si ; STACK_PUSH
027021  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027025  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027029  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
02702D  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
027031  68 80 00              PUSH   0x80 ; PUSH_CONST
027034  6A 00                 PUSH   0 ; STACK_PUSH
027036  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
027039  BA 07 00              MOV    dx, 7 ; MOV
02703C  BB C7 00              MOV    bx, 0xc7 ; CONST_LOAD
02703F  9A CE 00 1F 18        LCALL  0x181f, 0xce ; THUNK -> 0x0BCA:0x0002 (thunk @file 0x01A6BE type B)
027044  6A 07                 PUSH   7 ; STACK_PUSH
027046  6A 78                 PUSH   0x78 ; PUSH_CONST
027048  68 C7 00              PUSH   0xc7 ; PUSH_CONST
02704B  6A 08                 PUSH   8 ; STACK_PUSH
02704D  6A 00                 PUSH   0 ; STACK_PUSH
02704F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027053  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027057  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
02705B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
02705F  9A FC 04 1F 18        LCALL  0x181f, 0x4fc ; THUNK -> 0x02DD:0x0002 (thunk @file 0x01AAEC type B) overlay @file 0x033716
027064  83 C4 12              ADD    sp, 0x12 ; STACK_CLEANUP
027067  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
02706C  EB 0D                 JMP    0x2707b ; JUMP
02706E  52                    PUSH   dx ; STACK_PUSH
02706F  51                    PUSH   cx ; STACK_PUSH
027070  56                    PUSH   si ; STACK_PUSH
027071  0E                    PUSH   cs ; STACK_PUSH
027072  E8 6C 5A              CALL   0x2cae1 ; CALL_NEAR
027075  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
027078  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
02707B  83 7E F8 0F           CMP    word ptr [bp - 8], 0xf ; CMP
02707F  7D 33                 JGE    0x270b4 ; CJUMP
027081  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
027084  C1 E3 02              SHL    bx, 2 ; LOGIC
027087  8B 87 66 02           MOV    ax, word ptr [bx + 0x266] ; MOV
02708B  8B 8F 68 02           MOV    cx, word ptr [bx + 0x268] ; MOV
02708F  83 C1 08              ADD    cx, 8 ; ARITH
027092  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
027095  8A 97 62 8D           MOV    dl, byte ptr [bx - 0x729e] ; MOV
027099  2A F6                 SUB    dh, dh ; ARITH
02709B  8B F0                 MOV    si, ax ; MOV
02709D  8A 87 82 8E           MOV    al, byte ptr [bx - 0x717e] ; MOV
0270A1  98                    CWDE ; ARITH
0270A2  0B C0                 OR     ax, ax ; LOGIC
0270A4  7C C8                 JL     0x2706e ; CJUMP
0270A6  52                    PUSH   dx ; STACK_PUSH
0270A7  51                    PUSH   cx ; STACK_PUSH
0270A8  56                    PUSH   si ; STACK_PUSH
0270A9  50                    PUSH   ax ; STACK_PUSH
0270AA  0E                    PUSH   cs ; STACK_PUSH
0270AB  E8 75 59              CALL   0x2ca23 ; CALL_NEAR
0270AE  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
0270B1  EB C5                 JMP    0x27078 ; JUMP
0270B3  90                    NOP ; NOP
0270B4  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0270B8  74 13                 JE     0x270cd ; CJUMP
0270BA  6A 08                 PUSH   8 ; STACK_PUSH
0270BC  68 C7 00              PUSH   0xc7 ; PUSH_CONST
0270BF  6A 78                 PUSH   0x78 ; PUSH_CONST
0270C1  2B C0                 SUB    ax, ax ; ARITH
0270C3  BA 08 00              MOV    dx, 8 ; MOV
0270C6  2B DB                 SUB    bx, bx ; ARITH
0270C8  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
0270CD  5E                    POP    si ; STACK_POP
0270CE  C9                    LEAVE ; EPILOGUE
0270CF  CB                    RETF ; RETURN
