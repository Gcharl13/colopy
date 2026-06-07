; ============================================================================
; func_028154_unknown
; Region   : load_image
; Bytes    : file 0x028154..0x028195  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

028154  C8 16 00 00           ENTER  0x16, 0                      ; UNKNOWN
028158  52                    PUSH   dx                           ; UNKNOWN
028159  50                    PUSH   ax                           ; UNKNOWN
02815A  53                    PUSH   bx                           ; UNKNOWN
02815B  57                    PUSH   di                           ; UNKNOWN
02815C  56                    PUSH   si                           ; UNKNOWN
02815D  6A 0A                 PUSH   0xa                          ; UNKNOWN
02815F  8D 4E EC              LEA    cx, [bp - 0x14]              ; UNKNOWN
028162  51                    PUSH   cx                           ; UNKNOWN
028163  52                    PUSH   dx                           ; UNKNOWN
028164  8B F0                 MOV    si, ax                       ; UNKNOWN
028166  8B FB                 MOV    di, bx                       ; UNKNOWN
028168  9A 8A 08 65 5F        LCALL  0x5f65, 0x88a                ; UNKNOWN
02816D  83 C4 06              ADD    sp, 6                        ; UNKNOWN
028170  6A 05                 PUSH   5                            ; UNKNOWN
028172  8B C6                 MOV    ax, si                       ; UNKNOWN
028174  8B DF                 MOV    bx, di                       ; UNKNOWN
028176  8D 56 EC              LEA    dx, [bp - 0x14]              ; UNKNOWN
028179  0E                    PUSH   cs                           ; UNKNOWN
02817A  E8 8C FF              CALL   0x28109                      ; UNKNOWN
02817D  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
028180  68 DA 3E              PUSH   0x3eda                       ; UNKNOWN
028183  9A 86 08 65 5F        LCALL  0x5f65, 0x886                ; UNKNOWN
028188  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02818B  A3 3E 3F              MOV    word ptr [0x3f3e], ax        ; UNKNOWN
02818E  8B 46 EA              MOV    ax, word ptr [bp - 0x16]     ; UNKNOWN
028191  5E                    POP    si                           ; UNKNOWN
028192  5F                    POP    di                           ; UNKNOWN
028193  C9                    LEAVE                               ; UNKNOWN
028194  CB                    RETF                                ; UNKNOWN
