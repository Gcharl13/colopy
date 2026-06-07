; ============================================================================
; func_03A446_unknown
; Region   : load_image
; Bytes    : file 0x03A446..0x03A49B  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A446  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
03A44A  2B C0                 SUB    ax, ax                       ; UNKNOWN
03A44C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03A44F  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03A452  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A455  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
03A458  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A45B  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03A45F  2A E4                 SUB    ah, ah                       ; UNKNOWN
03A461  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
03A464  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
03A468  2A ED                 SUB    ch, ch                       ; UNKNOWN
03A46A  89 4E F0              MOV    word ptr [bp - 0x10], cx     ; UNKNOWN
03A46D  51                    PUSH   cx                           ; UNKNOWN
03A46E  50                    PUSH   ax                           ; UNKNOWN
03A46F  9A 91 02 C9 33        LCALL  0x33c9, 0x291                ; UNKNOWN
03A474  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A477  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03A47A  FF 76 F0              PUSH   word ptr [bp - 0x10]         ; UNKNOWN
03A47D  FF 76 F2              PUSH   word ptr [bp - 0xe]          ; UNKNOWN
03A480  9A 37 01 C9 33        LCALL  0x33c9, 0x137                ; UNKNOWN
03A485  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A488  A8 0A                 TEST   al, 0xa                      ; UNKNOWN
03A48A  74 0F                 JE     0x3a49b                      ; UNKNOWN
03A48C  6A 03                 PUSH   3                            ; UNKNOWN
03A48E  68 92 22              PUSH   0x2292                       ; UNKNOWN
03A491  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03A496  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A499  C9                    LEAVE                               ; UNKNOWN
03A49A  CB                    RETF                                ; UNKNOWN
