; ============================================================================
; func_06295E_unknown
; Region   : overlay
; Bytes    : file 0x06295E..0x062992  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06295E  C8 7A 00 00           ENTER  0x7a, 0 ; PROLOGUE
062962  53                    PUSH   bx ; STACK_PUSH
062963  52                    PUSH   dx ; STACK_PUSH
062964  50                    PUSH   ax ; STACK_PUSH
062965  56                    PUSH   si ; STACK_PUSH
062966  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
06296B  A1 F4 1D              MOV    ax, word ptr [0x1df4] ; GLOBAL_LOAD
06296E  89 46 94              MOV    word ptr [bp - 0x6c], ax ; LOCAL_STORE
062971  0B C0                 OR     ax, ax ; LOGIC
062973  75 1B                 JNE    0x62990 ; CJUMP
062975  F6 06 94 08 20        TEST   byte ptr [0x894], 0x20 ; LOGIC
06297A  74 14                 JE     0x62990 ; CJUMP
06297C  39 06 A2 53           CMP    word ptr [0x53a2], ax ; CMP
062980  75 09                 JNE    0x6298b ; CJUMP
062982  A1 96 53              MOV    ax, word ptr [0x5396] ; GLOBAL_LOAD
062985  39 06 D6 1D           CMP    word ptr [0x1dd6], ax ; CMP
062989  75 05                 JNE    0x62990 ; CJUMP
06298B  C7 46 94 01 00        MOV    word ptr [bp - 0x6c], 1 ; LOCAL_STORE
062990  8B C3                 MOV    ax, bx ; MOV
