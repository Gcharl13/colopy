; ============================================================================
; func_077ED0_unknown
; Region   : overlay
; Bytes    : file 0x077ED0..0x077EE4  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077ED0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
077ED4  52                    PUSH   dx ; STACK_PUSH
077ED5  50                    PUSH   ax ; STACK_PUSH
077ED6  56                    PUSH   si ; STACK_PUSH
077ED7  8B C8                 MOV    cx, ax ; MOV
077ED9  D1 E0                 SHL    ax, 1 ; LOGIC
077EDB  03 C1                 ADD    ax, cx ; ARITH
077EDD  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
077EE0  8B C2                 MOV    ax, dx ; MOV
077EE2  D1 E2                 SHL    dx, 1 ; LOGIC
