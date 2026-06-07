; ============================================================================
; func_046FFA_unknown
; Region   : overlay
; Bytes    : file 0x046FFA..0x047073  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046FFA  C8 A2 00 00           ENTER  0xa2, 0 ; PROLOGUE
046FFE  56                    PUSH   si ; STACK_PUSH
046FFF  2B C0                 SUB    ax, ax ; ARITH
047001  89 86 7E FF           MOV    word ptr [bp - 0x82], ax ; LOCAL_STORE
047005  89 46 96              MOV    word ptr [bp - 0x6a], ax ; LOCAL_STORE
047008  89 46 86              MOV    word ptr [bp - 0x7a], ax ; LOCAL_STORE
04700B  A1 8E 53              MOV    ax, word ptr [0x538e] ; GLOBAL_LOAD
04700E  B9 E7 FF              MOV    cx, 0xffe7 ; CONST_LOAD
047011  99                    CDQ ; ARITH
047012  F7 F9                 IDIV   cx ; ARITH
047014  03 06 8E 53           ADD    ax, word ptr [0x538e] ; ARITH
047018  89 46 84              MOV    word ptr [bp - 0x7c], ax ; LOCAL_STORE
04701B  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04701F  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
047023  2A E4                 SUB    ah, ah ; ARITH
047025  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
047028  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
04702C  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
04702F  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
047033  25 0F 00              AND    ax, 0xf ; LOGIC
047036  89 86 6C FF           MOV    word ptr [bp - 0x94], ax ; LOCAL_STORE
04703A  2D 04 00              SUB    ax, 4 ; ARITH
04703D  89 46 BE              MOV    word ptr [bp - 0x42], ax ; LOCAL_STORE
047040  50                    PUSH   ax ; STACK_PUSH
047041  9A 42 0A 1F 18        LCALL  0x181f, 0xa42 ; THUNK -> 0x05DC:0x0006 (thunk @file 0x01B032 type B) overlay @file 0x0219E8
047046  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
047049  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
04704C  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
04704F  9A 54 07 1F 18        LCALL  0x181f, 0x754 ; THUNK -> 0x037F:0x0142 (thunk @file 0x01AD44 type B) overlay @file 0x02EC7E
047054  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
047057  25 0A 00              AND    ax, 0xa ; LOGIC
04705A  89 46 D6              MOV    word ptr [bp - 0x2a], ax ; LOCAL_STORE
04705D  FF 76 9C              PUSH   word ptr [bp - 0x64] ; PUSH_GLOBAL
047060  FF 76 AA              PUSH   word ptr [bp - 0x56] ; PUSH_GLOBAL
047063  9A 2C 07 1F 18        LCALL  0x181f, 0x72c ; THUNK -> 0x037F:0x010E (thunk @file 0x01AD1C type B) overlay @file 0x02EC4A
047068  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04706B  25 40 00              AND    ax, 0x40 ; LOGIC
04706E  89 46 C2              MOV    word ptr [bp - 0x3e], ax ; LOCAL_STORE
047071  FF                    DB     0xFF ; DATA_BYTE
047072  B6                    DB     0xB6 ; DATA_BYTE
