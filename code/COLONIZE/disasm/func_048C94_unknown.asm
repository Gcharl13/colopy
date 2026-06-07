; ============================================================================
; func_048C94_unknown
; Region   : load_image
; Bytes    : file 0x048C94..0x048CE1  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048C94  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
048C98  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048C9B  B9 18 00              MOV    cx, 0x18                     ; UNKNOWN
048C9E  99                    CDQ                                 ; UNKNOWN
048C9F  F7 F9                 IDIV   cx                           ; UNKNOWN
048CA1  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
048CA4  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
048CA7  99                    CDQ                                 ; UNKNOWN
048CA8  F7 F9                 IDIV   cx                           ; UNKNOWN
048CAA  2B 06 40 C6           SUB    ax, word ptr [0xc640]        ; UNKNOWN
048CAE  78 05                 JS     0x48cb5                      ; UNKNOWN
048CB0  83 F8 02              CMP    ax, 2                        ; UNKNOWN
048CB3  7E 0A                 JLE    0x48cbf                      ; UNKNOWN
048CB5  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
048CB8  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
048CBB  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
048CBD  EB 1B                 JMP    0x48cda                      ; UNKNOWN
048CBF  6B C0 64              IMUL   ax, ax, 0x64                 ; UNKNOWN
048CC2  83 C0 05              ADD    ax, 5                        ; UNKNOWN
048CC5  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
048CC8  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
048CCA  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
048CCD  8B C8                 MOV    cx, ax                       ; UNKNOWN
048CCF  D1 E0                 SHL    ax, 1                        ; UNKNOWN
048CD1  03 C1                 ADD    ax, cx                       ; UNKNOWN
048CD3  D1 E0                 SHL    ax, 1                        ; UNKNOWN
048CD5  03 C1                 ADD    ax, cx                       ; UNKNOWN
048CD7  83 C0 19              ADD    ax, 0x19                     ; UNKNOWN
048CDA  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
048CDD  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
048CDF  C9                    LEAVE                               ; UNKNOWN
048CE0  CB                    RETF                                ; UNKNOWN
