; ============================================================================
; func_006A10_unknown
; Region   : load_image
; Bytes    : file 0x006A10..0x006A7C  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006A10  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
006A14  57                    PUSH   di ; STACK_PUSH
006A15  56                    PUSH   si ; STACK_PUSH
006A16  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006A19  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006A1C  89 5E FA              MOV    word ptr [bp - 6], bx ; LOCAL_STORE
006A1F  83 BF 5E 31 00        CMP    word ptr [bx + 0x315e], 0 ; CMP
006A24  7C 52                 JL     0x6a78 ; CJUMP
006A26  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
006A2A  2A E4                 SUB    ah, ah ; ARITH
006A2C  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
006A2F  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
006A33  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
006A36  8B C6                 MOV    ax, si ; MOV
006A38  0E                    PUSH   cs ; STACK_PUSH
006A39  E8 36 FC              CALL   0x6672 ; CALL_NEAR
006A3C  8B F8                 MOV    di, ax ; MOV
006A3E  3B FE                 CMP    di, si ; CMP
006A40  75 08                 JNE    0x6a4a ; CJUMP
006A42  8B C6                 MOV    ax, si ; MOV
006A44  0E                    PUSH   cs ; STACK_PUSH
006A45  E8 72 FC              CALL   0x66ba ; CALL_NEAR
006A48  8B F8                 MOV    di, ax ; MOV
006A4A  8B C6                 MOV    ax, si ; MOV
006A4C  0E                    PUSH   cs ; STACK_PUSH
006A4D  E8 5A FE              CALL   0x68aa ; CALL_NEAR
006A50  8B C7                 MOV    ax, di ; MOV
006A52  0E                    PUSH   cs ; STACK_PUSH
006A53  E8 40 FC              CALL   0x6696 ; CALL_NEAR
006A56  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
006A59  89 B7 5E 31           MOV    word ptr [bx + 0x315e], si ; MOV
006A5D  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
006A60  89 87 5C 31           MOV    word ptr [bx + 0x315c], ax ; MOV
006A64  C7 87 5E 31 FF FF     MOV    word ptr [bx + 0x315e], 0xffff ; CONST_LOAD
006A6A  8A 46 FE              MOV    al, byte ptr [bp - 2] ; LOCAL_LOAD
006A6D  88 87 44 31           MOV    byte ptr [bx + 0x3144], al ; MOV
006A71  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
006A74  88 87 45 31           MOV    byte ptr [bx + 0x3145], al ; MOV
006A78  5E                    POP    si ; STACK_POP
006A79  5F                    POP    di ; STACK_POP
006A7A  C9                    LEAVE ; EPILOGUE
006A7B  CB                    RETF ; RETURN
