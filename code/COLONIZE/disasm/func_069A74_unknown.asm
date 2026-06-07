; ============================================================================
; func_069A74_unknown
; Region   : load_image
; Bytes    : file 0x069A74..0x069A98  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069A74  55                    PUSH   bp                           ; UNKNOWN
069A75  8B EC                 MOV    bp, sp                       ; UNKNOWN
069A77  8C D9                 MOV    cx, ds                       ; UNKNOWN
069A79  C5 5E 06              LDS    bx, ptr [bp + 6]             ; UNKNOWN
069A7C  8B D3                 MOV    dx, bx                       ; UNKNOWN
069A7E  EB 0B                 JMP    0x69a8b                      ; UNKNOWN
069A80  2C 61                 SUB    al, 0x61                     ; UNKNOWN
069A82  3C 1A                 CMP    al, 0x1a                     ; UNKNOWN
069A84  73 04                 JAE    0x69a8a                      ; UNKNOWN
069A86  04 41                 ADD    al, 0x41                     ; UNKNOWN
069A88  88 07                 MOV    byte ptr [bx], al            ; UNKNOWN
069A8A  43                    INC    bx                           ; UNKNOWN
069A8B  8A 07                 MOV    al, byte ptr [bx]            ; UNKNOWN
069A8D  0A C0                 OR     al, al                       ; UNKNOWN
069A8F  75 EF                 JNE    0x69a80                      ; UNKNOWN
069A91  92                    XCHG   dx, ax                       ; UNKNOWN
069A92  8C DA                 MOV    dx, ds                       ; UNKNOWN
069A94  8E D9                 MOV    ds, cx                       ; UNKNOWN
069A96  5D                    POP    bp                           ; UNKNOWN
069A97  CB                    RETF                                ; UNKNOWN
