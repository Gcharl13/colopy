; ============================================================================
; func_008D26_unknown
; Region   : load_image
; Bytes    : file 0x008D26..0x008D6B  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008D26  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
008D2A  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
008D2F  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008D32  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008D35  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
008D3A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008D3D  0B C0                 OR     ax, ax ; LOGIC
008D3F  74 56                 JE     0x8d97 ; CJUMP
008D41  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008D44  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008D47  9A 58 03 7F 03        LCALL  0x37f, 0x358 ; LCALL
008D4C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008D4F  0B C0                 OR     ax, ax ; LOGIC
008D51  7C 44                 JL     0x8d97 ; CJUMP
008D53  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
008D58  EB 28                 JMP    0x8d82 ; JUMP
008D5A  A1 9E 53              MOV    ax, word ptr [0x539e] ; GLOBAL_LOAD
008D5D  39 46 FE              CMP    word ptr [bp - 2], ax ; CMP
008D60  7D 26                 JGE    0x8d88 ; CJUMP
008D62  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
008D65  69 5E FE CA 00        IMUL   bx, word ptr [bp - 2], 0xca ; ARITH
008D6A  38                    DB     0x38 ; DATA_BYTE
