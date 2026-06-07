; ============================================================================
; func_061454_unknown
; Region   : overlay
; Bytes    : file 0x061454..0x061469  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

061454  C8 3C 00 00           ENTER  0x3c, 0 ; PROLOGUE
061458  57                    PUSH   di ; STACK_PUSH
061459  56                    PUSH   si ; STACK_PUSH
06145A  C7 46 C6 01 00        MOV    word ptr [bp - 0x3a], 1 ; LOCAL_STORE
06145F  2B C0                 SUB    ax, ax ; ARITH
061461  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
061464  89 46 CA              MOV    word ptr [bp - 0x36], ax ; LOCAL_STORE
061467  89                    DB     0x89 ; DATA_BYTE
061468  46                    DB     0x46 ; DATA_BYTE
