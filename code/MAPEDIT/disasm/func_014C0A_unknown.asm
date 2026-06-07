; ============================================================================
; func_014C0A_unknown
; Region   : load_image
; Bytes    : file 0x014C0A..0x014C26  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

014C0A  55                    PUSH   bp ; STACK_PUSH
014C0B  8B EC                 MOV    bp, sp ; MOV
014C0D  57                    PUSH   di ; STACK_PUSH
014C0E  56                    PUSH   si ; STACK_PUSH
014C0F  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
014C12  26 8B 0D              MOV    cx, word ptr es:[di] ; MOV
014C15  A1 84 4A              MOV    ax, word ptr [0x4a84] ; GLOBAL_LOAD
014C18  8B 16 86 4A           MOV    dx, word ptr [0x4a86] ; GLOBAL_LOAD
014C1C  83 FA FF              CMP    dx, -1 ; CMP
014C1F  74 1C                 JE     0x14c3d ; CJUMP
014C21  50                    PUSH   ax ; STACK_PUSH
014C22  0B C2                 OR     ax, dx ; LOGIC
014C24  58                    POP    ax ; STACK_POP
014C25  74                    DB     0x74 ; DATA_BYTE
