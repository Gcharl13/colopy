; ============================================================================
; func_00513C_unknown
; Region   : load_image
; Bytes    : file 0x00513C..0x005156  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00513C  55                    PUSH   bp ; STACK_PUSH
00513D  8B EC                 MOV    bp, sp ; MOV
00513F  83 3E A0 00 00        CMP    word ptr [0xa0], 0 ; CMP
005144  74 10                 JE     0x5156 ; CJUMP
005146  83 3E A2 00 00        CMP    word ptr [0xa2], 0 ; CMP
00514B  75 09                 JNE    0x5156 ; CJUMP
00514D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005150  0E                    PUSH   cs ; STACK_PUSH
005151  E8 B4 FF              CALL   0x5108 ; CALL_NEAR
005154  C9                    LEAVE ; EPILOGUE
005155  CB                    RETF ; RETURN
