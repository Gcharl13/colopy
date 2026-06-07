; ============================================================================
; func_052F7E_unknown
; Region   : overlay
; Bytes    : file 0x052F7E..0x052F99  (27 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

052F7E  C8 1E 00 00           ENTER  0x1e, 0 ; PROLOGUE
052F82  56                    PUSH   si ; STACK_PUSH
052F83  C7 06 12 2D FF FF     MOV    word ptr [0x2d12], 0xffff ; GLOBAL_LOAD
052F89  2B C0                 SUB    ax, ax ; ARITH
052F8B  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
052F8E  A3 40 17              MOV    word ptr [0x1740], ax ; GLOBAL_LOAD
052F91  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
052F95  9A                    DB     0x9A ; DATA_BYTE
052F96  CA                    DB     0xCA ; DATA_BYTE
052F97  04                    DB     0x04 ; DATA_BYTE
052F98  1F                    DB     0x1F ; DATA_BYTE
