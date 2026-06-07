; ============================================================================
; func_03AB3D_unknown
; Region   : load_image
; Bytes    : file 0x03AB3D..0x03AC07  (202 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03AB3D  C8 64 00 00           ENTER  0x64, 0                      ; UNKNOWN
03AB41  56                    PUSH   si                           ; UNKNOWN
03AB42  C7 46 A8 01 00        MOV    word ptr [bp - 0x58], 1      ; UNKNOWN
03AB47  C7 46 AE 00 00        MOV    word ptr [bp - 0x52], 0      ; UNKNOWN
03AB4C  2B C0                 SUB    ax, ax                       ; UNKNOWN
03AB4E  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
03AB51  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
03AB54  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03AB57  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
03AB5A  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
03AB5F  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
03AB62  0B C0                 OR     ax, ax                       ; UNKNOWN
03AB64  7D 03                 JGE    0x3ab69                      ; UNKNOWN
03AB66  E9 5B 02              JMP    0x3adc4                      ; UNKNOWN
03AB69  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03AB6C  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
03AB70  24 0F                 AND    al, 0xf                      ; UNKNOWN
03AB72  3A 06 0C 3E           CMP    al, byte ptr [0x3e0c]        ; UNKNOWN
03AB76  74 03                 JE     0x3ab7b                      ; UNKNOWN
03AB78  E9 49 02              JMP    0x3adc4                      ; UNKNOWN
03AB7B  6A 00                 PUSH   0                            ; UNKNOWN
03AB7D  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
03AB80  9A D3 04 B7 36        LCALL  0x36b7, 0x4d3                ; UNKNOWN
03AB85  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03AB88  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
03AB8B  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
03AB90  89 46 AA              MOV    word ptr [bp - 0x56], ax     ; UNKNOWN
03AB93  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03AB96  83 BF 9A 88 00        CMP    word ptr [bx - 0x7766], 0    ; UNKNOWN
03AB9B  7D 24                 JGE    0x3abc1                      ; UNKNOWN
03AB9D  8B F3                 MOV    si, bx                       ; UNKNOWN
03AB9F  9A 0C 13 B7 36        LCALL  0x36b7, 0x130c               ; UNKNOWN
03ABA4  0B C0                 OR     ax, ax                       ; UNKNOWN
03ABA6  75 07                 JNE    0x3abaf                      ; UNKNOWN
03ABA8  80 BC 88 88 00        CMP    byte ptr [si - 0x7778], 0    ; UNKNOWN
03ABAD  74 12                 JE     0x3abc1                      ; UNKNOWN
03ABAF  6B 5E AA 1C           IMUL   bx, word ptr [bp - 0x56], 0x1c ; UNKNOWN
03ABB3  C6 87 88 88 00        MOV    byte ptr [bx - 0x7778], 0    ; UNKNOWN
03ABB8  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
03ABBB  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
03ABBE  E9 A7 01              JMP    0x3ad68                      ; UNKNOWN
03ABC1  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
03ABC5  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
03ABC9  68 00 08              PUSH   0x800                        ; UNKNOWN
03ABCC  9A BE 06 97 1B        LCALL  0x1b97, 0x6be                ; UNKNOWN
03ABD1  83 C4 06              ADD    sp, 6                        ; UNKNOWN
03ABD4  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
03ABD7  89 56 A6              MOV    word ptr [bp - 0x5a], dx     ; UNKNOWN
03ABDA  0B D0                 OR     dx, ax                       ; UNKNOWN
03ABDC  75 03                 JNE    0x3abe1                      ; UNKNOWN
03ABDE  E9 E3 01              JMP    0x3adc4                      ; UNKNOWN
03ABE1  C4 5E A4              LES    bx, ptr [bp - 0x5c]          ; UNKNOWN
03ABE4  26 C7 47 46 00 00     MOV    word ptr es:[bx + 0x46], 0   ; UNKNOWN
03ABEA  B8 02 00              MOV    ax, 2                        ; UNKNOWN
03ABED  26 89 47 4A           MOV    word ptr es:[bx + 0x4a], ax  ; UNKNOWN
03ABF1  0C 80                 OR     al, 0x80                     ; UNKNOWN
03ABF3  26 09 47 0A           OR     word ptr es:[bx + 0xa], ax   ; UNKNOWN
03ABF7  8B 46 AA              MOV    ax, word ptr [bp - 0x56]     ; UNKNOWN
03ABFA  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
03ABFD  C7 46 9E 01 00        MOV    word ptr [bp - 0x62], 1      ; UNKNOWN
03AC02  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03AC05  8B C3                 MOV    ax, bx                       ; UNKNOWN
