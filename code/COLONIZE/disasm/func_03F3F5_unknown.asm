; ============================================================================
; func_03F3F5_unknown
; Region   : load_image
; Bytes    : file 0x03F3F5..0x03F42B  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03F3F5  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
03F3F9  56                    PUSH   si                           ; UNKNOWN
03F3FA  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03F3FD  D1 E3                 SHL    bx, 1                        ; UNKNOWN
03F3FF  C7 87 C6 86 00 00     MOV    word ptr [bx - 0x793a], 0    ; UNKNOWN
03F405  2A C0                 SUB    al, al                       ; UNKNOWN
03F407  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
03F40A  88 87 92 85           MOV    byte ptr [bx - 0x7a6e], al   ; UNKNOWN
03F40E  88 87 AE 86           MOV    byte ptr [bx - 0x7952], al   ; UNKNOWN
03F412  88 87 B2 86           MOV    byte ptr [bx - 0x794e], al   ; UNKNOWN
03F416  88 87 B6 86           MOV    byte ptr [bx - 0x794a], al   ; UNKNOWN
03F41A  88 87 BA 86           MOV    byte ptr [bx - 0x7946], al   ; UNKNOWN
03F41E  88 87 96 85           MOV    byte ptr [bx - 0x7a6a], al   ; UNKNOWN
03F422  88 87 BE 86           MOV    byte ptr [bx - 0x7942], al   ; UNKNOWN
03F426  88 87 C2 86           MOV    byte ptr [bx - 0x793e], al   ; UNKNOWN
03F42A  88                    DB     0x88                         ; UNKNOWN (raw)
