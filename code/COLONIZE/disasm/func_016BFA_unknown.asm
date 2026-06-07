; ============================================================================
; func_016BFA_unknown
; Region   : load_image
; Bytes    : file 0x016BFA..0x016CDC  (226 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

016BFA  C8 40 00 00           ENTER  0x40, 0                      ; UNKNOWN
016BFE  56                    PUSH   si                           ; UNKNOWN
016BFF  9A 3F 14 5F 24        LCALL  0x245f, 0x143f               ; UNKNOWN
016C04  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
016C09  8D 46 CC              LEA    ax, [bp - 0x34]              ; UNKNOWN
016C0C  89 46 C6              MOV    word ptr [bp - 0x3a], ax     ; UNKNOWN
016C0F  B0 FF                 MOV    al, 0xff                     ; UNKNOWN
016C11  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
016C14  88 87 50 74           MOV    byte ptr [bx + 0x7450], al   ; UNKNOWN
016C18  88 87 41 74           MOV    byte ptr [bx + 0x7441], al   ; UNKNOWN
016C1C  8B 5E C6              MOV    bx, word ptr [bp - 0x3a]     ; UNKNOWN
016C1F  83 46 C6 02           ADD    word ptr [bp - 0x3a], 2      ; UNKNOWN
016C23  C7 07 FF FF           MOV    word ptr [bx], 0xffff        ; UNKNOWN
016C27  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
016C2A  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
016C2D  39 46 C6              CMP    word ptr [bp - 0x3a], ax     ; UNKNOWN
016C30  72 DD                 JB     0x16c0f                      ; UNKNOWN
016C32  8D 46 F2              LEA    ax, [bp - 0xe]               ; UNKNOWN
016C35  89 46 C4              MOV    word ptr [bp - 0x3c], ax     ; UNKNOWN
016C38  8B 5E C4              MOV    bx, word ptr [bp - 0x3c]     ; UNKNOWN
016C3B  83 46 C4 02           ADD    word ptr [bp - 0x3c], 2      ; UNKNOWN
016C3F  C7 07 00 00           MOV    word ptr [bx], 0             ; UNKNOWN
016C43  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
016C46  39 46 C4              CMP    word ptr [bp - 0x3c], ax     ; UNKNOWN
016C49  72 ED                 JB     0x16c38                      ; UNKNOWN
016C4B  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
016C50  C7 46 EC 00 00        MOV    word ptr [bp - 0x14], 0      ; UNKNOWN
016C55  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
016C58  80 BF 88 08 00        CMP    byte ptr [bx + 0x888], 0     ; UNKNOWN
016C5D  74 23                 JE     0x16c82                      ; UNKNOWN
016C5F  8A 46 EE              MOV    al, byte ptr [bp - 0x12]     ; UNKNOWN
016C62  8A 8F 8D 08           MOV    cl, byte ptr [bx + 0x88d]    ; UNKNOWN
016C66  2A ED                 SUB    ch, ch                       ; UNKNOWN
016C68  8B F1                 MOV    si, cx                       ; UNKNOWN
016C6A  8B 5E EC              MOV    bx, word ptr [bp - 0x14]     ; UNKNOWN
016C6D  88 80 D4 32           MOV    byte ptr [bx + si + 0x32d4], al ; UNKNOWN
016C71  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
016C74  8A 87 88 08           MOV    al, byte ptr [bx + 0x888]    ; UNKNOWN
016C78  2A E4                 SUB    ah, ah                       ; UNKNOWN
016C7A  FF 46 EC              INC    word ptr [bp - 0x14]         ; UNKNOWN
016C7D  3B 46 EC              CMP    ax, word ptr [bp - 0x14]     ; UNKNOWN
016C80  7F DD                 JG     0x16c5f                      ; UNKNOWN
016C82  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
016C85  83 7E EE 05           CMP    word ptr [bp - 0x12], 5      ; UNKNOWN
016C89  7C C5                 JL     0x16c50                      ; UNKNOWN
016C8B  C7 46 EE 00 00        MOV    word ptr [bp - 0x12], 0      ; UNKNOWN
016C90  8B 5E EE              MOV    bx, word ptr [bp - 0x12]     ; UNKNOWN
016C93  8A 9F D4 32           MOV    bl, byte ptr [bx + 0x32d4]   ; UNKNOWN
016C97  2A FF                 SUB    bh, bh                       ; UNKNOWN
016C99  8A 87 8D 08           MOV    al, byte ptr [bx + 0x88d]    ; UNKNOWN
016C9D  2A E4                 SUB    ah, ah                       ; UNKNOWN
016C9F  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
016CA2  8A 87 88 08           MOV    al, byte ptr [bx + 0x888]    ; UNKNOWN
016CA6  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
016CA9  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
016CAC  48                    DEC    ax                           ; UNKNOWN
016CAD  50                    PUSH   ax                           ; UNKNOWN
016CAE  6A 00                 PUSH   0                            ; UNKNOWN
016CB0  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
016CB5  83 C4 04              ADD    sp, 4                        ; UNKNOWN
016CB8  8B D8                 MOV    bx, ax                       ; UNKNOWN
016CBA  03 5E EA              ADD    bx, word ptr [bp - 0x16]     ; UNKNOWN
016CBD  89 5E F0              MOV    word ptr [bp - 0x10], bx     ; UNKNOWN
016CC0  80 BF 50 74 00        CMP    byte ptr [bx + 0x7450], 0    ; UNKNOWN
016CC5  7D E2                 JGE    0x16ca9                      ; UNKNOWN
016CC7  8A 46 EE              MOV    al, byte ptr [bp - 0x12]     ; UNKNOWN
016CCA  88 87 50 74           MOV    byte ptr [bx + 0x7450], al   ; UNKNOWN
016CCE  FF 46 EE              INC    word ptr [bp - 0x12]         ; UNKNOWN
016CD1  83 7E EE 0F           CMP    word ptr [bp - 0x12], 0xf    ; UNKNOWN
016CD5  7C B9                 JL     0x16c90                      ; UNKNOWN
016CD7  C7 46 C2 18 39        MOV    word ptr [bp - 0x3e], 0x3918 ; UNKNOWN
