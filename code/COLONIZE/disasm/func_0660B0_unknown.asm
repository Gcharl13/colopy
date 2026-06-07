; ============================================================================
; func_0660B0_unknown
; Region   : load_image
; Bytes    : file 0x0660B0..0x0660E9  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0660B0  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0660B4  57                    PUSH   di                           ; UNKNOWN
0660B5  56                    PUSH   si                           ; UNKNOWN
0660B6  8B F8                 MOV    di, ax                       ; UNKNOWN
0660B8  C6 46 FF 4E           MOV    byte ptr [bp - 1], 0x4e      ; UNKNOWN
0660BC  2B D2                 SUB    dx, dx                       ; UNKNOWN
0660BE  BE 7E 11              MOV    si, 0x117e                   ; UNKNOWN
0660C1  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
0660C4  81 FE FE 11           CMP    si, 0x11fe                   ; UNKNOWN
0660C8  73 18                 JAE    0x660e2                      ; UNKNOWN
0660CA  8A 04                 MOV    al, byte ptr [si]            ; UNKNOWN
0660CC  2A E4                 SUB    ah, ah                       ; UNKNOWN
0660CE  3B C7                 CMP    ax, di                       ; UNKNOWN
0660D0  75 09                 JNE    0x660db                      ; UNKNOWN
0660D2  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
0660D5  8A 44 06              MOV    al, byte ptr [si + 6]        ; UNKNOWN
0660D8  88 46 FF              MOV    byte ptr [bp - 1], al        ; UNKNOWN
0660DB  83 C6 08              ADD    si, 8                        ; UNKNOWN
0660DE  0B D2                 OR     dx, dx                       ; UNKNOWN
0660E0  74 E2                 JE     0x660c4                      ; UNKNOWN
0660E2  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
0660E5  5E                    POP    si                           ; UNKNOWN
0660E6  5F                    POP    di                           ; UNKNOWN
0660E7  C9                    LEAVE                               ; UNKNOWN
0660E8  CB                    RETF                                ; UNKNOWN
