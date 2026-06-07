; ============================================================================
; func_046C1C_unknown
; Region   : load_image
; Bytes    : file 0x046C1C..0x046C56  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

046C1C  C8 4E 00 00           ENTER  0x4e, 0                      ; UNKNOWN
046C20  56                    PUSH   si                           ; UNKNOWN
046C21  2B C0                 SUB    ax, ax                       ; UNKNOWN
046C23  89 46 BA              MOV    word ptr [bp - 0x46], ax     ; UNKNOWN
046C26  89 46 B6              MOV    word ptr [bp - 0x4a], ax     ; UNKNOWN
046C29  39 46 0A              CMP    word ptr [bp + 0xa], ax      ; UNKNOWN
046C2C  74 0B                 JE     0x46c39                      ; UNKNOWN
046C2E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
046C31  9A 9E 03 B7 36        LCALL  0x36b7, 0x39e                ; UNKNOWN
046C36  83 C4 02              ADD    sp, 2                        ; UNKNOWN
046C39  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
046C3C  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
046C41  EB 49                 JMP    0x46c8c                      ; UNKNOWN
046C43  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
046C46  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
046C4B  72 37                 JB     0x46c84                      ; UNKNOWN
046C4D  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
046C52  77 30                 JA     0x46c84                      ; UNKNOWN
046C54  8B C3                 MOV    ax, bx                       ; UNKNOWN
