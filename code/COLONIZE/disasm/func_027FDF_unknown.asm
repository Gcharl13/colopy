; ============================================================================
; func_027FDF_unknown
; Region   : load_image
; Bytes    : file 0x027FDF..0x028011  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

027FDF  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
027FE3  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
027FE8  0E                    PUSH   cs                           ; UNKNOWN
027FE9  E8 DE FB              CALL   0x27bca                      ; UNKNOWN
027FEC  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
027FEF  89 56 FC              MOV    word ptr [bp - 4], dx        ; UNKNOWN
027FF2  0B D0                 OR     dx, ax                       ; UNKNOWN
027FF4  74 16                 JE     0x2800c                      ; UNKNOWN
027FF6  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
027FF9  50                    PUSH   ax                           ; UNKNOWN
027FFA  0E                    PUSH   cs                           ; UNKNOWN
027FFB  E8 BC EE              CALL   0x26eba                      ; UNKNOWN
027FFE  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
028001  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
028004  FF 76 FA              PUSH   word ptr [bp - 6]            ; UNKNOWN
028007  9A 06 01 4F 00        LCALL  0x4f, 0x106                  ; UNKNOWN
02800C  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02800F  C9                    LEAVE                               ; UNKNOWN
028010  CB                    RETF                                ; UNKNOWN
