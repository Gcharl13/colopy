; ============================================================================
; func_05B2C2_unknown
; Region   : overlay
; Bytes    : file 0x05B2C2..0x05B2E5  (35 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05B2C2  C8 3A 00 00           ENTER  0x3a, 0 ; PROLOGUE
05B2C6  57                    PUSH   di ; STACK_PUSH
05B2C7  56                    PUSH   si ; STACK_PUSH
05B2C8  2B C0                 SUB    ax, ax ; ARITH
05B2CA  89 46 CC              MOV    word ptr [bp - 0x34], ax ; LOCAL_STORE
05B2CD  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
05B2D0  89 46 D8              MOV    word ptr [bp - 0x28], ax ; LOCAL_STORE
05B2D3  C7 46 DC 01 00        MOV    word ptr [bp - 0x24], 1 ; LOCAL_STORE
05B2D8  81 7E 06 2C 01        CMP    word ptr [bp + 6], 0x12c ; CMP
05B2DD  7C 07                 JL     0x5b2e6 ; CJUMP
05B2DF  2B C0                 SUB    ax, ax ; ARITH
05B2E1  5E                    POP    si ; STACK_POP
05B2E2  5F                    POP    di ; STACK_POP
05B2E3  C9                    LEAVE ; EPILOGUE
05B2E4  CB                    RETF ; RETURN
