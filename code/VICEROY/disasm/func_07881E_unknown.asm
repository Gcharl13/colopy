; ============================================================================
; func_07881E_unknown
; Region   : overlay
; Bytes    : file 0x07881E..0x078855  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07881E  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
078822  53                    PUSH   bx ; STACK_PUSH
078823  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
078828  8B 47 06              MOV    ax, word ptr [bx + 6] ; MOV
07882B  0B 47 04              OR     ax, word ptr [bx + 4] ; LOGIC
07882E  74 10                 JE     0x78840 ; CJUMP
078830  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
078833  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
078836  9A A8 01 1F 19        LCALL  0x191f, 0x1a8 ; THUNK -> 0x0000:0x01AA (thunk @file 0x01B798 type A) overlay @file 0x025AAA
07883B  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
078840  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
078843  2B C0                 SUB    ax, ax ; ARITH
078845  89 47 06              MOV    word ptr [bx + 6], ax ; MOV
078848  89 47 04              MOV    word ptr [bx + 4], ax ; MOV
07884B  89 47 02              MOV    word ptr [bx + 2], ax ; MOV
07884E  89 07                 MOV    word ptr [bx], ax ; MOV
078850  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
078853  C9                    LEAVE ; EPILOGUE
078854  CB                    RETF ; RETURN
