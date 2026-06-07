; ============================================================================
; func_00273E_unknown
; Region   : load_image
; Bytes    : file 0x00273E..0x002748  (10 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00273E  55                    PUSH   bp ; STACK_PUSH
00273F  8B EC                 MOV    bp, sp ; MOV
002741  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
002744  A3 CA 2C              MOV    word ptr [0x2cca], ax ; GLOBAL_LOAD
002747  8B                    DB     0x8B ; DATA_BYTE
