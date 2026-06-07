; ============================================================================
; func_065553_unknown
; Region   : load_image
; Bytes    : file 0x065553..0x065596  (67 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065553  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
065557  33 DB                 XOR    bx, bx                       ; UNKNOWN
065559  83 3E 94 CE 00        CMP    word ptr [0xce94], 0         ; UNKNOWN
06555E  74 0C                 JE     0x6556c                      ; UNKNOWN
065560  8B 0E 98 CE           MOV    cx, word ptr [0xce98]        ; UNKNOWN
065564  8B 16 9A CE           MOV    dx, word ptr [0xce9a]        ; UNKNOWN
065568  33 DB                 XOR    bx, bx                       ; UNKNOWN
06556A  51                    PUSH   cx                           ; UNKNOWN
06556B  52                    PUSH   dx                           ; UNKNOWN
06556C  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
065571  74 08                 JE     0x6557b                      ; UNKNOWN
065573  B8 03 00              MOV    ax, 3                        ; UNKNOWN
065576  CD 33                 INT    0x33                         ; UNKNOWN
065578  E8 B8 FF              CALL   0x65533                      ; UNKNOWN
06557B  83 3E 94 CE 00        CMP    word ptr [0xce94], 0         ; UNKNOWN
065580  74 02                 JE     0x65584                      ; UNKNOWN
065582  5A                    POP    dx                           ; UNKNOWN
065583  59                    POP    cx                           ; UNKNOWN
065584  53                    PUSH   bx                           ; UNKNOWN
065585  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
065588  89 0F                 MOV    word ptr [bx], cx            ; UNKNOWN
06558A  8B 5E 08              MOV    bx, word ptr [bp + 8]        ; UNKNOWN
06558D  89 17                 MOV    word ptr [bx], dx            ; UNKNOWN
06558F  58                    POP    ax                           ; UNKNOWN
065590  0B 06 96 CE           OR     ax, word ptr [0xce96]        ; UNKNOWN
065594  C9                    LEAVE                               ; UNKNOWN
065595  CB                    RETF                                ; UNKNOWN
