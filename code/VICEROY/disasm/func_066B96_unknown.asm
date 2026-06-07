; ============================================================================
; func_066B96_unknown
; Region   : overlay
; Bytes    : file 0x066B96..0x066BA7  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066B96  55                    PUSH   bp ; STACK_PUSH
066B97  8B EC                 MOV    bp, sp ; MOV
066B99  6A 00                 PUSH   0 ; STACK_PUSH
066B9B  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
066B9E  6A 27                 PUSH   0x27 ; PUSH_CONST
066BA0  6A 38                 PUSH   0x38 ; PUSH_CONST
066BA2  FF 36 CA 9C           PUSH   word ptr [0x9cca] ; PUSH_GLOBAL
066BA6  FF                    DB     0xFF ; DATA_BYTE
