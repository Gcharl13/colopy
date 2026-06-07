; ============================================================================
; func_005F48_unknown
; Region   : load_image
; Bytes    : file 0x005F48..0x005F82  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005F48  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
005F4C  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005F51  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005F54  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005F57  0E                    PUSH   cs ; STACK_PUSH
005F58  E8 D7 FD              CALL   0x5d32 ; CALL_NEAR
005F5B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005F5E  A8 02                 TEST   al, 2 ; LOGIC
005F60  74 1B                 JE     0x5f7d ; CJUMP
005F62  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
005F65  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
005F68  0E                    PUSH   cs ; STACK_PUSH
005F69  E8 84 FE              CALL   0x5df0 ; CALL_NEAR
005F6C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
005F6F  98                    CWDE ; ARITH
005F70  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
005F73  3D 04 00              CMP    ax, 4 ; CMP
005F76  7C 05                 JL     0x5f7d ; CJUMP
005F78  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
005F7D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
005F80  C9                    LEAVE ; EPILOGUE
005F81  CB                    RETF ; RETURN
