; ============================================================================
; func_03724E_unknown
; Region   : load_image
; Bytes    : file 0x03724E..0x037295  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03724E  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
037252  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
037257  7D 13                 JGE    0x3726c                      ; UNKNOWN
037259  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
03725E  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
037263  75 07                 JNE    0x3726c                      ; UNKNOWN
037265  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03726A  EB 05                 JMP    0x37271                      ; UNKNOWN
03726C  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
037271  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
037275  80 7F 01 3C           CMP    byte ptr [bx + 1], 0x3c      ; UNKNOWN
037279  7C 1A                 JL     0x37295                      ; UNKNOWN
03727B  83 7E FE 00           CMP    word ptr [bp - 2], 0         ; UNKNOWN
03727F  75 03                 JNE    0x37284                      ; UNKNOWN
037281  E9 B1 00              JMP    0x37335                      ; UNKNOWN
037284  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
037288  8D 06 AD 20           LEA    ax, [0x20ad]                 ; UNKNOWN
03728C  2B D2                 SUB    dx, dx                       ; UNKNOWN
03728E  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
037293  C9                    LEAVE                               ; UNKNOWN
037294  CB                    RETF                                ; UNKNOWN
