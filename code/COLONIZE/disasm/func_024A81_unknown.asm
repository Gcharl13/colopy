; ============================================================================
; func_024A81_unknown
; Region   : load_image
; Bytes    : file 0x024A81..0x024AAB  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024A81  C8 8C 00 00           ENTER  0x8c, 0                      ; UNKNOWN
024A85  57                    PUSH   di                           ; UNKNOWN
024A86  56                    PUSH   si                           ; UNKNOWN
024A87  C4 5E 04              LES    bx, ptr [bp + 4]             ; UNKNOWN
024A8A  26 8B 47 6E           MOV    ax, word ptr es:[bx + 0x6e]  ; UNKNOWN
024A8E  26 0B 47 6C           OR     ax, word ptr es:[bx + 0x6c]  ; UNKNOWN
024A92  75 03                 JNE    0x24a97                      ; UNKNOWN
024A94  E9 0A 02              JMP    0x24ca1                      ; UNKNOWN
024A97  83 3E 04 0A 07        CMP    word ptr [0xa04], 7          ; UNKNOWN
024A9C  7E 05                 JLE    0x24aa3                      ; UNKNOWN
024A9E  B8 01 00              MOV    ax, 1                        ; UNKNOWN
024AA1  EB 02                 JMP    0x24aa5                      ; UNKNOWN
024AA3  2B C0                 SUB    ax, ax                       ; UNKNOWN
024AA5  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
024AA9  8B C3                 MOV    ax, bx                       ; UNKNOWN
