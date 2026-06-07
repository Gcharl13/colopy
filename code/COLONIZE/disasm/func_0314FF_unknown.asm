; ============================================================================
; func_0314FF_unknown
; Region   : load_image
; Bytes    : file 0x0314FF..0x031550  (81 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0314FF  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
031503  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
031508  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
03150C  74 3D                 JE     0x3154b                      ; UNKNOWN
03150E  83 7E 06 05           CMP    word ptr [bp + 6], 5         ; UNKNOWN
031512  74 37                 JE     0x3154b                      ; UNKNOWN
031514  83 7E 06 08           CMP    word ptr [bp + 6], 8         ; UNKNOWN
031518  74 31                 JE     0x3154b                      ; UNKNOWN
03151A  83 7E 06 0E           CMP    word ptr [bp + 6], 0xe       ; UNKNOWN
03151E  74 2B                 JE     0x3154b                      ; UNKNOWN
031520  83 7E 06 0F           CMP    word ptr [bp + 6], 0xf       ; UNKNOWN
031524  74 25                 JE     0x3154b                      ; UNKNOWN
031526  83 7E 06 06           CMP    word ptr [bp + 6], 6         ; UNKNOWN
03152A  75 1A                 JNE    0x31546                      ; UNKNOWN
03152C  6A 03                 PUSH   3                            ; UNKNOWN
03152E  9A 88 03 5F 24        LCALL  0x245f, 0x388                ; UNKNOWN
031533  83 C4 02              ADD    sp, 2                        ; UNKNOWN
031536  0B C0                 OR     ax, ax                       ; UNKNOWN
031538  75 11                 JNE    0x3154b                      ; UNKNOWN
03153A  39 06 A4 73           CMP    word ptr [0x73a4], ax        ; UNKNOWN
03153E  75 0B                 JNE    0x3154b                      ; UNKNOWN
031540  39 06 A6 73           CMP    word ptr [0x73a6], ax        ; UNKNOWN
031544  75 05                 JNE    0x3154b                      ; UNKNOWN
031546  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
03154B  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
03154E  C9                    LEAVE                               ; UNKNOWN
03154F  CB                    RETF                                ; UNKNOWN
