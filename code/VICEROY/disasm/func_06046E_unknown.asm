; ============================================================================
; func_06046E_unknown
; Region   : overlay
; Bytes    : file 0x06046E..0x060494  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06046E  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
060472  57                    PUSH   di ; STACK_PUSH
060473  56                    PUSH   si ; STACK_PUSH
060474  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
060479  EB 5D                 JMP    0x604d8 ; JUMP
06047B  90                    NOP ; NOP
06047C  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
06047F  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
060483  80 E1 0F              AND    cl, 0xf ; LOGIC
060486  3A 0E 94 53           CMP    cl, byte ptr [0x5394] ; CMP
06048A  75 49                 JNE    0x604d5 ; CJUMP
06048C  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
060490  2A FF                 SUB    bh, bh ; ARITH
060492  8B CB                 MOV    cx, bx ; MOV
