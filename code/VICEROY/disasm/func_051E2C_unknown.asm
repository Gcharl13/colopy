; ============================================================================
; func_051E2C_unknown
; Region   : overlay
; Bytes    : file 0x051E2C..0x051E4C  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051E2C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
051E30  56                    PUSH   si ; STACK_PUSH
051E31  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
051E36  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
051E39  0E                    PUSH   cs ; STACK_PUSH
051E3A  E8 B1 16              CALL   0x534ee ; CALL_NEAR
051E3D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
051E40  0B C0                 OR     ax, ax ; LOGIC
051E42  75 03                 JNE    0x51e47 ; CJUMP
051E44  E9 99 00              JMP    0x51ee0 ; JUMP
051E47  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
051E4A  8B C3                 MOV    ax, bx ; MOV
