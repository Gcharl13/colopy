; ============================================================================
; func_067910_unknown
; Region   : load_image
; Bytes    : file 0x067910..0x06796E  (94 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067910  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
067914  57                    PUSH   di                           ; UNKNOWN
067915  56                    PUSH   si                           ; UNKNOWN
067916  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
067919  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06791C  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
067921  83 C4 04              ADD    sp, 4                        ; UNKNOWN
067924  BE FF FF              MOV    si, 0xffff                   ; UNKNOWN
067927  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
06792A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
06792D  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
067932  83 C4 04              ADD    sp, 4                        ; UNKNOWN
067935  8B D8                 MOV    bx, ax                       ; UNKNOWN
067937  03 5E 06              ADD    bx, word ptr [bp + 6]        ; UNKNOWN
06793A  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
06793D  4B                    DEC    bx                           ; UNKNOWN
06793E  8B FB                 MOV    di, bx                       ; UNKNOWN
067940  8C 46 FE              MOV    word ptr [bp - 2], es        ; UNKNOWN
067943  26 80 3F 20           CMP    byte ptr es:[bx], 0x20       ; UNKNOWN
067947  74 0A                 JE     0x67953                      ; UNKNOWN
067949  26 80 3D 09           CMP    byte ptr es:[di], 9          ; UNKNOWN
06794D  74 04                 JE     0x67953                      ; UNKNOWN
06794F  2B F6                 SUB    si, si                       ; UNKNOWN
067951  EB 07                 JMP    0x6795a                      ; UNKNOWN
067953  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
067956  26 C6 05 00           MOV    byte ptr es:[di], 0          ; UNKNOWN
06795A  8D 45 FF              LEA    ax, [di - 1]                 ; UNKNOWN
06795D  3B 46 06              CMP    ax, word ptr [bp + 6]        ; UNKNOWN
067960  73 02                 JAE    0x67964                      ; UNKNOWN
067962  2B F6                 SUB    si, si                       ; UNKNOWN
067964  0B F6                 OR     si, si                       ; UNKNOWN
067966  75 BC                 JNE    0x67924                      ; UNKNOWN
067968  5E                    POP    si                           ; UNKNOWN
067969  5F                    POP    di                           ; UNKNOWN
06796A  C9                    LEAVE                               ; UNKNOWN
06796B  CA 04 00              RETF   4                            ; UNKNOWN
