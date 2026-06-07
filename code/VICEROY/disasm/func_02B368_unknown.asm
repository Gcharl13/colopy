; ============================================================================
; func_02B368_unknown
; Region   : overlay
; Bytes    : file 0x02B368..0x02B395  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B368  C8 5A 00 00           ENTER  0x5a, 0 ; PROLOGUE
02B36C  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
02B36F  40                    INC    ax ; ARITH
02B370  40                    INC    ax ; ARITH
02B371  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
02B374  83 7E 0A FF           CMP    word ptr [bp + 0xa], -1 ; CMP
02B378  75 12                 JNE    0x2b38c ; CJUMP
02B37A  50                    PUSH   ax ; STACK_PUSH
02B37B  FF 36 A8 93           PUSH   word ptr [0x93a8] ; PUSH_GLOBAL
02B37F  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
02B384  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02B387  52                    PUSH   dx ; STACK_PUSH
02B388  E9 38 01              JMP    0x2b4c3 ; JUMP
02B38B  90                    NOP ; NOP
02B38C  6A 00                 PUSH   0 ; STACK_PUSH
02B38E  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
02B391  9A                    DB     0x9A ; DATA_BYTE
02B392  C2                    DB     0xC2 ; DATA_BYTE
02B393  0C                    DB     0x0C ; DATA_BYTE
02B394  1F                    DB     0x1F ; DATA_BYTE
