; ============================================================================
; func_043D8F_unknown
; Region   : load_image
; Bytes    : file 0x043D8F..0x043DF5  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

043D8F  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
043D93  50                    PUSH   ax                           ; UNKNOWN
043D94  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
043D99  39 16 34 0B           CMP    word ptr [0xb34], dx         ; UNKNOWN
043D9D  7F 51                 JG     0x43df0                      ; UNKNOWN
043D9F  A1 94 82              MOV    ax, word ptr [0x8294]        ; UNKNOWN
043DA2  F7 D8                 NEG    ax                           ; UNKNOWN
043DA4  50                    PUSH   ax                           ; UNKNOWN
043DA5  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
043DA8  E8 AB FF              CALL   0x43d56                      ; UNKNOWN
043DAB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043DAE  0B C0                 OR     ax, ax                       ; UNKNOWN
043DB0  74 04                 JE     0x43db6                      ; UNKNOWN
043DB2  83 46 FE 08           ADD    word ptr [bp - 2], 8         ; UNKNOWN
043DB6  FF 36 94 82           PUSH   word ptr [0x8294]            ; UNKNOWN
043DBA  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
043DBD  E8 96 FF              CALL   0x43d56                      ; UNKNOWN
043DC0  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043DC3  0B C0                 OR     ax, ax                       ; UNKNOWN
043DC5  74 04                 JE     0x43dcb                      ; UNKNOWN
043DC7  83 46 FE 04           ADD    word ptr [bp - 2], 4         ; UNKNOWN
043DCB  6A FF                 PUSH   -1                           ; UNKNOWN
043DCD  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
043DD0  E8 83 FF              CALL   0x43d56                      ; UNKNOWN
043DD3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043DD6  0B C0                 OR     ax, ax                       ; UNKNOWN
043DD8  74 04                 JE     0x43dde                      ; UNKNOWN
043DDA  83 46 FE 02           ADD    word ptr [bp - 2], 2         ; UNKNOWN
043DDE  6A 01                 PUSH   1                            ; UNKNOWN
043DE0  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
043DE3  E8 70 FF              CALL   0x43d56                      ; UNKNOWN
043DE6  83 C4 04              ADD    sp, 4                        ; UNKNOWN
043DE9  0B C0                 OR     ax, ax                       ; UNKNOWN
043DEB  74 03                 JE     0x43df0                      ; UNKNOWN
043DED  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
043DF0  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
043DF3  C9                    LEAVE                               ; UNKNOWN
043DF4  C3                    RET                                 ; UNKNOWN
