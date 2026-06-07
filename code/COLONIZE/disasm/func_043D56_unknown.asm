; ============================================================================
; func_043D56_unknown
; Region   : load_image
; Bytes    : file 0x043D56..0x043D8F  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043D56  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
043D5A  56                    PUSH   si                           ; UNKNOWN
043D5B  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
043D60  C4 1E A2 C1           LES    bx, ptr [0xc1a2]             ; UNKNOWN
043D64  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
043D67  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043D6A  83 E0 1F              AND    ax, 0x1f                     ; UNKNOWN
043D6D  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
043D70  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
043D73  7D 14                 JGE    0x43d89                      ; UNKNOWN
043D75  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
043D78  24 07                 AND    al, 7                        ; UNKNOWN
043D7A  3C 01                 CMP    al, 1                        ; UNKNOWN
043D7C  74 0B                 JE     0x43d89                      ; UNKNOWN
043D7E  83 7E FE 07           CMP    word ptr [bp - 2], 7         ; UNKNOWN
043D82  7E 05                 JLE    0x43d89                      ; UNKNOWN
043D84  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
043D89  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
043D8C  5E                    POP    si                           ; UNKNOWN
043D8D  C9                    LEAVE                               ; UNKNOWN
043D8E  C3                    RET                                 ; UNKNOWN
