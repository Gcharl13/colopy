; ============================================================================
; func_040DD2_unknown
; Region   : load_image
; Bytes    : file 0x040DD2..0x040E14  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

040DD2  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
040DD6  57                    PUSH   di                           ; UNKNOWN
040DD7  56                    PUSH   si                           ; UNKNOWN
040DD8  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
040DDB  2B FF                 SUB    di, di                       ; UNKNOWN
040DDD  8B C6                 MOV    ax, si                       ; UNKNOWN
040DDF  0E                    PUSH   cs                           ; UNKNOWN
040DE0  E8 95 ED              CALL   0x3fb78                      ; UNKNOWN
040DE3  8B F0                 MOV    si, ax                       ; UNKNOWN
040DE5  0B F6                 OR     si, si                       ; UNKNOWN
040DE7  7C 25                 JL     0x40e0e                      ; UNKNOWN
040DE9  0B FF                 OR     di, di                       ; UNKNOWN
040DEB  75 21                 JNE    0x40e0e                      ; UNKNOWN
040DED  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
040DF0  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
040DF4  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
040DF7  3C 0D                 CMP    al, 0xd                      ; UNKNOWN
040DF9  72 07                 JB     0x40e02                      ; UNKNOWN
040DFB  3C 12                 CMP    al, 0x12                     ; UNKNOWN
040DFD  77 03                 JA     0x40e02                      ; UNKNOWN
040DFF  BF 01 00              MOV    di, 1                        ; UNKNOWN
040E02  8B C6                 MOV    ax, si                       ; UNKNOWN
040E04  0E                    PUSH   cs                           ; UNKNOWN
040E05  E8 B6 ED              CALL   0x3fbbe                      ; UNKNOWN
040E08  8B F0                 MOV    si, ax                       ; UNKNOWN
040E0A  0B F6                 OR     si, si                       ; UNKNOWN
040E0C  7D DB                 JGE    0x40de9                      ; UNKNOWN
040E0E  8B C7                 MOV    ax, di                       ; UNKNOWN
040E10  5E                    POP    si                           ; UNKNOWN
040E11  5F                    POP    di                           ; UNKNOWN
040E12  C9                    LEAVE                               ; UNKNOWN
040E13  CB                    RETF                                ; UNKNOWN
