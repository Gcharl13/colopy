; ============================================================================
; func_067A83_unknown
; Region   : load_image
; Bytes    : file 0x067A83..0x067ACC  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067A83  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
067A87  52                    PUSH   dx                           ; UNKNOWN
067A88  50                    PUSH   ax                           ; UNKNOWN
067A89  8B C8                 MOV    cx, ax                       ; UNKNOWN
067A8B  0B C0                 OR     ax, ax                       ; UNKNOWN
067A8D  74 0A                 JE     0x67a99                      ; UNKNOWN
067A8F  48                    DEC    ax                           ; UNKNOWN
067A90  74 61                 JE     0x67af3                      ; UNKNOWN
067A92  0E                    PUSH   cs                           ; UNKNOWN
067A93  E8 72 FF              CALL   0x67a08                      ; UNKNOWN
067A96  E9 DF 00              JMP    0x67b78                      ; UNKNOWN
067A99  C7 46 FE 00 10        MOV    word ptr [bp - 2], 0x1000    ; UNKNOWN
067A9E  83 3E 5C 11 01        CMP    word ptr [0x115c], 1         ; UNKNOWN
067AA3  75 27                 JNE    0x67acc                      ; UNKNOWN
067AA5  FF 36 FA CE           PUSH   word ptr [0xcefa]            ; UNKNOWN
067AA9  FF 36 F8 CE           PUSH   word ptr [0xcef8]            ; UNKNOWN
067AAD  FF 36 F6 CE           PUSH   word ptr [0xcef6]            ; UNKNOWN
067AB1  FF 36 F4 CE           PUSH   word ptr [0xcef4]            ; UNKNOWN
067AB5  FF 36 E0 CE           PUSH   word ptr [0xcee0]            ; UNKNOWN
067AB9  FF 36 DE CE           PUSH   word ptr [0xcede]            ; UNKNOWN
067ABD  1E                    PUSH   ds                           ; UNKNOWN
067ABE  68 58 11              PUSH   0x1158                       ; UNKNOWN
067AC1  8D 46 FE              LEA    ax, [bp - 2]                 ; UNKNOWN
067AC4  16                    PUSH   ss                           ; UNKNOWN
067AC5  50                    PUSH   ax                           ; UNKNOWN
067AC6  FF 1E 66 11           LCALL  [0x1166]                     ; UNKNOWN
067ACA  C9                    LEAVE                               ; UNKNOWN
067ACB  CB                    RETF                                ; UNKNOWN
