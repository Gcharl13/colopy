; ============================================================================
; func_066FFA_unknown
; Region   : load_image
; Bytes    : file 0x066FFA..0x06702B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066FFA  C8 28 00 00           ENTER  0x28, 0                      ; UNKNOWN
066FFE  52                    PUSH   dx                           ; UNKNOWN
066FFF  53                    PUSH   bx                           ; UNKNOWN
067000  50                    PUSH   ax                           ; UNKNOWN
067001  57                    PUSH   di                           ; UNKNOWN
067002  56                    PUSH   si                           ; UNKNOWN
067003  8B 47 02              MOV    ax, word ptr [bx + 2]        ; UNKNOWN
067006  48                    DEC    ax                           ; UNKNOWN
067007  89 46 E0              MOV    word ptr [bp - 0x20], ax     ; UNKNOWN
06700A  8B 07                 MOV    ax, word ptr [bx]            ; UNKNOWN
06700C  48                    DEC    ax                           ; UNKNOWN
06700D  89 46 DA              MOV    word ptr [bp - 0x26], ax     ; UNKNOWN
067010  BA 01 00              MOV    dx, 1                        ; UNKNOWN
067013  8B 46 D2              MOV    ax, word ptr [bp - 0x2e]     ; UNKNOWN
067016  0B C0                 OR     ax, ax                       ; UNKNOWN
067018  79 03                 JNS    0x6701d                      ; UNKNOWN
06701A  BA FF FF              MOV    dx, 0xffff                   ; UNKNOWN
06701D  89 56 F0              MOV    word ptr [bp - 0x10], dx     ; UNKNOWN
067020  25 FF 7F              AND    ax, 0x7fff                   ; UNKNOWN
067023  89 46 D2              MOV    word ptr [bp - 0x2e], ax     ; UNKNOWN
067026  8B 5E D2              MOV    bx, word ptr [bp - 0x2e]     ; UNKNOWN
067029  8B C3                 MOV    ax, bx                       ; UNKNOWN
