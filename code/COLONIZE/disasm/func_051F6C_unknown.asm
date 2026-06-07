; ============================================================================
; func_051F6C_unknown
; Region   : load_image
; Bytes    : file 0x051F6C..0x051FF2  (134 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

051F6C  C8 EE 00 00           ENTER  0xee, 0                      ; UNKNOWN
051F70  57                    PUSH   di                           ; UNKNOWN
051F71  56                    PUSH   si                           ; UNKNOWN
051F72  C7 86 4A FF 01 00     MOV    word ptr [bp - 0xb6], 1      ; UNKNOWN
051F78  2B C0                 SUB    ax, ax                       ; UNKNOWN
051F7A  89 86 74 FF           MOV    word ptr [bp - 0x8c], ax     ; UNKNOWN
051F7E  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
051F81  89 86 54 FF           MOV    word ptr [bp - 0xac], ax     ; UNKNOWN
051F85  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
051F89  8A 87 83 88           MOV    al, byte ptr [bx - 0x777d]   ; UNKNOWN
051F8D  83 E0 0F              AND    ax, 0xf                      ; UNKNOWN
051F90  89 86 1C FF           MOV    word ptr [bp - 0xe4], ax     ; UNKNOWN
051F94  80 BF 88 88 00        CMP    byte ptr [bx - 0x7778], 0    ; UNKNOWN
051F99  74 18                 JE     0x51fb3                      ; UNKNOWN
051F9B  80 BF 88 88 05        CMP    byte ptr [bx - 0x7778], 5    ; UNKNOWN
051FA0  74 11                 JE     0x51fb3                      ; UNKNOWN
051FA2  80 BF 88 88 06        CMP    byte ptr [bx - 0x7778], 6    ; UNKNOWN
051FA7  74 0A                 JE     0x51fb3                      ; UNKNOWN
051FA9  80 BF 88 88 0A        CMP    byte ptr [bx - 0x7778], 0xa  ; UNKNOWN
051FAE  73 03                 JAE    0x51fb3                      ; UNKNOWN
051FB0  E9 00 39              JMP    0x558b3                      ; UNKNOWN
051FB3  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
051FB7  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
051FBB  2A E4                 SUB    ah, ah                       ; UNKNOWN
051FBD  89 86 7A FF           MOV    word ptr [bp - 0x86], ax     ; UNKNOWN
051FC1  8A 8F 81 88           MOV    cl, byte ptr [bx - 0x777f]   ; UNKNOWN
051FC5  2A ED                 SUB    ch, ch                       ; UNKNOWN
051FC7  89 8E 6E FF           MOV    word ptr [bp - 0x92], cx     ; UNKNOWN
051FCB  C7 46 8C 08 00        MOV    word ptr [bp - 0x74], 8      ; UNKNOWN
051FD0  8A 97 82 88           MOV    dl, byte ptr [bx - 0x777e]   ; UNKNOWN
051FD4  2A F6                 SUB    dh, dh                       ; UNKNOWN
051FD6  89 56 9E              MOV    word ptr [bp - 0x62], dx     ; UNKNOWN
051FD9  51                    PUSH   cx                           ; UNKNOWN
051FDA  50                    PUSH   ax                           ; UNKNOWN
051FDB  8B F3                 MOV    si, bx                       ; UNKNOWN
051FDD  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
051FE2  83 C4 04              ADD    sp, 4                        ; UNKNOWN
051FE5  0B C0                 OR     ax, ax                       ; UNKNOWN
051FE7  75 08                 JNE    0x51ff1                      ; UNKNOWN
051FE9  C6 84 87 88 40        MOV    byte ptr [si - 0x7779], 0x40 ; UNKNOWN
051FEE  E9 C2 38              JMP    0x558b3                      ; UNKNOWN
051FF1  6B                    DB     0x6B                         ; UNKNOWN (raw)
