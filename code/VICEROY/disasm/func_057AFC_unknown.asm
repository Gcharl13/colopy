; ============================================================================
; func_057AFC_unknown
; Region   : overlay
; Bytes    : file 0x057AFC..0x057B0F  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

057AFC  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
057B00  56                    PUSH   si ; STACK_PUSH
057B01  A0 98 53              MOV    al, byte ptr [0x5398] ; GLOBAL_LOAD
057B04  38 06 53 A1           CMP    byte ptr [0xa153], al ; CMP
057B08  75 06                 JNE    0x57b10 ; CJUMP
057B0A  2B C0                 SUB    ax, ax ; ARITH
057B0C  5E                    POP    si ; STACK_POP
057B0D  C9                    LEAVE ; EPILOGUE
057B0E  CB                    RETF ; RETURN
