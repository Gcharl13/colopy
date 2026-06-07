; ============================================================================
; func_00AC68_unknown
; Region   : load_image
; Bytes    : file 0x00AC68..0x00AC84  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AC68  55                    PUSH   bp ; STACK_PUSH
00AC69  8B EC                 MOV    bp, sp ; MOV
00AC6B  57                    PUSH   di ; STACK_PUSH
00AC6C  56                    PUSH   si ; STACK_PUSH
00AC6D  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
00AC70  26 8B 0D              MOV    cx, word ptr es:[di] ; MOV
00AC73  A1 22 4C              MOV    ax, word ptr [0x4c22] ; GLOBAL_LOAD
00AC76  8B 16 24 4C           MOV    dx, word ptr [0x4c24] ; GLOBAL_LOAD
00AC7A  83 FA FF              CMP    dx, -1 ; CMP
00AC7D  74 1C                 JE     0xac9b ; CJUMP
00AC7F  50                    PUSH   ax ; STACK_PUSH
00AC80  0B C2                 OR     ax, dx ; LOGIC
00AC82  58                    POP    ax ; STACK_POP
00AC83  74                    DB     0x74 ; DATA_BYTE
