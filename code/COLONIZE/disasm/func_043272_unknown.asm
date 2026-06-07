; ============================================================================
; func_043272_unknown
; Region   : load_image
; Bytes    : file 0x043272..0x0432A4  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043272  55                    PUSH   bp                           ; UNKNOWN
043273  8B EC                 MOV    bp, sp                       ; UNKNOWN
043275  83 3E FF 0A 00        CMP    word ptr [0xaff], 0          ; UNKNOWN
04327A  74 1A                 JE     0x43296                      ; UNKNOWN
04327C  6A 00                 PUSH   0                            ; UNKNOWN
04327E  6A 01                 PUSH   1                            ; UNKNOWN
043280  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
043284  0E                    PUSH   cs                           ; UNKNOWN
043285  E8 41 FF              CALL   0x431c9                      ; UNKNOWN
043288  8B E5                 MOV    sp, bp                       ; UNKNOWN
04328A  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
04328E  74 12                 JE     0x432a2                      ; UNKNOWN
043290  6A 01                 PUSH   1                            ; UNKNOWN
043292  6A 01                 PUSH   1                            ; UNKNOWN
043294  EB 04                 JMP    0x4329a                      ; UNKNOWN
043296  6A 00                 PUSH   0                            ; UNKNOWN
043298  6A 00                 PUSH   0                            ; UNKNOWN
04329A  FF 36 0A 3E           PUSH   word ptr [0x3e0a]            ; UNKNOWN
04329E  0E                    PUSH   cs                           ; UNKNOWN
04329F  E8 27 FF              CALL   0x431c9                      ; UNKNOWN
0432A2  C9                    LEAVE                               ; UNKNOWN
0432A3  CB                    RETF                                ; UNKNOWN
