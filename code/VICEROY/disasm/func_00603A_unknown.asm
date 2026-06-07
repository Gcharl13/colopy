; ============================================================================
; func_00603A_unknown
; Region   : load_image
; Bytes    : file 0x00603A..0x00605B  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00603A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00603E  56                    PUSH   si ; STACK_PUSH
00603F  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
006044  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
006047  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00604A  0E                    PUSH   cs ; STACK_PUSH
00604B  E8 AC FB              CALL   0x5bfa ; CALL_NEAR
00604E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
006051  0B C0                 OR     ax, ax ; LOGIC
006053  75 07                 JNE    0x605c ; CJUMP
006055  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
006058  5E                    POP    si ; STACK_POP
006059  C9                    LEAVE ; EPILOGUE
00605A  CB                    RETF ; RETURN
