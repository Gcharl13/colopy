; ============================================================================
; func_009A32_unknown
; Region   : load_image
; Bytes    : file 0x009A32..0x009A6A  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009A32  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
009A36  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
009A3B  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
009A3E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
009A41  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
009A46  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
009A49  0B C0                 OR     ax, ax ; LOGIC
009A4B  74 18                 JE     0x9a65 ; CJUMP
009A4D  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
009A50  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
009A53  9A 42 01 7F 03        LCALL  0x37f, 0x142 ; LCALL
009A58  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
009A5B  84 46 0A              TEST   byte ptr [bp + 0xa], al ; LOGIC
009A5E  74 05                 JE     0x9a65 ; CJUMP
009A60  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
009A65  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
009A68  C9                    LEAVE ; EPILOGUE
009A69  CB                    RETF ; RETURN
