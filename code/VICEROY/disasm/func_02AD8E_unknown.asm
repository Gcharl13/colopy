; ============================================================================
; func_02AD8E_unknown
; Region   : overlay
; Bytes    : file 0x02AD8E..0x02AE07  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AD8E  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
02AD92  81 3E EA 07 93 00     CMP    word ptr [0x7ea], 0x93 ; CMP
02AD98  7D 08                 JGE    0x2ada2 ; CJUMP
02AD9A  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
02AD9F  EB 06                 JMP    0x2ada7 ; JUMP
02ADA1  90                    NOP ; NOP
02ADA2  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
02ADA7  83 7E F8 00           CMP    word ptr [bp - 8], 0 ; CMP
02ADAB  75 1B                 JNE    0x2adc8 ; CJUMP
02ADAD  6A 47                 PUSH   0x47 ; PUSH_CONST
02ADAF  6A 00                 PUSH   0 ; STACK_PUSH
02ADB1  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02ADB4  2D 82 00              SUB    ax, 0x82 ; ARITH
02ADB7  50                    PUSH   ax ; STACK_PUSH
02ADB8  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02ADBD  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02ADC0  B9 12 00              MOV    cx, 0x12 ; CONST_LOAD
02ADC3  99                    CDQ ; ARITH
02ADC4  F7 F9                 IDIV   cx ; ARITH
02ADC6  EB 1D                 JMP    0x2ade5 ; JUMP
02ADC8  6A 4E                 PUSH   0x4e ; PUSH_CONST
02ADCA  6A 00                 PUSH   0 ; STACK_PUSH
02ADCC  A1 E8 07              MOV    ax, word ptr [0x7e8] ; GLOBAL_LOAD
02ADCF  2D 7C 00              SUB    ax, 0x7c ; ARITH
02ADD2  50                    PUSH   ax ; STACK_PUSH
02ADD3  9A 5C 03 1F 18        LCALL  0x181f, 0x35c ; THUNK -> 0x024C:0x000C (thunk @file 0x01A94C type B) overlay @file 0x028792
02ADD8  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02ADDB  40                    INC    ax ; ARITH
02ADDC  B9 05 00              MOV    cx, 5 ; MOV
02ADDF  99                    CDQ ; ARITH
02ADE0  F7 F9                 IDIV   cx ; ARITH
02ADE2  05 04 00              ADD    ax, 4 ; ARITH
02ADE5  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02ADE8  A1 3C 03              MOV    ax, word ptr [0x33c] ; GLOBAL_LOAD
02ADEB  48                    DEC    ax ; ARITH
02ADEC  3B 46 F6              CMP    ax, word ptr [bp - 0xa] ; CMP
02ADEF  7E 03                 JLE    0x2adf4 ; CJUMP
02ADF1  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
02ADF4  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02ADF7  83 3E 54 8D 07        CMP    word ptr [0x8d54], 7 ; CMP
02ADFC  75 6C                 JNE    0x2ae6a ; CJUMP
02ADFE  83 3E F4 07 00        CMP    word ptr [0x7f4], 0 ; CMP
02AE03  75 03                 JNE    0x2ae08 ; CJUMP
02AE05  E9                    DB     0xE9 ; DATA_BYTE
02AE06  CF                    DB     0xCF ; DATA_BYTE
