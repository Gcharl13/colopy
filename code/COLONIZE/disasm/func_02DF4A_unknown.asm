; ============================================================================
; func_02DF4A_unknown
; Region   : load_image
; Bytes    : file 0x02DF4A..0x02DF9B  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DF4A  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02DF4E  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
02DF51  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DF54  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
02DF57  A1 40 73              MOV    ax, word ptr [0x7340]        ; UNKNOWN
02DF5A  EB 33                 JMP    0x2df8f                      ; UNKNOWN
02DF5C  83 7E FA 00           CMP    word ptr [bp - 6], 0         ; UNKNOWN
02DF60  7D 34                 JGE    0x2df96                      ; UNKNOWN
02DF62  50                    PUSH   ax                           ; UNKNOWN
02DF63  0E                    PUSH   cs                           ; UNKNOWN
02DF64  E8 5D FF              CALL   0x2dec4                      ; UNKNOWN
02DF67  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02DF6A  0B C0                 OR     ax, ax                       ; UNKNOWN
02DF6C  74 19                 JE     0x2df87                      ; UNKNOWN
02DF6E  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02DF71  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
02DF74  39 46 FE              CMP    word ptr [bp - 2], ax        ; UNKNOWN
02DF77  75 0E                 JNE    0x2df87                      ; UNKNOWN
02DF79  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
02DF7D  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
02DF80  98                    CWDE                                ; UNKNOWN
02DF81  03 46 FC              ADD    ax, word ptr [bp - 4]        ; UNKNOWN
02DF84  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02DF87  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02DF8A  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
02DF8F  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
02DF92  0B C0                 OR     ax, ax                       ; UNKNOWN
02DF94  7D C6                 JGE    0x2df5c                      ; UNKNOWN
02DF96  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02DF99  C9                    LEAVE                               ; UNKNOWN
02DF9A  CB                    RETF                                ; UNKNOWN
