; ============================================================================
; func_030C68_unknown
; Region   : overlay
; Bytes    : file 0x030C68..0x030D16  (174 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030C68  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
030C6C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
030C71  83 7E 06 14           CMP    word ptr [bp + 6], 0x14 ; CMP
030C75  75 05                 JNE    0x30c7c ; CJUMP
030C77  C7 46 FE 02 00        MOV    word ptr [bp - 2], 2 ; LOCAL_STORE
030C7C  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
030C80  75 05                 JNE    0x30c87 ; CJUMP
030C82  C7 46 FE 03 00        MOV    word ptr [bp - 2], 3 ; LOCAL_STORE
030C87  83 7E 06 16           CMP    word ptr [bp + 6], 0x16 ; CMP
030C8B  75 05                 JNE    0x30c92 ; CJUMP
030C8D  C7 46 FE 05 00        MOV    word ptr [bp - 2], 5 ; LOCAL_STORE
030C92  83 7E 06 15           CMP    word ptr [bp + 6], 0x15 ; CMP
030C96  75 41                 JNE    0x30cd9 ; CJUMP
030C98  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
030C9D  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
030CA2  7D 16                 JGE    0x30cba ; CJUMP
030CA4  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
030CA9  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
030CAE  75 0A                 JNE    0x30cba ; CJUMP
030CB0  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
030CB3  2A E4                 SUB    ah, ah ; ARITH
030CB5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
030CB8  EB 05                 JMP    0x30cbf ; JUMP
030CBA  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
030CBF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
030CC2  05 04 00              ADD    ax, 4 ; ARITH
030CC5  50                    PUSH   ax ; STACK_PUSH
030CC6  6A 00                 PUSH   0 ; STACK_PUSH
030CC8  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
030CCD  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
030CD0  0B C0                 OR     ax, ax ; LOGIC
030CD2  75 05                 JNE    0x30cd9 ; CJUMP
030CD4  C7 46 FE 04 00        MOV    word ptr [bp - 2], 4 ; LOCAL_STORE
030CD9  A1 12 9E              MOV    ax, word ptr [0x9e12] ; GLOBAL_LOAD
030CDC  2D 14 00              SUB    ax, 0x14 ; ARITH
030CDF  50                    PUSH   ax ; STACK_PUSH
030CE0  50                    PUSH   ax ; STACK_PUSH
030CE1  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
030CE5  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
030CE8  9A 5C 09 1F 18        LCALL  0x181f, 0x95c ; THUNK -> 0x0427:0x06B4 (thunk @file 0x01AF4C type B) overlay @file 0x0313C8
030CED  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
030CF0  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
030CF3  0B C0                 OR     ax, ax ; LOGIC
030CF5  7C 1A                 JL     0x30d11 ; CJUMP
030CF7  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
030CFA  C6 87 4C 31 01        MOV    byte ptr [bx + 0x314c], 1 ; MOV
030CFF  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
030D02  88 87 5B 31           MOV    byte ptr [bx + 0x315b], al ; MOV
030D06  83 7E FE 02           CMP    word ptr [bp - 2], 2 ; CMP
030D0A  75 05                 JNE    0x30d11 ; CJUMP
030D0C  C6 87 59 31 64        MOV    byte ptr [bx + 0x3159], 0x64 ; CONST_LOAD
030D11  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
030D14  C9                    LEAVE ; EPILOGUE
030D15  CB                    RETF ; RETURN
