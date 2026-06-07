; ============================================================================
; func_030882_unknown
; Region   : load_image
; Bytes    : file 0x030882..0x0308D4  (82 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030882  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
030886  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
03088B  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03088F  7D 07                 JGE    0x30898                      ; UNKNOWN
030891  2B C0                 SUB    ax, ax                       ; UNKNOWN
030893  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
030896  EB 26                 JMP    0x308be                      ; UNKNOWN
030898  83 7E 06 2A           CMP    word ptr [bp + 6], 0x2a      ; UNKNOWN
03089C  7D 0A                 JGE    0x308a8                      ; UNKNOWN
03089E  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
0308A3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0308A6  EB 16                 JMP    0x308be                      ; UNKNOWN
0308A8  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0308AB  83 E8 2A              SUB    ax, 0x2a                     ; UNKNOWN
0308AE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0308B1  83 F8 07              CMP    ax, 7                        ; UNKNOWN
0308B4  7D 0B                 JGE    0x308c1                      ; UNKNOWN
0308B6  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2         ; UNKNOWN
0308BB  83 C0 0B              ADD    ax, 0xb                      ; UNKNOWN
0308BE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
0308C1  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0308C5  74 08                 JE     0x308cf                      ; UNKNOWN
0308C7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0308CA  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
0308CD  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0308CF  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
0308D2  C9                    LEAVE                               ; UNKNOWN
0308D3  CB                    RETF                                ; UNKNOWN
