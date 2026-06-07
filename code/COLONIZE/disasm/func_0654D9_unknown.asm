; ============================================================================
; func_0654D9_unknown
; Region   : load_image
; Bytes    : file 0x0654D9..0x06552E  (85 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0654D9  C8 00 00 00           ENTER  0, 0                         ; UNKNOWN
0654DD  8B C1                 MOV    ax, cx                       ; UNKNOWN
0654DF  8B 4E 06              MOV    cx, word ptr [bp + 6]        ; UNKNOWN
0654E2  D1 E1                 SHL    cx, 1                        ; UNKNOWN
0654E4  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
0654E7  50                    PUSH   ax                           ; UNKNOWN
0654E8  51                    PUSH   cx                           ; UNKNOWN
0654E9  52                    PUSH   dx                           ; UNKNOWN
0654EA  83 3E 94 CE 00        CMP    word ptr [0xce94], 0         ; UNKNOWN
0654EF  75 07                 JNE    0x654f8                      ; UNKNOWN
0654F1  9A 4C 00 1E 5C        LCALL  0x5c1e, 0x4c                 ; UNKNOWN
0654F6  EB 05                 JMP    0x654fd                      ; UNKNOWN
0654F8  9A B9 02 1E 5C        LCALL  0x5c1e, 0x2b9                ; UNKNOWN
0654FD  5A                    POP    dx                           ; UNKNOWN
0654FE  59                    POP    cx                           ; UNKNOWN
0654FF  58                    POP    ax                           ; UNKNOWN
065500  A3 98 CE              MOV    word ptr [0xce98], ax        ; UNKNOWN
065503  89 16 9A CE           MOV    word ptr [0xce9a], dx        ; UNKNOWN
065507  83 3E 92 CE 00        CMP    word ptr [0xce92], 0         ; UNKNOWN
06550C  74 10                 JE     0x6551e                      ; UNKNOWN
06550E  51                    PUSH   cx                           ; UNKNOWN
06550F  52                    PUSH   dx                           ; UNKNOWN
065510  B8 04 00              MOV    ax, 4                        ; UNKNOWN
065513  CD 33                 INT    0x33                         ; UNKNOWN
065515  5A                    POP    dx                           ; UNKNOWN
065516  59                    POP    cx                           ; UNKNOWN
065517  83 3E 94 CE 00        CMP    word ptr [0xce94], 0         ; UNKNOWN
06551C  75 07                 JNE    0x65525                      ; UNKNOWN
06551E  9A 07 00 1E 5C        LCALL  0x5c1e, 7                    ; UNKNOWN
065523  EB 0C                 JMP    0x65531                      ; UNKNOWN
065525  FA                    CLI                                 ; UNKNOWN
065526  9A F4 01 1E 5C        LCALL  0x5c1e, 0x1f4                ; UNKNOWN
06552B  FB                    STI                                 ; UNKNOWN
06552C  9A                    DB     0x9A                         ; UNKNOWN (raw)
06552D  CB                    DB     0xCB                         ; UNKNOWN (raw)
