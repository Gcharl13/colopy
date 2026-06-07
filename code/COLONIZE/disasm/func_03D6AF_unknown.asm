; ============================================================================
; func_03D6AF_unknown
; Region   : load_image
; Bytes    : file 0x03D6AF..0x03D6C7  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03D6AF  55                    PUSH   bp                           ; UNKNOWN
03D6B0  8B EC                 MOV    bp, sp                       ; UNKNOWN
03D6B2  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03D6B5  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03D6B8  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
03D6BD  8B E5                 MOV    sp, bp                       ; UNKNOWN
03D6BF  0B C0                 OR     ax, ax                       ; UNKNOWN
03D6C1  75 04                 JNE    0x3d6c7                      ; UNKNOWN
03D6C3  2B C0                 SUB    ax, ax                       ; UNKNOWN
03D6C5  C9                    LEAVE                               ; UNKNOWN
03D6C6  CB                    RETF                                ; UNKNOWN
