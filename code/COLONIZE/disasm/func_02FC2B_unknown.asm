; ============================================================================
; func_02FC2B_unknown
; Region   : load_image
; Bytes    : file 0x02FC2B..0x02FC79  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02FC2B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02FC2F  56                    PUSH   si                           ; UNKNOWN
02FC30  80 3E E3 0A 00        CMP    byte ptr [0xae3], 0          ; UNKNOWN
02FC35  75 40                 JNE    0x2fc77                      ; UNKNOWN
02FC37  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0         ; UNKNOWN
02FC3C  EB 2C                 JMP    0x2fc6a                      ; UNKNOWN
02FC3E  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02FC41  83 7E FE 05           CMP    word ptr [bp - 2], 5         ; UNKNOWN
02FC45  7D 20                 JGE    0x2fc67                      ; UNKNOWN
02FC47  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
02FC4A  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
02FC4D  0E                    PUSH   cs                           ; UNKNOWN
02FC4E  E8 40 FD              CALL   0x2f991                      ; UNKNOWN
02FC51  83 C4 04              ADD    sp, 4                        ; UNKNOWN
02FC54  8B 76 FE              MOV    si, word ptr [bp - 2]        ; UNKNOWN
02FC57  8B CE                 MOV    cx, si                       ; UNKNOWN
02FC59  C1 E6 02              SHL    si, 2                        ; UNKNOWN
02FC5C  03 F1                 ADD    si, cx                       ; UNKNOWN
02FC5E  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
02FC61  88 80 B0 73           MOV    byte ptr [bx + si + 0x73b0], al ; UNKNOWN
02FC65  EB D7                 JMP    0x2fc3e                      ; UNKNOWN
02FC67  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
02FC6A  83 7E FC 05           CMP    word ptr [bp - 4], 5         ; UNKNOWN
02FC6E  7D 07                 JGE    0x2fc77                      ; UNKNOWN
02FC70  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02FC75  EB CA                 JMP    0x2fc41                      ; UNKNOWN
02FC77  C6                    DB     0xC6                         ; UNKNOWN (raw)
02FC78  06                    DB     0x06                         ; UNKNOWN (raw)
