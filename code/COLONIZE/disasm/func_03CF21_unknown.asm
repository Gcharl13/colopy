; ============================================================================
; func_03CF21_unknown
; Region   : load_image
; Bytes    : file 0x03CF21..0x03CF61  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03CF21  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03CF25  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
03CF2A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CF2D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CF30  0E                    PUSH   cs                           ; UNKNOWN
03CF31  E8 5E FD              CALL   0x3cc92                      ; UNKNOWN
03CF34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CF37  0B C0                 OR     ax, ax                       ; UNKNOWN
03CF39  74 21                 JE     0x3cf5c                      ; UNKNOWN
03CF3B  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CF3E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CF41  9A 71 00 3C 22        LCALL  0x223c, 0x71                 ; UNKNOWN
03CF46  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03CF49  0B C0                 OR     ax, ax                       ; UNKNOWN
03CF4B  75 0F                 JNE    0x3cf5c                      ; UNKNOWN
03CF4D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03CF50  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03CF53  0E                    PUSH   cs                           ; UNKNOWN
03CF54  E8 F5 FE              CALL   0x3ce4c                      ; UNKNOWN
03CF57  2A E4                 SUB    ah, ah                       ; UNKNOWN
03CF59  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03CF5C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03CF5F  C9                    LEAVE                               ; UNKNOWN
03CF60  CB                    RETF                                ; UNKNOWN
