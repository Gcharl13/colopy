; ============================================================================
; func_02A462_unknown
; Region   : overlay
; Bytes    : file 0x02A462..0x02A4C6  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A462  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
02A466  56                    PUSH   si ; STACK_PUSH
02A467  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
02A46C  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
02A46F  D1 E6                 SHL    si, 1 ; LOGIC
02A471  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02A475  83 B8 9A 00 01        CMP    word ptr [bx + si + 0x9a], 1 ; CMP
02A47A  7D 4A                 JGE    0x2a4c6 ; CJUMP
02A47C  6A 01                 PUSH   1 ; STACK_PUSH
02A47E  9A 56 00 1F 18        LCALL  0x181f, 0x56 ; THUNK -> 0x0009:0x00B4 (thunk @file 0x01A646 type B) overlay @file 0x02287E
02A483  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A486  6A 06                 PUSH   6 ; STACK_PUSH
02A488  0E                    PUSH   cs ; STACK_PUSH
02A489  E8 2D 26              CALL   0x2cab9 ; CALL_NEAR
02A48C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A48F  FF B4 C0 97           PUSH   word ptr [si - 0x6840] ; PUSH_GLOBAL
02A493  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
02A498  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A49B  6A 07                 PUSH   7 ; STACK_PUSH
02A49D  0E                    PUSH   cs ; STACK_PUSH
02A49E  E8 18 26              CALL   0x2cab9 ; CALL_NEAR
02A4A1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02A4A4  83 3E EE 07 01        CMP    word ptr [0x7ee], 1 ; CMP
02A4A9  1B C0                 SBB    ax, ax ; ARITH
02A4AB  25 78 00              AND    ax, 0x78 ; LOGIC
02A4AE  99                    CDQ ; ARITH
02A4AF  52                    PUSH   dx ; STACK_PUSH
02A4B0  50                    PUSH   ax ; STACK_PUSH
02A4B1  6A 03                 PUSH   3 ; STACK_PUSH
02A4B3  0E                    PUSH   cs ; STACK_PUSH
02A4B4  E8 F3 25              CALL   0x2caaa ; CALL_NEAR
02A4B7  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02A4BA  C7 06 54 8D 14 00     MOV    word ptr [0x8d54], 0x14 ; GLOBAL_LOAD
02A4C0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
02A4C3  5E                    POP    si ; STACK_POP
02A4C4  C9                    LEAVE ; EPILOGUE
02A4C5  CB                    RETF ; RETURN
