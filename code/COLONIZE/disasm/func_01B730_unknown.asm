; ============================================================================
; func_01B730_unknown
; Region   : load_image
; Bytes    : file 0x01B730..0x01B7C8  (152 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01B730  C8 18 00 00           ENTER  0x18, 0                      ; UNKNOWN
01B734  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
01B737  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01B73A  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01B73D  C7 46 FE 06 09        MOV    word ptr [bp - 2], 0x906     ; UNKNOWN
01B742  C7 46 F4 04 09        MOV    word ptr [bp - 0xc], 0x904   ; UNKNOWN
01B747  8D 46 EA              LEA    ax, [bp - 0x16]              ; UNKNOWN
01B74A  50                    PUSH   ax                           ; UNKNOWN
01B74B  8D 46 EE              LEA    ax, [bp - 0x12]              ; UNKNOWN
01B74E  50                    PUSH   ax                           ; UNKNOWN
01B74F  8D 46 FC              LEA    ax, [bp - 4]                 ; UNKNOWN
01B752  50                    PUSH   ax                           ; UNKNOWN
01B753  B8 44 00              MOV    ax, 0x44                     ; UNKNOWN
01B756  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
01B759  50                    PUSH   ax                           ; UNKNOWN
01B75A  B8 03 00              MOV    ax, 3                        ; UNKNOWN
01B75D  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
01B760  50                    PUSH   ax                           ; UNKNOWN
01B761  0E                    PUSH   cs                           ; UNKNOWN
01B762  E8 11 E1              CALL   0x19876                      ; UNKNOWN
01B765  83 C4 0A              ADD    sp, 0xa                      ; UNKNOWN
01B768  6A 2D                 PUSH   0x2d                         ; UNKNOWN
01B76A  6A 11                 PUSH   0x11                         ; UNKNOWN
01B76C  68 84 00              PUSH   0x84                         ; UNKNOWN
01B76F  68 2F 01              PUSH   0x12f                        ; UNKNOWN
01B772  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
01B777  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01B77A  0B C0                 OR     ax, ax                       ; UNKNOWN
01B77C  74 48                 JE     0x1b7c6                      ; UNKNOWN
01B77E  2B C0                 SUB    ax, ax                       ; UNKNOWN
01B780  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
01B783  89 46 E8              MOV    word ptr [bp - 0x18], ax     ; UNKNOWN
01B786  EB 38                 JMP    0x1b7c0                      ; UNKNOWN
01B788  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
01B78B  39 46 FA              CMP    word ptr [bp - 6], ax        ; UNKNOWN
01B78E  7E 36                 JLE    0x1b7c6                      ; UNKNOWN
01B790  8B 4E EE              MOV    cx, word ptr [bp - 0x12]     ; UNKNOWN
01B793  41                    INC    cx                           ; UNKNOWN
01B794  41                    INC    cx                           ; UNKNOWN
01B795  F7 E9                 IMUL   cx                           ; UNKNOWN
01B797  05 84 00              ADD    ax, 0x84                     ; UNKNOWN
01B79A  89 46 F2              MOV    word ptr [bp - 0xe], ax      ; UNKNOWN
01B79D  FF 76 EE              PUSH   word ptr [bp - 0x12]         ; UNKNOWN
01B7A0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
01B7A3  50                    PUSH   ax                           ; UNKNOWN
01B7A4  B8 2F 01              MOV    ax, 0x12f                    ; UNKNOWN
01B7A7  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
01B7AA  50                    PUSH   ax                           ; UNKNOWN
01B7AB  9A 00 01 EF 21        LCALL  0x21ef, 0x100                ; UNKNOWN
01B7B0  83 C4 08              ADD    sp, 8                        ; UNKNOWN
01B7B3  0B C0                 OR     ax, ax                       ; UNKNOWN
01B7B5  74 06                 JE     0x1b7bd                      ; UNKNOWN
01B7B7  8B 46 E8              MOV    ax, word ptr [bp - 0x18]     ; UNKNOWN
01B7BA  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
01B7BD  FF 46 E8              INC    word ptr [bp - 0x18]         ; UNKNOWN
01B7C0  83 7E F0 00           CMP    word ptr [bp - 0x10], 0      ; UNKNOWN
01B7C4  7C C2                 JL     0x1b788                      ; UNKNOWN
01B7C6  83                    DB     0x83                         ; UNKNOWN (raw)
01B7C7  3E                    DB     0x3E                         ; UNKNOWN (raw)
