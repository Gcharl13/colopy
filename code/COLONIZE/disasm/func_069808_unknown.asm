; ============================================================================
; func_069808_unknown
; Region   : load_image
; Bytes    : file 0x069808..0x069821  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069808  55                    PUSH   bp                           ; UNKNOWN
069809  8B EC                 MOV    bp, sp                       ; UNKNOWN
06980B  B4 2C                 MOV    ah, 0x2c                     ; UNKNOWN
06980D  CD 21                 INT    0x21                         ; UNKNOWN
06980F  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
069812  88 2F                 MOV    byte ptr [bx], ch            ; UNKNOWN
069814  88 4F 01              MOV    byte ptr [bx + 1], cl        ; UNKNOWN
069817  88 77 02              MOV    byte ptr [bx + 2], dh        ; UNKNOWN
06981A  88 57 03              MOV    byte ptr [bx + 3], dl        ; UNKNOWN
06981D  33 C0                 XOR    ax, ax                       ; UNKNOWN
06981F  5D                    POP    bp                           ; UNKNOWN
069820  CB                    RETF                                ; UNKNOWN
