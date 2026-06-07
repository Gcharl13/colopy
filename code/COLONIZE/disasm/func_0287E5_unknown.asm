; ============================================================================
; func_0287E5_unknown
; Region   : load_image
; Bytes    : file 0x0287E5..0x028803  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0287E5  55                    PUSH   bp                           ; UNKNOWN
0287E6  8B EC                 MOV    bp, sp                       ; UNKNOWN
0287E8  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
0287EC  74 15                 JE     0x28803                      ; UNKNOWN
0287EE  C4 1E 8E 40           LES    bx, ptr [0x408e]             ; UNKNOWN
0287F2  26 80 67 02 0F        AND    byte ptr es:[bx + 2], 0xf    ; UNKNOWN
0287F7  8A 46 08              MOV    al, byte ptr [bp + 8]        ; UNKNOWN
0287FA  C0 E0 04              SHL    al, 4                        ; UNKNOWN
0287FD  26 08 47 02           OR     byte ptr es:[bx + 2], al     ; UNKNOWN
028801  C9                    LEAVE                               ; UNKNOWN
028802  CB                    RETF                                ; UNKNOWN
