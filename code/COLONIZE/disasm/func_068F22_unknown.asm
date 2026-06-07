; ============================================================================
; func_068F22_unknown
; Region   : load_image
; Bytes    : file 0x068F22..0x068F49  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068F22  55                    PUSH   bp                           ; UNKNOWN
068F23  8B EC                 MOV    bp, sp                       ; UNKNOWN
068F25  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
068F28  9A DA 24 65 5F        LCALL  0x5f65, 0x24da               ; UNKNOWN
068F2D  8B E5                 MOV    sp, bp                       ; UNKNOWN
068F2F  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
068F32  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
068F34  89 57 02              MOV    word ptr [bx + 2], dx        ; UNKNOWN
068F37  3D FF FF              CMP    ax, 0xffff                   ; UNKNOWN
068F3A  75 04                 JNE    0x68f40                      ; UNKNOWN
068F3C  3B D0                 CMP    dx, ax                       ; UNKNOWN
068F3E  74 04                 JE     0x68f44                      ; UNKNOWN
068F40  2B C0                 SUB    ax, ax                       ; UNKNOWN
068F42  EB 03                 JMP    0x68f47                      ; UNKNOWN
068F44  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
068F47  5D                    POP    bp                           ; UNKNOWN
068F48  CB                    RETF                                ; UNKNOWN
