; ============================================================================
; func_02E360_unknown
; Region   : load_image
; Bytes    : file 0x02E360..0x02E384  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02E360  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
02E364  56                    PUSH   si                           ; UNKNOWN
02E365  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02E36A  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02E36D  EB 56                 JMP    0x2e3c5                      ; UNKNOWN
02E36F  8B 5E FE              MOV    bx, word ptr [bp - 2]        ; UNKNOWN
02E372  D1 E3                 SHL    bx, 1                        ; UNKNOWN
02E374  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02E377  C7 00 0F 00           MOV    word ptr [bx + si], 0xf      ; UNKNOWN
02E37B  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02E37E  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02E381  5E                    POP    si                           ; UNKNOWN
02E382  C9                    LEAVE                               ; UNKNOWN
02E383  CB                    RETF                                ; UNKNOWN
