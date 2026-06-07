; ============================================================================
; func_043CE7_unknown
; Region   : load_image
; Bytes    : file 0x043CE7..0x043D56  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043CE7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
043CEB  50                    PUSH   ax                           ; UNKNOWN
043CEC  56                    PUSH   si                           ; UNKNOWN
043CED  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
043CF2  39 16 34 0B           CMP    word ptr [0xb34], dx         ; UNKNOWN
043CF6  7F 58                 JG     0x43d50                      ; UNKNOWN
043CF8  C7 46 FE A0 00        MOV    word ptr [bp - 2], 0xa0      ; UNKNOWN
043CFD  C4 1E A2 C1           LES    bx, ptr [0xc1a2]             ; UNKNOWN
043D01  2B 1E 94 82           SUB    bx, word ptr [0x8294]        ; UNKNOWN
043D05  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
043D08  25 A0 00              AND    ax, 0xa0                     ; UNKNOWN
043D0B  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
043D0E  75 04                 JNE    0x43d14                      ; UNKNOWN
043D10  83 46 FC 08           ADD    word ptr [bp - 4], 8         ; UNKNOWN
043D14  8B 1E A2 C1           MOV    bx, word ptr [0xc1a2]        ; UNKNOWN
043D18  8B 36 94 82           MOV    si, word ptr [0x8294]        ; UNKNOWN
043D1C  26 8A 00              MOV    al, byte ptr es:[bx + si]    ; UNKNOWN
043D1F  22 46 FE              AND    al, byte ptr [bp - 2]        ; UNKNOWN
043D22  2A E4                 SUB    ah, ah                       ; UNKNOWN
043D24  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
043D27  75 04                 JNE    0x43d2d                      ; UNKNOWN
043D29  83 46 FC 04           ADD    word ptr [bp - 4], 4         ; UNKNOWN
043D2D  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1]     ; UNKNOWN
043D31  22 46 FE              AND    al, byte ptr [bp - 2]        ; UNKNOWN
043D34  2A E4                 SUB    ah, ah                       ; UNKNOWN
043D36  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
043D39  75 04                 JNE    0x43d3f                      ; UNKNOWN
043D3B  83 46 FC 02           ADD    word ptr [bp - 4], 2         ; UNKNOWN
043D3F  26 8A 47 01           MOV    al, byte ptr es:[bx + 1]     ; UNKNOWN
043D43  22 46 FE              AND    al, byte ptr [bp - 2]        ; UNKNOWN
043D46  2A E4                 SUB    ah, ah                       ; UNKNOWN
043D48  3B 46 FA              CMP    ax, word ptr [bp - 6]        ; UNKNOWN
043D4B  75 03                 JNE    0x43d50                      ; UNKNOWN
043D4D  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
043D50  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
043D53  5E                    POP    si                           ; UNKNOWN
043D54  C9                    LEAVE                               ; UNKNOWN
043D55  C3                    RET                                 ; UNKNOWN
