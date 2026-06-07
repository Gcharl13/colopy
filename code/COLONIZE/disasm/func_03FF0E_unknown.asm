; ============================================================================
; func_03FF0E_unknown
; Region   : load_image
; Bytes    : file 0x03FF0E..0x03FF7A  (108 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FF0E  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03FF12  57                    PUSH   di                           ; UNKNOWN
03FF13  56                    PUSH   si                           ; UNKNOWN
03FF14  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
03FF17  6B DE 1C              IMUL   bx, si, 0x1c                 ; UNKNOWN
03FF1A  89 5E FA              MOV    word ptr [bp - 6], bx        ; UNKNOWN
03FF1D  83 BF 9A 88 00        CMP    word ptr [bx - 0x7766], 0    ; UNKNOWN
03FF22  7C 52                 JL     0x3ff76                      ; UNKNOWN
03FF24  8A 87 80 88           MOV    al, byte ptr [bx - 0x7780]   ; UNKNOWN
03FF28  2A E4                 SUB    ah, ah                       ; UNKNOWN
03FF2A  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03FF2D  8A 87 81 88           MOV    al, byte ptr [bx - 0x777f]   ; UNKNOWN
03FF31  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03FF34  8B C6                 MOV    ax, si                       ; UNKNOWN
03FF36  0E                    PUSH   cs                           ; UNKNOWN
03FF37  E8 3E FC              CALL   0x3fb78                      ; UNKNOWN
03FF3A  8B F8                 MOV    di, ax                       ; UNKNOWN
03FF3C  3B FE                 CMP    di, si                       ; UNKNOWN
03FF3E  75 08                 JNE    0x3ff48                      ; UNKNOWN
03FF40  8B C6                 MOV    ax, si                       ; UNKNOWN
03FF42  0E                    PUSH   cs                           ; UNKNOWN
03FF43  E8 78 FC              CALL   0x3fbbe                      ; UNKNOWN
03FF46  8B F8                 MOV    di, ax                       ; UNKNOWN
03FF48  8B C6                 MOV    ax, si                       ; UNKNOWN
03FF4A  0E                    PUSH   cs                           ; UNKNOWN
03FF4B  E8 5D FE              CALL   0x3fdab                      ; UNKNOWN
03FF4E  8B C7                 MOV    ax, di                       ; UNKNOWN
03FF50  0E                    PUSH   cs                           ; UNKNOWN
03FF51  E8 47 FC              CALL   0x3fb9b                      ; UNKNOWN
03FF54  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
03FF57  89 B7 9A 88           MOV    word ptr [bx - 0x7766], si   ; UNKNOWN
03FF5B  8B 5E FA              MOV    bx, word ptr [bp - 6]        ; UNKNOWN
03FF5E  89 87 98 88           MOV    word ptr [bx - 0x7768], ax   ; UNKNOWN
03FF62  C7 87 9A 88 FF FF     MOV    word ptr [bx - 0x7766], 0xffff ; UNKNOWN
03FF68  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
03FF6B  88 87 80 88           MOV    byte ptr [bx - 0x7780], al   ; UNKNOWN
03FF6F  8A 46 FC              MOV    al, byte ptr [bp - 4]        ; UNKNOWN
03FF72  88 87 81 88           MOV    byte ptr [bx - 0x777f], al   ; UNKNOWN
03FF76  5E                    POP    si                           ; UNKNOWN
03FF77  5F                    POP    di                           ; UNKNOWN
03FF78  C9                    LEAVE                               ; UNKNOWN
03FF79  CB                    RETF                                ; UNKNOWN
