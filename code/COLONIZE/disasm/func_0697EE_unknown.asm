; ============================================================================
; func_0697EE_unknown
; Region   : load_image
; Bytes    : file 0x0697EE..0x069807  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0697EE  55                    PUSH   bp                           ; UNKNOWN
0697EF  8B EC                 MOV    bp, sp                       ; UNKNOWN
0697F1  B4 2A                 MOV    ah, 0x2a                     ; UNKNOWN
0697F3  CD 21                 INT    0x21                         ; UNKNOWN
0697F5  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
0697F8  89 4F 02              MOV    word ptr [bx + 2], cx        ; UNKNOWN
0697FB  88 77 01              MOV    byte ptr [bx + 1], dh        ; UNKNOWN
0697FE  88 17                 MOV    byte ptr [bx], dl            ; UNKNOWN
069800  88 47 04              MOV    byte ptr [bx + 4], al        ; UNKNOWN
069803  33 C0                 XOR    ax, ax                       ; UNKNOWN
069805  5D                    POP    bp                           ; UNKNOWN
069806  CB                    RETF                                ; UNKNOWN
