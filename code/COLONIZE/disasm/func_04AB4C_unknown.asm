; ============================================================================
; func_04AB4C_unknown
; Region   : load_image
; Bytes    : file 0x04AB4C..0x04ABF6  (170 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04AB4C  C8 62 00 00           ENTER  0x62, 0                      ; UNKNOWN
04AB50  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
04AB54  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
04AB58  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
04AB5C  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
04AB60  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
04AB64  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
04AB68  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
04AB6C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
04AB70  68 B9 00              PUSH   0xb9                         ; UNKNOWN
04AB73  2B C0                 SUB    ax, ax                       ; UNKNOWN
04AB75  BA 0F 00              MOV    dx, 0xf                      ; UNKNOWN
04AB78  BB 40 01              MOV    bx, 0x140                    ; UNKNOWN
04AB7B  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
04AB80  6B 06 40 C6 18        IMUL   ax, word ptr [0xc640], 0x18  ; UNKNOWN
04AB85  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
04AB88  EB 37                 JMP    0x4abc1                      ; UNKNOWN
04AB8A  A0 62 09              MOV    al, byte ptr [0x962]         ; UNKNOWN
04AB8D  2A E4                 SUB    ah, ah                       ; UNKNOWN
04AB8F  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04AB92  50                    PUSH   ax                           ; UNKNOWN
04AB93  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
04AB96  8B 56 A0              MOV    dx, word ptr [bp - 0x60]     ; UNKNOWN
04AB99  8B DA                 MOV    bx, dx                       ; UNKNOWN
04AB9B  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
04ABA0  FF 36 B6 09           PUSH   word ptr [0x9b6]             ; UNKNOWN
04ABA4  FF 36 B4 09           PUSH   word ptr [0x9b4]             ; UNKNOWN
04ABA8  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
04ABAB  16                    PUSH   ss                           ; UNKNOWN
04ABAC  50                    PUSH   ax                           ; UNKNOWN
04ABAD  6A 00                 PUSH   0                            ; UNKNOWN
04ABAF  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
04ABB3  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
04ABB6  8B 56 A6              MOV    dx, word ptr [bp - 0x5a]     ; UNKNOWN
04ABB9  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
04ABBE  FF 46 A8              INC    word ptr [bp - 0x58]         ; UNKNOWN
04ABC1  8B 46 A8              MOV    ax, word ptr [bp - 0x58]     ; UNKNOWN
04ABC4  39 06 3E C6           CMP    word ptr [0xc63e], ax        ; UNKNOWN
04ABC8  7F 03                 JG     0x4abcd                      ; UNKNOWN
04ABCA  E9 D8 00              JMP    0x4aca5                      ; UNKNOWN
04ABCD  8B 0E 40 C6           MOV    cx, word ptr [0xc640]        ; UNKNOWN
04ABD1  83 C1 03              ADD    cx, 3                        ; UNKNOWN
04ABD4  6B C9 18              IMUL   cx, cx, 0x18                 ; UNKNOWN
04ABD7  3B C8                 CMP    cx, ax                       ; UNKNOWN
04ABD9  7F 03                 JG     0x4abde                      ; UNKNOWN
04ABDB  E9 C7 00              JMP    0x4aca5                      ; UNKNOWN
04ABDE  8D 4E AA              LEA    cx, [bp - 0x56]              ; UNKNOWN
04ABE1  51                    PUSH   cx                           ; UNKNOWN
04ABE2  8D 4E AE              LEA    cx, [bp - 0x52]              ; UNKNOWN
04ABE5  51                    PUSH   cx                           ; UNKNOWN
04ABE6  50                    PUSH   ax                           ; UNKNOWN
04ABE7  0E                    PUSH   cs                           ; UNKNOWN
04ABE8  E8 A9 E0              CALL   0x48c94                      ; UNKNOWN
04ABEB  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04ABEE  83 7E AE 00           CMP    word ptr [bp - 0x52], 0      ; UNKNOWN
04ABF2  7C CA                 JL     0x4abbe                      ; UNKNOWN
04ABF4  8D                    DB     0x8D                         ; UNKNOWN (raw)
04ABF5  46                    DB     0x46                         ; UNKNOWN (raw)
