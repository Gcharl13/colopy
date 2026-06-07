; ============================================================================
; func_03CFD7_unknown
; Region   : load_image
; Bytes    : file 0x03CFD7..0x03D011  (58 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CFD7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CFDB  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03CFE0  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CFE3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CFE6  0E                    PUSH   cs                           ; UNKNOWN
03CFE7  E8 DD FD              CALL   0x3cdc7                      ; UNKNOWN
03CFEA  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CFED  A8 02                 TEST   al, 2                        ; UNKNOWN
03CFEF  74 1B                 JE     0x3d00c                      ; UNKNOWN
03CFF1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CFF4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CFF7  0E                    PUSH   cs                           ; UNKNOWN
03CFF8  E8 86 FE              CALL   0x3ce81                      ; UNKNOWN
03CFFB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CFFE  98                    CWDE                                ; UNKNOWN
03CFFF  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03D002  83 F8 04              CMP    ax, 4                        ; UNKNOWN
03D005  7C 05                 JL     0x3d00c                      ; UNKNOWN
03D007  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03D00C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03D00F  C9                    LEAVE                               ; UNKNOWN
03D010  CB                    RETF                                ; UNKNOWN
