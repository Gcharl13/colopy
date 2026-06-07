; ============================================================================
; func_00494A_unknown
; Region   : load_image
; Bytes    : file 0x00494A..0x00496B  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00494A  55                    PUSH   bp ; STACK_PUSH
00494B  8B EC                 MOV    bp, sp ; MOV
00494D  1E                    PUSH   ds ; STACK_PUSH
00494E  68 02 4A              PUSH   0x4a02 ; PUSH_CONST
004951  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
004954  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
004957  1E                    PUSH   ds ; STACK_PUSH
004958  68 34 05              PUSH   0x534 ; PUSH_CONST
00495B  B8 09 00              MOV    ax, 9 ; MOV
00495E  9A 00 00 45 0F        LCALL  0xf45, 0 ; LCALL
004963  C7 06 40 60 00 00     MOV    word ptr [0x6040], 0 ; GLOBAL_LOAD
004969  C9                    LEAVE ; EPILOGUE
00496A  CB                    RETF ; RETURN
