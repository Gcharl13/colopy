; ============================================================================
; func_03FCF3_unknown
; Region   : load_image
; Bytes    : file 0x03FCF3..0x03FD1F  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FCF3  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03FCF7  52                    PUSH   dx                           ; UNKNOWN
03FCF8  57                    PUSH   di                           ; UNKNOWN
03FCF9  56                    PUSH   si                           ; UNKNOWN
03FCFA  8B C8                 MOV    cx, ax                       ; UNKNOWN
03FCFC  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03FCFF  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03FD02  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03FD05  8B C1                 MOV    ax, cx                       ; UNKNOWN
03FD07  0E                    PUSH   cs                           ; UNKNOWN
03FD08  E8 6D FE              CALL   0x3fb78                      ; UNKNOWN
03FD0B  8B F0                 MOV    si, ax                       ; UNKNOWN
03FD0D  8B 7E FC              MOV    di, word ptr [bp - 4]        ; UNKNOWN
03FD10  0B F6                 OR     si, si                       ; UNKNOWN
03FD12  7C 35                 JL     0x3fd49                      ; UNKNOWN
03FD14  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
03FD17  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
03FD1B  2A FF                 SUB    bh, bh                       ; UNKNOWN
03FD1D  8B C3                 MOV    ax, bx                       ; UNKNOWN
