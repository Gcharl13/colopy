; ============================================================================
; func_025285_unknown
; Region   : load_image
; Bytes    : file 0x025285..0x0252AB  (38 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025285  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
025289  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
02528C  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02528F  8B 46 0A              MOV    ax, word ptr [bp + 0xa]      ; UNKNOWN
025292  0E                    PUSH   cs                           ; UNKNOWN
025293  E8 62 FF              CALL   0x251f8                      ; UNKNOWN
025296  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
025299  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
02529C  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
0252A0  74 09                 JE     0x252ab                      ; UNKNOWN
0252A2  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
0252A5  26 80 0F 02           OR     byte ptr es:[bx], 2          ; UNKNOWN
0252A9  C9                    LEAVE                               ; UNKNOWN
0252AA  CB                    RETF                                ; UNKNOWN
