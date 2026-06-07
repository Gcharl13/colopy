; ============================================================================
; func_00FCE2_unknown
; Region   : load_image
; Bytes    : file 0x00FCE2..0x00FCF0  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FCE2  55                    PUSH   bp ; STACK_PUSH
00FCE3  8B EC                 MOV    bp, sp ; MOV
00FCE5  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
00FCE8  57                    PUSH   di ; STACK_PUSH
00FCE9  56                    PUSH   si ; STACK_PUSH
00FCEA  BE 16 29              MOV    si, 0x2916 ; CONST_LOAD
00FCED  56                    PUSH   si ; STACK_PUSH
00FCEE  E8                    DB     0xE8 ; DATA_BYTE
00FCEF  C3                    DB     0xC3 ; DATA_BYTE
