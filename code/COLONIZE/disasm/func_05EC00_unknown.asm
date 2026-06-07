; ============================================================================
; func_05EC00_unknown
; Region   : load_image
; Bytes    : file 0x05EC00..0x05EC42  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05EC00  55                    PUSH   bp                           ; UNKNOWN
05EC01  8B EC                 MOV    bp, sp                       ; UNKNOWN
05EC03  56                    PUSH   si                           ; UNKNOWN
05EC04  9A 3B 0A 5F 24        LCALL  0x245f, 0xa3b                ; UNKNOWN
05EC09  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
05EC0C  D1 E6                 SHL    si, 1                        ; UNKNOWN
05EC0E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EC12  39 80 9A 00           CMP    word ptr [bx + si + 0x9a], ax ; UNKNOWN
05EC16  7C 05                 JL     0x5ec1d                      ; UNKNOWN
05EC18  C7 46 08 00 00        MOV    word ptr [bp + 8], 0         ; UNKNOWN
05EC1D  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
05EC20  D1 E3                 SHL    bx, 1                        ; UNKNOWN
05EC22  83 BF 88 73 00        CMP    word ptr [bx + 0x7388], 0    ; UNKNOWN
05EC27  74 05                 JE     0x5ec2e                      ; UNKNOWN
05EC29  C7 46 08 00 00        MOV    word ptr [bp + 8], 0         ; UNKNOWN
05EC2E  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
05EC32  74 0E                 JE     0x5ec42                      ; UNKNOWN
05EC34  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
05EC37  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
05EC3B  88 87 8D 00           MOV    byte ptr [bx + 0x8d], al     ; UNKNOWN
05EC3F  5E                    POP    si                           ; UNKNOWN
05EC40  C9                    LEAVE                               ; UNKNOWN
05EC41  CB                    RETF                                ; UNKNOWN
