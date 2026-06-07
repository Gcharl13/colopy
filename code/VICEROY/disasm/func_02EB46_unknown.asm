; ============================================================================
; func_02EB46_unknown
; Region   : overlay
; Bytes    : file 0x02EB46..0x02EB53  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EB46  55                    PUSH   bp ; STACK_PUSH
02EB47  8B EC                 MOV    bp, sp ; MOV
02EB49  56                    PUSH   si ; STACK_PUSH
02EB4A  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
02EB4D  69 5E 06 CA 00        IMUL   bx, word ptr [bp + 6], 0xca ; ARITH
02EB52  38                    DB     0x38 ; DATA_BYTE
