; ============================================================================
; func_02AEDA_unknown
; Region   : overlay
; Bytes    : file 0x02AEDA..0x02AF59  (127 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AEDA  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02AEDE  56                    PUSH   si ; STACK_PUSH
02AEDF  83 3E 3C 03 00        CMP    word ptr [0x33c], 0 ; CMP
02AEE4  75 03                 JNE    0x2aee9 ; CJUMP
02AEE6  E9 E1 00              JMP    0x2afca ; JUMP
02AEE9  6A 47                 PUSH   0x47 ; PUSH_CONST
02AEEB  6A 00                 PUSH   0 ; STACK_PUSH
02AEED  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02AEF0  2D 7F 00              SUB    ax, 0x7f ; ARITH
02AEF3  50                    PUSH   ax ; STACK_PUSH
02AEF4  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02AEF9  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02AEFC  B9 0C 00              MOV    cx, 0xc ; CONST_LOAD
02AEFF  99                    CDQ ; ARITH
02AF00  F7 F9                 IDIV   cx ; ARITH
02AF02  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02AF05  FF 36 3E 03           PUSH   word ptr [0x33e] ; PUSH_GLOBAL
02AF09  8B F0                 MOV    si, ax ; MOV
02AF0B  9A 32 0B 1F 18        LCALL  0x181f, 0xb32 ; THUNK -> 0x05EB:0x2F8E (thunk @file 0x01B122 type B) overlay @file 0x029F7E
02AF10  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02AF13  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02AF16  56                    PUSH   si ; STACK_PUSH
02AF17  50                    PUSH   ax ; STACK_PUSH
02AF18  9A E6 0B 1F 18        LCALL  0x181f, 0xbe6 ; THUNK -> 0x05EB:0x2FF2 (thunk @file 0x01B1D6 type B) overlay @file 0x029FE2
02AF1D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
02AF20  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02AF23  83 3E 54 8D 07        CMP    word ptr [0x8d54], 7 ; CMP
02AF28  75 30                 JNE    0x2af5a ; CJUMP
02AF2A  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02AF2F  75 03                 JNE    0x2af34 ; CJUMP
02AF31  E9 96 00              JMP    0x2afca ; JUMP
02AF34  80 3E 8C A8 01        CMP    byte ptr [0xa88c], 1 ; CMP
02AF39  74 03                 JE     0x2af3e ; CJUMP
02AF3B  E9 8C 00              JMP    0x2afca ; JUMP
02AF3E  9A A2 03 1F 18        LCALL  0x181f, 0x3a2 ; THUNK -> 0x0262:0x0002 (thunk @file 0x01A992 type B) overlay @file 0x021D32
02AF43  50                    PUSH   ax ; STACK_PUSH
02AF44  6A 01                 PUSH   1 ; STACK_PUSH
02AF46  A0 8D A8              MOV    al, byte ptr [0xa88d] ; GLOBAL_LOAD
02AF49  2A E4                 SUB    ah, ah ; ARITH
02AF4B  50                    PUSH   ax ; STACK_PUSH
02AF4C  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
02AF4F  0E                    PUSH   cs ; STACK_PUSH
02AF50  E8 75 1B              CALL   0x2cac8 ; CALL_NEAR
02AF53  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02AF56  5E                    POP    si ; STACK_POP
02AF57  C9                    LEAVE ; EPILOGUE
02AF58  CB                    RETF ; RETURN
