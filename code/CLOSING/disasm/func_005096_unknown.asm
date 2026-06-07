; ============================================================================
; func_005096_unknown
; Region   : load_image
; Bytes    : file 0x005096..0x0050B8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005096  55                    PUSH   bp ; STACK_PUSH
005097  8B EC                 MOV    bp, sp ; MOV
005099  B8 FC 00              MOV    ax, 0xfc ; CONST_LOAD
00509C  50                    PUSH   ax ; STACK_PUSH
00509D  0E                    PUSH   cs ; STACK_PUSH
00509E  E8 7C 02              CALL   0x531d ; CALL_NEAR
0050A1  83 3E 8E 41 00        CMP    word ptr [0x418e], 0 ; CMP
0050A6  74 04                 JE     0x50ac ; CJUMP
0050A8  FF 1E 8C 41           LCALL  [0x418c] ; LCALL
0050AC  B8 FF 00              MOV    ax, 0xff ; CONST_LOAD
0050AF  50                    PUSH   ax ; STACK_PUSH
0050B0  0E                    PUSH   cs ; STACK_PUSH
0050B1  E8 69 02              CALL   0x531d ; CALL_NEAR
0050B4  8B E5                 MOV    sp, bp ; MOV
0050B6  5D                    POP    bp ; STACK_POP
0050B7  CB                    RETF ; RETURN
