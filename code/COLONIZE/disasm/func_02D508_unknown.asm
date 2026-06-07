; ============================================================================
; func_02D508_unknown
; Region   : load_image
; Bytes    : file 0x02D508..0x02D566  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D508  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02D50C  57                    PUSH   di                           ; UNKNOWN
02D50D  56                    PUSH   si                           ; UNKNOWN
02D50E  8B 7E 06              MOV    di, word ptr [bp + 6]        ; UNKNOWN
02D511  8B 76 0A              MOV    si, word ptr [bp + 0xa]      ; UNKNOWN
02D514  6A 00                 PUSH   0                            ; UNKNOWN
02D516  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02D519  8B 56 0E              MOV    dx, word ptr [bp + 0xe]      ; UNKNOWN
02D51C  8B 5E 10              MOV    bx, word ptr [bp + 0x10]     ; UNKNOWN
02D51F  9A 02 00 74 5B        LCALL  0x5b74, 2                    ; UNKNOWN
02D524  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
02D528  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
02D52C  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02D52F  50                    PUSH   ax                           ; UNKNOWN
02D530  57                    PUSH   di                           ; UNKNOWN
02D531  89 7E FC              MOV    word ptr [bp - 4], di        ; UNKNOWN
02D534  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02D537  2B C0                 SUB    ax, ax                       ; UNKNOWN
02D539  9A 0E 00 75 5B        LCALL  0x5b75, 0xe                  ; UNKNOWN
02D53E  2B F0                 SUB    si, ax                       ; UNKNOWN
02D540  FF 36 22 0C           PUSH   word ptr [0xc22]             ; UNKNOWN
02D544  FF 36 20 0C           PUSH   word ptr [0xc20]             ; UNKNOWN
02D548  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02D54B  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02D54E  6A 00                 PUSH   0                            ; UNKNOWN
02D550  8B C6                 MOV    ax, si                       ; UNKNOWN
02D552  8D 1E 82 CE           LEA    bx, [0xce82]                 ; UNKNOWN
02D556  8B 56 0C              MOV    dx, word ptr [bp + 0xc]      ; UNKNOWN
02D559  8B F0                 MOV    si, ax                       ; UNKNOWN
02D55B  9A 08 00 5D 5B        LCALL  0x5b5d, 8                    ; UNKNOWN
02D560  8B C6                 MOV    ax, si                       ; UNKNOWN
02D562  5E                    POP    si                           ; UNKNOWN
02D563  5F                    POP    di                           ; UNKNOWN
02D564  C9                    LEAVE                               ; UNKNOWN
02D565  CB                    RETF                                ; UNKNOWN
