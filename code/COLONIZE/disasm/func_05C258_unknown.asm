; ============================================================================
; func_05C258_unknown
; Region   : load_image
; Bytes    : file 0x05C258..0x05C26B  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C258  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
05C25C  56                    PUSH   si                           ; UNKNOWN
05C25D  A0 10 3E              MOV    al, byte ptr [0x3e10]        ; UNKNOWN
05C260  38 06 EB CD           CMP    byte ptr [0xcdeb], al        ; UNKNOWN
05C264  75 05                 JNE    0x5c26b                      ; UNKNOWN
05C266  2B C0                 SUB    ax, ax                       ; UNKNOWN
05C268  5E                    POP    si                           ; UNKNOWN
05C269  C9                    LEAVE                               ; UNKNOWN
05C26A  CB                    RETF                                ; UNKNOWN
