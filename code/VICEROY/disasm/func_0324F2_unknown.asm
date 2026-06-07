; ============================================================================
; func_0324F2_unknown
; Region   : overlay
; Bytes    : file 0x0324F2..0x032538  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0324F2  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
0324F6  56                    PUSH   si ; STACK_PUSH
0324F7  C7 46 AA 01 00        MOV    word ptr [bp - 0x56], 1 ; LOCAL_STORE
0324FC  83 3E 92 08 00        CMP    word ptr [0x892], 0 ; CMP
032501  74 5F                 JE     0x32562 ; CJUMP
032503  83 3E A2 0F 00        CMP    word ptr [0xfa2], 0 ; CMP
032508  75 58                 JNE    0x32562 ; CJUMP
03250A  6A 01                 PUSH   1 ; STACK_PUSH
03250C  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
032511  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
032514  6A 05                 PUSH   5 ; STACK_PUSH
032516  0E                    PUSH   cs ; STACK_PUSH
032517  E8 3A 43              CALL   0x36854 ; CALL_NEAR
03251A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03251D  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
032520  D1 E3                 SHL    bx, 1 ; LOGIC
032522  FF B7 C0 97           PUSH   word ptr [bx - 0x6840] ; PUSH_GLOBAL
032526  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
03252B  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03252E  9A 88 00 1F 18        LCALL  0x181f, 0x88 ; THUNK -> 0x0009:0x0222 (thunk @file 0x01A678 type B) overlay @file 0x0229EC
032533  1E                    PUSH   ds ; STACK_PUSH
032534  68 CA 0F              PUSH   0xfca ; PUSH_CONST
032537  9A                    DB     0x9A ; DATA_BYTE
