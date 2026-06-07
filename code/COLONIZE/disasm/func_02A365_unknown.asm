; ============================================================================
; func_02A365_unknown
; Region   : load_image
; Bytes    : file 0x02A365..0x02A3AE  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02A365  C8 C4 03 00           ENTER  0x3c4, 0                     ; UNKNOWN
02A369  C7 86 40 FF FF FF     MOV    word ptr [bp - 0xc0], 0xffff ; UNKNOWN
02A36F  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02A374  2B C0                 SUB    ax, ax                       ; UNKNOWN
02A376  89 86 4A FF           MOV    word ptr [bp - 0xb6], ax     ; UNKNOWN
02A37A  89 86 48 FF           MOV    word ptr [bp - 0xb8], ax     ; UNKNOWN
02A37E  39 46 08              CMP    word ptr [bp + 8], ax        ; UNKNOWN
02A381  74 07                 JE     0x2a38a                      ; UNKNOWN
02A383  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
02A386  C7 07 FF FF           MOV    word ptr [bx], 0xffff        ; UNKNOWN
02A38A  A1 14 0C              MOV    ax, word ptr [0xc14]         ; UNKNOWN
02A38D  89 86 46 FF           MOV    word ptr [bp - 0xba], ax     ; UNKNOWN
02A391  C7 06 14 0C 00 00     MOV    word ptr [0xc14], 0          ; UNKNOWN
02A397  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02A39A  0E                    PUSH   cs                           ; UNKNOWN
02A39B  E8 F4 F4              CALL   0x29892                      ; UNKNOWN
02A39E  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02A3A1  89 86 42 FF           MOV    word ptr [bp - 0xbe], ax     ; UNKNOWN
02A3A5  0B C0                 OR     ax, ax                       ; UNKNOWN
02A3A7  7F 05                 JG     0x2a3ae                      ; UNKNOWN
02A3A9  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02A3AC  C9                    LEAVE                               ; UNKNOWN
02A3AD  CB                    RETF                                ; UNKNOWN
