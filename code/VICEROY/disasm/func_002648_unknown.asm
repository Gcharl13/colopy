; ============================================================================
; func_002648_unknown
; Region   : load_image
; Bytes    : file 0x002648..0x002668  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002648  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
00264C  6A 0A                 PUSH   0xa                          ; UNKNOWN
00264E  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
002651  50                    PUSH   ax                           ; UNKNOWN
002652  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
002655  9A FA 08 1D 0D        LCALL  0xd1d, 0x8fa                 ; UNKNOWN
00265A  83 C4 06              ADD    sp, 6                        ; UNKNOWN
00265D  8D 46 EC              LEA    ax, [bp - 0x14]              ; UNKNOWN
002660  16                    PUSH   ss                           ; UNKNOWN
002661  50                    PUSH   ax                           ; UNKNOWN
002662  0E                    PUSH   cs                           ; UNKNOWN
002663  E8 A8 FF              CALL   0x260e                       ; UNKNOWN
002666  C9                    LEAVE                               ; UNKNOWN
002667  CB                    RETF                                ; UNKNOWN
