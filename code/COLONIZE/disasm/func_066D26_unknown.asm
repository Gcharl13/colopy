; ============================================================================
; func_066D26_unknown
; Region   : load_image
; Bytes    : file 0x066D26..0x066D5C  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066D26  C8 6E 01 00           ENTER  0x16e, 0                     ; UNKNOWN
066D2A  52                    PUSH   dx                           ; UNKNOWN
066D2B  53                    PUSH   bx                           ; UNKNOWN
066D2C  50                    PUSH   ax                           ; UNKNOWN
066D2D  57                    PUSH   di                           ; UNKNOWN
066D2E  56                    PUSH   si                           ; UNKNOWN
066D2F  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
066D32  48                    DEC    ax                           ; UNKNOWN
066D33  89 86 9E FE           MOV    word ptr [bp - 0x162], ax    ; UNKNOWN
066D37  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
066D39  48                    DEC    ax                           ; UNKNOWN
066D3A  89 86 94 FE           MOV    word ptr [bp - 0x16c], ax    ; UNKNOWN
066D3E  BA 01 00              MOV    dx, 1                        ; UNKNOWN
066D41  8B 86 8C FE           MOV    ax, word ptr [bp - 0x174]    ; UNKNOWN
066D45  0B C0                 OR     ax, ax                       ; UNKNOWN
066D47  79 03                 JNS    0x66d4c                      ; UNKNOWN
066D49  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
066D4C  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
066D4F  25 FF 7F              AND    ax, 0x7fff                   ; UNKNOWN
066D52  89 86 8C FE           MOV    word ptr [bp - 0x174], ax    ; UNKNOWN
066D56  8B 9E 8C FE           MOV    bx, word ptr [bp - 0x174]    ; UNKNOWN
066D5A  8B C3                 MOV    ax, bx                       ; UNKNOWN
