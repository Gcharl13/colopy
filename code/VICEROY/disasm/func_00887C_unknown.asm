; ============================================================================
; func_00887C_unknown
; Region   : load_image
; Bytes    : file 0x00887C..0x008891  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00887C  55                    PUSH   bp ; STACK_PUSH
00887D  8B EC                 MOV    bp, sp ; MOV
00887F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008882  0E                    PUSH   cs ; STACK_PUSH
008883  E8 6E FF              CALL   0x87f4 ; CALL_NEAR
008886  8B E5                 MOV    sp, bp ; MOV
008888  52                    PUSH   dx ; STACK_PUSH
008889  50                    PUSH   ax ; STACK_PUSH
00888A  9A FC 01 09 00        LCALL  9, 0x1fc ; LCALL
00888F  C9                    LEAVE ; EPILOGUE
008890  CB                    RETF ; RETURN
