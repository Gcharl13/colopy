; ============================================================================
; func_005DBA_unknown
; Region   : load_image
; Bytes    : file 0x005DBA..0x005DCB  (17 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005DBA  55                    PUSH   bp ; STACK_PUSH
005DBB  8B EC                 MOV    bp, sp ; MOV
005DBD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005DC0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005DC3  0E                    PUSH   cs ; STACK_PUSH
005DC4  E8 D5 FF              CALL   0x5d9c ; CALL_NEAR
005DC7  24 0F                 AND    al, 0xf ; LOGIC
005DC9  C9                    LEAVE ; EPILOGUE
005DCA  CB                    RETF ; RETURN
