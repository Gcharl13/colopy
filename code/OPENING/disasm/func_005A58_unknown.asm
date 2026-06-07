; ============================================================================
; func_005A58_unknown
; Region   : load_image
; Bytes    : file 0x005A58..0x005A79  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005A58  55                    PUSH   bp ; STACK_PUSH
005A59  8B EC                 MOV    bp, sp ; MOV
005A5B  57                    PUSH   di ; STACK_PUSH
005A5C  56                    PUSH   si ; STACK_PUSH
005A5D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
005A60  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
005A63  2A E4                 SUB    ah, ah ; ARITH
005A65  8B F8                 MOV    di, ax ; MOV
005A67  56                    PUSH   si ; STACK_PUSH
005A68  9A E6 14 52 04        LCALL  0x452, 0x14e6 ; LCALL
005A6D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
005A70  80 A5 AF 42 FD        AND    byte ptr [di + 0x42af], 0xfd ; LOGIC
005A75  80 64 06 CF           AND    byte ptr [si + 6], 0xcf ; LOGIC
