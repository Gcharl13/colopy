; ============================================================================
; func_012ADA_unknown
; Region   : load_image
; Bytes    : file 0x012ADA..0x012AF6  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012ADA  55                    PUSH   bp ; STACK_PUSH
012ADB  8B EC                 MOV    bp, sp ; MOV
012ADD  57                    PUSH   di ; STACK_PUSH
012ADE  56                    PUSH   si ; STACK_PUSH
012ADF  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
012AE2  26 8B 0D              MOV    cx, word ptr es:[di] ; MOV
012AE5  A1 2C A6              MOV    ax, word ptr [0xa62c] ; GLOBAL_LOAD
012AE8  8B 16 2E A6           MOV    dx, word ptr [0xa62e] ; GLOBAL_LOAD
012AEC  83 FA FF              CMP    dx, -1 ; CMP
012AEF  74 1C                 JE     0x12b0d ; CJUMP
012AF1  50                    PUSH   ax ; STACK_PUSH
012AF2  0B C2                 OR     ax, dx ; LOGIC
012AF4  58                    POP    ax ; STACK_POP
012AF5  74                    DB     0x74 ; DATA_BYTE
