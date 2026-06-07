; ============================================================================
; func_005C00_unknown
; Region   : load_image
; Bytes    : file 0x005C00..0x005C0E  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005C00  55                    PUSH   bp ; STACK_PUSH
005C01  8B EC                 MOV    bp, sp ; MOV
005C03  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
005C06  B4 41                 MOV    ah, 0x41 ; CONST_LOAD
005C08  CD 21                 INT    0x21 ; SYS
005C0A  E9 47 07              JMP    0x6354 ; JUMP
005C0D  00                    DB     0x00 ; DATA_BYTE
