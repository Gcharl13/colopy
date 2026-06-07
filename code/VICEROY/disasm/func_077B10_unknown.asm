; ============================================================================
; func_077B10_unknown
; Region   : overlay
; Bytes    : file 0x077B10..0x077B2F  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077B10  C8 52 00 00           ENTER  0x52, 0 ; PROLOGUE
077B14  52                    PUSH   dx ; STACK_PUSH
077B15  50                    PUSH   ax ; STACK_PUSH
077B16  53                    PUSH   bx ; STACK_PUSH
077B17  57                    PUSH   di ; STACK_PUSH
077B18  56                    PUSH   si ; STACK_PUSH
077B19  8B F0                 MOV    si, ax ; MOV
077B1B  8B FA                 MOV    di, dx ; MOV
077B1D  89 5E AE              MOV    word ptr [bp - 0x52], bx ; LOCAL_STORE
077B20  0E                    PUSH   cs ; STACK_PUSH
077B21  E8 D2 02              CALL   0x77df6 ; CALL_NEAR
077B24  83 7E 04 EC           CMP    word ptr [bp + 4], -0x14 ; CMP
077B28  75 03                 JNE    0x77b2d ; CJUMP
077B2A  E9 FF 01              JMP    0x77d2c ; JUMP
077B2D  68                    DB     0x68 ; DATA_BYTE
077B2E  CF                    DB     0xCF ; DATA_BYTE
