; ============================================================================
; func_068FBE_unknown
; Region   : load_image
; Bytes    : file 0x068FBE..0x069011  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068FBE  55                    PUSH   bp                           ; UNKNOWN
068FBF  8B EC                 MOV    bp, sp                       ; UNKNOWN
068FC1  83 EC 02              SUB    sp, 2                        ; UNKNOWN
068FC4  57                    PUSH   di                           ; UNKNOWN
068FC5  56                    PUSH   si                           ; UNKNOWN
068FC6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
068FC9  9A D2 07 65 5F        LCALL  0x5f65, 0x7d2                ; UNKNOWN
068FCE  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068FD1  8B F8                 MOV    di, ax                       ; UNKNOWN
068FD3  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
068FD6  E8 67 11              CALL   0x6a140                      ; UNKNOWN
068FD9  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068FDC  8B F0                 MOV    si, ax                       ; UNKNOWN
068FDE  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
068FE1  57                    PUSH   di                           ; UNKNOWN
068FE2  B8 01 00              MOV    ax, 1                        ; UNKNOWN
068FE5  50                    PUSH   ax                           ; UNKNOWN
068FE6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
068FE9  9A D4 04 65 5F        LCALL  0x5f65, 0x4d4                ; UNKNOWN
068FEE  83 C4 08              ADD    sp, 8                        ; UNKNOWN
068FF1  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
068FF4  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
068FF7  56                    PUSH   si                           ; UNKNOWN
068FF8  E8 B8 11              CALL   0x6a1b3                      ; UNKNOWN
068FFB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
068FFE  39 7E FE              CMP    word ptr [bp - 2], di        ; UNKNOWN
069001  75 05                 JNE    0x69008                      ; UNKNOWN
069003  2B C0                 SUB    ax, ax                       ; UNKNOWN
069005  EB 04                 JMP    0x6900b                      ; UNKNOWN
069007  90                    NOP                                 ; UNKNOWN
069008  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
06900B  5E                    POP    si                           ; UNKNOWN
06900C  5F                    POP    di                           ; UNKNOWN
06900D  8B E5                 MOV    sp, bp                       ; UNKNOWN
06900F  5D                    POP    bp                           ; UNKNOWN
069010  CB                    RETF                                ; UNKNOWN
