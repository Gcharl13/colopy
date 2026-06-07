; ============================================================================
; func_02D321_unknown
; Region   : load_image
; Bytes    : file 0x02D321..0x02D34F  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02D321  55                    PUSH   bp                           ; UNKNOWN
02D322  8B EC                 MOV    bp, sp                       ; UNKNOWN
02D324  57                    PUSH   di                           ; UNKNOWN
02D325  56                    PUSH   si                           ; UNKNOWN
02D326  8B 76 06              MOV    si, word ptr [bp + 6]        ; UNKNOWN
02D329  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
02D32C  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
02D32F  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
02D332  50                    PUSH   ax                           ; UNKNOWN
02D333  56                    PUSH   si                           ; UNKNOWN
02D334  8B F8                 MOV    di, ax                       ; UNKNOWN
02D336  0E                    PUSH   cs                           ; UNKNOWN
02D337  E8 BD FF              CALL   0x2d2f7                      ; UNKNOWN
02D33A  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D33D  1E                    PUSH   ds                           ; UNKNOWN
02D33E  68 38 1E              PUSH   0x1e38                       ; UNKNOWN
02D341  57                    PUSH   di                           ; UNKNOWN
02D342  56                    PUSH   si                           ; UNKNOWN
02D343  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
02D348  83 C4 08              ADD    sp, 8                        ; UNKNOWN
02D34B  5E                    POP    si                           ; UNKNOWN
02D34C  5F                    POP    di                           ; UNKNOWN
02D34D  C9                    LEAVE                               ; UNKNOWN
02D34E  CB                    RETF                                ; UNKNOWN
