; ============================================================================
; func_037476_unknown
; Region   : load_image
; Bytes    : file 0x037476..0x0374E6  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037476  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
03747A  56                    PUSH   si                           ; UNKNOWN
03747B  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
037480  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
037484  74 03                 JE     0x37489                      ; UNKNOWN
037486  E9 89 01              JMP    0x37612                      ; UNKNOWN
037489  83 3E 9A 79 04        CMP    word ptr [0x799a], 4         ; UNKNOWN
03748E  7D 16                 JGE    0x374a6                      ; UNKNOWN
037490  6B 1E 9A 79 34        IMUL   bx, word ptr [0x799a], 0x34  ; UNKNOWN
037495  80 BF B7 C0 00        CMP    byte ptr [bx - 0x3f49], 0    ; UNKNOWN
03749A  75 0A                 JNE    0x374a6                      ; UNKNOWN
03749C  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
03749F  2A E4                 SUB    ah, ah                       ; UNKNOWN
0374A1  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
0374A4  EB 05                 JMP    0x374ab                      ; UNKNOWN
0374A6  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1         ; UNKNOWN
0374AB  6A 0F                 PUSH   0xf                          ; UNKNOWN
0374AD  6A 01                 PUSH   1                            ; UNKNOWN
0374AF  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
0374B4  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0374B7  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
0374BA  8B 4E F8              MOV    cx, word ptr [bp - 8]        ; UNKNOWN
0374BD  41                    INC    cx                           ; UNKNOWN
0374BE  41                    INC    cx                           ; UNKNOWN
0374BF  D1 F9                 SAR    cx, 1                        ; UNKNOWN
0374C1  3B C8                 CMP    cx, ax                       ; UNKNOWN
0374C3  7C 21                 JL     0x374e6                      ; UNKNOWN
0374C5  6A 14                 PUSH   0x14                         ; UNKNOWN
0374C7  FF 36 9A 79           PUSH   word ptr [0x799a]            ; UNKNOWN
0374CB  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
0374D0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
0374D3  83 F8 01              CMP    ax, 1                        ; UNKNOWN
0374D6  1B C0                 SBB    ax, ax                       ; UNKNOWN
0374D8  24 FE                 AND    al, 0xfe                     ; UNKNOWN
0374DA  83 C0 1C              ADD    ax, 0x1c                     ; UNKNOWN
0374DD  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
0374E0  8A 46 F6              MOV    al, byte ptr [bp - 0xa]      ; UNKNOWN
0374E3  5E                    POP    si                           ; UNKNOWN
0374E4  C9                    LEAVE                               ; UNKNOWN
0374E5  CB                    RETF                                ; UNKNOWN
