; ============================================================================
; func_03A984_unknown
; Region   : load_image
; Bytes    : file 0x03A984..0x03AA23  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03A984  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03A988  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
03A98C  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
03A990  9A F1 01 C9 33        LCALL  0x33c9, 0x1f1                ; UNKNOWN
03A995  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A998  98                    CWDE                                ; UNKNOWN
03A999  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03A99C  F6 06 FB 3D 20        TEST   byte ptr [0x3dfb], 0x20      ; UNKNOWN
03A9A1  75 0B                 JNE    0x3a9ae                      ; UNKNOWN
03A9A3  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03A9A6  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
03A9A9  74 03                 JE     0x3a9ae                      ; UNKNOWN
03A9AB  E9 8D 01              JMP    0x3ab3b                      ; UNKNOWN
03A9AE  A1 8E 82              MOV    ax, word ptr [0x828e]        ; UNKNOWN
03A9B1  8B 16 8C 82           MOV    dx, word ptr [0x828c]        ; UNKNOWN
03A9B5  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03A9BA  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03A9BD  83 3E 08 3E 00        CMP    word ptr [0x3e08], 0         ; UNKNOWN
03A9C2  75 06                 JNE    0x3a9ca                      ; UNKNOWN
03A9C4  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03A9C7  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03A9CA  0B C0                 OR     ax, ax                       ; UNKNOWN
03A9CC  7D 03                 JGE    0x3a9d1                      ; UNKNOWN
03A9CE  E9 F2 00              JMP    0x3aac3                      ; UNKNOWN
03A9D1  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03A9D4  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
03A9D9  72 48                 JB     0x3aa23                      ; UNKNOWN
03A9DB  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
03A9E0  77 41                 JA     0x3aa23                      ; UNKNOWN
03A9E2  50                    PUSH   ax                           ; UNKNOWN
03A9E3  9A 9C 10 B7 36        LCALL  0x36b7, 0x109c               ; UNKNOWN
03A9E8  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03A9EB  6A 02                 PUSH   2                            ; UNKNOWN
03A9ED  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03A9F0  9A 26 0D B7 36        LCALL  0x36b7, 0xd26                ; UNKNOWN
03A9F5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03A9F8  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03A9FB  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
03A9FF  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
03AA03  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03AA06  9A 0A 04 B7 36        LCALL  0x36b7, 0x40a                ; UNKNOWN
03AA0B  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03AA0E  83 7E FE 01           CMP    word ptr [bp - 2], 1         ; UNKNOWN
03AA12  7E 0F                 JLE    0x3aa23                      ; UNKNOWN
03AA14  6A 00                 PUSH   0                            ; UNKNOWN
03AA16  68 2A 23              PUSH   0x232a                       ; UNKNOWN
03AA19  9A 41 37 97 1B        LCALL  0x1b97, 0x3741               ; UNKNOWN
03AA1E  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03AA21  C9                    LEAVE                               ; UNKNOWN
03AA22  CB                    RETF                                ; UNKNOWN
