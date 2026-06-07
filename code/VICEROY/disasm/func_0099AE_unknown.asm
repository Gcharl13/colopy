; ============================================================================
; func_0099AE_unknown
; Region   : load_image
; Bytes    : file 0x0099AE..0x0099ED  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0099AE  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0099B2  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
0099B7  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0099BA  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0099BD  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
0099C2  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0099C5  0B C0                 OR     ax, ax ; LOGIC
0099C7  74 1F                 JE     0x99e8 ; CJUMP
0099C9  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0099CC  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0099CF  9A 0E 01 7F 03        LCALL  0x37f, 0x10e ; LCALL
0099D4  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0099D7  24 1F                 AND    al, 0x1f ; LOGIC
0099D9  3A 46 0A              CMP    al, byte ptr [bp + 0xa] ; CMP
0099DC  72 0A                 JB     0x99e8 ; CJUMP
0099DE  3A 46 0C              CMP    al, byte ptr [bp + 0xc] ; CMP
0099E1  77 05                 JA     0x99e8 ; CJUMP
0099E3  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0099E8  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0099EB  C9                    LEAVE ; EPILOGUE
0099EC  CB                    RETF ; RETURN
