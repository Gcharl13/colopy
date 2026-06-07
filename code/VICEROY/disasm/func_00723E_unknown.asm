; ============================================================================
; func_00723E_unknown
; Region   : load_image
; Bytes    : file 0x00723E..0x00726E  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00723E  55                    PUSH   bp ; STACK_PUSH
00723F  8B EC                 MOV    bp, sp ; MOV
007241  57                    PUSH   di ; STACK_PUSH
007242  56                    PUSH   si ; STACK_PUSH
007243  8B 7E 08              MOV    di, word ptr [bp + 8] ; LOCAL_LOAD
007246  2B F6                 SUB    si, si ; ARITH
007248  57                    PUSH   di ; STACK_PUSH
007249  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00724C  9A E4 03 7F 03        LCALL  0x37f, 0x3e4 ; LCALL
007251  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007254  0B C0                 OR     ax, ax ; LOGIC
007256  7D 10                 JGE    0x7268 ; CJUMP
007258  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
00725B  57                    PUSH   di ; STACK_PUSH
00725C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00725F  0E                    PUSH   cs ; STACK_PUSH
007260  E8 15 FF              CALL   0x7178 ; CALL_NEAR
007263  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
007266  8B F0                 MOV    si, ax ; MOV
007268  8B C6                 MOV    ax, si ; MOV
00726A  5E                    POP    si ; STACK_POP
00726B  5F                    POP    di ; STACK_POP
00726C  C9                    LEAVE ; EPILOGUE
00726D  CB                    RETF ; RETURN
