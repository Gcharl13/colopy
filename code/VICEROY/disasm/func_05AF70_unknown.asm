; ============================================================================
; func_05AF70_unknown
; Region   : overlay
; Bytes    : file 0x05AF70..0x05B016  (166 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05AF70  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
05AF74  56                    PUSH   si ; STACK_PUSH
05AF75  C7 46 F0 FF FF        MOV    word ptr [bp - 0x10], 0xffff ; LOCAL_STORE
05AF7A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
05AF7F  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
05AF84  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
05AF88  7C 5B                 JL     0x5afe5 ; CJUMP
05AF8A  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05AF8D  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
05AF90  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
05AF93  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
05AF97  2A E4                 SUB    ah, ah ; ARITH
05AF99  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
05AF9C  8A 8F 45 31           MOV    cl, byte ptr [bx + 0x3145] ; MOV
05AFA0  2A ED                 SUB    ch, ch ; ARITH
05AFA2  89 4E F8              MOV    word ptr [bp - 8], cx ; LOCAL_STORE
05AFA5  51                    PUSH   cx ; STACK_PUSH
05AFA6  50                    PUSH   ax ; STACK_PUSH
05AFA7  9A 96 06 1F 18        LCALL  0x181f, 0x696 ; THUNK -> 0x037F:0x0358 (thunk @file 0x01AC86 type B) overlay @file 0x02EE94
05AFAC  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05AFAF  0B C0                 OR     ax, ax ; LOGIC
05AFB1  7C 05                 JL     0x5afb8 ; CJUMP
05AFB3  B8 01 00              MOV    ax, 1 ; MOV
05AFB6  EB 02                 JMP    0x5afba ; JUMP
05AFB8  2B C0                 SUB    ax, ax ; ARITH
05AFBA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05AFBD  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
05AFC0  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
05AFC3  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
05AFC8  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05AFCB  0B C0                 OR     ax, ax ; LOGIC
05AFCD  74 16                 JE     0x5afe5 ; CJUMP
05AFCF  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
05AFD2  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
05AFD5  9A 68 07 1F 18        LCALL  0x181f, 0x768 ; THUNK -> 0x03E4:0x0074 (thunk @file 0x01AD58 type B) overlay @file 0x028466
05AFDA  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
05AFDD  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
05AFE0  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
05AFE5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
05AFE8  9A EE 02 1F 18        LCALL  0x181f, 0x2ee ; THUNK -> 0x0427:0x0002 (thunk @file 0x01A8DE type B) overlay @file 0x030D16
05AFED  EB 40                 JMP    0x5b02f ; JUMP
05AFEF  90                    NOP ; NOP
05AFF0  6B 5E 08 1C           IMUL   bx, word ptr [bp + 8], 0x1c ; ARITH
05AFF4  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
05AFF8  24 0F                 AND    al, 0xf ; LOGIC
05AFFA  3C 04                 CMP    al, 4 ; CMP
05AFFC  72 03                 JB     0x5b001 ; CJUMP
05AFFE  D1 66 EE              SHL    word ptr [bp - 0x12], 1 ; LOGIC
05B001  83 7E FC 00           CMP    word ptr [bp - 4], 0 ; CMP
05B005  75 03                 JNE    0x5b00a ; CJUMP
05B007  E9 82 00              JMP    0x5b08c ; JUMP
05B00A  6B 5E F4 1C           IMUL   bx, word ptr [bp - 0xc], 0x1c ; ARITH
05B00E  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
05B012  2A FF                 SUB    bh, bh ; ARITH
05B014  8B C3                 MOV    ax, bx ; MOV
