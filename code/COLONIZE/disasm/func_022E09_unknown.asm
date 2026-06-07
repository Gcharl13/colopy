; ============================================================================
; func_022E09_unknown
; Region   : load_image
; Bytes    : file 0x022E09..0x022E6C  (99 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

022E09  C8 38 00 00           ENTER  0x38, 0                      ; UNKNOWN
022E0D  57                    PUSH   di                           ; UNKNOWN
022E0E  56                    PUSH   si                           ; UNKNOWN
022E0F  83 7E 0E 00           CMP    word ptr [bp + 0xe], 0       ; UNKNOWN
022E13  7C 0D                 JL     0x22e22                      ; UNKNOWN
022E15  8A 4E 0E              MOV    cl, byte ptr [bp + 0xe]      ; UNKNOWN
022E18  B8 10 00              MOV    ax, 0x10                     ; UNKNOWN
022E1B  D3 E0                 SHL    ax, cl                       ; UNKNOWN
022E1D  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
022E20  EB 05                 JMP    0x22e27                      ; UNKNOWN
022E22  C7 46 E2 00 00        MOV    word ptr [bp - 0x1e], 0      ; UNKNOWN
022E27  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
022E2A  8B 7E 08              MOV    di, word ptr [bp + 8]        ; UNKNOWN
022E2D  57                    PUSH   di                           ; UNKNOWN
022E2E  56                    PUSH   si                           ; UNKNOWN
022E2F  9A EC 00 C9 33        LCALL  0x33c9, 0xec                 ; UNKNOWN
022E34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
022E37  89 46 D6              MOV    word ptr [bp - 0x2a], ax     ; UNKNOWN
022E3A  89 56 D8              MOV    word ptr [bp - 0x28], dx     ; UNKNOWN
022E3D  57                    PUSH   di                           ; UNKNOWN
022E3E  56                    PUSH   si                           ; UNKNOWN
022E3F  9A 20 01 C9 33        LCALL  0x33c9, 0x120                ; UNKNOWN
022E44  83 C4 04              ADD    sp, 4                        ; UNKNOWN
022E47  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
022E4A  89 56 D4              MOV    word ptr [bp - 0x2c], dx     ; UNKNOWN
022E4D  57                    PUSH   di                           ; UNKNOWN
022E4E  56                    PUSH   si                           ; UNKNOWN
022E4F  9A D1 02 C9 33        LCALL  0x33c9, 0x2d1                ; UNKNOWN
022E54  83 C4 04              ADD    sp, 4                        ; UNKNOWN
022E57  89 46 CE              MOV    word ptr [bp - 0x32], ax     ; UNKNOWN
022E5A  89 56 D0              MOV    word ptr [bp - 0x30], dx     ; UNKNOWN
022E5D  57                    PUSH   di                           ; UNKNOWN
022E5E  56                    PUSH   si                           ; UNKNOWN
022E5F  9A 88 01 C9 33        LCALL  0x33c9, 0x188                ; UNKNOWN
022E64  83 C4 04              ADD    sp, 4                        ; UNKNOWN
022E67  89 46 CA              MOV    word ptr [bp - 0x36], ax     ; UNKNOWN
022E6A  89                    DB     0x89                         ; UNKNOWN (raw)
022E6B  56                    DB     0x56                         ; UNKNOWN (raw)
