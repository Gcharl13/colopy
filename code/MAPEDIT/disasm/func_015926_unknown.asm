; ============================================================================
; func_015926_unknown
; Region   : load_image
; Bytes    : file 0x015926..0x015934  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015926  55                    PUSH   bp ; STACK_PUSH
015927  8B EC                 MOV    bp, sp ; MOV
015929  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
01592C  B4 41                 MOV    ah, 0x41 ; CONST_LOAD
01592E  CD 21                 INT    0x21 ; SYS
015930  E9 85 07              JMP    0x160b8 ; JUMP
015933  00                    DB     0x00 ; DATA_BYTE
