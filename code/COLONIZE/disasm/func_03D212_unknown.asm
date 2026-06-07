; ============================================================================
; func_03D212_unknown
; Region   : load_image
; Bytes    : file 0x03D212..0x03D26D  (91 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D212  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03D216  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
03D21B  83 3E 40 0B 00        CMP    word ptr [0xb40], 0          ; UNKNOWN
03D220  74 67                 JE     0x3d289                      ; UNKNOWN
03D222  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D225  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D228  9A 38 00 3C 22        LCALL  0x223c, 0x38                 ; UNKNOWN
03D22D  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D230  83 F8 19              CMP    ax, 0x19                     ; UNKNOWN
03D233  74 54                 JE     0x3d289                      ; UNKNOWN
03D235  83 F8 1A              CMP    ax, 0x1a                     ; UNKNOWN
03D238  74 4F                 JE     0x3d289                      ; UNKNOWN
03D23A  83 F8 18              CMP    ax, 0x18                     ; UNKNOWN
03D23D  74 4A                 JE     0x3d289                      ; UNKNOWN
03D23F  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D242  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D245  0E                    PUSH   cs                           ; UNKNOWN
03D246  E8 38 FC              CALL   0x3ce81                      ; UNKNOWN
03D249  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03D24C  98                    CWDE                                ; UNKNOWN
03D24D  0B C0                 OR     ax, ax                       ; UNKNOWN
03D24F  7D 38                 JGE    0x3d289                      ; UNKNOWN
03D251  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03D254  83 E0 03              AND    ax, 3                        ; UNKNOWN
03D257  8B 4E 08              MOV    cx, word ptr [bp + 8]        ; UNKNOWN
03D25A  C1 F9 02              SAR    cx, 2                        ; UNKNOWN
03D25D  6B C9 13              IMUL   cx, cx, 0x13                 ; UNKNOWN
03D260  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
03D263  C1 FA 02              SAR    dx, 2                        ; UNKNOWN
03D266  6B D2 11              IMUL   dx, dx, 0x11                 ; UNKNOWN
03D269  03 CA                 ADD    cx, dx                       ; UNKNOWN
03D26B  03                    DB     0x03                         ; UNKNOWN (raw)
03D26C  0E                    DB     0x0E                         ; UNKNOWN (raw)
