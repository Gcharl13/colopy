; ============================================================================
; func_066352_unknown
; Region   : load_image
; Bytes    : file 0x066352..0x066388  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066352  C8 6E 01 00           ENTER  0x16e, 0                     ; UNKNOWN
066356  52                    PUSH   dx                           ; UNKNOWN
066357  53                    PUSH   bx                           ; UNKNOWN
066358  50                    PUSH   ax                           ; UNKNOWN
066359  57                    PUSH   di                           ; UNKNOWN
06635A  56                    PUSH   si                           ; UNKNOWN
06635B  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
06635E  48                    DEC    ax                           ; UNKNOWN
06635F  89 86 9E FE           MOV    word ptr [bp - 0x162], ax    ; UNKNOWN
066363  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
066365  48                    DEC    ax                           ; UNKNOWN
066366  89 86 94 FE           MOV    word ptr [bp - 0x16c], ax    ; UNKNOWN
06636A  BA 01 00              MOV    dx, 1                        ; UNKNOWN
06636D  8B 86 8C FE           MOV    ax, word ptr [bp - 0x174]    ; UNKNOWN
066371  0B C0                 OR     ax, ax                       ; UNKNOWN
066373  79 03                 JNS    0x66378                      ; UNKNOWN
066375  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
066378  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
06637B  25 FF 7F              AND    ax, 0x7fff                   ; UNKNOWN
06637E  89 86 8C FE           MOV    word ptr [bp - 0x174], ax    ; UNKNOWN
066382  8B 9E 8C FE           MOV    bx, word ptr [bp - 0x174]    ; UNKNOWN
066386  8B C3                 MOV    ax, bx                       ; UNKNOWN
