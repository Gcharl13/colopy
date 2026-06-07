; ============================================================================
; func_06C388_unknown
; Region   : overlay
; Bytes    : file 0x06C388..0x06C39B  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C388  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
06C38C  53                    PUSH   bx ; STACK_PUSH
06C38D  52                    PUSH   dx ; STACK_PUSH
06C38E  50                    PUSH   ax ; STACK_PUSH
06C38F  C6 46 FF 00           MOV    byte ptr [bp - 1], 0 ; LOCAL_STORE
06C393  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
06C396  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C399  8B C3                 MOV    ax, bx ; MOV
