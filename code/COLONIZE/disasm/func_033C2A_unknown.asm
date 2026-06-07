; ============================================================================
; func_033C2A_unknown
; Region   : load_image
; Bytes    : file 0x033C2A..0x033D0C  (226 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

033C2A  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
033C2E  8D 46 F6              LEA    ax, [bp - 0xa]               ; UNKNOWN
033C31  50                    PUSH   ax                           ; UNKNOWN
033C32  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
033C35  50                    PUSH   ax                           ; UNKNOWN
033C36  8D 46 FA              LEA    ax, [bp - 6]                 ; UNKNOWN
033C39  50                    PUSH   ax                           ; UNKNOWN
033C3A  8D 4E FE              LEA    cx, [bp - 2]                 ; UNKNOWN
033C3D  51                    PUSH   cx                           ; UNKNOWN
033C3E  8D 56 FC              LEA    dx, [bp - 4]                 ; UNKNOWN
033C41  52                    PUSH   dx                           ; UNKNOWN
033C42  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
033C45  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
033C48  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
033C4B  8B 5E 0E              MOV    bx, word ptr [bp + 0xe]      ; UNKNOWN
033C4E  FF 37                 PUSH   word ptr [bx]                ; UNKNOWN
033C50  0E                    PUSH   cs                           ; UNKNOWN
033C51  E8 0C FF              CALL   0x33b60                      ; UNKNOWN
033C54  83 C4 12              ADD    sp, 0x12                     ; UNKNOWN
033C57  83 7E FC 02           CMP    word ptr [bp - 4], 2         ; UNKNOWN
033C5B  7C 03                 JL     0x33c60                      ; UNKNOWN
033C5D  E9 81 00              JMP    0x33ce1                      ; UNKNOWN
033C60  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
033C63  6A 10                 PUSH   0x10                         ; UNKNOWN
033C65  8A 4E FC              MOV    cl, byte ptr [bp - 4]        ; UNKNOWN
033C68  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
033C6B  D3 F8                 SAR    ax, cl                       ; UNKNOWN
033C6D  50                    PUSH   ax                           ; UNKNOWN
033C6E  83 7E FC 01           CMP    word ptr [bp - 4], 1         ; UNKNOWN
033C72  75 05                 JNE    0x33c79                      ; UNKNOWN
033C74  B8 04 00              MOV    ax, 4                        ; UNKNOWN
033C77  EB 02                 JMP    0x33c7b                      ; UNKNOWN
033C79  2B C0                 SUB    ax, ax                       ; UNKNOWN
033C7B  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
033C7E  2B D8                 SUB    bx, ax                       ; UNKNOWN
033C80  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
033C83  2B D2                 SUB    dx, dx                       ; UNKNOWN
033C85  9A BD 01 76 1A        LCALL  0x1a76, 0x1bd                ; UNKNOWN
033C8A  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
033C8E  80 BF 82 88 0D        CMP    byte ptr [bx - 0x777e], 0xd  ; UNKNOWN
033C93  73 03                 JAE    0x33c98                      ; UNKNOWN
033C95  E9 96 00              JMP    0x33d2e                      ; UNKNOWN
033C98  80 BF 82 88 12        CMP    byte ptr [bx - 0x777e], 0x12 ; UNKNOWN
033C9D  76 03                 JBE    0x33ca2                      ; UNKNOWN
033C9F  E9 8C 00              JMP    0x33d2e                      ; UNKNOWN
033CA2  83 7E FC 00           CMP    word ptr [bp - 4], 0         ; UNKNOWN
033CA6  74 03                 JE     0x33cab                      ; UNKNOWN
033CA8  E9 83 00              JMP    0x33d2e                      ; UNKNOWN
033CAB  83 7E 0C 02           CMP    word ptr [bp + 0xc], 2       ; UNKNOWN
033CAF  7D 7D                 JGE    0x33d2e                      ; UNKNOWN
033CB1  80 BF 8C 88 00        CMP    byte ptr [bx - 0x7774], 0    ; UNKNOWN
033CB6  74 76                 JE     0x33d2e                      ; UNKNOWN
033CB8  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
033CBC  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
033CC0  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
033CC3  6A 00                 PUSH   0                            ; UNKNOWN
033CC5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
033CC8  9A 92 2F 5F 24        LCALL  0x245f, 0x2f92               ; UNKNOWN
033CCD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
033CD0  83 C0 17              ADD    ax, 0x17                     ; UNKNOWN
033CD3  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
033CD7  8B 56 FE              MOV    dx, word ptr [bp - 2]        ; UNKNOWN
033CDA  9A 0E 00 15 5D        LCALL  0x5d15, 0xe                  ; UNKNOWN
033CDF  EB 4D                 JMP    0x33d2e                      ; UNKNOWN
033CE1  83 7E FC 03           CMP    word ptr [bp - 4], 3         ; UNKNOWN
033CE5  7D 47                 JGE    0x33d2e                      ; UNKNOWN
033CE7  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
033CEB  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
033CEF  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
033CF2  03 46 FA              ADD    ax, word ptr [bp - 6]        ; UNKNOWN
033CF5  48                    DEC    ax                           ; UNKNOWN
033CF6  50                    PUSH   ax                           ; UNKNOWN
033CF7  8A 4E FC              MOV    cl, byte ptr [bp - 4]        ; UNKNOWN
033CFA  B8 64 00              MOV    ax, 0x64                     ; UNKNOWN
033CFD  D3 F8                 SAR    ax, cl                       ; UNKNOWN
033CFF  50                    PUSH   ax                           ; UNKNOWN
033D00  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; UNKNOWN
033D04  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
033D08  2A FF                 SUB    bh, bh                       ; UNKNOWN
033D0A  8B C3                 MOV    ax, bx                       ; UNKNOWN
