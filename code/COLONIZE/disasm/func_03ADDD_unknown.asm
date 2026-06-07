; ============================================================================
; func_03ADDD_unknown
; Region   : load_image
; Bytes    : file 0x03ADDD..0x03AE0F  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03ADDD  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
03ADE1  56                    PUSH   si                           ; UNKNOWN
03ADE2  6A 00                 PUSH   0                            ; UNKNOWN
03ADE4  6A 01                 PUSH   1                            ; UNKNOWN
03ADE6  6A FF                 PUSH   -1                           ; UNKNOWN
03ADE8  A1 0A 3E              MOV    ax, word ptr [0x3e0a]        ; UNKNOWN
03ADEB  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
03ADEE  50                    PUSH   ax                           ; UNKNOWN
03ADEF  9A C7 01 2A 1F        LCALL  0x1f2a, 0x1c7                ; UNKNOWN
03ADF4  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03ADF7  3D E7 03              CMP    ax, 0x3e7                    ; UNKNOWN
03ADFA  75 21                 JNE    0x3ae1d                      ; UNKNOWN
03ADFC  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
03AE01  74 0C                 JE     0x3ae0f                      ; UNKNOWN
03AE03  8D 1E 53 23           LEA    bx, [0x2353]                 ; UNKNOWN
03AE07  9A E6 36 97 1B        LCALL  0x1b97, 0x36e6               ; UNKNOWN
03AE0C  5E                    POP    si                           ; UNKNOWN
03AE0D  C9                    LEAVE                               ; UNKNOWN
03AE0E  CB                    RETF                                ; UNKNOWN
