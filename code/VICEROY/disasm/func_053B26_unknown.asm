; ============================================================================
; func_053B26_unknown
; Region   : overlay
; Bytes    : file 0x053B26..0x053B68  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053B26  55                    PUSH   bp ; STACK_PUSH
053B27  8B EC                 MOV    bp, sp ; MOV
053B29  56                    PUSH   si ; STACK_PUSH
053B2A  9A 3A 0D 1F 18        LCALL  0x181f, 0xd3a ; THUNK -> 0x05EB:0x0A50 (thunk @file 0x01B32A type B) overlay @file 0x027A40
053B2F  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
053B32  D1 E6                 SHL    si, 1 ; LOGIC
053B34  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053B38  39 80 9A 00           CMP    word ptr [bx + si + 0x9a], ax ; CMP
053B3C  7C 05                 JL     0x53b43 ; CJUMP
053B3E  C7 46 08 00 00        MOV    word ptr [bp + 8], 0 ; LOCAL_STORE
053B43  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
053B46  D1 E3                 SHL    bx, 1 ; LOGIC
053B48  83 BF C8 8D 00        CMP    word ptr [bx - 0x7238], 0 ; CMP
053B4D  74 05                 JE     0x53b54 ; CJUMP
053B4F  C7 46 08 00 00        MOV    word ptr [bp + 8], 0 ; LOCAL_STORE
053B54  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
053B58  74 0E                 JE     0x53b68 ; CJUMP
053B5A  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
053B5D  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053B61  88 87 8D 00           MOV    byte ptr [bx + 0x8d], al ; MOV
053B65  5E                    POP    si ; STACK_POP
053B66  C9                    LEAVE ; EPILOGUE
053B67  CB                    RETF ; RETURN
