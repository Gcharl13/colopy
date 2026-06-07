; ============================================================================
; func_02DC48_unknown
; Region   : load_image
; Bytes    : file 0x02DC48..0x02DC86  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DC48  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02DC4C  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DC4F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DC52  0E                    PUSH   cs                           ; UNKNOWN
02DC53  E8 6D FF              CALL   0x2dbc3                      ; UNKNOWN
02DC56  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02DC59  0B C0                 OR     ax, ax                       ; UNKNOWN
02DC5B  7C 27                 JL     0x2dc84                      ; UNKNOWN
02DC5D  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02DC60  6A 10                 PUSH   0x10                         ; UNKNOWN
02DC62  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DC66  8A 47 01              MOV    al, byte ptr [bx + 1]        ; UNKNOWN
02DC69  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DC6B  48                    DEC    ax                           ; UNKNOWN
02DC6C  48                    DEC    ax                           ; UNKNOWN
02DC6D  01 46 08              ADD    word ptr [bp + 8], ax        ; UNKNOWN
02DC70  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02DC73  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02DC75  2A E4                 SUB    ah, ah                       ; UNKNOWN
02DC77  48                    DEC    ax                           ; UNKNOWN
02DC78  48                    DEC    ax                           ; UNKNOWN
02DC79  01 46 06              ADD    word ptr [bp + 6], ax        ; UNKNOWN
02DC7C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DC7F  9A 53 01 C9 33        LCALL  0x33c9, 0x153                ; UNKNOWN
02DC84  C9                    LEAVE                               ; UNKNOWN
02DC85  CB                    RETF                                ; UNKNOWN
