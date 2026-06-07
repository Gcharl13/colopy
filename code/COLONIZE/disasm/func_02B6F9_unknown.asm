; ============================================================================
; func_02B6F9_unknown
; Region   : load_image
; Bytes    : file 0x02B6F9..0x02B715  (28 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B6F9  55                    PUSH   bp                           ; UNKNOWN
02B6FA  8B EC                 MOV    bp, sp                       ; UNKNOWN
02B6FC  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
02B701  74 12                 JE     0x2b715                      ; UNKNOWN
02B703  A1 4A 3E              MOV    ax, word ptr [0x3e4a]        ; UNKNOWN
02B706  39 46 06              CMP    word ptr [bp + 6], ax        ; UNKNOWN
02B709  75 0A                 JNE    0x2b715                      ; UNKNOWN
02B70B  6B 06 10 3E 34        IMUL   ax, word ptr [0x3e10], 0x34  ; UNKNOWN
02B710  05 9E C0              ADD    ax, 0xc09e                   ; UNKNOWN
02B713  C9                    LEAVE                               ; UNKNOWN
02B714  CB                    RETF                                ; UNKNOWN
