; ============================================================================
; func_040E14_unknown
; Region   : load_image
; Bytes    : file 0x040E14..0x040E44  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040E14  55                    PUSH   bp                           ; UNKNOWN
040E15  8B EC                 MOV    bp, sp                       ; UNKNOWN
040E17  57                    PUSH   di                           ; UNKNOWN
040E18  56                    PUSH   si                           ; UNKNOWN
040E19  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040E1C  8B C6                 MOV    ax, si                       ; UNKNOWN
040E1E  0E                    PUSH   cs                           ; UNKNOWN
040E1F  E8 56 ED              CALL   0x3fb78                      ; UNKNOWN
040E22  8B F0                 MOV    si, ax                       ; UNKNOWN
040E24  0B F6                 OR     si, si                       ; UNKNOWN
040E26  7C 18                 JL     0x40e40                      ; UNKNOWN
040E28  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
040E2B  8B C7                 MOV    ax, di                       ; UNKNOWN
040E2D  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040E30  88 87 88 88           MOV    byte ptr [bx - 0x7778], al   ; UNKNOWN
040E34  8B C6                 MOV    ax, si                       ; UNKNOWN
040E36  0E                    PUSH   cs                           ; UNKNOWN
040E37  E8 84 ED              CALL   0x3fbbe                      ; UNKNOWN
040E3A  8B F0                 MOV    si, ax                       ; UNKNOWN
040E3C  0B F6                 OR     si, si                       ; UNKNOWN
040E3E  7D EB                 JGE    0x40e2b                      ; UNKNOWN
040E40  5E                    POP    si                           ; UNKNOWN
040E41  5F                    POP    di                           ; UNKNOWN
040E42  C9                    LEAVE                               ; UNKNOWN
040E43  CB                    RETF                                ; UNKNOWN
