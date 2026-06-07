; ============================================================================
; func_01FB3D_unknown
; Region   : load_image
; Bytes    : file 0x01FB3D..0x01FB6D  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01FB3D  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
01FB41  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
01FB46  2B C0                 SUB    ax, ax                       ; UNKNOWN
01FB48  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
01FB4B  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01FB4E  EB 3F                 JMP    0x1fb8f                      ; UNKNOWN
01FB50  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
01FB53  9A 32 00 5F 24        LCALL  0x245f, 0x32                 ; UNKNOWN
01FB58  83 C4 02              ADD    sp, 2                        ; UNKNOWN
01FB5B  A0 10 3E              MOV    al, byte ptr [0x3e10]        ; UNKNOWN
01FB5E  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
01FB62  38 47 1A              CMP    byte ptr [bx + 0x1a], al     ; UNKNOWN
01FB65  75 25                 JNE    0x1fb8c                      ; UNKNOWN
01FB67  69 5E FA CA 00        IMUL   bx, word ptr [bp - 6], 0xca  ; UNKNOWN
01FB6C  F6                    DB     0xF6                         ; UNKNOWN (raw)
