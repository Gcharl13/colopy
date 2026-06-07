; ============================================================================
; func_00BB98_unknown
; Region   : load_image
; Bytes    : file 0x00BB98..0x00BBDF  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BB98  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00BB9C  C7 46 FA FE FF        MOV    word ptr [bp - 6], 0xfffe ; LOCAL_STORE
00BBA1  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
00BBA4  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00BBA7  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00BBAA  EB 28                 JMP    0xbbd4 ; JUMP
00BBAC  83 7E FE 31           CMP    word ptr [bp - 2], 0x31 ; CMP
00BBB0  7D 28                 JGE    0xbbda ; CJUMP
00BBB2  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00BBB5  0E                    PUSH   cs ; STACK_PUSH
00BBB6  E8 47 FD              CALL   0xb900 ; CALL_NEAR
00BBB9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00BBBC  0B C0                 OR     ax, ax ; LOGIC
00BBBE  74 11                 JE     0xbbd1 ; CJUMP
00BBC0  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BBC3  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
00BBC6  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
00BBC9  75 06                 JNE    0xbbd1 ; CJUMP
00BBCB  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00BBCE  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00BBD1  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
00BBD4  83 7E FA FF           CMP    word ptr [bp - 6], -1 ; CMP
00BBD8  7C D2                 JL     0xbbac ; CJUMP
00BBDA  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00BBDD  C9                    LEAVE ; EPILOGUE
00BBDE  CB                    RETF ; RETURN
