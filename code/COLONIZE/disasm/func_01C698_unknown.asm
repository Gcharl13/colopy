; ============================================================================
; func_01C698_unknown
; Region   : load_image
; Bytes    : file 0x01C698..0x01C6B9  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01C698  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
01C69C  81 3E E4 0E 9E 00     CMP    word ptr [0xee4], 0x9e       ; UNKNOWN
01C6A2  7C 1F                 JL     0x1c6c3                      ; UNKNOWN
01C6A4  6A 59                 PUSH   0x59                         ; UNKNOWN
01C6A6  2B C0                 SUB    ax, ax                       ; UNKNOWN
01C6A8  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
01C6AB  50                    PUSH   ax                           ; UNKNOWN
01C6AC  A1 E2 0E              MOV    ax, word ptr [0xee2]         ; UNKNOWN
01C6AF  2D D5 00              SUB    ax, 0xd5                     ; UNKNOWN
01C6B2  50                    PUSH   ax                           ; UNKNOWN
01C6B3  9A 08 00 C2 44        LCALL  0x44c2, 8                    ; UNKNOWN
01C6B8  83                    DB     0x83                         ; UNKNOWN (raw)
