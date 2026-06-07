; ============================================================================
; func_03C4A2_unknown
; Region   : overlay
; Bytes    : file 0x03C4A2..0x03C4DB  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C4A2  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
03C4A6  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
03C4A9  48                    DEC    ax ; ARITH
03C4AA  74 44                 JE     0x3c4f0 ; CJUMP
03C4AC  48                    DEC    ax ; ARITH
03C4AD  74 2D                 JE     0x3c4dc ; CJUMP
03C4AF  48                    DEC    ax ; ARITH
03C4B0  74 34                 JE     0x3c4e6 ; CJUMP
03C4B2  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
03C4B6  7D 66                 JGE    0x3c51e ; CJUMP
03C4B8  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
03C4BC  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
03C4C1  75 5B                 JNE    0x3c51e ; CJUMP
03C4C3  A0 82 53              MOV    al, byte ptr [0x5382] ; GLOBAL_LOAD
03C4C6  25 01 00              AND    ax, 1 ; LOGIC
03C4C9  3D 01 00              CMP    ax, 1 ; CMP
03C4CC  1B C0                 SBB    ax, ax ; ARITH
03C4CE  24 FB                 AND    al, 0xfb ; LOGIC
03C4D0  05 09 00              ADD    ax, 9 ; ARITH
03C4D3  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03C4D6  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
03C4D9  C9                    LEAVE ; EPILOGUE
03C4DA  CB                    RETF ; RETURN
