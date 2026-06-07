; ============================================================================
; func_06044C_unknown
; Region   : overlay
; Bytes    : file 0x06044C..0x06046D  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06044C  55                    PUSH   bp ; STACK_PUSH
06044D  8B EC                 MOV    bp, sp ; MOV
06044F  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
060452  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
060456  26 89 07              MOV    word ptr es:[bx], ax ; MOV
060459  6A 00                 PUSH   0 ; STACK_PUSH
06045B  6A 01                 PUSH   1 ; STACK_PUSH
06045D  0E                    PUSH   cs ; STACK_PUSH
06045E  E8 EE 0F              CALL   0x6144f ; CALL_NEAR
060461  8B E5                 MOV    sp, bp ; MOV
060463  6A 00                 PUSH   0 ; STACK_PUSH
060465  6A 00                 PUSH   0 ; STACK_PUSH
060467  0E                    PUSH   cs ; STACK_PUSH
060468  E8 E4 0F              CALL   0x6144f ; CALL_NEAR
06046B  C9                    LEAVE ; EPILOGUE
06046C  CB                    RETF ; RETURN
