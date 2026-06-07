; ============================================================================
; func_03CEA9_unknown
; Region   : load_image
; Bytes    : file 0x03CEA9..0x03CF21  (120 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CEA9  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CEAD  83 7E 0A 04           CMP    word ptr [bp + 0xa], 4       ; UNKNOWN
03CEB1  7D 49                 JGE    0x3cefc                      ; UNKNOWN
03CEB3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CEB6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CEB9  0E                    PUSH   cs                           ; UNKNOWN
03CEBA  E8 54 01              CALL   0x3d011                      ; UNKNOWN
03CEBD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CEC0  0B C0                 OR     ax, ax                       ; UNKNOWN
03CEC2  7C 38                 JL     0x3cefc                      ; UNKNOWN
03CEC4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CEC7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CECA  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03CECD  68 1E 27              PUSH   0x271e                       ; UNKNOWN
03CED0  9A DD 00 AA 38        LCALL  0x38aa, 0xdd                 ; UNKNOWN
03CED5  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03CED8  6A 05                 PUSH   5                            ; UNKNOWN
03CEDA  9A 0E 01 58 06        LCALL  0x658, 0x10e                 ; UNKNOWN
03CEDF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03CEE2  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03CEE5  99                    CDQ                                 ; UNKNOWN
03CEE6  52                    PUSH   dx                           ; UNKNOWN
03CEE7  50                    PUSH   ax                           ; UNKNOWN
03CEE8  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
03CEEB  99                    CDQ                                 ; UNKNOWN
03CEEC  52                    PUSH   dx                           ; UNKNOWN
03CEED  50                    PUSH   ax                           ; UNKNOWN
03CEEE  B8 AC FF              MOV    ax, 0xffac                   ; UNKNOWN
03CEF1  BA 01 00              MOV    dx, 1                        ; UNKNOWN
03CEF4  BB 2D 00              MOV    bx, 0x2d                     ; UNKNOWN
03CEF7  9A 66 02 B2 05        LCALL  0x5b2, 0x266                 ; UNKNOWN
03CEFC  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CEFF  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CF02  0E                    PUSH   cs                           ; UNKNOWN
03CF03  E8 12 FF              CALL   0x3ce18                      ; UNKNOWN
03CF06  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03CF09  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
03CF0C  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
03CF0F  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CF12  24 0F                 AND    al, 0xf                      ; UNKNOWN
03CF14  8A 4E 0A              MOV    cl, byte ptr [bp + 0xa]      ; UNKNOWN
03CF17  C0 E1 04              SHL    cl, 4                        ; UNKNOWN
03CF1A  0A C1                 OR     al, cl                       ; UNKNOWN
03CF1C  26 88 07              MOV    byte ptr es:[bx], al         ; UNKNOWN
03CF1F  C9                    LEAVE                               ; UNKNOWN
03CF20  CB                    RETF                                ; UNKNOWN
