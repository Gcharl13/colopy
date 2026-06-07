; ============================================================================
; func_03CC09_unknown
; Region   : load_image
; Bytes    : file 0x03CC09..0x03CC2D  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CC09  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CC0D  6B 5E 06 4E           IMUL   bx, word ptr [bp + 6], 0x4e  ; UNKNOWN
03CC11  8A 87 C6 7F           MOV    al, byte ptr [bx + 0x7fc6]   ; UNKNOWN
03CC15  2A E4                 SUB    ah, ah                       ; UNKNOWN
03CC17  0B C0                 OR     ax, ax                       ; UNKNOWN
03CC19  74 08                 JE     0x3cc23                      ; UNKNOWN
03CC1B  48                    DEC    ax                           ; UNKNOWN
03CC1C  74 05                 JE     0x3cc23                      ; UNKNOWN
03CC1E  48                    DEC    ax                           ; UNKNOWN
03CC1F  74 0C                 JE     0x3cc2d                      ; UNKNOWN
03CC21  EB 14                 JMP    0x3cc37                      ; UNKNOWN
03CC23  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03CC28  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CC2B  C9                    LEAVE                               ; UNKNOWN
03CC2C  CB                    RETF                                ; UNKNOWN
