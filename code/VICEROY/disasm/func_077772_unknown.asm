; ============================================================================
; func_077772_unknown
; Region   : overlay
; Bytes    : file 0x077772..0x077792  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077772  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
077776  52                    PUSH   dx ; STACK_PUSH
077777  50                    PUSH   ax ; STACK_PUSH
077778  8B C8                 MOV    cx, ax ; MOV
07777A  0B C0                 OR     ax, ax ; LOGIC
07777C  74 0A                 JE     0x77788 ; CJUMP
07777E  48                    DEC    ax ; ARITH
07777F  74 63                 JE     0x777e4 ; CJUMP
077781  0E                    PUSH   cs ; STACK_PUSH
077782  E8 E7 00              CALL   0x7786c ; CALL_NEAR
077785  E9 E2 00              JMP    0x7786a ; JUMP
077788  C7 46 FE 00 10        MOV    word ptr [bp - 2], 0x1000 ; LOCAL_STORE
07778D  83 3E CA 26 01        CMP    word ptr [0x26ca], 1 ; CMP
