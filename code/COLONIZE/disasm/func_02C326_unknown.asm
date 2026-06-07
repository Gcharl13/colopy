; ============================================================================
; func_02C326_unknown
; Region   : load_image
; Bytes    : file 0x02C326..0x02C3B3  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C326  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
02C32A  56                    PUSH   si                           ; UNKNOWN
02C32B  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
02C32E  50                    PUSH   ax                           ; UNKNOWN
02C32F  8D 4E AC              LEA    cx, [bp - 0x54]              ; UNKNOWN
02C332  51                    PUSH   cx                           ; UNKNOWN
02C333  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02C336  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02C339  0E                    PUSH   cs                           ; UNKNOWN
02C33A  E8 BD FF              CALL   0x2c2fa                      ; UNKNOWN
02C33D  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02C340  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02C344  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02C348  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02C34C  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02C350  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02C354  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02C358  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02C35C  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02C360  6A 30                 PUSH   0x30                         ; UNKNOWN
02C362  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
02C365  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
02C368  BB 48 00              MOV    bx, 0x48                     ; UNKNOWN
02C36B  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02C370  C6 46 A8 0A           MOV    byte ptr [bp - 0x58], 0xa    ; UNKNOWN
02C374  A1 B6 40              MOV    ax, word ptr [0x40b6]        ; UNKNOWN
02C377  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
02C37A  75 04                 JNE    0x2c380                      ; UNKNOWN
02C37C  C6 46 A8 0E           MOV    byte ptr [bp - 0x58], 0xe    ; UNKNOWN
02C380  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02C383  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02C386  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02C388  39 87 7C 0B           CMP    word ptr [bx + 0xb7c], ax    ; UNKNOWN
02C38C  74 03                 JE     0x2c391                      ; UNKNOWN
02C38E  E9 F6 00              JMP    0x2c487                      ; UNKNOWN
02C391  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02C395  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02C399  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02C39D  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02C3A1  8B 4E AA              MOV    cx, word ptr [bp - 0x56]     ; UNKNOWN
02C3A4  83 C1 2F              ADD    cx, 0x2f                     ; UNKNOWN
02C3A7  51                    PUSH   cx                           ; UNKNOWN
02C3A8  8A 4E A8              MOV    cl, byte ptr [bp - 0x58]     ; UNKNOWN
02C3AB  51                    PUSH   cx                           ; UNKNOWN
02C3AC  8B D3                 MOV    dx, bx                       ; UNKNOWN
02C3AE  8B 5E AC              MOV    bx, word ptr [bp - 0x54]     ; UNKNOWN
02C3B1  8B C3                 MOV    ax, bx                       ; UNKNOWN
