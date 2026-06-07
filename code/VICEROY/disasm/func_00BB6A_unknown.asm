; ============================================================================
; func_00BB6A_unknown
; Region   : load_image
; Bytes    : file 0x00BB6A..0x00BB97  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BB6A  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00BB6E  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00BB73  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
00BB78  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00BB7B  0E                    PUSH   cs ; STACK_PUSH
00BB7C  E8 81 FD              CALL   0xb900 ; CALL_NEAR
00BB7F  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00BB82  0B C0                 OR     ax, ax ; LOGIC
00BB84  74 03                 JE     0xbb89 ; CJUMP
00BB86  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00BB89  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00BB8C  83 7E FC 31           CMP    word ptr [bp - 4], 0x31 ; CMP
00BB90  7C E6                 JL     0xbb78 ; CJUMP
00BB92  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00BB95  C9                    LEAVE ; EPILOGUE
00BB96  CB                    RETF ; RETURN
