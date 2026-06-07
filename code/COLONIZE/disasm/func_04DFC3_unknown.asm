; ============================================================================
; func_04DFC3_unknown
; Region   : load_image
; Bytes    : file 0x04DFC3..0x04E01C  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04DFC3  C8 10 00 00           ENTER  0x10, 0                      ; UNKNOWN
04DFC7  57                    PUSH   di                           ; UNKNOWN
04DFC8  56                    PUSH   si                           ; UNKNOWN
04DFC9  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04DFCC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
04DFCF  8D 5E 06              LEA    bx, [bp + 6]                 ; UNKNOWN
04DFD2  8B 46 16              MOV    ax, word ptr [bp + 0x16]     ; UNKNOWN
04DFD5  8B 56 18              MOV    dx, word ptr [bp + 0x18]     ; UNKNOWN
04DFD8  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
04DFDD  89 46 F6              MOV    word ptr [bp - 0xa], ax      ; UNKNOWN
04DFE0  89 56 F8              MOV    word ptr [bp - 8], dx        ; UNKNOWN
04DFE3  8B 46 10              MOV    ax, word ptr [bp + 0x10]     ; UNKNOWN
04DFE6  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
04DFE9  8D 5E 0E              LEA    bx, [bp + 0xe]               ; UNKNOWN
04DFEC  8B 46 1A              MOV    ax, word ptr [bp + 0x1a]     ; UNKNOWN
04DFEF  8B 56 1C              MOV    dx, word ptr [bp + 0x1c]     ; UNKNOWN
04DFF2  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
04DFF7  89 46 F0              MOV    word ptr [bp - 0x10], ax     ; UNKNOWN
04DFFA  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
04DFFD  1E                    PUSH   ds                           ; UNKNOWN
04DFFE  C5 76 F6              LDS    si, ptr [bp - 0xa]           ; UNKNOWN
04E001  C4 7E F0              LES    di, ptr [bp - 0x10]          ; UNKNOWN
04E004  33 D2                 XOR    dx, dx                       ; UNKNOWN
04E006  32 E4                 XOR    ah, ah                       ; UNKNOWN
04E008  BB 00 00              MOV    bx, 0                        ; UNKNOWN
04E00B  8B 4E 1E              MOV    cx, word ptr [bp + 0x1e]     ; UNKNOWN
04E00E  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
04E013  8A 46 20              MOV    al, byte ptr [bp + 0x20]     ; UNKNOWN
04E016  A8 03                 TEST   al, 3                        ; UNKNOWN
04E018  75 08                 JNE    0x4e022                      ; UNKNOWN
04E01A  83                    DB     0x83                         ; UNKNOWN (raw)
04E01B  C3                    DB     0xC3                         ; UNKNOWN (raw)
