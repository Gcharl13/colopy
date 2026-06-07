; ============================================================================
; func_02AF5B_unknown
; Region   : load_image
; Bytes    : file 0x02AF5B..0x02AFD4  (121 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AF5B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02AF5F  57                    PUSH   di                           ; UNKNOWN
02AF60  56                    PUSH   si                           ; UNKNOWN
02AF61  BE 01 00              MOV    si, 1                        ; UNKNOWN
02AF64  2B FF                 SUB    di, di                       ; UNKNOWN
02AF66  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
02AF6B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02AF6E  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02AF71  9A 2F 00 8F 5C        LCALL  0x5c8f, 0x2f                 ; UNKNOWN
02AF76  9A F6 00 28 1A        LCALL  0x1a28, 0xf6                 ; UNKNOWN
02AF7B  2B C0                 SUB    ax, ax                       ; UNKNOWN
02AF7D  9A 55 00 8F 5C        LCALL  0x5c8f, 0x55                 ; UNKNOWN
02AF82  9A 02 00 9A 5B        LCALL  0x5b9a, 2                    ; UNKNOWN
02AF87  0B C0                 OR     ax, ax                       ; UNKNOWN
02AF89  74 09                 JE     0x2af94                      ; UNKNOWN
02AF8B  9A 14 00 9A 5B        LCALL  0x5b9a, 0x14                 ; UNKNOWN
02AF90  8B F8                 MOV    di, ax                       ; UNKNOWN
02AF92  2B F6                 SUB    si, si                       ; UNKNOWN
02AF94  83 3E EE 0E 00        CMP    word ptr [0xeee], 0          ; UNKNOWN
02AF99  74 02                 JE     0x2af9d                      ; UNKNOWN
02AF9B  2B F6                 SUB    si, si                       ; UNKNOWN
02AF9D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02AF9F  8B D6                 MOV    dx, si                       ; UNKNOWN
02AFA1  9A 18 01 8F 5C        LCALL  0x5c8f, 0x118                ; UNKNOWN
02AFA6  83 3E 9E 09 00        CMP    word ptr [0x99e], 0          ; UNKNOWN
02AFAB  74 1D                 JE     0x2afca                      ; UNKNOWN
02AFAD  9A 04 00 23 5E        LCALL  0x5e23, 4                    ; UNKNOWN
02AFB2  8B 4E FC              MOV    cx, word ptr [bp - 4]        ; UNKNOWN
02AFB5  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
02AFB8  83 C1 78              ADD    cx, 0x78                     ; UNKNOWN
02AFBB  83 D3 00              ADC    bx, 0                        ; UNKNOWN
02AFBE  3B D3                 CMP    dx, bx                       ; UNKNOWN
02AFC0  7C 08                 JL     0x2afca                      ; UNKNOWN
02AFC2  7F 04                 JG     0x2afc8                      ; UNKNOWN
02AFC4  3B C1                 CMP    ax, cx                       ; UNKNOWN
02AFC6  72 02                 JB     0x2afca                      ; UNKNOWN
02AFC8  2B F6                 SUB    si, si                       ; UNKNOWN
02AFCA  0B F6                 OR     si, si                       ; UNKNOWN
02AFCC  75 A8                 JNE    0x2af76                      ; UNKNOWN
02AFCE  8B C7                 MOV    ax, di                       ; UNKNOWN
02AFD0  5E                    POP    si                           ; UNKNOWN
02AFD1  5F                    POP    di                           ; UNKNOWN
02AFD2  C9                    LEAVE                               ; UNKNOWN
02AFD3  CB                    RETF                                ; UNKNOWN
