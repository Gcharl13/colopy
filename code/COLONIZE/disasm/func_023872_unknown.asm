; ============================================================================
; func_023872_unknown
; Region   : load_image
; Bytes    : file 0x023872..0x0238C0  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023872  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
023876  53                    PUSH   bx                           ; UNKNOWN
023877  50                    PUSH   ax                           ; UNKNOWN
023878  57                    PUSH   di                           ; UNKNOWN
023879  56                    PUSH   si                           ; UNKNOWN
02387A  0B D2                 OR     dx, dx                       ; UNKNOWN
02387C  74 30                 JE     0x238ae                      ; UNKNOWN
02387E  BF FF FF              MOV    di, 0xffff                   ; UNKNOWN
023881  9A 08 00 B7 36        LCALL  0x36b7, 8                    ; UNKNOWN
023886  8B F0                 MOV    si, ax                       ; UNKNOWN
023888  0B F6                 OR     si, si                       ; UNKNOWN
02388A  7C 1E                 JL     0x238aa                      ; UNKNOWN
02388C  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
02388F  8A 87 82 88           MOV    al, byte ptr [bx - 0x777e]   ; UNKNOWN
023893  3C 0D                 CMP    al, 0xd                      ; UNKNOWN
023895  72 06                 JB     0x2389d                      ; UNKNOWN
023897  3C 12                 CMP    al, 0x12                     ; UNKNOWN
023899  77 02                 JA     0x2389d                      ; UNKNOWN
02389B  8B FE                 MOV    di, si                       ; UNKNOWN
02389D  8B C6                 MOV    ax, si                       ; UNKNOWN
02389F  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
0238A4  8B F0                 MOV    si, ax                       ; UNKNOWN
0238A6  0B FF                 OR     di, di                       ; UNKNOWN
0238A8  7C DE                 JL     0x23888                      ; UNKNOWN
0238AA  0B FF                 OR     di, di                       ; UNKNOWN
0238AC  7D 03                 JGE    0x238b1                      ; UNKNOWN
0238AE  8B 7E FA              MOV    di, word ptr [bp - 6]        ; UNKNOWN
0238B1  8B C7                 MOV    ax, di                       ; UNKNOWN
0238B3  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
0238B6  89 07                 MOV    word ptr [bx], ax            ; UNKNOWN
0238B8  0E                    PUSH   cs                           ; UNKNOWN
0238B9  E8 0B FF              CALL   0x237c7                      ; UNKNOWN
0238BC  5E                    POP    si                           ; UNKNOWN
0238BD  5F                    POP    di                           ; UNKNOWN
0238BE  C9                    LEAVE                               ; UNKNOWN
0238BF  CB                    RETF                                ; UNKNOWN
