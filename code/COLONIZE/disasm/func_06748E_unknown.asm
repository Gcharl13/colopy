; ============================================================================
; func_06748E_unknown
; Region   : load_image
; Bytes    : file 0x06748E..0x0674A3  (21 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06748E  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
067492  06                    PUSH   es                           ; UNKNOWN
067493  57                    PUSH   di                           ; UNKNOWN
067494  C4 7E 06              LES    di, ptr [bp + 6]             ; UNKNOWN
067497  8C C0                 MOV    ax, es                       ; UNKNOWN
067499  9C                    PUSHF                               ; UNKNOWN
06749A  FA                    CLI                                 ; UNKNOWN
06749B  89 3E C8 CE           MOV    word ptr [0xcec8], di        ; UNKNOWN
06749F  A3 CA CE              MOV    word ptr [0xceca], ax        ; UNKNOWN
0674A2  0B                    DB     0x0B                         ; UNKNOWN (raw)
