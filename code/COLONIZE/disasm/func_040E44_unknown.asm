; ============================================================================
; func_040E44_unknown
; Region   : load_image
; Bytes    : file 0x040E44..0x040E6D  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040E44  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040E48  56                    PUSH   si                           ; UNKNOWN
040E49  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040E4C  0B F6                 OR     si, si                       ; UNKNOWN
040E4E  7C 29                 JL     0x40e79                      ; UNKNOWN
040E50  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040E53  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
040E57  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
040E5A  3C 0D                 CMP    al, 0xd                      ; UNKNOWN
040E5C  72 0F                 JB     0x40e6d                      ; UNKNOWN
040E5E  3C 12                 CMP    al, 0x12                     ; UNKNOWN
040E60  77 0B                 JA     0x40e6d                      ; UNKNOWN
040E62  56                    PUSH   si                           ; UNKNOWN
040E63  0E                    PUSH   cs                           ; UNKNOWN
040E64  E8 A5 FD              CALL   0x40c0c                      ; UNKNOWN
040E67  83 C4 02              ADD    sp, 2                        ; UNKNOWN
040E6A  5E                    POP    si                           ; UNKNOWN
040E6B  C9                    LEAVE                               ; UNKNOWN
040E6C  CB                    RETF                                ; UNKNOWN
