; ============================================================================
; func_041C44_unknown
; Region   : load_image
; Bytes    : file 0x041C44..0x041C90  (76 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041C44  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
041C48  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
041C4B  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
041C4E  0E                    PUSH   cs                           ; UNKNOWN
041C4F  E8 C8 FF              CALL   0x41c1a                      ; UNKNOWN
041C52  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041C55  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
041C58  A1 14 3E              MOV    ax, word ptr [0x3e14]        ; UNKNOWN
041C5B  FF 06 14 3E           INC    word ptr [0x3e14]            ; UNKNOWN
041C5F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
041C62  50                    PUSH   ax                           ; UNKNOWN
041C63  9A 0C 0D B7 36        LCALL  0x36b7, 0xd0c                ; UNKNOWN
041C68  83 C4 04              ADD    sp, 4                        ; UNKNOWN
041C6B  6B 5E FE 1C           IMUL   bx, word ptr [bp - 2], 0x1c  ; UNKNOWN
041C6F  C6 87 82 88 17        MOV    byte ptr [bx - 0x777e], 0x17 ; UNKNOWN
041C74  C6 87 86 88 FF        MOV    byte ptr [bx - 0x777a], 0xff ; UNKNOWN
041C79  C6 87 87 88 2D        MOV    byte ptr [bx - 0x7779], 0x2d ; UNKNOWN
041C7E  C6 87 8C 88 00        MOV    byte ptr [bx - 0x7774], 0    ; UNKNOWN
041C83  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
041C86  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
041C89  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
041C8C  9A                    DB     0x9A                         ; UNKNOWN (raw)
041C8D  CA                    DB     0xCA                         ; UNKNOWN (raw)
041C8E  02                    DB     0x02                         ; UNKNOWN (raw)
041C8F  B7                    DB     0xB7                         ; UNKNOWN (raw)
