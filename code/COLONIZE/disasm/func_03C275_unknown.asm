; ============================================================================
; func_03C275_unknown
; Region   : load_image
; Bytes    : file 0x03C275..0x03C2A2  (45 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C275  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03C279  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1         ; UNKNOWN
03C27E  A1 DA 79              MOV    ax, word ptr [0x79da]        ; UNKNOWN
03C281  83 E8 0D              SUB    ax, 0xd                      ; UNKNOWN
03C284  75 3B                 JNE    0x3c2c1                      ; UNKNOWN
03C286  FF 36 8C 82           PUSH   word ptr [0x828c]            ; UNKNOWN
03C28A  FF 36 8E 82           PUSH   word ptr [0x828e]            ; UNKNOWN
03C28E  9A 61 0A 5F 24        LCALL  0x245f, 0xa61                ; UNKNOWN
03C293  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03C296  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
03C299  0B C0                 OR     ax, ax                       ; UNKNOWN
03C29B  7C 29                 JL     0x3c2c6                      ; UNKNOWN
03C29D  69 D8 CA 00           IMUL   bx, ax, 0xca                 ; UNKNOWN
03C2A1  A0                    DB     0xA0                         ; UNKNOWN (raw)
