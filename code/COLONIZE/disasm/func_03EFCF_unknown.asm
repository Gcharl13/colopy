; ============================================================================
; func_03EFCF_unknown
; Region   : load_image
; Bytes    : file 0x03EFCF..0x03F03B  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03EFCF  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03EFD3  6B 1E 0A 3E 1C        IMUL   bx, word ptr [0x3e0a], 0x1c  ; UNKNOWN
03EFD8  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03EFDC  2A E4                 SUB    ah, ah                       ; UNKNOWN
03EFDE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03EFE1  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03EFE5  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03EFE8  B8 01 00              MOV    ax, 1                        ; UNKNOWN
03EFEB  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
03EFEE  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03EFF1  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
03EFF4  50                    PUSH   ax                           ; UNKNOWN
03EFF5  8D 4E FA              LEA    cx, [bp - 6]                 ; UNKNOWN
03EFF8  51                    PUSH   cx                           ; UNKNOWN
03EFF9  8D 56 FC              LEA    dx, [bp - 4]                 ; UNKNOWN
03EFFC  52                    PUSH   dx                           ; UNKNOWN
03EFFD  8D 5E FE              LEA    bx, [bp - 2]                 ; UNKNOWN
03F000  53                    PUSH   bx                           ; UNKNOWN
03F001  9A 47 00 BE 17        LCALL  0x17be, 0x47                 ; UNKNOWN
03F006  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03F009  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
03F00C  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03F00F  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03F012  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03F015  9A BD 00 BE 17        LCALL  0x17be, 0xbd                 ; UNKNOWN
03F01A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03F01D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03F020  9A F2 03 E8 39        LCALL  0x39e8, 0x3f2                ; UNKNOWN
03F025  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03F028  FF 76 F8              PUSH   word ptr [bp - 8]            ; UNKNOWN
03F02B  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
03F02E  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
03F031  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
03F034  9A 2D 02 BE 17        LCALL  0x17be, 0x22d                ; UNKNOWN
03F039  C9                    LEAVE                               ; UNKNOWN
03F03A  CB                    RETF                                ; UNKNOWN
