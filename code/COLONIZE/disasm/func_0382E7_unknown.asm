; ============================================================================
; func_0382E7_unknown
; Region   : load_image
; Bytes    : file 0x0382E7..0x03831D  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0382E7  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0382EB  A0 F4 0A              MOV    al, byte ptr [0xaf4]         ; UNKNOWN
0382EE  88 46 FE              MOV    byte ptr [bp - 2], al        ; UNKNOWN
0382F1  C6 06 F4 0A 00        MOV    byte ptr [0xaf4], 0          ; UNKNOWN
0382F6  0E                    PUSH   cs                           ; UNKNOWN
0382F7  E8 2C F9              CALL   0x37c26                      ; UNKNOWN
0382FA  80 3E F4 0A 00        CMP    byte ptr [0xaf4], 0          ; UNKNOWN
0382FF  75 0E                 JNE    0x3830f                      ; UNKNOWN
038301  80 7E FE 00           CMP    byte ptr [bp - 2], 0         ; UNKNOWN
038305  74 08                 JE     0x3830f                      ; UNKNOWN
038307  6A 01                 PUSH   1                            ; UNKNOWN
038309  E8 71 B6              CALL   0x3397d                      ; UNKNOWN
03830C  83 C4 02              ADD    sp, 2                        ; UNKNOWN
03830F  80 3E F4 0A 00        CMP    byte ptr [0xaf4], 0          ; UNKNOWN
038314  75 05                 JNE    0x3831b                      ; UNKNOWN
038316  C6 06 F3 0A FE        MOV    byte ptr [0xaf3], 0xfe       ; UNKNOWN
03831B  C9                    LEAVE                               ; UNKNOWN
03831C  C3                    RET                                 ; UNKNOWN
