; ============================================================================
; func_012A66_unknown
; Region   : load_image
; Bytes    : file 0x012A66..0x012A83  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012A66  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
012A6A  57                    PUSH   di ; STACK_PUSH
012A6B  56                    PUSH   si ; STACK_PUSH
012A6C  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
012A6F  26 8B 0D              MOV    cx, word ptr es:[di] ; MOV
012A72  A1 30 A6              MOV    ax, word ptr [0xa630] ; GLOBAL_LOAD
012A75  8B 16 32 A6           MOV    dx, word ptr [0xa632] ; GLOBAL_LOAD
012A79  83 FA FF              CMP    dx, -1 ; CMP
012A7C  74 1C                 JE     0x12a9a ; CJUMP
012A7E  50                    PUSH   ax ; STACK_PUSH
012A7F  0B C2                 OR     ax, dx ; LOGIC
012A81  58                    POP    ax ; STACK_POP
012A82  74                    DB     0x74 ; DATA_BYTE
