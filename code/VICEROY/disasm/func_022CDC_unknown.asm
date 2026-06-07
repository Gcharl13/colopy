; ============================================================================
; func_022CDC_unknown
; Region   : overlay
; Bytes    : file 0x022CDC..0x022D0E  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022CDC  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
022CE0  56                    PUSH   si ; STACK_PUSH
022CE1  6A 00                 PUSH   0 ; STACK_PUSH
022CE3  6A 01                 PUSH   1 ; STACK_PUSH
022CE5  6A FF                 PUSH   -1 ; STACK_PUSH
022CE7  A1 92 53              MOV    ax, word ptr [0x5392] ; GLOBAL_LOAD
022CEA  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
022CED  50                    PUSH   ax ; STACK_PUSH
022CEE  9A F8 02 1F 19        LCALL  0x191f, 0x2f8 ; THUNK -> 0x0000:0x01C6 (thunk @file 0x01B8E8 type A) overlay @file 0x025AC6
022CF3  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
022CF6  3D E7 03              CMP    ax, 0x3e7 ; CMP
022CF9  75 21                 JNE    0x22d1c ; CJUMP
022CFB  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
022D00  74 0C                 JE     0x22d0e ; CJUMP
022D02  8D 1E 1E 0A           LEA    bx, [0xa1e] ; ADDR
022D06  9A FE 03 1F 18        LCALL  0x181f, 0x3fe ; THUNK -> 0x0000:0x3744 (thunk @file 0x01A9EE type A) overlay @file 0x029044
022D0B  5E                    POP    si ; STACK_POP
022D0C  C9                    LEAVE ; EPILOGUE
022D0D  CB                    RETF ; RETURN
