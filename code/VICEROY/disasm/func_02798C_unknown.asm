; ============================================================================
; func_02798C_unknown
; Region   : overlay
; Bytes    : file 0x02798C..0x027ADA  (334 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02798C  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
027990  57                    PUSH   di ; STACK_PUSH
027991  56                    PUSH   si ; STACK_PUSH
027992  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
027995  25 01 00              AND    ax, 1 ; LOGIC
027998  75 14                 JNE    0x279ae ; CJUMP
02799A  C6 46 FC 0F           MOV    byte ptr [bp - 4], 0xf ; LOCAL_STORE
02799E  C7 46 FA FF FF        MOV    word ptr [bp - 6], 0xffff ; LOCAL_STORE
0279A3  C6 46 F4 39           MOV    byte ptr [bp - 0xc], 0x39 ; LOCAL_STORE
0279A7  C6 46 FE 30           MOV    byte ptr [bp - 2], 0x30 ; LOCAL_STORE
0279AB  EB 12                 JMP    0x279bf ; JUMP
0279AD  90                    NOP ; NOP
0279AE  C6 46 FC 00           MOV    byte ptr [bp - 4], 0 ; LOCAL_STORE
0279B2  C7 46 FA 0F 00        MOV    word ptr [bp - 6], 0xf ; LOCAL_STORE
0279B7  C6 46 F4 30           MOV    byte ptr [bp - 0xc], 0x30 ; LOCAL_STORE
0279BB  C6 46 FE 39           MOV    byte ptr [bp - 2], 0x39 ; LOCAL_STORE
0279BF  8D 46 F6              LEA    ax, [bp - 0xa] ; ADDR
0279C2  50                    PUSH   ax ; STACK_PUSH
0279C3  8D 4E F8              LEA    cx, [bp - 8] ; ADDR
0279C6  51                    PUSH   cx ; STACK_PUSH
0279C7  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0279CA  0E                    PUSH   cs ; STACK_PUSH
0279CB  E8 F1 4F              CALL   0x2c9bf ; CALL_NEAR
0279CE  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0279D1  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0279D4  05 03 00              ADD    ax, 3 ; ARITH
0279D7  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
0279DA  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0279DD  40                    INC    ax ; ARITH
0279DE  40                    INC    ax ; ARITH
0279DF  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
0279E2  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0279E6  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0279EA  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0279EE  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0279F2  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
0279F5  50                    PUSH   ax ; STACK_PUSH
0279F6  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0279F9  8B D0                 MOV    dx, ax ; MOV
0279FB  03 56 F8              ADD    dx, word ptr [bp - 8] ; ARITH
0279FE  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
027A01  03 5E F6              ADD    bx, word ptr [bp - 0xa] ; ARITH
027A04  4B                    DEC    bx ; ARITH
027A05  4A                    DEC    dx ; ARITH
027A06  8B F0                 MOV    si, ax ; MOV
027A08  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
027A0D  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027A11  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027A15  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
027A19  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
027A1D  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
027A20  50                    PUSH   ax ; STACK_PUSH
027A21  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
027A24  03 46 F8              ADD    ax, word ptr [bp - 8] ; ARITH
027A27  48                    DEC    ax ; ARITH
027A28  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
027A2B  03 5E F6              ADD    bx, word ptr [bp - 0xa] ; ARITH
027A2E  8D 5F FF              LEA    bx, [bx - 1] ; ADDR
027A31  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
027A34  8B FA                 MOV    di, dx ; MOV
027A36  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
027A3B  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027A3F  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027A43  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
027A47  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
027A4B  8A 46 F4              MOV    al, byte ptr [bp - 0xc] ; LOCAL_LOAD
027A4E  50                    PUSH   ax ; STACK_PUSH
027A4F  8B DF                 MOV    bx, di ; MOV
027A51  8B C6                 MOV    ax, si ; MOV
027A53  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
027A56  03 56 F8              ADD    dx, word ptr [bp - 8] ; ARITH
027A59  4A                    DEC    dx ; ARITH
027A5A  9A BC 08 1F 19        LCALL  0x191f, 0x8bc ; THUNK -> 0x0BBC:0x000C (thunk @file 0x01BEAC type B)
027A5F  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027A63  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027A67  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
027A6B  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
027A6F  8A 46 F4              MOV    al, byte ptr [bp - 0xc] ; LOCAL_LOAD
027A72  50                    PUSH   ax ; STACK_PUSH
027A73  8B C6                 MOV    ax, si ; MOV
027A75  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
027A78  03 5E F6              ADD    bx, word ptr [bp - 0xa] ; ARITH
027A7B  4B                    DEC    bx ; ARITH
027A7C  8B D7                 MOV    dx, di ; MOV
027A7E  9A B2 08 1F 19        LCALL  0x191f, 0x8b2 ; THUNK -> 0x0BC3:0x0006 (thunk @file 0x01BEA2 type B)
027A83  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
027A87  7C 2C                 JL     0x27ab5 ; CJUMP
027A89  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
027A8D  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
027A91  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
027A95  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
027A99  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
027A9C  48                    DEC    ax ; ARITH
027A9D  48                    DEC    ax ; ARITH
027A9E  50                    PUSH   ax ; STACK_PUSH
027A9F  8A 46 FA              MOV    al, byte ptr [bp - 6] ; LOCAL_LOAD
027AA2  50                    PUSH   ax ; STACK_PUSH
027AA3  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
027AA6  40                    INC    ax ; ARITH
027AA7  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
027AAA  4B                    DEC    bx ; ARITH
027AAB  4B                    DEC    bx ; ARITH
027AAC  8B 56 0A              MOV    dx, word ptr [bp + 0xa] ; LOCAL_LOAD
027AAF  42                    INC    dx ; ARITH
027AB0  9A BA 00 1F 18        LCALL  0x181f, 0xba ; THUNK -> 0x0B9E:0x000A (thunk @file 0x01A6AA type B)
027AB5  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
027AB8  2A E4                 SUB    ah, ah ; ARITH
027ABA  50                    PUSH   ax ; STACK_PUSH
027ABB  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
027ABE  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
027AC1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
027AC4  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
027AC9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
027ACC  52                    PUSH   dx ; STACK_PUSH
027ACD  50                    PUSH   ax ; STACK_PUSH
027ACE  9A 3C 01 1F 18        LCALL  0x181f, 0x13c ; THUNK -> 0x004B:0x0288 (thunk @file 0x01A72C type B) overlay @file 0x060630
027AD3  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
027AD6  5E                    POP    si ; STACK_POP
027AD7  5F                    POP    di ; STACK_POP
027AD8  C9                    LEAVE ; EPILOGUE
027AD9  CB                    RETF ; RETURN
