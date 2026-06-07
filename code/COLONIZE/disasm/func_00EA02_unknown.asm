; ============================================================================
; func_00EA02_unknown
; Region   : load_image
; Bytes    : file 0x00EA02..0x00EA39  (55 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EA02  C8 08 00 00           ENTER  8, 0                         ; UNKNOWN
00EA06  56                    PUSH   si                           ; UNKNOWN
00EA07  6A 08                 PUSH   8                            ; UNKNOWN
00EA09  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00EA0C  8D 46 F8              LEA    ax, [bp - 8]                 ; UNKNOWN
00EA0F  50                    PUSH   ax                           ; UNKNOWN
00EA10  9A 24 08 65 5F        LCALL  0x5f65, 0x824                ; UNKNOWN
00EA15  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00EA18  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
00EA1B  C6 07 FF              MOV    byte ptr [bx], 0xff          ; UNKNOWN
00EA1E  8D 76 F8              LEA    si, [bp - 8]                 ; UNKNOWN
00EA21  B8 01 54              MOV    ax, 0x5401                   ; UNKNOWN
00EA24  CD 67                 INT    0x67                         ; UNKNOWN
00EA26  8A C4                 MOV    al, ah                       ; UNKNOWN
00EA28  32 E4                 XOR    ah, ah                       ; UNKNOWN
00EA2A  A3 4E 05              MOV    word ptr [0x54e], ax         ; UNKNOWN
00EA2D  0B C0                 OR     ax, ax                       ; UNKNOWN
00EA2F  75 09                 JNE    0xea3a                       ; UNKNOWN
00EA31  89 17                 MOV    word ptr [bx], dx            ; UNKNOWN
00EA33  B8 01 00              MOV    ax, 1                        ; UNKNOWN
00EA36  5E                    POP    si                           ; UNKNOWN
00EA37  C9                    LEAVE                               ; UNKNOWN
00EA38  CB                    RETF                                ; UNKNOWN
