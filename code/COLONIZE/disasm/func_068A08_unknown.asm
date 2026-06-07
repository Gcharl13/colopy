; ============================================================================
; func_068A08_unknown
; Region   : load_image
; Bytes    : file 0x068A08..0x068A40  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068A08  55                    PUSH   bp                           ; UNKNOWN
068A09  8B EC                 MOV    bp, sp                       ; UNKNOWN
068A0B  83 EC 04              SUB    sp, 4                        ; UNKNOWN
068A0E  57                    PUSH   di                           ; UNKNOWN
068A0F  56                    PUSH   si                           ; UNKNOWN
068A10  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
068A13  56                    PUSH   si                           ; UNKNOWN
068A14  E8 29 17              CALL   0x6a140                      ; UNKNOWN
068A17  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068A1A  8B F8                 MOV    di, ax                       ; UNKNOWN
068A1C  8D 46 0A              LEA    ax, [bp + 0xa]               ; UNKNOWN
068A1F  50                    PUSH   ax                           ; UNKNOWN
068A20  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
068A23  56                    PUSH   si                           ; UNKNOWN
068A24  9A B2 1B 65 5F        LCALL  0x5f65, 0x1bb2               ; UNKNOWN
068A29  83 C4 06              ADD    sp, 6                        ; UNKNOWN
068A2C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068A2F  56                    PUSH   si                           ; UNKNOWN
068A30  57                    PUSH   di                           ; UNKNOWN
068A31  E8 7F 17              CALL   0x6a1b3                      ; UNKNOWN
068A34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
068A37  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
068A3A  5E                    POP    si                           ; UNKNOWN
068A3B  5F                    POP    di                           ; UNKNOWN
068A3C  8B E5                 MOV    sp, bp                       ; UNKNOWN
068A3E  5D                    POP    bp                           ; UNKNOWN
068A3F  CB                    RETF                                ; UNKNOWN
