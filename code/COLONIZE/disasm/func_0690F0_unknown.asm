; ============================================================================
; func_0690F0_unknown
; Region   : load_image
; Bytes    : file 0x0690F0..0x06911C  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0690F0  55                    PUSH   bp                           ; UNKNOWN
0690F1  8B EC                 MOV    bp, sp                       ; UNKNOWN
0690F3  83 7E 08 00           CMP    word ptr [bp + 8], 0         ; UNKNOWN
0690F7  75 0D                 JNE    0x69106                      ; UNKNOWN
0690F9  2B C0                 SUB    ax, ax                       ; UNKNOWN
0690FB  50                    PUSH   ax                           ; UNKNOWN
0690FC  B8 04 00              MOV    ax, 4                        ; UNKNOWN
0690FF  50                    PUSH   ax                           ; UNKNOWN
069100  2B C0                 SUB    ax, ax                       ; UNKNOWN
069102  50                    PUSH   ax                           ; UNKNOWN
069103  EB 0B                 JMP    0x69110                      ; UNKNOWN
069105  90                    NOP                                 ; UNKNOWN
069106  B8 00 02              MOV    ax, 0x200                    ; UNKNOWN
069109  50                    PUSH   ax                           ; UNKNOWN
06910A  2B C0                 SUB    ax, ax                       ; UNKNOWN
06910C  50                    PUSH   ax                           ; UNKNOWN
06910D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
069110  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
069113  9A 50 26 65 5F        LCALL  0x5f65, 0x2650               ; UNKNOWN
069118  8B E5                 MOV    sp, bp                       ; UNKNOWN
06911A  5D                    POP    bp                           ; UNKNOWN
06911B  CB                    RETF                                ; UNKNOWN
