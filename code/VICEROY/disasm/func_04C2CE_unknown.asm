; ============================================================================
; func_04C2CE_unknown
; Region   : overlay
; Bytes    : file 0x04C2CE..0x04C2E1  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C2CE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C2D2  57                    PUSH   di ; STACK_PUSH
04C2D3  56                    PUSH   si ; STACK_PUSH
04C2D4  C7 46 FE 0E 00        MOV    word ptr [bp - 2], 0xe ; LOCAL_STORE
04C2D9  EB 1E                 JMP    0x4c2f9 ; JUMP
04C2DB  90                    NOP ; NOP
04C2DC  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
04C2DF  8B C3                 MOV    ax, bx ; MOV
