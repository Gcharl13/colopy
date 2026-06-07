; ============================================================================
; func_03CE5D_unknown
; Region   : load_image
; Bytes    : file 0x03CE5D..0x03CE81  (36 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CE5D  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CE61  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CE64  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CE67  0E                    PUSH   cs                           ; UNKNOWN
03CE68  E8 AD FF              CALL   0x3ce18                      ; UNKNOWN
03CE6B  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03CE6E  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
03CE71  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
03CE74  26 8A 07              MOV    al, byte ptr es:[bx]         ; UNKNOWN
03CE77  32 46 0A              XOR    al, byte ptr [bp + 0xa]      ; UNKNOWN
03CE7A  24 0F                 AND    al, 0xf                      ; UNKNOWN
03CE7C  26 30 07              XOR    byte ptr es:[bx], al         ; UNKNOWN
03CE7F  C9                    LEAVE                               ; UNKNOWN
03CE80  CB                    RETF                                ; UNKNOWN
