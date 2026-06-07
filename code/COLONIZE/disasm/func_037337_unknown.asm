; ============================================================================
; func_037337_unknown
; Region   : load_image
; Bytes    : file 0x037337..0x03739B  (100 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

037337  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
03733B  8B 1E A8 74           MOV    bx, word ptr [0x74a8]        ; UNKNOWN
03733F  80 7F 01 01           CMP    byte ptr [bx + 1], 1         ; UNKNOWN
037343  7E 73                 JLE    0x373b8                      ; UNKNOWN
037345  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
037348  25 FE 00              AND    ax, 0xfe                     ; UNKNOWN
03734B  D1 E0                 SHL    ax, 1                        ; UNKNOWN
03734D  83 C0 04              ADD    ax, 4                        ; UNKNOWN
037350  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
037353  A1 06 3E              MOV    ax, word ptr [0x3e06]        ; UNKNOWN
037356  B9 90 01              MOV    cx, 0x190                    ; UNKNOWN
037359  99                    CDQ                                 ; UNKNOWN
03735A  F7 F9                 IDIV   cx                           ; UNKNOWN
03735C  8B C8                 MOV    cx, ax                       ; UNKNOWN
03735E  41                    INC    cx                           ; UNKNOWN
03735F  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
037362  F7 E9                 IMUL   cx                           ; UNKNOWN
037364  89 46 F8              MOV    word ptr [bp - 8], ax        ; UNKNOWN
037367  04 05                 ADD    al, 5                        ; UNKNOWN
037369  3A 47 01              CMP    al, byte ptr [bx + 1]        ; UNKNOWN
03736C  7D 4A                 JGE    0x373b8                      ; UNKNOWN
03736E  8A 46 F8              MOV    al, byte ptr [bp - 8]        ; UNKNOWN
037371  38 47 01              CMP    byte ptr [bx + 1], al        ; UNKNOWN
037374  7E 14                 JLE    0x3738a                      ; UNKNOWN
037376  A0 1E 3E              MOV    al, byte ptr [0x3e1e]        ; UNKNOWN
037379  2A E4                 SUB    ah, ah                       ; UNKNOWN
03737B  40                    INC    ax                           ; UNKNOWN
03737C  50                    PUSH   ax                           ; UNKNOWN
03737D  6A 01                 PUSH   1                            ; UNKNOWN
03737F  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
037384  83 C4 04              ADD    sp, 4                        ; UNKNOWN
037387  48                    DEC    ax                           ; UNKNOWN
037388  74 11                 JE     0x3739b                      ; UNKNOWN
03738A  8D 1E 86 09           LEA    bx, [0x986]                  ; UNKNOWN
03738E  8D 06 C5 20           LEA    ax, [0x20c5]                 ; UNKNOWN
037392  2B D2                 SUB    dx, dx                       ; UNKNOWN
037394  9A 6F 36 97 1B        LCALL  0x1b97, 0x366f               ; UNKNOWN
037399  C9                    LEAVE                               ; UNKNOWN
03739A  CB                    RETF                                ; UNKNOWN
