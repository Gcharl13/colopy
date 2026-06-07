; ============================================================================
; func_069F48_unknown
; Region   : load_image
; Bytes    : file 0x069F48..0x069FDF  (151 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069F48  55                    PUSH   bp                           ; UNKNOWN
069F49  8B EC                 MOV    bp, sp                       ; UNKNOWN
069F4B  56                    PUSH   si                           ; UNKNOWN
069F4C  57                    PUSH   di                           ; UNKNOWN
069F4D  8B 76 08              MOV    si, word ptr [bp + 8]        ; UNKNOWN
069F50  8A 44 06              MOV    al, byte ptr [si + 6]        ; UNKNOWN
069F53  A8 82                 TEST   al, 0x82                     ; UNKNOWN
069F55  74 69                 JE     0x69fc0                      ; UNKNOWN
069F57  A8 40                 TEST   al, 0x40                     ; UNKNOWN
069F59  75 65                 JNE    0x69fc0                      ; UNKNOWN
069F5B  C7 44 02 00 00        MOV    word ptr [si + 2], 0         ; UNKNOWN
069F60  A8 01                 TEST   al, 1                        ; UNKNOWN
069F62  74 0B                 JE     0x69f6f                      ; UNKNOWN
069F64  A8 10                 TEST   al, 0x10                     ; UNKNOWN
069F66  74 58                 JE     0x69fc0                      ; UNKNOWN
069F68  8B 4C 04              MOV    cx, word ptr [si + 4]        ; UNKNOWN
069F6B  89 0C                 MOV    word ptr [si], cx            ; UNKNOWN
069F6D  24 FE                 AND    al, 0xfe                     ; UNKNOWN
069F6F  0C 02                 OR     al, 2                        ; UNKNOWN
069F71  24 EF                 AND    al, 0xef                     ; UNKNOWN
069F73  88 44 06              MOV    byte ptr [si + 6], al        ; UNKNOWN
069F76  8B FE                 MOV    di, si                       ; UNKNOWN
069F78  81 EF 78 12           SUB    di, 0x1278                   ; UNKNOWN
069F7C  81 C7 18 13           ADD    di, 0x1318                   ; UNKNOWN
069F80  33 DB                 XOR    bx, bx                       ; UNKNOWN
069F82  8A 5C 07              MOV    bl, byte ptr [si + 7]        ; UNKNOWN
069F85  A8 08                 TEST   al, 8                        ; UNKNOWN
069F87  75 4D                 JNE    0x69fd6                      ; UNKNOWN
069F89  A8 04                 TEST   al, 4                        ; UNKNOWN
069F8B  75 1E                 JNE    0x69fab                      ; UNKNOWN
069F8D  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
069F90  75 44                 JNE    0x69fd6                      ; UNKNOWN
069F92  81 FE 80 12           CMP    si, 0x1280                   ; UNKNOWN
069F96  74 0C                 JE     0x69fa4                      ; UNKNOWN
069F98  81 FE 88 12           CMP    si, 0x1288                   ; UNKNOWN
069F9C  74 06                 JE     0x69fa4                      ; UNKNOWN
069F9E  81 FE 98 12           CMP    si, 0x1298                   ; UNKNOWN
069FA2  75 25                 JNE    0x69fc9                      ; UNKNOWN
069FA4  F6 87 47 12 40        TEST   byte ptr [bx + 0x1247], 0x40 ; UNKNOWN
069FA9  74 1E                 JE     0x69fc9                      ; UNKNOWN
069FAB  B9 01 00              MOV    cx, 1                        ; UNKNOWN
069FAE  51                    PUSH   cx                           ; UNKNOWN
069FAF  8D 7E 06              LEA    di, [bp + 6]                 ; UNKNOWN
069FB2  57                    PUSH   di                           ; UNKNOWN
069FB3  53                    PUSH   bx                           ; UNKNOWN
069FB4  0E                    PUSH   cs                           ; UNKNOWN
069FB5  E8 DA 08              CALL   0x6a892                      ; UNKNOWN
069FB8  83 C4 06              ADD    sp, 6                        ; UNKNOWN
069FBB  B9 01 00              MOV    cx, 1                        ; UNKNOWN
069FBE  EB 3F                 JMP    0x69fff                      ; UNKNOWN
069FC0  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
069FC3  80 4C 06 20           OR     byte ptr [si + 6], 0x20      ; UNKNOWN
069FC7  EB 5E                 JMP    0x6a027                      ; UNKNOWN
069FC9  53                    PUSH   bx                           ; UNKNOWN
069FCA  56                    PUSH   si                           ; UNKNOWN
069FCB  E8 16 10              CALL   0x6afe4                      ; UNKNOWN
069FCE  5B                    POP    bx                           ; UNKNOWN
069FCF  5B                    POP    bx                           ; UNKNOWN
069FD0  F6 44 06 08           TEST   byte ptr [si + 6], 8         ; UNKNOWN
069FD4  74 D5                 JE     0x69fab                      ; UNKNOWN
069FD6  8B 0C                 MOV    cx, word ptr [si]            ; UNKNOWN
069FD8  8B 54 04              MOV    dx, word ptr [si + 4]        ; UNKNOWN
069FDB  2B CA                 SUB    cx, dx                       ; UNKNOWN
069FDD  42                    INC    dx                           ; UNKNOWN
069FDE  89                    DB     0x89                         ; UNKNOWN (raw)
