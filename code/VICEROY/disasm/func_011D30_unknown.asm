; ============================================================================
; func_011D30_unknown
; Region   : load_image
; Bytes    : file 0x011D30..0x011D99  (105 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D30  55                    PUSH   bp                           ; UNKNOWN
011D31  8B EC                 MOV    bp, sp                       ; UNKNOWN
011D33  83 EC 04              SUB    sp, 4                        ; UNKNOWN
011D36  32 FF                 XOR    bh, bh                       ; UNKNOWN
011D38  88 7E FE              MOV    byte ptr [bp - 2], bh        ; UNKNOWN
011D3B  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
011D3E  8B C8                 MOV    cx, ax                       ; UNKNOWN
011D40  C6 46 FC 00           MOV    byte ptr [bp - 4], 0         ; UNKNOWN
011D44  A9 00 80              TEST   ax, 0x8000                   ; UNKNOWN
011D47  75 10                 JNE    0x11d59                      ; UNKNOWN
011D49  A9 00 40              TEST   ax, 0x4000                   ; UNKNOWN
011D4C  75 07                 JNE    0x11d55                      ; UNKNOWN
011D4E  F6 06 01 2B 80        TEST   byte ptr [0x2b01], 0x80      ; LOGIC
011D53  75 04                 JNE    0x11d59                      ; UNKNOWN
011D55  C6 46 FC 80           MOV    byte ptr [bp - 4], 0x80      ; LOCAL_STORE
011D59  8B 56 06              MOV    dx, word ptr [bp + 6]        ; UNKNOWN
011D5C  24 03                 AND    al, 3                        ; UNKNOWN
011D5E  0A C7                 OR     al, bh                       ; UNKNOWN
011D60  B4 3D                 MOV    ah, 0x3d                     ; UNKNOWN
011D62  CD 21                 INT    0x21                         ; UNKNOWN
011D64  73 12                 JAE    0x11d78                      ; UNKNOWN
011D66  3D 02 00              CMP    ax, 2                        ; UNKNOWN
011D69  75 09                 JNE    0x11d74                      ; UNKNOWN
011D6B  F7 C1 00 01           TEST   cx, 0x100                    ; UNKNOWN
011D6F  74 03                 JE     0x11d74                      ; UNKNOWN
011D71  E9 9F 00              JMP    0x11e13                      ; UNKNOWN
011D74  F9                    STC                                 ; UNKNOWN
011D75  E9 6D ED              JMP    0x10ae5                      ; UNKNOWN
011D78  93                    XCHG   bx, ax                       ; UNKNOWN
011D79  8B C1                 MOV    ax, cx                       ; UNKNOWN
011D7B  25 00 05              AND    ax, 0x500                    ; UNKNOWN
011D7E  3D 00 05              CMP    ax, 0x500                    ; UNKNOWN
011D81  75 09                 JNE    0x11d8c                      ; UNKNOWN
011D83  B4 3E                 MOV    ah, 0x3e                     ; UNKNOWN
011D85  CD 21                 INT    0x21                         ; UNKNOWN
011D87  B8 00 11              MOV    ax, 0x1100                   ; UNKNOWN
011D8A  EB E8                 JMP    0x11d74                      ; UNKNOWN
011D8C  C6 46 FD 01           MOV    byte ptr [bp - 3], 1         ; UNKNOWN
011D90  B8 00 44              MOV    ax, 0x4400                   ; UNKNOWN
011D93  CD 21                 INT    0x21                         ; UNKNOWN
011D95  F6 C2 80              TEST   dl, 0x80                     ; UNKNOWN
011D98  74                    DB     0x74                         ; UNKNOWN (raw)
