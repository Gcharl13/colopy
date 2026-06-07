; ============================================================================
; func_002783_unknown
; Region   : load_image
; Bytes    : file 0x002783..0x002790  (13 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002783  C8 2C 03 06           ENTER  0x32c, 6 ; PROLOGUE
002787  CC                    INT3 ; SYS
002788  2C 50                 SUB    al, 0x50 ; ARITH
00278A  6A 00                 PUSH   0 ; STACK_PUSH
00278C  A1 CA 2C              MOV    ax, word ptr [0x2cca] ; GLOBAL_LOAD
00278F  8B                    DB     0x8B ; DATA_BYTE
