; ============================================================================
; func_03CAC6_unknown
; Region   : overlay
; Bytes    : file 0x03CAC6..0x03CB00  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CAC6  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
03CACA  56                    PUSH   si ; STACK_PUSH
03CACB  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
03CAD0  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03CAD3  2A E4                 SUB    ah, ah ; ARITH
03CAD5  40                    INC    ax ; ARITH
03CAD6  50                    PUSH   ax ; STACK_PUSH
03CAD7  2B C0                 SUB    ax, ax ; ARITH
03CAD9  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
03CADC  50                    PUSH   ax ; STACK_PUSH
03CADD  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
03CAE2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
03CAE5  0B C0                 OR     ax, ax ; LOGIC
03CAE7  75 03                 JNE    0x3caec ; CJUMP
03CAE9  E9 B3 02              JMP    0x3cd9f ; JUMP
03CAEC  C7 46 E8 00 00        MOV    word ptr [bp - 0x18], 0 ; LOCAL_STORE
03CAF1  E9 CD 00              JMP    0x3cbc1 ; JUMP
03CAF4  6B 5E EE 1C           IMUL   bx, word ptr [bp - 0x12], 0x1c ; ARITH
03CAF8  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
03CAFC  2A FF                 SUB    bh, bh ; ARITH
03CAFE  8B C3                 MOV    ax, bx ; MOV
