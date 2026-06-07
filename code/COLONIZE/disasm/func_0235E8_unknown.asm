; ============================================================================
; func_0235E8_unknown
; Region   : load_image
; Bytes    : file 0x0235E8..0x02369A  (178 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0235E8  C8 26 01 00           ENTER  0x126, 0                     ; UNKNOWN
0235EC  57                    PUSH   di                           ; UNKNOWN
0235ED  56                    PUSH   si                           ; UNKNOWN
0235EE  BE 01 00              MOV    si, 1                        ; UNKNOWN
0235F1  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0235F4  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
0235F7  50                    PUSH   ax                           ; UNKNOWN
0235F8  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
0235FD  83 C4 04              ADD    sp, 4                        ; UNKNOWN
023600  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
023603  16                    PUSH   ss                           ; UNKNOWN
023604  50                    PUSH   ax                           ; UNKNOWN
023605  1E                    PUSH   ds                           ; UNKNOWN
023606  68 B0 18              PUSH   0x18b0                       ; UNKNOWN
023609  9A 0A 00 3A 5B        LCALL  0x5b3a, 0xa                  ; UNKNOWN
02360E  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
023612  16                    PUSH   ss                           ; UNKNOWN
023613  50                    PUSH   ax                           ; UNKNOWN
023614  8D 46 A4              LEA    ax, [bp - 0x5c]              ; UNKNOWN
023617  16                    PUSH   ss                           ; UNKNOWN
023618  50                    PUSH   ax                           ; UNKNOWN
023619  8D 1E B4 18           LEA    bx, [0x18b4]                 ; UNKNOWN
02361D  2B C0                 SUB    ax, ax                       ; UNKNOWN
02361F  9A 0E 00 AC 5B        LCALL  0x5bac, 0xe                  ; UNKNOWN
023624  0B C0                 OR     ax, ax                       ; UNKNOWN
023626  75 6C                 JNE    0x23694                      ; UNKNOWN
023628  8D 46 F4              LEA    ax, [bp - 0xc]               ; UNKNOWN
02362B  16                    PUSH   ss                           ; UNKNOWN
02362C  50                    PUSH   ax                           ; UNKNOWN
02362D  6A 00                 PUSH   0                            ; UNKNOWN
02362F  6A 01                 PUSH   1                            ; UNKNOWN
023631  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
023635  16                    PUSH   ss                           ; UNKNOWN
023636  50                    PUSH   ax                           ; UNKNOWN
023637  B8 08 00              MOV    ax, 8                        ; UNKNOWN
02363A  99                    CDQ                                 ; UNKNOWN
02363B  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
023640  0B D0                 OR     dx, ax                       ; UNKNOWN
023642  74 50                 JE     0x23694                      ; UNKNOWN
023644  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
023647  8B 56 0E              MOV    dx, word ptr [bp + 0xe]      ; UNKNOWN
02364A  8B F8                 MOV    di, ax                       ; UNKNOWN
02364C  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02364F  83 7E 10 00           CMP    word ptr [bp + 0x10], 0      ; UNKNOWN
023653  74 15                 JE     0x2366a                      ; UNKNOWN
023655  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
023658  2B 56 F4              SUB    dx, word ptr [bp - 0xc]      ; UNKNOWN
02365B  8D 5E 08              LEA    bx, [bp + 8]                 ; UNKNOWN
02365E  2B C0                 SUB    ax, ax                       ; UNKNOWN
023660  9A 00 00 97 5A        LCALL  0x5a97, 0                    ; UNKNOWN
023665  8B F8                 MOV    di, ax                       ; UNKNOWN
023667  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02366A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02366D  57                    PUSH   di                           ; UNKNOWN
02366E  6A 00                 PUSH   0                            ; UNKNOWN
023670  6A 01                 PUSH   1                            ; UNKNOWN
023672  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
023676  16                    PUSH   ss                           ; UNKNOWN
023677  50                    PUSH   ax                           ; UNKNOWN
023678  8B 46 F6              MOV    ax, word ptr [bp - 0xa]      ; UNKNOWN
02367B  F7 6E F4              IMUL   word ptr [bp - 0xc]          ; UNKNOWN
02367E  9A 0A 00 D7 5B        LCALL  0x5bd7, 0xa                  ; UNKNOWN
023683  0B D0                 OR     dx, ax                       ; UNKNOWN
023685  74 0D                 JE     0x23694                      ; UNKNOWN
023687  8D 86 DA FE           LEA    ax, [bp - 0x126]             ; UNKNOWN
02368B  16                    PUSH   ss                           ; UNKNOWN
02368C  50                    PUSH   ax                           ; UNKNOWN
02368D  9A 29 02 AC 5B        LCALL  0x5bac, 0x229                ; UNKNOWN
023692  2B F6                 SUB    si, si                       ; UNKNOWN
023694  8B C6                 MOV    ax, si                       ; UNKNOWN
023696  5E                    POP    si                           ; UNKNOWN
023697  5F                    POP    di                           ; UNKNOWN
023698  C9                    LEAVE                               ; UNKNOWN
023699  CB                    RETF                                ; UNKNOWN
