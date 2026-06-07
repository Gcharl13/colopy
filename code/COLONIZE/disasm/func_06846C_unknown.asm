; ============================================================================
; func_06846C_unknown
; Region   : load_image
; Bytes    : file 0x06846C..0x068489  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06846C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
068470  57                    PUSH   di                           ; UNKNOWN
068471  56                    PUSH   si                           ; UNKNOWN
068472  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
068475  26 8B 0D              MOV    cx, word ptr es:[di]         ; UNKNOWN
068478  A1 EC CE              MOV    ax, word ptr [0xceec]        ; UNKNOWN
06847B  8B 16 EE CE           MOV    dx, word ptr [0xceee]        ; UNKNOWN
06847F  83 FA FF              CMP    dx, -1                       ; UNKNOWN
068482  74 1C                 JE     0x684a0                      ; UNKNOWN
068484  50                    PUSH   ax                           ; UNKNOWN
068485  0B C2                 OR     ax, dx                       ; UNKNOWN
068487  58                    POP    ax                           ; UNKNOWN
068488  74                    DB     0x74                         ; UNKNOWN (raw)
