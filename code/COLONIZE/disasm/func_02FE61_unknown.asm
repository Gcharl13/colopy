; ============================================================================
; func_02FE61_unknown
; Region   : load_image
; Bytes    : file 0x02FE61..0x02FECB  (106 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02FE61  C8 42 00 00           ENTER  0x42, 0                      ; UNKNOWN
02FE65  56                    PUSH   si                           ; UNKNOWN
02FE66  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
02FE6B  2B C0                 SUB    ax, ax                       ; UNKNOWN
02FE6D  89 46 EE              MOV    word ptr [bp - 0x12], ax     ; UNKNOWN
02FE70  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
02FE73  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FE77  8A 47 1A              MOV    al, byte ptr [bx + 0x1a]     ; UNKNOWN
02FE7A  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FE7C  89 46 C8              MOV    word ptr [bp - 0x38], ax     ; UNKNOWN
02FE7F  83 F8 04              CMP    ax, 4                        ; UNKNOWN
02FE82  7D 10                 JGE    0x2fe94                      ; UNKNOWN
02FE84  6B D8 34              IMUL   bx, ax, 0x34                 ; UNKNOWN
02FE87  38 A7 B7 C0           CMP    byte ptr [bx - 0x3f49], ah   ; UNKNOWN
02FE8B  75 07                 JNE    0x2fe94                      ; UNKNOWN
02FE8D  C7 46 DA 01 00        MOV    word ptr [bp - 0x26], 1      ; UNKNOWN
02FE92  EB 05                 JMP    0x2fe99                      ; UNKNOWN
02FE94  C7 46 DA 00 00        MOV    word ptr [bp - 0x26], 0      ; UNKNOWN
02FE99  0E                    PUSH   cs                           ; UNKNOWN
02FE9A  E8 8E E1              CALL   0x2e02b                      ; UNKNOWN
02FE9D  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02FEA0  83 7E DA 00           CMP    word ptr [bp - 0x26], 0      ; UNKNOWN
02FEA4  75 66                 JNE    0x2ff0c                      ; UNKNOWN
02FEA6  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02FEA9  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
02FEAC  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02FEB0  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
02FEB2  2A E4                 SUB    ah, ah                       ; UNKNOWN
02FEB4  8A 57 01              MOV    dl, byte ptr [bx + 1]        ; UNKNOWN
02FEB7  2A F6                 SUB    dh, dh                       ; UNKNOWN
02FEB9  9A 60 00 B7 36        LCALL  0x36b7, 0x60                 ; UNKNOWN
02FEBE  EB 27                 JMP    0x2fee7                      ; UNKNOWN
02FEC0  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
02FEC3  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
02FEC7  2A FF                 SUB    bh, bh                       ; UNKNOWN
02FEC9  8B C3                 MOV    ax, bx                       ; UNKNOWN
