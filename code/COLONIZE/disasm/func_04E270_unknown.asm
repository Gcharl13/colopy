; ============================================================================
; func_04E270_unknown
; Region   : load_image
; Bytes    : file 0x04E270..0x04E29E  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04E270  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04E274  56                    PUSH   si                           ; UNKNOWN
04E275  C6 46 FF 00           MOV    byte ptr [bp - 1], 0         ; UNKNOWN
04E279  0E                    PUSH   cs                           ; UNKNOWN
04E27A  E8 79 FF              CALL   0x4e1f6                      ; UNKNOWN
04E27D  BE 92 C6              MOV    si, 0xc692                   ; UNKNOWN
04E280  80 3C 30              CMP    byte ptr [si], 0x30          ; UNKNOWN
04E283  74 05                 JE     0x4e28a                      ; UNKNOWN
04E285  80 3C 31              CMP    byte ptr [si], 0x31          ; UNKNOWN
04E288  75 0E                 JNE    0x4e298                      ; UNKNOWN
04E28A  D0 66 FF              SHL    byte ptr [bp - 1], 1         ; UNKNOWN
04E28D  80 3C 31              CMP    byte ptr [si], 0x31          ; UNKNOWN
04E290  75 03                 JNE    0x4e295                      ; UNKNOWN
04E292  FE 46 FF              INC    byte ptr [bp - 1]            ; UNKNOWN
04E295  46                    INC    si                           ; UNKNOWN
04E296  EB E8                 JMP    0x4e280                      ; UNKNOWN
04E298  8A 46 FF              MOV    al, byte ptr [bp - 1]        ; UNKNOWN
04E29B  5E                    POP    si                           ; UNKNOWN
04E29C  C9                    LEAVE                               ; UNKNOWN
04E29D  CB                    RETF                                ; UNKNOWN
