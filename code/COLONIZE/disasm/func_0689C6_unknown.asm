; ============================================================================
; func_0689C6_unknown
; Region   : load_image
; Bytes    : file 0x0689C6..0x0689F1  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0689C6  55                    PUSH   bp                           ; UNKNOWN
0689C7  8B EC                 MOV    bp, sp                       ; UNKNOWN
0689C9  56                    PUSH   si                           ; UNKNOWN
0689CA  9A 8A 20 65 5F        LCALL  0x5f65, 0x208a               ; UNKNOWN
0689CF  8B F0                 MOV    si, ax                       ; UNKNOWN
0689D1  0B F6                 OR     si, si                       ; UNKNOWN
0689D3  75 05                 JNE    0x689da                      ; UNKNOWN
0689D5  2B C0                 SUB    ax, ax                       ; UNKNOWN
0689D7  EB 13                 JMP    0x689ec                      ; UNKNOWN
0689D9  90                    NOP                                 ; UNKNOWN
0689DA  56                    PUSH   si                           ; UNKNOWN
0689DB  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
0689DE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
0689E1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0689E4  9A 08 1A 65 5F        LCALL  0x5f65, 0x1a08               ; UNKNOWN
0689E9  83 C4 08              ADD    sp, 8                        ; UNKNOWN
0689EC  5E                    POP    si                           ; UNKNOWN
0689ED  8B E5                 MOV    sp, bp                       ; UNKNOWN
0689EF  5D                    POP    bp                           ; UNKNOWN
0689F0  CB                    RETF                                ; UNKNOWN
