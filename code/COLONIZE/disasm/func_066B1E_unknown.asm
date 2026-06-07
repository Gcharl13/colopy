; ============================================================================
; func_066B1E_unknown
; Region   : load_image
; Bytes    : file 0x066B1E..0x066B4F  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066B1E  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
066B22  52                    PUSH   dx                           ; UNKNOWN
066B23  53                    PUSH   bx                           ; UNKNOWN
066B24  50                    PUSH   ax                           ; UNKNOWN
066B25  57                    PUSH   di                           ; UNKNOWN
066B26  56                    PUSH   si                           ; UNKNOWN
066B27  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
066B2A  48                    DEC    ax                           ; UNKNOWN
066B2B  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
066B2E  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
066B30  48                    DEC    ax                           ; UNKNOWN
066B31  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
066B34  BA 01 00              MOV    dx, 1                        ; UNKNOWN
066B37  8B 46 D2              MOV    ax, word ptr [bp - 0x2e]     ; UNKNOWN
066B3A  0B C0                 OR     ax, ax                       ; UNKNOWN
066B3C  79 03                 JNS    0x66b41                      ; UNKNOWN
066B3E  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
066B41  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
066B44  25 FF 7F              AND    ax, 0x7fff                   ; UNKNOWN
066B47  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
066B4A  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
066B4D  8B C3                 MOV    ax, bx                       ; UNKNOWN
