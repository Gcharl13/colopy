; ============================================================================
; func_02AECC_unknown
; Region   : load_image
; Bytes    : file 0x02AECC..0x02AEF9  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AECC  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02AED0  57                    PUSH   di                           ; UNKNOWN
02AED1  56                    PUSH   si                           ; UNKNOWN
02AED2  A1 A4 40              MOV    ax, word ptr [0x40a4]        ; UNKNOWN
02AED5  8B 16 A6 40           MOV    dx, word ptr [0x40a6]        ; UNKNOWN
02AED9  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02AEDC  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02AEDF  C4 7E FC              LES    di, ptr [bp - 4]             ; UNKNOWN
02AEE2  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
02AEE5  0B D2                 OR     dx, dx                       ; UNKNOWN
02AEE7  74 0C                 JE     0x2aef5                      ; UNKNOWN
02AEE9  32 C0                 XOR    al, al                       ; UNKNOWN
02AEEB  B9 FF FF              MOV    cx, 0xffff                   ; UNKNOWN
02AEEE  F2 AE                 REPNE SCASB al, byte ptr es:[di]         ; UNKNOWN
02AEF0  75 03                 JNE    0x2aef5                      ; UNKNOWN
02AEF2  4A                    DEC    dx                           ; UNKNOWN
02AEF3  75 F6                 JNE    0x2aeeb                      ; UNKNOWN
02AEF5  8C C2                 MOV    dx, es                       ; UNKNOWN
02AEF7  8B C7                 MOV    ax, di                       ; UNKNOWN
