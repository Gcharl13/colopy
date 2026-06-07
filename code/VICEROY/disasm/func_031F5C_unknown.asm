; ============================================================================
; func_031F5C_unknown
; Region   : overlay
; Bytes    : file 0x031F5C..0x031F7C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031F5C  55                    PUSH   bp ; STACK_PUSH
031F5D  8B EC                 MOV    bp, sp ; MOV
031F5F  6A 01                 PUSH   1 ; STACK_PUSH
031F61  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
031F66  8B E5                 MOV    sp, bp ; MOV
031F68  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
031F6B  0E                    PUSH   cs ; STACK_PUSH
031F6C  E8 E5 48              CALL   0x36854 ; CALL_NEAR
031F6F  8B E5                 MOV    sp, bp ; MOV
031F71  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
031F74  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
031F77  6A 03                 PUSH   3 ; STACK_PUSH
031F79  0E                    PUSH   cs ; STACK_PUSH
031F7A  E8                    DB     0xE8 ; DATA_BYTE
031F7B  C3                    DB     0xC3 ; DATA_BYTE
