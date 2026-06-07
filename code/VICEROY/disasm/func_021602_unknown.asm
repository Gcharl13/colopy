; ============================================================================
; func_021602_unknown
; Region   : overlay
; Bytes    : file 0x021602..0x02165E  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021602  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
021606  A1 28 83              MOV    ax, word ptr [0x8328] ; GLOBAL_LOAD
021609  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02160C  EB 31                 JMP    0x2163f ; JUMP
02160E  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
021611  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
021614  39 06 06 88           CMP    word ptr [0x8806], ax ; CMP
021618  7C 22                 JL     0x2163c ; CJUMP
02161A  6A 0F                 PUSH   0xf ; PUSH_CONST
02161C  50                    PUSH   ax ; STACK_PUSH
02161D  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
021620  9A 4A 07 1F 18        LCALL  0x181f, 0x74a ; THUNK -> 0x037F:0x02F8 (thunk @file 0x01AD3A type B) overlay @file 0x02EE34
021625  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
021628  25 0F 00              AND    ax, 0xf ; LOGIC
02162B  50                    PUSH   ax ; STACK_PUSH
02162C  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
02162F  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
021632  9A 2C 01 1F 19        LCALL  0x191f, 0x12c ; THUNK -> 0x0000:0x0008 (thunk @file 0x01B71C type A) overlay @file 0x025908
021637  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
02163A  EB D2                 JMP    0x2160e ; JUMP
02163C  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
02163F  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
021642  39 06 04 88           CMP    word ptr [0x8804], ax ; CMP
021646  7C 08                 JL     0x21650 ; CJUMP
021648  A1 2E 83              MOV    ax, word ptr [0x832e] ; GLOBAL_LOAD
02164B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02164E  EB C1                 JMP    0x21611 ; JUMP
021650  9A C0 03 1F 18        LCALL  0x181f, 0x3c0 ; THUNK -> 0x0262:0x0060 (thunk @file 0x01A9B0 type B) overlay @file 0x021D90
021655  6A 01                 PUSH   1 ; STACK_PUSH
021657  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
02165C  C9                    LEAVE ; EPILOGUE
02165D  CB                    RETF ; RETURN
