; ============================================================================
; func_00631E_unknown
; Region   : load_image
; Bytes    : file 0x00631E..0x006337  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00631E  55                    PUSH   bp ; STACK_PUSH
00631F  8B EC                 MOV    bp, sp ; MOV
006321  56                    PUSH   si ; STACK_PUSH
006322  8B 76 04              MOV    si, word ptr [bp + 4] ; LOCAL_LOAD
006325  B8 00 02              MOV    ax, 0x200 ; CONST_LOAD
006328  50                    PUSH   ax ; STACK_PUSH
006329  9A 8E 24 7D 03        LCALL  0x37d, 0x248e ; LCALL
00632E  59                    POP    cx ; STACK_POP
00632F  8B DE                 MOV    bx, si ; MOV
006331  81 EB A8 41           SUB    bx, 0x41a8 ; ARITH
006335  81                    DB     0x81 ; DATA_BYTE
006336  C3                    DB     0xC3 ; DATA_BYTE
