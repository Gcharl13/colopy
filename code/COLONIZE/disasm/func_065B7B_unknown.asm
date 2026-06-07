; ============================================================================
; func_065B7B_unknown
; Region   : load_image
; Bytes    : file 0x065B7B..0x065BB7  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

065B7B  55                    PUSH   bp                           ; UNKNOWN
065B7C  8B EC                 MOV    bp, sp                       ; UNKNOWN
065B7E  53                    PUSH   bx                           ; UNKNOWN
065B7F  50                    PUSH   ax                           ; UNKNOWN
065B80  57                    PUSH   di                           ; UNKNOWN
065B81  56                    PUSH   si                           ; UNKNOWN
065B82  8B FA                 MOV    di, dx                       ; UNKNOWN
065B84  9A B9 02 1E 5C        LCALL  0x5c1e, 0x2b9                ; UNKNOWN
065B89  9A A4 05 1E 5C        LCALL  0x5c1e, 0x5a4                ; UNKNOWN
065B8E  8B F0                 MOV    si, ax                       ; UNKNOWN
065B90  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
065B93  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
065B96  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
065B99  FF 76 FE              PUSH   word ptr [bp - 2]            ; UNKNOWN
065B9C  57                    PUSH   di                           ; UNKNOWN
065B9D  FF 76 FC              PUSH   word ptr [bp - 4]            ; UNKNOWN
065BA0  1E                    PUSH   ds                           ; UNKNOWN
065BA1  68 82 CE              PUSH   0xce82                       ; UNKNOWN
065BA4  9A 27 00 4C 5E        LCALL  0x5e4c, 0x27                 ; UNKNOWN
065BA9  83 C4 10              ADD    sp, 0x10                     ; UNKNOWN
065BAC  0B F6                 OR     si, si                       ; UNKNOWN
065BAE  74 05                 JE     0x65bb5                      ; UNKNOWN
065BB0  9A DE 06 1E 5C        LCALL  0x5c1e, 0x6de                ; UNKNOWN
065BB5  9A                    DB     0x9A                         ; UNKNOWN (raw)
065BB6  CB                    DB     0xCB                         ; UNKNOWN (raw)
