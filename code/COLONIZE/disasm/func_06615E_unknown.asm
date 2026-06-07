; ============================================================================
; func_06615E_unknown
; Region   : load_image
; Bytes    : file 0x06615E..0x06618F  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06615E  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
066162  52                    PUSH   dx                           ; UNKNOWN
066163  53                    PUSH   bx                           ; UNKNOWN
066164  50                    PUSH   ax                           ; UNKNOWN
066165  57                    PUSH   di                           ; UNKNOWN
066166  56                    PUSH   si                           ; UNKNOWN
066167  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
06616A  48                    DEC    ax                           ; UNKNOWN
06616B  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
06616E  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
066170  48                    DEC    ax                           ; UNKNOWN
066171  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
066174  BA 01 00              MOV    dx, 1                        ; UNKNOWN
066177  8B 46 D2              MOV    ax, word ptr [bp - 0x2e]     ; UNKNOWN
06617A  0B C0                 OR     ax, ax                       ; UNKNOWN
06617C  79 03                 JNS    0x66181                      ; UNKNOWN
06617E  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
066181  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
066184  25 FF 7F              AND    ax, 0x7fff                   ; UNKNOWN
066187  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
06618A  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
06618D  8B C3                 MOV    ax, bx                       ; UNKNOWN
