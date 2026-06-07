; ============================================================================
; func_006096_unknown
; Region   : load_image
; Bytes    : file 0x006096..0x0060B8  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006096  55                    PUSH   bp ; STACK_PUSH
006097  8B EC                 MOV    bp, sp ; MOV
006099  B8 FC 00              MOV    ax, 0xfc ; CONST_LOAD
00609C  50                    PUSH   ax ; STACK_PUSH
00609D  0E                    PUSH   cs ; STACK_PUSH
00609E  E8 7C 02              CALL   0x631d ; CALL_NEAR
0060A1  83 3E E4 43 00        CMP    word ptr [0x43e4], 0 ; CMP
0060A6  74 04                 JE     0x60ac ; CJUMP
0060A8  FF 1E E2 43           LCALL  [0x43e2] ; LCALL
0060AC  B8 FF 00              MOV    ax, 0xff ; CONST_LOAD
0060AF  50                    PUSH   ax ; STACK_PUSH
0060B0  0E                    PUSH   cs ; STACK_PUSH
0060B1  E8 69 02              CALL   0x631d ; CALL_NEAR
0060B4  8B E5                 MOV    sp, bp ; MOV
0060B6  5D                    POP    bp ; STACK_POP
0060B7  CB                    RETF ; RETURN
