; ============================================================================
; func_060F32_unknown
; Region   : overlay
; Bytes    : file 0x060F32..0x060F4B  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060F32  C8 50 00 00           ENTER  0x50, 0 ; PROLOGUE
060F36  83 3E EA 07 3D        CMP    word ptr [0x7ea], 0x3d ; CMP
060F3B  7C 0F                 JL     0x60f4c ; CJUMP
060F3D  81 3E EA 07 8D 00     CMP    word ptr [0x7ea], 0x8d ; CMP
060F43  7D 07                 JGE    0x60f4c ; CJUMP
060F45  0E                    PUSH   cs ; STACK_PUSH
060F46  E8 F2 04              CALL   0x6143b ; CALL_NEAR
060F49  C9                    LEAVE ; EPILOGUE
060F4A  CB                    RETF ; RETURN
