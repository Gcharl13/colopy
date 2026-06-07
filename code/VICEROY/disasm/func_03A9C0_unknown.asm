; ============================================================================
; func_03A9C0_unknown
; Region   : overlay
; Bytes    : file 0x03A9C0..0x03AA09  (73 bytes)
; Purpose  : Score formula (964-byte stack frame!)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

03A9C0  C8 C4 03 00           ENTER  0x3c4, 0 ; PROLOGUE
03A9C4  C7 86 40 FF FF FF     MOV    word ptr [bp - 0xc0], 0xffff ; LOCAL_STORE
03A9CA  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
03A9CF  2B C0                 SUB    ax, ax ; ARITH
03A9D1  89 86 4A FF           MOV    word ptr [bp - 0xb6], ax ; LOCAL_STORE
03A9D5  89 86 48 FF           MOV    word ptr [bp - 0xb8], ax ; LOCAL_STORE
03A9D9  39 46 08              CMP    word ptr [bp + 8], ax ; CMP
03A9DC  74 07                 JE     0x3a9e5 ; CJUMP
03A9DE  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
03A9E1  C7 07 FF FF           MOV    word ptr [bx], 0xffff ; CONST_LOAD
03A9E5  A1 72 03              MOV    ax, word ptr [0x372] ; GLOBAL_LOAD
03A9E8  89 86 46 FF           MOV    word ptr [bp - 0xba], ax ; LOCAL_STORE
03A9EC  C7 06 72 03 00 00     MOV    word ptr [0x372], 0 ; GLOBAL_LOAD
03A9F2  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
03A9F5  0E                    PUSH   cs ; STACK_PUSH
03A9F6  E8 71 09              CALL   0x3b36a ; CALL_NEAR
03A9F9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03A9FC  89 86 42 FF           MOV    word ptr [bp - 0xbe], ax ; LOCAL_STORE
03AA00  0B C0                 OR     ax, ax ; LOGIC
03AA02  7F 06                 JG     0x3aa0a ; CJUMP
03AA04  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03AA07  C9                    LEAVE ; EPILOGUE
03AA08  CB                    RETF ; RETURN
