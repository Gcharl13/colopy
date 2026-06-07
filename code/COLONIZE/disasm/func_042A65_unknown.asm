; ============================================================================
; func_042A65_unknown
; Region   : load_image
; Bytes    : file 0x042A65..0x042AAE  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042A65  C8 74 00 00           ENTER  0x74, 0                      ; UNKNOWN
042A69  56                    PUSH   si                           ; UNKNOWN
042A6A  2B C0                 SUB    ax, ax                       ; UNKNOWN
042A6C  89 46 A4              MOV    word ptr [bp - 0x5c], ax     ; UNKNOWN
042A6F  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
042A72  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042A75  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
042A7A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
042A7D  0E                    PUSH   cs                           ; UNKNOWN
042A7E  E8 76 F9              CALL   0x423f7                      ; UNKNOWN
042A81  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
042A84  2B C0                 SUB    ax, ax                       ; UNKNOWN
042A86  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
042A89  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
042A8C  EB 64                 JMP    0x42af2                      ; UNKNOWN
042A8E  83 7E 96 19           CMP    word ptr [bp - 0x6a], 0x19   ; UNKNOWN
042A92  7D 50                 JGE    0x42ae4                      ; UNKNOWN
042A94  FF 76 96              PUSH   word ptr [bp - 0x6a]         ; UNKNOWN
042A97  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
042A9A  9A 00 00 60 15        LCALL  0x1560, 0                    ; UNKNOWN
042A9F  83 C4 04              ADD    sp, 4                        ; UNKNOWN
042AA2  0B C0                 OR     ax, ax                       ; UNKNOWN
042AA4  75 35                 JNE    0x42adb                      ; UNKNOWN
042AA6  8A 46 98              MOV    al, byte ptr [bp - 0x68]     ; UNKNOWN
042AA9  8B 5E 96              MOV    bx, word ptr [bp - 0x6a]     ; UNKNOWN
042AAC  8B CB                 MOV    cx, bx                       ; UNKNOWN
