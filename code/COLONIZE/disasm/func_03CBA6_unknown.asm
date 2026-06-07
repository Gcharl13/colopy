; ============================================================================
; func_03CBA6_unknown
; Region   : load_image
; Bytes    : file 0x03CBA6..0x03CBD2  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CBA6  55                    PUSH   bp                           ; UNKNOWN
03CBA7  8B EC                 MOV    bp, sp                       ; UNKNOWN
03CBA9  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CBAC  A3 3A 82              MOV    word ptr [0x823a], ax        ; UNKNOWN
03CBAF  0B C0                 OR     ax, ax                       ; UNKNOWN
03CBB1  7C 05                 JL     0x3cbb8                      ; UNKNOWN
03CBB3  83 F8 08              CMP    ax, 8                        ; UNKNOWN
03CBB6  7C 05                 JL     0x3cbbd                      ; UNKNOWN
03CBB8  C7 46 06 00 00        MOV    word ptr [bp + 6], 0         ; UNKNOWN
03CBBD  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CBC0  83 C0 04              ADD    ax, 4                        ; UNKNOWN
03CBC3  A3 84 C0              MOV    word ptr [0xc084], ax        ; UNKNOWN
03CBC6  6B 46 06 4E           IMUL   ax, word ptr [bp + 6], 0x4e  ; UNKNOWN
03CBCA  05 C4 7F              ADD    ax, 0x7fc4                   ; UNKNOWN
03CBCD  A3 38 82              MOV    word ptr [0x8238], ax        ; UNKNOWN
03CBD0  C9                    LEAVE                               ; UNKNOWN
03CBD1  CB                    RETF                                ; UNKNOWN
