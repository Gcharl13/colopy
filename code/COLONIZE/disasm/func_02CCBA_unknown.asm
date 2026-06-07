; ============================================================================
; func_02CCBA_unknown
; Region   : load_image
; Bytes    : file 0x02CCBA..0x02CD46  (140 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02CCBA  C8 58 00 00           ENTER  0x58, 0                      ; UNKNOWN
02CCBE  57                    PUSH   di                           ; UNKNOWN
02CCBF  56                    PUSH   si                           ; UNKNOWN
02CCC0  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
02CCC4  7D 03                 JGE    0x2ccc9                      ; UNKNOWN
02CCC6  E9 65 01              JMP    0x2ce2e                      ; UNKNOWN
02CCC9  83 7E 06 03           CMP    word ptr [bp + 6], 3         ; UNKNOWN
02CCCD  7E 03                 JLE    0x2ccd2                      ; UNKNOWN
02CCCF  E9 5C 01              JMP    0x2ce2e                      ; UNKNOWN
02CCD2  8D 46 AA              LEA    ax, [bp - 0x56]              ; UNKNOWN
02CCD5  50                    PUSH   ax                           ; UNKNOWN
02CCD6  8D 4E AC              LEA    cx, [bp - 0x54]              ; UNKNOWN
02CCD9  51                    PUSH   cx                           ; UNKNOWN
02CCDA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02CCDD  0E                    PUSH   cs                           ; UNKNOWN
02CCDE  E8 A6 FF              CALL   0x2cc87                      ; UNKNOWN
02CCE1  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02CCE4  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
02CCE8  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
02CCEC  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
02CCF0  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
02CCF4  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02CCF8  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02CCFC  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02CD00  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02CD04  6A 52                 PUSH   0x52                         ; UNKNOWN
02CD06  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
02CD09  8B 56 AA              MOV    dx, word ptr [bp - 0x56]     ; UNKNOWN
02CD0C  BB 58 00              MOV    bx, 0x58                     ; UNKNOWN
02CD0F  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
02CD14  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
02CD17  8A 87 7A 09           MOV    al, byte ptr [bx + 0x97a]    ; UNKNOWN
02CD1B  88 46 A8              MOV    byte ptr [bp - 0x58], al     ; UNKNOWN
02CD1E  39 1E 10 3E           CMP    word ptr [0x3e10], bx        ; UNKNOWN
02CD22  74 03                 JE     0x2cd27                      ; UNKNOWN
02CD24  E9 F3 00              JMP    0x2ce1a                      ; UNKNOWN
02CD27  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
02CD2B  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
02CD2F  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
02CD33  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
02CD37  8B 4E AA              MOV    cx, word ptr [bp - 0x56]     ; UNKNOWN
02CD3A  83 C1 51              ADD    cx, 0x51                     ; UNKNOWN
02CD3D  51                    PUSH   cx                           ; UNKNOWN
02CD3E  50                    PUSH   ax                           ; UNKNOWN
02CD3F  8B 46 AC              MOV    ax, word ptr [bp - 0x54]     ; UNKNOWN
02CD42  8B D8                 MOV    bx, ax                       ; UNKNOWN
02CD44  83                    DB     0x83                         ; UNKNOWN (raw)
02CD45  C3                    DB     0xC3                         ; UNKNOWN (raw)
