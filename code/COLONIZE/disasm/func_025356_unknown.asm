; ============================================================================
; func_025356_unknown
; Region   : load_image
; Bytes    : file 0x025356..0x025378  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025356  C8 20 00 00           ENTER  0x20, 0                      ; UNKNOWN
02535A  56                    PUSH   si                           ; UNKNOWN
02535B  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
02535E  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54]  ; UNKNOWN
025362  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56]  ; UNKNOWN
025366  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
025369  89 56 E2              MOV    word ptr [bp - 0x1e], dx     ; UNKNOWN
02536C  2B C0                 SUB    ax, ax                       ; UNKNOWN
02536E  89 46 E6              MOV    word ptr [bp - 0x1a], ax     ; UNKNOWN
025371  89 46 E4              MOV    word ptr [bp - 0x1c], ax     ; UNKNOWN
025374  8B C2                 MOV    ax, dx                       ; UNKNOWN
025376  0B                    DB     0x0B                         ; UNKNOWN (raw)
025377  46                    DB     0x46                         ; UNKNOWN (raw)
