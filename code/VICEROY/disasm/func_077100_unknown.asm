; ============================================================================
; func_077100_unknown
; Region   : overlay
; Bytes    : file 0x077100..0x07711D  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077100  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
077104  52                    PUSH   dx ; STACK_PUSH
077105  50                    PUSH   ax ; STACK_PUSH
077106  57                    PUSH   di ; STACK_PUSH
077107  56                    PUSH   si ; STACK_PUSH
077108  2B C0                 SUB    ax, ax ; ARITH
07710A  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
07710D  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
077110  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
077113  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
077116  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
077119  8B C2                 MOV    ax, dx ; MOV
07711B  0B                    DB     0x0B ; DATA_BYTE
07711C  46                    DB     0x46 ; DATA_BYTE
