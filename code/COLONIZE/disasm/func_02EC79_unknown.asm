; ============================================================================
; func_02EC79_unknown
; Region   : load_image
; Bytes    : file 0x02EC79..0x02ECB3  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EC79  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02EC7D  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
02EC82  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02EC85  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EC88  0E                    PUSH   cs                           ; UNKNOWN
02EC89  E8 FA EF              CALL   0x2dc86                      ; UNKNOWN
02EC8C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02EC8F  98                    CWDE                                ; UNKNOWN
02EC90  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02EC93  0B C0                 OR     ax, ax                       ; UNKNOWN
02EC95  7C 17                 JL     0x2ecae                      ; UNKNOWN
02EC97  50                    PUSH   ax                           ; UNKNOWN
02EC98  0E                    PUSH   cs                           ; UNKNOWN
02EC99  E8 4B F7              CALL   0x2e3e7                      ; UNKNOWN
02EC9C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EC9F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02ECA2  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02ECA5  0E                    PUSH   cs                           ; UNKNOWN
02ECA6  E8 77 F7              CALL   0x2e420                      ; UNKNOWN
02ECA9  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
02ECAC  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
02ECAE  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02ECB1  C9                    LEAVE                               ; UNKNOWN
02ECB2  CB                    RETF                                ; UNKNOWN
