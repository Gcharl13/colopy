; ============================================================================
; func_02FE18_unknown
; Region   : load_image
; Bytes    : file 0x02FE18..0x02FE61  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02FE18  C8 0A 00 00           ENTER  0xa, 0                       ; UNKNOWN
02FE1C  56                    PUSH   si                           ; UNKNOWN
02FE1D  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
02FE22  EB 2D                 JMP    0x2fe51                      ; UNKNOWN
02FE24  FF 46 FA              INC    word ptr [bp - 6]            ; UNKNOWN
02FE27  83 7E FA 05           CMP    word ptr [bp - 6], 5         ; UNKNOWN
02FE2B  7D 21                 JGE    0x2fe4e                      ; UNKNOWN
02FE2D  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
02FE30  8B C6                 MOV    ax, si                       ; UNKNOWN
02FE32  C1 E6 02              SHL    si, 2                        ; UNKNOWN
02FE35  03 F0                 ADD    si, ax                       ; UNKNOWN
02FE37  8B 5E F8              MOV    bx, word ptr [bp - 8]        ; UNKNOWN
02FE3A  80 B8 B0 73 00        CMP    byte ptr [bx + si + 0x73b0], 0 ; UNKNOWN
02FE3F  74 E3                 JE     0x2fe24                      ; UNKNOWN
02FE41  6A FF                 PUSH   -1                           ; UNKNOWN
02FE43  53                    PUSH   bx                           ; UNKNOWN
02FE44  50                    PUSH   ax                           ; UNKNOWN
02FE45  0E                    PUSH   cs                           ; UNKNOWN
02FE46  E8 69 DE              CALL   0x2dcb2                      ; UNKNOWN
02FE49  83 C4 06              ADD    sp, 6                        ; UNKNOWN
02FE4C  EB D6                 JMP    0x2fe24                      ; UNKNOWN
02FE4E  FF 46 F8              INC    word ptr [bp - 8]            ; UNKNOWN
02FE51  83 7E F8 05           CMP    word ptr [bp - 8], 5         ; UNKNOWN
02FE55  7D 07                 JGE    0x2fe5e                      ; UNKNOWN
02FE57  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0         ; UNKNOWN
02FE5C  EB C9                 JMP    0x2fe27                      ; UNKNOWN
02FE5E  5E                    POP    si                           ; UNKNOWN
02FE5F  C9                    LEAVE                               ; UNKNOWN
02FE60  CB                    RETF                                ; UNKNOWN
