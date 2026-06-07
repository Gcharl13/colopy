; ============================================================================
; func_0335E2_unknown
; Region   : load_image
; Bytes    : file 0x0335E2..0x033637  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0335E2  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0335E6  C7 06 AA 79 00 00     MOV    word ptr [0x79aa], 0         ; UNKNOWN
0335EC  A1 9A 79              MOV    ax, word ptr [0x799a]        ; UNKNOWN
0335EF  83 E8 14              SUB    ax, 0x14                     ; UNKNOWN
0335F2  8B D0                 MOV    dx, ax                       ; UNKNOWN
0335F4  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
0335F9  EB 1D                 JMP    0x33618                      ; UNKNOWN
0335FB  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
0335FE  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
033603  72 07                 JB     0x3360c                      ; UNKNOWN
033605  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
03360A  76 04                 JBE    0x33610                      ; UNKNOWN
03360C  FF 06 AA 79           INC    word ptr [0x79aa]            ; UNKNOWN
033610  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
033613  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
033618  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03361B  0B C0                 OR     ax, ax                       ; UNKNOWN
03361D  7D DC                 JGE    0x335fb                      ; UNKNOWN
03361F  83 3E AA 79 00        CMP    word ptr [0x79aa], 0         ; UNKNOWN
033624  74 0F                 JE     0x33635                      ; UNKNOWN
033626  A1 AA 79              MOV    ax, word ptr [0x79aa]        ; UNKNOWN
033629  39 06 AC 79           CMP    word ptr [0x79ac], ax        ; UNKNOWN
03362D  7C 06                 JL     0x33635                      ; UNKNOWN
03362F  C7 06 AC 79 00 00     MOV    word ptr [0x79ac], 0         ; UNKNOWN
033635  C9                    LEAVE                               ; UNKNOWN
033636  CB                    RETF                                ; UNKNOWN
