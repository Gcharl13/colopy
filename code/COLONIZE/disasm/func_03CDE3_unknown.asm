; ============================================================================
; func_03CDE3_unknown
; Region   : load_image
; Bytes    : file 0x03CDE3..0x03CE0B  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CDE3  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03CDE7  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CDEA  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CDED  0E                    PUSH   cs                           ; UNKNOWN
03CDEE  E8 BF FF              CALL   0x3cdb0                      ; UNKNOWN
03CDF1  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CDF4  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03CDF7  89 56 FE              MOV    word ptr [bp - 2], dx        ; UNKNOWN
03CDFA  83 7E 0C 00           CMP    word ptr [bp + 0xc], 0       ; UNKNOWN
03CDFE  74 0B                 JE     0x3ce0b                      ; UNKNOWN
03CE00  8A 46 0A              MOV    al, byte ptr [bp + 0xa]      ; UNKNOWN
03CE03  C4 5E FC              LES    bx, ptr [bp - 4]             ; UNKNOWN
03CE06  26 08 07              OR     byte ptr es:[bx], al         ; UNKNOWN
03CE09  C9                    LEAVE                               ; UNKNOWN
03CE0A  CB                    RETF                                ; UNKNOWN
