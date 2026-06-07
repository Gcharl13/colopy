; ============================================================================
; func_004DF8_unknown
; Region   : load_image
; Bytes    : file 0x004DF8..0x004E76  (126 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004DF8  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
004DFC  C7 46 FE 25 00        MOV    word ptr [bp - 2], 0x25 ; LOCAL_STORE
004E01  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004E04  E9 97 00              JMP    0x4e9e ; JUMP
004E07  90                    NOP ; NOP
004E08  C7 46 FE 20 00        MOV    word ptr [bp - 2], 0x20 ; LOCAL_STORE
004E0D  E9 D0 00              JMP    0x4ee0 ; JUMP
004E10  C7 46 FE 21 00        MOV    word ptr [bp - 2], 0x21 ; LOCAL_STORE
004E15  E9 C8 00              JMP    0x4ee0 ; JUMP
004E18  C7 46 FE 22 00        MOV    word ptr [bp - 2], 0x22 ; LOCAL_STORE
004E1D  E9 C0 00              JMP    0x4ee0 ; JUMP
004E20  C7 46 FE 23 00        MOV    word ptr [bp - 2], 0x23 ; LOCAL_STORE
004E25  E9 B8 00              JMP    0x4ee0 ; JUMP
004E28  C7 46 FE 3A 00        MOV    word ptr [bp - 2], 0x3a ; LOCAL_STORE
004E2D  E9 B0 00              JMP    0x4ee0 ; JUMP
004E30  C7 46 FE 3B 00        MOV    word ptr [bp - 2], 0x3b ; LOCAL_STORE
004E35  E9 A8 00              JMP    0x4ee0 ; JUMP
004E38  C7 46 FE 38 00        MOV    word ptr [bp - 2], 0x38 ; LOCAL_STORE
004E3D  E9 A0 00              JMP    0x4ee0 ; JUMP
004E40  C7 46 FE 24 00        MOV    word ptr [bp - 2], 0x24 ; LOCAL_STORE
004E45  E9 98 00              JMP    0x4ee0 ; JUMP
004E48  C7 46 FE 25 00        MOV    word ptr [bp - 2], 0x25 ; LOCAL_STORE
004E4D  E9 90 00              JMP    0x4ee0 ; JUMP
004E50  C7 46 FE 26 00        MOV    word ptr [bp - 2], 0x26 ; LOCAL_STORE
004E55  E9 88 00              JMP    0x4ee0 ; JUMP
004E58  C7 46 FE 27 00        MOV    word ptr [bp - 2], 0x27 ; LOCAL_STORE
004E5D  E9 80 00              JMP    0x4ee0 ; JUMP
004E60  C7 46 FE 39 00        MOV    word ptr [bp - 2], 0x39 ; LOCAL_STORE
004E65  EB 79                 JMP    0x4ee0 ; JUMP
004E67  90                    NOP ; NOP
004E68  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
004E6B  05 1B 00              ADD    ax, 0x1b ; ARITH
004E6E  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
004E71  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
004E74  C9                    LEAVE ; EPILOGUE
004E75  CB                    RETF ; RETURN
